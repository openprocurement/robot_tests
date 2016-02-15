*** Settings ***
Library  openprocurement_client_helper.py


*** Keywords ***
Отримати internal id по UAid
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tenderid
  Log Many  @{ARGUMENTS}
  Log Many  ${ID_MAP}
  ${status}=  Run Keyword And Return Status  Dictionary Should Contain Key  ${ID_MAP}  ${ARGUMENTS[1]}
  Run Keyword And Return If  ${status}  Get From Dictionary  ${ID_MAP}  ${ARGUMENTS[1]}
  ${tenders}=  get_tenders  ${USERS.users['${ARGUMENTS[0]}'].client}
  Log Many  @{tenders}
  :FOR  ${tender}  IN  @{tenders}
  \  Set To Dictionary  ${ID_MAP}  ${tender.tenderID}  ${tender.id}
  Log Many  ${ID_MAP}
  Dictionary Should Contain Key  ${ID_MAP}  ${ARGUMENTS[1]}
  Run Keyword And Return  Get From Dictionary  ${ID_MAP}  ${ARGUMENTS[1]}


Підготувати клієнт для користувача
  [Arguments]  @{ARGUMENTS}
  [Documentation]  Відкрити браузер, створити об’єкт api wrapper, тощо
  ${api_wrapper}=  prepare_api_wrapper  ${USERS.users['${ARGUMENTS[0]}'].api_key}  ${API_HOST_URL}  ${api_version}
  Set To Dictionary  ${USERS.users['${ARGUMENTS[0]}']}  client  ${api_wrapper}
  ${ID_MAP}=  Create Dictionary
  Set Suite Variable  ${ID_MAP}
  Log Variables


Підготувати дані для оголошення тендера
  ${INITIAL_TENDER_DATA}=  prepare_test_tender_data
  [return]   ${INITIAL_TENDER_DATA}


Створити тендер
  [Arguments]  @{ARGUMENTS}
  ${TENDER_DATA}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  create_tender  ${ARGUMENTS[1]}
  Log object data  ${TENDER_DATA}  created_tender
  ${access_token}=  Get Variable Value  ${TENDER_DATA.access.token}
  Set To Dictionary  ${USERS.users['${ARGUMENTS[0]}']}   access_token   ${access_token}
  Set To Dictionary  ${USERS.users['${ARGUMENTS[0]}']}   TENDER_DATA   ${TENDER_DATA}
  Log   ${access_token}
  Log   ${TENDER_DATA.data.id}
  Log   ${USERS.users['${ARGUMENTS[0]}'].TENDER_DATA}
  [return]  ${TENDER_DATA.data.tenderID}


Пошук тендера по ідентифікатору
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tenderId
  ${internalid}=  Отримати internal id по UAid  ${ARGUMENTS[0]}  ${ARGUMENTS[1]}
  ${tender_data}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  get_tender  ${internalid}
  Set To Dictionary  ${USERS.users['${ARGUMENTS[0]}']}   tender_data   ${tender_data}
  [return]   ${tender_data}


Оновити сторінку з тендером
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tenderId
  ${tender_data}=  openprocurement_client.Пошук тендера по ідентифікатору    @{ARGUMENTS}
  Log  ${tender_data}


Отримати інформацію із тендера
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  fieldname
  Log Many  @{ARGUMENTS}
  ${field_value}=  Get_From_Object  ${USERS.users['${ARGUMENTS[0]}'].tender_data.data}  ${ARGUMENTS[1]}
  Log  ${field_value}
  [return]  ${field_value}


Внести зміни в тендер
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  id
  ...      ${ARGUMENTS[2]} ==  fieldname
  ...      ${ARGUMENTS[3]} ==  fieldvalue
  ${internalid}=  Отримати internal id по UAid  ${ARGUMENTS[0]}  ${ARGUMENTS[1]}
  Отримати тендер   ${ARGUMENTS[0]}   ${internalid}
  Set_To_Object  ${TENDER_DATA.data}   ${ARGUMENTS[2]}   ${ARGUMENTS[3]}
  ${TENDER_DATA}=  set_access_key  ${TENDER_DATA}  ${USERS.users['${ARGUMENTS[0]}'].access_token}
  ${TENDER_DATA}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  patch_tender  ${TENDER_DATA}
  Set Global Variable  ${TENDER_DATA}


