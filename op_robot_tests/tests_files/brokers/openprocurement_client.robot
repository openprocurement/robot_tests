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
  ${tender_id}=  Wait Until Keyword Succeeds  5x  30 sec  get_tender_id_by_uaid  ${tender_uaid}  ${USERS.users['${username}'].client}
  Set To Dictionary  ${USERS.users['${username}'].id_map}  ${tender_uaid}  ${tender_id}
  [return]  ${tender_id}


Підготувати клієнт для користувача
  [Arguments]  ${username}
  [Documentation]  Відкрити браузер, створити об’єкт api wrapper, тощо
  Log  ${API_HOST_URL}
  Log  ${API_VERSION}
  ${api_wrapper}=  prepare_api_wrapper  ${USERS.users['${username}'].api_key}  ${API_HOST_URL}  ${API_VERSION}
  Set To Dictionary  ${USERS.users['${username}']}  client=${api_wrapper}
  Set To Dictionary  ${USERS.users['${username}']}  access_token=${EMPTY}
  ${id_map}=  Create Dictionary
  Set To Dictionary  ${USERS.users['${username}']}  id_map=${id_map}
  Log Variables


Завантажити документ
  [Arguments]  ${username}  ${filepath}  ${tender_uaid}
  Log  ${username}
  Log  ${tender_uaid}
  Log  ${filepath}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${tender}=  set_access_key  ${tender}   ${USERS.users['${username}'].access_token}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  upload_document  ${filepath}  ${tender}
  Log object data   ${reply}  reply
  #return here is needed to have uploaded doc data in `Завантажити документ в лот` keyword
  [return]   ${reply}


Отримати інформацію із документа
  [Arguments]  ${username}  ${tender_uaid}  ${doc_id}  ${field}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${document}=  get_document_by_id  ${tender.data}  ${doc_id}
  Log  ${document}
  [Return]  ${document['${field}']}


Отримати документ
  [Arguments]  ${username}  ${tender_uaid}  ${doc_id}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${document}=  get_document_by_id  ${tender.data}  ${doc_id}
  ${filename}=  download_file_from_url  ${document.url}  ${OUTPUT_DIR}${/}${document.title}
  [return]  ${filename}


Отримати посилання на аукціон для глядача
  [Arguments]  ${username}  ${tender_uaid}  ${lot_id}=${Empty}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${object_with_url}=  get_object_by_id  ${tender.data}  ${lot_id}  lots  id
  Log  ${object_with_url}
  ${auctionUrl}=  Get Variable Value  ${object_with_url['auctionUrl']}
  [Return]  ${auctionUrl}


Отримати посилання на аукціон для учасника
  [Arguments]  ${username}  ${tender_uaid}  ${relatedLot}=${Empty}
  ${bid}=  openprocurement_client.Отримати пропозицію  ${username}  ${tender_uaid}
  ${object_with_url}=  get_object_by_id  ${bid.data}  ${relatedLot}  lotValues  relatedLot
  Log  ${object_with_url}
  ${participationUrl}=  Get Variable Value  ${object_with_url['participationUrl']}
  [Return]  ${participationUrl}

##############################################################################
#             Tender operations
##############################################################################

Підготувати дані для оголошення тендера
  [Documentation]  Це слово використовується в майданчиків, тому потрібно, щоб воно було і тут
  [Arguments]  ${username}  ${tender_data}  ${role_name}
  [return]  ${tender_data}


Створити тендер
  [Arguments]  ${username}  ${tender_data}
  ${tender}=  Call Method  ${USERS.users['${username}'].client}  create_tender  ${tender_data}
  Log  ${tender}
  ${access_token}=  Get Variable Value  ${tender.access.token}
  ${status}=  Set Variable If  'open' in '${MODE}'  active.tendering  ${EMPTY}
  ${status}=  Set Variable If  'below' in '${MODE}'  active.enquiries  ${status}
  ${status}=  Set Variable If  '${status}'=='${EMPTY}'  active   ${status}
  Set To Dictionary  ${tender['data']}  status=${status}
  ${tender}=  Call Method  ${USERS.users['${username}'].client}  patch_tender  ${tender}
  Log  ${tender}
  Log  ${\n}${API_HOST_URL}/api/${API_VERSION}/tenders/${tender.data.id}${\n}  WARN
  Set To Dictionary  ${USERS.users['${username}']}   access_token=${access_token}
  Set To Dictionary  ${USERS.users['${username}']}   tender_data=${tender}
  Log   ${USERS.users['${username}'].tender_data}
  [return]  ${tender.data.tenderID}


Пошук тендера по ідентифікатору
  [Arguments]  ${username}  ${tender_uaid}  ${save_key}=tender_data
  ${internalid}=  openprocurement_client.Отримати internal id по UAid  ${username}  ${tender_uaid}
  ${tender}=  Call Method  ${USERS.users['${username}'].client}  get_tender  ${internalid}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}'].access_token}
  Set To Dictionary  ${USERS.users['${username}']}  ${save_key}=${tender}
  ${tender}=  munch_dict  arg=${tender}
  Log  ${tender}
  [return]   ${tender}


Отримати тендер другого етапу та зберегти його
  [Arguments]  ${username}  ${tender_id}
  ${response}=  Call Method  ${USERS.users['${username}'].client}  patch_credentials  ${tender_id}  ${USERS.users['${username}'].access_token}
  ${tender}=  set_access_key  ${response}  ${response.access.token}
  Set To Dictionary  ${USERS.users['${username}']}   access_token=${response.access.token}
  Set To Dictionary  ${USERS.users['${username}']}  tender_data=${response}
  Log  ${tender.data.tenderID}


Оновити сторінку з тендером
  [Arguments]  ${username}  ${tender_uaid}
  openprocurement_client.Пошук тендера по ідентифікатору    ${username}  ${tender_uaid}


