*** Settings ***
Library            op_robot_tests.tests_files.service_keywords
Library            Collections
Resource           keywords.robot
Resource           resource.robot


*** Keywords ***
Можливість оголосити тендер
  ${number_of_lots}=  Convert To Integer  ${number_of_lots}
  ${number_of_items}=  Convert To Integer  ${number_of_items}
  ${tender_parameters}=  Create Dictionary
  ...      mode=${mode}
  ...      number_of_items=${number_of_items}
  ...      number_of_lots=${number_of_lots}
  ...      tender_meat=${${tender_meat}}
  ...      lot_meat=${${lot_meat}}
  ...      item_meat=${${item_meat}}
  ${tender_data}=  Підготувати дані для створення тендера  ${tender_parameters}
  ${adapted_data}=  Адаптувати дані для оголошення тендера  ${tender_owner}  ${tender_data}
  ${TENDER_UAID}=  Run As  ${tender_owner}  Створити тендер  ${adapted_data}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  initial_data=${adapted_data}
  Set To Dictionary  ${TENDER}  TENDER_UAID=${TENDER_UAID}


Можливість знайти тендер по ідентифікатору для усіх користувачів
  :FOR  ${username}  IN  ${tender_owner}  ${provider}  ${provider1}  ${viewer}
  \  Можливість знайти тендер по ідентифікатору для користувача ${username}


Можливість знайти тендер по ідентифікатору для користувача ${username}
  Дочекатись синхронізації з майданчиком  ${username}
  Run as  ${username}  Пошук тендера по ідентифікатору  ${TENDER['TENDER_UAID']}


Можливість змінити поле ${field_name} тендера на ${field_value}
  Run As  ${tender_owner}  Внести зміни в тендер  ${TENDER['TENDER_UAID']}  ${field_name}  ${field_value}


Можливість додати документацію до тендера
  ${filepath}=  create_fake_doc
  Run As  ${tender_owner}  Завантажити документ  ${filepath}  ${TENDER['TENDER_UAID']}
  ${documents}=  Create Dictionary  filepath=${filepath}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  documents=${documents}


Можливість додати предмет закупівлі в тендер
  ${item}=  Підготувати дані для створення предмету закупівлі  ${USERS.users['${tender_owner}'].initial_data.data['items'][0]['classification']['id']}
  Run As  ${tender_owner}  Додати предмет закупівлі  ${TENDER['TENDER_UAID']}  ${item}
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
  Звірити поле тендера із значенням  ${username}  ${TENDER['TENDER_UAID']}  ${data}  ${field}


Звірити відображення поля ${field} тендера для користувача ${username}
  Звірити поле тендера  ${username}  ${TENDER['TENDER_UAID']}  ${USERS.users['${tender_owner}'].initial_data}  ${field}


Звірити відображення дати ${date} тендера для усіх користувачів
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}  ${provider}  ${provider1}
  \  Звірити відображення дати ${date} тендера для користувача ${username}


Звірити відображення дати ${date} тендера для користувача ${username}
  Звірити дату тендера  ${username}  ${TENDER['TENDER_UAID']}  ${USERS.users['${tender_owner}'].initial_data}  ${date}


Звірити відображення поля ${field} у новоствореному предметі для усіх користувачів
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}  ${provider}  ${provider1}
  \  Звірити відображення поля ${field} у новоствореному предметі для користувача ${username}


Звірити відображення поля ${field} у новоствореному предметі для користувача ${username}
  Дочекатись синхронізації з майданчиком  ${username}
  Звірити поле тендера із значенням  ${username}  ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${tender_owner}'].item_data.item.${field}}  ${field}
  ...      object_id=${USERS.users['${tender_owner}'].item_data.item_id}


Звірити відображення поля ${field} усіх предметів для усіх користувачів
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}  ${provider}  ${provider1}
  \  Звірити відображення поля ${field} усіх предметів для користувача ${username}


Звірити відображення поля ${field} усіх предметів для користувача ${username}
  ${number_of_items}=  Get Length  ${USERS.users['${tender_owner}'].initial_data.data['items']}
  :FOR  ${item_index}  IN RANGE  ${number_of_items}
  \  Звірити відображення поля ${field} ${item_index} предмету для користувача ${username}


