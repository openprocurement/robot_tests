# -*- coding: utf-8 -
import os
from munch import munchify, Munch, fromYAML
from json import load
from robot.output import LOGGER
from robot.output.loggerhelper import Message
from robot.libraries.BuiltIn import BuiltIn


from .initial_data import (
    test_tender_data, test_question_data, test_question_answer_data,
    test_bid_data
)


def log_object_data(data, file_name="", format="yaml"):
    if not isinstance(data, Munch):
        data = munchify(data)
    if format == 'json':
        data = data.toJSON(indent=2)
    else:
        data = data.toYAML(allow_unicode=True, default_flow_style=False)
        format = 'yaml'
    LOGGER.log_message(Message(data, "INFO"))
    if file_name:
        output_dir = BuiltIn().get_variable_value("${OUTPUT_DIR}")
        with open(os.path.join(output_dir, file_name + '.' + format), "w") as file_obj:
            file_obj.write(data)


def load_initial_data_from(file_name):
    if not os.path.exists(file_name):
        file_name = os.path.join(os.path.dirname(__file__), 'data/{}'.format(file_name))
    with open(file_name) as file_obj:
        if file_name.endswith(".json"):
            return Munch.fromDict(load(file_obj))
        elif file_name.endswith(".yaml"):
            return fromYAML(file_obj)


def prepare_test_tender_data():
    return munchify({'data': test_tender_data})
