# -*- coding: utf-8 -
from datetime import datetime, timedelta
from faker import Factory
from munch import munchify
from pytz import timezone
from tempfile import NamedTemporaryFile
import os

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


def test_tender_data(intervals):
    now = get_now()
    return {
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
                "id": u"0000{}".format(fake.pyint()),
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
                    "countryName_ru": u"Украина",
                    "countryName_en": "Ukraine",
                    "postalCode": fake.postalcode(),
                    "region": u"м. Київ",
                    "locality": u"м. Київ",
                    "streetAddress": fake.street_address()
                },
                "classification": {
                    "scheme": u"CPV",
                    "id": u"44617100-9",
                    "description": u"Картонки",
                    "description_ru": u"Большие картонные коробки",
                    "description_en": u"Cartons"
                },
                "additionalClassifications": [
                    {
                        "scheme": u"ДКПП",
                        "id": u"17.21.1",
                        "description": u"Папір і картон гофровані, паперова й картонна тара"
                    }
                ],
                "unit": {
                    "name": u"кілограм",
                    "name_ru": u"килограмм",
                    "name_en": "kilogram",
                    "code": u"KGM"
                },
                "quantity": fake.pyint()
            }
        ],
        "enquiryPeriod": {
            "startDate": (now).isoformat(),
            "endDate": (now + timedelta(minutes=(
                intervals['enquiry']))).isoformat()
        },
        "tenderPeriod": {
            "startDate": (now + timedelta(minutes=2)).isoformat(),
            "endDate": (now + timedelta(minutes=(
                intervals['tender']))).isoformat()
        }
    }

def test_tender_data_multiple_items(intervals):
    now = get_now()
    t_data = test_tender_data(intervals)
    t_data.update({
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
                    "countryName_ru": u"Украина",
                    "countryName_en": "Ukraine",
                    "postalCode": "01008",
                    "region": u"м. Київ",
                    "locality": u"м. Київ",
                    "streetAddress": u"ул. Грушевского, 12/2"
                },
                "classification": {
                    "scheme": u"CPV",
                    "id": u"44617100-9",
                    "description": u"Картонки",
                    "description_ru": u"Большие картонные коробки",
                    "description_en": u"Cartons"
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
                    "name_ru": u"килограмм",
                    "name_en": "kilogram",
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
                    "countryName_ru": u"Украина",
                    "countryName_en": "Ukraine",
                    "postalCode": fake.postalcode(),
                    "region": u"м. Київ",
                    "locality": u"м. Київ",
                    "streetAddress": fake.street_address()
                },
                "classification": {
                    "scheme": u"CPV",
                    "id": u"44617100-9",
                    "description": u"Картонки",
                    "description_ru": u"Большие картонные коробки",
                    "description_en": u"Cartons"
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
                    "name_ru": u"килограмм",
                    "name_en": "kilogram",
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
                    "countryName_ru": u"Украина",
                    "countryName_en": "Ukraine",
                    "postalCode": fake.postalcode(),
                    "region": u"Луганська область",
                    "locality": u"м. Луганськ",
                    "streetAddress": u"Вул. Оборонна 28"
                },
                "classification": {
                    "scheme": u"CPV",
                    "id": u"44617100-9",
                    "description": u"Картонки",
                    "description_ru": u"Большие картонные коробки",
                    "description_en": u"Cartons"
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
                    "name_ru": u"килограмм",
                    "name_en": "kilogram",
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
                    "countryName_ru": u"Украина",
                    "countryName_en": "Ukraine",
                    "postalCode": fake.postalcode(),
                    "region": u"м. Київ",
                    "locality": u"м. Київ",
                    "streetAddress": fake.street_address()
                },
                "classification": {
                    "scheme": u"CPV",
                    "id": u"44617100-9",
                    "description": u"Картонки",
                    "description_ru": u"Большие картонные коробки",
                    "description_en": u"Cartons"
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
                    "name_ru": u"килограмм",
                    "name_en": "kilogram",
                    "code": u"KGM"
                },
                "quantity": fake.pyint()
            }
        ]
    })
    return t_data

def test_tender_data_multiple_lots(intervals):
    t_data = test_tender_data_multiple_items(intervals)
    for i in range(3):
        t_data['items'][i]['relatedLot'] = "3c8f387879de4c38957402dbdb8b31af"
    t_data['items'][3]['relatedLot'] = "bcac8d2ceb5f4227b841a2211f5cb646"
    t_data['lots'] = [
    {
      "id": "3c8f387879de4c38957402dbdb8b31af",
      "title": "Lot #1: Kyiv stationey",
      "description": "Items for Kyiv office",
      "value": {"currency": "UAH", "amount": 34000.0, "valueAddedTaxIncluded": "true"},
      "minimalStep": {"currency": "UAH", "amount": 30.0, "valueAddedTaxIncluded": "true"},
      "status": "active"
    }, {
      "id": "bcac8d2ceb5f4227b841a2211f5cb646",
      "title": "Lot #1: Lviv stationey",
      "description": "Items for Lviv office",
      "value": {"currency": "UAH", "amount": 9000.0, "valueAddedTaxIncluded": "true"},
      "minimalStep": {"currency": "UAH", "amount": 35.0, "valueAddedTaxIncluded": "true"},
      "status": "active"
    }
    ]
    return t_data

