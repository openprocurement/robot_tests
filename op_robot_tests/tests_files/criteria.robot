*** Settings ***
Resource        base_keywords.robot
Suite Setup     Test Suite Setup
Suite Teardown  Test Suite Teardown

*** Variables ***
${RESOURCE}         criteria
${MODE}             criteria
@{USED_ROLES}       catalogues_admin  viewer

*** Test Cases ***
Можливість створити характеристику
  [Tags]   ${USERS.users['${catalogues_admin}'].broker}: Оголошення характеристики
  ...      catalogues_admin
  ...      ${USERS.users['${catalogues_admin}'].broker}
  ...      create_criteria
  [Teardown]  Оновити LAST_MODIFICATION_DATE  CRITERIA
  Можливість створити характеристику


Можливість знайти характеристику по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук характеристики
  ...      viewer  criteria_admin
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${catalogues_admin}'].broker}
  ...      find_criteria
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}  CRITERIA
  Можливість знайти характеристику по ідентифікатору для усіх користувачів


Неможливість створення характеристику
  [Tags]   ${USERS.users['${viewer}'].broker}: Неможливість оголошення характеристики
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      impossibility_create_criteria
  Неможливість для ${viewer} створити критерію


Відображення статусу характеристики
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних характеристики
  ...      viewer
  ...      ${USERS.users['${catalogues_admin}'].broker}
  ...      criteria_view
  Звірити відображення поля status характеристики із active для усіх користувачів


Відображення назви характеристики
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних характеристики
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      criteria_view
  Звірити відображення поля name характеристики для користувача ${viewer}


Відображення назви характеристики ангійською мовою
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних характеристики
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      criteria_view
  Звірити відображення поля nameEng характеристики для користувача ${viewer}


Відображення мінімального значення характеристики
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних характеристики
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      criteria_view
  Звірити відображення поля minValue характеристики для користувача ${viewer}


Відображення максмимального значення характеристики
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних характеристики
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      criteria_view
  Звірити відображення поля maxValue характеристики для користувача ${viewer}


Відображення коду одиниці виміру
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних характеристики
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      criteria_view
  Звірити відображення поля unit.code характеристики для користувача ${viewer}


Відображення назви одиниці виміру
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних характеристики
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      criteria_view
  Звірити відображення поля unit.name характеристики для користувача ${viewer}


Відображення типу даних характеристики
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних характеристики
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      criteria_view
  Звірити відображення поля dataType характеристики для користувача ${viewer}


Відображення коду класифікатора
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних характеристики
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      criteria_view
  Звірити відображення поля classification.id характеристики для користувача ${viewer}


Відображення назви коду класифікатора
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних характеристики
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      criteria_view
  Звірити відображення поля classification.description характеристики для користувача ${viewer}


Відображення ознаки довідника коду класифікатора
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних характеристики
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      criteria_view
  Звірити відображення поля classification.scheme характеристики для користувача ${viewer}


Відображення коду додаткового класифікатора
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних характеристики
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      criteria_view
  Звірити відображення поля additionalClassification.id характеристики для користувача ${viewer}


Відображення назви коду додаткового класифікатора
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних характеристики
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      criteria_view
  Звірити відображення поля additionalClassification.description характеристики для користувача ${viewer}


Відображення ознаки довідника коду додаткового класифікатора
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних характеристики
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      criteria_view
  Звірити відображення поля additionalClassification.scheme характеристики для користувача ${viewer}


Можливість змінити назву характеристики
  [Tags]   ${USERS.users['${catalogues_admin}'].broker}: Редагування характеристики
  ...      catalogues_admin
  ...      ${USERS.users['${catalogues_admin}'].broker}
  ...      modify_criteria
  [Teardown]  Оновити LAST_MODIFICATION_DATE  CRITERIA
  ${field_value}=  create_fake_sentence
  Можливість змінити поле name характеристики на ${field_value}


Відображення зміненої назви характеристики
  [Tags]   ${USERS.users['${viewer}'].broker}: Редагування характеристики
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      modify_criteria
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}  CRITERIA
  Remove From Dictionary  ${USERS.users['${viewer}'].criteria_data}  name
  Звірити відображення поля name характеристики із ${USERS.users['${catalogues_admin}'].new_name} для користувача ${viewer}


