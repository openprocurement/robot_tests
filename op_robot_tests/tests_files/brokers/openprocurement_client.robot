*** Settings ***
Library  op_robot_tests.tests_files.brokers.openprocurement_client_helper
Library  Selenium2Screenshots

***Variables***
${item_id}       0
${question_id}   0

*** Keywords ***
отримати internal id по UAid
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tenderid
  log many  @{ARGUMENTS}
  ${tenders}=  get_internal_id   ${USERS.users['${ARGUMENTS[0]}'].client.get_tenders}      ${USERS.users['${ARGUMENTS[0]}'].creation_date} 
  :FOR  ${tender}  IN  @{tenders}
  \  log  ${tender}
  \  ${internal_id}=  Run Keyword And Return If  '${tender.tenderID}' == '${ARGUMENTS[1]}'      Get Variable Value  ${tender.id}
  \  Exit For Loop If  '${tender.tenderID}' == '${ARGUMENTS[1]}'
  log  ${internal_id}
  log  ${tenders}
  [return]  ${internal_id}


Підготувати клієнт для користувача
  [Arguments]  @{ARGUMENTS}
  [Documentation]  Відкрити брaвзер, створити обєкт api wrapper, тощо
  ${api_wrapper}=  prepare_api_wrapper  ${USERS.users['${ARGUMENTS[0]}'].api_key}  ${API_HOST_URL}    ${api_version} 
  ${creation_date} =   get_date
  Set To Dictionary  ${USERS.users['${ARGUMENTS[0]}']}   creation_date   ${creation_date}
  Set To Dictionary  ${USERS.users['${ARGUMENTS[0]}']}   client  ${api_wrapper}
  Log Variables
  
Підготувати дані для оголошення тендера 
  ${INITIAL_TENDER_DATA}=  prepare_test_tender_data
  [return]   ${INITIAL_TENDER_DATA}
  
Створити тендер
  [Arguments]  @{ARGUMENTS}
  ${TENDER_DATA}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  create_tender  ${ARGUMENTS[1]}
  Log object data  ${TENDER_DATA}  cteated_tender
  ${access_token}=  Get Variable Value  ${TENDER_DATA.access.token}
  Set To Dictionary  ${USERS.users['${ARGUMENTS[0]}']}   access_token   ${access_token}
  Log   access_token: ${access_token}
  Log   tender_id: ${TENDER_DATA.data.id}
  Set Global Variable  ${TENDER_DATA}
  [return]  ${TENDER_DATA.data.tenderID}  ${TENDER_DATA.data.id}

Створити багатопредметний тендер
  [Arguments]  @{ARGUMENTS}
  ${INITIAL_TENDER_DATA}=  prepare_test_tender_data_multiple_items
  Log object data  ${INITIAL_TENDER_DATA}
  ${TENDER_DATA}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  create_tender   ${INITIAL_TENDER_DATA}
  Log object data  ${TENDER_DATA}  cteated_tender
  ${access_token}=  Get Variable Value  ${TENDER_DATA.access.token}
  Set Global Variable  ${access_token}
  Set To Dictionary  ${USERS.users['${ARGUMENTS[0]}']}   access_token   ${access_token}
  Log   access_token: ${access_token}
  Log   tender_id: ${TENDER_DATA.data.id}
  Set Global Variable  ${TENDER_DATA}
  [return]   ${TENDER_DATA}
  
Пошук тендера по ідентифікатору
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tenderId
  ...      ${ARGUMENTS[2]} ==  id
  ${internalid}=  отримати internal id по UAid  ${ARGUMENTS[0]}  ${ARGUMENTS[1]}
  ${tender_data}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  get_tender  ${internalid}
  Set To Dictionary  ${USERS.users['${ARGUMENTS[0]}']}   tender_data   ${tender_data}
  [return]   ${tender_data}


Обновити сторінку з тендером
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
  log  ${ARGUMENTS}
  ${field_value}=   Get_From_Object  ${USERS.users['${ARGUMENTS[0]}'].tender_data.data}   ${ARGUMENTS[1]}
  log   ${field_value}
  [return]  ${field_value}