def test_meat_tender_data(tender):
    item_id = "edd0032574bf4402877ad5f362df225a"
    tender.data['items'][0].id = item_id
    tender.data.features =  [
      {
          "code":"ee3e24bc17234a41bd3e3a04cc28e9c6",
          "featureOf":"tenderer",
          "title":"Термін оплати",
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
          "title": "Сорт",
          "description": "Сорт продукції",
          "enum":[
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
    return munchify({
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


def test_bid_data_meat_tender():
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
            "parameters": [
                     {
                         "code": "ee3e24bc17234a41bd3e3a04cc28e9c6",
                         "value": fake.random_element(elements=(0.15, 0.1, 0.05, 0))
                     },
                     {
                         "code": "48cfd91612c04125ab406374d7cc8d93",
                         "value": fake.random_element(elements=(0.05, 0.01, 0))
                     }
            ],
            "value": {
                "amount": 500
            }
        }
    })


def test_lots_bid_data():
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
            "lotValues": [
                    {
                    "value": {"currency": "UAH",
                              "amount": 1000 + fake.pyfloat(left_digits=3, right_digits=0, positive=True),
                              "valueAddedTaxIncluded": "true"},
                    "relatedLot": "3c8f387879de4c38957402dbdb8b31af",
                    "date": "2015-11-01T12:43:12.482645+02:00"
                    },
                    {
                    "value": {"currency": "UAH",
                              "amount": 1000 + fake.pyfloat(left_digits=3, right_digits=0, positive=True),
                              "valueAddedTaxIncluded": "true"},
                    "relatedLot": "bcac8d2ceb5f4227b841a2211f5cb646",
                    "date": "2015-11-01T12:43:12.482645+02:00"
                    }
            ]
        }
    })

def auction_bid():
    return munchify({
        "data": {
            "value": {
                "amount": 200,
                "currency": "UAH",
                "valueAddedTaxIncluded": "true"
            }
        }
    })


def test_award_data():
    return munchify({'data': {}})


def test_item_data():
    now = get_now()
    return  {
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
                    "countryName_ru": u"Украина",
                    "countryName_en": "Ukraine",
                    "postalCode": fake.postalcode(),
                    "region": u"м. Київ",
                    "locality": u"м. Київ",
                    "streetAddress": fake.street_address()
                },
                "classification": {
                    "scheme": u"CPV",
                    "id": u"44617100-9",
                    "description": u"Картонки",
                    "description_ru": u"Большие картонные коробки",
                    "description_en": u"Cartons"
                },
                "additionalClassifications": [
                    {
                        "scheme": u"ДКПП",
                        "id": u"17.21.1",
                        "description": u"Папір і картон гофровані, паперова й картонна тара"
                    }
                ],
                "unit": {
                    "name": u"кілограм",
                    "name_ru": u"килограмм",
                    "name_en": "kilogram",
                    "code": u"KGM"
                },
                "quantity": fake.pyint()
            }


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
                  "title":"180 днів та більше"
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
          "relatedItem": "edd0032574bf4402877ad5f362df225a",
          "title": "Сорт",
          "description": "Сорт продукції",
          "enum":[
              {
                  "value": 0.35,
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


def test_lot_data():
    return munchify(
        {'data':
            {
              "description": fake.sentence(nb_words=10, variable_nb_words=True),
              "title": fake.sentence(nb_words=6, variable_nb_words=True),
                        "value": {"currency": "UAH",
                        "amount": fake.pyfloat(left_digits=4, right_digits=1, positive=True),
                        "valueAddedTaxIncluded": "true"},
              "minimalStep": {"currency": "UAH", "amount": 30.0, "valueAddedTaxIncluded": "true"},
              "status": "active"
            }
        })


def test_lot_document_data(document, lot_id="3c8f387879de4c38957402dbdb8b31af"):
    lot_document = {"documentOf":"lot", "relatedItem": lot_id}
    lot_document.update(document.data)
    return munchify({"data": lot_document})


def test_lot_question_data(question, lot_id="3c8f387879de4c38957402dbdb8b31af"):
    lot_question = {"questionOf":"lot", "relatedItem": lot_id}
    lot_question.update(question.data)
    return munchify({"data": lot_question})


def test_lot_complaint_data(complaint, lot_id="3c8f387879de4c38957402dbdb8b31af"):
    lot_complaint = {"complaintOf":"lot", "relatedItem": lot_id}
    lot_complaint.update(complaint.data)
    return munchify({"data": lot_complaint})
