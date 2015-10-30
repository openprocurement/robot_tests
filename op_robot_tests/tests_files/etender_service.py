from datetime import date, datetime, timedelta
from dateutil.parser import parse
from dateutil.tz import tzlocal
from iso8601 import parse_date
from jsonpath_rw import parse as parse_path
from pytz import timezone
from robot.output import LOGGER
from robot.output.loggerhelper import Message
from robot.libraries.BuiltIn import BuiltIn
from robot.errors import HandlerExecutionFailed
from op_robot_tests.tests_files.initial_data import (
    test_tender_data
)
import time

TIMEZONE = timezone('Europe/Kiev')


def convert_date_to_etender_format(isodate):
    iso_dt = parse_date(isodate)
    date_string = iso_dt.strftime("%d-%m-%Y")
    return date_string


def convert_time_to_etender_format(isodate):
    iso_dt = parse_date(isodate)
    time_string = iso_dt.strftime("%H:%M")
    return time_string
