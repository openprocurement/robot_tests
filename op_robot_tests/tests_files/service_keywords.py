# -*- coding: utf-8 -
from datetime import timedelta
from dateutil.parser import parse
from dpath.util import new as xpathnew
from iso8601 import parse_date
from json import load
from jsonpath_rw import parse as parse_path
from munch import fromYAML, Munch, munchify
from robot.errors import HandlerExecutionFailed
from robot.libraries.BuiltIn import BuiltIn
from robot.output import LOGGER
from robot.output.loggerhelper import Message
# These imports are not pointless. Robot's resource and testsuite files
# can access them by simply importing library "service_keywords".
# Please ignore the warning given by Flake8 or other linter.
from .initial_data import (
    auction_bid,
    create_fake_doc,
    create_fake_sentence,
    test_additional_items_data,
    test_award_data,
    test_bid_data,
    test_bid_data_meat_tender,
    test_cancel_claim_data,
    test_cancel_tender_data,
    test_change_cancellation_document_field_data,
    test_claim_answer_data,
    test_claim_answer_satisfying_data,
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
    test_lots_bid_data,
    test_meat_tender_data,
    test_question_answer_data,
    test_question_data,
    test_submit_claim_data,
    test_supplier_data,
    test_tender_data,
    test_tender_data_limited,
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


def change_state(arguments):
    try:
        if arguments[0] == "shouldfail":
            return "shouldfail"
        return "pass"
    except IndexError:
        return "pass"


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
                LOGGER.log_message(Message("Nothing to update, "\
                                           "creating new file.", "INFO"))
        data_obj = munch_to_object(data, format)
        with open(file_path, "w") as file_obj:
            file_obj.write(data_obj)
    data_obj = munch_to_object(data, format)
    LOGGER.log_message(Message(data_obj.decode('utf-8'), "INFO"))

def munch_from_object(data, format="yaml"):
    if format.lower() == 'json':
        return data.fromJSON(data)
    else:
        return data.fromYAML(data)

def munch_to_object(data, format="yaml"):
    if format.lower() == 'json':
        return data.toJSON(indent=2)
    else:
        return data.toYAML(allow_unicode=True, default_flow_style=False)


def load_initial_data_from(file_name):
    if not os.path.exists(file_name):
        file_name = os.path.join(os.path.dirname(__file__), 'data', file_name)
    with open(file_name) as file_obj:
        if file_name.endswith(".json"):
            return Munch.fromDict(load(file_obj))
        elif file_name.endswith(".yaml"):
            return fromYAML(file_obj)


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

    if mode == 'single':
        return munchify({'data': test_tender_data(intervals)})
    elif mode == 'multi':
        return munchify({'data': test_tender_data_multiple_items(intervals)})
    elif mode == 'reporting':
        return munchify({'data': test_tender_data_limited(intervals, 'reporting')})
    elif mode == 'negotiation':
        return munchify({'data': test_tender_data_limited(intervals, 'negotiation')})
    elif mode == 'negotiation.quick':
        return munchify({'data': test_tender_data_limited(intervals, 'negotiation.quick')})
    elif mode == 'openua':
        return munchify({'data': test_tender_data_openua(intervals)})
    elif mode == 'openeu':
        return munchify({'data': test_tender_data_openeu(intervals)})
    raise ValueError("Invalid mode for prepare_test_tender_data")


def run_keyword_and_ignore_keyword_definitions(name, *args):
    """Runs the given keyword with given arguments and returns the status as a Boolean value.

    This keyword returns `True` if the keyword that is executed succeeds and
    `False` if it fails. This is useful, for example, in combination with
    `Run Keyword If`. If you are interested in the error message or return
    value, use `Run Keyword And Ignore Error` instead.

    The keyword name and arguments work as in `Run Keyword`.

    Example:
    | ${passed} = | `Run Keyword And Return Status` | Keyword | args |
    | `Run Keyword If` | ${passed} | Another keyword |

    New in Robot Framework 2.7.6.
    """
    try:
        status, _ = BuiltIn().run_keyword_and_ignore_error(name, *args)
    except HandlerExecutionFailed:
        LOGGER.log_message(Message("Keyword {} not implemented", "ERROR"))
        return "FAIL", ""
    return status, _


def set_tender_periods(tender):
    now = get_now()
    tender.data.enquiryPeriod.endDate = (now + timedelta(minutes=2)).isoformat()
    tender.data.tenderPeriod.startDate = (now + timedelta(minutes=2)).isoformat()
    tender.data.tenderPeriod.endDate = (now + timedelta(minutes=4)).isoformat()
    return tender


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
    return None


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


def merge_dicts(left, right):
    new = {}
    new.update(left)
    new.update(right)
    return new


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


def cancel_tender(cancellation_reason):
    return {
        'data': {
            'reason': cancellation_reason
        }
    }


def confirm_supplier(supplier_id):
    return {
        "data": {
            "status": "active",
            "id": supplier_id
        }
    }


def change_cancellation_document_field(key, value):
    data = {
        "data": {
            key: value
        }
    }
    return data


def confirm_cancellation(cancellation_id):
    data = {
        "data": {
            "status": "active",
            "id": cancellation_id
        }
    }
    return data


def confirm_contract(contract_id):
    data = {
        "data": {
            "id": contract_id,
            "status": "active"
        }
    }
    return data


def additional_items_data(tender_id, access_token):
    data = {"access": {"token": access_token}, "data": {"id": tender_id, "items": [{"unit": {"code": "MON", "name": "month"}, "quantity": 9}]}}
    return data


def munch_dict(arg=None, data=False):
    if arg is None:
        arg = {}
    if data:
        arg['data'] = {}
    return munchify(arg)


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
