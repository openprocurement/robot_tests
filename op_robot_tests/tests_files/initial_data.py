# -*- coding: utf-8 -
import os
import random
import hashlib
from datetime import timedelta
from tempfile import NamedTemporaryFile
from uuid import uuid4
from faker import Factory
from faker.providers.company.en_US import Provider as CompanyProviderEnUs
from faker.providers.company.ru_RU import Provider as CompanyProviderRuRu
from munch import munchify
from op_faker import OP_Provider
from .local_time import get_now, TZ


fake_en = Factory.create(locale='en_US')
fake_ru = Factory.create(locale='ru_RU')
fake_uk = Factory.create(locale='uk_UA')
fake_uk.add_provider(OP_Provider)
fake = fake_uk
used_identifier_id = []
mode_open = ["belowThreshold", "aboveThresholdUA", "aboveThresholdEU",
            "aboveThresholdUA.defense", "competitiveDialogueUA", "competitiveDialogueEU", "esco"]
mode_limited = ["reporting", "negotiation.quick", "negotiation"]

# This workaround fixes an error caused by missing "catch_phrase" class method
# for the "ru_RU" locale in Faker >= 0.7.4
fake_ru.add_provider(CompanyProviderEnUs)
fake_ru.add_provider(CompanyProviderRuRu)


def create_fake_sentence():
    return fake.sentence(nb_words=10, variable_nb_words=True)


def create_fake_funder():
    return fake.funders_data()


def get_fake_funder_scheme():
    return fake.funder_scheme()


def create_fake_amount(award_amount):
    return round(random.uniform(1, award_amount), 2)


def create_fake_number(min_number, max_number):
    return random.randint(int(min_number), int(max_number))


def create_fake_title():
    return u"[ТЕСТУВАННЯ] {}".format(fake.title())


def create_fake_date():
    return get_now().isoformat()


def subtraction(value1, value2):
    if "." in str (value1) or "." in str (value2):
        return (float (value1) - float (value2))
    else:
        return (int (value1) - int (value2))


def create_fake_value_amount():
    return fake.random_int(min=1)

def get_number_of_minutes(days, accelerator):
    return 1440 * int(days) / accelerator

def field_with_id(prefix, sentence):
    return u"{}-{}: {}".format(prefix, fake.uuid4()[:8], sentence)


def translate_country_en(country):
    if country == u"Україна":
        return "Ukraine"
    else:
        raise Exception(u"Cannot translate country to english: {}".format(country))


def convert_amount(amount):
    return  (("{:,}".format(float (amount))).replace(',',' ').replace('.',','))


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
    return tf.name.replace('\\', '\\\\'), os.path.basename(tf.name), content


def test_tender_data(params,
                     periods=("enquiry", "tender"),
                     submissionMethodDetails=None,
                     funders=None,
                     accelerator=None):
    submissionMethodDetails = submissionMethodDetails \
        if submissionMethodDetails else "quick"
    now = get_now()
    value_amount = round(random.uniform(3000, 99999999.99), 2)  # max value equals to budget of Ukraine in hryvnias
    data = {
        "mode": "test",
        "submissionMethodDetails": submissionMethodDetails,
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
        "items": [],
        "features": []
    }
    accelerator = accelerator \
        if accelerator else params['intervals']['accelerator']
    data['procurementMethodDetails'] = 'quick, ' \
        'accelerator={}'.format(accelerator)
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
            inc_dt += timedelta(minutes=params['intervals'][period_name][i])
            period_dict[period_name + "Period"][j + "Date"] = inc_dt.astimezone(TZ).isoformat()
    data.update(period_dict)
    if params.get('moz_integration'):
        cpv_group = 336
    else:
        cpv_group = fake.cpv()[:4]
    if params.get('number_of_lots'):
        data['lots'] = []
        for lot_number in range(params['number_of_lots']):
            lot_id = uuid4().hex
            new_lot = test_lot_data(data['value']['amount'])
            data['lots'].append(new_lot)
            data['lots'][lot_number]['id'] = lot_id
            for i in range(params['number_of_items']):
                new_item = test_item_data(cpv_group)
                new_item['relatedLot'] = lot_id
                data['items'].append(new_item)
        value_amount = round(sum(lot['value']['amount'] for lot in data['lots']), 2)
        minimalStep = min(lot['minimalStep']['amount'] for lot in data['lots'])
        data['value']['amount'] = value_amount
        data['minimalStep']['amount'] = minimalStep
        if params.get('lot_meat'):
            new_feature = test_feature_data()
            new_feature['featureOf'] = "lot"
            data['lots'][0]['id'] = data['lots'][0].get('id', uuid4().hex)
            new_feature['relatedItem'] = data['lots'][0]['id']
            data['features'].append(new_feature)
    else:
        for i in range(params['number_of_items']):
            new_item = test_item_data(cpv_group)
            data['items'].append(new_item)
    if params.get('tender_meat'):
        new_feature = test_feature_data()
        new_feature.featureOf = "tenderer"
        data['features'].append(new_feature)
    if params.get('item_meat'):
        new_feature = test_feature_data()
        new_feature['featureOf'] = "item"
        data['items'][0]['id'] = data['items'][0].get('id', uuid4().hex)
        new_feature['relatedItem'] = data['items'][0]['id']
        data['features'].append(new_feature)
    if not data['features']:
        del data['features']
    if funders is not None:
        data['funders'] = [fake.funders_data() for _ in range(int(funders))]
    data['status'] = 'draft'
    return munchify(data)