Отримати тендер
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  id
  ${TENDER_DATA}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  get_tender  ${ARGUMENTS[1]}
  Log object data  ${TENDER_DATA}
  ${TENDER_DATA}=  set_access_key  ${TENDER_DATA}  ${USERS.users['${ARGUMENTS[0]}'].access_token}
  Set Global Variable  ${TENDER_DATA}


Відняти предмети закупівлі
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  id
  ...      ${ARGUMENTS[2]} ==  number
  ${internalid}=  Отримати internal id по UAid  ${ARGUMENTS[0]}  ${ARGUMENTS[1]}
  Отримати тендер   ${ARGUMENTS[0]}    ${internalid}
  @{items}=  Get From Object   ${TENDER_DATA.data}    items
  Log Many  @{items}
  :FOR    ${INDEX}    IN RANGE    ${ARGUMENTS[2]}
   \          Remove From List  ${items}  0
  Log Many  @{items}
  Set_To_Object    ${TENDER_DATA.data}   items  ${items}
  ${TENDER_DATA}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  patch_tender  ${TENDER_DATA}
  ${TENDER_DATA}=  set_access_key  ${TENDER_DATA}  ${USERS.users['${ARGUMENTS[0]}'].access_token}


Додати предмети закупівлі
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  id
  ...      ${ARGUMENTS[2]} ==  number
  ${internalid}=  Отримати internal id по UAid  ${ARGUMENTS[0]}  ${ARGUMENTS[1]}
  Отримати тендер   ${ARGUMENTS[0]}    ${internalid}
  @{items}=  Get From Object   ${TENDER_DATA.data}    items
  Log Many  @{items}
  :FOR    ${INDEX}    IN RANGE    ${ARGUMENTS[2]}
  \    ${item}=  test_item_data
  \    Append To List  ${items}  ${item}
  Log Many  @{items}
  Set_To_Object    ${TENDER_DATA.data}   items  ${items}
  ${TENDER_DATA}=  set_access_key  ${TENDER_DATA}  ${USERS.users['${ARGUMENTS[0]}'].access_token}
  ${TENDER_DATA}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  patch_tender  ${TENDER_DATA}


Задати питання
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tender_uid
  ...      ${ARGUMENTS[2]} ==  question
  [Arguments]  @{ARGUMENTS}
  Log many  @{ARGUMENTS}
  ${internalid}=  Отримати internal id по UAid  ${ARGUMENTS[0]}  ${ARGUMENTS[1]}
  ${tender}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  get_tender  ${internalid}
  Log   ${USERS.users['${ARGUMENTS[0]}']}
  ${biddingresponse}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  create_question  ${tender}  ${ARGUMENTS[2]}
  [return]  ${biddingresponse}


Відповісти на питання
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tender_uid
  ...      ${ARGUMENTS[2]} ==  question_id
  ...      ${ARGUMENTS[3]} ==  answer_data
  [Arguments]  @{ARGUMENTS}
  Log many  @{ARGUMENTS}
  ${internalid}=  Отримати internal id по UAid  ${ARGUMENTS[0]}  ${ARGUMENTS[1]}
  ${tender}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  get_tender  ${internalid}
  Log many     ${USERS.users['${ARGUMENTS[0]}']}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${ARGUMENTS[0]}'].access_token}
  ${ARGUMENTS[3].data.id}=  Set Variable   ${tender.data.questions[${ARGUMENTS[2]}].id}
  ${question_with_answer}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  patch_question  ${tender}  ${ARGUMENTS[3]}
  Log many   ${USERS.users['${ARGUMENTS[0]}'].client}  ${tender}  ${ARGUMENTS[3]}
  Log object data   ${question_with_answer}  question_with_answer