Звірити відображення поля ${field} ${item_index} предмету для користувача ${username}
  ${item_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].initial_data.data['items'][${item_index}]}
  Звірити поле тендера із значенням  ${username}  ${TENDER['TENDER_UAID']}  ${USERS.users['${tender_owner}'].initial_data.data['items'][${item_index}].${field}}  ${field}  ${item_id}


Звірити відображення дати ${field} усіх предметів для користувача ${username}
  ${number_of_items}=  Get Length  ${USERS.users['${tender_owner}'].initial_data.data['items']}
  :FOR  ${item_index}  IN RANGE  ${number_of_items}
  \  Звірити відображення дати ${field} ${item_index} предмету для користувача ${username}


Звірити відображення дати ${date} ${item_index} предмету для користувача ${username}
  ${item_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].initial_data.data['items'][${item_index}]}
  Звірити дату тендера із значенням  ${username}  ${TENDER['TENDER_UAID']}  ${USERS.users['${tender_owner}'].initial_data.data['items'][${item_index}].${date}}  ${date}  ${item_id}


Звірити відображення координат усіх предметів для користувача ${username}
  ${number_of_items}=  Get Length  ${USERS.users['${tender_owner}'].initial_data.data['items']}
  :FOR  ${item_index}  IN RANGE  ${number_of_items}
  \  Звірити відображення координат ${item_index} предмету для користувача ${username}


Звірити відображення координат ${item_index} предмету для користувача ${username}
  ${item_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].initial_data.data['items'][${item_index}]}
  Звірити координати доставки тендера  ${viewer}  ${TENDER['TENDER_UAID']}  ${USERS.users['${tender_owner}'].initial_data}  ${item_id}


Отримати дані із поля ${field} тендера для усіх користувачів
  :FOR  ${username}  IN  ${viewer}  ${provider}  ${provider1}  ${tender_owner}
  \  Отримати дані із поля ${field} тендера для користувача ${username}


Отримати дані із поля ${field} тендера для користувача ${username}
  Отримати дані із тендера  ${username}  ${TENDER['TENDER_UAID']}  ${field}

##############################################################################################
#             LOTS
##############################################################################################

Можливість додати документацію до ${lot_index} лоту
  ${lot_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].tender_data.data.lots[${lot_index}]}
  ${filepath}=  create_fake_doc
  Run As  ${tender_owner}  Завантажити документ в лот  ${filepath}  ${TENDER['TENDER_UAID']}  ${lot_id}


Можливість додати предмет закупівлі в ${lot_index} лот
  ${lot_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].tender_data.data.lots[${lot_index}]}
  ${item}=  Підготувати дані для створення предмету закупівлі  ${USERS.users['${tender_owner}'].initial_data.data['items'][0]['classification']['id']}
  Run As  ${tender_owner}  Додати предмет закупівлі в лот  ${TENDER['TENDER_UAID']}  ${lot_id}  ${item}
  ${item_id}=  get_id_from_object  ${item}
  ${item_data}=  Create Dictionary  item=${item}  item_id=${item_id}
  ${item_data}=  munch_dict  arg=${item_data}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  item_data=${item_data}


Можливість видалити предмет закупівлі з ${lot_index} лоту
  ${lot_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].tender_data.data.lots[${lot_index}]}
  Run As  ${tender_owner}  Видалити предмет закупівлі  ${TENDER['TENDER_UAID']}  ${USERS.users['${tender_owner}'].item_data.item_id}  ${lot_id}


Можливість створення лоту із прив’язаним предметом закупівлі
  ${lot}=  Підготувати дані для створення лоту  ${USERS.users['${tender_owner}'].tender_data.data.value.amount}
  ${item}=  Підготувати дані для створення предмету закупівлі  ${USERS.users['${tender_owner}'].initial_data.data['items'][0]['classification']['id']}
  ${lot_resp}=  Run As  ${tender_owner}  Створити лот із предметом закупівлі  ${TENDER['TENDER_UAID']}  ${lot}  ${item}
  ${item_id}=  get_id_from_object  ${item}
  ${item_data}=  Create Dictionary  item=${item}  item_id=${item_id}
  ${item_data}=  munch_dict  arg=${item_data}
  ${lot_id}=  get_id_from_object  ${lot.data}
  ${lot_data}=  Create Dictionary  lot=${lot}  lot_resp=${lot_resp}  lot_id=${lot_id}
  ${lot_data}=  munch_dict  arg=${lot_data}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  item_data=${item_data}  lot_data=${lot_data}