def test_tender_data_planning(params):
    data = {
        "budget": {
            "amountNet": round(random.uniform(3000, 999999999.99), 2),
            "description": fake.description(),
            "project": {
                "id": str(fake.random_int(min=1, max=999)),
                "name": fake.description(),
            },
            "currency": "UAH",
            "amount": round(random.uniform(3000, 99999999999.99), 2),
            "id": str(fake.random_int(min=1, max=99999999999)) + "-" + str(fake.random_int(min=1, max=9)),
        },
        "procuringEntity": {
            "identifier": {
                "scheme": "UA-EDR",
                "id": str(fake.random_int(min=1, max=999)),
                "legalName": fake.description(),
            },
            "name": fake.description(),
        },
        "tender": {
            "procurementMethod": "",
            "procurementMethodType": params['mode'],
            "tenderPeriod": {
                "startDate": get_now().replace(hour=0, minute=0, second=0, microsecond=0).isoformat()
            }
        },
        "items": []
        }
    id_cpv=fake.cpv()[:4]
    cpv_data=test_item_data(id_cpv)
    data.update(cpv_data)
    del data['deliveryDate']
    del data['description']
    del data['description_en']
    del data['description_ru']
    del data['deliveryAddress']
    del data['deliveryLocation']
    del data['quantity']
    del data['unit']
    for i in range(params['number_of_items']):
        item_data=test_item_data(id_cpv)
        del item_data['deliveryAddress']
        del item_data['deliveryLocation']
        item_data['deliveryDate']['endDate'] = (get_now() + timedelta(days=10)).replace(hour=0, minute=0, second=0, microsecond=0).isoformat()
        del item_data['deliveryDate']['startDate']
        data['items'].append(item_data)
    if params['mode'] in mode_open:
        data["tender"]["procurementMethod"] = "open"
    if params['mode'] in mode_limited:
        data["tender"]["procurementMethod"] = "limited"
    return munchify(data)


def test_tender_data_limited(params):
    data = test_tender_data(params)
    del data["submissionMethodDetails"]
    del data["minimalStep"]
    del data["enquiryPeriod"]
    del data["tenderPeriod"]
    for lot in data.get('lots', []):
        lot.pop('minimalStep', None)
    data["procuringEntity"]["kind"] = "general"
    data.update({"procurementMethodType": params['mode'], "procurementMethod": "limited"})
    if params['mode'] == "negotiation":
        cause_variants = (
            "artContestIP",
            "noCompetition",
            "twiceUnsuccessful",
            "additionalPurchase",
            "additionalConstruction",
            "stateLegalServices"
        )
        cause = fake.random_element(cause_variants)
    elif params['mode'] == "negotiation.quick":
        cause_variants = ('quick',)
    if params['mode'] in ("negotiation", "negotiation.quick"):
        cause = fake.random_element(cause_variants)
        data.update({
            "cause": cause,
            "causeDescription": fake.description()
        })
    return munchify(data)


def test_feature_data():
    return munchify({
        "code": uuid4().hex,
        "title": field_with_id("f", fake.title()),
        "title_en": field_with_id('f', fake_en.sentence(nb_words=5, variable_nb_words=True)),
        "title_ru": field_with_id('f', fake_ru.sentence(nb_words=5, variable_nb_words=True)),
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
    })


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


def test_complaint_data():
    data = munchify({
        "data": {
            "author": fake.procuringEntity(),
            "description": fake.description(),
            "title": fake.title()
        }
    })
    return data


test_claim_data = test_complaint_data


