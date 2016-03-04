*** Settings ***
Library  openprocurement_client_helper.py


*** Keywords ***
Отримати internal id по UAid
  [Arguments]  ${username}  ${tender_uaid}
  Log  ${username}
  Log  ${tender_uaid}
  Log Many  ${ID_MAP}
  ${status}=  Run Keyword And Return Status  Dictionary Should Contain Key  ${ID_MAP}  ${tender_uaid}
  Run Keyword And Return If  ${status}  Get From Dictionary  ${ID_MAP}  ${tender_uaid}
  ${tenders}=  get_tenders  ${USERS.users['${username}'].client}
  Log Many  @{tenders}
  :FOR  ${tender}  IN  @{tenders}
  \  Set To Dictionary  ${ID_MAP}  ${tender.tenderID}  ${tender.id}
  Log Many  ${ID_MAP}
  Dictionary Should Contain Key  ${ID_MAP}  ${tender_uaid}
  Run Keyword And Return  Get From Dictionary  ${ID_MAP}  ${tender_uaid}


Підготувати клієнт для користувача
  [Arguments]  ${username}
  [Documentation]  Відкрити браузер, створити об’єкт api wrapper, тощо
  Log  ${api_host_url}
  Log  ${api_version}
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
  [Arguments]  ${username}  ${tender_uaid}
  ${internalid}=  Отримати internal id по UAid  ${username}  ${tender_uaid}
  ${tender}=  Отримати тендер   ${username}   ${internalid}
  [return]   ${tender}


Оновити сторінку з тендером
  [Arguments]  ${username}  ${tender_uaid}
  ${tender_data}=  openprocurement_client.Пошук тендера по ідентифікатору    ${username}  ${tender_uaid}
  Log  ${tender_data}


Отримати інформацію із тендера
  [Arguments]  ${username}  ${fieldname}
  Log  ${username}
  Log  ${fieldname}
  ${status}=  Run Keyword And Return Status  Dictionary Should Contain Key  ${USERS.users['${username}'].tender_data.data}  ${fieldname}
  Run Keyword Unless
  ...      ${status}
  ...      openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${TENDER['TENDER_UAID']}
  ${field_value}=  Get_From_Object  ${USERS.users['${username}'].tender_data.data}  ${fieldname}
  Log  ${field_value}
  [return]  ${field_value}


Внести зміни в тендер
  [Arguments]  ${username}  ${tender_uaid}  ${fieldname}  ${fieldvalue}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  Set_To_Object  ${tender.data}   ${fieldname}   ${fieldvalue}
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
  [Arguments]  ${username}  ${tender_uaid}  ${number}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  @{items}=  Get From Object   ${tender.data}    items
  Log Many  @{items}
  :FOR    ${INDEX}    IN RANGE    ${number}
   \          Remove From List  ${items}  0
  Log Many  @{items}
  Set_To_Object    ${tender.data}   items  ${items}
  Call Method  ${USERS.users['${username}'].client}  patch_tender  ${tender}


Додати предмети закупівлі
  [Arguments]  ${username}  ${tender_uaid}  ${number}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
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
  [Arguments]  ${username}  ${tender_uaid}  ${question}
  Log  ${question}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${biddingresponse}=  Call Method  ${USERS.users['${username}'].client}  create_question  ${tender}  ${question}
  [return]  ${biddingresponse}


Відповісти на питання
  [Arguments]  ${username}  ${tender_uaid}  ${question_id}  ${answer_data}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}'].access_token}
  ${answer_data.data.id}=  Set Variable   ${tender.data.questions[${question_id}].id}
  ${question_with_answer}=  Call Method  ${USERS.users['${username}'].client}  patch_question  ${tender}  ${answer_data}
  Log object data   ${question_with_answer}  question_with_answer


Подати скаргу
  [Arguments]  ${username}  ${tender_uaid}  ${complaint}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${complaint}=  Call Method  ${USERS.users['${username}'].client}  _create_tender_resource_item  ${tender}  ${complaint}   complaints
  ${access_token}=  Get Variable Value  ${complaint.access.token}
  Set To Dictionary  ${USERS.users['${username}']}   access_token   ${access_token}
  Log object data   ${complaint}  complaint


