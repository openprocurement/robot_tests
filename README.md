# robot_tests

[![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/openprocurement/robot_tests?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

## Запуск тестів ##
Необхідно запустити:
```
bin/openprocurement_tests
```

В тестах використовуються користувачі, які описані в https://github.com/openprocurement/robot_tests/blob/master/op_robot_tests/tests_files/data/users.yaml. За замовчуванням тести використовують користувачів з реалізацією запитів в центральну базу за допомогою API клієнта (умовна назва Quinta). Скрипт ```bin/openprocurement_tests``` дає змогу змінити користувача для ролей.
Для прикладу для тесту 'CreateTenderTest' використовуються  ролі *tender_owner* та *provider*. В тесті прописано, що роль [*tender_owner* буде виконувати *Tender_Owner*](https://github.com/openprocurement/robot_tests/blob/master/op_robot_tests/tests_files/singleItemTender.robot#L16) з [відповідною реалізацією запитів](https://github.com/openprocurement/robot_tests/blob/master/op_robot_tests/tests_files/data/users.yaml#L4) в центральну базу.
Для запуску тестів де роль *tender_owner* виконує [*Prom_Owner*](https://github.com/openprocurement/robot_tests/blob/master/op_robot_tests/tests_files/data/users.yaml#L7) запускаємо
```
bin/openprocurement_tests -v tender_owner:Prom_Owner
