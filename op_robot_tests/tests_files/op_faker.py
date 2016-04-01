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
        self.fake_items = fake_data.items_data

    @classmethod
    def word(self):
        return self.random_element(self.words)


    @classmethod
    def sentence(self, nb_words=5, variable_nb_words=False):
        '''
        :param variable_nb_words set to false, and if it
        is set to true nothing changes, because it is added in order
        to provider backward compatibility with BaseProvider.
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
    def fake_item(self):
        return self.random_element(self.fake_items)
