*** Settings ***
Library  openprocurement_client_helper.py


*** Keywords ***
Отримати internal id по UAid
  [Arguments]  ${username}  ${tender_uaid}
  Log  ${username}
  Log  ${tender_uaid}
  Log Many  ${USERS.users['${username}'].id_map}
  ${status}=  Run Keyword And Return Status  Dictionary Should Contain Key  ${USERS.users['${username}'].id_map}  ${tender_uaid}
  Run Keyword And Return If  ${status}  Get From Dictionary  ${USERS.users['${username}'].id_map}  ${tender_uaid}
  Call Method  ${USERS.users['${username}'].client}  get_tenders
  ${tender_id}=  Wait Until Keyword Succeeds  5x  30 sec  get_tender_id_by_uaid  ${tender_uaid}  ${USERS.users['${username}'].client}  id_field=auctionID
  Set To Dictionary  ${USERS.users['${username}'].id_map}  ${tender_uaid}  ${tender_id}
  [return]  ${tender_id}


Підготувати клієнт для користувача
  [Arguments]  ${username}
  [Documentation]  Відкрити браузер, створити об’єкт api wrapper, тощо
  Log  ${api_host_url}
  Log  ${api_version}
  ${api_wrapper}=  prepare_api_wrapper  ${USERS.users['${username}'].api_key}  ${api_host_url}  ${api_version}
  Set To Dictionary  ${USERS.users['${username}']}  client=${api_wrapper}
  Set To Dictionary  ${USERS.users['${username}']}  access_token=${EMPTY}
  ${id_map}=  Create Dictionary
  Set To Dictionary  ${USERS.users['${username}']}  id_map=${id_map}
  Log Variables


Підготувати дані для оголошення тендера
  [Documentation]  Це слово використовується в майданчиків, тому потрібно, щоб воно було і тут
  [Arguments]  ${username}  ${tender_data}
  [return]  ${tender_data}


Підготувати дані для оголошення тендера користувачем
  [Documentation]  Це слово використовується в майданчиків, тому потрібно, щоб воно було і тут
  [Arguments]  ${username}  ${tender_data}  ${role_name}
  [return]  ${tender_data}


Створити тендер
  [Arguments]  ${username}  ${tender_data}
  ${tender}=  Call Method  ${USERS.users['${username}'].client}  create_tender  ${tender_data}
  Log object data  ${tender}  created_tender
  ${access_token}=  Get Variable Value  ${tender.access.token}
  Set To Dictionary  ${USERS.users['${username}']}   access_token=${access_token}
  Set To Dictionary  ${USERS.users['${username}']}   tender_data=${tender}
  Log   ${access_token}
  Log   ${tender.data.id}
  Log   ${USERS.users['${username}'].tender_data}
  [return]  ${tender.data.auctionID}


Пошук тендера по ідентифікатору
  [Arguments]  ${username}  ${tender_uaid}
  ${internalid}=  openprocurement_client.Отримати internal id по UAid  ${username}  ${tender_uaid}
  ${tender}=  openprocurement_client.Отримати тендер  ${username}  ${internalid}
  [return]   ${tender}


Оновити сторінку з тендером
  [Arguments]  ${username}  ${tender_uaid}
  ${tender_data}=  openprocurement_client.Пошук тендера по ідентифікатору    ${username}  ${tender_uaid}
  Log  ${tender_data}


Отримати інформацію із тендера
  [Arguments]  ${username}  ${field_name}
  Log  ${username}
  Log  ${field_name}

  openprocurement_client.Пошук тендера по ідентифікатору
  ...      ${username}
  ...      ${TENDER['TENDER_UAID']}

  ${status}  ${field_value}=  Run keyword and ignore error
  ...      Get from object
  ...      ${USERS.users['${username}'].tender_data.data}
  ...      ${field_name}
  Run Keyword if  '${status}' == 'PASS'  Return from keyword   ${field_value}

  Fail  Field not found: ${field_name}


Отримати інформацію із запитання
  [Arguments]  ${username}  ${question_id}  ${field_name}
  ${field_name}=  Отримати шлях до поля об’єкта  ${username}  ${field_name}  ${question_id}
  Run Keyword And Return  openprocurement_client.Отримати інформацію із тендера  ${username}  ${field_name}


