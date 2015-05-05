# -*- coding: utf-8 -
import os
from munch import munchify, Munch, fromYAML
from json import load
from robot.output import LOGGER
from robot.output.loggerhelper import Message
from robot.libraries.BuiltIn import BuiltIn
from robot.errors import HandlerExecutionFailed
from datetime import datetime, timedelta
from dateutil.parser import parse
from dateutil.tz import tzlocal
from dpath.util import set as xpathset
from jsonpath_rw import parse as parse_path
from .initial_data import (
    test_tender_data, test_question_data, test_question_answer_data,
    test_bid_data, test_award_data, test_complaint_data, test_complaint_reply_data, test_tender_data_multiple_lots,
    auction_bid
)


def log_object_data(data, file_name="", format="yaml"):
    if not isinstance(data, Munch):
        data = munchify(data)
    if format == 'json':
        data = data.toJSON(indent=2)
    else:
        data = data.toYAML(allow_unicode=True, default_flow_style=False)
        format = 'yaml'
    LOGGER.log_message(Message(data, "INFO"))
    if file_name:
        output_dir = BuiltIn().get_variable_value("${OUTPUT_DIR}")
        with open(os.path.join(output_dir, file_name + '.' + format), "w") as file_obj:
            file_obj.write(data)


def load_initial_data_from(file_name):
    if not os.path.exists(file_name):
        file_name = os.path.join(os.path.dirname(__file__), 'data/{}'.format(file_name))
    with open(file_name) as file_obj:
        if file_name.endswith(".json"):
            return Munch.fromDict(load(file_obj))
        elif file_name.endswith(".yaml"):
            return fromYAML(file_obj)


def prepare_test_tender_data():
    return munchify({'data': test_tender_data()})
  
def prepare_test_tender_data_multiple_items():
    return munchify({'data': test_tender_data_multiple_lots()})


def run_keyword_and_ignore_keyword_definations(name, *args):
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
    except HandlerExecutionFailed, e:
        LOGGER.log_message(Message("Keyword {} not implemented", "ERROR"))
        return "FAIL", ""
    return status, _


def set_tender_periods(tender):
    now = datetime.now()
    tender.data.enquiryPeriod.endDate = (now + timedelta(minutes=2)).isoformat()
    tender.data.tenderPeriod.startDate = (now + timedelta(minutes=2)).isoformat()
    tender.data.tenderPeriod.endDate = (now + timedelta(minutes=4)).isoformat()
    return tender


def set_access_key(tender, access_token):
    tender.access = munchify({"token": access_token})
    return tender


def set_to_object(obj, attribute, value):
    xpathset(obj, attribute.replace('.', '/'), value)
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
    now = datetime.now(tzlocal())
    LOGGER.log_message(Message("now: {}".format(now.isoformat()), "INFO"))
    wait_seconds = (date - now).total_seconds()
    wait_seconds += 2
    if wait_seconds < 0:
        return 0
    return wait_seconds