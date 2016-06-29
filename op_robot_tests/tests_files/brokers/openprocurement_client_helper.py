from openprocurement_client.client import Client
from openprocurement_client.utils import get_tender_id_by_uaid


def prepare_api_wrapper(key, host_url, api_version, resource='auctions'):
    return Client(key, host_url, api_version, resource=resource)
