*** Settings ***
Resource  resource.robot
Library  op_robot_tests.tests_files.service_keywords
Library  String
Library  Collections
Library  Selenium2Library
Library  DateTime
Library  Selenium2Screenshots
Library  DebugLibrary

*** Keywords ***
TestSuiteSetup
    Завантажуємо дані про користувачів і майданчики

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
  \  ${keywords_file}=  Get Broker Property By Username  ${username}  keywords_file
  \  Run Keyword If  '${status}' == 'True'  Завантажуємо бібліотеку з реалізацією для майданчика ${keywords_file}
  \  Run Keyword If  '${status}' == 'True'  Викликати для учасника  ${username}  Підготувати клієнт для користувача

Get Broker Property
  [Arguments]  ${broker_name}  ${property}
  [Documentation]
  ...      This keyword returns a property of specified broker
  ...      if that property exists, otherwise, it returns a
  ...      default value.
  ${status}=  Run Keyword And Return Status  Should Contain  ${BROKERS['${broker_name}']}  ${property}
  Return From Keyword If  ${status}  ${BROKERS['${broker_name}'].${property}}
  # If broker doesn't have that property, fall back to default value
  Should Contain  ${BROKERS['Default']}  ${property}
  [return]  ${BROKERS['Default'].${property}}

Get Broker Property By Username
  [Documentation]
  ...      This keyword gets the corresponding broker name
  ...      for a specified username and then calls
  ...      "Get Broker Property"
  [Arguments]  ${username}  ${property}
  ${broker_name}=  Get Variable Value  ${USERS.users['${username}'].broker}
  Run Keyword And Return  Get Broker Property  ${broker_name}  ${property}

Підготовка початкових даних
  @{QUESTIONS}=  Create list
  ${question}=  test question data
  Append to list  ${QUESTIONS}  ${question}
  Set Global Variable  @{QUESTIONS}
  @{ANSWERS}=  Create list
  ${answer}=  test_question_answer_data
  Append to list  ${ANSWERS}  ${answer}
  Set Global Variable  @{ANSWERS}
  @{COMPLAINTS}=  Create list
  ${complaint}=  test_complaint_data
  Append to list  ${COMPLAINTS}  ${complaint}
  Set Global Variable  @{COMPLAINTS}
  @{REPLIES}=  Create list
  ${reply}=  test_complaint_reply_data
  Append to list  ${REPLIES}  ${reply}
  Set Global Variable  @{REPLIES}
  ${custom_intervals}=  Get Broker Property By Username  ${tender_owner}  intervals
  ${default_intervals}=  Get Broker Property  Default  intervals
  ${period_intervals}=  merge_dicts  ${default_intervals}  ${custom_intervals}
  ${tender_data}=  prepare_test_tender_data  ${period_intervals}  ${mode}
  ${TENDER}=  Create Dictionary
  Set Global Variable  ${TENDER}
  Log  ${TENDER}
  Log  ${tender_data}
  [return]  ${tender_data}

Завантажуємо бібліотеку з реалізацією для майданчика ${keywords_file}
  Import Resource  ${CURDIR}/brokers/${keywords_file}.robot

##################################################################################
Дочекатись синхронізації з майданчиком
  [Arguments]  ${username}
  [Documentation]
  ...      Get ${wait_timeout} for specified user and wait
  ...      until that timeout runs out.
  ${now}=  Get Current Date
  ${delta}=  Subtract Date From Date  ${now}  ${TENDER['LAST_MODIFICATION_DATE']}
  ${timeout_on_wait}=  Get Broker Property By Username  ${username}  timeout_on_wait
  ${wait_timeout}=  Subtract Time From Time  ${timeout_on_wait}  ${delta}
  Run Keyword If   ${wait_timeout}>0   Sleep  ${wait_timeout}

Звірити поле тендера
  [Arguments]  ${username}  ${tender_data}  ${field}
  ${left}=  Get_From_Object  ${tender_data.data}  ${field}
  ${right}=  Викликати для учасника  ${username}  Отримати інформацію із тендера  ${field}
  Порівняти об'єкти  ${left}  ${right}

