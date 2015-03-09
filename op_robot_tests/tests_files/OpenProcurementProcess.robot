*** Setting ***
Library  op_robot_tests.tests_files.service_keywords
Library  String
LIbrary  Collections
LIbrary  Selenium2Library
Library  DebugLibrary

Test Setup  TestCaseSetup


*** Variables ***
@{important_fields}   description   minimalStep.amount   procuringEntity.name  tenderID  title   value.amount


*** Test Cases ***
Створення тендера
    [tags]   all_stages
    Власник тендера створив тендер
    Інші учасники побачили створений тендер
    [Teardown]  Close all browsers


*** Keywords ***
TestCaseSetup
    Завантажуємо дані про корисувачів і площадки
    Підготовка початкових даних


Завантажуємо дані про корисувачів і площадки

  # Init Brokers
  ${file_path}=  Get Variable Value  ${BROKERS_FILE}  brokers.yaml
  ${BROKERS}=  load_initial_data_from  ${file_path}
  Set Global Variable  ${BROKERS}
  ${brokers_list}=    Get Dictionary Items    ${BROKERS}
  :FOR  ${Broker_Name}  ${Broker_Data}   IN  @{brokers_list}
  \  Завантажуємо бібліотеку з реалізацією ${Broker_Data.broker_api} площадки

  # Init Users
  ${file_path}=  Get Variable Value  ${USERS_FILE}  users.yaml
  ${USERS}=  load_initial_data_from  ${file_path}
  Set Global Variable  ${USERS}
  ${users_list}=    Get Dictionary Items    ${USERS.users}
  :FOR  ${username}  ${user_data}   IN  @{users_list}
  \  Викликати "Підготувати клієнт для користувача" для учасника "${username}"

Підготовка початкових даних
  ${INITIAL_TENDER_DATA}=  prepare_test_tender_data
  Set Global Variable  ${INITIAL_TENDER_DATA}

Завантажуємо бібліотеку з реалізацією ${broker_api} площадки
  Import Resource  ${CURDIR}/brokers/${broker_api}.robot

Власник тендера створив тендер
  Викликати "Створити тендер" для учасника "${USERS.tender_owner}"
  Log  Учасник ${USERS.tender_owner} використовуючи майданчик ${USERS.users['${USERS.tender_owner}'].broker} з імплементацією api: ${BROKERS['${USERS.users['${USERS.tender_owner}'].broker}'].broker_api} створює тендер   WARN


Інші учасники побачили створений тендер
  Log  Очікуємо синхронізації з майданчиками   WARN
  Sleep   15
  ${users_list}=    Get Dictionary Items    ${USERS.users}
  :FOR    ${User_Name}  ${User_Data}   IN  @{users_list}
  \  Run Keyword If  '${User_Name}' != '${USERS.tender_owner}'   Учасник ${User_Name} побачив створений тендер


Учасник ${User_Name} побачив створений тендер
  Викликати "Звірити інформацію про тендер" для учасника "${username}"
  Log  Учасник ${User_Name} використовуючи майданчик ${USERS.users['${User_Name}'].broker} з імплементацією api: ${BROKERS['${USERS.users['${User_Name}'].broker}'].broker_api} перевірив створений тендер   WARN


Викликати "${command}" для учасника "${username}"
  Run keyword   ${BROKERS['${USERS.users['${username}'].broker}'].broker_api}.${command}  ${username}