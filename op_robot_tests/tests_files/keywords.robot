*** Settings ***
Library  op_robot_tests.tests_files.service_keywords
Library  String
Library  Collections
Library  Selenium2Library
Library  DateTime
Library  DebugLibrary

Documentation
...  This resource file contains keywords that are used directly by
...  test suites or by brokers' keyword libraries (also known as drivers).

*** Keywords ***
Test Suite Setup
  Set Selenium Implicit Wait  5 s
  Set Selenium Timeout  10 s
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
  Log  ${BROKERS}
  Set Suite Variable  ${BROKERS}

  ${file_path}=  Get Variable Value  ${USERS_FILE}  users.yaml
  ${USERS}=  load_initial_data_from  ${file_path}
  Set Global Variable  ${USERS}

  Set Suite Variable With Default Value  ${role}  ${BROKERS['${broker}'].roles.${role}}
  Set Suite Variable With Default Value  tender_owner  Tender_Owner
  Set Suite Variable With Default Value  provider      Tender_User
  Set Suite Variable With Default Value  provider1     Tender_User1
  Set Suite Variable With Default Value  viewer        Tender_Viewer
  ${active_users}=  Create Dictionary  tender_owner=${tender_owner}  provider=${provider}  provider1=${provider1}  viewer=${viewer}

  ${users_list}=  Get Dictionary Items  ${USERS.users}
  :FOR  ${username}  ${user_data}  IN  @{users_list}
  \  Log  ${active_users}
  \  Log  ${username}
  \  ${munch_dict}=  munch_dict  data=${True}
  \  Log Many  ${munch_dict}
  \  ${status}=  Run Keyword And Return Status  Dictionary Should Contain Value  ${active_users}  ${username}
  \  ${keywords_file}=  Get Broker Property By Username  ${username}  keywords_file
  \  Run Keyword If  ${status}  Завантажуємо бібліотеку з реалізацією для майданчика ${keywords_file}
  \  Run Keyword If  ${status}  Викликати для учасника  ${username}  Підготувати клієнт для користувача
  \  Run Keyword If  ${status}  Set To Dictionary  ${USERS.users['${username}']}  tender_data=${munch_dict}


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
  ${question_lot}=  test_lot_question_data  ${question}
  Append to list  ${QUESTIONS}  ${question}  ${question_lot}
  Set Global Variable  @{QUESTIONS}
  @{ANSWERS}=  Create list
  ${answer}=  test_question_answer_data
  Append to list  ${ANSWERS}  ${answer}
  Set Global Variable  @{ANSWERS}
  @{COMPLAINTS}=  Create list
  ${complaint}=  test_complaint_data
  ${complaint_lot}=  test_lot_complaint_data  ${complaint}
  Append to list  ${COMPLAINTS}  ${complaint}  ${complaint_lot}
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
  ${bundled_st}=  Run Keyword And Return Status  Import Resource  ${CURDIR}${/}brokers${/}${keywords_file}.robot
  ${external_st}=  Run Keyword And Return Status  Import Resource  ${CURDIR}${/}..${/}..${/}src${/}robot_tests.broker.${keywords_file}${/}${keywords_file}.robot
  Run Keyword If  ${bundled_st} == ${external_st} == ${False}  Fail  Resource file ${keywords_file}.robot not found
  Run Keyword If  ${bundled_st} == ${external_st} == ${True}  Fail  Resource file ${keywords_file}.robot found in both brokers${/} and src${/}


Дочекатись синхронізації з майданчиком
  [Arguments]  ${username}
  [Documentation]
  ...      Find out how much time has passed since the procurement was modified
  ...      and store the result in `delta`,
  ...      then get `timeout_on_wait` for ``username``,
  ...      then wait for `sleep` seconds, where:
  ...
  ...      sleep = timeout_on_wait - delta
  ...
  ...      Thus, when this keyword is executed several times in a row,
  ...      it will wait for as long as really needed.
  ...
  ...      Example:
  ...
  ...      The procurement is modified.
  ...      In 5 seconds, this keyword is called for `viewer`.
  ...      Immediately, this keyword is called for `provider`.
  ...      Timeout for `viewer` is 60.
  ...      Timeout for `provider` is 300.
  ...      First call (for `viewer`) will trigger `Sleep 55`.
  ...      Second call (for `provider`) will trigger `Sleep 235`.
  ...      As a result, the delay will end in 300 seconds
  ...      since last modification date.
  ...
  ...      Another example (a variation of previous one):
  ...
  ...      Timeout for `viewer` is 120.
  ...      Timeout for `provider` is 30.
  ...      First call will trigger `Sleep 115`.
  ...      Second call will trigger `Sleep 0`,
  ...      since we have already slept for 120 seconds
  ...      and there is no need to sleep any longer.
  ${now}=  Get Current TZdate
  ${delta}=  Subtract Date From Date  ${now}  ${TENDER['LAST_MODIFICATION_DATE']}
  ${timeout_on_wait}=  Get Broker Property By Username  ${username}  timeout_on_wait
  ${sleep}=  Subtract Time From Time  ${timeout_on_wait}  ${delta}
  Run Keyword If  ${sleep} > 0  Sleep  ${sleep}


Звірити поле тендера
  [Arguments]  ${username}  ${tender_data}  ${field}
  ${left}=  Get_From_Object  ${tender_data.data}  ${field}
  Звірити поле тендера із значенням  ${username}  ${left}  ${field}