Внести зміни в тендер
  [Arguments]  ${username}  ${tender_uaid}  ${fieldname}  ${fieldvalue}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  Set_To_Object  ${tender.data}   ${fieldname}   ${fieldvalue}
  ${procurementMethodType}=  Get Variable Value  ${tender.data.procurementMethodType}
  Run Keyword If  '${procurementMethodType}' == 'aboveThresholdUA' or '${procurementMethodType}' == 'aboveThresholdEU'
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
  Set To Dictionary  ${USERS.users['${username}']}  tender_data=${tender}
  Log  ${tender}
  [Return]  ${tender}


Додати предмет закупівлі
  [Arguments]  ${username}  ${tender_uaid}  ${item}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  Append To List  ${tender.data['items']}  ${item}
  Call Method  ${USERS.users['${username}'].client}  patch_tender  ${tender}


Видалити предмет закупівлі
  [Arguments]  ${username}  ${tender_uaid}  ${item_id}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${item_index}=  get_object_index_by_id  ${tender.data['items']}  ${item_id}
  Remove From List  ${tender.data['items']}  ${item_index}
  Call Method  ${USERS.users['${username}'].client}  patch_tender  ${tender}


Задати питання
  [Arguments]  ${username}  ${tender_uaid}  ${question}
  Log  ${question}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${biddingresponse}=  Call Method  ${USERS.users['${username}'].client}  create_question  ${tender}  ${question}
  [return]  ${biddingresponse}


Відповісти на питання
  [Arguments]  ${username}  ${tender_uaid}  ${question}  ${answer_data}  ${question_id}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}'].access_token}
  ${answer_data.data.id}=  openprocurement_client.Отримати інформацію із запитання  ${username}  ${question_id}  id
  ${question_with_answer}=  Call Method  ${USERS.users['${username}'].client}  patch_question  ${tender}  ${answer_data}
  Log object data   ${question_with_answer}  question_with_answer
  [return]  ${question_with_answer}


Подати цінову пропозицію
  [Arguments]  ${username}  ${tender_uaid}  ${bid}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${lots}=  Run Keyword If  "${mode}" == "single"  Get Variable Value  ${tender.data.lots}
  ${bid}=  Run Keyword If  ${lots}  test_bid_data  multiLot
  ...                  ELSE  Set Variable  ${bid}
  Run Keyword If  ${lots}
  ...       Run Keywords
  ...       Remove From List  ${bid.data.lotValues}  1
  ...       AND
  ...       Set_To_Object  ${bid.data.lotValues[0]}  relatedLot  ${lots[0].id}
  ${biddingresponse}=  Call Method  ${USERS.users['${username}'].client}  create_bid  ${tender}  ${bid}
  Set To Dictionary   ${USERS.users['${username}'].bidresponses['bid'].data}  id=${biddingresponse['data']['id']}
  Log  ${biddingresponse}
  [return]  ${biddingresponse}


Змінити цінову пропозицію
  [Arguments]  ${username}  ${tender_uaid}  ${fieldname}  ${fieldvalue}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${lots}=  Run Keyword If  "${mode}" == "single"  Get Variable Value  ${tender.data.lots}
  ${fieldname}=  Run Keyword If  ${lots}  Set Variable  lotValues.0.${fieldname}
  ...                        ELSE  Set Variable  ${fieldname}
  ${bid}=  openprocurement_client.Отримати пропозицію  ${username}  ${tender_uaid}
  Set_To_Object  ${bid.data}   ${fieldname}   ${fieldvalue}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}'].bidresponses['resp'].access.token}
  ${changed_bid}=  Call Method  ${USERS.users['${username}'].client}  patch_bid  ${tender}  ${bid}
  Log  ${changed_bid}
  [return]   ${changed_bid}


Скасувати цінову пропозицію
  [Arguments]  ${username}  ${tender_uaid}  ${bid}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  Set To Dictionary   ${bid.data}  id=${USERS.users['${username}'].bidresponses['bid'].data.id}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}'].bidresponses['resp'].access.token}
  ${changed_bid}=  Call Method  ${USERS.users['${username}'].client}  delete_bid   ${tender}  ${bid}
  Log  ${changed_bid}
  [return]   ${changed_bid}


