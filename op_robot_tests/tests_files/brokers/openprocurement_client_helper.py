from openprocurement_client.client import Client
import sys


def prepare_api_wrapper(key='', host_url="https://api-sandbox.openprocurement.org", api_version='0.8'):
    return Client(key, host_url, api_version)


def get_internal_id(get_tenders_function, date):
    result = get_tenders_function({"offset": date, "opt_fields": 'tenderID'})
    return result