Можливість видалення ${lot_index} лоту
  ${lot_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].tender_data.data.lots[${lot_index}]}
  Run As  ${tender_owner}  Видалити лот  ${TENDER['TENDER_UAID']}  ${lot_id}
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}  ${provider}  ${provider1}
  \  Remove From List  ${USERS.users['${username}'].tender_data.data.lots}  ${lot_index}


Звірити відображення поля ${field} усіх лотів для усіх користувачів
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}  ${provider}  ${provider1}
  \  Звірити відображення поля ${field} усіх лотів для користувача ${username}


Звірити відображення поля ${field} усіх лотів для користувача ${username}
  ${number_of_lots}=  Get Length  ${USERS.users['${tender_owner}'].initial_data.data.lots}
  :FOR  ${lot_index}  IN RANGE  ${number_of_lots}
  \  Звірити відображення поля ${field} ${lot_index} лоту для користувача ${username}


Звірити відображення поля ${field} ${lot_index} лоту для користувача ${username}
  Дочекатись синхронізації з майданчиком  ${username}
  ${lot_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].initial_data.data.lots[${lot_index}]}
  Звірити поле тендера із значенням  ${username}  ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${tender_owner}'].initial_data.data.lots[${lot_index}].${field}}  ${field}
  ...      object_id=${lot_id}


Звірити відображення поля ${field} у новоствореному лоті для усіх користувачів
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}  ${provider}  ${provider1}
  \  Звірити відображення поля ${field} у новоствореному лоті для користувача ${username}


Звірити відображення поля ${field} у новоствореному лоті для користувача ${username}
  Дочекатись синхронізації з майданчиком  ${username}
  Звірити поле тендера із значенням  ${username}  ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${tender_owner}'].lot_data.lot.data.${field}}  ${field}
  ...      object_id=${USERS.users['${tender_owner}'].lot_data.lot_id}


Можливість змінити на ${percent} відсотки бюджет ${lot_index} лоту
  ${percent}=  Convert To Number  ${percent}
  ${value}=  Evaluate  ${USERS.users['${tender_owner}'].tender_data.data.lots[${lot_index}].value.amount}*${percent}/${100}
  Можливість змінити поле value.amount ${lot_index} лоту на ${value}


Можливість змінити поле ${field} ${lot_index} лоту на ${value}
  ${lot_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].tender_data.data.lots[${lot_index}]}
  Run As  ${tender_owner}  Змінити лот  ${TENDER['TENDER_UAID']}  ${lot_id}  ${field}  ${value}

##############################################################################################
#             FEATURES
##############################################################################################

Можливість добавити неціновий показник на тендер
  ${feature}=  Підготувати дані для створення нецінового показника
  Set To Dictionary  ${feature}  featureOf=tenderer
  Run As  ${tender_owner}  Додати неціновий показник на тендер  ${TENDER['TENDER_UAID']}  ${feature}
  ${feature_id}=  get_id_from_object  ${feature}
  ${feature_data}=  Create Dictionary  feature=${feature}  feature_id=${feature_id}
  ${feature_data}=  munch_dict  arg=${feature_data}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  feature_data=${feature_data}


Можливість добавити неціновий показник на ${lot_index} лот
  ${feature}=  Підготувати дані для створення нецінового показника
  Set To Dictionary  ${feature}  featureOf=lot
  ${lot_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].tender_data.data.lots[${lot_index}]}
  Run As  ${tender_owner}  Додати неціновий показник на лот  ${TENDER['TENDER_UAID']}  ${feature}  ${lot_id}
  ${feature_id}=  get_id_from_object  ${feature}
  ${feature_data}=  Create Dictionary  feature=${feature}  feature_id=${feature_id}
  ${feature_data}=  munch_dict  arg=${feature_data}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  feature_data=${feature_data}


