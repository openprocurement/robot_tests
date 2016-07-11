# -*- coding: utf-8 -
from datetime import timedelta
from faker import Factory
from munch import munchify
from tempfile import NamedTemporaryFile
from .local_time import get_now
import random

fake = Factory.create('uk_UA')
fake_ru = Factory.create('ru')
fake_en = Factory.create()


def create_fake_sentence():
    return fake.sentence(nb_words=10, variable_nb_words=True)


def field_with_id(prefix, sentence):
    return "{}-{}: {}".format(prefix, fake.uuid4()[:8], sentence)


def create_fake_doc():
    content = fake.text()
    suffix = fake.random_element(('.doc', '.docx', '.pdf'))
    tf = NamedTemporaryFile(delete=False, suffix=suffix)
    tf.write(content)
    tf.close()
    return tf.name


def test_tender_data(intervals, periods=("enquiry", "tender")):
    now = get_now()
    value_amount = 50000.99
    t_data = {
        "title": u"[ТЕСТУВАННЯ] " + fake.catch_phrase(),
        "mode": "test",
        "submissionMethodDetails": "quick",
        "description": u"Тестовий тендер",
        "description_ru": u"Тестовый тендер",
        "description_en": "Test tender",
        "procuringEntity": {
            "name": fake.company(),
            "name_ru": fake_ru.company(),
            "name_en": fake_en.company(),
            "identifier": {
                "scheme": u"UA-EDR",
                "id": u"{:08d}".format(fake.pyint()),
                "uri": fake.image_url(width=None, height=None)
            },
            "address": {
                "countryName": u"Україна",
                "countryName_ru": u"Украина",
                "countryName_en": "Ukraine",
                "postalCode": fake.postalcode(),
                "region": u"м. Київ",
                "locality": u"м. Київ",
                "streetAddress": fake.street_address()
            },
            "contactPoint": {
                "name": fake.name(),
                "telephone": fake.phone_number()
            },
        },
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
    new_item = test_item_data()
    t_data['items'].append(new_item)
    period_dict = {}
    inc_dt = now
    for period_name in periods:
        period_dict[period_name + "Period"] = {}
        for i, j in zip(range(2), ("start", "end")):
            inc_dt += timedelta(minutes=intervals[period_name][i])
            period_dict[period_name + "Period"][j + "Date"] = inc_dt.isoformat()
    t_data.update(period_dict)
    return t_data


def test_tender_data_limited(intervals, procurement_method_type):
    now = get_now()
    data = {
        "items":
        [
            {
                "classification":
                {
                    "description": u"Послуги з організації шкільного харчування",
                    "id": "55523100-3",
                    "scheme": "CPV"
                },
                "description": field_with_id('i', fake.sentence(nb_words=10, variable_nb_words=True)),
                "id": "2dc54675d6364e2baffbc0f8e74432ac",
                "deliveryDate": {
                    "endDate": (now + timedelta(days=5)).isoformat()
                },
                "deliveryLocation": {
                    "latitude": 49.8500,
                    "longitude": 24.0167
                },
                "deliveryAddress": {
                    "countryName": u"Україна",
                    "countryName_ru": u"Украина",
                    "countryName_en": "Ukraine",
                    "postalCode": fake.postalcode(),
                    "region": u"м. Київ",
                    "locality": u"м. Київ",
                    "streetAddress": fake.street_address()
                }
            }
        ],
        "mode": "test",
        "procurementMethod": "limited",
        "procurementMethodType": procurement_method_type,
        "procuringEntity":
        {
            "address":
            {
                "countryName": u"Україна",
                "locality": u"м. Вінниця",
                "postalCode": "21027",
                "region": u"м. Вінниця",
                "streetAddress": u"вул. Стахурського. 22"
            },
            "contactPoint":
            {
                "name": u"Куца Світлана Валентинівна",
                "telephone": "+380 (432) 46-53-02",
                "url": "http://sch10.edu.vn.ua/"
            },
            "identifier":
            {
                "id": "21725150",
                "legalName": u"Заклад \"Загальноосвітня школа І-ІІІ ступенів № 10 Вінницької міської ради\"",
                "scheme": u"UA-EDR"
            },
            "name": u"ЗОСШ #10 м.Вінниці",
            "kind": "general"
        },
        "value": {
            "amount": 500000,
            "currency": "UAH",
            "valueAddedTaxIncluded": True
        },
        "description": fake.sentence(nb_words=10, variable_nb_words=True),
        "description_en": fake.sentence(nb_words=10, variable_nb_words=True),
        "description_ru": fake.sentence(nb_words=10, variable_nb_words=True),
        "title": fake.catch_phrase(),
        "title_en": fake.catch_phrase(),
        "title_ru": fake.catch_phrase()
    }
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
    if procurement_method_type == "negotiation" \
            or procurement_method_type == "negotiation.quick":
        data.update({
            "procurementMethodDetails": "quick, accelerator=1440",
            "causeDescription": fake.sentence(nb_words=10, variable_nb_words=True)
        })
    return data


def test_tender_data_multiple_items(intervals):
    t_data = test_tender_data(intervals)
    for _ in range(4):
        new_item = test_item_data()
        t_data['items'].append(new_item)
    return t_data


def test_tender_data_multiple_lots(intervals):
    tender = test_tender_data(intervals)
    first_lot_id = "3c8f387879de4c38957402dbdb8b31af"
    tender['items'][0]['relatedLot'] = first_lot_id
    tender['lots'] = [test_lot_data()]
    tender['lots'][0]['id'] = first_lot_id
    return tender


def test_tender_data_meat(intervals):
    tender = munchify(test_tender_data(intervals))
    item_id = "edd0032574bf4402877ad5f362df225a"
    tender['items'][0].id = item_id
    tender.features = [
        {
            "code": "ee3e24bc17234a41bd3e3a04cc28e9c6",
            "featureOf": "tenderer",
            "title":  field_with_id('f', "Термін оплати"),
            "description": "Умови відстрочки платежу після поставки товару",
            "enum": [
                {
                    "value": 0.15,
                    "title": "180 днів та більше"
                },
                {
                    "value": 0.1,
                    "title": "90-179 днів",
                },
                {
                    "value": 0.05,
                    "title": "30-89 днів"
                },
                {
                    "value": 0,
                    "title": "Менше 30 днів"
                }
            ]
        },
        {
            "code": "48cfd91612c04125ab406374d7cc8d93",
            "featureOf": "item",
            "relatedItem": item_id,
            "title":  field_with_id('f', "Сорт"),
            "description": "Сорт продукції",
            "enum": [
                {
                    "value": 0.05,
                    "title": "Вищий"
                },
                {
                    "value": 0.01,
                    "title": "Перший",
                },
                {
                    "value": 0,
                    "title": "Другий"
                }
            ]
        }
    ]
    return tender


def test_question_data():
    data = munchify({
        "data": {
            "author": {
                "address": {
                    "countryName": u"Україна",
                    "countryName_ru": u"Украина",
                    "countryName_en": "Ukraine",
                    "locality": u"м. Вінниця",
                    "postalCode": "21100",
                    "region": u"Вінницька область",
                    "streetAddress": fake.street_address()
                },
                "contactPoint": {
                    "name": fake.name(),
                    "telephone": fake.phone_number()
                },
                "identifier": {
                    "scheme": u"UA-EDR",
                    "id": u"{:08d}".format(fake.pyint()),
                    "uri": fake.image_url(width=None, height=None)
                },
                "name": fake.company()
            },
            "description": fake.sentence(nb_words=10, variable_nb_words=True),
            "title": field_with_id('q', fake.sentence(nb_words=6, variable_nb_words=True))
        }
    })
    return data


def test_question_answer_data():
    return munchify({
        "data": {
            "answer": fake.sentence(nb_words=40, variable_nb_words=True)
        }
    })


def test_complaint_data(lot=False):
    data = munchify({
        "data": {
            "author": {
                "address": {
                    "countryName": u"Україна",
                    "countryName_ru": u"Украина",
                    "countryName_en": "Ukraine",
                    "locality": u"м. Вінниця",
                    "postalCode": "21100",
                    "region": u"Вінницька область",
                    "streetAddress": fake.street_address()
                },
                "contactPoint": {
                    "name": fake.name(),
                    "telephone": fake.phone_number()
                },
                "identifier": {
                    "scheme": u"UA-EDR",
                    "id": u"{:08d}".format(fake.pyint()),
                    "uri": fake.image_url(width=None, height=None)
                },
                "name": fake.company()
            },
            "description": fake.sentence(nb_words=10, variable_nb_words=True),
            "title": fake.sentence(nb_words=6, variable_nb_words=True)
        }
    })
    if lot:
        data = test_lot_complaint_data(data)
    return data


test_claim_data = test_complaint_data


def test_complaint_answer_data(complaint_id):
    return munchify({
        "data": {
            "id": complaint_id,
            "status": "answered",
            "resolutionType": "resolved",
            "resolution": fake.sentence(nb_words=40, variable_nb_words=True)
        }
    })


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


def test_change_cancellation_document_field_data(key, value):
    return munchify({
        "data": {
            key: value
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
                {
                    "address": {
                        "countryName": u"Україна",
                        "countryName_ru": u"Украина",
                        "countryName_en": "Ukraine",
                        "locality": u"м. Вінниця",
                        "postalCode": "21100",
                        "region": u"Вінницька область",
                        "streetAddress": fake.street_address()
                    },
                    "contactPoint": {
                        "name": fake.name(),
                        "telephone": fake.phone_number()
                    },
                    "identifier": {
                        "scheme": u"UA-EDR",
                        "id": u"{:08d}".format(fake.pyint()),
                    },
                    "name": fake.company()
                }
            ]
        }
    })
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
                    "amount": fake.random_int(min=50001, max=60000),
                    "valueAddedTaxIncluded": True
                }
            })


