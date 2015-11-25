*** Settings ***
Resource  resource.robot
Library  op_robot_tests.tests_files.service_keywords
Library  String
Library  Collections
Library  Selenium2Library
Library  DateTime
Library  Selenium2Screenshots
Library  DebugLibrary
Library  op_robot_tests.tests_files.brokers.openprocurement_client_helper

*** Keywords ***
TestSuiteSetup
    Завантажуємо дані про користувачів і майданчики
    Підготовка початкових даних

Set Suite Variable With Default Value
  [Arguments]  ${suite_var}  ${def_value}
  ${tmp}=  Get Variable Value  ${${suite_var}}  ${def_value}
  Set Suite Variable  ${${suite_var}}  ${tmp}

Завантажуємо дані про користувачів і майданчики
  Log  ${broker}
  Log  ${role}

  ${file_path}=  Get Variable Value  ${BROKERS_FILE}  brokers.yaml
  ${BROKERS}=  load_initial_data_from  ${file_path}
  log  ${BROKERS}
  Set Global Variable  ${BROKERS}

  ${brokers_list}=    Get Dictionary Items    ${BROKERS}
  log  ${brokers_list}

  ${file_path}=  Get Variable Value  ${USERS_FILE}  users.yaml
  ${USERS}=  load_initial_data_from  ${file_path}
  Set Global Variable  ${USERS}

  Set Suite Variable With Default Value  ${role}  ${BROKERS['${broker}'].roles.${role}}
  Set Suite Variable With Default Value  tender_owner  Tender_Owner
  Set Suite Variable With Default Value  provider      Tender_User
  Set Suite Variable With Default Value  provider1     Tender_User1
  Set Suite Variable With Default Value  viewer        Tender_Viewer
  ${active_users}=  Create Dictionary  tender_owner  ${tender_owner}  provider  ${provider}  provider1  ${provider1}  viewer  ${viewer}

  ${users_list}=    Get Dictionary Items    ${USERS.users}
  :FOR  ${username}  ${user_data}   IN  @{users_list}
  \  log  ${active_users}
  \  log  ${username}
  \  ${status}=  Run Keyword And Return Status   Dictionary Should Contain Value  ${active_users}   ${username}
  \  Run Keyword If   '${status}' == 'True'   Завантажуємо бібліотеку з реалізацією ${BROKERS['${USERS.users['${username}'].broker}'].keywords_file} майданчики
  \  Run Keyword If   '${status}' == 'True'   Викликати для учасника   ${username}  Підготувати клієнт для користувача

Підготовка початкових даних
  @{QUESTIONS} =  Create list
  ${question}=  test question data
  Append to list   ${QUESTIONS}   ${question}
  Set Global Variable  ${QUESTIONS}
  @{ANSWERS} =  Create list
  ${answer}=  test_question_answer_data
  Append to list   ${ANSWERS}   ${answer}
  Set Global Variable  ${ANSWERS}
  @{COMPLAINTS} =  Create list
  ${complaint}=  test_complaint_data
  Append to list   ${COMPLAINTS}   ${complaint}
  Set Global Variable  ${COMPLAINTS}
  @{REPLIES} =  Create list
  ${reply}=  test_complaint_reply_data
  Append to list   ${REPLIES}   ${reply}
  Set Global Variable  ${REPLIES}
  ${INITIAL_TENDER_DATA}=  Викликати для учасника     ${tender_owner}   Підготувати дані для оголошення тендера  ${BROKERS['${USERS.users['${tender_owner}'].broker}'].period_interval}   ${mode}
  Set Global Variable  ${INITIAL_TENDER_DATA}
  ${TENDER}=  Create Dictionary
  Set Global Variable  ${TENDER}
  Log  ${TENDER}
  Log  ${INITIAL_TENDER_DATA}

Завантажуємо бібліотеку з реалізацією ${keywords_file} майданчики
  Import Resource  ${CURDIR}/brokers/${keywords_file}.robot

##################################################################################
Дочекатись синхронізації з майданчиком
  [Arguments]  ${username}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tenderId
  ...      ${ARGUMENTS[2]} ==  id

  ${now}=  Get Current Date
  ${delta}=  Subtract Date From Date  ${now}  ${TENDER['LAST_MODIFICATION_DATE']}
  ${wait_timeout}=  Subtract Time From Time  ${BROKERS['${USERS.users['${username}'].broker}'].timeout_on_wait}  ${delta}
  Run Keyword If   ${wait_timeout}>0   Sleep  ${wait_timeout}

Звірити поле тендера
  [Arguments]  ${username}  ${field}
  ${field_value}=   Get_From_Object  ${INITIAL_TENDER_DATA.data}   ${field}
  Звірити поле    ${username}  ${field}  ${field_value}

