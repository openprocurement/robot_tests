from openprocurement_client.client import Client
from openprocurement_client.utils import get_tender_id_by_uaid
from openprocurement_client.exceptions import IdNotFound


def prepare_api_wrapper(key, host_url, api_version):
    return Client(key, host_url, api_version)

def get_complaint_internal_id(tender, complaintID):
    for complaint in tender.data.complaints:
        if complaint.complaintID == complaintID:
            return complaint.id
    raise IdNotFound