Внести зміни в тендер
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  id
  ...      ${ARGUMENTS[2]} ==  fieldname
  ...      ${ARGUMENTS[3]} ==  fieldvalue
  ${internalid}=  отримати internal id по UAid  ${ARGUMENTS[0]}  ${ARGUMENTS[1]}
  отримати тендер   ${ARGUMENTS[0]}   ${internalid}
  Set_To_Object  ${TENDER_DATA.data}   ${ARGUMENTS[2]}   ${ARGUMENTS[3]}
  ${TENDER_DATA}=  set_access_key  ${TENDER_DATA}  ${USERS.users['${ARGUMENTS[0]}'].access_token}
  ${TENDER_DATA}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  patch_tender  ${TENDER_DATA}
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

відняти предмети закупівлі
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  id
  ...      ${ARGUMENTS[2]} ==  number
  ${internalid}=  отримати internal id по UAid  ${ARGUMENTS[0]}  ${ARGUMENTS[1]}
  отримати тендер   ${ARGUMENTS[0]}    ${internalid}
  ${items}=  get from object   ${TENDER_DATA.data}    items
  log  ${items}
  :FOR    ${INDEX}    IN RANGE    ${ARGUMENTS[2]}
   \          Remove From List  ${items}  0
  log  ${items}
  Set_To_Object    ${TENDER_DATA.data}   items  ${items}
  ${TENDER_DATA}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  patch_tender  ${TENDER_DATA}
  ${TENDER_DATA}=  set_access_key  ${TENDER_DATA}  ${USERS.users['${ARGUMENTS[0]}'].access_token}

додати предмети закупівлі
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  id
  ...      ${ARGUMENTS[2]} ==  number
  ${internalid}=  отримати internal id по UAid  ${ARGUMENTS[0]}  ${ARGUMENTS[1]}
  отримати тендер   ${ARGUMENTS[0]}    ${internalid}
  ${items}=  get from object   ${TENDER_DATA.data}    items
  ${item}=  get variable value   ${items[1]}
  log  ${items}
  :FOR    ${INDEX}    IN RANGE    ${ARGUMENTS[2]}
  \    Append To List  ${items}  ${item}
  log  ${items}
  Set_To_Object    ${TENDER_DATA.data}   items  ${items}
  ${TENDER_DATA}=  set_access_key  ${TENDER_DATA}  ${USERS.users['${ARGUMENTS[0]}'].access_token}
  ${TENDER_DATA}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  patch_tender  ${TENDER_DATA}


Задати питання
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tender_uid
  ...      ${ARGUMENTS[2]} ==  question
  [Arguments]  @{ARGUMENTS}
  log many  @{ARGUMENTS}
  ${internalid}=  отримати internal id по UAid  ${ARGUMENTS[0]}  ${ARGUMENTS[1]}
  ${tender}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  get_tender  ${internalid}
  log   ${USERS.users['${ARGUMENTS[0]}']}
  ${biddingresponce}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  create_question  ${tender}  ${ARGUMENTS[2]}
  [return]  ${biddingresponce}

Відповісти на питання
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tender_uid
  ...      ${ARGUMENTS[2]} ==  question_id
  ...      ${ARGUMENTS[3]} ==  answer_data
  [Arguments]  @{ARGUMENTS}
  log many  @{ARGUMENTS}
  ${internalid}=  отримати internal id по UAid  ${ARGUMENTS[0]}  ${ARGUMENTS[1]}
  ${tender}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  get_tender  ${internalid}
  log many     ${USERS.users['${ARGUMENTS[0]}']}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${ARGUMENTS[0]}'].access_token}
  ${ARGUMENTS[3].data.id}=  Set Variable   ${tender.data.questions[${ARGUMENTS[2]}].id}
  ${quvestion_with_answer}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  patch_question  ${tender}  ${ARGUMENTS[3]}
  log many   ${USERS.users['${ARGUMENTS[0]}'].client}  ${tender}  ${ARGUMENTS[3]}
  Log object data   ${quvestion_with_answer}  quvestion_with_answer

Подати скаргу
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tender_uid
  ...      ${ARGUMENTS[2]} ==  complaint
  [Arguments]  @{ARGUMENTS}
  log many  @{ARGUMENTS}
  ${internalid}=  отримати internal id по UAid  ${ARGUMENTS[0]}  ${ARGUMENTS[1]}
  ${tender}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  get_tender  ${internalid}
  ${complaint}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  _create_tender_resource_item  ${tender}  ${ARGUMENTS[2]}   complaints
  Log object data   ${complaint}  complaint

