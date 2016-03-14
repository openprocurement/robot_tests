# -*- coding: utf-8 -
from copy import deepcopy
from datetime import timedelta
from dateutil.parser import parse
from dpath.util import new as xpathnew
from iso8601 import parse_date
from json import load
from jsonpath_rw import parse as parse_path
from munch import fromYAML, Munch, munchify
from restkit import request
from robot.errors import ExecutionFailed
from robot.libraries.BuiltIn import BuiltIn
from robot.output import LOGGER
from robot.output.loggerhelper import Message
# These imports are not pointless. Robot's resource and testsuite files
# can access them by simply importing library "service_keywords".
# Please ignore the warning given by Flake8 or other linter.
from .initial_data import (
    create_fake_doc,
    create_fake_sentence,
    test_award_data,
    test_bid_data,
    test_cancel_claim_data,
    test_cancel_tender_data,
    test_change_cancellation_document_field_data,
    test_claim_answer_data,
    test_claim_data,
    test_complaint_answer_data,
    test_complaint_data,
    test_complaint_reply_data,
    test_confirm_data,
    test_escalate_claim_data,
    test_invalid_features_data,
    test_item_data,
    test_lot_complaint_data,
    test_lot_data,
    test_lot_document_data,
    test_lot_question_data,
    test_question_answer_data,
    test_question_data,
    test_supplier_data,
    test_tender_data,
    test_tender_data_limited,
    test_tender_data_meat,
    test_tender_data_multiple_items,
    test_tender_data_multiple_lots,
    test_tender_data_openeu,
    test_tender_data_openua
)
from .local_time import get_now, TZ
import os
from barbecue import chef
import re


def get_current_tzdate():
    return get_now().strftime('%Y-%m-%d %H:%M:%S.%f')


def add_minutes_to_date(date, minutes):
    return (parse_date(date) + timedelta(minutes=int(minutes))).isoformat()


def get_file_contents(path):
    with open(path, 'r') as f:
        return unicode(f.read()) or u''


def compare_date(date1, date2, accuracy):
    date1 = parse(date1)
    date2 = parse(date2)
    if date1.tzinfo is None:
        date1 = TZ.localize(date1)
    if date2.tzinfo is None:
        date2 = TZ.localize(date2)

    delta = (date1 - date2).total_seconds()
    if abs(delta) > accuracy:
        return False
    return True


def log_object_data(data, file_name=None, format="yaml", update=False):
    """Log object data in pretty format (JSON or YAML)

    Two output formats are supported: "yaml" and "json".

    If a file name is specified, the output is written into that file.

    If you would like to get similar output everywhere,
    use the following snippet somewhere in your code
    before actually using Munch. For instance,
    put it into your __init__.py, or, if you use zc.buildout,
    specify it in "initialization" setting of zc.recipe.egg.

    from munch import Munch
    Munch.__str__ = lambda self: Munch.toYAML(self, allow_unicode=True,
                                              default_flow_style=False)
    Munch.__repr__ = Munch.__str__
    """
    if not isinstance(data, Munch):
        data = munchify(data)
    if file_name:
        output_dir = BuiltIn().get_variable_value("${OUTPUT_DIR}")
        file_path = os.path.join(output_dir, file_name + '.' + format)
        if update:
            try:
                with open(file_path, "r+") as file_obj:
                    new_data = data.copy()
                    data = munch_from_object(file_obj.read(), format)
                    data.update(new_data)
                    file_obj.seek(0)
                    file_obj.truncate()
            except IOError as e:
                LOGGER.log_message(Message(e, "INFO"))
                LOGGER.log_message(Message("Nothing to update, "
                                           "creating new file.", "INFO"))
        data_obj = munch_to_object(data, format)
        with open(file_path, "w") as file_obj:
            file_obj.write(data_obj)
    data_obj = munch_to_object(data, format)
    LOGGER.log_message(Message(data_obj.decode('utf-8'), "INFO"))


def munch_from_object(data, format="yaml"):
    if format.lower() == 'json':
        return Munch.fromJSON(data)
    else:
        return Munch.fromYAML(data)