Прийняти цінову пропозицію
  [Arguments]  ${username}  ${tender_uaid}  ${award}
  ${internalid}=  openprocurement_client.Отримати internal id по UAid  ${username}  ${tender_uaid}
  ${tender}=  Call Method  ${USERS.users['${username}'].client}  get_tender  ${internalid}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}'].access_token}
  ${award_activeted_response}=  Call Method  ${USERS.users['${username}'].client}  patch_award  ${tender}  ${award}
  Log  ${award_activeted_response}
  [return]  ${award_activeted_response}


Завантажити документ в ставку
  [Arguments]  ${username}  ${path}  ${tender_uaid}  ${doc_type}=documents
  ${bid_id}=  Get Variable Value   ${USERS.users['${username}'].bidresponses['resp'].data.id}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}'].bidresponses['resp'].access.token}
  ${response}=  Call Method  ${USERS.users['${username}'].client}  upload_bid_document  ${path}  ${tender}  ${bid_id}  ${doc_type}
  ${uploaded_file} =  Create Dictionary   filepath=${path}   upload_response=${response}
  Log  ${response}
  Log object data   ${uploaded_file}
  [return]  ${uploaded_file}


Змінити документ в ставці
  [Arguments]  ${username}  ${tender_uaid}  ${path}  ${bidid}  ${docid}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}'].bidresponses['resp'].access.token}
  ${response}=  Call Method  ${USERS.users['${username}'].client}  update_bid_document  ${path}  ${tender}   ${bidid}   ${docid}
  ${uploaded_file} =  Create Dictionary   filepath=${path}   upload_response=${response}
  Log  ${response}
  Log object data   ${uploaded_file}
  [return]  ${uploaded_file}


Змінити документацію в ставці
  [Arguments]  ${username}  ${tender_uaid}  ${doc_data}  ${bidid}  ${docid}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}'].bidresponses['resp'].access.token}
  ${response}=  Call Method  ${USERS.users['${username}'].client}  patch_bid_document   ${tender}   ${doc_data}   ${bidid}   ${docid}
  Log  ${response}
  [return]  ${response}


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
  [Arguments]  ${username}  ${tender_uaid}  ${lot_id}=${Empty}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${lot_auctionUrl}=  Run Keyword If  "${mode}" == "single"  Get Variable Value  ${tender.data.lots[0].auctionUrl}
  ${auctionUrl}=  Run Keyword If  ${lot_auctionUrl.__class__ is not type(None)}  Set Variable  ${lot_auctionUrl}
  ...                         ELSE IF  '${lot_id}'  Set Variable  ${tender.data.lots[${lot_index}].auctionUrl}
  ...                         ELSE  Set Variable  ${tender.data.auctionUrl}
  [return]  ${auctionUrl}


Отримати посилання на аукціон для учасника
  [Arguments]  ${username}  ${tender_uaid}
  ${bid}=  openprocurement_client.Отримати пропозицію  ${username}  ${tender_uaid}
  ${lot_participationUrl}=  Run Keyword If  "${mode}" == "single"  Get Variable Value  ${bid.data.lotValues[0].participationUrl}
  ${participationUrl}=  Run Keyword If  ${lot_participationUrl.__class__ is not type(None)}  Set Variable  ${lot_participationUrl}
  ...                               ELSE  Set Variable  ${bid.data.participationUrl}
  [return]  ${participationUrl}


Отримати пропозицію
  [Arguments]  ${username}  ${tender_uaid}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${bid_id}=  Get Variable Value  ${USERS.users['${username}'].bidresponses['resp'].data.id}
  ${token}=  Get Variable Value  ${USERS.users['${username}'].bidresponses['resp'].access.token}
  ${bid}=  Call Method  ${USERS.users['${username}'].client}  get_bid  ${tender}  ${bid_id}  ${token}
  ${bid}=  munchify  ${bid}
  Log  ${bid}
  [return]  ${bid}


