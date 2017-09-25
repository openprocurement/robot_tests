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
# This workaround fixes an error caused by missing "catch_phrase" class method
# for the "ru_RU" locale in Faker >= 0.7.4
fake_ru.add_provider(CompanyProviderEnUs)
fake_ru.add_provider(CompanyProviderRuRu)


def create_fake_sentence():
    return fake.sentence(nb_words=10, variable_nb_words=True)


def create_fake_amount(award_amount):
    return round(random.uniform(1, award_amount), 2)


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
    data['status'] = 'active.tendering'
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
    bid.data['status'] = 'pending'
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
    bid.data['status'] = 'pending'
    return bid


def test_bid_value(tender_data):
    annual_cost = []
    for i in range(0, 21):
        cost=float(round(random.uniform(1, 100), 2))
        annual_cost.append(cost)
    if tender_data['fundingKind'] == "budget":
        yearly_percentage=float(round(random.uniform(0.01, float(tender_data['yearlyPaymentsPercentageRange'])), 3))
    else:
        yearly_percentage= 0.8
    bid = munchify({
        "value": {
            "currency": "UAH",
            "valueAddedTaxIncluded": True,
            "yearlyPaymentsPercentage": yearly_percentage,
            "annualCostsReduction": annual_cost,
            "contractDuration": {
                "years": int(random.uniform(1, 15)),
                "days": int(random.uniform(1, 364))
            }
        }
    })
    return bid


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
    days = fake.random_int(min=1, max=30)
    data["deliveryDate"] = {
        "startDate": (get_now() + timedelta(days=days)).astimezone(TZ).isoformat(),
        "endDate": (get_now() + timedelta(days=days)).astimezone(TZ).isoformat()
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


def test_tender_data_esco(params):
    data = test_tender_data(params, ('tender',))
    data['procurementMethodType'] = 'esco'
    data['title_en'] = "[TESTING]"
    for item_number, item in enumerate(data['items']):
        item['description_en'] = "Test item #{}".format(item_number)
    data.update({"procurementMethodType": params['mode'], "procurementMethod": "open"})
    data['procuringEntity']['name_en'] = fake_en.name()
    data['procuringEntity']['contactPoint']['name_en'] = fake_en.name()
    data['procuringEntity']['contactPoint']['availableLanguage'] = "en"
    data['procuringEntity']['identifier']['legalName_en'] = fake_en.sentence(nb_words=10, variable_nb_words=True)
    data['procuringEntity']['kind'] = 'general'
    data['minimalStepPercentage'] = float(round(random.uniform(0.015, 0.03), 3))
    funding_variants = (
        "budget",
        "other"
        )
    data['fundingKind'] = fake.random_element(funding_variants)
    data['NBUdiscountRate'] = float(round(random.uniform(0, 0.99), 3))
    del data["value"]
    del data['submissionMethodDetails']
    del data["minimalStep"]
    if params['number_of_lots'] == 0:
        if data['fundingKind'] == "budget":
            data['yearlyPaymentsPercentageRange'] = float(round(random.uniform(0.01, 0.8), 3))
        else:
            data['yearlyPaymentsPercentageRange'] = 0.8
    for index in range(params['number_of_lots']):
        data['lots'][index]['fundingKind'] = data['fundingKind']
        data['lots'][index]['minimalStepPercentage'] = round((float(data['minimalStepPercentage'])/(index+1)), 3)
        if data['fundingKind'] == "budget":
            data['lots'][index]['yearlyPaymentsPercentageRange'] = float(round(random.uniform(0.01, 0.8), 3))
        else:
            data['lots'][index]['yearlyPaymentsPercentageRange'] = 0.8
        del data['lots'][index]['value']
        del data['lots'][index]['minimalStep']
    for index in range(params['number_of_items']):
        del data['items'][index]['deliveryDate']
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