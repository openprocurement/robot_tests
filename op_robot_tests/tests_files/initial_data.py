# -*- coding: utf-8 -
from datetime import datetime, timedelta
now = datetime.now()
from munch import munchify
from faker import Factory
fake = Factory.create('uk_UA')
fake_ru = Factory.create('ru')
fake_en = Factory.create()

test_tender_data = {
    "title": fake.catch_phrase(),
    "mode": "test",
    "submissionMethodDetails": "quick",
    "description": "Тестовий тендер",
    "description_en": "Test tender",
    "description_ru": "Тестовый тендер",
    "procuringEntity": {
        "name": fake.company(),
        "name_ru": fake_ru.company(),
        "name_en": fake_en.company(),
        "identifier": {
            "scheme": u"UA-EDR",
            "id": u"0000{}".format(fake.pyint()),
            "uri": fake.image_url(width=None, height=None)
        },
        "address": {
            "countryName": u"Україна",
            "postalCode": fake.postalcode(),
            "region": u"м. Київ",
            "locality": u"м. Київ",
            "streetAddress": fake.street_address()
        },
        "contactPoint": {
            "name": fake.name(),
            "telephone": fake.phone_number()
        }
    },
    "value": {
        "amount": 50000.99,
        "currency": u"UAH"
    },
    "minimalStep": {
        "amount": 100.1,
        "currency": u"UAH"
    },
    "items": [
        {
            "description": fake.catch_phrase(),
            "deliveryDate": {
                "endDate": (now + timedelta(days=5)).isoformat()
            },
            "deliveryLocation": {
                "latitude": "49.8500° N",
                "longitude": "24.0167° E"
            },
            "deliveryAddress": {
                "countryName": u"Україна",
                "postalCode": fake.postalcode(),
                "region": u"м. Київ",
                "locality": u"м. Київ",
                "streetAddress": fake.street_address()
            },
            "classification": {
                "scheme": u"CPV",
                "id": u"44617100-9",
                "description": u"Cartons"
            },
            "additionalClassifications": [
                {
                    "scheme": u"ДКПП",
                    "id": u"17.21.1",
                    "description": u"папір і картон гофровані, паперова й картонна тара"
                }
            ],
            "unit": {
                "name": u"item",
                "code": u"44617100-9"
            },
            "quantity": fake.pyint()
        }
    ],
    "enquiryPeriod": {
        "endDate": (now + timedelta(minutes=2)).isoformat()
    },
    "tenderPeriod": {
        "endDate": (now + timedelta(minutes=5)).isoformat()
    }
}


def test_question_data():
    return munchify({
        "data": {
            "author": {
                "address": {
                    "countryName": "Україна",
                    "locality": "м. Вінниця",
                    "postalCode": "21100",
                    "region": "м. Вінниця",
                    "streetAddress": fake.street_address()
                },
                "contactPoint": {
                    "name": fake.name(),
                    "telephone": fake.phone_number()
                },
                "identifier": {
                    "scheme": u"UA-EDR",
                    "id": u"0000{}".format(fake.pyint()),
                    "uri": fake.image_url(width=None, height=None)
                },
                "name": fake.company()
            },
            "description": fake.sentence(nb_words=10, variable_nb_words=True),
            "title": fake.sentence(nb_words=6, variable_nb_words=True)
        }
    })


def test_question_answer_data():
    return munchify({
        "data": {
            "answer": fake.sentence(nb_words=40, variable_nb_words=True)
        }
    })


def test_bid_data():
    return munchify({
        "data": {
            "tenderers": [
                {
                    "address": {
                        "countryName": "Україна",
                        "locality": "м. Вінниця",
                        "postalCode": "21100",
                        "region": "м. Вінниця",
                        "streetAddress": fake.street_address()
                    },
                    "contactPoint": {
                        "name": fake.name(),
                        "telephone": fake.phone_number()
                    },
                    "identifier": {
                        "scheme": u"UA-EDR",
                        "id": u"0000{}".format(fake.pyint()),
                    },
                    "name": fake.company()
                }
            ],
            "value": {
                "amount": 500
            }
        }
    })