Отримати інформацію із тендера
  [Arguments]  ${username}  ${tender_uaid}  ${field_name}
  openprocurement_client.Пошук тендера по ідентифікатору
  ...      ${username}
  ...      ${tender_uaid}

  ${status}  ${field_value}=  Run keyword and ignore error
  ...      Get from object
  ...      ${USERS.users['${username}'].tender_data.data}
  ...      ${field_name}
  Run Keyword if  '${status}' == 'PASS'  Return from keyword   ${field_value}

  Fail  Field not found: ${field_name}


Внести зміни в тендер
  [Arguments]  ${username}  ${tender_uaid}  ${fieldname}  ${fieldvalue}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  Set_To_Object  ${tender.data}   ${fieldname}   ${fieldvalue}
  ${procurementMethodType}=  Get From Object  ${tender.data}  procurementMethodType
  Run Keyword If  '${procurementMethodType}' == 'aboveThresholdUA' or '${procurementMethodType}' == 'aboveThresholdEU'
  ...      Remove From Dictionary  ${tender.data}  enquiryPeriod
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}'].access_token}
  ${tender}=  Call Method  ${USERS.users['${username}'].client}  patch_tender  ${tender}
  Set_To_Object   ${USERS.users['${username}'].tender_data}   ${fieldname}   ${fieldvalue}

##############################################################################
#             Item operations
##############################################################################

Додати предмет закупівлі
  [Arguments]  ${username}  ${tender_uaid}  ${item}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  Append To List  ${tender.data['items']}  ${item}
  Call Method  ${USERS.users['${username}'].client}  patch_tender  ${tender}


Отримати інформацію із предмету
  [Arguments]  ${username}  ${tender_uaid}  ${item_id}  ${field_name}
  ${field_name}=  Отримати шлях до поля об’єкта  ${username}  ${field_name}  ${item_id}
  Run Keyword And Return  openprocurement_client.Отримати інформацію із тендера  ${username}  ${tender_uaid}  ${field_name}


Видалити предмет закупівлі
  [Arguments]  ${username}  ${tender_uaid}  ${item_id}  ${lot_id}=${Empty}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${item_index}=  get_object_index_by_id  ${tender.data['items']}  ${item_id}
  Remove From List  ${tender.data['items']}  ${item_index}
  Call Method  ${USERS.users['${username}'].client}  patch_tender  ${tender}

##############################################################################
#             Lot operations
##############################################################################

Створити лот
  [Arguments]  ${username}  ${tender_uaid}  ${lot}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}   create_lot   ${tender}    ${lot}
  #return here is needed to have created lot id in `Створити лот з предметом закупівлі` keyword
  [return]  ${reply}


Створити лот із предметом закупівлі
  [Arguments]  ${username}  ${tender_uaid}  ${lot}  ${item}
  ${reply}=  openprocurement_client.Створити лот  ${username}  ${tender_uaid}  ${lot}
  ${lot_id}=  get_id_from_object  ${lot.data}
  openprocurement_client.Додати предмет закупівлі в лот  ${username}  ${tender_uaid}  ${lot_id}  ${item}


Отримати інформацію із лоту
  [Arguments]  ${username}  ${tender_uaid}  ${lot_id}  ${field_name}
  ${field_name}=  Отримати шлях до поля об’єкта  ${username}  ${field_name}  ${lot_id}
  Run Keyword And Return  openprocurement_client.Отримати інформацію із тендера  ${username}  ${tender_uaid}  ${field_name}


Змінити лот
  [Arguments]  ${username}  ${tender_uaid}  ${lot_id}   ${fieldname}  ${fieldvalue}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${lot_index}=  get_object_index_by_id  ${tender.data.lots}  ${lot_id}
  ${lot}=  Create Dictionary  data=${tender.data.lots[${lot_index}]}
  Set_To_Object   ${lot.data}   ${fieldname}   ${fieldvalue}
  ${reply}=  Call Method   ${USERS.users['${username}'].client}   patch_lot   ${tender}   ${lot}


Додати предмет закупівлі в лот
  [Arguments]  ${username}  ${tender_uaid}  ${lot_id}  ${item}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${lot_index}=  get_object_index_by_id  ${tender.data.lots}  ${lot_id}
  ${lot_id}=  Get Variable Value  ${tender.data.lots[${lot_index}].id}
  Set_To_Object   ${item}   relatedLot   ${lot_id}
  Append To List   ${tender.data['items']}   ${item}
  Call Method   ${USERS.users['${username}'].client}   patch_tender   ${tender}


Завантажити документ в лот
  [Arguments]  ${username}  ${filepath}  ${tender_uaid}  ${lot_id}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${lot_index}=  get_object_index_by_id  ${tender.data.lots}  ${lot_id}
  ${lot_id}=  Get Variable Value  ${tender.data.lots[${lot_index}].id}
  ${doc}=  openprocurement_client.Завантажити документ  ${username}  ${filepath}  ${tender_uaid}
  ${lot_doc}=  test_lot_document_data  ${doc}  ${lot_id}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_document   ${tender}   ${lot_doc}


Видалити лот
  [Arguments]  ${username}  ${tender_uaid}  ${lot_id}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${lot_index}=  get_object_index_by_id  ${tender.data.lots}  ${lot_id}
  ${lot}=  Create Dictionary  data=${tender.data.lots[${lot_index}]}
  :FOR  ${item}  IN  @{tender.data['items']}
  \  ${item_id}=  get_id_from_object  ${item}
  \  Run Keyword If  '${item.relatedLot}'=='${lot.data.id}'
  \  ...     openprocurement_client.Видалити предмет закупівлі  ${username}  ${tender_uaid}  ${item_id}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}   delete_lot   ${tender}    ${lot}


