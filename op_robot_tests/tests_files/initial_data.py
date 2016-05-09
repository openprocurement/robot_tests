# -*- coding: utf-8 -
from datetime import timedelta
from faker import Factory
from munch import munchify
from uuid import uuid4
from copy import deepcopy
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
    prefix = "{}-{}{}".format("d", fake.uuid4()[:8], fake_en.word())
    tf = NamedTemporaryFile(delete=False, suffix=suffix, prefix=prefix)
    tf.write(content)
    tf.close()
    return tf.name


def test_tender_data(intervals, periods=("enquiry", "tender"), number_of_items=1, number_of_lots=0, meat=False):
    now = get_now()
    value_amount = round(random.uniform(3000, 99999999999.99), 2)  # max value equals to budget of Ukraine in hryvnias
    data = {
        "mode": "test",
        "submissionMethodDetails": "quick",
        "description": fake.description(),
        "description_en": fake_en.sentence(nb_words=10, variable_nb_words=True),
        "description_ru": fake_ru.sentence(nb_words=10, variable_nb_words=True),
        "title": fake.title(),
        "title_en": fake_en.catch_phrase(),
        "title_ru": fake_ru.catch_phrase(),
        "procuringEntity": deepcopy(fake.procuringEntity()),
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
    number_of_lots = int(number_of_lots)
    cpv_group = fake.cpv()[:3]
    if number_of_lots:
        data['lots'] = []
        for lot_number in range(number_of_lots):
            lot_id = uuid4().hex
            new_lot = test_lot_data(data['value']['amount'])
            data['lots'].append(new_lot)
            data['lots'][lot_number]['id'] = lot_id
            for i in range(number_of_items):
                new_item = test_item_data(cpv_group)
                data['items'].append(new_item)
                data['items'][lot_number]['relatedLot'] = lot_id
        value_amount = sum(lot['value']['amount'] for lot in data['lots'])
        minimalStep = min(lot['minimalStep']['amount'] for lot in data['lots'])
        data['value']['amount'] = value_amount
        data['minimalStep']['amount'] = minimalStep
    else:
        for i in range(number_of_items):
            new_item = test_item_data(cpv_group)
            data['items'].append(new_item)
    if meat:
        data['features'] = [
            {
                "code": uuid4().hex,
                "featureOf": "tenderer",
                "title": field_with_id("f", fake.title()),
                "description": fake.description(),
                "enum": [
                    {
                        "value": 0.15,
                        "title": fake.word()
                    },
                    {
                        "value": 0.10,
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
            }
        ]
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


def test_question_data():
    return munchify({
        "data": {
            "author": fake.procuringEntity(),
            "description": fake.description(),
            "title": field_with_id("q", fake.title())
        }
    })


def test_related_question(question, relation, obj_id):
    question.data.update({"questionOf": relation, "relatedItem": obj_id})
    return munchify(question)


def test_question_answer_data():
    return munchify({
        "data": {
            "answer": fake.sentence(nb_words=40, variable_nb_words=True)
        }
    })


def test_complaint_data(lot=False):
    data = munchify({
        "data": {
            "author": fake.procuringEntity(),
            "description": fake.description(),
            "title": fake.title()
        }
    })
    if lot:
        data = test_lot_complaint_data(data)
    return data


test_claim_data = test_complaint_data


def test_claim_answer_data():
    return munchify({
        "data": {
            "status": "answered",
            "resolutionType": "resolved",
            "tendererAction": fake.sentence(nb_words=10, variable_nb_words=True),
            "resolution": fake.sentence(nb_words=15, variable_nb_words=True)
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


def test_bid_data():
    bid = munchify({
        "data": {
            "tenderers": [
                fake.procuringEntity()
            ]
        }
    })
    bid.data.tenderers[0].address.countryName_en = translate_country_en(bid.data.tenderers[0].address.countryName)
    bid.data.tenderers[0].address.countryName_ru = translate_country_ru(bid.data.tenderers[0].address.countryName)
    return bid


def test_bid_value(max_value_amount):
    return munchify({
        "value": {
            "currency": "UAH",
            "amount": round(random.uniform(1, max_value_amount), 2),
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
        }
    ]


def test_lot_data(max_value_amount):
    value_amount = round(random.uniform(1, max_value_amount), 2)
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


def test_lot_complaint_data(complaint, lot_id):
    complaint.data.update({"complaintOf": "lot", "relatedItem": lot_id})
    return munchify(complaint)


def test_tender_data_openua(intervals, number_of_items, number_of_lots, meat):
    accelerator = intervals['accelerator']
    # Since `accelerator` field is not really a list containing timings
    # for a period called `acceleratorPeriod`, let's remove it :)
    del intervals['accelerator']
    # We should not provide any values for `enquiryPeriod` when creating
    # an openUA or openEU procedure. That field should not be present at all.
    # Therefore, we pass a nondefault list of periods to `test_tender_data()`.
    data = test_tender_data(intervals, ('tender',), number_of_items, number_of_lots, meat)
    data['procurementMethodType'] = 'aboveThresholdUA'
    data['procurementMethodDetails'] = 'quick, ' \
        'accelerator={}'.format(accelerator)
    data['procuringEntity']['kind'] = 'general'
    return data


def test_tender_data_openeu(intervals, number_of_items, number_of_lots, meat):
    accelerator = intervals['accelerator']
    # Since `accelerator` field is not really a list containing timings
    # for a period called `acceleratorPeriod`, let's remove it :)
    del intervals['accelerator']
    # We should not provide any values for `enquiryPeriod` when creating
    # an openUA or openEU procedure. That field should not be present at all.
    # Therefore, we pass a nondefault list of periods to `test_tender_data()`.
    data = test_tender_data(intervals, ('tender',), number_of_items, number_of_lots, meat)
    data['procurementMethodType'] = 'aboveThresholdEU'
    data['procurementMethodDetails'] = 'quick, ' \
        'accelerator={}'.format(accelerator)
    data['title_en'] = "[TESTING]"
    for item_number, item in enumerate(data['items']):
        item['description_en'] = "Test item #{}".format(item_number)
    data['procuringEntity']['name_en'] = fake_en.name()
    data['procuringEntity']['contactPoint']['name_en'] = fake_en.name()
    data['procuringEntity']['contactPoint']['availableLanguage'] = "en"
    data['procuringEntity']['identifier']['legalName_en'] = "Institution \"Vinnytsia City Council primary and secondary general school № 10\""
    data['procuringEntity']['kind'] = 'general'
    return data
