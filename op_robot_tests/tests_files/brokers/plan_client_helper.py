from openprocurement_client.plan import PlansClient


def prepare_plan_api_wrapper(key, host_url, api_version):
    return PlansClient(key, host_url, api_version)

def get_plans(client, offset=None):
    params = {'opt_fields': 'planID', 'descending': 1}
    if offset:
        params['offset'] = offset
    return client.get_plans(params)