Отримати документ
  [Arguments]  ${username}  ${tender_uaid}  ${url}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${token}=    Get Variable Value  ${USERS.users['${username}'].bidresponses['resp'].access.token}
  ${contents}  ${filename}=  Call Method  ${USERS.users['${username}'].client}  get_file   ${tender}   ${url}   ${token}
  Log   ${filename}
  [return]   ${contents}  ${filename}

##############################################################################
#             Lot operations
##############################################################################

Створити лот
  [Arguments]  ${username}  ${tender_uaid}  ${lot}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}   create_lot   ${tender}    ${lot}
  [return]  ${reply}


Отримати інформацію із лоту
  [Arguments]  ${username}  ${lot_id}  ${field_name}
  ${field_name}=  Отримати шлях до поля об’єкта  ${username}  ${field_name}  ${lot_id}
  Run Keyword And Return  openprocurement_client.Отримати інформацію із тендера  ${username}  ${field_name}


Змінити лот
  [Arguments]  ${username}  ${tender_uaid}  ${lot_id}   ${fieldname}  ${fieldvalue}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${lot_index}=  get_object_index_by_id  ${tender.data.lots}  ${lot_id}
  ${lot}=  Create Dictionary  data=${tender.data.lots[${lot_index}]}
  Set_To_Object   ${lot.data}   ${fieldname}   ${fieldvalue}
  ${reply}=  Call Method   ${USERS.users['${username}'].client}   patch_lot   ${tender}   ${lot}
  [return]  ${reply}


Додати предмет закупівлі в лот
  [Arguments]  ${username}  ${tender_uaid}  ${lot_id}  ${item}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${lot_index}=  get_object_index_by_id  ${tender.data.lots}  ${lot_id}
  ${lot_id}=  Get Variable Value  ${tender.data.lots[${lot_index}].id}
  Set_To_Object   ${item}   relatedLot   ${lot_id}
  Append To List   ${tender.data['items']}   ${item}
  Call Method   ${USERS.users['${username}'].client}   patch_tender   ${tender}


Задати питання до лоту
  [Arguments]  ${username}  ${tender_uaid}  ${lot_id}  ${question}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${lot_index}=  get_object_index_by_id  ${tender.data.lots}  ${lot_id}
  ${lot_id}=  Get Variable Value  ${tender.data.lots[${lot_index}].id}
  ${question}=  test_lot_question_data  ${question}  ${lot_id}
  ${biddingresponse}=  Call Method  ${USERS.users['${username}'].client}  create_question  ${tender}  ${question}
  [return]  ${biddingresponse}


Завантажити документ в лот
  [Arguments]  ${username}  ${filepath}  ${tender_uaid}  ${lot_id}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${lot_index}=  get_object_index_by_id  ${tender.data.lots}  ${lot_id}
  ${lot_id}=  Get Variable Value  ${tender.data.lots[${lot_index}].id}
  ${doc}=  openprocurement_client.Завантажити документ  ${username}  ${filepath}  ${tender_uaid}
  ${lot_doc}=  test_lot_document_data  ${doc}  ${lot_id}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_document   ${tender}   ${lot_doc}
  [return]   ${reply}


Видалити лот
  [Arguments]  ${username}  ${tender_uaid}  ${lot_id}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${lot_index}=  get_object_index_by_id  ${tender.data.lots}  ${lot_id}
  ${lot}=  Create Dictionary  data=${tender.data.lots[${lot_index}]}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}   delete_lot   ${tender}    ${lot}
  [return]  ${reply}


Подати цінову пропозицію на лоти
  [Arguments]  ${username}  ${tender_uaid}  ${bid}  ${lots_ids}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  : FOR    ${index}    ${lot_id}    IN ENUMERATE    @{lots_ids}
  \    ${lot_index}=  get_object_index_by_id  ${tender.data.lots}  ${lot_id}
  \    ${lot_id}=  Get Variable Value  ${tender.data.lots[${lot_index}].id}
  \    Set To Dictionary  ${bid.data.lotValues[${index}]}  relatedLot=${lot_id}
  ${reply}=  openprocurement_client.Подати цінову пропозицію  ${username}  ${tender_uaid}  ${bid}
  [return]  ${reply}

##############################################################################
#             Claims
##############################################################################