Неможливість змінити назву характерестики
    [Tags]   ${USERS.users['${viewer}'].broker}: Неможливість редагування характеристики
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      impossibility_modify_criteria
  ${field_value}=  create_fake_sentence
  Перевірити неможливість зміни поля name характеристики на значення ${field_value} для користувача ${viewer}


Відображення незміненої назви у характеристики
  [Tags]   ${USERS.users['${viewer}'].broker}: Неможливість редагування характеристики
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      impossibility_modify_criteria
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}  CRITERIA
  Звірити відображення поля name характеристики із ${USERS.users['${catalogues_admin}'].criteria_data.name} для користувача ${viewer}


Можливість змінити назву англійською мовою характеристики
  [Tags]   ${USERS.users['${catalogues_admin}'].broker}: Редагування характеристики
  ...      catalogues_admin
  ...      ${USERS.users['${catalogues_admin}'].broker}
  ...      modify_criteria
  [Teardown]  Оновити LAST_MODIFICATION_DATE  CRITERIA
  ${field_value}=  create_fake_eng_sentence
  Можливість змінити поле nameEng характеристики на ${field_value}


Відображення зміненої назви англійською мовою характеристики
  [Tags]   ${USERS.users['${viewer}'].broker}: Редагування характеристики
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      modify_criteria
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}  CRITERIA
  Remove From Dictionary  ${USERS.users['${viewer}'].criteria_data}  nameEng
  Звірити відображення поля nameEng характеристики із ${USERS.users['${catalogues_admin}'].new_nameEng} для користувача ${viewer}


Неможливість змінити назву англійською мовою характеристики
    [Tags]   ${USERS.users['${viewer}'].broker}: Неможливість редагування характеристики
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      impossibility_modify_criteria
  ${field_value}=  create_fake_eng_sentence
  Перевірити неможливість зміни поля nameEng характеристики на значення ${field_value} для користувача ${viewer}


Відображення незміненої назви англійською мовою у характеристики
  [Tags]   ${USERS.users['${viewer}'].broker}: Неможливість редагування характеристики
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      impossibility_modify_criteria
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}  CRITERIA
  Звірити відображення поля nameEng характеристики із ${USERS.users['${catalogues_admin}'].criteria_data.nameEng} для користувача ${viewer}


Можливість змінити мінімальне значення характеристики
  [Tags]   ${USERS.users['${catalogues_admin}'].broker}: Редагування характеристики
  ...      catalogues_admin
  ...      ${USERS.users['${catalogues_admin}'].broker}
  ...      modify_criteria
  [Teardown]  Оновити LAST_MODIFICATION_DATE  CRITERIA
  ${field_value}=  create_fake_number  ${USERS.users['${viewer}'].criteria_data.minValue}  ${USERS.users['${viewer}'].criteria_data.maxValue}
  Можливість змінити поле minValue характеристики на ${field_value}


Відображення зміненого мінімального значення характеристики
  [Tags]   ${USERS.users['${viewer}'].broker}: Редагування характеристики
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      modify_criteria
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}  CRITERIA
  Remove From Dictionary  ${USERS.users['${viewer}'].criteria_data}  minValue
  Звірити відображення поля minValue характеристики із ${USERS.users['${catalogues_admin}'].new_minValue} для користувача ${viewer}


Неможливість змінити мінімальне значення характеристики
  [Tags]   ${USERS.users['${viewer}'].broker}: Неможливість редагування характеристики
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      impossibility_modify_criteria
  ${field_value}=  create_fake_number  ${USERS.users['${viewer}'].criteria_data.minValue}  ${USERS.users['${viewer}'].criteria_data.maxValue}
  Перевірити неможливість зміни поля minValue характеристики на значення ${field_value} для користувача ${viewer}


Відображення незміненого мінімального значення у характеристики
  [Tags]   ${USERS.users['${viewer}'].broker}: Неможливість редагування характеристики
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      impossibility_modify_criteria
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}  CRITERIA
  Звірити відображення поля minValue характеристики із ${USERS.users['${catalogues_admin}'].criteria_data.minValue} для користувача ${viewer}


