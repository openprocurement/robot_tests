# -*- coding: utf-8 -*-
from faker.providers import BaseProvider
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
    __fake_data = load_data_from_file("op_faker_data.json")
    word_list = __fake_data.words
    procuringEntities = __fake_data.procuringEntities
    addresses = __fake_data.addresses
    classifications = __fake_data.classifications
    cavs = __fake_data.cavs
    items_base_data = __fake_data.items_base_data

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
    def cav(self):
        return self.random_element(self.cavs)

    @classmethod
    def fake_item(self, cav_group=None):
        """
        Generate a random item for openprocurement tenders

        :param cav_group: gives possibility to generate items
            from a specific cav group. cpv group is three digits
            in the beginning of each cpv id.
        """
        if cav_group is None:
            item_base_data = self.random_element(self.items_base_data)
        else:
            cav_group = str(cav_group)
            similar_cavs = []
            for cav_element in self.cavs:
                if cav_element.startswith(cav_group):
                    similar_cavs.append(cav_element)
            cav = self.random_element(similar_cavs)
            for entity in self.items_base_data:
                if entity["cav_id"] == cav:
                    item_base_data = entity
                    break

        # choose appropriate dkpp classification for item_base_data's cpv
        for entity in self.classifications:
            if entity["classification"]["id"] == item_base_data["cav_id"]:
                classification = entity
                break

        address = self.random_element(self.addresses)
        item = {
            "description": item_base_data["description"],
            "description_ru": item_base_data["description_ru"],
            "description_en": item_base_data["description_en"],
            "classification": classification["classification"],
            "deliveryAddress": address["deliveryAddress"],
            "deliveryLocation": address["deliveryLocation"],
            "unit": item_base_data["unit"],
            "quantity": self.randomize_nb_elements(number=item_base_data["quantity"], le=80, ge=120)
        }
        return deepcopy(item)
