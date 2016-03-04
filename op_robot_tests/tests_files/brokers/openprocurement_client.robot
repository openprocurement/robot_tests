*** Settings ***
Library  openprocurement_client_helper.py


*** Keywords ***
Отримати internal id по UAid
  [Arguments]  ${username}  ${tender_uid}
  Log Many  @{ARGUMENTS}
  Log Many  ${ID_MAP}
  ${status}=  Run Keyword And Return Status  Dictionary Should Contain Key  ${ID_MAP}  ${tender_uid}
  Run Keyword And Return If  ${status}  Get From Dictionary  ${ID_MAP}  ${tender_uid}
  ${tenders}=  get_tenders  ${USERS.users['${username}'].client}
  Log Many  @{tenders}
  :FOR  ${tender}  IN  @{tenders}
  \  Set To Dictionary  ${ID_MAP}  ${tender.tenderID}  ${tender.id}
  Log Many  ${ID_MAP}
  Dictionary Should Contain Key  ${ID_MAP}  ${tender_uid}
  Run Keyword And Return  Get From Dictionary  ${ID_MAP}  ${tender_uid}


Підготувати клієнт для користувача
  [Arguments]  ${username}
  [Documentation]  Відкрити браузер, створити об’єкт api wrapper, тощо
  Log Many  ${api_host_url}  ${api_version}
  ${api_wrapper}=  prepare_api_wrapper  ${USERS.users['${username}'].api_key}  ${api_host_url}  ${api_version}
  Set To Dictionary  ${USERS.users['${username}']}  client  ${api_wrapper}
  Set To Dictionary  ${USERS.users['${username}']}  access_token  ${EMPTY}
  ${ID_MAP}=  Create Dictionary
  Set Suite Variable  ${ID_MAP}
  Log Variables


Підготувати дані для оголошення тендера
  ${INITIAL_TENDER_DATA}=  prepare_test_tender_data
  [return]   ${INITIAL_TENDER_DATA}


Створити тендер
  [Arguments]  ${username}  ${tender_data}
  ${tender}=  Call Method  ${USERS.users['${username}'].client}  create_tender  ${tender_data}
  Log object data  ${tender}  created_tender
  ${access_token}=  Get Variable Value  ${tender.access.token}
  Set To Dictionary  ${USERS.users['${username}']}   access_token   ${access_token}
  Set To Dictionary  ${USERS.users['${username}']}   tender_data   ${tender}
  Log   ${access_token}
  Log   ${tender.data.id}
  Log   ${USERS.users['${username}'].tender_data}
  [return]  ${tender.data.tenderID}


Пошук тендера по ідентифікатору
  [Arguments]  ${username}  ${tender_uid}
  ${internalid}=  Отримати internal id по UAid  ${username}  ${tender_uid}
  ${tender}=  Отримати тендер   ${username}   ${internalid}
  [return]   ${tender}


Оновити сторінку з тендером
  [Arguments]  ${username}  ${tender_uid}
  ${tender_data}=  openprocurement_client.Пошук тендера по ідентифікатору    ${username}  ${tender_uid}
  Log  ${tender_data}


Отримати інформацію із тендера
  [Arguments]  ${username}  ${fieldname}
  Log Many  @{ARGUMENTS}
  ${status}=  Run Keyword And Return Status  Dictionary Should Contain Key  ${USERS.users['${username}'].tender_data.data}  ${fieldname}
  Run Keyword Unless
  ...      ${status}
  ...      openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${TENDER['TENDER_UAID']}
  ${field_value}=  Get_From_Object  ${USERS.users['${username}'].tender_data.data}  ${fieldname}
  Log  ${field_value}
  [return]  ${field_value}