порівняти скаргу 
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tender_uid
  ...      ${ARGUMENTS[2]} ==  complaint
  [Arguments]  @{ARGUMENTS}
  ${internalid}=  отримати internal id по UAid  ${ARGUMENTS[0]}  ${ARGUMENTS[1]}
  ${tender}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  get_tender  ${internalid}
  ${complaint}=   Get Variable Value  ${tender.data.complaints[0]}  
  log   ${complaint}
  log   ${ARGUMENTS[2]}
  #TODO: COMPARE 
  #Dictionary Should Contain Sub Dictionary   ${complaint}   ${ARGUMENTS[2].data}
  #:FOR  ${element}  IN  ${ARGUMENTS[2].data}
  #\  log  ${element}
  #\  Dictionary Should Contain Value  ${complaint}  ${element}

Обробити скаргу
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tender_uid
  ...      ${ARGUMENTS[2]} ==  question_id
  ...      ${ARGUMENTS[3]} ==  answer_data
  [Arguments]  @{ARGUMENTS}
  log many  @{ARGUMENTS}
  ${internalid}=  отримати internal id по UAid  ${ARGUMENTS[0]}  ${ARGUMENTS[1]}
  ${tender}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  get_tender  ${internalid}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${ARGUMENTS[0]}'].access_token}
  ${ARGUMENTS[3].data.id}=  Set Variable   ${tender.data.complaints[${ARGUMENTS[2]}].id}
  ${complaint_with_answer}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  _patch_tender_resource_item  ${tender}  ${ARGUMENTS[3]}  complaints
  log many   ${USERS.users['${ARGUMENTS[0]}'].client}  ${tender}  ${ARGUMENTS[3]}
  Log object data   ${complaint_with_answer}  complaint_with_answer

Подати цінову пропозицію
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tender_uid
  ...      ${ARGUMENTS[2]} ==  bid
  [Arguments]  @{ARGUMENTS}
  log many  @{ARGUMENTS}
  ${internalid}=  отримати internal id по UAid  ${ARGUMENTS[0]}  ${ARGUMENTS[1]}
  ${tender}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  get_tender  ${internalid}
  log  ${tender}отримати
  ${biddingresponce}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  create_bid  ${tender}  ${ARGUMENTS[2]}
  [return]  ${biddingresponce}

Змінити цінову пропозицію
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tender_uid
  ...      ${ARGUMENTS[2]} ==  bid
  [Arguments]  @{ARGUMENTS}
  ${internalid}=  отримати internal id по UAid  ${ARGUMENTS[0]}  ${ARGUMENTS[1]}
  ${tender}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  get_tender  ${internalid}
  ${changed_bid}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  patch_bid  ${tender}  ${ARGUMENTS[2]}
  Log  ${changed_bid}
  [return]   ${changed_bid}

скасувати цінову пропозицію
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tender_uid
  ...      ${ARGUMENTS[2]} ==  bid
  [Arguments]  @{ARGUMENTS}
  ${internalid}=  отримати internal id по UAid  ${ARGUMENTS[0]}  ${ARGUMENTS[1]}
  ${tender}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  get_tender  ${internalid}
  log   ${tender}
  log   ${ARGUMENTS[2]}отримати
  ${changed_bid}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  delete_bid   ${tender}  ${ARGUMENTS[2]}
  Log  ${changed_bid}
  [return]   ${changed_bid}

Прийняти цінову пропозицію
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tender_uid
  ...      ${ARGUMENTS[2]} ==  award
  [Arguments]  @{ARGUMENTS}
  ${internalid}=  отримати internal id по UAid  ${ARGUMENTS[0]}  ${ARGUMENTS[1]}
  ${tender}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  get_tender  ${internalid}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${ARGUMENTS[0]}'].access_token}
  ${award_activeted_response}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  patch_award  ${tender}  ${ARGUMENTS[2]}
  Log  ${award_activeted_response}
  [return]  ${award_activeted_response}