def munch_to_object(data, format="yaml"):
    if format.lower() == 'json':
        return data.toJSON(indent=2)
    else:
        return data.toYAML(allow_unicode=True, default_flow_style=False)


def load_data_from(file_name, mode=None):
    if not os.path.exists(file_name):
        file_name = os.path.join(os.path.dirname(__file__), 'data', file_name)
    with open(file_name) as file_obj:
        if file_name.endswith(".json"):
            file_data = Munch.fromDict(load(file_obj))
        elif file_name.endswith(".yaml"):
            file_data = fromYAML(file_obj)
    if mode == "brokers":
        default = file_data.pop('Default')
        brokers = {}
        for k, v in file_data.iteritems():
            brokers[k] = merge_dicts(default, v)
        return brokers
    else:
        return file_data


def compute_intrs(brokers_data, used_brokers):
    """Compute optimal values for period intervals.

    Notice: This function is maximally effective if ``brokers_data``
    does not contain ``Default`` entry.
    Using `load_data_from` with ``mode='brokers'`` is recommended.
    """
    num_types = (int, long, float)

    def recur(l, r):
        l, r = deepcopy(l), deepcopy(r)
        if isinstance(l, list) and isinstance(r, list) and len(l) == len(r):
            lst = []
            for ll, rr in zip(l, r):
                lst.append(recur(ll, rr))
            return lst
        elif isinstance(l, num_types) and isinstance(r, num_types):
            if l == r:
                return l
            if l > r:
                return l
            if l < r:
                return r
        elif isinstance(l, dict) and isinstance(r, dict):
            for k, v in r.iteritems():
                if k not in l.keys():
                    l[k] = v
                else:
                    l[k] = recur(l[k], v)
            return l
        else:
            raise TypeError("Couldn't recur({0}, {1})".format(
                str(type(l)), str(type(r))))

    intrs = []
    for i in used_brokers:
        intrs.append(brokers_data[i]['intervals'])
    result = intrs.pop(0)
    for i in intrs:
        result = recur(result, i)
    return result


def prepare_test_tender_data(procedure_intervals, mode):
    # Get actual intervals by mode name
    if mode in procedure_intervals:
        intervals = procedure_intervals[mode]
    else:
        intervals = procedure_intervals['default']
    LOGGER.log_message(Message(intervals))

    # Set acceleration value for certain modes
    if mode in ['openua', 'openeu']:
        assert isinstance(intervals['accelerator'], int), \
            "Accelerator should be an 'int', " \
            "not '{}'".format(type(intervals['accelerator']).__name__)
        assert intervals['accelerator'] >= 0, \
            "Accelerator should not be less than 0"
    else:
        assert 'accelerator' not in intervals.keys(), \
               "Accelerator is not available for mode '{0}'".format(mode)

    if mode == 'meat':
        return munchify({'data': test_tender_data_meat(intervals)})
    elif mode == 'multiItem':
        return munchify({'data': test_tender_data_multiple_items(intervals)})
    elif mode == 'multiLot':
        return munchify({'data': test_tender_data_multiple_lots(intervals)})
    elif mode == 'negotiation':
        return munchify({'data': test_tender_data_limited(intervals, 'negotiation')})
    elif mode == 'negotiation.quick':
        return munchify({'data': test_tender_data_limited(intervals, 'negotiation.quick')})
    elif mode == 'openeu':
        return munchify({'data': test_tender_data_openeu(intervals)})
    elif mode == 'openua':
        return munchify({'data': test_tender_data_openua(intervals)})
    elif mode == 'reporting':
        return munchify({'data': test_tender_data_limited(intervals, 'reporting')})
    elif mode == 'single':
        return munchify({'data': test_tender_data(intervals)})
    raise ValueError("Invalid mode for prepare_test_tender_data")


def run_keyword_and_ignore_keyword_definitions(name, *args, **kwargs):
    """This keyword is pretty similar to `Run Keyword And Ignore Error`,
    which, unfortunately, does not suppress the error when you try
    to use it to run a keyword which is not defined.
    As a result, the execution of its parent keyword / test case is aborted.

    How this works:

    This is a simple wrapper for `Run Keyword And Ignore Error`.
    It handles the error mentioned above and additionally provides
    a meaningful error message.
    """
    try:
        status, _ = BuiltIn().run_keyword_and_ignore_error(name, *args, **kwargs)
    except ExecutionFailed as e:
        status, _ = "FAIL", e.message
    return status, _