Можливість добавити неціновий показник на ${item_index} предмет
  ${feature}=  Підготувати дані для створення нецінового показника
  Set To Dictionary  ${feature}  featureOf=item
  ${item_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].tender_data.data['items'][${item_index}]}
  Run As  ${tender_owner}  Додати неціновий показник на предмет  ${TENDER['TENDER_UAID']}  ${feature}  ${item_id}
  ${feature_id}=  get_id_from_object  ${feature}
  ${feature_data}=  Create Dictionary  feature=${feature}  feature_id=${feature_id}
  ${feature_data}=  munch_dict  arg=${feature_data}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  feature_data=${feature_data}


Звірити відображення поля ${field} у новоствореному неціновому показнику для усіх користувачів
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}  ${provider}  ${provider1}
  \  Звірити відображення поля ${field} у новоствореному неціновому показнику для користувача ${username}


Звірити відображення поля ${field} у новоствореному неціновому показнику для користувача ${username}
  Дочекатись синхронізації з майданчиком  ${username}
  Звірити поле тендера із значенням  ${username}  ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${tender_owner}'].feature_data.feature.${field}}  ${field}
  ...      object_id=${USERS.users['${tender_owner}'].feature_data.feature_id}


Звірити відображення поля ${field} усіх нецінових показників для усіх користувачів
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}  ${provider}  ${provider1}
  \  Звірити відображення поля ${field} усіх нецінових показників для користувача ${username}


Звірити відображення поля ${field} усіх нецінових показників для користувача ${username}
  ${number_of_features}=  Get Length  ${USERS.users['${tender_owner}'].initial_data.data.features}
  :FOR  ${feature_index}  IN RANGE  ${number_of_features}
  \  Звірити відображення поля ${field} ${feature_index} нецінового показника для користувача ${username}


Звірити відображення поля ${field} ${feature_index} нецінового показника для користувача ${username}
  Дочекатись синхронізації з майданчиком  ${username}
  ${feature_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].initial_data.data.features[${feature_index}]}
  Звірити поле тендера із значенням  ${username}  ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${tender_owner}'].initial_data.data.features[${feature_index}].${field}}  ${field}
  ...      object_id=${feature_id}


Можливість видалити ${feature_index} неціновий показник
  ${feature_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].tender_data.data['features'][${feature_index}]}
  Run As  ${tender_owner}  Видалити неціновий показник  ${TENDER['TENDER_UAID']}  ${feature_id}
  ${feature_index}=  get_object_index_by_id  ${USERS.users['${tender_owner}'].tender_data.data['features']}  ${feature_id}
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}  ${provider}  ${provider1}
  \  Remove From List  ${USERS.users['${username}'].tender_data.data['features']}  ${feature_index}

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
  ${question_resp}=  Run As  ${username}  Задати запитання на лот  ${TENDER['TENDER_UAID']}  ${lot_id}  ${question}
  ${now}=  Get Current TZdate
  ${question.data.date}=  Set variable  ${now}
  ${question_id}=  get_id_from_object  ${question.data}
  ${question_data}=  Create Dictionary  question=${question}  question_resp=${question_resp}  question_id=${question_id}
  ${question_data}=  munch_dict  arg=${question_data}
  Set To Dictionary  ${USERS.users['${username}']}  question_data=${question_data}


Можливість задати запитання на ${item_index} предмет користувачем ${username}
  ${item_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].tender_data.data['items'][${item_index}]}
  ${question}=  Підготувати дані для запитання
  ${question_resp}=  Run As  ${username}  Задати запитання на предмет  ${TENDER['TENDER_UAID']}  ${item_id}  ${question}
  ${now}=  Get Current TZdate
  ${question.data.date}=  Set variable  ${now}
  ${question_id}=  get_id_from_object  ${question.data}
  ${question_data}=  Create Dictionary  question=${question}  question_resp=${question_resp}  question_id=${question_id}
  ${question_data}=  munch_dict  arg=${question_data}
  Set To Dictionary  ${USERS.users['${username}']}  question_data=${question_data}


