from openprocurement_client.client import Client


def prepare_api_wrapper(key, host_url, api_version):
    return Client(key, host_url, api_version)


def get_tenders(client, offset=None):
    params = {'opt_fields': 'tenderID', 'descending': 1}
    if offset:
        params['offset'] = offset
    return client.get_tenders(params)
