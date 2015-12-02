# -*- coding: utf-8 -
import os
from pytz import timezone
from datetime import datetime, timedelta
from munch import munchify
from faker import Factory
from tempfile import NamedTemporaryFile

fake = Factory.create('uk_UA')
fake_ru = Factory.create('ru')
fake_en = Factory.create()

TZ = timezone(os.environ['TZ'] if 'TZ' in os.environ else 'Europe/Kiev')

def get_now():
    return datetime.now(TZ)


def create_fake_doc():
    content = fake.text()
    tf = NamedTemporaryFile(delete=False)
    tf.write(content)
    tf.close()
    return tf.name

def test_tender_data(period_interval):
  now = get_now()
  return {
    "title": u"[ТЕСТУВАННЯ] " + fake.catch_phrase(),
    "mode": "test",
    "submissionMethodDetails": "quick",
    "description": "Test tender1",  #Error @prom when 'Тестовый тендер'
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
        "amount": 50000, #Error @prom when float '50000.99'
        "currency": u"UAH"
    },
    "minimalStep": {
        "amount": 100,   #Error @prom when float '100.1'
        "currency": u"UAH"
    },
    "items": [
        {
            "description": fake.catch_phrase(),
            "deliveryDate": {
                "endDate": (now + timedelta(days=5)).isoformat()
            },
            "deliveryLocation": {
                "latitude": u"49.8500° N",
                "longitude": u"24.0167° E"
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
                "name": u"кілограм",
                "code": u"KGM"
            },
            "quantity": fake.pyint()
        }
    ],
    "enquiryPeriod": {
        "startDate": (now).isoformat(),
        "endDate": (now + timedelta(minutes=1)).isoformat()
    },
    "tenderPeriod": {
        "startDate": (now + timedelta(minutes=2)).isoformat(),
        "endDate": (now + timedelta(minutes=(2+period_interval))).isoformat()
    }
}

def prom_test_tender_data():
  now = get_now()
  return {
    "title": fake.catch_phrase(),
    "mode": "test",
    "submissionMethodDetails": "quick",
    "description": "Test tender1",  #Error @prom when 'Тестовый тендер'
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
        "amount": 50000, #Error @prom when float '50000.99'
        "currency": u"UAH"
    },
    "minimalStep": {
        "amount": 100,   #Error @prom when float '100.1'
        "currency": u"UAH"
    },
    "items": [
        {
            "description": fake.catch_phrase(),
            "deliveryDate": {
                "startDate": (now + timedelta(days=4)).isoformat(),
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
                "name": u"кілограм",
                "code": u"KGM"
            },
            "quantity": fake.pyint()
        }
    ],
    "enquiryPeriod": {
        "startDate": (now + timedelta(days=1)).isoformat(),
        "endDate": (now + timedelta(days=2)).isoformat()
    },
    "tenderPeriod": {
        "startDate": (now + timedelta(days=3)).isoformat(),
        "endDate": (now + timedelta(days=5)).isoformat()
    }
}

def test_tender_data_multiple_lots(period_interval):
    now = get_now()
    return {
      "title": fake.catch_phrase(),
      "mode": "test",
      "submissionMethodDetails": "quick",
      "description": u"Тестовий тендер",
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
                "latitude": 49.8500,
                "longitude": 24.0167
            },
            "deliveryAddress": {
                "countryName": u"Україна",
                "postalCode": "01008",
                "region": u"м. Київ",
                "locality": u"м. Київ",
                "streetAddress": u"ул. Грушевского, 12/2"
            },
            "classification": {
                "scheme": u"CPV",
                "id": u"44617100-9",
                "description": u"Cartons"
            },
            "additionalClassifications": [
                {
                    "scheme": u"ДКПП",
                    "id": u"17.29.12-00.00",
                    "description": u"Блоки, плити та пластини фільтрувальні, з паперової маси"
                }
            ],
            "unit": {
                "name": u"кілограм",
                "code": u"KGM"
            },
            "quantity": fake.pyint()
        },
    {
            "description": fake.catch_phrase(),
            "deliveryDate": {
                "endDate": (now + timedelta(days=5)).isoformat()
            },
            "deliveryLocation": {
                "latitude": 49.8500,
                "longitude": 24.0167
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
                    "id": u"17.21.99-00.00",
                    "description": u"Роботи субпідрядні як частина виробництва гофрованих паперу й картону, паперової та картонної тари"
                }
            ],
            "unit": {
                "name": u"кілограм",
                "code": u"KGM"
            },
            "quantity": fake.pyint()
        },
    {
            "description": fake.catch_phrase(),
            "deliveryDate": {
                "endDate": (now + timedelta(days=5)).isoformat()
            },
            "deliveryLocation": {
                "latitude": 49.3418,
                "longitude": 39.1829
            },
            "deliveryAddress": {
                "countryName": u"Україна",
                "postalCode": fake.postalcode(),
                "region": u"м. Луганськ",
                "locality": u"м. Луганськ",
                "streetAddress": u"Вул. Оборонна 28"
            },
            "classification": {
                "scheme": u"CPV",
                "id": u"44617100-9",
                "description": u"Cartons"
            },
            "additionalClassifications": [
                {
                    "scheme": u"ДКПП",
                    "id": u"17.22.12-40.00",
                    "description": u"Вата; вироби з вати, інші"
                }
            ],
            "unit": {
                "name": u"кілограм",
                "code": u"KGM"
            },
            "quantity": fake.pyint()
        },
    {
            "description": fake.catch_phrase(),
            "deliveryDate": {
                "endDate": (now + timedelta(days=5)).isoformat()
            },
            "deliveryLocation": {
                "latitude": 49.8500,
                "longitude": 24.0167
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
                    "id": u"17.22.12-50.00",
                    "description": u"Одяг і речі до одягу з паперової маси, паперу, целюлозної вати чи полотна з целюлозного волокна (крім носових хусточок, наголовних уборів)"
                }
            ],
            "unit": {
                "name": u"кілограм",
                "code": u"KGM"
            },
            "quantity": fake.pyint()
        }
    ],
    "enquiryPeriod": {
        "startDate": (now).isoformat(),
        "endDate": (now + timedelta(minutes=1)).isoformat()
    },
    "tenderPeriod": {
        "startDate": (now + timedelta(minutes=2)).isoformat(),
        "endDate": (now + timedelta(minutes=(2+period_interval))).isoformat()
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

def test_complaint_data():
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

def test_complaint_reply_data():
    return munchify({
          "data": {
            "status": "resolved"
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

def auction_bid():
    return munchify({
        "data": {"value": {
                    "amount": 200,
                    "currency": "UAH",
                    "valueAddedTaxIncluded": true
                }
        }
    })


def test_award_data():
    return munchify({'data': {}})