Порівняти об'єкти
  [Arguments]  ${left}  ${right}
  Should Not Be Equal  ${left}  ${None}
  Should Not Be Equal  ${right}  ${None}
  Should Be Equal  ${left}  ${right}

Звірити дату тендера
  [Arguments]  ${username}  ${tender_data}  ${field}
  ${left}=  Get_From_Object  ${tender_data.data}  ${field}
  ${right}=  Викликати для учасника  ${username}  Отримати інформацію із тендера  ${field}
  Звірити дату  ${left}  ${right}

Звірити дату
  [Arguments]  ${left}  ${right}
  Should Not Be Equal  ${left}  ${None}
  Should Not Be Equal  ${right}  ${None}
  ${status}=  compare_date  ${left}  ${right}
  Should Be True  ${status}

Звірити поля предметів закупівлі багатопредметного тендера
  [Arguments]  ${username}  ${tender_data}  ${field}
  Дочекатись синхронізації з майданчиком    ${username}
  @{items}=  Get_From_Object  ${tender_data.data}  items
  ${len_of_items}=   Get Length   ${items}
  :FOR   ${index}    IN RANGE   ${len_of_items}
    \    Log   ${index}
    \    Звірити поле тендера  ${viewer}  ${tender_data}  items[${index}].${field}

Звірити дату предметів закупівлі багатопредметного тендера
  [Arguments]  ${username}  ${tender_data}  ${field}
  Дочекатись синхронізації з майданчиком    ${username}
  @{items}=  Get_From_Object  ${tender_data.data}  items
  ${len_of_items}=   Get Length   ${items}
  :FOR   ${index}    IN RANGE   ${len_of_items}
    \    Log   ${index}
    \    Звірити дату тендера  ${viewer}  ${tender_data}  items[${index}].${field}

Викликати для учасника
  [Documentation]
  ...      Cause sometimes keyword SHOULD fail to pass the testcase,
  ...      this keyword takes "shouldfail" argument as first one in @{arguments}
  ...      and switches the behaviour of keyword and "shouldfail"
  [Arguments]  ${username}  ${command}  @{arguments}
  Log  ${username}
  Log  ${command}
  Log Many  @{arguments}
  ${state}=  change_state  ${arguments}
  Run Keyword And Return If  '${state}' == 'shouldfail'  SwitchState  ${username}  ${command}  @{arguments}
  Run Keyword And Return If  '${state}' == 'pass'  Normal  ${username}  ${command}  @{arguments}

Normal
  [Arguments]  ${username}  ${command}  @{arguments}
  Log  ${username}
  Log  ${command}
  Log Many  @{arguments}
  ${keywords_file}=  Get Broker Property By Username  ${username}  keywords_file
  Run Keyword And Return  ${keywords_file}.${command}  ${username}  @{arguments}

SwitchState
  [Arguments]  ${username}  ${command}  @{arguments}
  Log  ${username}
  Log  ${command}
  Log Many  @{arguments}
  Remove From List  ${arguments}  0
  Log Many  @{arguments}
  ${keywords_file}=  Get Broker Property By Username  ${username}  keywords_file
  ${status}  ${value}=  run_keyword_and_ignore_keyword_definitions  ${keywords_file}.${command}  ${username}  @{arguments}
  Run keyword if  '${status}' == 'PASS'   Log   Учасник ${username} зміг виконати "${command}"   WARN
  [return]   ${value}

Дочекатись дати
  [Arguments]  ${date}
  ${wait_timeout}=  wait_to_date  ${date}
  Run Keyword If   ${wait_timeout}>0   Sleep  ${wait_timeout}

Дочекатись дати початку прийому пропозицій
  Дочекатись дати  ${tender_data.data.tenderPeriod.startDate}

Дочекатись дати закінчення прийому пропозицій
  Дочекатись дати  ${tender_data.data.tenderPeriod.endDate}

Дочекатись дати початку аукціону
  Дочекатись дати  ${tender_data.data.auctionPeriod.startDate}

Дочекатись дати закінчення аукціону
  Дочекатись дати  ${tender_data.data.auctionPeriod.endDate}