Створити вимогу
  [Documentation]  Створює вимогу у статусі "draft"
  [Arguments]  ${username}  ${tender_uaid}  ${claim}
  Log  ${claim}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору
  ...      ${username}
  ...      ${tender_uaid}
  ${reply}=  Call Method
  ...      ${USERS.users['${username}'].client}
  ...      create_complaint
  ...      ${tender}
  ...      ${claim}
  Log  ${reply}
  [return]  ${reply}


Завантажити документацію до вимоги
  [Arguments]  ${username}  ${tender_uaid}  ${claim}  ${document}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${tender}=  set_access_key  ${tender}  ${claim.access.token}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  upload_complaint_document  ${document}  ${tender}  ${claim['data']['id']}
  Log  ${tender}
  Log  ${reply}


Подати вимогу
  [Documentation]  Переводить вимогу зі статусу "draft" у статус "claim"
  [Arguments]  ${username}  ${tender_uaid}  ${claim}  ${confirmation_data}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${tender}=  set_access_key  ${tender}  ${claim.access.token}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_complaint  ${tender}  ${confirmation_data}
  Log  ${tender}
  Log  ${reply}


Відповісти на вимогу
  [Documentation]  Переводить вимогу зі статусу "claim" у статус "answered"
  [Arguments]  ${username}  ${tender_uaid}  ${claim}  ${answer_data}
  Log  ${claim}
  Log  ${answer_data}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  log  ${tender}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_complaint  ${tender}  ${answer_data}
  Log  ${reply}


Підтвердити вирішення вимоги
  [Documentation]  Переводить вимогу зі статусу "answered" у статус "resolved"
  [Arguments]  ${username}  ${tender_uaid}  ${claim}  ${confirmation_data}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${tender}=  set_access_key  ${tender}  ${claim.access.token}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_complaint  ${tender}  ${confirmation_data}
  Log  ${reply}


Скасувати вимогу
  [Documentation]  Переводить вимогу в статус "canceled"
  [Arguments]  ${username}  ${tender_uaid}  ${claim}  ${cancellation_data}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${tender}=  set_access_key  ${tender}  ${claim.access.token}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_complaint  ${tender}  ${cancellation_data}
  Log  ${reply}


Перетворити вимогу в скаргу
  [Documentation]  Переводить вимогу у статус "pending"
  [Arguments]  ${username}  ${tender_uaid}  ${claim}  ${escalating_data}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${tender}=  set_access_key  ${tender}  ${claim.access.token}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_complaint  ${tender}  ${escalating_data}
  Log  ${reply}

##############################################################################
#             Qualification operations
##############################################################################

Завантажити документ рішення кваліфікаційної комісії
  [Documentation]
  ...      [Arguments] Username, tender uaid, qualification number and document to upload
  ...      [Description] Find tender using uaid,  and call upload_qualification_document
  ...      [Return] Reply of API
  [Arguments]  ${username}  ${document}  ${tender_uaid}  ${award_num}  ${lot_id}=${Empty}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${doc}=  Call Method  ${USERS.users['${username}'].client}  upload_award_document  ${document}  ${tender}  ${tender.data.awards[${award_num}].id}
  ${lot_index}=  Run Keyword If  '${lot_id}'  get_object_index_by_id  ${tender.data.lots}  ${lot_id}
  Run Keyword If  '${lot_id}'
  ...      Set To Object  ${doc.data}  documentOf  lot
  ...      Set To Object  ${doc.data}  relatedItem  ${tender.data.lots[${lot_index}].id}
  ...      Call Method  ${USERS.users['${username}'].client}  patch_document   ${tender}   ${doc}
  Log  ${doc}
  [Return]  ${doc}


Підтвердити постачальника
  [Documentation]
  ...      [Arguments] Username, tender uaid and number of the award to confirm
  ...      Find tender using uaid, create dict with confirmation data and call patch_award
  ...      [Return] Nothing
  [Arguments]  ${username}  ${tender_uaid}  ${award_num}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${award}=  create_data_dict  data.status  active
  Set To Dictionary  ${award.data}  id=${tender.data.awards[${award_num}].id}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_award  ${tender}  ${award}
  Log  ${reply}