Звірити поле
  [Arguments]  ${username}  ${field}   ${subject}
  ${field_response}=  Викликати для учасника    ${username}   Отримати інформацію із тендера   ${field}
  Should Not Be Equal  ${field_response}   ${None}
  Should Be Equal   ${subject}   ${field_response}   Майданчик ${USERS.users['${username}'].broker}

Звірити поле створеного тендера
  [Arguments]  ${initial}  ${tender_data}  ${field}
  ${field_value}=   Get_From_Object  ${initial}   ${field}
  ${field_response}=  Get_From_Object  ${tender_data}   ${field}
  Should Not Be Equal  ${field_response}   ${None}
  Should Not Be Equal  ${field_value}   ${None}
  Should Be Equal   ${field_value}   ${field_response}

Звірити дату тендера
  [Arguments]  ${username}  ${field}
  ${isodate}=   Get_From_Object  ${INITIAL_TENDER_DATA.data}   ${field}
  Should Not Be Equal  ${isodate}   ${None}
  Звірити дату  ${username}  ${field}  ${isodate}

Звірити дату
   [Arguments]  ${username}  ${field}   ${subject}
   ${field_date}=  Викликати для учасника    ${username}   Отримати інформацію із тендера  ${field}
   ${returned}=   compare_date   ${subject}  ${field_date}
   Should Not Be Equal  ${field_date}   ${None}
   Should Not Be Equal  ${returned}   ${None}
   Should Be True  '${returned}' == 'True'

Звірити поля предметів закупівлі багатопредметного тендера
  [Arguments]  ${username}  ${field}
  Дочекатись синхронізації з майданчиком    ${username}
  @{items}=  Get_From_Object  ${INITIAL_TENDER_DATA.data}     items
  ${len_of_items}=   Get Length   ${items}
  :FOR   ${index}    IN RANGE   ${len_of_items}
    \    Log   ${index}
    \    Звірити поле тендера   ${viewer}  items[${index}].${field}

Звірити дату предметів закупівлі багатопредметного тендера
  [Arguments]  ${username}  ${field}
  Дочекатись синхронізації з майданчиком    ${username}
  @{items}=  Get_From_Object  ${INITIAL_TENDER_DATA.data}     items
  ${len_of_items}=   Get Length   ${items}
  :FOR   ${index}    IN RANGE   ${len_of_items}
    \    Log   ${index}
    \    Звірити дату тендера   ${viewer}  items[${index}].${field}

Викликати для учасника
  [Documentation]
  ...    Cause sometimes keyword SHOULD fail to pass the testcase,
  ...    this keyword takes "shouldfail" argument as first one in @{arguments}
  ...    and switches the behaviour of keyword and "shouldfail"
  [Arguments]  ${username}  ${command}  @{arguments}
  log  ${username}
  log  ${command}
  log  ${arguments}
  ${state}=   change_state  ${arguments}
  ${value}=  Run keyword if  '${state}' == 'shouldfail'   SwitchState  ${username}  ${command}  @{arguments}
  ${value}=  Run keyword if  '${state}' == 'pass'   Normal  ${username}  ${command}  @{arguments}
  [return]   ${value}

Normal
  [Arguments]  ${username}  ${command}  @{arguments}
  log  ${username}
  log  ${command}
  log  ${arguments}
  ${value}=  Run Keyword   ${BROKERS['${USERS.users['${username}'].broker}'].keywords_file}.${command}  ${username}  @{arguments}
  [return]   ${value}

SwitchState
  [Arguments]  ${username}  ${command}  @{arguments}
  log  ${username}
  log  ${command}
  log  ${arguments}
  Remove From List  ${arguments}  0
  log  ${arguments}
  ${status}  ${value}=  run_keyword_and_ignore_keyword_definitions   ${BROKERS['${USERS.users['${username}'].broker}'].keywords_file}.${command}  ${username}  @{arguments}
  Run keyword if  '${status}' == 'PASS'   Log   Учасник ${username} зміг виконати "${command}"   WARN
  [return]   ${value}

Дочекатись дати
  [Arguments]  ${date}
  ${wait_timeout}=  wait_to_date  ${date}
  Run Keyword If   ${wait_timeout}>0   Sleep  ${wait_timeout}

Дочекатись дати початку прийому пропозицій
  Дочекатись дати  ${TENDER_DATA.data.tenderPeriod.startDate}

Дочекатись дати закінчення прийому пропозицій
  Дочекатись дати  ${TENDER_DATA.data.tenderPeriod.endDate}

Дочекатись дати початку аукціону
  Дочекатись дати  ${TENDER_DATA.data.auctionPeriod.startDate}

Дочекатись дати закінчення аукціону
  Дочекатись дати  ${TENDER_DATA.data.auctionPeriod.endDate}