Можливість відповісти на запитання
  ${answer}=  Підготувати дані для відповіді на запитання
  Run As  ${tender_owner}
  ...      Відповісти на запитання  ${TENDER['TENDER_UAID']}
  ...      ${answer}
  ...      ${USERS.users['${provider}'].question_data.question_id}
  Set To Dictionary  ${USERS.users['${provider}'].question_data.question.data}  answer=${answer.data.answer}


Звірити відображення поля ${field} запитання для усіх користувачів
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}  ${provider}  ${provider1}
  \  Звірити відображення поля ${field} запитання для користувача ${username}


Звірити відображення поля ${field} запитання для користувача ${username}
  Звірити поле тендера із значенням  ${username}  ${TENDER['TENDER_UAID']}  ${USERS.users['${provider}'].question_data.question.data.${field}}  ${field}  ${USERS.users['${provider}'].question_data.question_id}

##############################################################################################
#             COMPLAINTS
##############################################################################################


Можливість створити чернетку вимоги про виправлення умов закупівлі
  ${claim}=  Підготувати дані для подання вимоги
  ${complaintID}=  Run As  ${provider}
  ...      Створити чернетку вимоги про виправлення умов закупівлі
  ...      ${TENDER['TENDER_UAID']}
  ...      ${claim}
  ${claim_data}=  Create Dictionary  claim=${claim}  complaintID=${complaintID}
  ${claim_data}=  munch_dict  arg=${claim_data}
  Set To Dictionary  ${USERS.users['${provider}']}  claim_data  ${claim_data}


Можливість створити чернетку вимоги про виправлення умов ${lot_index} лоту
  ${claim}=  Підготувати дані для подання вимоги
  ${complaintID}=  Run As  ${provider}
  ...      Створити чернетку вимоги про виправлення умов лоту
  ...      ${TENDER['TENDER_UAID']}
  ...      ${claim}
  ...      ${lot_index}
  ${claim_data}=  Create Dictionary  claim=${claim}  complaintID=${complaintID}
  ${claim_data}=  munch_dict  arg=${claim_data}
  Set To Dictionary  ${USERS.users['${provider}']}  claim_data  ${claim_data}


Можливість створити чернетку вимоги про виправлення визначення ${award_index} переможця
  ${claim}=  Підготувати дані для подання вимоги
  ${complaintID}=  Run As  ${provider}
  ...      Створити чернетку вимоги про виправлення визначення переможця
  ...      ${TENDER['TENDER_UAID']}
  ...      ${claim}
  ...      ${award_index}
  ${claim_data}=  Create Dictionary  claim=${claim}  complaintID=${complaintID}
  ${claim_data}=  munch_dict  arg=${claim_data}
  Set To Dictionary  ${USERS.users['${provider}']}  claim_data  ${claim_data}


Можливість створити вимогу про виправлення умов закупівлі із документацією
  ${claim}=  Підготувати дані для подання вимоги
  ${document}=  create_fake_doc
  ${complaintID}=  Run As  ${provider}
  ...      Створити вимогу про виправлення умов закупівлі
  ...      ${TENDER['TENDER_UAID']}
  ...      ${claim}
  ...      ${document}
  ${claim_data}=  Create Dictionary  claim=${claim}  complaintID=${complaintID}  document=${document}
  ${claim_data}=  munch_dict  arg=${claim_data}
  Set To Dictionary  ${USERS.users['${provider}']}  claim_data  ${claim_data}


Можливість створити вимогу про виправлення умов ${lot_index} лоту із документацією
  ${claim}=  Підготувати дані для подання вимоги
  ${document}=  create_fake_doc
  ${complaintID}=  Run As  ${provider}
  ...      Створити вимогу про виправлення умов лоту
  ...      ${TENDER['TENDER_UAID']}
  ...      ${claim}
  ...      ${lot_index}
  ...      ${document}
  ${claim_data}=  Create Dictionary  claim=${claim}  complaintID=${complaintID}  document=${document}
  ${claim_data}=  munch_dict  arg=${claim_data}
  Set To Dictionary  ${USERS.users['${provider}']}  claim_data  ${claim_data}


