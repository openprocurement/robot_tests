from openprocurement_client.client import Client


def prepare_api_wrapper(key='', host_url="https://api-sandbox.openprocurement.org", api_version='0.7' ):
    return Client(key, host_url, api_version )
