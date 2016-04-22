*** Settings ***
Library            op_robot_tests.tests_files.service_keywords
Library            Collections
Resource           keywords.robot
Resource           resource.robot


*** Keywords ***
Можливість оголосити тендер
  ${tender_data}=  Підготовка даних для створення тендера
  ${adapted_data}=  Адаптувати дані для оголошення тендера  ${tender_owner}  ${tender_data}
  ${TENDER_UAID}=  Run As  ${tender_owner}  Створити тендер  ${adapted_data}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  initial_data=${adapted_data}
  Set To Dictionary  ${TENDER}  TENDER_UAID=${TENDER_UAID}
  Log  ${TENDER}


Можливість знайти тендер по ідентифікатору
  :FOR  ${username}  IN  ${tender_owner}  ${provider}  ${provider1}  ${viewer}
  \  Дочекатись синхронізації з майданчиком  ${username}
  \  Run As  ${username}  Пошук тендера по ідентифікатору  ${TENDER['TENDER_UAID']}


Можливість додати тендерну документацію
  ${filepath}=  create_fake_doc
  ${doc_upload_reply}=  Run As  ${tender_owner}  Завантажити документ  ${filepath}  ${TENDER['TENDER_UAID']}
  ${file_upload_process_data} =  Create Dictionary  filepath=${filepath}  doc_upload_reply=${doc_upload_reply}
  Log  ${file_upload_process_data}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  file_upload_process_data=${file_upload_process_data}
  Log  ${USERS.users['${tender_owner}']}


Можливість добавити предмет закупівлі в тендер
  ${item}=  Підготовка даних для створення предмету закупівлі
  Run As   ${tender_owner}   Додати предмет закупівлі    ${TENDER['TENDER_UAID']}   ${item}
  ${item_id}=  get_id_from_object  ${item}
  ${item_data}=  Create Dictionary  item=${item}  item_id=${item_id}
  ${item_data}=  munch_dict  arg=${item_data}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  item_data=${item_data}


Можливість видалити предмет закупівлі з тендера
  Run As  ${tender_owner}  Видалити предмет закупівлі  ${TENDER['TENDER_UAID']}  ${USERS.users['${tender_owner}'].item_data.item_id}

##############################################################################################
#             LOTS
##############################################################################################

Можливість додати документацію до лоту
  ${lot_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].initial_data.data.lots[0]}
  ${filepath}=   create_fake_doc
  Run As   ${tender_owner}   Завантажити документ в лот  ${filepath}   ${TENDER['TENDER_UAID']}  ${lot_id}


Можливість добавити предмет закупівлі в лот
  ${lot_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].initial_data.data.lots[0]}
  ${item}=  Підготовка даних для створення предмету закупівлі
  Run As   ${tender_owner}   Додати предмет закупівлі в лот    ${TENDER['TENDER_UAID']}  ${lot_id}   ${item}
  ${item_id}=  get_id_from_object  ${item}
  ${item_data}=  Create Dictionary  item=${item}  item_id=${item_id}
  ${item_data}=  munch_dict  arg=${item_data}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  item_data=${item_data}


Можливість видалити предмет закупівлі з лоту
  ${lot_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].initial_data.data.lots[0]}
  Run As  ${tender_owner}  Видалити предмет закупівлі  ${TENDER['TENDER_UAID']}  ${USERS.users['${tender_owner}'].item_data.item_id}  ${lot_id}


Можливість створення лоту
  ${lot}=  Підготовка даних для створення лоту
  ${lot_resp}=  Run As   ${tender_owner}  Створити лот  ${TENDER['TENDER_UAID']}  ${lot}
  ${lot_id}=  get_id_from_object  ${lot.data}
  ${lot_data}=  Create Dictionary  lot=${lot}  lot_resp=${lot_resp}  lot_id=${lot_id}
  ${lot_data}=  munch_dict  arg=${lot_data}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  lot_data=${lot_data}
  log  ${lot_resp}


Можливість видалення лоту
  Run As  ${tender_owner}  Видалити лот  ${TENDER['TENDER_UAID']}  ${USERS.users['${tender_owner}'].lot_data.lot_id}


Відображення ${field} першого лоту для усіх користувачів
  ${lot_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].initial_data.data.lots[0]}
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}  ${provider}  ${provider1}
  \  Дочекатись синхронізації з майданчиком    ${username}
  \  Звірити поле тендера із значенням  ${username}
  \  ...      ${USERS.users['${tender_owner}'].initial_data.data.lots[0].${field}}  ${field}
  \  ...      object_id=${lot_id}


Відображення ${field} першого лоту
  ${lot_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].initial_data.data.lots[0]}
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data.data.lots[0].${field}}  ${field}
  ...      object_id=${lot_id}


Можливість змінити ${field} першого лоту до ${value}
  ${lot_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].initial_data.data.lots[0]}
  Run As   ${tender_owner}  Змінити лот  ${TENDER['TENDER_UAID']}  ${lot_id}  ${field}   ${value}

##############################################################################################
#             QUESTIONS
##############################################################################################

Можливість задати питання на тендер
  [Arguments]  ${username}
  ${question}=  Підготовка даних для запитання
  ${question_resp}=  Run As  ${username}  Задати питання  ${TENDER['TENDER_UAID']}  ${question}
  ${now}=  Get Current TZdate
  ${question.data.date}=  Set variable  ${now}
  ${question_id}=  get_id_from_object  ${question.data}
  ${question_data}=  Create Dictionary  question=${question}  question_resp=${question_resp}  question_id=${question_id}
  ${question_data}=  munch_dict  arg=${question_data}
  Set To Dictionary  ${USERS.users['${username}']}  question_data=${question_data}