Звірити поле тендера із значенням
  [Arguments]  ${username}  ${left}  ${field}
  ${right}=  Викликати для учасника  ${username}  Отримати інформацію із тендера  ${field}
  Порівняти об'єкти  ${left}  ${right}
  Set_To_Object  ${USERS.users['${username}'].tender_data.data}  ${field}  ${left}


Порівняти об'єкти
  [Arguments]  ${left}  ${right}
  Should Not Be Equal  ${left}  ${None}
  Should Not Be Equal  ${right}  ${None}
  Should Be Equal  ${left}  ${right}


Звірити дату тендера
  [Arguments]  ${username}  ${tender_data}  ${field}
  ${left}=  Get_From_Object  ${tender_data.data}  ${field}
  Звірити дату тендера із значенням  ${username}  ${left}  ${field}


Звірити дату тендера із значенням
  [Arguments]  ${username}  ${left}  ${field}
  ${right}=  Викликати для учасника  ${username}  Отримати інформацію із тендера  ${field}
  Порівняти дати  ${left}  ${right}
  Set_To_Object  ${USERS.users['${username}'].tender_data.data}  ${field}  ${left}


Порівняти дати
  [Documentation]
  ...      Compare dates with specified ``accuracy`` (in seconds).
  ...      Default is `60`.
  ...
  ...      The keyword will fail if the difference between
  ...      ``left`` and ``right`` dates is more than ``accuracy``,
  ...      otherwise it will pass.
  [Arguments]  ${left}  ${right}  ${accuracy}=60
  Should Not Be Equal  ${left}  ${None}
  Should Not Be Equal  ${right}  ${None}
  ${status}=  compare_date  ${left}  ${right}  ${accuracy}
  Should Be True  ${status}


Звірити поля предметів закупівлі багатопредметного тендера
  [Arguments]  ${username}  ${tender_data}  ${field}
  @{items}=  Get_From_Object  ${tender_data.data}  items
  ${len_of_items}=  Get Length  ${items}
  :FOR  ${index}  IN RANGE  ${len_of_items}
  \  Log  ${index}
  \  Звірити поле тендера  ${viewer}  ${tender_data}  items[${index}].${field}


Звірити дату предметів закупівлі багатопредметного тендера
  [Arguments]  ${username}  ${tender_data}  ${field}
  @{items}=  Get_From_Object  ${tender_data.data}  items
  ${len_of_items}=  Get Length  ${items}
  :FOR  ${index}  IN RANGE  ${len_of_items}
  \  Log  ${index}
  \  Звірити дату тендера  ${viewer}  ${tender_data}  items[${index}].${field}


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
  Run keyword if  '${status}' == 'PASS'  Fail  Користувач ${username} зміг виконати "${command}"
  [return]  ${value}


Дочекатись дати
  [Arguments]  ${date}
  ${sleep}=  wait_to_date  ${date}
  Run Keyword If  ${sleep} > 0  Sleep  ${sleep}


Дочекатись дати початку прийому пропозицій
  [Arguments]  ${username}
  Log  ${username}
  # This tries to get the date from current user's procurement data cache.
  # On failure, it reads from tender_owner's cached initial_data.
  # XXX: This is a dirty hack!
  # HACK: It was left here only for backward compatibiliy.
  # HACK: Before caching was implemented, this keyword used to look into
  # HACK: tender_owner's initial_data.
  # HACK: This should be cleaned up as soon as each broker implements reading
  # HACK: of the needed dates from tender's page.
  ${status}  ${date}=  Run Keyword And Ignore Error
  ...      Set Variable
  ...      ${USERS.users['${username}'].tender_data.data.tenderPeriod.startDate}
  # By default if condition is not satisfied, variable is set to None.
  # The third argument sets the variable to itself instead of None.
  ${date}=  Set Variable If
  ...      '${status}' == 'FAIL'
  ...      ${USERS.users['${tender_owner}'].initial_data.data.tenderPeriod.startDate}
  ...      ${date}
  Дочекатись дати  ${date}


Дочекатись дати закінчення прийому пропозицій
  [Arguments]  ${username}
  Log  ${username}
  # XXX: HACK: Same as above
  ${status}  ${date}=  Run Keyword And Ignore Error
  ...      Set Variable
  ...      ${USERS.users['${username}'].tender_data.data.tenderPeriod.endDate}
  ${date}=  Set Variable If
  ...      '${status}' == 'FAIL'
  ...      ${USERS.users['${tender_owner}'].initial_data.data.tenderPeriod.endDate}
  ...      ${date}
  Дочекатись дати  ${date}


Дочекатись дати початку аукціону
  [Arguments]  ${username}
  Log  ${username}
  # Can't use that dirty hack here since we don't know
  # the date of auction when creating the procurement :)
  Дочекатись дати  ${USERS.users['${username}'].tender_data.data.auctionPeriod.startDate}


Дочекатись дати закінчення аукціону
  [Arguments]  ${username}  ${tender_uaid}
  ${status}  ${endDate}=  Run Keyword And Ignore Keyword Definitions  Wait Until Keyword Succeeds  20x  15s  Викликати для учасника  ${username}  Отримати дату кінця аукціону  ${tender_uaid}
  Run keyword if  ${status} == 'FAIL'  Sleep  1500