Дискваліфікувати постачальника
  [Documentation]
  ...      [Arguments] Username, tender uaid and award number
  ...      [Description] Find tender using uaid, create data dict with unsuccessful status and call patch_award
  ...      [Return] Reply of API
  [Arguments]  ${username}  ${tender_uid}  ${award_num}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uid}
  ${award}=  create_data_dict   data.status  unsuccessful
  Set To Dictionary  ${award.data}  id=${tender.data.awards[${award_num}].id}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_award  ${tender}  ${award}
  Log  ${reply}
  [Return]  ${reply}


Скасування рішення кваліфікаційної комісії
  [Documentation]
  ...      [Arguments] Username, tender uaid and award number
  ...      [Description] Find tender using uaid, create data dict with unsuccessful status and call patch_award
  ...      [Return] Reply of API
  [Arguments]  ${username}  ${tender_uid}  ${award_num}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uid}
  ${award}=  create_data_dict   data.status  cancelled
  Set To Dictionary  ${award.data}  id=${tender.data.awards[${award_num}].id}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_award  ${tender}  ${award}
  Log  ${reply}
  [Return]  ${reply}

##############################################################################
#             Limited procurement
##############################################################################

Додати і підтвердити постачальника
  [Documentation]
  ...      [Arguments] Username, tender uaid and supplier data
  ...      Find tender using uaid and call create_award
  ...      [Return] Nothing
  [Arguments]  ${username}  ${tender_uaid}  ${supplier_data}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  create_award  ${tender}  ${supplier_data}
  Log  ${reply}
  ${supplier_number}=  Set variable  0
  openprocurement_client.Підтвердити постачальника  ${username}  ${tender_uaid}  ${supplier_number}


Скасувати закупівлю
  [Documentation]
  ...      [Arguments] Username, tender uaid, cancellation reason,
  ...      document and new description of document
  ...      [Description] Find tender using uaid, set cancellation reason, get data from cancel_tender
  ...      and call create_cancellation
  ...      After that add document to cancellation and change description of document
  ...      [Return] Nothing
  [Arguments]  ${username}  ${tender_uaid}  ${cancellation_reason}  ${document}  ${new_description}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${data}=  test_cancel_tender_data  ${cancellation_reason}
  Log  ${data}
  ${cancel_reply}=  Call Method  ${USERS.users['${username}'].client}  create_cancellation  ${tender}  ${data}
  Log  ${cancel_reply}
  ${cancellation_id}=  Set variable  ${cancel_reply.data.id}

  ${document_id}=  openprocurement_client.Завантажити документацію до запиту на скасування  ${username}  ${tender_uaid}  ${cancellation_id}  ${document}

  openprocurement_client.Змінити опис документа в скасуванні  ${username}  ${tender_uaid}  ${cancellation_id}  ${document_id}  ${new_description}

  openprocurement_client.Підтвердити скасування закупівлі  ${username}  ${tender_uaid}  ${cancellation_id}


Завантажити документацію до запиту на скасування
  [Documentation]
  ...      [Arguments] Username, tender uaid, cancellation id and document to upload
  ...      [Description] Find tender using uaid, and call upload_cancellation_document
  ...      [Return] ID of added document
  [Arguments]  ${username}  ${tender_uaid}  ${cancellation_id}  ${document}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
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
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${temp}=  Create Dictionary  ${field}=${new_description}
  ${data}=  Create Dictionary  data=${temp}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_cancellation_document  ${tender}  ${data}  ${cancellation_id}  ${document_id}
  Log  ${reply}


Завантажити нову версію документа до запиту на скасування
  [Documentation]
  ...      [Arguments] Username, tender uaid, cancallation number and cancellation document number
  ...      Find tender using uaid, create fake documentation and call update_cancellation_document
  ...      [Return] Nothing
  [Arguments]  ${username}  ${tender_uaid}  ${cancel_num}  ${doc_num}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${second_cancel_doc}=  create_fake_doc
  Set To Dictionary  ${USERS.users['${tender_owner}']}  second_cancel_doc=${second_cancel_doc}
  Log  ${second_cancel_doc}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  update_cancellation_document  ${second_cancel_doc}  ${tender}  ${tender['data']['cancellations'][${cancel_num}]['id']}  ${tender['data']['cancellations'][${cancel_num}]['documents'][${doc_num}]['id']}
  Log  ${reply}