Подати скаргу
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tender_uid
  ...      ${ARGUMENTS[2]} ==  complaint
  [Arguments]  @{ARGUMENTS}
  Log many  @{ARGUMENTS}
  ${internalid}=  Отримати internal id по UAid  ${ARGUMENTS[0]}  ${ARGUMENTS[1]}
  ${tender}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  get_tender  ${internalid}
  ${complaint}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  _create_tender_resource_item  ${tender}  ${ARGUMENTS[2]}   complaints
  ${access_token}=  Get Variable Value  ${complaint.access.token}
  Set To Dictionary  ${USERS.users['${ARGUMENTS[0]}']}   access_token   ${access_token}
  Log object data   ${complaint}  complaint


Порівняти скаргу
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tender_uid
  ...      ${ARGUMENTS[2]} ==  complaint
  [Arguments]  @{ARGUMENTS}
  Log many  @{ARGUMENTS}
  ${internalid}=  Отримати internal id по UAid  ${ARGUMENTS[0]}  ${ARGUMENTS[1]}
  ${tender}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  get_tender  ${internalid}
  ${complaint}=   Get Variable Value  ${tender.data.complaints[0]}
  Log   ${complaint}
  #TODO: COMPARE
  #Dictionary Should Contain Sub Dictionary   ${complaint}   ${ARGUMENTS[2].data}
  #:FOR  ${element}  IN  ${ARGUMENTS[2].data}
  #\  Log  ${element}
  #\  Dictionary Should Contain Value  ${complaint}  ${element}


Обробити скаргу
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tender_uid
  ...      ${ARGUMENTS[2]} ==  question_id
  ...      ${ARGUMENTS[3]} ==  answer_data
  [Arguments]  @{ARGUMENTS}
  Log many  @{ARGUMENTS}
  ${internalid}=  Отримати internal id по UAid  ${ARGUMENTS[0]}  ${ARGUMENTS[1]}
  ${tender}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  get_tender  ${internalid}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${ARGUMENTS[0]}'].access_token}
  ${ARGUMENTS[3].data.id}=  Set Variable   ${tender.data.complaints[${ARGUMENTS[2]}].id}
  ${complaint_with_answer}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  _patch_tender_resource_item  ${tender}  ${ARGUMENTS[3]}  complaints
  Log many   ${USERS.users['${ARGUMENTS[0]}'].client}  ${tender}  ${ARGUMENTS[3]}
  Log object data   ${complaint_with_answer}  complaint_with_answer


Подати цінову пропозицію
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tender_uid
  ...      ${ARGUMENTS[2]} ==  bid
  [Arguments]  @{ARGUMENTS}
  Log many  @{ARGUMENTS}
  ${internalid}=  Отримати internal id по UAid  ${ARGUMENTS[0]}  ${ARGUMENTS[1]}
  ${tender}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  get_tender  ${internalid}
  Log  ${tender}
  ${biddingresponse}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  create_bid  ${tender}  ${ARGUMENTS[2]}
  [return]  ${biddingresponse}


Змінити цінову пропозицію
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tender_uid
  ...      ${ARGUMENTS[2]} ==  bid
  [Arguments]  @{ARGUMENTS}
  ${internalid}=  Отримати internal id по UAid  ${ARGUMENTS[0]}  ${ARGUMENTS[1]}
  ${tender}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  get_tender  ${internalid}
  ${changed_bid}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  patch_bid  ${tender}  ${ARGUMENTS[2]}
  Log  ${changed_bid}
  [return]   ${changed_bid}


Скасувати цінову пропозицію
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tender_uid
  ...      ${ARGUMENTS[2]} ==  bid
  [Arguments]  @{ARGUMENTS}
  Log many  @{ARGUMENTS}
  ${internalid}=  Отримати internal id по UAid  ${ARGUMENTS[0]}  ${ARGUMENTS[1]}
  ${tender}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  get_tender  ${internalid}
  Log   ${tender}
  ${changed_bid}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  delete_bid   ${tender}  ${ARGUMENTS[2]}
  Log  ${changed_bid}
  [return]   ${changed_bid}


