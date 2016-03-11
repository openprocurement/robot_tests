from openprocurement_client.plan import PlansClient


def prepare_plan_api_wrapper(key, host_url, api_version):
    return PlansClient(key, host_url, api_version)