def test_claim_answer_data(status):
    return munchify({
        "data": {
            "status": "answered",
            "resolutionType": status,
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


def test_bid_competitive_data():
    bid = munchify({
        "data": {
            "tenderers": [
                fake.procuringEntity()
            ]
        }
    })
    if len(used_identifier_id) == 3:
        del used_identifier_id[0]
    id = bid.data.tenderers[0].identifier.id
    while (id in used_identifier_id):
        bid = munchify({
            "data": {
                "tenderers": [
                    fake.procuringEntity()
                ]
            }
        })
        id = bid.data.tenderers[0].identifier.id
    used_identifier_id.append(id)
    bid.data.tenderers[0].address.countryName_en = translate_country_en(bid.data.tenderers[0].address.countryName)
    bid.data.tenderers[0].address.countryName_ru = translate_country_ru(bid.data.tenderers[0].address.countryName)
    bid.data['status'] = 'draft'
    return bid


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
    bid.data['status'] = 'draft'
    return bid


def test_bid_value(max_value_amount):
    return munchify({
        "value": {
            "currency": "UAH",
            "amount": round(random.uniform((0.95 * max_value_amount), max_value_amount), 2),
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
            },
            "qualified": True
        }
    })


def test_item_data(cpv=None):
    data = fake.fake_item(cpv)
    data["description"] = field_with_id("i", data["description"])
    data["description_en"] = field_with_id("i", data["description_en"])
    data["description_ru"] = field_with_id("i", data["description_ru"])
    startDate = fake.random_int(min=1, max=30)
    endDate = startDate + fake.random_int(min=1, max=7)
    data["deliveryDate"] = {
        "startDate": (get_now() + timedelta(days=startDate)).replace(hour=0, minute=0, second=0, microsecond=0).isoformat(),
        "endDate": (get_now() + timedelta(days=endDate)).replace(hour=0, minute=0, second=0, microsecond=0).isoformat()
    }
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
            "title_en": field_with_id('l', fake_en.sentence(nb_words=5, variable_nb_words=True)),
            "title_ru": field_with_id('l', fake_ru.sentence(nb_words=5, variable_nb_words=True)),
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

def test_change_document_data(document, change_id):
    document.data.update({"documentOf": "change", "relatedItem": change_id})
    return munchify(document)


def test_tender_data_openua(params, submissionMethodDetails):
    # We should not provide any values for `enquiryPeriod` when creating
    # an openUA or openEU procedure. That field should not be present at all.
    # Therefore, we pass a nondefault list of periods to `test_tender_data()`.
    data = test_tender_data(params, ('tender',), submissionMethodDetails)
    data['procurementMethodType'] = 'aboveThresholdUA'
    data['procuringEntity']['kind'] = 'general'
    return data


def test_tender_data_openua_defense(params, submissionMethodDetails):
    """We should not provide any values for `enquiryPeriod` when creating
    an openUA, openEU or openUA_defense procedure. That field should not be present at all.
    Therefore, we pass a nondefault list of periods to `test_tender_data()`."""
    data = test_tender_data(params, ('tender',), submissionMethodDetails)
    data['procurementMethodType'] = 'aboveThresholdUA.defense'
    data['procuringEntity']['kind'] = 'defense'
    return data


def test_tender_data_openeu(params, submissionMethodDetails):
    # We should not provide any values for `enquiryPeriod` when creating
    # an openUA or openEU procedure. That field should not be present at all.
    # Therefore, we pass a nondefault list of periods to `test_tender_data()`.
    data = test_tender_data(params, ('tender',), submissionMethodDetails)
    data['procurementMethodType'] = 'aboveThresholdEU'
    data['title_en'] = "[TESTING]"
    for item_number, item in enumerate(data['items']):
        item['description_en'] = "Test item #{}".format(item_number)
    data['procuringEntity']['name_en'] = fake_en.name()
    data['procuringEntity']['contactPoint']['name_en'] = fake_en.name()
    data['procuringEntity']['contactPoint']['availableLanguage'] = "en"
    data['procuringEntity']['identifier']['legalName_en'] = u"Institution \"Vinnytsia City Council primary and secondary general school № 10\""
    data['procuringEntity']['kind'] = 'general'
    return data


def test_tender_data_competitive_dialogue(params, submissionMethodDetails):
    # We should not provide any values for `enquiryPeriod` when creating
    # an openUA or openEU procedure. That field should not be present at all.
    # Therefore, we pass a nondefault list of periods to `test_tender_data()`.
    data = test_tender_data(params, ('tender',), submissionMethodDetails)
    if params.get('dialogue_type') == 'UA':
        data['procurementMethodType'] = 'competitiveDialogueUA'
    else:
        data['procurementMethodType'] = 'competitiveDialogueEU'
        data['procuringEntity']['contactPoint']['availableLanguage'] = "en"
    data['title_en'] = "[TESTING] {}".format(fake_en.sentence(nb_words=3, variable_nb_words=True))
    for item in data['items']:
        item['description_en'] = fake_en.sentence(nb_words=3, variable_nb_words=True)
    data['procuringEntity']['name_en'] = fake_en.name()
    data['procuringEntity']['contactPoint']['name_en'] = fake_en.name()
    data['procuringEntity']['identifier']['legalName_en'] = fake_en.sentence(nb_words=10, variable_nb_words=True)
    data['procuringEntity']['kind'] = 'general'
    return data


def test_change_data():
    return munchify(
    {
        "data":
        {
            "rationale": fake.description(),
            "rationale_en": fake_en.sentence(nb_words=10, variable_nb_words=True),
            "rationale_ru": fake_ru.sentence(nb_words=10, variable_nb_words=True),
            "rationaleTypes": fake.rationaleTypes(amount=3), 
            "status": "pending"
        }
    })


def get_hash(file_contents):
    return ("md5:"+hashlib.md5(file_contents).hexdigest())