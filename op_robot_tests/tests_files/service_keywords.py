#!/usr/bin/env python
# -*- coding: utf-8 -
import os
from munch import munchify, Munch, fromYAML
from json import load
from iso8601 import parse_date
from robot.output import LOGGER
from robot.output.loggerhelper import Message
from robot.libraries.BuiltIn import BuiltIn
from robot.errors import HandlerExecutionFailed
from datetime import datetime, timedelta, date
from dateutil.parser import parse
from dateutil.tz import tzlocal
from pytz import timezone
from dpath.util import set as xpathset
from jsonpath_rw import parse as parse_path
import time
from .initial_data import (
    test_tender_data, test_question_data, test_question_answer_data,
    test_bid_data, test_award_data, test_complaint_data, test_complaint_reply_data, test_tender_data_multiple_lots,
    auction_bid, prom_test_tender_data, create_fake_doc
)
import calendar

TIMEZONE = timezone('Europe/Kiev')

def get_date():
    return datetime.now().isoformat()

def change_state(arguments):
    try:
        if arguments[0] == "shouldfail":
            return "shouldfail"
        return "pass"
    except IndexError:
        return "pass"

def prepare_prom_test_tender_data():
    return munchify({'data': prom_test_tender_data()})

def compare_date(data1, data2):
    data1=parse(data1) 
    data2=parse(data2)
    #LOGGER.log_message(Message("data1: {}".format(data1), "INFO"))
    #LOGGER.log_message(Message("data2: {}".format(data2), "INFO"))
    if data1.tzinfo is None:
        data1 = TIMEZONE.localize(data1)
    if data2.tzinfo is None:
        data2 = TIMEZONE.localize(data2)
    delta = (data1-data2).total_seconds()
    if abs(delta) > 60:
       return False
    return True 

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

def convert_date_to_prom_format(isodate):
    iso_dt=parse_date(isodate)
    day_string = iso_dt.strftime("%d.%m.%Y %H:%M")
    return  day_string

def load_initial_data_from(file_name):
    if not os.path.exists(file_name):
        file_name = os.path.join(os.path.dirname(__file__), 'data/{}'.format(file_name))
    with open(file_name) as file_obj:
        if file_name.endswith(".json"):
            return Munch.fromDict(load(file_obj))
        elif file_name.endswith(".yaml"):
            return fromYAML(file_obj)

def prepare_test_tender_data(period_interval=2, mode='single'):
    if mode == 'single':
        return munchify({'data': test_tender_data(period_interval=period_interval)})
    elif mode == 'multi':
        return munchify({'data': test_tender_data_multiple_lots(period_interval=period_interval)})
    raise ValueError('A very specific bad thing happened') 

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

##GUI Frontends common
def convert_date_to_slash_format(isodate):
    iso_dt=parse_date(isodate)
    date_string = iso_dt.strftime("%d/%m/%Y")
    return  date_string

def Add_data_for_GUI_FrontEnds(INITIAL_TENDER_DATA):
    now = datetime.now() 
    #INITIAL_TENDER_DATA.data.enquiryPeriod['startDate'] = (now + timedelta(minutes=2)).isoformat()
    INITIAL_TENDER_DATA.data.enquiryPeriod['endDate'] = (now + timedelta(minutes=6)).isoformat()
    INITIAL_TENDER_DATA.data.tenderPeriod['startDate'] = (now + timedelta(minutes=7)).isoformat()
    INITIAL_TENDER_DATA.data.tenderPeriod['endDate'] = (now + timedelta(minutes=11)).isoformat()
    return INITIAL_TENDER_DATA

def local_path_to_file(file_name):
    path = os.getcwd()
    path = path.split("brokers", 1)[0] + "/src/op_robot_tests/op_robot_tests/tests_files/documents/" + file_name
    return path

## E-Tender
def convert_date_to_etender_format(isodate):
    iso_dt=parse_date(isodate)
    date_string = iso_dt.strftime("%d-%m-%Y")
    return  date_string

def convert_date_for_delivery(isodate):
    iso_dt=parse_date(isodate)
    date_string = iso_dt.strftime("%Y-%m-%d %H:%M")
    return  date_string

def convert_time_to_etender_format(isodate):
    iso_dt=parse_date(isodate)
    time_string = iso_dt.strftime("%H:%M")
    return  time_string

def procuringEntity_name(INITIAL_TENDER_DATA):
    INITIAL_TENDER_DATA.data.procuringEntity['name'] = u"Повна назва невідомо чого"
    return INITIAL_TENDER_DATA

##Newtend
def newtend_date_picker_index(isodate):
    now = datetime.today()
    date_str = '01' + str(now.month) + str(now.year)
    first_day_of_month = datetime.strptime(date_str, "%d%m%Y")
    mod = first_day_of_month.isoweekday() - 2
    iso_dt=parse_date(isodate)
    last_day_of_month = calendar.monthrange(now.year, now.month)[1] 
    #LOGGER.log_message(Message("last_day_of_month: {}".format(last_day_of_month), "INFO")) 
    if now.day>iso_dt.day:
        mod = calendar.monthrange(now.year, now.month)[1] + mod
    return mod + iso_dt.day

def Update_data_for_Newtend(INITIAL_TENDER_DATA):
    #INITIAL_TENDER_DATA.data.items[0].classification['description'] = u"Картонки"
    INITIAL_TENDER_DATA.data.procuringEntity['name'] = u"openprocurement"
    return INITIAL_TENDER_DATA