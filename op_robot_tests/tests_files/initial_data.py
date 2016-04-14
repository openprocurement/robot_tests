# -*- coding: utf-8 -
from datetime import timedelta
from faker import Factory
from munch import munchify
from tempfile import NamedTemporaryFile
from .local_time import get_now
from .op_faker import OP_Provider
import random


fake = Factory.create('uk_UA')
fake_ru = Factory.create('ru')
fake_en = Factory.create()
fake.add_provider(OP_Provider)


def create_fake_sentence():
    return fake.sentence(nb_words=10, variable_nb_words=True)


def field_with_id(prefix, sentence):
    return u"{}-{}: {}".format(prefix, fake.uuid4()[:8], sentence)


def translate_country_en(country):
    if country == u"Україна":
        return "Ukraine"
    else:
        raise Exception(u"Cannot translate country to english: {}".format(country))


def translate_country_ru(country):
    if country == u"Україна":
        return u"Украина"
    else:
        raise Exception(u"Cannot translate country to russian: {}".format(country))


def create_fake_doc():
    content = fake.text()
    suffix = fake.random_element(('.doc', '.docx', '.pdf'))
    tf = NamedTemporaryFile(delete=False, suffix=suffix)
    tf.write(content)
    tf.close()
    return tf.name


def test_tender_data(intervals, periods=("enquiry", "tender")):
    now = get_now()
    value_amount = round(random.uniform(3000, 250000000000), 2) #max value equals to budget of Ukraine in hryvnias
    data = {
        "mode": "test",
        "submissionMethodDetails": "quick",
        "description": fake.description(),
        "description_en": fake_en.sentence(nb_words=10, variable_nb_words=True),
        "description_ru": fake_ru.sentence(nb_words=10, variable_nb_words=True),
        "title": fake.title(),
        "title_en": fake_en.catch_phrase(),
        "title_ru": fake_ru.catch_phrase(),
        "procuringEntity": fake.procuringEntity(),
        "value": {
            "amount": value_amount,
            "currency": u"UAH",
            "valueAddedTaxIncluded": True
        },
        "minimalStep": {
            "amount": round(random.uniform(0.005, 0.03) * value_amount, 2),
            "currency": u"UAH"
        },
        "items": []
    }
    data["procuringEntity"]["kind"] = "other"
    new_item = test_item_data()
    data["items"].append(new_item)
    if data.get("mode") == "test":
        data["title"] = u"[ТЕСТУВАННЯ] {}".format(data["title"])
        data["title_en"] = u"[TESTING] {}".format(data["title_en"])
        data["title_ru"] = u"[ТЕСТИРОВАНИЕ] {}".format(data["title_ru"])
    period_dict = {}
    inc_dt = now
    for period_name in periods:
        period_dict[period_name + "Period"] = {}
        for i, j in zip(range(2), ("start", "end")):
            inc_dt += timedelta(minutes=intervals[period_name][i])
            period_dict[period_name + "Period"][j + "Date"] = inc_dt.isoformat()
    data.update(period_dict)
    return munchify(data)


def test_tender_data_limited(intervals, procurement_method_type):
    data = test_tender_data(intervals)
    del data["submissionMethodDetails"]
    del data["minimalStep"]
    del data["enquiryPeriod"]
    del data["tenderPeriod"]
    data["procuringEntity"]["kind"] = "general"
    data.update({"procurementMethodType": procurement_method_type, "procurementMethod": "limited"})
    if procurement_method_type == "negotiation":
        cause_variants = (
            "artContestIP",
            "noCompetition",
            "twiceUnsuccessful",
            "additionalPurchase",
            "additionalConstruction",
            "stateLegalServices"
        )
        cause = fake.random_element(cause_variants)
        data.update({"cause": cause})
    if procurement_method_type == "negotiation.quick":
        cause_variants = ('quick',)
        cause = fake.random_element(cause_variants)
        data.update({"cause": cause})
    if procurement_method_type in ("negotiation", "negotiation.quick"):
        data.update({
            "procurementMethodDetails": "quick, accelerator=1440",
            "causeDescription": fake.description()
        })
    return munchify(data)


def test_tender_data_multiple_items(intervals):
    t_data = test_tender_data(intervals)
    for _ in range(4):
        new_item = test_item_data()
        t_data['items'].append(new_item)
    return munchify(t_data)


def test_tender_data_multiple_lots(intervals):
    tender = test_tender_data(intervals)
    first_lot_id = "3c8f387879de4c38957402dbdb8b31af"
    tender['items'][0]['relatedLot'] = first_lot_id
    tender['lots'] = [test_lot_data()]
    tender['lots'][0]['id'] = first_lot_id
    return munchify(tender)