Можливість створити вимогу про виправлення визначення ${award_index} переможця із документацією
  ${claim}=  Підготувати дані для подання вимоги
  ${document}=  create_fake_doc
  ${complaintID}=  Run As  ${provider}
  ...      Створити вимогу про виправлення визначення переможця
  ...      ${TENDER['TENDER_UAID']}
  ...      ${claim}
  ...      ${award_index}
  ...      ${document}
  ${claim_data}=  Create Dictionary  claim=${claim}  complaintID=${complaintID}  document=${document}
  ${claim_data}=  munch_dict  arg=${claim_data}
  Set To Dictionary  ${USERS.users['${provider}']}  claim_data  ${claim_data}


Можливість скасувати вимогу про виправлення умов закупівлі
  ${cancellation_reason}=  create_fake_sentence
  ${data}=  Create Dictionary  status=cancelled  cancellationReason=${cancellation_reason}
  ${cancellation_data}=  Create Dictionary  data=${data}
  ${cancellation_data}=  munch_dict  arg=${cancellation_data}
  Run As  ${provider}
  ...      Скасувати вимогу про виправлення умов закупівлі
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['claim_data']['complaintID']}
  ...      ${cancellation_data}
  Set To Dictionary  ${USERS.users['${provider}'].claim_data}  cancellation  ${cancellation_data}


Можливість скасувати вимогу про виправлення умов лоту
  ${cancellation_reason}=  create_fake_sentence
  ${data}=  Create Dictionary  status=cancelled  cancellationReason=${cancellation_reason}
  ${cancellation_data}=  Create Dictionary  data=${data}
  ${cancellation_data}=  munch_dict  arg=${cancellation_data}
  Run As  ${provider}
  ...      Скасувати вимогу про виправлення умов лоту
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['claim_data']['complaintID']}
  ...      ${cancellation_data}
  Set To Dictionary  ${USERS.users['${provider}'].claim_data}  cancellation  ${cancellation_data}


Можливість скасувати вимогу про виправлення визначення ${award_index} переможця
  ${cancellation_reason}=  create_fake_sentence
  ${data}=  Create Dictionary  status=cancelled  cancellationReason=${cancellation_reason}
  ${cancellation_data}=  Create Dictionary  data=${data}
  ${cancellation_data}=  munch_dict  arg=${cancellation_data}
  Run As  ${provider}
  ...      Скасувати вимогу про виправлення визначення переможця
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['claim_data']['complaintID']}
  ...      ${cancellation_data}
  ...      ${award_index}
  Set To Dictionary  ${USERS.users['${provider}'].claim_data}  cancellation  ${cancellation_data}


Можливість перетворити вимогу про виправлення умов закупівлі в скаргу
  ${data}=  Create Dictionary  status=pending  satisfied=${False}
  ${escalation_data}=  Create Dictionary  data=${data}
  ${escalation_data}=  munch_dict  arg=${escalation_data}
  Run As  ${provider}
  ...      Перетворити вимогу про виправлення умов закупівлі в скаргу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['claim_data']['complaintID']}
  ...      ${escalation_data}
  Set To Dictionary  ${USERS.users['${provider}'].claim_data}  escalation  ${escalation_data}


Можливість перетворити вимогу про виправлення умов лоту в скаргу
  ${data}=  Create Dictionary  status=pending  satisfied=${False}
  ${escalation_data}=  Create Dictionary  data=${data}
  ${escalation_data}=  munch_dict  arg=${escalation_data}
  Run As  ${provider}
  ...      Перетворити вимогу про виправлення умов лоту в скаргу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['claim_data']['complaintID']}
  ...      ${escalation_data}
  Set To Dictionary  ${USERS.users['${provider}'].claim_data}  escalation  ${escalation_data}


Можливість перетворити вимогу про виправлення визначення ${award_index} переможця в скаргу
  ${data}=  Create Dictionary  status=pending  satisfied=${False}
  ${escalation_data}=  Create Dictionary  data=${data}
  ${escalation_data}=  munch_dict  arg=${escalation_data}
  Run As  ${provider}
  ...      Перетворити вимогу про виправлення визначення переможця в скаргу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['claim_data']['complaintID']}
  ...      ${escalation_data}
  ...      ${award_index}
  Set To Dictionary  ${USERS.users['${provider}'].claim_data}  escalation  ${escalation_data}