Скасувати лот
  [Arguments]  ${username}  ${tender_uaid}  ${lot_id}  ${cancellation_reason}  ${document}  ${new_description}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${lot_id}=  Get Variable Value  ${tender.data.lots[${lot_index}].id}
  ${data}=  Create dictionary
  ...      reason=${cancellation_reason}
  ...      cancellationOf=lot
  ...      relatedLot=${lot_id}
  ${cancellation_data}=  Create dictionary  data=${data}
  ${cancellation_data}=  munch_dict  arg=${cancellation_data}
  ${cancel_reply}=  Call Method  ${USERS.users['${username}'].client}  create_cancellation  ${tender}  ${cancellation_data}
  ${cancellation_id}=  Set variable  ${cancel_reply.data.id}

  ${document_id}=  openprocurement_client.Завантажити документацію до запиту на скасування  ${username}  ${tender_uaid}  ${cancellation_id}  ${document}

  openprocurement_client.Змінити опис документа в скасуванні  ${username}  ${tender_uaid}  ${cancellation_id}  ${document_id}  ${new_description}

  openprocurement_client.Підтвердити скасування закупівлі  ${username}  ${tender_uaid}  ${cancellation_id}


Отримати інформацію з документа до лоту
  [Arguments]  ${username}  ${tender_uaid}  ${lot_id}  ${doc_id}  ${field}
  openprocurement_client.Отримати інформацію з документа  ${username}  ${tender_uaid}  ${doc_id}  ${field}


Отримати документ до лоту
  [Arguments]  ${username}  ${tender_uaid}  ${lot_id}  ${doc_id}
  Run Keyword And Return  openprocurement_client.Отримати документ  ${username}  ${tender_uaid}  ${doc_id}

##############################################################################
#             Feature operations
##############################################################################

Додати неціновий показник на тендер
  [Arguments]  ${username}  ${tender_uaid}  ${feature}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  Append To List  ${tender.data['features']}  ${feature}
  Call Method  ${USERS.users['${username}'].client}  patch_tender  ${tender}


Додати неціновий показник на предмет
  [Arguments]  ${username}  ${tender_uaid}  ${feature}  ${item_id}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${item_index}=  get_object_index_by_id  ${tender.data['items']}  ${item_id}
  ${item_id}=  Get Variable Value  ${tender.data['items'][${item_index}].id}
  Set To Dictionary  ${feature}  relatedItem=${item_id}
  Append To List  ${tender.data['features']}  ${feature}
  Call Method  ${USERS.users['${username}'].client}  patch_tender  ${tender}


Додати неціновий показник на лот
  [Arguments]  ${username}  ${tender_uaid}  ${feature}  ${lot_id}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${lot_index}=  get_object_index_by_id  ${tender.data['lots']}  ${lot_id}
  ${lot_id}=  Get Variable Value  ${tender.data['lots'][${lot_index}].id}
  Set To Dictionary  ${feature}  relatedItem=${lot_id}
  Append To List  ${tender.data['features']}  ${feature}
  Call Method  ${USERS.users['${username}'].client}  patch_tender  ${tender}


Отримати інформацію із нецінового показника
  [Arguments]  ${username}  ${tender_uaid}  ${feature_id}  ${field_name}
  ${field_name}=  Отримати шлях до поля об’єкта  ${username}  ${field_name}  ${feature_id}
  Run Keyword And Return  openprocurement_client.Отримати інформацію із тендера  ${username}  ${tender_uaid}  ${field_name}


Видалити неціновий показник
  [Arguments]  ${username}  ${tender_uaid}  ${feature_id}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${feature_index}=  get_object_index_by_id  ${tender.data['features']}  ${feature_id}
  Remove From List  ${tender.data['features']}  ${feature_index}
  Call Method  ${USERS.users['${username}'].client}  patch_tender  ${tender}


##############################################################################
#             Questions
##############################################################################

Задати запитання на предмет
  [Arguments]  ${username}  ${tender_uaid}  ${item_id}  ${question}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${item_index}=  get_object_index_by_id  ${tender.data['items']}  ${item_id}
  ${item_id}=  Get Variable Value  ${tender.data['items'][${item_index}].id}
  ${question}=  test_related_question  ${question}  item  ${item_id}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  create_question  ${tender}  ${question}


Задати запитання на лот
  [Arguments]  ${username}  ${tender_uaid}  ${lot_id}  ${question}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${lot_index}=  get_object_index_by_id  ${tender.data.lots}  ${lot_id}
  ${lot_id}=  Get Variable Value  ${tender.data.lots[${lot_index}].id}
  ${question}=  test_related_question  ${question}  lot  ${lot_id}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  create_question  ${tender}  ${question}


Задати запитання на тендер
  [Arguments]  ${username}  ${tender_uaid}  ${question}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  create_question  ${tender}  ${question}


Отримати інформацію із запитання
  [Arguments]  ${username}  ${tender_uaid}  ${question_id}  ${field_name}
  ${field_name}=  Отримати шлях до поля об’єкта  ${username}  ${field_name}  ${question_id}
  Run Keyword And Return  openprocurement_client.Отримати інформацію із тендера  ${username}  ${tender_uaid}  ${field_name}


Відповісти на запитання
  [Arguments]  ${username}  ${tender_uaid}  ${answer_data}  ${question_id}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}'].access_token}
  ${answer_data.data.id}=  openprocurement_client.Отримати інформацію із запитання  ${username}  ${tender_uaid}  ${question_id}  id
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_question  ${tender}  ${answer_data}

##############################################################################
#             Claims
##############################################################################

Отримати internal id по UAid для скарги
  [Arguments]  ${tender}  ${complaintID}
  ${complaint_internal_id}=  get_complaint_internal_id  ${tender}  ${complaintID}
  [Return]  ${complaint_internal_id}

#Ключові слова типу `* про виправлення умов закупівлі` додані для сумісності з майданчиками