Внести зміни в тендер
  [Arguments]  ${username}  ${tender_uid}  ${fieldname}  ${fieldvalue}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uid}
  Set_To_Object  ${tender.data}   ${fieldname}   ${fieldvalue}
  ${procurementMethodType}=  Get From Object  ${tender.data}  procurementMethodType
  Run Keyword If  '${procurementMethodType}' == 'aboveThresholdUA'
  ...      Remove From Dictionary  ${tender.data}  enquiryPeriod
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}'].access_token}
  ${tender}=  Call Method  ${USERS.users['${username}'].client}  patch_tender  ${tender}
  Set_To_Object   ${USERS.users['${username}'].tender_data}   ${fieldname}   ${fieldvalue}


Отримати тендер
  [Arguments]  ${username}  ${internalid}
  Log  ${username}
  Log  ${internalid}
  ${tender}=  Call Method  ${USERS.users['${username}'].client}  get_tender  ${internalid}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}'].access_token}
  Set To Dictionary  ${USERS.users['${username}']}  tender_data  ${tender}
  Log  ${tender}
  [Return]  ${tender}


Відняти предмети закупівлі
  [Arguments]  ${username}  ${tender_uid}  ${number}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uid}
  @{items}=  Get From Object   ${tender.data}    items
  Log Many  @{items}
  :FOR    ${INDEX}    IN RANGE    ${number}
   \          Remove From List  ${items}  0
  Log Many  @{items}
  Set_To_Object    ${tender.data}   items  ${items}
  Call Method  ${USERS.users['${username}'].client}  patch_tender  ${tender}


Додати предмети закупівлі
  [Arguments]  ${username}  ${tender_uid}  ${number}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uid}
  @{items}=  Get From Object   ${tender.data}    items
  Log Many  @{items}
  :FOR    ${INDEX}    IN RANGE    ${number}
  \    ${item}=  test_item_data
  \    Append To List  ${items}  ${item}
  Log Many  @{items}
  Set_To_Object    ${tender.data}   items  ${items}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}'].access_token}
  Call Method  ${USERS.users['${username}'].client}  patch_tender  ${tender}


Задати питання
  [Arguments]  ${username}  ${tender_uid}  ${question}
  Log  ${question}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uid}
  ${biddingresponse}=  Call Method  ${USERS.users['${username}'].client}  create_question  ${tender}  ${question}
  [return]  ${biddingresponse}


Відповісти на питання
  [Arguments]  ${username}  ${tender_uid}  ${question}  ${answer_data}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uid}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}'].access_token}
  ${answer_data.data.id}=  Set Variable   ${question.data.id}
  ${question_with_answer}=  Call Method  ${USERS.users['${username}'].client}  patch_question  ${tender}  ${answer_data}
  Log object data   ${question_with_answer}  question_with_answer
  [return]  ${question_with_answer}


Подати скаргу
  [Arguments]  ${username}  ${tender_uid}  ${complaint}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uid}
  ${complaint}=  Call Method  ${USERS.users['${username}'].client}  _create_tender_resource_item  ${tender}  ${complaint}   complaints
  ${access_token}=  Get Variable Value  ${complaint.access.token}
  Set To Dictionary  ${USERS.users['${username}']}   access_token   ${access_token}
  Log object data   ${complaint}  complaint


Порівняти скаргу
  [Arguments]  ${username}  ${tender_uid}  ${complaint}
  Log many  @{ARGUMENTS}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uid}
  ${complaint}=   Get Variable Value  ${tender.data.complaints[0]}
  Log   ${complaint}
  #TODO: COMPARE
  #Dictionary Should Contain Sub Dictionary   ${complaint}   ${complaint.data}
  #:FOR  ${element}  IN  ${complaint.data}
  #\  Log  ${element}
  #\  Dictionary Should Contain Value  ${complaint}  ${element}


Обробити скаргу
  [Arguments]  ${username}  ${tender_uid}  ${complaint_id}  ${answer_data}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uid}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}'].access_token}
  ${answer_data.data.id}=  Set Variable   ${tender.data.complaints[${complaint_id}].id}
  ${complaint_with_answer}=  Call Method  ${USERS.users['${username}'].client}  _patch_tender_resource_item  ${tender}  ${answer_data}  complaints
  Log many   ${USERS.users['${username}'].client}  ${tender}  ${answer_data}
  Log object data   ${complaint_with_answer}  complaint_with_answer