def test_tender_data_meat(intervals):
    tender = munchify(test_tender_data(intervals))
    item_id = "edd0032574bf4402877ad5f362df225a"
    tender['items'][0].id = item_id
    tender.features = [
        {
            "code": "ee3e24bc17234a41bd3e3a04cc28e9c6",
            "featureOf": "tenderer",
            "title": field_with_id("f", fake.title()),
            "description": fake.description(),
            "enum": [
                {
                    "value": 0.15,
                    "title": fake.word()
                },
                {
                    "value": 0.1,
                    "title": fake.word()
                },
                {
                    "value": 0.05,
                    "title": fake.word()
                },
                {
                    "value": 0,
                    "title": fake.word()
                }
            ]
        },
        {
            "code": "48cfd91612c04125ab406374d7cc8d93",
            "featureOf": "item",
            "relatedItem": item_id,
            "title": field_with_id("f", fake.title()),
            "description": fake.description(),
            "enum": [
                {
                    "value": 0.05,
                    "title": fake.word()
                },
                {
                    "value": 0.01,
                    "title": fake.word()
                },
                {
                    "value": 0,
                    "title": fake.word()
                }
            ]
        }
    ]
    return munchify(tender)


def test_question_data():
    return munchify({
        "data": {
            "author": fake.procuringEntity(),
            "description": fake.description(),
            "title": field_with_id("q", fake.title())
        }
    })


def test_question_answer_data():
    return munchify({
        "data": {
            "answer": fake.sentence(nb_words=40, variable_nb_words=True)
        }
    })


def test_complaint_data(lot=False):
    data = munchify({
        "data" : {
            "author": fake.procuringEntity(),
            "description": fake.description(),
            "title": fake.title()
        }
    })
    if lot:
        data = test_lot_complaint_data(data)
    return data


test_claim_data = test_complaint_data


def test_claim_answer_satisfying_data(claim_id):
    return munchify({
        "data": {
            "id": claim_id,
            "status": "resolved",
            "satisfied": True
        }
    })


def test_claim_answer_data(claim_id):
    return munchify({
        "data": {
            "status": "answered",
            "resolutionType": "resolved",
            "tendererAction": fake.sentence(nb_words=10, variable_nb_words=True),
            "resolution": fake.sentence(nb_words=15, variable_nb_words=True),
            "id": claim_id
        }
    })


def test_escalate_claim_data(claim_id):
    return munchify({
        "data": {
            "status": "pending",
            "satisfied": False,
            "id": claim_id
        }
    })


def test_cancel_tender_data(cancellation_reason):
    return munchify({
        'data': {
            'reason': cancellation_reason
        }
    })


def test_cancel_claim_data(claim_id, cancellation_reason):
    return munchify({
        'data': {
            'cancellationReason': cancellation_reason,
            'status': 'cancelled',
            'id': claim_id
        }
    })


def test_confirm_data(id):
    return munchify({
        "data": {
            "status": "active",
            "id": id
        }
    })


def test_submit_claim_data(claim_id):
    return munchify({
        "data": {
            "id": claim_id,
            "status": "claim"
        }
    })


def test_complaint_reply_data():
    return munchify({
        "data": {
            "status": "resolved"
        }
    })


