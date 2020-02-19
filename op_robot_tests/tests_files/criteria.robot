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

#########################################
#######NEGATIVE TESTS
#######
Превірка на відсутність можливості створення критерії
  [Tags]   ${USERS.users['${viewer}'].broker}: Оголошення характеристики
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      impossibility_create_criteria
  Відсутність можливості для ${viewer} створити критерію

Перевірка на відсутність характеристики
  [Tags]   ${USERS.users['${viewer}'].broker}: Оголошення характеристики
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      impossibility_view_criteria
  Перевірити на відсутність потенційно створеної характеристики по ідентифікатору для усіх користувачів
#######
###########################################

Відображення статусу характеристики
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних характеристики
  ...      viewer
  ...      ${USERS.users['${catalogues_admin}'].broker}
  ...      criteria_view_status
  Звірити відображення поля status характеристики із active для усіх користувачів


Відображення назви характеристики
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних характеристики
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      criteria_view_name
  Звірити відображення поля name характеристики для користувача ${viewer}


Відображення назви характеристики ангійською мовою
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних характеристики
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      criteria_view_name_us
  Звірити відображення поля nameEng характеристики для користувача ${viewer}


Відображення мінімального значення характеристики
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних характеристики
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      criteria_view_min
  Звірити відображення поля minValue характеристики для користувача ${viewer}


Відображення максмимального значення характеристики
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних характеристики
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      criteria_view_max
  Звірити відображення поля maxValue характеристики для користувача ${viewer}


Відображення коду одиниці виміру
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних характеристики
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      criteria_view_util_code
  Звірити відображення поля unit.code характеристики для користувача ${viewer}


Відображення назви одиниці виміру
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних характеристики
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      criteria_view_util_name
  Звірити відображення поля unit.name характеристики для користувача ${viewer}


Відображення типу даних характеристики
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних характеристики
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      criteria_view_type_data
  Звірити відображення поля dataType характеристики для користувача ${viewer}


Відображення коду класифікатора
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних характеристики
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      criteria_view_classifications_id
  Звірити відображення поля classification.id характеристики для користувача ${viewer}


Відображення назви коду класифікатора
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних характеристики
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      criteria_view_classifications_description
  Звірити відображення поля classification.description характеристики для користувача ${viewer}


Відображення ознаки довідника коду класифікатора
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних характеристики
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      criteria_view_classifications_scheme
  Звірити відображення поля classification.scheme характеристики для користувача ${viewer}


Відображення коду додаткового класифікатора
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних характеристики
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      criteria_view_additionalClassification_id
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}  CRITERIA
  Звірити відображення поля additionalClassification.id характеристики для користувача ${viewer}


Відображення назви коду додаткового класифікатора
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних характеристики
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      criteria_view_additionalClassification_description
  Звірити відображення поля additionalClassification.description характеристики для користувача ${viewer}


Відображення ознаки довідника коду додаткового класифікатора
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних характеристики
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      criteria_view_additionalClassification_scheme
  Звірити відображення поля additionalClassification.scheme характеристики для користувача ${viewer}


Можливість змінити назву характеристики
  [Tags]   ${USERS.users['${catalogues_admin}'].broker}: Редагування характеристики
  ...      catalogues_admin
  ...      ${USERS.users['${catalogues_admin}'].broker}
  ...      modify_criteria_name
  [Teardown]  Оновити LAST_MODIFICATION_DATE  CRITERIA
  ${field_value}=  create_fake_sentence
  Можливість змінити поле name характеристики на ${field_value}


Відображення зміненої назви характеристики
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення характеристики
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      view_modified_criteria_name
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}  CRITERIA
  Remove From Dictionary  ${USERS.users['${viewer}'].criteria_data}  name
  Звірити відображення поля name характеристики із ${USERS.users['${catalogues_admin}'].new_name} для користувача ${viewer}

##################################################
#######NEGATIVE TESTS
Відсутність можливості змінити назву характерестики
    [Tags]   ${USERS.users['${viewer}'].broker}: Відображення характеристики
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      impossibility_modify_criteria
  ${field_value_name}=  create_fake_sentence
  Відсутність можливості змінити поле name характеристики на ${field_value_name}

Перевірити чи змінено назву характеристики
  [Tags]   ${USERS.users['${viewer}'].broker}: Редагування характеристики
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      impossibility_modify_criteria_view
  Remove From Dictionary  ${USERS.users['${viewer}'].criteria_data}  name
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}  CRITERIA
  Перевірити чи не відбулися зміни поля name характеристики із ${USERS.users['${catalogues_admin}'].exeption_name} для користувача ${viewer}
##########
####################################################

Можливість змінити назву англійською мовою характеристики
  [Tags]   ${USERS.users['${catalogues_admin}'].broker}: Редагування характеристики
  ...      catalogues_admin
  ...      ${USERS.users['${catalogues_admin}'].broker}
  ...      modify_criteria_view_by_en
  [Teardown]  Оновити LAST_MODIFICATION_DATE  CRITERIA
  ${field_value}=  create_fake_eng_sentence
  Можливість змінити поле nameEng характеристики на ${field_value}


Відображення зміненої назви англійською мовою характеристики
  [Tags]   ${USERS.users['${viewer}'].broker}: Редагування характеристики
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      view_modified_criteria_by_en
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}  CRITERIA
  Remove From Dictionary  ${USERS.users['${viewer}'].criteria_data}  nameEng
  Звірити відображення поля nameEng характеристики із ${USERS.users['${catalogues_admin}'].new_nameEng} для користувача ${viewer}