Порівняти скаргу
  [Arguments]  ${username}  ${tender_uaid}  ${complaint}
  Log  ${username}
  Log  ${tender_uaid}
  Log  ${complaint}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${complaint}=   Get Variable Value  ${tender.data.complaints[0]}
  Log   ${complaint}
  #TODO: COMPARE
  #Dictionary Should Contain Sub Dictionary   ${complaint}   ${complaint.data}
  #:FOR  ${element}  IN  ${complaint.data}
  #\  Log  ${element}
  #\  Dictionary Should Contain Value  ${complaint}  ${element}


Обробити скаргу
  [Arguments]  ${username}  ${tender_uaid}  ${complaint_id}  ${answer_data}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}'].access_token}
  ${answer_data.data.id}=  Set Variable   ${tender.data.complaints[${complaint_id}].id}
  ${complaint_with_answer}=  Call Method  ${USERS.users['${username}'].client}  _patch_tender_resource_item  ${tender}  ${answer_data}  complaints
  Log many   ${USERS.users['${username}'].client}  ${tender}  ${answer_data}
  Log object data   ${complaint_with_answer}  complaint_with_answer


Подати цінову пропозицію
  [Arguments]  ${username}  ${tender_uaid}  ${bid}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${biddingresponse}=  Call Method  ${USERS.users['${username}'].client}  create_bid  ${tender}  ${bid}
  Log  ${biddingresponse}
  [return]  ${biddingresponse}


Змінити цінову пропозицію
  [Arguments]  ${username}  ${tender_uaid}  ${bid}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${changed_bid}=  Call Method  ${USERS.users['${username}'].client}  patch_bid  ${tender}  ${bid}
  Log  ${changed_bid}
  [return]   ${changed_bid}


Скасувати цінову пропозицію
  [Arguments]  ${username}  ${tender_uaid}  ${bid}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${changed_bid}=  Call Method  ${USERS.users['${username}'].client}  delete_bid   ${tender}  ${bid}
  Log  ${changed_bid}
  [return]   ${changed_bid}


Прийняти цінову пропозицію
  [Arguments]  ${username}  ${tender_uaid}  ${award}
  ${internalid}=  Отримати internal id по UAid  ${username}  ${tender_uaid}
  ${tender}=  Call Method  ${USERS.users['${username}'].client}  get_tender  ${internalid}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}'].access_token}
  ${award_activeted_response}=  Call Method  ${USERS.users['${username}'].client}  patch_award  ${tender}  ${award}
  Log  ${award_activeted_response}
  [return]  ${award_activeted_response}


Завантажити документ в ставку
  [Arguments]  ${username}  ${path}  ${tender_uaid}
  ${bid_id}=  Get Variable Value   ${USERS.users['${username}'].bidresponses['resp'].data.id}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
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
  [Arguments]  ${username}  ${filepath}  ${tender_uaid}
  Log  ${username}
  Log  ${tender_uaid}
  Log  ${filepath}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${tender}=  set_access_key  ${tender}   ${USERS.users['${username}'].access_token}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  upload_document  ${filepath}  ${tender}
  Log object data   ${reply}  reply
  [return]   ${reply}


Отримати посилання на аукціон для глядача
  [Arguments]  ${username}  ${tender_uaid}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  [return]  ${tender.data.auctionUrl}


Отримати посилання на аукціон для учасника
  [Arguments]  ${username}  ${tender_uaid}
  ${bid}=  Викликати для учасника  ${username}  Отримати пропозицію  ${tender_uaid}
  [return]  ${bid.data.participationUrl}


