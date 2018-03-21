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


def create_fake_title(name):
    if name == 'ua':
        return u"[ТЕСТУВАННЯ] {}".format(fake.sentence(nb_words=3, variable_nb_words=True))
    elif name == 'en':
        return u"[TESTING] {}".format(fake_en.sentence(nb_words=3, variable_nb_words=True))
    elif name == 'ru':
        return u"[ТЕСТИРОВАНИЕ] {}".format(fake_ru.sentence(nb_words=3, variable_nb_words=True))


def create_fake_description(name):
    if name == 'ua':
        return fake.sentence(nb_words=10, variable_nb_words=True)
    elif name == 'en':
        return fake_en.sentence(nb_words=10, variable_nb_words=True)
    elif name == 'ru':
        return fake_ru.sentence(nb_words=10, variable_nb_words=True)


def create_fake_dgfID():
    return fake.dgfID()


def create_fake_date():
    return get_now().strftime('%Y-%m-%d')


def create_fake_dgfDecisionID():
    return fake.dgfDecisionID()


def create_fake_tenderAttempts(attempt):
    number = [1,2,3,4,5,6,7,8]
    number.remove(attempt)
    return  random.choice(number)


def create_fake_amount():
    return round(random.uniform(3000, 999999999.99), 2)


def create_fake_minimal_step(value_amount):
    return round(random.uniform(0.01, 0.03) * value_amount, 2)


def create_fake_guarantee(value_amount):
    guarantee = round(0.1 * value_amount, 2)
    # Required guarantee deposit must not be greater than 500 000 UAH
    return guarantee if guarantee <= 500000 else 500000


def create_fake_cancellation_reason():
    reasons = [u"Згідно рішення виконавчої дирекції Фонду гарантування вкладів фізичних осіб",
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


def test_tender_data(params,
                    periods=("enquiry", "tender"),
                    submissionMethodDetails=None):
    submissionMethodDetails = submissionMethodDetails \
        if submissionMethodDetails else "quick"
    now = get_now()
    value_amount = create_fake_amount()  # max value equals to budget of Ukraine in hryvnias

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
        "guarantee": {
            "amount": create_fake_guarantee(value_amount),
            "currency": u"UAH"
        },
        "minimalStep": {
            "amount": create_fake_minimal_step(value_amount),
            "currency": u"UAH"
        },
        "items": [],
    }

    accelerator = params['intervals']['accelerator']
    data['procurementMethodDetails'] = 'quick, ' \
        'accelerator={}'.format(accelerator)

    data["procuringEntity"]["kind"] = "other"

    cav_group = fake.cav_other()[:3]
    for i in range(params['number_of_items']):
        new_item = test_item_data(cav_group)
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
            "status": "draft",
            "tenderers": [
                fake.procuringEntity()
            ]
        }
    })
    bid.data.tenderers[0].address.countryName_en = translate_country_en(bid.data.tenderers[0].address.countryName)
    bid.data.tenderers[0].address.countryName_ru = translate_country_ru(bid.data.tenderers[0].address.countryName)
    return bid