Створити чернетку вимоги про виправлення умов закупівлі
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
  Set To Dictionary  ${USERS.users['${username}']}  complaint_access_token=${reply.access.token}
  [return]  ${reply.data.complaintID}


Створити чернетку вимоги про виправлення умов лоту
  [Documentation]  Створює вимогу у статусі "draft"
  [Arguments]  ${username}  ${tender_uaid}  ${claim}  ${lot_id}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору
  ...      ${username}
  ...      ${tender_uaid}
  ${lot_index}=  get_object_index_by_id  ${tender.data.lots}  ${lot_id}
  Set to dictionary  ${claim.data}  relatedLot=${tender.data.lots[${lot_index}].id}
  ${complaintID}=  openprocurement_client.Створити чернетку вимоги про виправлення умов закупівлі
  ...      ${username}
  ...      ${tender_uaid}
  ...      ${claim}
  [return]  ${complaintID}


Створити чернетку вимоги про виправлення визначення переможця
  [Documentation]  Створює вимогу у статусі "draft"
  [Arguments]  ${username}  ${tender_uaid}  ${claim}  ${award_index}
  Log  ${claim}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору
  ...      ${username}
  ...      ${tender_uaid}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}'].access_token}
  ${reply}=  Call Method
  ...      ${USERS.users['${username}'].client}
  ...      create_award_complaint
  ...      ${tender}
  ...      ${claim}
  ...      ${tender.data.awards[${award_index}].id}
  Log  ${reply}
  Set To Dictionary  ${USERS.users['${username}']}  complaint_access_token=${reply.access.token}
  Log  ${USERS.users['${username}'].complaint_access_token}
  [return]  ${reply.data.complaintID}


Створити вимогу про виправлення умов закупівлі
  [Documentation]  Створює вимогу у статусі "claim"
  ...      Можна створити вимогу як з документацією, так і без неї
  [Arguments]  ${username}  ${tender_uaid}  ${claim}  ${document}=${None}

  ${complaintID}=  openprocurement_client.Створити чернетку вимоги про виправлення умов закупівлі
  ...      ${username}
  ...      ${tender_uaid}
  ...      ${claim}

  ${status}=  Run keyword and return status  Should not be equal  ${document}  ${None}
  Log  ${status}
  Run keyword if  ${status} == ${True}  openprocurement_client.Завантажити документацію до вимоги
  ...      ${username}
  ...      ${tender_uaid}
  ...      ${complaintID}
  ...      ${document}

  ${data}=  Create Dictionary  status=claim
  ${confirmation_data}=  Create Dictionary  data=${data}
  openprocurement_client.Подати вимогу
  ...      ${username}
  ...      ${tender_uaid}
  ...      ${complaintID}
  ...      ${confirmation_data}
  [return]  ${complaintID}


Створити вимогу про виправлення умов лоту
  [Documentation]  Створює вимогу у статусі "claim"
  ...      Можна створити вимогу як з документацією, так і без неї
  ...      Якщо lot_index == None, то створюється вимога про виправлення умов тендера.
  [Arguments]  ${username}  ${tender_uaid}  ${claim}  ${lot_id}  ${document}=${None}
  ${complaintID}=  openprocurement_client.Створити чернетку вимоги про виправлення умов лоту
  ...      ${username}
  ...      ${tender_uaid}
  ...      ${claim}
  ...      ${lot_id}

  ${status}=  Run keyword and return status  Should not be equal  ${document}  ${None}
  Log  ${status}
  Run keyword if  ${status} == ${True}  openprocurement_client.Завантажити документацію до вимоги
  ...      ${username}
  ...      ${tender_uaid}
  ...      ${complaintID}
  ...      ${document}

  ${data}=  Create Dictionary  status=claim
  ${confirmation_data}=  Create Dictionary  data=${data}
  openprocurement_client.Подати вимогу
  ...      ${username}
  ...      ${tender_uaid}
  ...      ${complaintID}
  ...      ${confirmation_data}

  [return]  ${complaintID}


Створити вимогу про виправлення визначення переможця
  [Documentation]  Створює вимогу у статусі "claim"
  ...      Можна створити вимогу як з документацією, так і без неї
  [Arguments]  ${username}  ${tender_uaid}  ${claim}  ${award_index}  ${document}=${None}
  ${complaintID}=  openprocurement_client.Створити чернетку вимоги про виправлення визначення переможця
  ...      ${username}
  ...      ${tender_uaid}
  ...      ${claim}
  ...      ${award_index}

  ${status}=  Run keyword and return status  Should not be equal  ${document}  ${None}
  Log  ${status}
  Run keyword if  ${status} == ${True}  openprocurement_client.Завантажити документацію до вимоги про виправлення визначення переможця
  ...      ${username}
  ...      ${tender_uaid}
  ...      ${complaintID}
  ...      ${award_index}
  ...      ${document}

  ${status}=  Set variable if  'open' in '${MODE}'  pending  claim
  ${data}=  Create Dictionary  status=${status}
  ${confirmation_data}=  Create Dictionary  data=${data}
  openprocurement_client.Подати вимогу про виправлення визначення переможця
  ...      ${username}
  ...      ${tender_uaid}
  ...      ${complaintID}
  ...      ${award_index}
  ...      ${confirmation_data}

  [return]  ${complaintID}


Завантажити документацію до вимоги
  [Arguments]  ${username}  ${tender_uaid}  ${complaintID}  ${document}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}'].complaint_access_token}
  ${complaint_internal_id}=  openprocurement_client.Отримати internal id по UAid для скарги  ${tender}  ${complaintID}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  upload_complaint_document  ${document}  ${tender}  ${complaint_internal_id}
  Log  ${tender}
  Log  ${reply}


