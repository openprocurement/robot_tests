# -*- coding: utf-8 -*-
from faker.providers import BaseProvider
from faker.generator import random
from copy import deepcopy
from munch import Munch
from json import load
import os


def load_data_from_file(file_name):
    if not os.path.exists(file_name):
        file_name = os.path.join(os.path.dirname(__file__), file_name)
    with open(file_name) as file_obj:
        if file_name.endswith(".json"):
            return Munch.fromDict(load(file_obj))
        elif file_name.endswith(".yaml"):
            return Munch.fromYAML(file_obj)


class OP_Provider(BaseProvider):
    _fake_data = load_data_from_file("op_faker_data.json")
    word_list = _fake_data.words
    procuringEntities = _fake_data.procuringEntities
    funders = _fake_data.funders
    funders_scheme_list = _fake_data.funders_scheme
    addresses = _fake_data.addresses
    classifications = _fake_data.classifications
    cpvs = _fake_data.cpvs
    items_base_data = _fake_data.items_base_data
    rationale_types = _fake_data.rationale_types

    @classmethod
    def randomize_nb_elements(self, number=10, le=60, ge=140):
        """
        Returns a random value near number.

        :param number: value to which the result must be near
        :param le: lower limit of randomizing (percents). Default - 60
        :param ge: upper limit of randomizing (percents). Default - 140
        :returns: a random int in range [le * number / 100, ge * number / 100]
            with minimum of 1
        """
        if le > ge:
            raise Exception("Lower bound: {} is greater then upper: {}.".format(le, ge))
        return int(number * self.random_int(min=le, max=ge) / 100) + 1

    @classmethod
    def word(self):
        """
        :example 'Курка'
        """
        return self.random_element(self.word_list)

    @classmethod
    def words(self, nb=3):
        """
        Generate an array of random words
        :example: array('Надіньте', 'фуражка', 'зелено')
        :param nb: how many words to return
        """
        return [self.word() for _ in range(0, nb)]

    @classmethod
    def sentence(self, nb_words=5, variable_nb_words=True):
        """
        Generate a random sentence
        :example: 'Курка надіньте пречудовий зелено на.'
        :param nb_words: how many words the sentence should contain
        :param variable_nb_words: set to false if you want exactly $nbWords returned,
            otherwise $nbWords may vary by +/-40% with a minimum of 1
        """
        if nb_words <= 0:
            return ''

        if variable_nb_words:
            nb_words = self.randomize_nb_elements(number=nb_words)

        words = self.words(nb_words)
        words[0] = words[0].title()

        return " ".join(words) + '.'

    @classmethod
    def title(self):
        return self.sentence(nb_words=3)

    @classmethod
    def description(self):
        return self.sentence(nb_words=10)

    @classmethod
    def procuringEntity(self):
        return deepcopy(self.random_element(self.procuringEntities))

    @classmethod
    def funders_data(self):
        return self.random_element(self.funders)

    @classmethod
    def funder_scheme(self):
        return self.random_element(self.funders_scheme_list)

    @classmethod
    def cpv(self, cpv_group=None):
        if cpv_group:
            cpvs = []
            for cpv_element in self.cpvs:
                if cpv_element.startswith(cpv_group):
                    cpvs.append(cpv_element)
            return self.random_element(cpvs)
        else:
            return self.random_element(self.cpvs)

    @classmethod
    def fake_item(self, cpv_group=None):
        """
        Generate a random item for openprocurement tenders

        :param cpv_group: gives possibility to generate items
            from a specific cpv group. Cpv group is three digits
            in the beginning of each cpv id.
        """
        item_base_data = None
        if cpv_group is None:
            item_base_data = self.random_element(self.items_base_data)
        else:
            cpv_group = str(cpv_group)
            similar_cpvs = []
            for cpv_element in self.cpvs:
                if cpv_element.startswith(cpv_group):
                    similar_cpvs.append(cpv_element)
            cpv = self.random_element(similar_cpvs)
            for entity in self.items_base_data:
                if entity["cpv_id"] == cpv:
                    item_base_data = entity
                    break
            if not item_base_data:
                raise ValueError('unable to find an item with CPV ' + cpv)

        # choose appropriate additional classification for item_base_data's cpv
        additional_class = []
        for entity in self.classifications:
            if entity["classification"]["id"] == item_base_data["cpv_id"]:
                additional_class.append(entity)
        if not additional_class:
            raise ValueError('unable to find a matching additional classification for CPV ' + cpv)
        classification = self.random_element(additional_class)

        dk_descriptions = {
            u'ДК003': (u'Послуги фахівців', u'Услуги специалистов', u'Specialists services'),
            u'ДК015': (u'Дослідження та розробки', u'Исследования и разработки', u'Research and development'),
            u'ДК018': (u'Будівлі та споруди', u'Здания и сооружения', u'Buildings and structures')
        }
        address = self.random_element(self.addresses)
        item = {
            "classification": classification["classification"],
            "deliveryAddress": address["deliveryAddress"],
            "deliveryLocation": address["deliveryLocation"],
            "unit": item_base_data["unit"],
            "quantity": self.randomize_nb_elements(number=item_base_data["quantity"], le=80, ge=120)
        }
        if item_base_data["cpv_id"] == "99999999-9":
            scheme = classification["additionalClassifications"][0]["scheme"]
            item.update({
                "description": dk_descriptions[scheme][0],
                "description_ru": dk_descriptions[scheme][1],
                "description_en": dk_descriptions[scheme][2]
            })
        else:
            item.update({
                "additionalClassifications": classification["additionalClassifications"],
                "description": item_base_data["description"],
                "description_ru": item_base_data["description_ru"],
                "description_en": item_base_data["description_en"]
            })
        return deepcopy(item)

    @classmethod
    def rationaleTypes(self, amount=3):
        return random.sample(self.rationale_types, amount)