def test_bid_value(max_value_amount, minimalStep=0):
    return munchify({
        "value": {
            "currency": "UAH",
            "amount": round(random.uniform(1, 1.01)*(max_value_amount + minimalStep), 2),
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


def test_item_data(cav):
    #using typical functions for dgf other and all other modes besides dgf financial
    #items will be genareted from other CAV group
    data = fake.fake_item(cav)

    data["description"] = field_with_id("i", data["description"])
    data["description_en"] = field_with_id("i", data["description_en"])
    data["description_ru"] = field_with_id("i", data["description_ru"])
    days = fake.random_int(min=1, max=30)
    data["deliveryDate"] = {"endDate": (get_now() + timedelta(days=days)).isoformat()}
    data["deliveryAddress"]["countryName_en"] = translate_country_en(data["deliveryAddress"]["countryName"])
    data["deliveryAddress"]["countryName_ru"] = translate_country_ru(data["deliveryAddress"]["countryName"])
    return munchify(data)


def test_item_data_financial(cav):
    #using special function for generating items from financial CAV group
    #in dgf finsncial mode
    data = fake.fake_item_financial(cav)

    data["description"] = field_with_id("i", data["description"])
    data["description_en"] = field_with_id("i", data["description_en"])
    data["description_ru"] = field_with_id("i", data["description_ru"])
    days = fake.random_int(min=1, max=30)
    data["deliveryDate"] = {"endDate": (get_now() + timedelta(days=days)).isoformat()}
    data["deliveryAddress"]["countryName_en"] = translate_country_en(data["deliveryAddress"]["countryName"])
    data["deliveryAddress"]["countryName_ru"] = translate_country_ru(data["deliveryAddress"]["countryName"])
    return munchify(data)


def test_tender_data_dgf_other(params, submissionMethodDetails):
    data = test_tender_data(params, [], submissionMethodDetails)

    data['dgfID'] = fake.dgfID()
    data['dgfDecisionID'] = fake.dgfDecisionID()
    data['dgfDecisionDate'] =  (get_now() + timedelta(days=-2)).strftime('%Y-%m-%d')
    data['tenderAttempts'] =  fake.random_int(min=1, max=8)
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

    cav_group_other = fake.cav_other()[:3]
    used_cavs = [cav_group_other]
    for i in range(params['number_of_items']):
        new_item = test_item_data(cav_group_other)
        data['items'].append(new_item)
        while (cav_group_other in used_cavs) and (i != (params['number_of_items'] - 1)):
            cav_group_other = fake.cav_other()[:3]
        used_cavs.append(cav_group_other)
    return data


def test_tender_data_dgf_financial(params, submissionMethodDetails):
    data = test_tender_data(params, [], submissionMethodDetails)

    data['dgfID'] = fake.dgfID()
    data['dgfDecisionID'] = fake.dgfDecisionID()
    data['dgfDecisionDate'] = (get_now() + timedelta(days=-2)).strftime('%Y-%m-%d')
    data['tenderAttempts'] = fake.random_int(min=1, max=8)

    del data["procuringEntity"]

    for i in range(params['number_of_items']):
        data['items'].pop()

    url = params['api_host_url']

    # TODO: handle this magic string
    if url == 'https://lb.api.ea.openprocurement.org':
        del data['procurementMethodDetails']

    period_dict = {}
    inc_dt = get_now()
    period_dict["auctionPeriod"] = {}
    inc_dt += timedelta(minutes=params['intervals']['auction'][0])
    period_dict["auctionPeriod"]["startDate"] = inc_dt.isoformat()
    data.update(period_dict)

    data['procurementMethodType'] = 'dgfFinancialAssets'
    data["procuringEntity"] = fake.procuringEntity()

    for i in range(params['number_of_items']):
        cav_group_financial = fake.cav_financial()[:3]
        new_item = test_item_data_financial(cav_group_financial)
        data['items'].append(new_item)

    return data


def test_tender_data_dgf_insider(params, submissionMethodDetails):
    data = test_tender_data(params, [], submissionMethodDetails)

    data['dgfID'] = fake.dgfID()
    data['dgfDecisionID'] = fake.dgfDecisionID()
    data['dgfDecisionDate'] = (get_now() + timedelta(days=-2)).strftime('%Y-%m-%d')
    data['tenderAttempts'] = fake.random_int(min=1, max=8)

    del data["procuringEntity"]
    del data['minimalStep']

    for i in range(params['number_of_items']):
        data['items'].pop()

    url = params['api_host_url']

    # TODO: handle this magic string
    if url == 'https://lb.api.ea.openprocurement.org':
        del data['procurementMethodDetails']

    period_dict = {}
    inc_dt = get_now()
    period_dict["auctionPeriod"] = {}
    inc_dt += timedelta(minutes=params['intervals']['auction'][0])
    period_dict["auctionPeriod"]["startDate"] = inc_dt.isoformat()
    data.update(period_dict)

    data['procurementMethodType'] = 'dgfInsider'
    data["procuringEntity"] = fake.procuringEntity_insider()

    for i in range(params['number_of_items']):
        cav_group_financial = fake.cav_financial()[:3]
        new_item = test_item_data_financial(cav_group_financial)
        data['items'].append(new_item)

    return data