def set_access_key(tender, access_token):
    tender.access = munchify({"token": access_token})
    return tender


def set_to_object(obj, attribute, value):
    xpathnew(obj, attribute, value, separator='.')
    return obj


def get_from_object(obj, attribute):
    """Gets data from a dictionary using a dotted accessor-string"""
    jsonpath_expr = parse_path(attribute)
    return_list = [i.value for i in jsonpath_expr.find(obj)]
    if return_list:
        return return_list[0]
    else:
        raise AttributeError('Attribute not found: {0}'.format(attribute))


def wait_to_date(date_stamp):
    date = parse(date_stamp)
    LOGGER.log_message(Message("date: {}".format(date.isoformat()), "INFO"))
    now = get_now()
    LOGGER.log_message(Message("now: {}".format(now.isoformat()), "INFO"))
    wait_seconds = (date - now).total_seconds()
    wait_seconds += 2
    if wait_seconds < 0:
        return 0
    return wait_seconds


def merge_dicts(a, b):
    """Merge dicts recursively.

    Origin: https://www.xormedia.com/recursively-merge-dictionaries-in-python/
    """
    if not isinstance(b, dict):
        return b
    result = deepcopy(a)
    for k, v in b.iteritems():
        if k in result and isinstance(result[k], dict):
                result[k] = merge_dicts(result[k], v)
        else:
            result[k] = deepcopy(v)
    return munchify(result)


def create_data_dict(path_to_value=None, value=None):
    data_dict = munchify({'data': {}})
    if isinstance(path_to_value, basestring) and value:
        list_items = re.search('\d+', path_to_value)
        if list_items:
            list_items = list_items.group(0)
            path_to_value = path_to_value.split('[' + list_items + ']')
            path_to_value.insert(1, '.' + list_items)
            set_to_object(data_dict, path_to_value[0], [])
            set_to_object(data_dict, ''.join(path_to_value[:2]), {})
            set_to_object(data_dict, ''.join(path_to_value), value)
        else:
            data_dict = set_to_object(data_dict, path_to_value, value)
    return data_dict


def munch_dict(arg=None, data=False):
    if arg is None:
        arg = {}
    if data:
        arg['data'] = {}
    return munchify(arg)


def get_id_from_object(obj):
    obj_id = re.match(r'(^[filq]-[0-9a-fA-F]{8}): ', obj['title'])
    if not obj_id:
        obj_id = re.match(r'(^[filq]-[0-9a-fA-F]{8}): ', obj['description'])
    return obj_id.group(1)


def get_object_type_by_id(object_id):
    prefixes = {'q': 'questions', 'f': 'features', 'i': 'items', 'l': 'lots'}
    return prefixes.get(object_id[0])


def get_object_index_by_id(data, object_id):
    if not data:
        return 0
    for index, element in enumerate(data):
        element_id = get_id_from_object(element)
        if element_id == object_id:
            break
    else:
        index += 1
    return index

# GUI Frontends common
def add_data_for_gui_frontends(tender_data):
    now = get_now()
    # tender_data.data.enquiryPeriod['startDate'] = (now + timedelta(minutes=2)).isoformat()
    tender_data.data.enquiryPeriod['endDate'] = (now + timedelta(minutes=6)).isoformat()
    tender_data.data.tenderPeriod['startDate'] = (now + timedelta(minutes=7)).isoformat()
    tender_data.data.tenderPeriod['endDate'] = (now + timedelta(minutes=11)).isoformat()
    return tender_data


def convert_date_to_slash_format(isodate):
    iso_dt = parse_date(isodate)
    date_string = iso_dt.strftime("%d/%m/%Y")
    return date_string


def convert_datetime_to_dot_format(isodate):
    iso_dt = parse_date(isodate)
    day_string = iso_dt.strftime("%d.%m.%Y %H:%M")
    return day_string


def local_path_to_file(file_name):
    return os.path.join(os.path.dirname(__file__), 'documents', file_name)