def test_bid_data(mode):
    bid = munchify({
        "data": {
            "tenderers": [
                fake.procuringEntity()
            ]
        }
    }
    bid["data"]["tenderers"][0]["address"]["countryName_en"] = translate_country_en(bid["data"]["tenderers"][0]["address"]["countryName"])
    bid["data"]["tenderers"][0]["address"]["countryName_ru"] = translate_country_ru(bid["data"]["tenderers"][0]["address"]["countryName"])
    if 'open' in mode:
        bid.data['selfEligible'] = True
        bid.data['selfQualified'] = True
    if mode == 'multiLot':
        bid.data.lotValues = list()
        for _ in range(2):
            bid.data.lotValues.append(test_bid_value())
    else:
        bid.data.update(test_bid_value())
    if mode == 'meat':
        bid.data.update(test_bid_params())
    return bid


def test_bid_params():
    return munchify({
        "parameters": [
            {
                "code": "ee3e24bc17234a41bd3e3a04cc28e9c6",
                "value": fake.random_element(elements=(0.15, 0.1, 0.05, 0))
            },
            {
                "code": "48cfd91612c04125ab406374d7cc8d93",
                "value": fake.random_element(elements=(0.05, 0.01, 0))
            }
        ]
    })

def test_bid_value():
    return munchify({
                "value": {
                    "currency": "UAH",
                    "amount": fake.random_int(max=1999),
                    "valueAddedTaxIncluded": True
                }
            })


def test_supplier_data():
    return munchify({
        "data": {
            "suppliers": [
                fake.procuringEntity()
            ],
            "value": {
                "amount": fake.random_int(min=1),
                "currency": "UAH",
                "valueAddedTaxIncluded": True
            }
        }
    })


def test_item_data(cpv=None):
    data = fake.fake_item(cpv)
    data["description"] = field_with_id("i", data["description"])
    days = fake.random_int(min=1, max=30)
    data["deliveryDate"] = {"endDate": (get_now() + timedelta(days=days)).isoformat()}
    data["deliveryAddress"]["countryName_en"] = translate_country_en(data["deliveryAddress"]["countryName"])
    data["deliveryAddress"]["countryName_ru"] = translate_country_ru(data["deliveryAddress"]["countryName"])
    return munchify(data)


def test_invalid_features_data():
    return [
        {
            "code": "ee3e24bc17234a41bd3e3a04cc28e9c6",
            "featureOf": "tenderer",
            "title": fake.title(),
            "description": fake.description(),
            "enum": [
                {
                    "value": 0.35,
                    "title": fake.word()
                },
                {
                    "value": 0,
                    "title": fake.word()
                }
            ]
        },
        {
            "code": "48cfd91612c04125ab406374d7cc8d93",
            "featureOf": "item",
            "relatedItem": "edd0032574bf4402877ad5f362df225a",
            "title": fake.title(),
            "description": fake.description(),
            "enum": [
                {
                    "value": 0.35,
                    "title": fake.word()
                },
                {
                    "value": 0,
                    "title": fake.word()
                }
            ]
        }
    ]


def test_lot_data():
    value_amount = round(random.uniform(3000, 250000000000), 2) #max value equals to budget of Ukraine in hryvnias
    return munchify(
        {
            "description": fake.description(),
            "title": field_with_id('l', fake.title()),
            "value": {
                "currency": "UAH",
                "amount": value_amount,
                "valueAddedTaxIncluded": True
            },
            "minimalStep": {
                "currency": "UAH",
                "amount": round(random.uniform(0.005, 0.03) * value_amount, 2),
                "valueAddedTaxIncluded": True
            },
            "status": "active"
        })


def test_lot_document_data(document, lot_id):
    document.data.update({"documentOf": "lot", "relatedItem": lot_id})
    return munchify(document)


def test_lot_question_data(question, lot_id):
    question.data.update({"questionOf": "lot", "relatedItem": lot_id})
    return munchify(question)


def test_lot_complaint_data(complaint, lot_id):
    complaint.data.update({"complaintOf": "lot", "relatedItem": lot_id})
    return munchify(complaint)


def test_tender_data_openua(intervals):
    accelerator = intervals['accelerator']
    # Since `accelerator` field is not really a list containing timings
    # for a period called `acceleratorPeriod`, let's remove it :)
    del intervals['accelerator']
    # We should not provide any values for `enquiryPeriod` when creating
    # an openUA or openEU procedure. That field should not be present at all.
    # Therefore, we pass a nondefault list of periods to `test_tender_data()`.
    t_data = test_tender_data(intervals, periods=('tender',))
    t_data['procurementMethodType'] = 'aboveThresholdUA'
    t_data['procurementMethodDetails'] = 'quick, ' \
        'accelerator={}'.format(accelerator)
    t_data['procuringEntity']['kind'] = 'general'
    return t_data


def test_tender_data_openeu(intervals):
    accelerator = intervals['accelerator']
    # Since `accelerator` field is not really a list containing timings
    # for a period called `acceleratorPeriod`, let's remove it :)
    del intervals['accelerator']
    # We should not provide any values for `enquiryPeriod` when creating
    # an openUA or openEU procedure. That field should not be present at all.
    # Therefore, we pass a nondefault list of periods to `test_tender_data()`.
    t_data = test_tender_data(intervals, periods=('tender',))
    t_data['procurementMethodType'] = 'aboveThresholdEU'
    t_data['procurementMethodDetails'] = 'quick, ' \
        'accelerator={}'.format(accelerator)
    t_data['title_en'] = "[TESTING]"
    for item_number, item in enumerate(t_data['items']):
        item['description_en'] = "Test item #{}".format(item_number)
    t_data['procuringEntity']['contactPoint']['name_en'] = fake_en.name()
    t_data['procuringEntity']['contactPoint']['availableLanguage'] = "en"
    t_data['procuringEntity']['identifier']['legalName_en'] = "Institution \"Vinnytsia City Council primary and secondary general school № 10\""
    t_data['procuringEntity']['kind'] = 'general'
    return t_data
