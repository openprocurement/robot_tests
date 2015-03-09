from openprocurement_client.client import Client


def prepare_api_wrapper(key=''):
    return Client(key)