Прийняти цінову пропозицію
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tender_uid
  ...      ${ARGUMENTS[2]} ==  award
  [Arguments]  @{ARGUMENTS}
  ${internalid}=  Отримати internal id по UAid  ${ARGUMENTS[0]}  ${ARGUMENTS[1]}
  ${tender}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  get_tender  ${internalid}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${ARGUMENTS[0]}'].access_token}
  ${award_activeted_response}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  patch_award  ${tender}  ${ARGUMENTS[2]}
  Log  ${award_activeted_response}
  [return]  ${award_activeted_response}


Завантажити документ в ставку
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  path
  ...      ${ARGUMENTS[2]} ==  tenderid
  [Arguments]  @{ARGUMENTS}
  Log many  @{ARGUMENTS}
  ${bid_id}=  Get Variable Value   ${USERS.users['${ARGUMENTS[0]}'].bidresponses['resp'].data.id}
  ${internalid}=  Отримати internal id по UAid  ${ARGUMENTS[0]}  ${ARGUMENTS[2]}
  ${tender}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  get_tender  ${internalid}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${ARGUMENTS[0]}'].bidresponses['resp'].access.token}
  ${response}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  upload_bid_document  ${ARGUMENTS[1]}  ${tender}  ${bid_id}
  ${uploaded_file} =  Create Dictionary   filepath  ${ARGUMENTS[1]}   upload_response  ${response}
  Log  ${response}
  Log object data   ${uploaded_file}
  [return]  ${uploaded_file}


Змінити документ в ставці
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  path
  ...      ${ARGUMENTS[2]} ==  bidid
  ...      ${ARGUMENTS[3]} ==  docid
  [Arguments]  @{ARGUMENTS}
  Log many  @{ARGUMENTS}
  ${internalid}=  Отримати internal id по UAid  ${ARGUMENTS[0]}  ${TENDER['TENDER_UAID']}
  ${tender}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  get_tender  ${internalid}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${ARGUMENTS[0]}'].bidresponses['resp'].access.token}
  ${response}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  update_bid_document  ${ARGUMENTS[1]}  ${tender}   ${ARGUMENTS[2]}   ${ARGUMENTS[3]}
  ${uploaded_file} =  Create Dictionary   filepath  ${ARGUMENTS[1]}   upload_response  ${response}
  Log  ${response}
  Log object data   ${uploaded_file}
  [return]  ${uploaded_file}


Завантажити документ
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  filepath
  ...      ${ARGUMENTS[2]} ==  TENDER['TENDER_UAID']
  [Arguments]  @{ARGUMENTS}
  Log many  @{ARGUMENTS}
  ${tenderID}=  openprocurement_client.Отримати internal id по UAid  ${ARGUMENTS[0]}   ${ARGUMENTS[2]}
  ${tender}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  get_tender  ${tenderID}
  ${tender}=  set_access_key  ${tender}   ${USERS.users['${ARGUMENTS[0]}'].access_token}
  ${reply}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  upload_document  ${ARGUMENTS[1]}  ${tender}
  Log object data   ${reply}  reply
  [return]   ${reply}


Отримати посилання на аукціон для глядача
  [Arguments]  ${username}  ${tender_uid}
  ${internalid}=  Отримати internal id по UAid  ${username}  ${tender_uid}
  ${tender}=  Call Method  ${USERS.users['${username}'].client}  get_tender  ${internalid}
  [return]  ${tender.data.auctionUrl}


Отримати посилання на аукціон для учасника
  [Arguments]  ${username}  ${tender_uid}
  ${bid}=  Викликати для учасника  ${username}  Отримати пропозицію  ${tender_uid}
  [return]  ${bid.data.participationUrl}


Отримати пропозицію
  [Arguments]  ${username}  ${tender_uid}
  ${internalid}=  Отримати internal id по UAid  ${username}  ${tender_uid}
  ${bid_id}=  Get Variable Value  ${USERS.users['${username}'].bidresponses['resp'].data.id}
  ${token}=  Get Variable Value  ${USERS.users['${username}'].bidresponses['resp'].access.token}
  ${tender}=  Call Method  ${USERS.users['${username}'].client}  get_tender  ${internalid}
  ${bid}=  Call Method  ${USERS.users['${username}'].client}  get_bid  ${tender}  ${bid_id}  ${token}
  [return]  ${bid}