Можливість задати питання на лот
  [Arguments]  ${username}
  ${lot_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].tender_data.data.lots[0]}
  ${question}=  Підготовка даних для запитання
  ${question_resp}=  Run As   ${username}   Задати питання на лот  ${TENDER['TENDER_UAID']}  ${lot_id}  ${question}
  ${now}=  Get Current TZdate
  ${question.data.date}=  Set variable  ${now}
  ${question_id}=  get_id_from_object  ${question.data}
  ${question_data}=  Create Dictionary  question=${question}  question_resp=${question_resp}  question_id=${question_id}
  ${question_data}=  munch_dict  arg=${question_data}


Можливість задати питання на предмет
  [Arguments]  ${username}
  ${item_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].tender_data.data['items'][0]}
  ${question}=  Підготовка даних для запитання
  ${question_resp}=  Run As   ${username}   Задати питання на предмет  ${TENDER['TENDER_UAID']}  ${item_id}  ${question}
  ${now}=  Get Current TZdate
  ${question.data.date}=  Set variable  ${now}
  ${question_id}=  get_id_from_object  ${question.data}
  ${question_data}=  Create Dictionary  question=${question}  question_resp=${question_resp}  question_id=${question_id}
  ${question_data}=  munch_dict  arg=${question_data}


Можливість відповісти на запитання
  ${answer}=  Підготовка даних для відповіді на запитання
  ${answer_resp}=  Run As  ${tender_owner}
  ...      Відповісти на питання  ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['question_data']['question_resp']}  ${answer}
  ...      question_id=${USERS.users['${provider}'].question_data.question_id}
  ${now}=  Get Current TZdate
  ${answer.data.date}=  Set variable  ${now}
  ${answer_data}=  Create Dictionary  answer=${answer}  answer_resp=${answer_resp}
  Set To Dictionary  ${USERS.users['${provider}']}  answer_data=${answer_data}

##############################################################################################
#             BIDDING
##############################################################################################

Можливість подати цінову пропозицію на тендер
  [Arguments]  ${username}
  ${bid}=  Підготувати дані для подання пропозиції
  ${bidresponses}=  Create Dictionary  bid=${bid}
  Set To Dictionary  ${USERS.users['${username}']}  bidresponses=${bidresponses}
  ${resp}=  Run As  ${username}  Подати цінову пропозицію  ${TENDER['TENDER_UAID']}  ${bid}
  Set To Dictionary  ${USERS.users['${username}'].bidresponses}  resp=${resp}


Можливість подати цінову пропозицію на лоти
  [Arguments]  ${username}
  @{lots_ids}=  Отримати ідентифікатори об’єктів  ${username}  lots
  ${number_of_lots}=  Get Length  ${lots_ids}
  ${bid}=  Підготувати дані для подання пропозиції  ${number_of_lots}
  ${bidresponses}=  Create Dictionary  bid=${bid}
  Set To Dictionary  ${USERS.users['${username}']}   bidresponses=${bidresponses}
  ${resp}=  Run As  ${username}  Подати цінову пропозицію на лоти  ${TENDER['TENDER_UAID']}  ${bid}  ${lots_ids}
  Set To Dictionary  ${USERS.users['${username}'].bidresponses}   resp=${resp}


Можливість змінити пропозицію до ${amount} першим учасником
  ${field}=  Set Variable If  '${mode}'=='without_lots'  value.amount   lotValues.0.value.amount
  ${fixbidto10resp}=  Викликати для учасника  ${provider}  Змінити цінову пропозицію  ${TENDER['TENDER_UAID']}  value.amount  10
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses}  fixbidto10resp=${fixbidto10resp}
  Log  ${fixbidto10resp}


Можливість завантажити документ в пропозицію
  [Arguments]  ${username}
  Log  ${USERS.users['${username}'].broker}
  ${filepath}=  create_fake_doc
  ${bid_doc_upload}=  Викликати для учасника  ${username}  Завантажити документ в ставку  ${filepath}  ${TENDER['TENDER_UAID']}
  Set To Dictionary  ${USERS.users['${username}'].bidresponses}  bid_doc_upload=${bid_doc_upload}


Можливість змінити документацію цінової пропозиції
  [Arguments]  ${username}
  ${filepath}=  create_fake_doc
  ${bidid}=  Get Variable Value  ${USERS.users['${username}'].bidresponses['resp'].data.id}
  ${docid}=  Get Variable Value  ${USERS.users['${username}'].bidresponses['bid_doc_upload']['upload_response'].data.id}
  ${bid_doc_modified}=  Викликати для учасника  ${username}  Змінити документ в ставці  ${filepath}  ${bidid}  ${docid}
  Set To Dictionary  ${USERS.users['${username}'].bidresponses}  bid_doc_modified=${bid_doc_modified}


Можливість скасувати цінову пропозицію
  [Arguments]  ${username}
  ${canceledbidresp}=  Run As   ${username}   Скасувати цінову пропозицію   ${TENDER['TENDER_UAID']}   ${USERS.users['${username}'].bidresponses['resp']}
  Log  ${canceledbidresp}