def test_supplier_data():
    return munchify({
        "data": {
            "suppliers": [
                {
                    "address": {
                        "countryName": u"Україна",
                        "locality": u"м. Вінниця",
                        "postalCode": "21100",
                        "region": u"м. Вінниця",
                        "streetAddress": u"вул. Островського, 33"
                    },
                    "contactPoint": {
                        "email": "soleksuk@gmail.com",
                        "name": u"Сергій Олексюк",
                        "telephone": "+380 (432) 21-69-30"
                    },
                    "identifier": {
                        "id": "13313462",
                        "legalName": u"Державне комунальне підприємство громадського харчування «Школяр»",
                        "scheme": "UA-EDR",
                        "uri": "http://sch10.edu.vn.ua/"
                    },
                    "name": u"ДКП «Школяр»"
                }
            ],
            "value": {
                "amount": 475000,
                "currency": "UAH",
                "valueAddedTaxIncluded": True
            }
        }
    })


def test_award_data():
    return munchify({'data': {}})


def test_item_data():
    now = get_now()
    return munchify({
        "description": field_with_id('i', fake.catch_phrase()),
        "deliveryDate": {
            "endDate": (now + timedelta(days=5)).isoformat()
        },
        "deliveryLocation": {
            "latitude": 49.8500,
            "longitude": 24.0167
        },
        "deliveryAddress": {
            "countryName": u"Україна",
            "countryName_ru": u"Украина",
            "countryName_en": "Ukraine",
            "postalCode": fake.postalcode(),
            "region": u"м. Київ",
            "locality": u"м. Київ",
            "streetAddress": fake.street_address()
        },
        "classification": {
            "scheme": u"CAV",
            "id": u"66113000-5",
            "description": u"Права вимоги"
        },
        "unit": {
            "name": u"кілограми",
            "name_ru": u"килограммы",
            "name_en": "kilogram",
            "code": u"KGM"
        },
        "quantity": fake.pyint()
    })


