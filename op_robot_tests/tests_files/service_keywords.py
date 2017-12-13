# -*- coding: utf-8 -
import operator
from .local_time import get_now, TZ
from copy import deepcopy
from datetime import timedelta
from dateutil.parser import parse
from dpath.util import delete as xpathdelete, get as xpathget, new as xpathnew
from haversine import haversine
from json import load, loads
from jsonpath_rw import parse as parse_path
from munch import Munch, munchify
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
    create_fake_amount,
    create_fake_number,
    create_fake_date,
    create_fake_funder,
    get_fake_funder_scheme,
    fake,
    subtraction,
    field_with_id,
    test_bid_data,
    test_bid_value,
    test_change_data,
    test_claim_answer_data,
    test_claim_data,
    test_complaint_data,
    test_complaint_reply_data,
    test_confirm_data,
    test_feature_data,
    test_invalid_features_data,
    test_item_data,
    test_lot_data,
    test_lot_document_data,
    test_related_question,
    test_question_answer_data,
    test_question_data,
    test_supplier_data,
    test_tender_data,
    test_tender_data_competitive_dialogue,
    test_tender_data_limited,
    test_tender_data_openeu,
    test_tender_data_openua,
    test_tender_data_planning,
    test_tender_data_openua_defense,
    test_bid_competitive_data,
    create_fake_title,
    create_fake_value_amount,
    test_change_document_data,
    convert_amount,
    get_number_of_minutes,
    get_hash,
)
from barbecue import chef
from restkit import request
# End of non-pointless import
import os
import re


NUM_TYPES = (int, long, float)
STR_TYPES = (str, unicode)


def get_current_tzdate():
    return get_now().strftime('%Y-%m-%d %H:%M:%S.%f')


def add_minutes_to_date(date, minutes):
    return (parse(date) + timedelta(minutes=float(minutes))).isoformat()


def compare_date(left, right, accuracy="minute", absolute_delta=True):
    '''Compares dates with specified accuracy

    Before comparison dates are parsed into datetime.datetime format
    and localized.

    :param left:            First date
    :param right:           Second date
    :param accuracy:        Max difference between dates to consider them equal
                            Default value   - "minute"
                            Possible values - "day", "hour", "minute" or float value
                            of seconds
    :param absolute_delta:  Type of comparison. If set to True, then no matter which date order. If set to
                            False then right must be lower then left for accuracy value.
                            Default value   - True
                            Possible values - True and False or something what can be casted into them
    :returns:               Boolean value

    :error:                 ValueError when there is problem with converting accuracy
                            into float value. When it will be catched warning will be
                            given and accuracy will be set to 60.

    '''
    left = parse(left)
    right = parse(right)

    if left.tzinfo is None:
        left = TZ.localize(left)
    if right.tzinfo is None:
        right = TZ.localize(right)

    delta = (left - right).total_seconds()

    if accuracy == "day":
        accuracy = 24 * 60 * 60 - 1
    elif accuracy == "hour":
        accuracy = 60 * 60 - 1
    elif accuracy == "minute":
        accuracy = 60 - 1
    else:
        try:
            accuracy = float(accuracy)
        except ValueError:
            LOGGER.log_message(Message("Could not convert from {} to float. Accuracy is set to 60 seconds.".format(accuracy), "WARN"))
            accuracy = 60
    if absolute_delta:
        delta = abs(delta)
    if delta > accuracy:
        return False
    return True


def compare_coordinates(left_lat, left_lon, right_lat, right_lon, accuracy=0.1):
    '''Compares coordinates with specified accuracy

    :param left_lat:        First coordinate latitude
    :param left_lon:        First coordinate longitude
    :param right_lat:       Second coordinate latitude
    :param right_lon:       Second coordinate longitude
    :param accuracy:        Max difference between coordinates to consider them equal
                            Default value   - 0.1
                            Possible values - float or integer value of kilometers

    :returns:               Boolean value

    :error:                 ValueError when there is problem with converting accuracy
                            into float value. When it will be catched warning will be
                            given and accuracy will be set to 0.1.
    '''
    for key, value in {'left_lat': left_lat, 'left_lon': left_lon, 'right_lat': right_lat, 'right_lon': right_lon}.iteritems():
        if not isinstance(value, NUM_TYPES):
            raise TypeError("Invalid type for coordinate '{0}'. "
                            "Expected one of {1}, got {2}".format(
                                key, str(NUM_TYPES), str(type(value))))
    distance = haversine((left_lat, left_lon), (right_lat, right_lon))
    if distance > accuracy:
        return False
    return True


def log_object_data(data, file_name=None, format="yaml", update=False, artifact=False):
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
        if artifact:
            file_path = os.path.join(os.path.dirname(__file__), 'data', file_name + '.' + format)
        else:
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