Завантажити документацію до вимоги про виправлення визначення переможця
  [Arguments]  ${username}  ${tender_uaid}  ${complaintID}  ${award_index}  ${document}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору
  ...      ${username}
  ...      ${tender_uaid}
  Log  ${USERS.users['${username}'].complaint_access_token}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}'].complaint_access_token}
  ${complaint_internal_id}=  openprocurement_client.Отримати internal id по UAid для скарги  ${tender}  ${complaintID}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  upload_award_complaint_document  ${document}  ${tender}  ${tender.data.awards[${award_index}].id}  ${complaint_internal_id}
  Log  ${tender}
  Log  ${reply}


Подати вимогу
  [Documentation]  Переводить вимогу зі статусу "draft" у статус "claim"
  [Arguments]  ${username}  ${tender_uaid}  ${complaintID}  ${confirmation_data}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}'].complaint_access_token}
  ${complaint_internal_id}=  openprocurement_client.Отримати internal id по UAid для скарги  ${tender}  ${complaintID}
  Set To Dictionary  ${confirmation_data.data}  id=${complaint_internal_id}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_complaint  ${tender}  ${confirmation_data}
  Log  ${tender}
  Log  ${reply}


Подати вимогу про виправлення визначення переможця
  [Documentation]  Переводить вимогу зі статусу "draft" у статус "claim"
  [Arguments]  ${username}  ${tender_uaid}  ${complaintID}  ${award_index}  ${confirmation_data}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору
  ...      ${username}
  ...      ${tender_uaid}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}'].complaint_access_token}
  ${complaint_internal_id}=  openprocurement_client.Отримати internal id по UAid для скарги  ${tender}  ${complaintID}
  Set To Dictionary  ${confirmation_data.data}  id=${complaint_internal_id}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_award_complaint  ${tender}  ${confirmation_data}  ${tender.data.awards[${award_index}].id}
  Log  ${tender}
  Log  ${reply}


Відповісти на вимогу про виправлення умов закупівлі
  [Documentation]  Переводить вимогу зі статусу "claim" у статус "answered"
  [Arguments]  ${username}  ${tender_uaid}  ${complaintID}  ${answer_data}
  openprocurement_client.Відповісти на вимогу про виправлення умов лоту
  ...      ${username}
  ...      ${tender_uaid}
  ...      ${complaintID}
  ...      ${answer_data}


Відповісти на вимогу про виправлення умов лоту
  [Documentation]  Переводить вимогу зі статусу "claim" у статус "answered"
  [Arguments]  ${username}  ${tender_uaid}  ${complaintID}  ${answer_data}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${complaint_internal_id}=  openprocurement_client.Отримати internal id по UAid для скарги  ${tender}  ${complaintID}
  Set To Dictionary  ${answer_data.data}  id=${complaint_internal_id}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_complaint  ${tender}  ${answer_data}
  log  ${tender}
  Log  ${reply}


Відповісти на вимогу про виправлення визначення переможця
  [Documentation]  Переводить вимогу зі статусу "claim" у статус "answered"
  [Arguments]  ${username}  ${tender_uaid}  ${complaintID}  ${answer_data}  ${award_index}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${complaint_internal_id}=  openprocurement_client.Отримати internal id по UAid для скарги  ${tender}  ${complaintID}
  Set To Dictionary  ${answer_data.data}  id=${complaint_internal_id}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_award_complaint  ${tender}  ${answer_data}  ${tender.data.awards[${award_index}].id}
  log  ${tender}
  Log  ${reply}


Підтвердити вирішення вимоги про виправлення умов закупівлі
  [Documentation]  Переводить вимогу зі статусу "answered" у статус "resolved"
  [Arguments]  ${username}  ${tender_uaid}  ${complaintID}  ${confirmation_data}
  openprocurement_client.Підтвердити вирішення вимоги про виправлення умов лоту  ${username}  ${tender_uaid}  ${complaintID}  ${confirmation_data}


Підтвердити вирішення вимоги про виправлення умов лоту
  [Documentation]  Переводить вимогу зі статусу "answered" у статус "resolved"
  [Arguments]  ${username}  ${tender_uaid}  ${complaintID}  ${confirmation_data}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}'].complaint_access_token}
  ${complaint_internal_id}=  openprocurement_client.Отримати internal id по UAid для скарги  ${tender}  ${complaintID}
  Set To Dictionary  ${confirmation_data.data}  id=${complaint_internal_id}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_complaint  ${tender}  ${confirmation_data}
  Log  ${reply}


Підтвердити вирішення вимоги про виправлення визначення переможця
  [Documentation]  Переводить вимогу зі статусу "answered" у статус "resolved"
  [Arguments]  ${username}  ${tender_uaid}  ${complaintID}  ${confirmation_data}  ${award_index}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}'].complaint_access_token}
  ${complaint_internal_id}=  openprocurement_client.Отримати internal id по UAid для скарги  ${tender}  ${complaintID}
  Set To Dictionary  ${confirmation_data.data}  id=${complaint_internal_id}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_award_complaint  ${tender}  ${confirmation_data}  ${tender.data.awards[${award_index}].id}
  Log  ${reply}


Скасувати вимогу про виправлення умов закупівлі
  [Documentation]  Переводить вимогу в статус "canceled"
  [Arguments]  ${username}  ${tender_uaid}  ${complaintID}  ${cancellation_data}
  openprocurement_client.Скасувати вимогу про виправлення умов лоту  ${username}  ${tender_uaid}  ${complaintID}  ${cancellation_data}


Скасувати вимогу про виправлення умов лоту
  [Documentation]  Переводить вимогу в статус "canceled"
  [Arguments]  ${username}  ${tender_uaid}  ${complaintID}  ${cancellation_data}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}'].complaint_access_token}
  ${complaint_internal_id}=  openprocurement_client.Отримати internal id по UAid для скарги  ${tender}  ${complaintID}
  Set To Dictionary  ${cancellation_data.data}  id=${complaint_internal_id}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_complaint  ${tender}  ${cancellation_data}
  Log  ${reply}


