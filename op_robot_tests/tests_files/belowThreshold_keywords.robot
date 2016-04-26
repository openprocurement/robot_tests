*** Settings ***
Library            op_robot_tests.tests_files.service_keywords
Library            Collections
Resource           keywords.robot
Resource           resource.robot


*** Keywords ***
Можливість оголосити тендер
  ${tender_data}=  Підготувати дані для створення тендера
  ${adapted_data}=  Адаптувати дані для оголошення тендера  ${tender_owner}  ${tender_data}
  ${TENDER_UAID}=  Run As  ${tender_owner}  Створити тендер  ${adapted_data}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  initial_data=${adapted_data}
  Set To Dictionary  ${TENDER}  TENDER_UAID=${TENDER_UAID}


Можливість знайти тендер по ідентифікатору для усіх учасників
  :FOR  ${username}  IN  ${tender_owner}  ${provider}  ${provider1}  ${viewer}
  \  Дочекатись синхронізації з майданчиком  ${username}
  \  Run As  ${username}  Пошук тендера по ідентифікатору  ${TENDER['TENDER_UAID']}


Можливість додати документацію до тендера
  ${filepath}=  create_fake_doc
  Run As  ${tender_owner}  Завантажити документ  ${filepath}  ${TENDER['TENDER_UAID']}


Можливість додати предмет закупівлі в тендер
  ${item}=  Підготувати дані для створення предмету закупівлі
  Run As   ${tender_owner}   Додати предмет закупівлі    ${TENDER['TENDER_UAID']}   ${item}
  ${item_id}=  get_id_from_object  ${item}
  ${item_data}=  Create Dictionary  item=${item}  item_id=${item_id}
  ${item_data}=  munch_dict  arg=${item_data}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  item_data=${item_data}


Можливість видалити предмет закупівлі з тендера
  Run As  ${tender_owner}  Видалити предмет закупівлі  ${TENDER['TENDER_UAID']}  ${USERS.users['${tender_owner}'].item_data.item_id}


Звірити відображення поля ${field} тендера для усіх користувачів
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}  ${provider}  ${provider1}
  \  Звірити відображення поля ${field} тендера для користувача ${username}

Звірити відображення поля ${field} тендера із ${data} для користувача ${username}
  Звірити поле тендера із значенням  ${username}  ${data}  ${field}

Звірити відображення поля ${field} тендера для користувача ${username}
  Звірити поле тендера  ${username}  ${USERS.users['${tender_owner}'].initial_data}  ${field}


Звірити відображення дати ${date} тендера для користувача ${username}
  Звірити дату тендера   ${username}  ${USERS.users['${tender_owner}'].initial_data}  ${date}


Звірити відображення поля ${field} ${item_index} предмету для користувача ${username}
  ${item_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].initial_data.data['items'][${item_index}]}
  Звірити поле тендера із значенням  ${username}  ${USERS.users['${tender_owner}'].initial_data.data['items'][${item_index}].${field}}  ${field}  ${item_id}


Звірити відображення дати ${date} ${item_index} предмету для користувача ${username}
  ${item_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].initial_data.data['items'][${item_index}]}
  Звірити дату тендера із значенням  ${username}  ${USERS.users['${tender_owner}'].initial_data.data['items'][${item_index}].${date}}  ${date}  ${item_id}

Звірити відображення координат ${item_index} предмету для користувача ${username}
  Звірити координати доставки тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  items[${item_index}]

##############################################################################################
#             LOTS
##############################################################################################

Можливість додати документацію до ${lot_index} лоту
  ${lot_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].tender_data.data.lots[${lot_index}]}
  ${filepath}=   create_fake_doc
  Run As   ${tender_owner}   Завантажити документ в лот  ${filepath}   ${TENDER['TENDER_UAID']}  ${lot_id}


Можливість додати предмет закупівлі в ${lot_index} лот
  ${lot_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].tender_data.data.lots[${lot_index}]}
  ${item}=  Підготувати дані для створення предмету закупівлі
  Run As   ${tender_owner}   Додати предмет закупівлі в лот    ${TENDER['TENDER_UAID']}  ${lot_id}   ${item}
  ${item_id}=  get_id_from_object  ${item}
  ${item_data}=  Create Dictionary  item=${item}  item_id=${item_id}
  ${item_data}=  munch_dict  arg=${item_data}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  item_data=${item_data}