Отримати пропозицію
  [Arguments]  ${username}  ${tender_uaid}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${bid_id}=  Get Variable Value  ${USERS.users['${username}'].bidresponses['resp'].data.id}
  ${token}=  Get Variable Value  ${USERS.users['${username}'].bidresponses['resp'].access.token}
  ${bid}=  Call Method  ${USERS.users['${username}'].client}  get_bid  ${tender}  ${bid_id}  ${token}
  [return]  ${bid}


Отримати документ
  [Arguments]  ${username}  ${tender_uaid}  ${url}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${token}=    Get Variable Value  ${USERS.users['${username}'].bidresponses['resp'].access.token}
  ${contents}  ${filename}=  Call Method  ${USERS.users['${username}'].client}  get_file   ${tender}   ${url}   ${token}
  Log   ${filename}
  [return]   ${contents}  ${filename}


Створити лот
  [Arguments]  ${username}  ${tender}  ${lot}
  Log  ${username}
  Log  ${tender}
  Log  ${lot}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}'].access_token}
  ${tender_lot}=  Call Method  ${USERS.users['${username}'].client}   create_lot   ${tender}    ${lot}
  Log   ${tender_lot}
  [return]  ${tender_lot}
  #TODO:
  #[Arguments]  ${username}  ${tender_uaid}  ${lot}
  #${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}


Змінити лот
  [Arguments]  ${username}  ${tender}  ${lot}
  ${tender}=  set_access_key  ${tender}   ${USERS.users['${username}'].access_token}
  ${tender_lot}=  Call Method  ${USERS.users['${username}'].client}   patch_lot   ${tender}    ${lot}
  Log   ${tender_lot}
  [return]  ${tender_lot}
  #TODO:
  #[Arguments]  ${username}  ${tender_uaid}  ${lot}
  #${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}


Завантажити документ в лот
  [Arguments]  ${username}  ${filepath}  ${tender_uaid}  ${lot_id}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${tender}=  set_access_key  ${tender}   ${USERS.users['${username}'].access_token}
  ${doc}=  Завантажити документ  ${username}  ${filepath}  ${tender_uaid}
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
  #[Arguments]  ${username}  ${tender_uaid}  ${lot}
  #${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}

##############################################################################
#             Limited procurement
##############################################################################

Модифікувати закупівлю
  [Documentation]
  ...      [Arguments] Username and tender uaid
  ...      Find tender using uaid, get data from additional_items_data and call patch_tender
  ...      [Return] Nothing
  [Arguments]  ${username}  ${tender_uaid}
  ${tender}=  Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${data}=  additional_items_data  ${tender['data']['id']}  ${tender['access']['token']}
  Log  ${data}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  additional_items  ${data['data']['items']}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_tender  ${data}
  Log  ${reply}


Додати і підтвердити постачальника
  [Documentation]
  ...      [Arguments] Username, tender uaid and supplier data
  ...      Find tender using uaid and call create_award
  ...      [Return] Nothing
  [Arguments]  ${username}  ${tender_uaid}  ${supplier_data}
  ${tender}=  Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  create_award  ${tender}  ${supplier_data}
  Log  ${reply}
  ${supplier_number}=  Set variable  0
  Підтвердити постачальника  ${username}  ${tender_uaid}  ${supplier_number}


Підтвердити постачальника
  [Documentation]
  ...      [Arguments] Username, tender uaid and number of the award to confirm
  ...      Find tender using uaid, get data from confirm_supplier and call patch_award
  ...      [Return] Nothing
  [Arguments]  ${username}  ${tender_uaid}  ${award_num}
  ${tender}=  Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${data}=  test_confirm_data  ${tender['data']['awards'][${award_num}]['id']}
  Log  ${data}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_award  ${tender}  ${data}
  Log  ${reply}