Отримати документ
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  TENDER['TENDER_UAID']
  ...      ${ARGUMENTS[2]} ==  url
  [Arguments]  @{ARGUMENTS}
  Log many  @{ARGUMENTS}
  ${tenderID}=  openprocurement_client.Отримати internal id по UAid  ${ARGUMENTS[0]}   ${ARGUMENTS[1]}
  ${tender}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  get_tender  ${tenderID}
  ${token}=    Get Variable Value  ${USERS.users['${ARGUMENTS[0]}'].bidresponses['resp'].access.token}
  ${contents}  ${filename}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  get_file   ${tender}   ${ARGUMENTS[2]}   ${token}
  Log   ${filename}
  [return]   ${contents}  ${filename}


Створити лот
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tender
  ...      ${ARGUMENTS[2]} ==  lot
  [Arguments]  @{ARGUMENTS}
  Log many  @{ARGUMENTS}
  ${tender}=  set_access_key  ${ARGUMENTS[1]}  ${USERS.users['${ARGUMENTS[0]}'].access_token}
  ${tender_lot}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}   create_lot   ${tender}    ${ARGUMENTS[2]}
  Log   ${tender_lot}
  [return]  ${tender_lot}


Змінити лот
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tender
  ...      ${ARGUMENTS[2]} ==  lot
  [Arguments]  @{ARGUMENTS}
  Log many  @{ARGUMENTS}
  ${tender}=  set_access_key  ${ARGUMENTS[1]}   ${USERS.users['${ARGUMENTS[0]}'].access_token}
  ${tender_lot}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}   patch_lot   ${tender}    ${ARGUMENTS[2]}
  Log   ${tender_lot}
  [return]  ${tender_lot}


Завантажити документ в лот
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  filepath
  ...      ${ARGUMENTS[2]} ==  tenderUAID
  ...      ${ARGUMENTS[3]} ==  lot_id
  [Arguments]  @{ARGUMENTS}
  Log many  @{ARGUMENTS}
  ${tenderID}=  openprocurement_client.Отримати internal id по UAid  ${ARGUMENTS[0]}   ${ARGUMENTS[2]}
  ${tender}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  get_tender  ${tenderID}
  ${tender}=  set_access_key  ${tender}   ${USERS.users['${ARGUMENTS[0]}'].access_token}
  ${doc}=  Завантажити документ  ${ARGUMENTS[0]}  ${ARGUMENTS[1]}  ${ARGUMENTS[2]}
  ${lot_doc}=  test_lot_document_data  ${doc}  ${ARGUMENTS[3]}
  ${reply}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}  patch_document   ${tender}   ${lot_doc}
  Log object data   ${reply}  reply
  [return]   ${reply}


Видалити лот
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tender
  ...      ${ARGUMENTS[2]} ==  lot
  [Arguments]  @{ARGUMENTS}
  Log many  @{ARGUMENTS}
  ${tender}=  set_access_key  ${ARGUMENTS[1]}   ${USERS.users['${ARGUMENTS[0]}'].access_token}
  ${tender_lot}=  Call Method  ${USERS.users['${ARGUMENTS[0]}'].client}   delete_lot   ${tender}   ${ARGUMENTS[2]}
  Log   ${tender_lot}
  [return]  ${tender_lot}

##############################################################################
#             Limited procurement
##############################################################################

Отримати тендер [modified]
  [Arguments]  ${username}  ${tender_uaid}
  Log  ${username}
  Log  ${tender_uaid}
  ${tenderID}=  openprocurement_client.Отримати internal id по UAid  ${username}  ${tender_uaid}
  ${tender}=  Call Method  ${USERS.users['${username}'].client}  get_tender  ${tenderID}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}'].access_token}
  Log  ${tender}
  [Return]  ${tender}


Модифікувати закупівлю
  [Arguments]  ${username}  ${tender_uaid}
  ${tender}=  Отримати тендер [modified]  ${username}  ${tender_uaid}
  ${data}=  modify_tender  ${tender['data']['id']}  ${tender['access']['token']}
  Log  ${data}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_tender  ${data}
  Log  ${reply}