Звірити відображення поля ${field} вимоги із ${data} для користувача ${username}
  Звірити поле скарги із значенням  ${username}
  ...      ${data}
  ...      ${field}
  ...      ${USERS.users['${provider}'].claim_data['complaintID']}


Звірити відображення поля ${field} вимоги про виправлення визначення ${award_index} переможця із ${data} для користувача ${username}
  Звірити поле скарги про виправлення визначення переможця із значенням  ${username}
  ...      ${data}
  ...      ${field}
  ...      ${award_index}
  ...      ${USERS.users['${provider}'].claim_data['complaintID']}


Можливість відповісти на вимогу про виправлення умов закупівлі
  ${answer_data}=  test_claim_answer_data
  Log  ${answer_data}
  Run As  ${tender_owner}
  ...      Відповісти на вимогу про виправлення умов закупівлі
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['claim_data']['complaintID']}
  ...      ${answer_data}
  ${claim_data}=  Create Dictionary  claim_answer=${answer_data}
  ${claim_data}=  munch_dict  arg=${claim_data}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  claim_data  ${claim_data}


Можливість відповісти на вимогу про виправлення умов лоту
  ${answer_data}=  test_claim_answer_data
  Log  ${answer_data}
  Run As  ${tender_owner}
  ...      Відповісти на вимогу про виправлення умов лоту
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['claim_data']['complaintID']}
  ...      ${answer_data}
  ${claim_data}=  Create Dictionary  claim_answer=${answer_data}
  ${claim_data}=  munch_dict  arg=${claim_data}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  claim_data  ${claim_data}


Можливість відповісти на вимогу про виправлення визначення ${award_index} переможця
  ${answer_data}=  test_claim_answer_data
  Log  ${answer_data}
  Run As  ${tender_owner}
  ...      Відповісти на вимогу про виправлення визначення переможця
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['claim_data']['complaintID']}
  ...      ${answer_data}
  ...      ${award_index}
  ${claim_data}=  Create Dictionary  claim_answer=${answer_data}
  ${claim_data}=  munch_dict  arg=${claim_data}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  claim_data  ${claim_data}


Можливість підтвердити задоволення вимоги про виправлення умов закупівлі
  ${data}=  Create Dictionary  status=resolved  satisfied=${True}
  ${confirmation_data}=  Create Dictionary  data=${data}
  ${confirmation_data}=  munch_dict  arg=${confirmation_data}
  Run As  ${provider}
  ...      Підтвердити вирішення вимоги про виправлення умов закупівлі
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['claim_data']['complaintID']}
  ...      ${confirmation_data}
  Set To Dictionary  ${USERS.users['${provider}']['claim_data']}  claim_answer_confirm  ${confirmation_data}


Можливість підтвердити задоволення вимоги про виправлення умов лоту
  ${data}=  Create Dictionary  status=resolved  satisfied=${True}
  ${confirmation_data}=  Create Dictionary  data=${data}
  ${confirmation_data}=  munch_dict  arg=${confirmation_data}
  Run As  ${provider}
  ...      Підтвердити вирішення вимоги про виправлення умов лоту
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['claim_data']['complaintID']}
  ...      ${confirmation_data}
  Set To Dictionary  ${USERS.users['${provider}']['claim_data']}  claim_answer_confirm  ${confirmation_data}


Можливість підтвердити задоволення вимоги про виправлення визначення ${award_index} переможця
  ${data}=  Create Dictionary  status=resolved  satisfied=${True}
  ${confirmation_data}=  Create Dictionary  data=${data}
  ${confirmation_data}=  munch_dict  arg=${confirmation_data}
  Run As  ${provider}
  ...      Підтвердити вирішення вимоги про виправлення визначення переможця
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['claim_data']['complaintID']}
  ...      ${confirmation_data}
  ...      ${award_index}
  Set To Dictionary  ${USERS.users['${provider}']['claim_data']}  claim_answer_confirm  ${confirmation_data}