Подати цінову пропозицію
  [Arguments]  ${username}  ${tender_uid}  ${bid}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uid}
  ${biddingresponse}=  Call Method  ${USERS.users['${username}'].client}  create_bid  ${tender}  ${bid}
  Set To Dictionary   ${USERS.users['${username}'].bidresponses['bid'].data}  id  ${biddingresponse['data']['id']}
  Log  ${biddingresponse}
  [return]  ${biddingresponse}


Змінити цінову пропозицію
  [Arguments]  ${username}  ${tender_uid}  ${fieldname}  ${fieldvalue}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uid}
  ${bid}=  Отримати пропозицію  ${username}  ${tender_uid}
  Set_To_Object  ${bid.data}   ${fieldname}   ${fieldvalue}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}'].bidresponses['resp'].access.token}
  ${changed_bid}=  Call Method  ${USERS.users['${username}'].client}  patch_bid  ${tender}  ${bid}
  Log  ${changed_bid}
  [return]   ${changed_bid}


Скасувати цінову пропозицію
  [Arguments]  ${username}  ${tender_uid}  ${bid}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uid}
  Set To Dictionary   ${bid.data}  id  ${USERS.users['${username}'].bidresponses['bid'].data.id}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}'].bidresponses['resp'].access.token}
  ${changed_bid}=  Call Method  ${USERS.users['${username}'].client}  delete_bid   ${tender}  ${bid}
  Log  ${changed_bid}
  [return]   ${changed_bid}


Прийняти цінову пропозицію
  [Arguments]  ${username}  ${tender_uid}  ${award}
  ${internalid}=  Отримати internal id по UAid  ${username}  ${tender_uid}
  ${tender}=  Call Method  ${USERS.users['${username}'].client}  get_tender  ${internalid}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}'].access_token}
  ${award_activeted_response}=  Call Method  ${USERS.users['${username}'].client}  patch_award  ${tender}  ${award}
  Log  ${award_activeted_response}
  [return]  ${award_activeted_response}


Завантажити документ в ставку
  [Arguments]  ${username}  ${path}  ${tender_uid}
  ${bid_id}=  Get Variable Value   ${USERS.users['${username}'].bidresponses['resp'].data.id}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uid}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}'].bidresponses['resp'].access.token}
  ${response}=  Call Method  ${USERS.users['${username}'].client}  upload_bid_document  ${path}  ${tender}  ${bid_id}
  ${uploaded_file} =  Create Dictionary   filepath  ${path}   upload_response  ${response}
  Log  ${response}
  Log object data   ${uploaded_file}
  [return]  ${uploaded_file}


Змінити документ в ставці
  [Arguments]  ${username}  ${path}  ${bidid}  ${docid}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${TENDER['TENDER_UAID']}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}'].bidresponses['resp'].access.token}
  ${response}=  Call Method  ${USERS.users['${username}'].client}  update_bid_document  ${path}  ${tender}   ${bidid}   ${docid}
  ${uploaded_file} =  Create Dictionary   filepath  ${path}   upload_response  ${response}
  Log  ${response}
  Log object data   ${uploaded_file}
  [return]  ${uploaded_file}


Завантажити документ
  [Arguments]  ${username}  ${filepath}  ${tender_uid}
  Log many  @{ARGUMENTS}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uid}
  ${tender}=  set_access_key  ${tender}   ${USERS.users['${username}'].access_token}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  upload_document  ${filepath}  ${tender}
  Log object data   ${reply}  reply
  [return]   ${reply}


Отримати посилання на аукціон для глядача
  [Arguments]  ${username}  ${tender_uid}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uid}
  [return]  ${tender.data.auctionUrl}


