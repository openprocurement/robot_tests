from openprocurement_client.client import Client
from openprocurement_client.document_service_client \
    import DocumentServiceClient
from openprocurement_client.exceptions import IdNotFound
from restkit.errors import RequestFailed, BadStatusLine
from retrying import retry
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
    for auction in data.get('auctions', []):
        for document in auction.get('documents', []):
            if doc_id in document.get('title', ''):
                return document
    raise Exception('Document with id {} not found'.format(doc_id))


def download_file_from_url(url, path_to_save_file):
    f = open(path_to_save_file, 'wb')
    f.write(urllib.urlopen(url).read())
    f.close()
    return os.path.basename(f.name)
