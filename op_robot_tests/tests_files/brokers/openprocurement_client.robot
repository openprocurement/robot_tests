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
  #Debug
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


обновити сторінку з тендером
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tenderId
  ...      ${ARGUMENTS[2]} ==  id
  openprocurement_client.Пошук тендера по ідентифікатору    @{ARGUMENTS}


отримати інформацію із тендера
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  fieldname
  ${field_value}=   Get_From_Object  ${USERS.users['${ARGUMENTS[0]}'].tender_data.data}   ${ARGUMENTS[1]}
  [return]  ${field_value}


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
  log many  @{ARGUMENTS}
  ${tender}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  get_tender  ${ARGUMENTS[1]}
  ${question}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  create_question  ${tender}  ${ARGUMENTS[2]}
  Log object data   ${question}  question

Відповісти на питання
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tender_uid
  ...      ${ARGUMENTS[2]} ==  question_id
  ...      ${ARGUMENTS[3]} ==  answer_data
  [Arguments]  @{ARGUMENTS}
  log many  @{ARGUMENTS}
  ${tender}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  get_tender  ${ARGUMENTS[1]}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${ARGUMENTS[0]}'].access_token}
  ${ARGUMENTS[3].data.id}=  Set Variable   ${tender.data.questions[${ARGUMENTS[2]}].id}
  ${quvestion_with_answer}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  patch_question  ${tender}  ${ARGUMENTS[3]}
  Log object data   ${quvestion_with_answer}  quvestion_with_answer


Подати цінову пропозицію
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tender_uid
  ...      ${ARGUMENTS[2]} ==  bid
  [Arguments]  @{ARGUMENTS}
  log many  @{ARGUMENTS}
  ${tender}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  get_tender  ${ARGUMENTS[1]}
  ${biddingresponce}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  create_bid  ${tender}  ${ARGUMENTS[2]}
  [return]  ${biddingresponce}
  
Змінити цінову пропозицію
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tender_uid
  ...      ${ARGUMENTS[2]} ==  bid
  [Arguments]  @{ARGUMENTS}
  ${tender}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  get_tender  ${ARGUMENTS[1]}
  ${changed_bid_amount}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  patch_bid  ${tender}  ${ARGUMENTS[2]}
  Log object data   ${changed_bid_amount}  changed_bid_amount

  
Прийняти цінову пропозицію
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tender_uid
  ...      ${ARGUMENTS[2]} ==  award
  [Arguments]  @{ARGUMENTS}
  ${tender}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  get_tender  ${ARGUMENTS[1]}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${ARGUMENTS[0]}'].access_token}
  ${award_activeted_response}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  patch_award  ${tender}  ${ARGUMENTS[2]}
  Log object data   ${award_activeted_response}  award_activeted_response
  [return]  ${award_activeted_response}