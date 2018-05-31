# -*- coding: utf-8 -
from datetime import timedelta
from faker import Factory
from faker.providers.company.en_US import Provider as CompanyProviderEnUs
from faker.providers.company.ru_RU import Provider as CompanyProviderRuRu
from munch import munchify
from uuid import uuid4
from tempfile import NamedTemporaryFile
from .local_time import get_now
from op_faker import OP_Provider
import os
import random


fake_en = Factory.create(locale='en_US')
fake_ru = Factory.create(locale='ru_RU')
fake_uk = Factory.create(locale='uk_UA')
fake_uk.add_provider(OP_Provider)
fake = fake_uk

# This workaround fixes an error caused by missing "catch_phrase" class method
# for the "ru_RU" locale in Faker >= 0.7.4
fake_ru.add_provider(CompanyProviderEnUs)
fake_ru.add_provider(CompanyProviderRuRu)


def create_fake_sentence():
    return fake.sentence(nb_words=10, variable_nb_words=True)


def create_fake_tenderAttempts(attempt):
    if attempt == 1:
        return random.choice([2, 3, 4])
    else:
        return 1


def create_fake_title(language):
    title = {
            u'ua': u"[ТЕСТУВАННЯ] {}".format(fake.title()),
            u'ru': u"[ТЕСТИРОВАНИЕ] {}".format(fake_ru.sentence(nb_words=2), variable_nb_words=True),
            u'en': u"[TESTING] {}".format(fake_en.sentence(nb_words=2), variable_nb_words=True)
    }
    return title[language]


def create_fake_description(language):
    description = {
            u'ua': fake.sentence(nb_words=10, variable_nb_words=True),
            u'ru': fake_ru.sentence(nb_words=10, variable_nb_words=True),
            u'en': fake_en.sentence(nb_words=10, variable_nb_words=True)
    }
    return description[language]


def create_fake_dgfID():
    return fake.dgfID()


def create_fake_decisionDate():
    return (get_now() - timedelta(days=2)).isoformat()


def create_fake_decisionID():
    return fake.dgfDecisionID()


def create_fake_date():
    return (get_now() + timedelta(days=2)).isoformat()


def convert_days_to_seconds(days, accelerator):
    seconds = timedelta(days=int(days)).total_seconds()
    return seconds / accelerator


def create_fake_amount(min_value, max_value):
    return round(random.uniform(min_value, max_value), 2)


def create_fake_value(value_amount):
    return round(random.uniform(0.5, 0.999) * value_amount, 2)


def create_fake_minimal_step(value_amount):
    return round(random.uniform(0.01, 0.1) * value_amount, 2)


def create_fake_guarantee(value_amount):
    # Required guarantee deposit must not be greater than 500 000 UAH
    return round(random.uniform(0.02, 0.1) * value_amount, 2)


def create_fake_item_description():
    return field_with_id("i", fake.title())


def create_fake_scheme_id(scheme_id):
    return fake.scheme_other(scheme_id)


def create_fake_items_quantity():
    return round(random.uniform(5, 10), 4)


def cretate_fake_unit_name():
    return random.choice([u'гектар', u'кілометри', u'штуки', u'блок', u'метри кубічні'])


def create_fake_cancellation_reason():
    reasons = [u"Згідно рішення виконавчої дирекції Замовника",
               u"Порушення порядку публікації оголошення"]
    return random.choice(reasons)


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
    return tf.name, os.path.basename(tf.name), content


def create_fake_image():
    # TODO: Move this code (as well as other "fake" stuff in this file)
    # into op_faker
    # Also, this doesn't create any images for now; instead,
    # pre-generated ones are used.
    image_format = fake.random_element(('jpg', 'png'))
    return os.path.abspath(os.path.join(os.path.dirname(__file__),
                                        'op_faker',
                                        'illustration.' + image_format))


def create_fake_url():
    """
    Generate fake valid URL for VDR and technicalSpecifications
    randomize size, font and background color for image.
    Example: https://dummyimage.com/700x400/964f96/363636
    """
    base = 'https://dummyimage.com'
    background_color = ''.join([random.choice('0123456789ABCDEF') for _ in range(6)])
    font_color = ''.join([random.choice('0123456789ABCDEF') for _ in range(6)])
    size_x =  random.randint(10, 1000)
    size_y =  random.randint(10, 1000)
    return '{0}/{1}x{2}/{3}/{4}.png'.format(base, size_x, size_y, background_color, font_color)


def test_tender_data(params, periods=("enquiry", "tender")):
    now = get_now()
    value_amount = create_fake_amount(3000, 999999999.99)  # max value equals to budget of Ukraine in hryvnias

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
            "valueAddedTaxIncluded": False
        },
        "guarantee": {
            "amount": create_fake_guarantee(value_amount),
            "currency": u"UAH"
        },
        "minimalStep": {
            "amount": create_fake_minimal_step(value_amount),
            "currency": u"UAH",
            "valueAddedTaxIncluded": False
        },
        "items": [],
    }

    accelerator = params['intervals']['accelerator']
    data['procurementMethodDetails'] = 'quick, ' \
        'accelerator={}'.format(accelerator)

    data["procuringEntity"]["kind"] = "other"

    data['rectificationPeriod'] = {
            "endDate": (get_now() + timedelta(minutes=(random.randint(5, 19) * 1440) / accelerator)).isoformat(),
    }

    scheme_group = fake.scheme_other()[:4]
    for i in range(params['number_of_items']):
        new_item = test_item_data(scheme_group)
        data['items'].append(new_item)

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
            period_dict[period_name + "Period"][j + "Date"] = inc_dt.isoformat()
    data.update(period_dict)

    return munchify(data)


