from openprocurement_client.client import Client, EDRClient
from openprocurement_client.dasu_client import DasuClient
from openprocurement_client.document_service_client \
    import DocumentServiceClient
from openprocurement_client.plan import PlansClient
from openprocurement_client.contract import ContractingClient
from openprocurement_client.exceptions import IdNotFound
from restkit.errors import RequestFailed, BadStatusLine, ResourceError
from retrying import retry
from time import sleep
import os
import urllib

def retry_if_request_failed(exception):
    status_code = getattr(exception, 'status_code', None)
    print(status_code)
    if 500 <= status_code < 600 or status_code in (409, 429, 412):
        return True
    else:
        return isinstance(exception, BadStatusLine)


class StableClient(Client):
    @retry(stop_max_attempt_number=100, wait_random_min=500,
           wait_random_max=4000, retry_on_exception=retry_if_request_failed)
    def request(self, *args, **kwargs):
        return super(StableClient, self).request(*args, **kwargs)


class StableDsClient(DocumentServiceClient):
    @retry(stop_max_attempt_number=100, wait_random_min=500,
           wait_random_max=4000, retry_on_exception=retry_if_request_failed)
    def request(self, *args, **kwargs):
        return super(StableDsClient, self).request(*args, **kwargs)


def prepare_api_wrapper(key, resource, host_url, api_version, ds_client=None):
    return StableClient(key, resource, host_url, api_version,
                        ds_client=ds_client)


def prepare_ds_api_wrapper(ds_host_url, auth_ds):
    return StableDsClient(ds_host_url, auth_ds)


class ContractingStableClient(ContractingClient):
    @retry(stop_max_attempt_number=100, wait_random_min=500, wait_random_max=4000, retry_on_exception=retry_if_request_failed)
    def request(self, *args, **kwargs):
        return super(ContractingStableClient, self).request(*args, **kwargs)


def prepare_contract_api_wrapper(key, host_url, api_version, ds_client=None):
    return ContractingStableClient(key, host_url, api_version, ds_client=ds_client)


class StableEDRClient(EDRClient):
    @retry(stop_max_attempt_number=100, wait_random_min=500,
           wait_random_max=4000, retry_on_exception=retry_if_request_failed)
    def request(self, *args, **kwargs):
        try:
            res = super(StableEDRClient, self).request(*args, **kwargs)
        except ResourceError as re:
            if re.status_int == 429:
                sleep(int(re.response.headers.get('Retry-After', '30')))
            raise re
        else:
            return res


def prepare_edr_wrapper(host_url, api_version, username, password):
    return StableEDRClient(host_url, api_version, username, password)


def get_complaint_internal_id(tender, complaintID):
    try:
        for complaint in tender.data.complaints:
            if complaint.complaintID == complaintID:
                return complaint.id
    except AttributeError:
        pass
    try:
        for award in tender.data.awards:
            for complaint in award.complaints:
                if complaint.complaintID == complaintID:
                    return complaint.id
    except AttributeError:
        pass
    raise IdNotFound


def get_document_by_id(data, doc_id):
    for document in data.get('documents', []):
        if doc_id in document.get('title', ''):
            return document
    for complaint in data.get('complaints', []):
        for document in complaint.get('documents', []):
            if doc_id in document.get('title', ''):
                return document
    for contract in data.get('contracts', []):
        for document in contract.get('documents', []):
            if doc_id in document.get('title', ''):
                return document
    for award in data.get('awards', []):
        for document in award.get('documents', []):
            if doc_id in document.get('title', ''):
                return document
        for complaint in award.get('complaints', []):
            for document in complaint.get('documents', []):
                if doc_id in document.get('title', ''):
                    return document
    for cancellation in data.get('cancellations', []):
        for document in cancellation.get('documents', []):
            if doc_id in document.get('title', ''):
                return document
    for bid in data.get('bids', []):
        for document in bid.get('documents', []):
            if doc_id in document.get('title', ''):
                return document
    raise Exception('Document with id {} not found'.format(doc_id))


def get_tenders_by_funder_id(client,
                             funder_id=None,
                             descending=True,
                             tender_id_field='tenderID',
                             opt_fields=('funders',)):
    params = {'offset': '',
              'opt_fields': ','.join((tender_id_field,) + opt_fields),
              'descending': descending}
    tender_list = True
    client._update_params(params)
    tenders_with_funder = {}
    while tender_list and not tenders_with_funder:
        tender_list = client.get_tenders()
        for tender in tender_list:
            if 'funders' in tender:
                tenders_with_funder[tender[tender_id_field]] = [el['identifier']['id'] for el in tender['funders']]
    # In case we are looking for a specific funder
    if funder_id:
        tenders_with_funder = {k: v for k, v in tenders_with_funder.items() if funder_id in v}
    if not tenders_with_funder:
        raise IdNotFound
    else:
        return tenders_with_funder


def download_file_from_url(url, path_to_save_file):
    f = open(path_to_save_file, 'wb')
    f.write(urllib.urlopen(url).read())
    f.close()
    return os.path.basename(f.name)


class StableClient_plan(PlansClient):
    @retry(stop_max_attempt_number=100, wait_random_min=500, wait_random_max=4000, retry_on_exception=retry_if_request_failed)
    def request(self, *args, **kwargs):
        return super(StableClient_plan, self).request(*args, **kwargs)


def prepare_plan_api_wrapper(key, host_url, api_version):
    return StableClient_plan(key, host_url, api_version)


class StableClient_dasu(DasuClient):
    @retry(stop_max_attempt_number=100, wait_random_min=500,
           wait_random_max=4000, retry_on_exception=retry_if_request_failed)
    def request(self, *args, **kwargs):
        return super(StableClient_dasu, self).request(*args, **kwargs)


def prepare_dasu_api_wrapper(key, resource, host_url, api_version, ds_client=None):
    print  key
    return StableClient_dasu(key, resource, host_url, api_version,
                        ds_client=ds_client)