def test_invalid_features_data():
    return [
        {
            "code": "ee3e24bc17234a41bd3e3a04cc28e9c6",
            "featureOf": "tenderer",
            "title": "Термін оплати",
            "description": "Умови відстрочки платежу після поставки товару",
            "enum": [
                {
                    "value": 0.35,
                    "title": "180 днів та більше"
                },
                {
                    "value": 0,
                    "title": "Менше 30 днів"
                }
            ]
        },
        {
            "code": "48cfd91612c04125ab406374d7cc8d93",
            "featureOf": "item",
            "relatedItem": "edd0032574bf4402877ad5f362df225a",
            "title": "Сорт",
            "description": "Сорт продукції",
            "enum": [
                {
                    "value": 0.35,
                    "title": "Вищий"
                },
                {
                    "value": 0,
                    "title": "Другий"
                }
            ]
        }
    ]


def test_lot_data():
    return munchify(
        {
            "description": fake.sentence(nb_words=10, variable_nb_words=True),
            "title": field_with_id('l', fake.sentence(nb_words=6, variable_nb_words=True)),
            "value": {
                "currency": "UAH",
                "amount": 2000 + fake.pyfloat(left_digits=4, right_digits=1, positive=True),
                "valueAddedTaxIncluded": True
            },
            "minimalStep": {
                "currency": "UAH",
                "amount": 30.0,
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
    return t_data
