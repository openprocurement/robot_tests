*** Settings ***
Library  op_robot_tests.tests_files.brokers.openprocurement_client_helper

*** Keywords ***
Підготувати клієнт для користувача
  [Arguments]  ${username}
  [Documentation]  Відкрити брaвзер, створити обєкт api wrapper, тощо
  ${api_wrapper}=  prepare_api_wrapper  ${BROKERS['${USERS.users['${username}'].broker}'].api_key}
  Set To Dictionary  ${USERS.users['${username}']}   client  ${api_wrapper}
  Log Variables

Створити тендер
  [Arguments]  ${username}
  ${INITIAL_TENDER_DATA}=  prepare_test_tender_data
  Log object data  ${INITIAL_TENDER_DATA}
  ${TENDER_DATA}=  Call Method  ${USERS.users['${username}'].client}  create_tender  ${INITIAL_TENDER_DATA}
  Log object data  ${TENDER_DATA}  cteated_tender
  ${access_token}=  Get Variable Value  ${TENDER_DATA.access.token}
  Set To Dictionary  ${USERS.users['${username}']}   access_token   ${access_token}
  Log   access_token: ${access_token}
  Log   tender_id: ${TENDER_DATA.data.id}
  Log Variables
  Set Global Variable  ${TENDER_DATA}

Звірити інформацію про тендер
  [Arguments]  ${username}
  ${tender}=  Call Method  ${USERS.users['${username}'].client}  get_tender  ${TENDER_DATA.data.id}
  Log object data  ${tender}
  :FOR   ${field}    IN  @{important_fields}
  \  Page Should Contain  ${TENDER_DATA.data.${field}}
  \  Log   Учасник ${username} звірив поле "${field}"  warn