def test_asset_data(params):
    test_asset_data = {
        "title": u"[ТЕСТУВАННЯ] {}".format(fake.title()),
        "title_en": u"[TESTING] {}".format(fake_en.catch_phrase()),
        "title_ru": u"[ТЕСТИРОВАНИЕ] {}".format(fake_ru.catch_phrase()),
        "description": fake.description(),
        "description_en": fake_en.sentence(nb_words=10, variable_nb_words=True),
        "description_ru": fake_ru.sentence(nb_words=10, variable_nb_words=True),
        "assetType": 'domain',
        "mode": "test",
        "items": [],
        "decisions": [{
            "title": fake.title(),
            "title_en": fake_en.catch_phrase(),
            "title_ru": fake_ru.catch_phrase(),
            "decisionDate": create_fake_decisionDate(),
            "decisionID": create_fake_decisionID()
        }],
        "assetCustodian": fake.procuringEntity(),
        "assetHolder": fake.procuringEntity(),
    }
    scheme_group = fake.scheme_other()[:3]
    for i in range(params['number_of_items']):
        new_item = test_item_data(scheme_group)
        new_item["registrationDetails"]= {
            "status": 'complete'
    }
        test_asset_data['items'].append(new_item)
    return munchify(test_asset_data)


def test_lot_data(params):
    lot_data = {
        "lotType": "yoke",
        "decisions": [{
            "decisionDate": create_fake_decisionDate(),
            "decisionID": create_fake_decisionID()
        }],
        "mode": "test"
    }
    return munchify(lot_data)


def update_lot_data(lot_data, asset_id):
    lot_data["data"].update({"assets": asset_id})
    return munchify(lot_data)


def test_lot_auctions_data(lot_data, index):
    if index == '0':
        value_amount = create_fake_amount(3000, 999999999.99)
        lot_data.update({
            "value": {
                "amount": value_amount,
                "currency": u"UAH",
                "valueAddedTaxIncluded": False
            },
            "guarantee": {
                "amount": create_fake_guarantee(value_amount),
                "currency": u"UAH"
            },
            "minimalStep": {
                "amount": create_fake_minimal_step(value_amount),
                "currency": u"UAH",
                "valueAddedTaxIncluded": False
            },
            "registrationFee": {
                "amount": create_fake_guarantee(value_amount),
                "currency": u"UAH"
            },
            "auctionPeriod": {
                "startDate": create_fake_date()
            }
        })
    else:
        lot_data.update({
            "tenderingDuration": 'P1M'
        })
    return munchify(lot_data)


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


def test_confirm_data(id):
    return munchify({
        "data": {
            "status": "active",
            "id": id
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


def test_bid_value(max_value_amount, minimalStep):
    return munchify({
        "value": {
            "currency": "UAH",
            "amount": round(random.uniform(1, 1.05)*(max_value_amount + minimalStep), 2),
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


def test_item_data(scheme):
    #using typical functions for dgf other and all other modes besides dgf financial
    #items will be genareted from other CAV-PS group
    data = fake.fake_item(scheme)

    data["description"] = field_with_id("i", data["description"])
    data["description_en"] = field_with_id("i", data["description_en"])
    data["description_ru"] = field_with_id("i", data["description_ru"])
    data["quantity"] = round(random.uniform(1, 5), 4)
    return munchify(data)


def test_tender_data_dgf_other(params):
    data = test_tender_data(params, [])

    data['dgfID'] = fake.dgfID()
    data['tenderAttempts'] = fake.random_int(min=1, max=4)
    data['minNumberOfQualifiedBids'] = int(params['minNumberOfQualifiedBids'])
    del data["procuringEntity"]

    for i in range(params['number_of_items']):
        data['items'].pop()

    url = params['api_host_url']
    if url == 'https://lb.api.ea.openprocurement.org':
        del data['procurementMethodDetails']

    period_dict = {}
    inc_dt = get_now()
    period_dict["auctionPeriod"] = {}
    inc_dt += timedelta(minutes=params['intervals']['auction'][0])
    period_dict["auctionPeriod"]["startDate"] = inc_dt.isoformat()
    data.update(period_dict)

    data['procurementMethodType'] = 'dgfOtherAssets'
    data["procuringEntity"] = fake.procuringEntity_other()

    for i in range(params['number_of_items']):
        scheme_group_other = fake.scheme_other()[:4]
        new_item = test_item_data(scheme_group_other)
        data['items'].append(new_item)
    return data