Скасувати вимогу про виправлення визначення переможця
  [Documentation]  Переводить вимогу в статус "canceled"
  [Arguments]  ${username}  ${tender_uaid}  ${complaintID}  ${cancellation_data}  ${award_index}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}'].complaint_access_token}
  ${complaint_internal_id}=  openprocurement_client.Отримати internal id по UAid для скарги  ${tender}  ${complaintID}
  Set To Dictionary  ${cancellation_data.data}  id=${complaint_internal_id}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_award_complaint  ${tender}  ${cancellation_data}  ${tender.data.awards[${award_index}].id}
  Log  ${reply}


Перетворити вимогу про виправлення умов закупівлі в скаргу
  [Documentation]  Переводить вимогу у статус "pending"
  [Arguments]  ${username}  ${tender_uaid}  ${complaintID}  ${escalating_data}
  openprocurement_client.Перетворити вимогу про виправлення умов лоту в скаргу  ${username}  ${tender_uaid}  ${complaintID}  ${escalating_data}


Перетворити вимогу про виправлення умов лоту в скаргу
  [Documentation]  Переводить вимогу у статус "pending"
  [Arguments]  ${username}  ${tender_uaid}  ${complaintID}  ${escalating_data}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}'].complaint_access_token}
  ${complaint_internal_id}=  openprocurement_client.Отримати internal id по UAid для скарги  ${tender}  ${complaintID}
  Set To Dictionary  ${escalating_data.data}  id=${complaint_internal_id}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_complaint  ${tender}  ${escalating_data}
  Log  ${reply}


Перетворити вимогу про виправлення визначення переможця в скаргу
  [Documentation]  Переводить вимогу у статус "pending"
  [Arguments]  ${username}  ${tender_uaid}  ${complaintID}  ${escalating_data}  ${award_index}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}'].complaint_access_token}
  ${complaint_internal_id}=  openprocurement_client.Отримати internal id по UAid для скарги  ${tender}  ${complaintID}
  Set To Dictionary  ${escalating_data.data}  id=${complaint_internal_id}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_award_complaint  ${tender}  ${escalating_data}  ${tender.data.awards[${award_index}].id}
  Log  ${reply}


Отримати інформацію із скарги
  [Arguments]  ${username}  ${tender_uaid}  ${complaintID}  ${field_name}  ${award_index}=${None}
  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${complaints}=  Get Variable Value  ${USERS.users['${username}'].tender_data.data.awards[${award_index}].complaints}  ${USERS.users['${username}'].tender_data.data.complaints}
  ${complaint_index}=  get_complaint_index_by_complaintID  ${complaints}  ${complaintID}
  ${field_value}=  Get Variable Value  ${complaints[${complaint_index}]['${field_name}']}
  [Return]  ${field_value}


Отримати інформацію із документа до скарги
  [Arguments]  ${username}  ${tender_uaid}  ${complaintID}  ${doc_id}  ${field_name}  ${award_id}=${None}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${document}=  get_document_by_id  ${tender.data}  ${doc_id}
  Log  ${document}
  [Return]  ${document['${field_name}']}


Отримати документ до скарги
  [Arguments]  ${username}  ${tender_uaid}  ${complaintID}  ${doc_id}  ${award_id}=${None}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${document}=  get_document_by_id  ${tender.data}  ${doc_id}
  ${filename}=  download_file_from_url  ${document.url}  ${OUTPUT_DIR}${/}${document.title}
  [return]  ${filename}

##############################################################################
#             Bid operations
##############################################################################

Подати цінову пропозицію
  [Arguments]  ${username}  ${tender_uaid}  ${bid}  ${lots_ids}=${None}  ${features_ids}=${None}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${lots_ids}=  Run Keyword IF  ${lots_ids}  Set Variable  ${lots_ids}
  ...     ELSE  Create List
  : FOR    ${index}    ${lot_id}    IN ENUMERATE    @{lots_ids}
  \    ${lot_index}=  get_object_index_by_id  ${tender.data.lots}  ${lot_id}
  \    ${lot_id}=  Get Variable Value  ${tender.data.lots[${lot_index}].id}
  \    Set To Dictionary  ${bid.data.lotValues[${index}]}  relatedLot=${lot_id}
  ${features_ids}=  Run Keyword IF  ${features_ids}  Set Variable  ${features_ids}
  ...     ELSE  Create List
  : FOR    ${index}    ${feature_id}    IN ENUMERATE    @{features_ids}
  \    ${feature_index}=  get_object_index_by_id  ${tender.data.features}  ${feature_id}
  \    ${code}=  Get Variable Value  ${tender.data.features[${feature_index}].code}
  \    Set To Dictionary  ${bid.data.parameters[${index}]}  code=${code}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  create_bid  ${tender}  ${bid}
  Log  ${reply}
  ${status}=  Set Variable If  '${MODE}'=='openeu'  pending  active
  Set To Dictionary  ${reply['data']}  status=${status}
  ${reply_active}=  Call Method  ${USERS.users['${username}'].client}  patch_bid  ${tender}  ${reply}
  Set To Dictionary  ${USERS.users['${username}']}  access_token=${reply['access']['token']}
  Set To Dictionary   ${USERS.users['${username}'].bidresponses['bid'].data}  id=${reply['data']['id']}
  Log  ${reply_active}


Змінити цінову пропозицію
  [Arguments]  ${username}  ${tender_uaid}  ${fieldname}  ${fieldvalue}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${bid}=  openprocurement_client.Отримати пропозицію  ${username}  ${tender_uaid}
  Set_To_Object  ${bid.data}   ${fieldname}   ${fieldvalue}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}']['access_token']}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_bid  ${tender}  ${bid}
  Log  ${reply}