Підтвердити скасування закупівлі
  [Documentation]
  ...      [Arguments] Username, tender uaid, cancellation number
  ...      Find tender using uaid, get cancellation test_confirmation data and call patch_cancellation
  ...      [Return] Nothing
  [Arguments]  ${username}  ${tender_uaid}  ${cancel_id}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${data}=  test_confirm_data  ${cancel_id}
  Log  ${data}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_cancellation  ${tender}  ${data}
  Log  ${reply}


Підтвердити підписання контракту
  [Documentation]
  ...      [Arguments] Username, tender uaid, contract number
  ...      Find tender using uaid, get contract test_confirmation data and call patch_contract
  ...      [Return] Nothing
  [Arguments]  ${username}  ${tender_uaid}  ${contract_num}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${data}=  test_confirm_data  ${tender['data']['contracts'][${contract_num}]['id']}
  Log  ${data}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_contract  ${tender}  ${data}
  Log  ${reply}

##############################################################################
#             OpenUA procedure
##############################################################################

Підтвердити кваліфікацію
  [Documentation]
  ...      [Arguments] Username, tender uaid and qualification number
  ...      [Description] Find tender using uaid, create data dict with active status and call patch_qualification
  ...      [Return] Reply of API
  [Arguments]  ${username}  ${tender_uid}  ${qualification_num}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uid}
  ${qualification}=  create_data_dict   data.status  active
  Set To Dictionary  ${qualification.data}  id=${tender.data.qualifications[${qualification_num}].id}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_qualification  ${tender}  ${qualification}
  Log  ${reply}
  [Return]  ${reply}


Відхилити кваліфікацію
  [Documentation]
  ...      [Arguments] Username, tender uaid and qualification number
  ...      [Description] Find tender using uaid, create data dict with unsuccessful status and call patch_qualification
  ...      [Return] Reply of API
  [Arguments]  ${username}  ${tender_uid}  ${qualification_num}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uid}
  ${qualification}=  create_data_dict   data.status  unsuccessful
  Set To Dictionary  ${qualification.data}  id=${tender.data.qualifications[${qualification_num}].id}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_qualification  ${tender}  ${qualification}
  Log  ${reply}
  [Return]  ${reply}


Завантажити документ у кваліфікацію
  [Documentation]
  ...      [Arguments] Username, tender uaid, qualification number and document to upload
  ...      [Description] Find tender using uaid,  and call upload_qualification_document
  ...      [Return] Reply of API
  [Arguments]  ${username}  ${document}  ${tender_uaid}  ${qualification_num}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${doc_reply}=  Call Method  ${USERS.users['${username}'].client}  upload_qualification_document  ${document}  ${tender}  ${tender.data.qualifications[${qualification_num}].id}
  Log  ${doc_reply}
  [Return]  ${doc_reply}


Скасувати кваліфікацію
  [Documentation]
  ...      [Arguments] Username, tender uaid and qualification number
  ...      [Description] Find tender using uaid, create data dict with cancelled status and call patch_qualification
  ...      [Return] Reply of API
  [Arguments]  ${username}  ${tender_uid}  ${qualification_num}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uid}
  ${qualification}=  create_data_dict   data.status  cancelled
  Set To Dictionary  ${qualification.data}  id=${tender.data.qualifications[${qualification_num}].id}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_qualification  ${tender}  ${qualification}
  Log  ${reply}
  [Return]  ${reply}


Затвердити остаточне рішення кваліфікації
  [Documentation]
  ...      [Arguments] Username and tender uaid
  ...
  ...      [Description] Find tender using uaid and call patch_tender
  ...
  ...      [Return] Reply of API
  [Arguments]  ${username}  ${tender_uaid}
  ${internal_id}=  openprocurement_client.Отримати internal id по UAid  ${username}  ${tender_uaid}
  ${tender}=  create_data_dict  data.id  ${internal_id}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}'].access_token}
  set_to_object  ${tender}  data.status  active.pre-qualification.stand-still
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_tender  ${tender}
  Log  ${reply}
  [Return]  ${reply}