Отримати посилання на аукціон для учасника
  [Arguments]  ${username}  ${tender_uid}
  ${bid}=  Викликати для учасника  ${username}  Отримати пропозицію  ${tender_uid}
  [return]  ${bid.data.participationUrl}


Отримати пропозицію
  [Arguments]  ${username}  ${tender_uid}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uid}
  ${bid_id}=  Get Variable Value  ${USERS.users['${username}'].bidresponses['resp'].data.id}
  ${token}=  Get Variable Value  ${USERS.users['${username}'].bidresponses['resp'].access.token}
  ${bid}=  Call Method  ${USERS.users['${username}'].client}  get_bid  ${tender}  ${bid_id}  ${token}
  [return]  ${bid}


Отримати документ
  [Arguments]  ${username}  ${tender_uid}  ${url}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uid}
  ${token}=    Get Variable Value  ${USERS.users['${username}'].bidresponses['resp'].access.token}
  ${contents}  ${filename}=  Call Method  ${USERS.users['${username}'].client}  get_file   ${tender}   ${url}   ${token}
  Log   ${filename}
  [return]   ${contents}  ${filename}


Створити лот
  [Arguments]  ${username}  ${tender}  ${lot}
  Log many  @{ARGUMENTS}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}'].access_token}
  ${tender_lot}=  Call Method  ${USERS.users['${username}'].client}   create_lot   ${tender}    ${lot}
  Log   ${tender_lot}
  [return]  ${tender_lot}
  #TODO:
  #[Arguments]  ${username}  ${tender_uid}  ${lot}
  #${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uid}


Змінити лот
  [Arguments]  ${username}  ${tender}  ${lot}
  ${tender}=  set_access_key  ${tender}   ${USERS.users['${username}'].access_token}
  ${tender_lot}=  Call Method  ${USERS.users['${username}'].client}   patch_lot   ${tender}    ${lot}
  Log   ${tender_lot}
  [return]  ${tender_lot}
  #TODO:
  #[Arguments]  ${username}  ${tender_uid}  ${lot}
  #${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uid}


Завантажити документ в лот
  [Arguments]  ${username}  ${filepath}  ${tender_uid}  ${lot_id}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uid}
  ${tender}=  set_access_key  ${tender}   ${USERS.users['${username}'].access_token}
  ${doc}=  Завантажити документ  ${username}  ${filepath}  ${tender_uid}
  ${lot_doc}=  test_lot_document_data  ${doc}  ${lot_id}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_document   ${tender}   ${lot_doc}
  Log object data   ${reply}  reply
  [return]   ${reply}


Видалити лот
  [Arguments]  ${username}  ${tender}  ${lot}
  ${tender}=  set_access_key  ${tender}   ${USERS.users['${username}'].access_token}
  ${tender_lot}=  Call Method  ${USERS.users['${username}'].client}   delete_lot   ${tender}   ${lot}
  Log   ${tender_lot}
  [return]  ${tender_lot}
  #TODO:
  #[Arguments]  ${username}  ${tender_uid}  ${lot}
  #${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uid}

##############################################################################
#             Limited procurement
##############################################################################

Отримати тендер [modified]
  [Arguments]  ${username}
  Log  ${username}
  Log  ${TENDER['TENDER_UAID']}
  ${tenderID}=  openprocurement_client.Отримати internal id по UAid  ${username}  ${TENDER['TENDER_UAID']}
  ${tender}=  Call Method  ${USERS.users['${username}'].client}  get_tender  ${tenderID}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}'].access_token}
  Log  ${tender}
  [Return]  ${tender}


Модифікувати закупівлю
  [Arguments]  ${username}
  ${tender}=  Викликати для учасника  ${username}  Отримати тендер [modified]
  ${data}=  modify_tender  ${tender['data']['id']}  ${tender['access']['token']}
  Log  ${data}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_tender  ${data}
  Log  ${reply}