Скасувати цінову пропозицію
  [Arguments]  ${username}  ${tender_uaid}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${bid_id}=  openprocurement_client.Отримати інформацію із пропозиції  ${username}  ${tender_uaid}  id
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  delete_bid   ${tender}  ${bid_id}  ${USERS.users['${username}']['access_token']}
  Log  ${reply}


Завантажити документ в ставку
  [Arguments]  ${username}  ${path}  ${tender_uaid}  ${doc_type}=documents
  ${bid_id}=  Get Variable Value   ${USERS.users['${username}'].bidresponses['bid'].data.id}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}']['access_token']}
  ${response}=  Call Method  ${USERS.users['${username}'].client}  upload_bid_document  ${path}  ${tender}  ${bid_id}  ${doc_type}
  ${uploaded_file} =  Create Dictionary
  ...      filepath=${path}
  ...      upload_response=${response}
  Log object data   ${uploaded_file}
  [return]  ${uploaded_file}


Змінити документ в ставці
  [Arguments]  ${username}  ${tender_uaid}  ${path}  ${doc_id}
  ${bid_id}=  Get Variable Value   ${USERS.users['${username}'].bidresponses['bid'].data.id}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}']['access_token']}
  ${bid}=  openprocurement_client.Отримати пропозицію  ${username}  ${tender_uaid}
  ${bid_doc}=  get_document_by_id  ${bid.data}  ${doc_id}
  ${response}=  Call Method  ${USERS.users['${username}'].client}  update_bid_document  ${path}  ${tender}   ${bid_id}   ${bid_doc['id']}
  ${uploaded_file} =  Create Dictionary
  ...      filepath=${path}
  ...      upload_response=${response}
  Log object data   ${uploaded_file}
  [return]  ${uploaded_file}


Змінити документацію в ставці
  [Arguments]  ${username}  ${tender_uaid}  ${doc_data}  ${doc_id}
  ${bid_id}=  Get Variable Value   ${USERS.users['${username}'].bidresponses['bid'].data.id}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}']['access_token']}
  ${bid}=  openprocurement_client.Отримати пропозицію  ${username}  ${tender_uaid}
  ${bid_doc}=  get_document_by_id  ${bid.data}  ${doc_id}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_bid_document   ${tender}   ${doc_data}   ${bid_id}   ${bid_doc['id']}


Отримати пропозицію
  [Arguments]  ${username}  ${tender_uaid}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${bid_id}=  Get Variable Value  ${USERS.users['${username}'].bidresponses['bid'].data.id}
  ${token}=  Get Variable Value  ${USERS.users['${username}']['access_token']}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  get_bid  ${tender}  ${bid_id}  ${token}
  ${reply}=  munch_dict  arg=${reply}
  [return]  ${reply}


Отримати інформацію із пропозиції
  [Arguments]  ${username}  ${tender_uaid}  ${field}
  ${bid}=  openprocurement_client.Отримати пропозицію  ${username}  ${tender_uaid}
  [return]  ${bid.data.${field}}


##############################################################################
#             Qualification operations
##############################################################################

Завантажити документ рішення кваліфікаційної комісії
  [Documentation]
  ...      [Arguments] Username, tender uaid, qualification number and document to upload
  ...      [Description] Find tender using uaid,  and call upload_qualification_document
  ...      [Return] Reply of API
  [Arguments]  ${username}  ${document}  ${tender_uaid}  ${award_num}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${doc}=  Call Method  ${USERS.users['${username}'].client}  upload_award_document  ${document}  ${tender}  ${tender.data.awards[${award_num}].id}
  Log  ${doc}


Підтвердити постачальника
  [Documentation]
  ...      [Arguments] Username, tender uaid and number of the award to confirm
  ...      Find tender using uaid, create dict with confirmation data and call patch_award
  ...      [Return] Nothing
  [Arguments]  ${username}  ${tender_uaid}  ${award_num}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${award}=  create_data_dict  data.status  active
  Set To Dictionary  ${award.data}  id=${tender.data.awards[${award_num}].id}
  Run Keyword IF  'open' in '${MODE}'
  ...      Set To Dictionary  ${award.data}
  ...      qualified=${True}
  ...      eligible=${True}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_award  ${tender}  ${award}
  Log  ${reply}


Дискваліфікувати постачальника
  [Documentation]
  ...      [Arguments] Username, tender uaid and award number
  ...      [Description] Find tender using uaid, create data dict with unsuccessful status and call patch_award
  ...      [Return] Reply of API
  [Arguments]  ${username}  ${tender_uaid}  ${award_num}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
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
  [Arguments]  ${username}  ${tender_uaid}  ${award_num}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${award}=  create_data_dict   data.status  cancelled
  Set To Dictionary  ${award.data}  id=${tender.data.awards[${award_num}].id}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_award  ${tender}  ${award}
  Log  ${reply}

##############################################################################
#             Limited procurement
##############################################################################

Створити постачальника, додати документацію і підтвердити його
  [Documentation]
  ...      [Arguments] Username, tender uaid and supplier data
  ...      Find tender using uaid and call create_award, add documentation to that award and update his status to active
  ...      [Return] Nothing
  [Arguments]  ${username}  ${tender_uaid}  ${supplier_data}  ${document}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  create_award  ${tender}  ${supplier_data}
  Log  ${reply}
  ${supplier_number}=  Set variable  0
  openprocurement_client.Завантажити документ рішення кваліфікаційної комісії  ${username}  ${document}  ${tender_uaid}  ${supplier_number}
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
  ${data}=  Create dictionary  reason=${cancellation_reason}
  ${cancellation_data}=  Create dictionary  data=${data}
  ${cancellation_data}=  munch_dict  arg=${cancellation_data}
  ${cancel_reply}=  Call Method  ${USERS.users['${username}'].client}  create_cancellation  ${tender}  ${cancellation_data}
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


