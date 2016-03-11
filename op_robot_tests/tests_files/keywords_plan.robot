*** Settings ***
Library  op_robot_tests.tests_files.service_keywords
Library  String
Library  Collections
Library  Selenium2Library
Library  DateTime
Library  DebugLibrary
Resource  keywords.robot

*** Keywords ***
Test Suite Plan Setup
  Set Suite Variable  ${WARN_RUN_AS}  ${False}
  Set Selenium Implicit Wait  5 s
  Set Selenium Timeout  10 s
  Завантажуємо дані про користувачів і майданчики для планів

Завантажуємо дані про користувачів і майданчики для планів
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
  Set Suite Variable With Default Value  plan_owner  Plan_Owner
  Set Suite Variable With Default Value  provider      Plan_User
  Set Suite Variable With Default Value  provider1     Plan_User1
  Set Suite Variable With Default Value  viewer        Plan_Viewer
  ${active_users}=  Create Dictionary  plan_owner=${plan_owner}  provider=${provider}  provider1=${provider1}  viewer=${viewer}

  ${users_list}=  Get Dictionary Items  ${USERS.users}
  :FOR  ${username}  ${user_data}  IN  @{users_list}
  \  Log  ${active_users}
  \  Log  ${username}
  \  ${munch_dict}=  munch_dict  data=${True}
  \  Log Many  ${munch_dict}
  \  ${status}=  Run Keyword And Return Status  Dictionary Should Contain Value  ${active_users}  ${username}
  \  ${keywords_file}=  Get Broker Property By Username  ${username}  keywords_file
  \  Run Keyword If  ${status}  Завантажуємо бібліотеку з реалізацією для майданчика ${keywords_file}
  \  Run Keyword If  ${status}  Викликати для учасника  ${username}  Підготувати клієнта для користувача
  \  Run Keyword If  ${status}  Set To Dictionary  ${USERS.users['${username}']}  plan_data=${munch_dict}

Підготовка початкових даних плану
  ${plan_data}=  test_plan_data
  ${PLAN}=  Create Dictionary
  Set Global Variable  ${PLAN}
  Log  ${PLAN}
  Log  ${plan_data}
  [return]  ${plan_data}
