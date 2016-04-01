# -*- coding: utf-8 -*-
from faker import Faker
from faker.providers import BaseProvider
from munch import Munch
from json import load
import os


def load_data_from_file(file_name):
    if not os.path.exists(file_name):
        file_name = os.path.join(os.path.dirname(__file__), 'data', file_name)
    with open(file_name) as file_obj:
        if file_name.endswith(".json"):
            return Munch.fromDict(load(file_obj))
        elif file_name.endswith(".yaml"):
            return fromYAML(file_obj)


class OP_Provider(BaseProvider):
    @classmethod
    def load_data(self):
        fake_data = load_data_from_file("faker_data.json")
        self.words = fake_data.words
        self.procuringEntities = fake_data.procuringEntities
        self.addresses = fake_data.addresses
        self.classifications = fake_data.classifications
        self.units = fake_data.units
        self.cpvs = fake_data.CPVs
        self.items_base_data = fake_data.items_base_data


    @classmethod
    def word(self):
        return self.random_element(self.words)


    @classmethod
    def sentence(self, nb_words=5, variable_nb_words=False):
        '''
        :param variable_nb_words set to false, and if it is set to true
        nothing changes, because it is added only in order to have the
        same arguments with BaseProvider.sentence()
        '''
        result = u"{} ".format(self.word().capitalize())
        for _ in range(nb_words - 2):
            result += u"{} ".format(self.word())
        result += u"{}.".format(self.word())
        return result


    @classmethod
    def title(self):
        return self.sentence(nb_words = 3)


    @classmethod
    def description(self):
        return self.sentence(nb_words = 10)


    @classmethod
    def procuringEntity(self):
        return self.random_element(self.procuringEntities)


    @classmethod
    def cpv(self):
        return self.random_element(self.cpvs)


    @classmethod
    def fake_item(self, cpv=None):
        if cpv is None:
            item_base_data = self.random_element(self.items_base_data)
        else:
            cpv = "{}".format(cpv)
            similar_cpvs = []
            for cpv_element in self.cpvs:
                if cpv_element.startswith(cpv):
                    similar_cpvs.append(cpv_element)
            cpv = self.random_element(similar_cpvs)
            for entity in self.items_base_data:
                if entity["cpv_id"] == cpv:
                    item_base_data = entity

        for entity in self.classifications:
            if entity["classification"]["id"] == item_base_data["cpv_id"]:
                classification = entity
                break

        address = self.random_element(self.addresses)
        unit = self.random_element(self.units)
        item = {
            "description": item_base_data["description"],
            "classification": classification["classification"],
            "additionalClassifications": classification["additionalClassifications"],
            "deliveryAddress": address["deliveryAddress"],
            "deliveryLocation": address["deliveryLocation"],
            "unit": item_base_data["unit"],
            "quantity": self.random_int(min=1, max=32770)
        }
        return item