Отримати інформацію із документа до скасування
  [Arguments]  ${username}  ${tender_uaid}  ${cancel_id}  ${doc_id}  ${field_name}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${document}=  get_document_by_id  ${tender.data}  ${doc_id}
  Log  ${document}
  [Return]  ${document['${field_name}']}


Отримати документ до скасування
  [Arguments]  ${username}  ${tender_uaid}  ${cancel_id}  ${doc_id}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${document}=  get_document_by_id  ${tender.data}  ${doc_id}
  ${filename}=  download_file_from_url  ${document.url}  ${OUTPUT_DIR}${/}${document.title}
  [return]  ${filename}

##############################################################################
#             OpenUA procedure
##############################################################################

Підтвердити кваліфікацію
  [Documentation]
  ...      [Arguments] Username, tender uaid and qualification number
  ...      [Description] Find tender using uaid, create data dict with active status and call patch_qualification
  ...      [Return] Reply of API
  [Arguments]  ${username}  ${tender_uaid}  ${qualification_num}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${qualification}=  create_data_dict   data.status  active
  Set To Dictionary  ${qualification.data}  id=${tender.data.qualifications[${qualification_num}].id}  eligible=${True}  qualified=${True}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_qualification  ${tender}  ${qualification}
  Log  ${reply}


Відхилити кваліфікацію
  [Documentation]
  ...      [Arguments] Username, tender uaid and qualification number
  ...      [Description] Find tender using uaid, create data dict with unsuccessful status and call patch_qualification
  ...      [Return] Reply of API
  [Arguments]  ${username}  ${tender_uaid}  ${qualification_num}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${qualification}=  create_data_dict   data.status  unsuccessful
  Set To Dictionary  ${qualification.data}  id=${tender.data.qualifications[${qualification_num}].id}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_qualification  ${tender}  ${qualification}
  Log  ${reply}


Завантажити документ у кваліфікацію
  [Documentation]
  ...      [Arguments] Username, tender uaid, qualification number and document to upload
  ...      [Description] Find tender using uaid,  and call upload_qualification_document
  ...      [Return] Reply of API
  [Arguments]  ${username}  ${document}  ${tender_uaid}  ${qualification_num}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${doc_reply}=  Call Method  ${USERS.users['${username}'].client}  upload_qualification_document  ${document}  ${tender}  ${tender.data.qualifications[${qualification_num}].id}
  Log  ${doc_reply}


Скасувати кваліфікацію
  [Documentation]
  ...      [Arguments] Username, tender uaid and qualification number
  ...      [Description] Find tender using uaid, create data dict with cancelled status and call patch_qualification
  ...      [Return] Reply of API
  [Arguments]  ${username}  ${tender_uaid}  ${qualification_num}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${qualification}=  create_data_dict   data.status  cancelled
  Set To Dictionary  ${qualification.data}  id=${tender.data.qualifications[${qualification_num}].id}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_qualification  ${tender}  ${qualification}
  Log  ${reply}


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


Перевести тендер на статус очікування обробки мостом
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
  set_to_object  ${tender}  data.status  active.stage2.waiting
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_tender  ${tender}
  Log  ${reply}


Активувати другий етап
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
  set_to_object  ${tender}  data.status  active.tendering
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_tender  ${tender}
  Log  ${reply}

##############################################################################
#             CONTRACT SIGNING
##############################################################################

Редагувати угоду
  [Arguments]  ${username}  ${tender_uaid}  ${contract_index}  ${fieldname}  ${fieldvalue}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${contract}=  Create Dictionary  data=${tender.data.contracts[${contract_index}]}
  Set_to_object  ${contract.data}  ${fieldname}  ${fieldvalue}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_contract  ${tender}  ${contract}
  Log  ${reply}


Встановити дату підписання угоди
  [Arguments]  ${username}  ${tender_uaid}  ${contract_index}  ${fieldvalue}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${contract}=  Create Dictionary  data=${tender.data.contracts[${contract_index}]}
  Set To Dictionary  ${contract.data}  dateSigned=${fieldvalue}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_contract  ${tender}  ${contract}
  Log  ${reply}


Вказати дату початку дії угоди
  [Arguments]  ${username}  ${tender_uaid}  ${contract_index}  ${fieldvalue}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${period}=  Create Dictionary  startDate=${fieldvalue}
  ${contract}=  Create Dictionary  data=${tender.data.contracts[${contract_index}]}
  Set To Dictionary  ${contract.data}  period=${period}
  Log  ${contract}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_contract  ${tender}  ${contract}
  Log  ${reply}


Вказати дату завершення дії угоди
  [Arguments]  ${username}  ${tender_uaid}  ${contract_index}  ${fieldvalue}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${period}=  Create Dictionary  endDate=${fieldvalue}
  ${contract}=  Create Dictionary  data=${tender.data.contracts[${contract_index}]}
  Set To Dictionary  ${contract.data}  period=${period}
  Log  ${contract}
  ${reply}=  Call Method  ${USERS.users['${username}'].client}  patch_contract  ${tender}  ${contract}
  Log  ${reply}


Завантажити документ в угоду
  [Arguments]  ${username}  ${path}  ${tender_uaid}  ${contract_index}  ${doc_type}=documents
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${contract_id}=  Get Variable Value  ${tender.data.contracts[${contract_index}].id}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}']['access_token']}
  ${response}=  Call Method  ${USERS.users['${username}'].client}  upload_contract_document  ${path}  ${tender}  ${contract_id}  ${doc_type}
  ${uploaded_file} =  Create Dictionary
  ...      filepath=${path}
  ...      upload_response=${response}
  Log object data  ${uploaded_file}


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
