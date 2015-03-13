*** Setting ***
Library  op_robot_tests.tests_files.service_keywords
Library  String
LIbrary  Collections
LIbrary  Selenium2Library
Library  DebugLibrary

Suite Setup  TestCaseSetup
Suite Teardown  Close all browsers


*** Variables ***
${viewer}    E-tender User
${provider}   Andrew
@{item_fields}   description   quantity   classification.id  classification.description  deliveryAddress  deliveryDate

*** Test Cases ***
Можливість оголосити тендер
  [Tags]   ${USERS.users['${USERS.tender_owner}'].broker}: Можливість оголосити тендер
  Викликати для учасника     ${USERS.tender_owner}   Створити тендер
  ${LAST_MODIFICATION_DATE}=  Get Current Date
  Set Global Variable   ${LAST_MODIFICATION_DATE}

Пошук тендера по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук тендера по ідентифікатору
  Дочекатись синхронізації з майданчиком    ${viewer}
  Викликати для учасника   ${viewer}   Пошук тендера по ідентифікатору   ${TENDER_DATA.data.tenderID}   ${TENDER_DATA.data.id}

Відображення заголовоку оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Звірити поле тендера   ${viewer}  title

Відображення tenderID оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Звірити поле тендера   ${viewer}  tenderID

Відображення опису оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Звірити поле тендера   ${viewer}  description

Відображення початоку періоду уточнення оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Звірити поле тендера   ${viewer}  enquiryPeriod.startDate

Відображення закінчення періоду уточнення оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Звірити поле тендера   ${viewer}  enquiryPeriod.endDate

Відображення початоку періоду прийому пропозицій оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Звірити поле тендера   ${viewer}  tenderPeriod.startDate

Відображення закінчення періоду прийому пропозицій оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Звірити поле тендера   ${viewer}  tenderPeriod.endDate

Відображення бюджету оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Звірити поле тендера   ${viewer}  value.amount

Відображення мінімального кроку оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Звірити поле тендера   ${viewer}  minimalStep.amount

Відображення procuringEntity.name оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Звірити поле тендера   ${viewer}  procuringEntity.name




Відображення предмету закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення однопредметного тендера
  Звірити поле тендера   ${viewer}  items[0].description

Відображення кількісті предметів закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення однопредметного тендера
  Звірити поле тендера   ${viewer}  items[0].quantity

Відображення класифікаторів закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення однопредметного тендера
  Звірити поле тендера   ${viewer}  items[0].classification.id
  Звірити поле тендера   ${viewer}  items[0].classification.description

Відображення місце поставки закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення однопредметного тендера
  Звірити поле тендера   ${viewer}  items[0].deliveryAddress

Відображення строки поставки закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення однопредметного тендера
  Звірити поле тендера   ${viewer}  items[0].deliveryDate.endDate

Задати питання
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість задати запитання
  Викликати для учасника   ${provider}   Задати питання    ${TENDER_DATA.data.id}   ${QUESTIONS[0]}
  ${LAST_MODIFICATION_DATE}=  Get Current Date
  Set Global Variable   ${LAST_MODIFICATION_DATE}
  отримати останні зміни в тендері


Відображення заголовоку анонімного питання без відповіді
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення анонімного питання без відповідей
  Дочекатись синхронізації з майданчиком    ${viewer}
  Викликати для учасника   ${viewer}   обновити сторінку з тендером   ${TENDER_DATA.data.tenderID}   ${TENDER_DATA.data.id}
  Звірити поле тендера   ${viewer}  questions[0].title

Відображення опис анонімного питання без відповіді
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення анонімного питання без відповідей
  Звірити поле тендера   ${viewer}  questions[0].description


Відображення дата анонімного питання без відповіді
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення анонімного питання без відповідей
  Звірити поле тендера   ${viewer}  questions[0].date

  # ${users_list}=    Get Dictionary Items    ${USERS.users}
  # :FOR    ${username}  ${User_Data}   IN  @{users_list}
  # \  Run Keyword If  '${User_Name}' != '${USERS.tender_owner}'   Відображення основних даних оголошеного тендера   ${username}
#
# Відображення однопредметного тендера
  # ${users_list}=    Get Dictionary Items    ${USERS.users}
  # :FOR    ${username}  ${User_Data}   IN  @{users_list}
  # \  Run Keyword If  '${User_Name}' != '${USERS.tender_owner}'   Відображення однопредметного тендера  ${username}
#
#
# Можливість змінити основні властивості тендера
    # [tags]   all_stages
    # Власник змінив основні властивості тендера
    # Інші учасники побачили створений тендер
#
# Питання і відповідь
  # Учасник Andrew задав 1-ше питання
  # Інші учасники побачили 1-ше питання
  # Власник відповів на 1-ше питання
  # Інші учасники побачили відповідь на 1-ше питання
#


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
  \  Завантажуємо бібліотеку з реалізацією ${Broker_Data.keywords_file} площадки
  # Init Users
  ${file_path}=  Get Variable Value  ${USERS_FILE}  users.yaml
  ${USERS}=  load_initial_data_from  ${file_path}
  Set Global Variable  ${USERS}
  ${users_list}=    Get Dictionary Items    ${USERS.users}
  :FOR  ${username}  ${user_data}   IN  @{users_list}
  \  Викликати для учасника   ${username}  Підготувати клієнт для користувача

Підготовка початкових даних
  @{QUESTIONS} =  Create list
  ${question}=  test question data
  Append to list   ${QUESTIONS}   ${question}
  Set Global Variable  ${QUESTIONS}
  ${INITIAL_TENDER_DATA}=  prepare_test_tender_data
  Set Global Variable  ${INITIAL_TENDER_DATA}

Завантажуємо бібліотеку з реалізацією ${keywords_file} площадки
  Import Resource  ${CURDIR}/brokers/${keywords_file}.robot


##################################################################################
Дочекатись синхронізації з майданчиком
  [Arguments]  ${username}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tenderId
  ...      ${ARGUMENTS[2]} ==  id

  ${now}=  Get Current Date
  ${delta}=  Subtract Date From Date  ${now}  ${LAST_MODIFICATION_DATE}
  ${wait_timout}=  Subtract Time From Time  ${BROKERS['${USERS.users['${username}'].broker}'].timout_on_wait}  ${delta}
  Run Keyword If   ${wait_timout}>0   Sleep  ${wait_timout}

отримати останні зміни в тендері
  ${TENDER_DATA}=   Викликати для учасника   ${USERS.tender_owner}   Пошук тендера по ідентифікатору   ${TENDER_DATA.data.tenderID}   ${TENDER_DATA.data.id}
  Set To Dictionary  ${TENDER_DATA}   access_token   ${access_token}
  Set Global Variable  ${TENDER_DATA}
  Log object data  ${TENDER_DATA}  tender_with_question

Звірити поле тендера
  [Arguments]  ${username}  ${field}
  ${field_response}=  Викликати для учасника    ${username}   отримати інформацію із тендера  ${field}
  ${field_value}=   Get_From_Object  ${TENDER_DATA.data}   ${field}
  Should Be Equal   ${field_value}   ${field_response}   Майданчик ${USERS.users['${username}'].broker}


Викликати для учасника
  [Arguments]  ${username}  ${command}  @{arguments}
  ${status}  ${value}=  run_keyword_and_ignore_keyword_definations   ${BROKERS['${USERS.users['${username}'].broker}'].keywords_file}.${command}  ${username}  @{arguments}
  Run keyword if  '${status}' == 'FAIL'   Log   Учасник ${username} не зміг виконати "${command}"   WARN
  [return]   ${value}