def load_data_from(file_name, mode=None, external_params_name=None):
    """We assume that 'external_params' is a a valid json if passed
    """

    external_params = BuiltIn().\
        get_variable_value('${{{name}}}'.format(name=external_params_name))

    if not os.path.exists(file_name):
        file_name = os.path.join(os.path.dirname(__file__), 'data', file_name)
    with open(file_name) as file_obj:
        if file_name.endswith('.json'):
            file_data = Munch.fromDict(load(file_obj))
        elif file_name.endswith('.yaml'):
            file_data = Munch.fromYAML(file_obj)
    if mode == 'brokers':
        default = file_data.pop('Default')
        brokers = {}
        for k, v in file_data.iteritems():
            brokers[k] = merge_dicts(default, v)
        file_data = brokers

    try:
        ext_params_munch \
            = Munch.fromDict(loads(external_params)) \
            if external_params else Munch()
    except ValueError:
        raise ValueError(
            'Value {param} of command line parameter {name} is invalid'.
            format(name=external_params_name, param=str(external_params))
        )

    return merge_dicts(file_data, ext_params_munch)


def compute_intrs(brokers_data, used_brokers):
    """Compute optimal values for period intervals.

    Notice: This function is maximally effective if ``brokers_data``
    does not contain ``Default`` entry.
    Using `load_data_from` with ``mode='brokers'`` is recommended.
    """
    keys_to_prefer_lesser = ('accelerator',)

    def recur(l, r, prefer_greater_numbers=True):
        l, r = deepcopy(l), deepcopy(r)
        if isinstance(l, list) and isinstance(r, list) and len(l) == len(r):
            lst = []
            for ll, rr in zip(l, r):
                lst.append(recur(ll, rr))
            return lst
        elif isinstance(l, NUM_TYPES) and isinstance(r, NUM_TYPES):
            if l == r:
                return l
            if l > r:
                return l if prefer_greater_numbers else r
            if l < r:
                return r if prefer_greater_numbers else l
        elif isinstance(l, dict) and isinstance(r, dict):
            for k, v in r.iteritems():
                if k not in l.keys():
                    l[k] = v
                elif k in keys_to_prefer_lesser:
                   l[k] = recur(l[k], v, prefer_greater_numbers=False)
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


def prepare_test_tender_data(procedure_intervals,
                             tender_parameters,
                             submissionMethodDetails,
                             accelerator,
                             funders):
    # Get actual intervals by mode name
    mode = tender_parameters['mode']
    if mode in procedure_intervals:
        intervals = procedure_intervals[mode]
    else:
        intervals = procedure_intervals['default']
    LOGGER.log_message(Message(intervals))
    tender_parameters['intervals'] = intervals

    # Set acceleration value for certain modes
    assert isinstance(intervals['accelerator'], int), \
        "Accelerator should be an 'int', " \
        "not '{}'".format(type(intervals['accelerator']).__name__)
    assert intervals['accelerator'] >= 0, \
        "Accelerator should not be less than 0"
    if mode == 'negotiation':
        return munchify({'data': test_tender_data_limited(tender_parameters)})
    elif mode == 'negotiation.quick':
        return munchify({'data': test_tender_data_limited(tender_parameters)})
    elif mode == 'openeu':
        return munchify({'data': test_tender_data_openeu(
            tender_parameters, submissionMethodDetails)})
    elif mode == 'openua':
        return munchify({'data': test_tender_data_openua(
            tender_parameters, submissionMethodDetails)})
    elif mode == 'openua_defense':
        return munchify({'data': test_tender_data_openua_defense(
            tender_parameters, submissionMethodDetails)})
    elif mode == 'open_competitive_dialogue':
        return munchify({'data': test_tender_data_competitive_dialogue(
            tender_parameters, submissionMethodDetails)})
    elif mode == 'reporting':
        return munchify({'data': test_tender_data_limited(tender_parameters)})
    elif mode == 'belowThreshold':
        return munchify({'data': test_tender_data(
            tender_parameters,
            submissionMethodDetails=submissionMethodDetails,
            funders=funders,
            accelerator=accelerator)})
        # The previous line needs an explicit keyword argument because,
        # unlike previous functions, this one has three arguments.
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


def get_from_object(obj, attribute):
    """Gets data from a dictionary using a dotted accessor-string"""
    jsonpath_expr = parse_path(attribute)
    return_list = [i.value for i in jsonpath_expr.find(obj)]
    if return_list:
        return return_list[0]
    else:
        raise AttributeError('Attribute not found: {0}'.format(attribute))


def set_to_object(obj, attribute, value):
    # Search the list index in path to value
    list_index = re.search('\d+', attribute)
    if list_index and attribute != 'stage2TenderID':
        list_index = list_index.group(0)
        parent, child = attribute.split('[' + list_index + '].')[:2]
        # Split attribute to path to lits (parent) and path to value in list element (child)
        try:
            # Get list from parent
            listing = get_from_object(obj, parent)
            # Create object with list_index if he don`t exist
            if len(listing) < int(list_index) + 1:
                listing.append({})
        except AttributeError:
            # Create list if he don`t exist
            listing = [{}]
        # Update list in parent
        xpathnew(obj, parent, listing, separator='.')
        # Set value in obj
        xpathnew(obj, '.'.join([parent, list_index,  child]), value, separator='.')
    else:
        xpathnew(obj, attribute, value, separator='.')
    return munchify(obj)


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
    obj_id = re.match(r'(^[filq]-[0-9a-fA-F]{8}): ', obj.get('title', ''))
    if not obj_id:
        obj_id = re.match(r'(^[filq]-[0-9a-fA-F]{8}): ', obj.get('description', ''))
    return obj_id.group(1)