Скасувати закупівлю
  [Documentation]
  ...      [Arguments] Username, tender uaid, cancellation reason,
  ...      document and new description of document
  ...      [Description] Find tender using uaid, set cancellation reason, get data from cancel_tender
  ...      and call create_cancellation
  ...      After that add document to cancellation and change description of document
  ...      [Return] Nothing
  [Arguments]  ${username}  ${tender_uaid}  ${cancellation_reason}  ${document}  ${new_description}
  ${tender}=  Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${data}=  cancel_tender  ${cancellation_reason}
  Log  ${data}
  ${cancel_reply}=  Call Method  ${USERS.users['${username}'].client}  create_cancellation  ${tender}  ${data}
  Log  ${cancel_reply}
  ${cancellation_id}=  Set variable  ${cancel_reply.data.id}


  ${document_id}=  Завантажити документацію до запиту на скасування  ${username}  ${tender_uaid}  ${cancellation_id}  ${document}


  Змінити опис документа в скасуванні  ${username}  ${tender_uaid}  ${cancellation_id}  ${document_id}  ${new_description}


  Підтвердити скасування закупівлі  ${username}  ${tender_uaid}  ${cancellation_id}


Завантажити документацію до запиту на скасування
  [Documentation]
  ...      [Arguments] Username, tender uaid, cancellation id and document to upload
  ...      [Description] Find tender using uaid, and call upload_cancellation_document
  ...      [Return] ID of added document
  [Arguments]  ${username}  ${tender_uaid}  ${cancellation_id}  ${document}
  ${tender}=  Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${doc_reply}=  Call Method  ${USERS.users['${username}'].client}  upload_cancellation_document  ${document}  ${tender}  ${cancellation_id}
  Log  ${doc_reply}
  [Return]  ${doc_reply.data.id}


Змінити опис документа в скасуванні
  [Documentation]
  ...      [Arguments] Username, tender uaid, cancellation id, document id and new description of document
  ...      [Description] Find tender using uaid, create dict with data about description and call
  ...      patch_cancellation_document
  ...      [Return] Nothing
  [Arguments]  ${username}  ${tender_uaid}  ${cancellation_id}  ${document_id}  ${new_description}
  ${field}=  Set variable  description
  ${tender}=  Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${temp}=  Create Dictionary  ${field}  ${new_description}
  ${data}=  Create Dictionary  data  ${temp}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_cancellation_document  ${tender}  ${data}  ${cancellation_id}  ${document_id}
  Log  ${reply}


Завантажити нову версію документа до запиту на скасування
  [Documentation]
  ...      [Arguments] Username, tender uaid, cancallation number and cancellation document number
  ...      Find tender using uaid, create fake documentation and call update_cancellation_document
  ...      [Return] Nothing
  [Arguments]  ${username}  ${tender_uaid}  ${cancel_num}  ${doc_num}
  ${tender}=  Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${second_cancel_doc}=  create_fake_doc
  Set To Dictionary  ${USERS.users['${tender_owner}']}  second_cancel_doc  ${second_cancel_doc}
  Log  ${second_cancel_doc}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  update_cancellation_document  ${second_cancel_doc}  ${tender}  ${tender['data']['cancellations'][${cancel_num}]['id']}  ${tender['data']['cancellations'][${cancel_num}]['documents'][${doc_num}]['id']}
  Log  ${reply}


Підтвердити скасування закупівлі
  [Documentation]
  ...      [Arguments] Username, tender uaid, cancellation number
  ...      Find tender using uaid, get cancellation confirmation data and call patch_cancellation
  ...      [Return] Nothing
  [Arguments]  ${username}  ${tender_uaid}  ${cancel_id}
  ${tender}=  Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${data}=  test_confirm_data  ${cancel_id}
  Log  ${data}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_cancellation  ${tender}  ${data}
  Log  ${reply}


Підтвердити підписання контракту
  [Documentation]
  ...      [Arguments] Username, tender uaid, contract number
  ...      Find tender using uaid, get contract confirmation data and call patch_contract
  ...      [Return] Nothing
  [Arguments]  ${username}  ${tender_uaid}  ${contract_num}
  ${tender}=  Викликати для учасника  ${username}  Пошук тендера по ідентифікатору  ${tender_uaid}
  ${data}=  test_confirm_data  ${tender['data']['contracts'][${contract_num}]['id']}
  Log  ${data}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_contract  ${tender}  ${data}
  Log  ${reply}
