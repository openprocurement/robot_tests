from openprocurement_client.client import Client


def prepare_api_wrapper(key='', host_url="https://api-sandbox.openprocurement.org"):
    return Client(key, host_url)