def get_id_from_string(string):
    return re.match(r'[dc]\-[0-9a-fA-F]{8}', string).group(0)


def get_object_type_by_id(object_id):
    prefixes = {'q': 'questions', 'f': 'features', 'i': 'items', 'l': 'lots'}
    return prefixes.get(object_id[0])


def get_complaint_index_by_complaintID(data, complaintID):
    if not data:
        return 0
    for index, element in enumerate(data):
        if element['complaintID'] == complaintID:
            break
    else:
        index += 1
    return index


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


def get_object_by_id(data, given_object_id, slice_element, object_id):
    """
        data: object to slice
        given_object_id: with what id we should compare
        slice_element: what path should be extracted (e.g. from { key: val } extract key )
        object_id: what property is id (e.g. from { id: 1, name: 2 } extract id)
    """

    # Slice the given object, e.g. slice bid object to lotValues object
    try:
        sliced_object = data[slice_element]
    except KeyError:
        return data

    # If there is one sliced object, get the 1st element
    if len(sliced_object) == 1:
        return sliced_object[0]

    # Compare given object id and id from sliced object
    for index, element in enumerate(sliced_object):
        element_id = element[object_id]
        if element_id == given_object_id:
            return element

    return sliced_object[0]


def generate_test_bid_data(tender_data):
    if tender_data.get('procurementMethodType', '') in (
            'aboveThresholdUA',
            'aboveThresholdUA.defense',
            'aboveThresholdEU',
            'competitiveDialogueUA',
            'competitiveDialogueEU'
        ):
        bid = test_bid_competitive_data()
        bid.data.selfEligible = True
        bid.data.selfQualified = True
    else:
        bid = test_bid_data()
    if 'lots' in tender_data:
        bid.data.lotValues = []
        for lot in tender_data['lots']:
            value = test_bid_value(lot['value']['amount'])
            value['relatedLot'] = lot.get('id', '')
            bid.data.lotValues.append(value)
    else:
        bid.data.update(test_bid_value(tender_data['value']['amount']))
    if 'features' in tender_data:
        bid.data.parameters = []
        for feature in tender_data['features']:
            parameter = {"value": fake.random_element(elements=(0.05, 0.01, 0)), "code": feature.get('code', '')}
            bid.data.parameters.append(parameter)
    return bid


def mult_and_round(*args, **kwargs):
    return round(reduce(operator.mul, args), kwargs.get('precision', 2))


def generate_test_bid_data_second_stage(tender_data, index='0'):
    bid = test_bid_data()
    if index.isdigit():
        index = int(index)
    else:
        index = 0
    bid['data']['tenderers'][0]['identifier']['id'] = tender_data['shortlistedFirms'][index]['identifier']['id']
    bid['data']['tenderers'][0]['identifier']['scheme'] = tender_data['shortlistedFirms'][index]['identifier']['scheme']
    bid['data']['tenderers'][0]['identifier']['legalName'] = tender_data['shortlistedFirms'][index]['identifier']['legalName']
    bid['data']['tenderers'][0]['name'] = tender_data['shortlistedFirms'][index]['name']
    if tender_data.get('procurementMethodType', '') in ('competitiveDialogueEU.stage2', 'competitiveDialogueUA.stage2'):
        bid.data.selfEligible = True
        bid.data.selfQualified = True
    if 'lots' in tender_data:
        bid.data.lotValues = []
        for lot in tender_data['lots']:
            value = test_bid_value(lot['value']['amount'])
            value['relatedLot'] = lot.get('id', '')
            bid.data.lotValues.append(value)
    else:
        bid.data.update(test_bid_value(tender_data['value']['amount']))
    if 'features' in tender_data:
        bid.data.parameters = []
        for feature in tender_data['features']:
            parameter = {"value": fake.random_element(elements=(0.05, 0.01, 0)), "code": feature.get('code', '')}
            bid.data.parameters.append(parameter)
    return bid


def convert_amount_string_to_float(amount_string):
    return float(amount_string.replace(' ', '').replace(',', '.'))


def compare_rationale_types(type1, type2):
    return set(type1) == set(type2)


def delete_from_dictionary(variable, path):
    if not type(path) in STR_TYPES:
        raise TypeError('path must be one of: ' +
            str([x.__name__ for x in STR_TYPES]))
    return xpathdelete(variable, path, separator='.')


def dictionary_should_not_contain_path(dictionary, path):
    try:
        xpathget(dictionary, path, separator='.')
    except KeyError:
        return
    raise RuntimeError("Dictionary contains path '%s'." % path)