Можливість видалити предмет закупівлі з ${lot_index} лоту
  ${lot_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].tender_data.data.lots[${lot_index}]}
  Run As  ${tender_owner}  Видалити предмет закупівлі  ${TENDER['TENDER_UAID']}  ${USERS.users['${tender_owner}'].item_data.item_id}  ${lot_id}


Можливість створення лоту
  ${lot}=  Підготувати дані для створення лоту
  ${lot_resp}=  Run As   ${tender_owner}  Створити лот  ${TENDER['TENDER_UAID']}  ${lot}
  ${lot_id}=  get_id_from_object  ${lot.data}
  ${lot_data}=  Create Dictionary  lot=${lot}  lot_resp=${lot_resp}  lot_id=${lot_id}
  ${lot_data}=  munch_dict  arg=${lot_data}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  lot_data=${lot_data}


Можливість видалення ${lot_index} лоту
  ${lot_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].tender_data.data.lots[${lot_index}]}
  Run As  ${tender_owner}  Видалити лот  ${TENDER['TENDER_UAID']}  ${lot_id}
  Remove From List   ${USERS.users['${tender_owner}'].tender_data.data.lots}  ${lot_index}


Звірити відображення поля ${field} ${lot_index} лоту для усіх користувачів
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}  ${provider}  ${provider1}
  \  Звірити відображення поля ${field} 0 лоту для користувача ${username}


Звірити відображення поля ${field} ${lot_index} новоствореного лоту для усіх користувачів
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}  ${provider}  ${provider1}
  \  Звірити відображення поля ${field} новоствореного лоту для користувача ${username}


Звірити відображення поля ${field} ${lot_index} лоту для користувача ${username}
  Дочекатись синхронізації з майданчиком    ${username}
  ${lot_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].initial_data.data.lots[${lot_index}]}
  Звірити поле тендера із значенням  ${username}
  ...      ${USERS.users['${tender_owner}'].initial_data.data.lots[${lot_index}].${field}}  ${field}
  ...      object_id=${lot_id}


Звірити відображення поля ${field} ${lot_index} новоствореного лоту для користувача ${username}
  Дочекатись синхронізації з майданчиком    ${username}
  Звірити поле тендера із значенням  ${username}
  ...      ${USERS.users['${tender_owner}'].lot_data.lot.data.${field}}  ${field}
  ...      object_id=${USERS.users['${tender_owner}'].lot_data.lot_id}


Можливість змінити ${field} ${lot_index} лоту до ${value}
  ${lot_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].tender_data.data.lots[${lot_index}]}
  Run As   ${tender_owner}  Змінити лот  ${TENDER['TENDER_UAID']}  ${lot_id}  ${field}   ${value}

##############################################################################################
#             QUESTIONS
##############################################################################################

Можливість задати запитання на тендер користувачем ${username}
  ${question}=  Підготувати дані для запитання
  ${question_resp}=  Run As  ${username}  Задати запитання на тендер  ${TENDER['TENDER_UAID']}  ${question}
  ${now}=  Get Current TZdate
  ${question.data.date}=  Set variable  ${now}
  ${question_id}=  get_id_from_object  ${question.data}
  ${question_data}=  Create Dictionary  question=${question}  question_resp=${question_resp}  question_id=${question_id}
  ${question_data}=  munch_dict  arg=${question_data}
  Set To Dictionary  ${USERS.users['${username}']}  question_data=${question_data}


Можливість задати запитання на ${lot_index} лот користувачем ${username}
  ${lot_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].tender_data.data.lots[${lot_index}]}
  ${question}=  Підготувати дані для запитання
  ${question_resp}=  Run As   ${username}   Задати запитання на лот  ${TENDER['TENDER_UAID']}  ${lot_id}  ${question}
  ${now}=  Get Current TZdate
  ${question.data.date}=  Set variable  ${now}
  ${question_id}=  get_id_from_object  ${question.data}
  ${question_data}=  Create Dictionary  question=${question}  question_resp=${question_resp}  question_id=${question_id}
  ${question_data}=  munch_dict  arg=${question_data}


