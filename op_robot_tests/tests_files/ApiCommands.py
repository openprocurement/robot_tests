# -*- coding: utf-8 -
from munch import munchify
from .initial_data import (
    test_tender_data, test_question_data, test_question_answer_data,
    test_bid_data
)

from dateutil.parser import parse
from dateutil.tz import tzlocal
from datetime import datetime, timedelta

from json import loads as convert_from_string_to_dict
from openprocurement_client.client import Client
from StringIO import StringIO
from robot.output import LOGGER
from robot.output.loggerhelper import Message


def prepare_api(key=''):
    return Client(key)


def prepare_test_tender_data():
    tender = munchify({'data': test_tender_data})
    return tender


def set_tender_periods(tender):
    now = datetime.now()
    tender.data.enquiryPeriod.endDate = (now + timedelta(minutes=2)).isoformat()
    tender.data.tenderPeriod.startDate = (now + timedelta(minutes=2)).isoformat()
    tender.data.tenderPeriod.endDate = (now + timedelta(minutes=4)).isoformat()
    return tender


def set_access_key(tender, access_token):
    tender.access = munchify({"token": access_token})
    return tender


def upload_tender_document(api, tender):
    file = StringIO()
    file.name = 'тест.txt'
    file.write("test text dataaaфвфв")
    file.seek(0)
    return api.upload_document(tender, file)


def patch_tender_document(api, tender, doc_id):
    file = StringIO()
    file.name = 'test1.txt'
    file.write("контент")
    file.seek(0)
    return api.update_document(tender, doc_id, file)


def create_approve_award_request_data(award_id):
    return munchify({"data": {"status": "active", "id": award_id}})


def calculate_wait_to_date(date_stamp):
    date = parse(date_stamp)
    LOGGER.log_message(Message("date: {}".format(date.isoformat()), "INFO"))
    now = datetime.now(tzlocal())
    LOGGER.log_message(Message("now: {}".format(now.isoformat()), "INFO"))
    wait_seconds = (date - now).total_seconds()
    wait_seconds += 2
    if wait_seconds < 0:
        return 0
    return wait_seconds