Можливість змінити мінімальне значення характеристики
  [Tags]   ${USERS.users['${catalogues_admin}'].broker}: Редагування характеристики
  ...      catalogues_admin
  ...      ${USERS.users['${catalogues_admin}'].broker}
  ...      modify_criteria_min_value
  [Teardown]  Оновити LAST_MODIFICATION_DATE  CRITERIA
  ${field_value}=  create_fake_number  ${USERS.users['${viewer}'].criteria_data.minValue}  ${USERS.users['${viewer}'].criteria_data.maxValue}
  Можливість змінити поле minValue характеристики на ${field_value}


Відображення зміненого мінімального значення характеристики
  [Tags]   ${USERS.users['${viewer}'].broker}: Редагування характеристики
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      view_modified_criteria_min_value
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}  CRITERIA
  Remove From Dictionary  ${USERS.users['${viewer}'].criteria_data}  minValue
  Звірити відображення поля minValue характеристики із ${USERS.users['${catalogues_admin}'].new_minValue} для користувача ${viewer}

#############################################################################
######NEGATIVE TESTS

Відсутність можливості змінити мінімальне значення характеристики
  [Tags]   ${USERS.users['${viewer}'].broker}: Редагування характеристики
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      impossibility_modify_criteria_min_value
  ${field_value_min}=  create_fake_number  ${USERS.users['${viewer}'].criteria_data.minValue}  ${USERS.users['${viewer}'].criteria_data.maxValue}
  Відсутність можливості змінити поле minValue характеристики на ${field_value_min}

Перевірити чи не відбулися зміни в полі мінімальне значення характеристики
  [Tags]   ${USERS.users['${viewer}'].broker}: Редагування характеристики
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      impossibility_view_criteria_min_value
  Remove From Dictionary  ${USERS.users['${viewer}'].criteria_data}  minValue
  Перевірити чи не відбулися зміни поля minValue характеристики із ${USERS.users['${catalogues_admin}'].exeption_minValue} для користувача ${viewer}
#######
##############################################################################

Можливість змінити максимальне значення характеристики
  [Tags]   ${USERS.users['${catalogues_admin}'].broker}: Редагування характеристики
  ...      catalogues_admin
  ...      ${USERS.users['${catalogues_admin}'].broker}
  ...      modify_criteria_max_value
  [Teardown]  Оновити LAST_MODIFICATION_DATE  CRITERIA
  ${min_value}=  Convert To Number  ${USERS.users['${viewer}'].criteria_data.minValue}
  ${field_value}=  create_fake_value_amount  ${min_value}
  Можливість змінити поле maxValue характеристики на ${field_value}


Відображення зміненого максимального значення характеристики
  [Tags]   ${USERS.users['${viewer}'].broker}: Редагування характеристики
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      view_modified_criteria_max_value
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}  CRITERIA
  Remove From Dictionary  ${USERS.users['${viewer}'].criteria_data}  maxValue
  Звірити відображення поля maxValue характеристики із ${USERS.users['${catalogues_admin}'].new_maxValue} для користувача ${viewer}

########################################################################
###########NEGATIVE TESTS

Відсутність можливості змінити максимальне значення характеристики
  [Tags]   ${USERS.users['${viewer}'].broker}: Редагування характеристики
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      impossibility_modify_criteria_max_value
  ${field_value_max}=  create_fake_number  ${USERS.users['${viewer}'].criteria_data.minValue}  ${USERS.users['${viewer}'].criteria_data.maxValue}
  Відсутність можливості змінити поле maxValue характеристики на ${field_value_max}

Перевірити чи відбулися зміни в полі максимальне значення характеристики
  [Tags]   ${USERS.users['${viewer}'].broker}: Редагування характеристики
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      impossibility_view_criteria_min_value
  Remove From Dictionary  ${USERS.users['${viewer}'].criteria_data}  maxValue
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}  CRITERIA
  Перевірити чи не відбулися зміни поля maxValue характеристики із ${USERS.users['${catalogues_admin}'].exeption_maxValue} для користувача ${viewer}

###########
########################################################################

Можливість видалити характеристику
  [Tags]   ${USERS.users['${catalogues_admin}'].broker}: Видалення характеристики
  ...      criteria_admin
  ...      ${USERS.users['${catalogues_admin}'].broker}
  ...      delete_criteria
  [Teardown]  Оновити LAST_MODIFICATION_DATE  CRITERIA
  Можливість видалити характеристику

Відображення статусу видаленої характеристики
  [Tags]   ${USERS.users['${viewer}'].broker}: Переглянути статус видаленої характеристики
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      view_status_ofter_deleted_criteria
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}  CRITERIA
  Remove From Dictionary  ${USERS.users['${viewer}'].criteria_data}  status
  Звірити відображення поля status характеристики із retired для користувача ${viewer}

###################################################
#########NEGATIVE TESTS
Відсутність можливості видалити
  [Tags]   ${USERS.users['${viewer}'].broker}: Видалення характеристики
  ...      criteria_admin
  ...      ${USERS.users['${viewer}'].broker}
  ...      impossibility_delete_criteria
  [Teardown]  Оновити LAST_MODIFICATION_DATE  CRITERIA
  Відсутність можливості ${viewer} видалити характеристику


Відображення статусу потеційно видаленої характеристики
  [Tags]   ${USERS.users['${viewer}'].broker}: Видалення характеристики
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      check_no_delete_criteria
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}  CRITERIA
  Remove From Dictionary  ${USERS.users['${viewer}'].criteria_data}  status
  Звірити відображення поля status характеристики із active для користувача ${viewer}
####################################################