Завантажити документ в ставку
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  token
  ...      ${ARGUMENTS[2]} ==  bid_id
  [Arguments]  @{ARGUMENTS}
  log  ${ARGUMENTS[0]}
  log  ${ARGUMENTS[1]}

  # Built-in variables related to the operating system ease making the test data operating-system-agnostic.
  log  ${TEMPDIR} # An absolute path to the directory where the test data file is located. This variable is case-sensitive.
  log  ${CURDIR}  # An absolute path to the system temporary directory. In UNIX-like systems this is typically /tmp, and in Windows c:\Documents and Settings\<user>\Local Settings\Temp.

  ${filecontent} =  Set Variable  somestring
  ${created_file_path}=   create_file  ${filecontent}
  ${tender}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  get_tender  ${TENDER_DATA.data.id}
  ${tender}=  set_access_key  ${tender}  ${ARGUMENTS[1]}
  ${responce}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  upload_bid_document  ${created_file_path}  ${tender}   ${ARGUMENTS[2]}
  ${uploaded_file} =  Create Dictionary   filepath  ${created_file_path}   filecontent  ${filecontent}   upload_responce  ${responce}
  Log object data   ${uploaded_file}
  [return]  ${uploaded_file}

Змінити документ в ставці
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  token
  ...      ${ARGUMENTS[2]} ==  bid_id
  ...      ${ARGUMENTS[3]} ==  file_id
  [Arguments]  @{ARGUMENTS}
  log  ${ARGUMENTS[0]}
  log  ${ARGUMENTS[1]}
  log  ${ARGUMENTS[2]}
  log  ${ARGUMENTS[3]}
  ${tender}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  get_tender  ${TENDER_DATA.data.id}
  ${tender}=  set_access_key  ${tender}  ${ARGUMENTS[1]}
  ${filename}=   Set Variable  newfile.txt
  Set_To_Object  ${TENDER_DATA.data}    documents.title   ${filename}
  ${reply}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  update_bid_document  ${filename}  ${tender}   ${ARGUMENTS[2]}  ${ARGUMENTS[3]}
  Log object data   ${reply}  reply

Завантажити документ
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  filename
  ...      ${ARGUMENTS[2]} ==  tenderID
  [Arguments]  @{ARGUMENTS}
  log  ${ARGUMENTS[0]}
  log  ${ARGUMENTS[1]}
  log  ${ARGUMENTS[2]}
  ${tenderID}=  openprocurement_client.отримати internal id по UAid  ${ARGUMENTS[0]}   ${ARGUMENTS[2]}
  ${tender}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  get_tender  ${tenderID}
  ${tender}=  set_access_key  ${tender}   ${USERS.users['${ARGUMENTS[0]}'].access_token}
  Set_To_Object  ${TENDER_DATA.data}    documents.title   ${filename}
  ${reply}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  upload_tender_document  ${filename}  ${tender}
  Log object data   ${reply}  reply

Отримати пропозиції
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tender_uid
  ...      ${ARGUMENTS[2]} ==  bid_id
  ...      ${ARGUMENTS[3]} ==  token
  [Arguments]  @{ARGUMENTS}
  ${internalid}=  отримати internal id по UAid  ${ARGUMENTS[0]}  ${ARGUMENTS[1]}
  ${tender}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  get_tender  ${internalid}
  ${bids}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  get_bid    ${tender}   ${ARGUMENTS[2]}  ${ARGUMENTS[3]}
  Log  ${bids}
  [return]   ${bids}

отримати документ
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tenderUaID
  ...      ${ARGUMENTS[2]} ==  url
  ...      ${ARGUMENTS[3]} ==  token
  [Arguments]  @{ARGUMENTS}
  log  ${ARGUMENTS[0]}
  log  ${ARGUMENTS[1]}
  log  ${ARGUMENTS[2]}
  ${tenderID}=  openprocurement_client.отримати internal id по UAid  ${ARGUMENTS[0]}   ${ARGUMENTS[1]}
  ${tender}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  get_tender  ${tenderID}
  ${contents}  ${filename}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  get_file   ${tender}   ${ARGUMENTS[2]}  ${ARGUMENTS[3]}
  log   ${contents}
  log   ${filename}
  [return]   ${contents}  ${filename}