*** Settings ***
Library  op_robot_tests.tests_files.brokers.openprocurement_client_helper

*** Keywords ***
Підготувати клієнт для користувача
  [Arguments]  @{ARGUMENTS}
  [Documentation]  Відкрити брaвзер, створити обєкт api wrapper, тощо
  ${api_wrapper}=  prepare_api_wrapper  ${BROKERS['${USERS.users['${ARGUMENTS[0]}'].broker}'].api_key}
  Set To Dictionary  ${USERS.users['${ARGUMENTS[0]}']}   client  ${api_wrapper}
  Log Variables

Створити тендер
  [Arguments]  @{ARGUMENTS}
  ${INITIAL_TENDER_DATA}=  prepare_test_tender_data
  Log object data  ${INITIAL_TENDER_DATA}
  ${TENDER_DATA}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  create_tender  ${INITIAL_TENDER_DATA}
  Log object data  ${TENDER_DATA}  cteated_tender
  ${access_token}=  Get Variable Value  ${TENDER_DATA.access.token}
  Set Global Variable  ${access_token}
  Set To Dictionary  ${USERS.users['${ARGUMENTS[0]}']}   access_token   ${access_token}
  Log   access_token: ${access_token}
  Log   tender_id: ${TENDER_DATA.data.id}
  Set Global Variable  ${TENDER_DATA}
  [return]  ${TENDER_DATA}

Пошук тендера по ідентифікатору
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tenderId
  ...      ${ARGUMENTS[2]} ==  id
  ${tender_data}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  get_tender  ${ARGUMENTS[2]}
  Set To Dictionary  ${USERS.users['${ARGUMENTS[0]}']}   tender_data   ${tender_data}
  [return]   ${tender_data}


отримати інформацію із тендера
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  fieldname
  [return]  ${USERS.users['${ARGUMENTS[0]}'].tender_data.data.${ARGUMENTS[1]}}



отримати інформацію про description для предмету закупівлі в однопредметному тендері
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  [return]  ${USERS.users['${ARGUMENTS[0]}'].tender_data.data['items'][0].description}

отримати інформацію про quantity для предмету закупівлі в однопредметному тендері
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  [return]  ${USERS.users['${ARGUMENTS[0]}'].tender_data.data['items'][0].quantity}


отримати інформацію про classification.id для предмету закупівлі в однопредметному тендері
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  [return]  ${USERS.users['${ARGUMENTS[0]}'].tender_data.data['items'][0].classification.id}


отримати інформацію про classification.description для предмету закупівлі в однопредметному тендері
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  [return]  ${USERS.users['${ARGUMENTS[0]}'].tender_data.data['items'][0].classification.description}


отримати інформацію про deliveryAddress для предмету закупівлі в однопредметному тендері
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  [return]  ${USERS.users['${ARGUMENTS[0]}'].tender_data.data['items'][0].deliveryAddress}

отримати інформацію про deliveryDate для предмету закупівлі в однопредметному тендері
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  [return]  ${USERS.users['${ARGUMENTS[0]}'].tender_data.data['items'][0].deliveryDate}

Внести зміни в тендер
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  id
  ...      ${ARGUMENTS[2]} ==  fieldname
  ...      ${ARGUMENTS[3]} ==  fieldvalue
  отримати тендер   ${ARGUMENTS[0]}   ${ARGUMENTS[1]}
  Set_To_Object  ${TENDER_DATA.data}   ${ARGUMENTS[2]}   ${ARGUMENTS[3]}

  ${TENDER_DATA}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  patch_tender  ${TENDER_DATA}
  ${TENDER_DATA}=  set_access_key  ${TENDER_DATA}  ${USERS.users['${ARGUMENTS[0]}'].access_token}
  Set Global Variable  ${TENDER_DATA}

отримати тендер
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  id
  ${TENDER_DATA}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  get_tender  ${ARGUMENTS[1]}
  Log object data  ${TENDER_DATA}
  ${TENDER_DATA}=  set_access_key  ${TENDER_DATA}  ${USERS.users['${ARGUMENTS[0]}'].access_token}
  Set Global Variable  ${TENDER_DATA}



Задати питання
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tender_uid
  ...      ${ARGUMENTS[2]} ==  question
  [Arguments]  @{ARGUMENTS}
  ${tender}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  get_tender  ${ARGUMENTS[1]}
  ${question}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  create_question  ${tender}  ${ARGUMENTS[2]}
  Log object data   ${question}  question