Можливість змінити максимальне значення характеристики
  [Tags]   ${USERS.users['${catalogues_admin}'].broker}: Редагування характеристики
  ...      catalogues_admin
  ...      ${USERS.users['${catalogues_admin}'].broker}
  ...      modify_criteria
  [Teardown]  Оновити LAST_MODIFICATION_DATE  CRITERIA
  ${min_value}=  Convert To Number  ${USERS.users['${viewer}'].criteria_data.minValue}
  ${field_value}=  create_fake_value_amount  ${min_value}
  Можливість змінити поле maxValue характеристики на ${field_value}


Відображення зміненого максимального значення характеристики
  [Tags]   ${USERS.users['${viewer}'].broker}: Редагування характеристики
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      modify_criteria
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}  CRITERIA
  Remove From Dictionary  ${USERS.users['${viewer}'].criteria_data}  maxValue
  Звірити відображення поля maxValue характеристики із ${USERS.users['${catalogues_admin}'].new_maxValue} для користувача ${viewer}


Неможливість змінити максимальне значення характеристики
  [Tags]   ${USERS.users['${viewer}'].broker}: Неможливість редагування характеристики
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      impossibility_modify_criteria
  ${field_value}=  create_fake_number  ${USERS.users['${catalogues_admin}'].criteria_data.minValue}  ${USERS.users['${catalogues_admin}'].criteria_data.maxValue}
  Перевірити неможливість зміни поля maxValue характеристики на значення ${field_value} для користувача ${viewer}


Відображення незміненого максимального значення у характеристики
  [Tags]   ${USERS.users['${viewer}'].broker}: Неможливість редагування характеристики
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      impossibility_modify_criteria
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}  CRITERIA
  Звірити відображення поля maxValue характеристики із ${USERS.users['${catalogues_admin}'].criteria_data.maxValue} для користувача ${viewer}


Неможливість змінити величину характеристики
  [Tags]   ${USERS.users['${catalogues_admin}'].broker}: Неможливість редагування характеристики
  ...      viewer
  ...      ${USERS.users['${catalogues_admin}'].broker}
  ...      impossibility_modify_criteria
  ${field_value}=  create_unit
  Перевірити неможливість зміни поля unit характеристики на значення ${field_value} для користувача ${catalogues_admin}


Відображення незміненої величини коду характеристики
  [Tags]   ${USERS.users['${viewer}'].broker}: Неможливість редагування характеристики
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      modify_criteria
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}  CRITERIA
  Звірити відображення поля unit.code характеристики із ${USERS.users['${catalogues_admin}'].criteria_data.unit.code} для користувача ${viewer}


Відображення незміненої величини назви характеристики
  [Tags]   ${USERS.users['${viewer}'].broker}: Неможливість редагування характеристики
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      modify_criteria
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}  CRITERIA
  Звірити відображення поля unit.name характеристики із ${USERS.users['${catalogues_admin}'].criteria_data.unit.name} для користувача ${viewer}


Неможливість видалити характеристику
  [Tags]   ${USERS.users['${viewer}'].broker}: Неможливість видалення характеристики
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      impossibility_delete_criteria
  [Teardown]  Оновити LAST_MODIFICATION_DATE  CRITERIA
  Неможливість ${viewer} видалити характеристику


Відображення статусу невидаленої характеристики
  [Tags]   ${USERS.users['${viewer}'].broker}: Неможливість видалення характеристики
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      impossibility_delete_criteria
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}  CRITERIA
  Remove From Dictionary  ${USERS.users['${viewer}'].criteria_data}  status
  Звірити відображення поля status характеристики із active для користувача ${viewer}


Можливість видалити характеристику
  [Tags]   ${USERS.users['${catalogues_admin}'].broker}: Видалення характеристики
  ...      criteria_admin
  ...      ${USERS.users['${catalogues_admin}'].broker}
  ...      delete_criteria
  [Teardown]  Оновити LAST_MODIFICATION_DATE  CRITERIA
  Можливість видалити характеристику


Відображення статусу видаленої характеристики
  [Tags]   ${USERS.users['${viewer}'].broker}: Видалення характеристики
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      delete_criteria
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}  CRITERIA
  Remove From Dictionary  ${USERS.users['${viewer}'].criteria_data}  status
  Звірити відображення поля status характеристики із retired для користувача ${viewer}
