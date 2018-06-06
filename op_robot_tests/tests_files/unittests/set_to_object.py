from unittest import TestCase, main

from op_robot_tests.tests_files.service_keywords import set_to_object


class TestSetToObject(TestCase):
    def test_raises_1(self):
        given = None
        with self.assertRaises(TypeError):
            given = set_to_object(given, 'foo[0]', 1)

    def test_raises_2(self):
        given = {'foo': None}
        with self.assertRaises(TypeError):
            given = set_to_object(given, 'foo[0]', 1)

    def test_1(self):
        given = {}
        expected = {'foo': 1}
        given = set_to_object(given, 'foo', 1)
        self.assertEqual(given, expected)

    def test_2(self):
        given = {'foo': []}
        expected = {'foo': [1]}
        given = set_to_object(given, 'foo[0]', 1)
        self.assertEqual(given, expected)

    def test_3(self):
        given = {}
        expected = {'foo': [1]}
        given = set_to_object(given, 'foo[0]', 1)
        self.assertEqual(given, expected)

    def test_4(self):
        given = {}
        expected = {'foo': {'bar': 1}}
        given = set_to_object(given, 'foo.bar', 1)
        self.assertEqual(given, expected)

    def test_5(self):
        given = {}
        expected = {'foo': [None, {'bar': 1}]}
        given = set_to_object(given, 'foo[1].bar', 1)
        self.assertEqual(given, expected)

    def test_6(self):
        given = {}
        expected = {'foo': [{'bar': [1]}]}
        given = set_to_object(given, 'foo[0].bar[0]', 1)
        self.assertEqual(given, expected)

    def test_7(self):
        given = {}
        expected = {'foo': [{'bar': [1]}, None, None]}
        given = set_to_object(given, 'foo[-3].bar[-1]', 1)
        self.assertEqual(given, expected)

    def test_8(self):
        given = {'foo': [{'bar': [1]}]}
        expected = {'foo': [{'bar': [1]}, None, {'baz': [2]}]}
        given = set_to_object(given, 'foo[2].baz[0]', 2)
        self.assertEqual(given, expected)

    def test_9(self):
        given = {'foo': [{'bar': [1]}]}
        expected = {'foo': [{'baz': [2, None]}, None, {'bar': [1]}]}
        given = set_to_object(given, 'foo[-3].baz[-2]', 2)
        self.assertEqual(given, expected)


if __name__ == '__main__':
    main()