Додати постачальника
  [Arguments]  ${username}  ${tender_uaid}
  ${tender}=  Отримати тендер [modified]  ${username}  ${tender_uaid}
  ${supplier_data}=  test supplier data
  Log  ${supplier_data}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  create_award  ${tender}  ${supplier_data}
  Log  ${reply}


Підтвердити постачальника
  [Arguments]  ${username}  ${tender_uaid}  ${award_num}
  ${tender}=  Отримати тендер [modified]  ${username}  ${tender_uaid}
  ${data}=  Confirm supplier  ${tender['data']['awards'][${award_num}]['id']}
  Log  ${data}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_award  ${tender}  ${data}
  Log  ${reply}


Додати запит на скасування
  [Arguments]  ${username}  ${tender_uaid}
  ${tender}=  Отримати тендер [modified]  ${username}  ${tender_uaid}
  ${CANCELLATION_REASON}  Set variable  prost :))
  Set suite variable  ${CANCELLATION_REASON}
  ${data}=  Cancel tender  ${CANCELLATION_REASON}
  Log  ${data}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  create_cancellation  ${tender}  ${data}
  Log  ${reply}


Завантажити документацію до запиту на скасування
  [Arguments]  ${username}  ${tender_uaid}  ${cancel_num}
  ${tender}=  Отримати тендер [modified]  ${username}  ${tender_uaid}
  ${FIRST_CANCELLATION_DOCUMENT}=  create_fake_doc
  Set suite variable  ${FIRST_CANCELLATION_DOCUMENT}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  upload_cancellation_document  ${FIRST_CANCELLATION_DOCUMENT}  ${tender}  ${tender['data']['cancellations'][${cancel_num}]['id']}
  Log  ${reply}


Змінити опис документа в скасуванні
  [Arguments]  ${username}  ${tender_uaid}  ${cancel_num}  ${doc_num}
  ${tender}=  Отримати тендер [modified]  ${username}  ${tender_uaid}
  ${CANCELLATION_DOCUMENT_DESCRIPTION}  Set variable  test description
  Set suite variable  ${CANCELLATION_DOCUMENT_DESCRIPTION}
  ${cancellation_document_field}  Set variable  description
  ${data}=  change_cancellation_document_field  ${cancellation_document_field}  ${CANCELLATION_DOCUMENT_DESCRIPTION}
  Log  ${data}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_cancellation_document  ${tender}  ${data}  ${cancel_num}  ${doc_num}
  Log  ${reply}


Завантажити нову версію документа до запиту на скасування
  [Arguments]  ${username}  ${tender_uaid}  ${cancel_num}  ${doc_num}
  ${tender}=  Отримати тендер [modified]  ${username}  ${tender_uaid}
  ${SECOND_CANCELLATION_DOCUMENT}=  create_fake_doc
  Set suite variable  ${SECOND_CANCELLATION_DOCUMENT}
  Log  ${SECOND_CANCELLATION_DOCUMENT}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  update_cancellation_document  ${SECOND_CANCELLATION_DOCUMENT}  ${tender}  ${tender['data']['cancellations'][${cancel_num}]['id']}  ${tender['data']['cancellations'][${cancel_num}]['documents'][${doc_num}]['id']}
  Log  ${reply}


Підтвердити скасування закупівлі
  [Arguments]  ${username}  ${tender_uaid}  ${cancel_num}
  ${tender}=  Отримати тендер [modified]  ${username}  ${tender_uaid}
  ${data}=  Confirm cancellation  ${tender['data']['cancellations'][${cancel_num}]['id']}
  Log  ${data}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_cancellation  ${tender}  ${data}
  Log  ${reply}


Підтвердити підписання контракту
  [Arguments]  ${username}  ${tender_uaid}  ${contract_num}
  ${tender}=  Викликати для учасника  ${username}  Отримати тендер [modified]  ${tender_uaid}
  ${data}=  confirm contract  ${tender['data']['contracts'][${contract_num}]['id']}
  Log  ${data}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_contract  ${tender}  ${data}
  Log  ${reply}
