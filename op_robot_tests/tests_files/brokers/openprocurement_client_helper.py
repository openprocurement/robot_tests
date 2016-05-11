from openprocurement_client.client import Client
from openprocurement_client.utils import get_tender_id_by_uaid
from openprocurement_client.exceptions import IdNotFound


def prepare_api_wrapper(key, host_url, api_version):
    return Client(key, host_url, api_version)

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

