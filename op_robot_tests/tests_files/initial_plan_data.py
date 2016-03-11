# -*- coding: utf-8 -
from munch import munchify


def test_plan_data():
    return munchify({
	"data":
	{
		"classification":
		{
				"scheme": "CPV",
				"description": "Банкомати",
				"id": "30123200-9"
		},
		"items": [
				{
					"description": "30123200-9 Automatic cash dispensers",
					"classification":
					{
						"scheme": "CPV",
						"description": "Банкомати",
						"id": "30123200-9"
					},
					"additionalClassifications":
				[{
					"scheme": "ДКПП",
					"id": "45.19",
					"description": " Торгівля іншими автотранспортними засобами"
				}],
				"id": "de5fd3f7c9e1494e84c9711ee77b6842",
				"unit": {
					"code": "H87",
					"name": "pieces"},
					"quantity": 1}
			],
		"planID": "UA-P-2016-02-01-000001-1",
		"budget":
			{
				"amountNet": 10000,
				"description": "30123200-9 Automatic cash dispensers",
				"currency": "UAH",
				"amount": 12000,
				"id": "201630123200-9"
			},
		"additionalClassifications":
			[
				{
					"scheme": "ДКПП",
					"id": "45.19",
					"description": " Торгівля іншими автотранспортними засобами"
				},
				{
					"scheme": "КЕКВ",
					"id": "2200","description": "Використання товарів і послуг"
				}
			],
		"procuringEntity":
			{
				"identifier":
					{
						"scheme": "UA-EDR",
						"id": "0007777777",
						"legalName": "ТОВ \"avp\""
					},
				"name": "avp"
			},
		"tender":
			{
				"procurementMethod": "open",
                "procurementMethodType": "belowThreshold",
				"tenderPeriod":
					{
						"startDate": "2016-02-29T00:00:00+02:00"
				}
			},
		"dateModified": "2016-02-01T11:00:47.174178+02:00"
	}
    })