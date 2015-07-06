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
    test_tender_data
)

TIMEZONE = timezone('Europe/Kiev')

def convert_date_to_etender_format(isodate):
    iso_dt=parse_date(isodate)
    date_string = iso_dt.strftime("%d-%m-%Y")
    return  date_string

def convert_time_to_etender_format(isodate):
    iso_dt=parse_date(isodate)
    time_string = iso_dt.strftime("%H:%M")
    return  time_string