##############################################################################################
#             BIDDING
##############################################################################################

Можливість подати цінову пропозицію користувачем ${username}
  ${bid}=  Підготувати дані для подання пропозиції  ${username}
  ${bidresponses}=  Create Dictionary  bid=${bid}
  Set To Dictionary  ${USERS.users['${username}']}  bidresponses=${bidresponses}
  ${resp}=  Run As  ${username}  Подати цінову пропозицію  ${TENDER['TENDER_UAID']}  ${bid}
  Set To Dictionary  ${USERS.users['${username}'].bidresponses}  resp=${resp}


Неможливість подати цінову пропозицію без прив’язки до лоту користувачем ${username}
  ${bid}=  Підготувати дані для подання пропозиції  ${username}
  ${values}=  Get Variable Value  ${bid.data.lotValues[0]}
  Remove From Dictionary  ${bid.data}  lotValues
  Set_To_Object  ${bid}  data  ${values}
  Require Failure  ${username}  Подати цінову пропозицію  ${TENDER['TENDER_UAID']}  ${bid}


Неможливість подати цінову пропозицію без нецінових показників користувачем ${username}
  ${bid}=  Підготувати дані для подання пропозиції  ${username}
  Remove From Dictionary  ${bid.data}  parameters
  Require Failure  ${username}  Подати цінову пропозицію  ${TENDER['TENDER_UAID']}  ${bid}


Можливість змінити пропозицію до ${amount} користувачем ${username}
  ${field}=  Set Variable If  ${number_of_lots} == 0  value.amount  lotValues[0].value.amount
  ${fixbidto10resp}=  Run As  ${username}  Змінити цінову пропозицію  ${TENDER['TENDER_UAID']}  ${field}  ${amount}


Можливість завантажити документ в пропозицію користувачем ${username}
  ${filepath}=  create_fake_doc
  ${bid_doc_upload}=  Run As  ${username}  Завантажити документ в ставку  ${filepath}  ${TENDER['TENDER_UAID']}
  Set To Dictionary  ${USERS.users['${username}'].bidresponses}  bid_doc_upload=${bid_doc_upload}


Можливість змінити документацію цінової пропозиції користувачем ${username}
  ${filepath}=  create_fake_doc
  ${docid}=  Get Variable Value  ${USERS.users['${username}'].bidresponses['bid_doc_upload']['upload_response'].data.id}
  ${bid_doc_modified}=  Run As  ${username}  Змінити документ в ставці  ${filepath}  ${docid}
  Set To Dictionary  ${USERS.users['${username}'].bidresponses}  bid_doc_modified=${bid_doc_modified}

##############################################################################################
#             Cancellations
##############################################################################################

Можливість скасувати цінову пропозицію користувачем ${username}
  ${canceledbidresp}=  Run As  ${username}  Скасувати цінову пропозицію  ${TENDER['TENDER_UAID']}


Можливість скасувати закупівлю
  ${cancellation_data}=  Підготувати дані про скасування  ${tender_owner}
  Run as  ${tender_owner}
  ...      Скасувати закупівлю
  ...      ${TENDER['TENDER_UAID']}
  ...      ${cancellation_data['cancellation_reason']}
  ...      ${cancellation_data['document']}
  ...      ${cancellation_data['description']}

##############################################################################################
#             Awarding
##############################################################################################

Можливість зареєструвати, додати документацію і підтвердити постачальника до закупівлі
  ${supplier_data}=  Підготувати дані про постачальника  ${tender_owner}
  ${filepath}=  create_fake_doc
  Run as  ${tender_owner}
  ...      Створити постачальника, додати документацію і підтвердити його
  ...      ${TENDER['TENDER_UAID']}
  ...      ${supplier_data}
  ...      ${filepath}
  Set to dictionary  ${USERS.users['${tender_owner}']}  award_document=${filepath}


Можливість укласти угоду для закупівлі
  Run as  ${tender_owner}
  ...      Підтвердити підписання контракту
  ...      ${TENDER['TENDER_UAID']}
  ...      ${0}