Можливість задати запитання на ${item_index} предмет користувачем ${username}
  ${item_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].tender_data.data['items'][${item_index}]}
  ${question}=  Підготувати дані для запитання
  ${question_resp}=  Run As   ${username}   Задати запитання на предмет  ${TENDER['TENDER_UAID']}  ${item_id}  ${question}
  ${now}=  Get Current TZdate
  ${question.data.date}=  Set variable  ${now}
  ${question_id}=  get_id_from_object  ${question.data}
  ${question_data}=  Create Dictionary  question=${question}  question_resp=${question_resp}  question_id=${question_id}
  ${question_data}=  munch_dict  arg=${question_data}


Можливість відповісти на запитання
  ${answer}=  Підготувати дані для відповіді на запитання
  ${answer_resp}=  Run As  ${tender_owner}
  ...      Відповісти на запитання  ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['question_data']['question_resp']}  ${answer}
  ...      question_id=${USERS.users['${provider}'].question_data.question_id}
  ${now}=  Get Current TZdate
  ${answer.data.date}=  Set variable  ${now}
  ${answer_data}=  Create Dictionary  answer=${answer}  answer_resp=${answer_resp}
  Set To Dictionary  ${USERS.users['${provider}']}  answer_data=${answer_data}

##############################################################################################
#             BIDDING
##############################################################################################

Можливість подати цінову пропозицію на тендер користувачем ${username}
  ${bid}=  Підготувати дані для подання пропозиції
  ${bidresponses}=  Create Dictionary  bid=${bid}
  Set To Dictionary  ${USERS.users['${username}']}  bidresponses=${bidresponses}
  ${resp}=  Run As  ${username}  Подати цінову пропозицію  ${TENDER['TENDER_UAID']}  ${bid}
  Set To Dictionary  ${USERS.users['${username}'].bidresponses}  resp=${resp}


Можливість подати цінову пропозицію на лоти користувачем ${username}
  @{lots_ids}=  Отримати ідентифікатори об’єктів  ${username}  lots
  ${number_of_lots}=  Get Length  ${lots_ids}
  ${bid}=  Підготувати дані для подання пропозиції  ${number_of_lots}
  ${bidresponses}=  Create Dictionary  bid=${bid}
  Set To Dictionary  ${USERS.users['${username}']}   bidresponses=${bidresponses}
  ${resp}=  Run As  ${username}  Подати цінову пропозицію на лоти  ${TENDER['TENDER_UAID']}  ${bid}  ${lots_ids}
  Set To Dictionary  ${USERS.users['${username}'].bidresponses}   resp=${resp}


Можливість змінити пропозицію до ${amount} користувачем ${username}
  ${field}=  Set Variable If  '${mode}'=='without_lots'  value.amount   lotValues.0.value.amount
  ${fixbidto10resp}=  Run As  ${username}  Змінити цінову пропозицію  ${TENDER['TENDER_UAID']}  ${field}  10
  Set To Dictionary  ${USERS.users['${username}'].bidresponses}  fixbidto10resp=${fixbidto10resp}


Можливість завантажити документ в пропозицію користувачем ${username}
  ${filepath}=  create_fake_doc
  ${bid_doc_upload}=  Run As  ${username}  Завантажити документ в ставку  ${filepath}  ${TENDER['TENDER_UAID']}
  Set To Dictionary  ${USERS.users['${username}'].bidresponses}  bid_doc_upload=${bid_doc_upload}


Можливість змінити документацію цінової пропозиції користувачем ${username}
  ${filepath}=  create_fake_doc
  ${docid}=  Get Variable Value  ${USERS.users['${username}'].bidresponses['bid_doc_upload']['upload_response'].data.id}
  ${bid_doc_modified}=  Run As  ${username}  Змінити документ в ставці  ${filepath}  ${docid}
  Set To Dictionary  ${USERS.users['${username}'].bidresponses}  bid_doc_modified=${bid_doc_modified}


Можливість скасувати цінову пропозицію користувачем ${username}
  ${canceledbidresp}=  Run As   ${username}   Скасувати цінову пропозицію   ${TENDER['TENDER_UAID']}   ${USERS.users['${username}'].bidresponses['resp']}