Додати постачальника
  [Arguments]  ${username}
  ${tender}=  Викликати для учасника  ${username}  Отримати тендер [modified]
  ${supplier_data}=  test supplier data
  Log  ${supplier_data}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  create_award  ${tender}  ${supplier_data}
  Log  ${reply}


Підтвердити постачальника
  [Arguments]  ${username}
  ${tender}=  Викликати для учасника  ${username}  Отримати тендер [modified]
  ${data}=  Confirm supplier  ${tender['data']['awards'][0]['id']}
  Log  ${data}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_award  ${tender}  ${data}
  Log  ${reply}


Додати запит на скасування
  [Arguments]  ${username}
  ${tender}=  Викликати для учасника  ${username}  Отримати тендер [modified]
  ${CANCELLATION_REASON}  Set variable  prost :))
  Set suite variable  ${CANCELLATION_REASON}
  ${data}=  Cancel tender  ${CANCELLATION_REASON}
  Log  ${data}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  create_cancellation  ${tender}  ${data}
  Log  ${reply}


Завантажити документацію до запиту на скасування
  [Arguments]  ${username}
  ${tender}=  Викликати для учасника  ${username}  Отримати тендер [modified]
  ${FIRST_CANCELLATION_DOCUMENT}=  create_fake_doc
  Set suite variable  ${FIRST_CANCELLATION_DOCUMENT}
  ${cancel_num}  Set variable  0
  Log  ${cancel_num}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  upload_cancellation_document  ${FIRST_CANCELLATION_DOCUMENT}  ${tender}  ${tender['data']['cancellations'][${cancel_num}]['id']}
  Log  ${reply}


Змінити опис документа в скасуванні
  [Arguments]  ${username}
  ${tender}=  Викликати для учасника  ${username}  Отримати тендер [modified]
  ${CANCELLATION_DOCUMENT_DESCRIPTION}  Set variable  test description
  Set suite variable  ${CANCELLATION_DOCUMENT_DESCRIPTION}
  ${cancellation_document_field}  Set variable  description
  ${data}=  change_cancellation_document_field  ${cancellation_document_field}  ${CANCELLATION_DOCUMENT_DESCRIPTION}
  Log  ${data}
  ${cancel_num}  Set variable  0
  ${doc_num}  Set variable  0
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_cancellation_document  ${tender}  ${data}  ${cancel_num}  ${doc_num}
  Log  ${reply}


Завантажити нову версію документа до запиту на скасування
  [Arguments]  ${username}
  ${tender}=  Викликати для учасника  ${username}  Отримати тендер [modified]
  ${SECOND_CANCELLATION_DOCUMENT}=  create_fake_doc
  Set suite variable  ${SECOND_CANCELLATION_DOCUMENT}
  Log  ${SECOND_CANCELLATION_DOCUMENT}
  ${cancel_num}  Set variable  0
  ${doc_num}  Set variable  0
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  update_cancellation_document  ${SECOND_CANCELLATION_DOCUMENT}  ${tender}  ${tender['data']['cancellations'][${cancel_num}]['id']}  ${tender['data']['cancellations'][${cancel_num}]['documents'][${doc_num}]['id']}
  Log  ${reply}


Підтвердити скасування закупівлі
  [Arguments]  ${username}
  ${tender}=  Викликати для учасника  ${username}  Отримати тендер [modified]
  ${cancel_num}  Set variable  0
  Log  ${cancel_num}
  ${data}=  Confirm cancellation  ${tender['data']['cancellations'][${cancel_num}]['id']}
  Log  ${data}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_cancellation  ${tender}  ${data}
  Log  ${reply}


Підтвердити підписання контракту
  [Arguments]  ${username}
  ${tender}=  Викликати для учасника  ${username}  Отримати тендер [modified]
  ${contract_num}  Set variable  0
  ${data}=  confirm contract  ${tender['data']['contracts'][${contract_num}]['id']}
  Log  ${data}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_contract  ${tender}  ${data}
  Log  ${reply}
