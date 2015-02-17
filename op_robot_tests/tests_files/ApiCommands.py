# -*- coding: utf-8 -

from munch import munchify, Munch
from .initial_data import (
    test_tender_data, test_question_data, test_question_answer_data,
    test_bid_data
)
from openprocurement_client.client import Client
from datetime import datetime, timedelta
from StringIO import StringIO
from robot.output import LOGGER
from robot.output.loggerhelper import Message


def prepare_api(key=''):
    return Client(key)


def prepare_test_tender_data():
    tender = munchify({'data': test_tender_data})
    return tender


def log_object_data(data):
    if not isinstance(data, Munch):
        data = munchify(data)
    LOGGER.log_message(
        Message(data.toYAML(allow_unicode=True, default_flow_style=False), "INFO")
    )


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
    file.name = 'test_file.txt'
    file.write("test text data")
    file.seek(0)
    return api.upload_document(tender, file)


def patch_tender_document(api, tender, doc_id):
    file = StringIO()
    file.name = 'test_file1.txt'
    file.write("test text data 11111")
    file.seek(0)
    return api.update_document(tender, doc_id, file)


def let_active_award(api, tender):
    awards = api.get_awards(tender)
    print "----_____ WE GOT AN AWARDS _____----"
    award_id = [i['id'] for i in awards.data if i['status'] == 'pending'][0]
    active_award = munchify({"data": {"status": "active", "id": award_id}})
    award = api.patch_award(tender, active_award)
