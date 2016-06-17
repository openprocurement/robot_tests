from openprocurement_client.client import Client
from openprocurement_client.contract import ContractingClient
from openprocurement_client.utils import get_tender_id_by_uaid, get_contract_id_by_uaid
from openprocurement_client.exceptions import IdNotFound
from restkit.errors import RequestFailed
from retrying import retry
import os
import urllib


def retry_if_request_failed(exception):
    return isinstance(exception, RequestFailed)


class StableClient(Client):
    @retry(stop_max_attempt_number=100, wait_random_min=500, wait_random_max=4000, retry_on_exception=retry_if_request_failed)
    def request(self, *args, **kwargs):
        return super(StableClient, self).request(*args, **kwargs)


class ContractingStableClient(ContractingClient):
    @retry(stop_max_attempt_number=100, wait_random_min=500, wait_random_max=4000, retry_on_exception=retry_if_request_failed)
    def request(self, *args, **kwargs):
        return super(ContractingStableClient, self).request(*args, **kwargs)


def prepare_contract_api_wrapper(key, host_url, api_version):
    return ContractingStableClient(key, host_url, api_version)


def prepare_api_wrapper(key, host_url, api_version):
    return StableClient(key, host_url, api_version)


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
    raise Exception('Document with id {} not found'.format(doc_id))


def download_file_from_url(url, path_to_save_file):
    f = open(path_to_save_file, 'wb')
    f.write(urllib.urlopen(url).read())
    f.close()
    return os.path.basename(f.name)
