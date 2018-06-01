*** Settings ***
Library            op_robot_tests.tests_files.service_keywords
Library            Collections
Resource           keywords.robot
Resource           resource.robot


*** Keywords ***
Можливість оголосити тендер
  ${tender_parameters}=  Create Dictionary
  ...      mode=${MODE}
  ...      api_host_url=${API_HOST_URL}
  ...      number_of_items=${NUMBER_OF_ITEMS}
  ${tender_data}=  Підготувати дані для створення тендера  ${tender_parameters}
  ${adapted_data}=  Адаптувати дані для оголошення тендера  ${tender_data}
  ${TENDER_UAID}=  Run Keyword If  '${MODE}' == 'assets'  Run As  ${tender_owner}  Створити об'єкт МП  ${adapted_data}
  ...  ELSE IF  '${MODE}' == 'lots'  Run As  ${tender_owner}  Створити лот  ${adapted_data}  ${ASSET_UAID}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  initial_data=${adapted_data}
  Set To Dictionary  ${TENDER}  TENDER_UAID=${TENDER_UAID}


Можливість знайти тендер по ідентифікатору для усіх користувачів
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \  Можливість знайти тендер по ідентифікатору для користувача ${username}


Можливість знайти тендер по ідентифікатору для користувача ${username}
  Дочекатись синхронізації з майданчиком  ${username}
  Run Keyword If  '${MODE}' == 'assets'  Run as  ${username}  Пошук об’єкта МП по ідентифікатору  ${TENDER['TENDER_UAID']}
  ...  ELSE IF  '${MODE}' == 'lots'  Run as  ${username}  Пошук лоту по ідентифікатору  ${TENDER['TENDER_UAID']}


Можливість додати документацію до тендера
  ${file_path}  ${file_name}  ${file_content}=  create_fake_doc
  Run As  ${tender_owner}  Завантажити документ  ${file_path}  ${TENDER['TENDER_UAID']}
  ${doc_id}=  get_id_from_doc_name  ${file_name}
  ${tender_document}=  Create Dictionary  doc_name=${file_name}  doc_id=${doc_id}  doc_content=${file_content}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  tender_document=${tender_document}
  Remove File  ${file_path}


Можливість додати ілюстрацію до тендера
  ${image_path}=  create_fake_image
  Run As  ${tender_owner}  Завантажити ілюстрацію  ${TENDER['TENDER_UAID']}  ${image_path}


Можливість додати ілюстрацію до об’єкта МП
  ${image_path}=  create_fake_image
  Run As  ${tender_owner}  Завантажити ілюстрацію в об'єкт МП  ${TENDER['TENDER_UAID']}  ${image_path}


Можливість додати ілюстрацію до лоту
  ${image_path}=  create_fake_image
  Run As  ${tender_owner}  Завантажити ілюстрацію в лот  ${TENDER['TENDER_UAID']}  ${image_path}


Можливість додати публічний паспорт активу до тендера
  ${certificate_url}=  create_fake_url
  Run As  ${tender_owner}  Додати публічний паспорт активу  ${TENDER['TENDER_UAID']}  ${certificate_url}


Можливість додати офлайн документ
  ${accessDetails}=  create_fake_sentence
  Run As  ${tender_owner}  Додати офлайн документ  ${TENDER['TENDER_UAID']}  ${accessDetails}


Можливість завантажити документ до тендера з типом ${doc_type}
  ${file_path}  ${file_name}  ${file_content}=  create_fake_doc
  Run Keyword If  '${MODE}' == 'assets'  Run As  ${tender_owner}  Завантажити документ в об'єкт МП з типом  ${TENDER['TENDER_UAID']}  ${file_path}  ${doc_type}
  ...  ELSE IF  '${MODE}' == 'lots'  Run As  ${tender_owner}  Завантажити документ в лот з типом  ${TENDER['TENDER_UAID']}  ${file_path}  ${doc_type}
  ${doc_id}=  get_id_from_doc_name  ${file_name}
  ${tender_document}=  Create Dictionary  doc_name=${file_name}  doc_id=${doc_id}  doc_content=${file_content}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  tender_document=${tender_document}
  Remove File  ${file_path}


Можливість завантажити документ з типом ${doc_type} до ${auction_index} аукціону
  ${file_path}  ${file_name}  ${file_content}=  create_fake_doc
  Run As  ${tender_owner}  Завантажити документ в умови проведення аукціону  ${TENDER['TENDER_UAID']}  ${file_path}  ${doc_type}  ${auction_index}
  ${doc_id}=  get_id_from_doc_name  ${file_name}
  ${auction_document}=  Create Dictionary  doc_name=${file_name}  doc_id=${doc_id}  doc_content=${file_content}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  auction_document=${auction_document}
  Remove File  ${file_path}


Можливість додати предмет закупівлі в тендер
  ${len_of_items_before_patch}=  Run As  ${tender_owner}  Отримати кількість активів в об'єкті МП  ${TENDER['TENDER_UAID']}
  ${item}=  Підготувати дані для створення предмету закупівлі  ${USERS.users['${tender_owner}'].initial_data.data['items'][0]['classification']['id']}
  Run Keyword If  '${MODE}' == 'assets'  Run As  ${tender_owner}  Додати актив до об'єкта МП  ${TENDER['TENDER_UAID']}  ${item}
  ${item_id}=  get_id_from_object  ${item}
  ${item_data}=  Create Dictionary  item=${item}  item_id=${item_id}
  ${item_data}=  munch_dict  arg=${item_data}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  item_data=${item_data}
  ${len_of_items_after_patch}=  Run As  ${tender_owner}  Отримати кількість активів в об'єкті МП  ${TENDER['TENDER_UAID']}
  Run Keyword And Expect Error  *  Порівняти об'єкти  ${len_of_items_before_patch}  ${len_of_items_after_patch}


Можливість видалити предмет закупівлі з тендера
  Run As  ${tender_owner}  Видалити предмет закупівлі  ${TENDER['TENDER_UAID']}  ${USERS.users['${tender_owner}'].item_data.item_id}


Неможливість додати предмет закупівлі в тендер
  ${len_of_items_before_patch}=  Run As  ${tender_owner}  Отримати кількість предметів в тендері  ${TENDER['TENDER_UAID']}
  ${item}=  Підготувати дані для створення предмету закупівлі  ${USERS.users['${tender_owner}'].initial_data.data['items'][0]['classification']['id']}
  Require Failure  ${tender_owner}  Додати предмет закупівлі  ${TENDER['TENDER_UAID']}  ${item}
  ${len_of_items_after_patch}=  Run As  ${tender_owner}  Отримати кількість предметів в тендері  ${TENDER['TENDER_UAID']}
  Порівняти об'єкти  ${len_of_items_before_patch}  ${len_of_items_after_patch}


Неможливість видалити предмет закупівлі з тендера
  ${len_of_items_before_patch}=  Run As  ${tender_owner}  Отримати кількість предметів в тендері  ${TENDER['TENDER_UAID']}
  ${item_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].tender_data.data['items'][-1]}
  Require Failure  ${tender_owner}  Видалити предмет закупівлі  ${TENDER['TENDER_UAID']}  ${item_id}
  ${len_of_items_after_patch}=  Run As  ${tender_owner}  Отримати кількість предметів в тендері  ${TENDER['TENDER_UAID']}
  Порівняти об'єкти  ${len_of_items_before_patch}  ${len_of_items_after_patch}


Неможливість додати документацію до лоту
  ${len_of_documents_before_patch}=  Run As  ${tender_owner}  Отримати кількість документів в тендері  ${TENDER['TENDER_UAID']}
  ${file_path}  ${file_name}  ${file_content}=  create_fake_doc
  Require Failure  ${tender_owner}  Завантажити документ  ${file_path}  ${TENDER['TENDER_UAID']}
  ${len_of_documents_after_patch}=  Run As  ${tender_owner}  Отримати кількість документів в тендері  ${TENDER['TENDER_UAID']}
  Порівняти об'єкти  ${len_of_documents_before_patch}  ${len_of_documents_after_patch}
  Remove File  ${file_path}


Неможливість редагувати документ
  [Arguments]  ${username}  ${tender_uaid}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${tender}=  set_access_key  ${tender}  ${USERS.users['${username}'].access_token}
  ${document}=  get_document_by_id  ${tender.data}  ${USERS.users['${tender_owner}'].tender_document.doc_id}
  ${patch_data}=  Create Dictionary  data=${document}
  Set To Dictionary  ${patch_data.data}  documentType=illustration
  Run keyword and expect error  *  Call Method  ${USERS.users['${username}'].client}  patch_document  ${tender}  ${patch_data}


Звірити відображення поля ${field} документа ${doc_id} із ${left} для користувача ${username}
  ${right}=  Run As  ${username}  Отримати інформацію із документа  ${TENDER['TENDER_UAID']}  ${doc_id}  ${field}
  Порівняти об'єкти  ${left}  ${right}


Звірити відображення поля ${field} тендера для усіх користувачів
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \  Звірити відображення поля ${field} тендера для користувача ${username}


Звірити відображення поля ${field} тендера із ${data} для усіх користувачів
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \  Дочекатись синхронізації з майданчиком  ${username}
  \  Звірити відображення поля ${field} тендера із ${data} для користувача ${username}


Звірити відображення поля ${field} тендера із ${data} для користувача ${username}
  Звірити поле тендера із значенням  ${username}  ${TENDER['TENDER_UAID']}  ${data}  ${field}


Звірити відображення поля ${field} тендера для користувача ${username}
  Звірити поле тендера  ${username}  ${TENDER['TENDER_UAID']}  ${USERS.users['${tender_owner}'].initial_data}  ${field}


Звірити відображення вмісту документа ${doc_id} із ${left} для користувача ${username}
  ${file_name}=  Run as  ${username}  Отримати документ  ${TENDER['TENDER_UAID']}  ${doc_id}
  ${right}=  Get File  ${OUTPUT_DIR}${/}${file_name}
  Порівняти об'єкти  ${left}  ${right}


Звірити відображення дати ${date} тендера для усіх користувачів
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \  Звірити відображення дати ${date} тендера для користувача ${username}


Звірити відображення дати ${date} тендера із ${left} для усіх користувачів
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \   Звірити дату тендера із значенням  ${username}  ${TENDER['TENDER_UAID']}  ${left}  ${date}  accuracy=60  absolute_delta=${False}


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


Звірити відображення зміненого поля ${field} предмета із ${data} для усіх користувачів
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \  Дочекатись синхронізації з майданчиком  ${username}
  \  Звірити відображення поля ${field} зміненого предмета із ${data} для користувача ${username}


Звірити відображення зміненого поля ${field} активу лоту із ${data} для усіх користувачів
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \  Дочекатись синхронізації з майданчиком  ${username}
  \  Звірити відображення поля ${field} зміненого активу лоту із ${data} для користувача ${username}


Звірити відображення поля ${field} усіх предметів для усіх користувачів
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \  Звірити відображення поля ${field} усіх предметів для користувача ${username}


Звірити відображення поля ${field} усіх предметів для користувача ${username}
  :FOR  ${item_index}  IN RANGE  ${NUMBER_OF_ITEMS}
  \  Звірити відображення поля ${field} ${item_index} предмету для користувача ${username}


Звірити відображення поля ${field} усіх новостворених предметів для користувача ${username}
  :FOR  ${item_index}  IN RANGE  ${NUMBER_OF_ITEMS}
  \  Звірити відображення поля ${field} у новоствореному предметі для користувача ${username}


Додати предмети закупівлі в тендер
  :FOR  ${item_index}  IN RANGE  ${NUMBER_OF_ITEMS}
  \  Можливість додати предмет закупівлі в тендер


Можливість змінити поле ${field_name} предмета на ${field_value}
  ${item_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].tender_data.data['items'][0]}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  item_id=${item_id}
  Run Keyword If  '${MODE}' == 'assets'  Run As  ${tender_owner}  Внести зміни в актив об'єкта МП  ${item_id}  ${TENDER['TENDER_UAID']}  ${field_name}  ${field_value}
  ...  ELSE IF  '${MODE}' == 'lots'  Run As  ${tender_owner}  Внести зміни в актив лоту  ${item_id}  ${TENDER['TENDER_UAID']}  ${field_name}  ${field_value}


Звірити відображення поля ${field} ${item_index} предмету для користувача ${username}
  ${item_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].initial_data.data['items'][${item_index}]}
  Звірити поле тендера із значенням  ${username}  ${TENDER['TENDER_UAID']}  ${USERS.users['${tender_owner}'].initial_data.data['items'][${item_index}].${field}}  ${field}  ${item_id}


Звірити відображення поля ${field} зміненого предмета із ${data} для користувача ${username}
  ${item_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].initial_data.data['items'][0]}
  Звірити поле тендера із значенням  ${username}  ${TENDER['TENDER_UAID']}  ${data}  ${field}  ${item_id}


Звірити відображення поля ${field} зміненого активу лоту із ${data} для користувача ${username}
  ${item_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].tender_data.data['items'][0]}
  Звірити поле тендера із значенням  ${username}  ${TENDER['TENDER_UAID']}  ${data}  ${field}  ${item_id}


Звірити відображення дати ${field} усіх предметів для користувача ${username}
  :FOR  ${item_index}  IN RANGE  ${NUMBER_OF_ITEMS}
  \  Звірити відображення дати ${field} ${item_index} предмету для користувача ${username}


Звірити відображення дати ${date} ${item_index} предмету для користувача ${username}
  ${item_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].initial_data.data['items'][${item_index}]}
  Звірити дату тендера із значенням  ${username}  ${TENDER['TENDER_UAID']}  ${USERS.users['${tender_owner}'].initial_data.data['items'][${item_index}].${date}}  ${date}  ${item_id}


Звірити відображення координат усіх предметів для користувача ${username}
  :FOR  ${item_index}  IN RANGE  ${NUMBER_OF_ITEMS}
  \  Звірити відображення координат ${item_index} предмету для користувача ${username}


Звірити відображення координат ${item_index} предмету для користувача ${username}
  ${item_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].initial_data.data['items'][${item_index}]}
  Звірити координати доставки тендера  ${viewer}  ${TENDER['TENDER_UAID']}  ${USERS.users['${tender_owner}'].initial_data}  ${item_id}


Отримати дані із поля ${field} усіх аукціонів для усіх користувачів
  :FOR  ${index}  IN RANGE  0  3
  \  Отримати дані із поля auctions[${index}].${field} тендера для усіх користувачів


Отримати дані із поля ${field} тендера для усіх користувачів
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \  ${field_value}=  Отримати дані із поля ${field} тендера для користувача ${username}
  \  Set To Dictionary  ${USERS.users['${username}']}  field=${field_value}
  Порівняти об'єкти  ${USERS.users['${tender_owner}'].field}  ${USERS.users['${viewer}'].field}


Отримати дані із поля ${field} лоту для усіх користувачів
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \  ${field_value}=  Отримати дані із поля ${field} тендера для користувача ${username}


Отримати дані із дати ${field} тендера для усіх користувачів
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \  ${field_value}=  Отримати дані із поля ${field} тендера для користувача ${username}
  \  Set To Dictionary  ${USERS.users['${username}']}  field=${field_value}
  Порівняти дати  ${USERS.users['${tender_owner}'].field}  ${USERS.users['${viewer}'].field}  accuracy=60  absolute_delta=${False}


Отримати дані із поля ${field} предмета для усіх користувачів
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \  ${field_value}=  Отримати дані із поля ${field} предмета для користувача ${username}
  \  Set To Dictionary  ${USERS.users['${username}']}  field_item=${field_value}
  Порівняти об'єкти  ${USERS.users['${tender_owner}'].field_item}  ${USERS.users['${viewer}'].field_item}


Отримати дані із поля ${field} тендера для користувача ${username}
  ${field_value}=  Отримати дані із тендера  ${username}  ${TENDER['TENDER_UAID']}  ${field}
  [return]  ${field_value}


Отримати дані із поля ${field} предмета для користувача ${username}
  ${field_value}=  Отримати дані із тендера  ${username}  ${TENDER['TENDER_UAID']}  ${field}  ${USERS.users['${tender_owner}'].item_id}
  [return]  ${field_value}


Перевірити, чи тривалість між ${rectificationPeriod_endDate} і ${tenderPeriod_endDate} становить не менше ${days} днів
  ${period_intervals}=  compute_intrs  ${BROKERS}  ${used_brokers}
  ${seconds}=  convert_days_to_seconds  ${days}  ${period_intervals.${MODE}.accelerator}
  ${status}=  compare_periods_duration  ${rectificationPeriod_endDate}  ${tenderPeriod_endDate}  ${seconds}
  Should Be True  ${status}  msg=Період редагування лоту завершується менш ніж за 5 днів до закінчення періоду подачі пропозицій

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
  Set To Dictionary  ${USERS.users['${username}']}  tender_question_data=${question_data}


Можливість задати запитання на ${item_index} предмет користувачем ${username}
  ${item_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].tender_data.data['items'][${item_index}]}
  ${question}=  Підготувати дані для запитання
  ${question_resp}=  Run As  ${username}  Задати запитання на предмет  ${TENDER['TENDER_UAID']}  ${item_id}  ${question}
  ${now}=  Get Current TZdate
  ${question.data.date}=  Set variable  ${now}
  ${question_id}=  get_id_from_object  ${question.data}
  ${question_data}=  Create Dictionary  question=${question}  question_resp=${question_resp}  question_id=${question_id}
  ${question_data}=  munch_dict  arg=${question_data}
  Set To Dictionary  ${USERS.users['${username}']}  items_${item_index}_question_data=${question_data}


Можливість відповісти на запитання на тендер
  ${answer}=  Підготувати дані для відповіді на запитання
  Run As  ${tender_owner}
  ...      Відповісти на запитання  ${TENDER['TENDER_UAID']}
  ...      ${answer}
  ...      ${USERS.users['${provider}'].tender_question_data.question_id}
  Set To Dictionary  ${USERS.users['${provider}'].tender_question_data.question.data}  answer=${answer.data.answer}


Можливість відповісти на запитання на ${item_index} предмет
  ${answer}=  Підготувати дані для відповіді на запитання
  Run As  ${tender_owner}
  ...      Відповісти на запитання  ${TENDER['TENDER_UAID']}
  ...      ${answer}
  ...      ${USERS.users['${provider}'].items_${item_index}_question_data.question_id}
  Set To Dictionary  ${USERS.users['${provider}'].items_${item_index}_question_data.question.data}  answer=${answer.data.answer}


Звірити відображення поля ${field} запитання на тендер для усіх користувачів
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}  ${provider}  ${provider1}
  \  Дочекатись синхронізації з майданчиком  ${username}
  \  Звірити відображення поля ${field} запитання на тендер для користувача ${username}


Звірити відображення поля ${field} запитання на тендер для користувача ${username}
  Звірити поле тендера із значенням  ${username}  ${TENDER['TENDER_UAID']}  ${USERS.users['${provider}'].tender_question_data.question.data.${field}}  ${field}  ${USERS.users['${provider}'].tender_question_data.question_id}


Звірити відображення поля ${field} запитання на ${item_index} предмет для усіх користувачів
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}  ${provider}  ${provider1}
  \  Дочекатись синхронізації з майданчиком  ${username}
  \  Звірити відображення поля ${field} запитання на ${item_index} предмет для користувача ${username}


Звірити відображення поля ${field} запитання на ${item_index} предмет для користувача ${username}
  Звірити поле тендера із значенням  ${username}  ${TENDER['TENDER_UAID']}  ${USERS.users['${provider}'].items_${item_index}_question_data.question.data.${field}}  ${field}  ${USERS.users['${provider}'].items_${item_index}_question_data.question_id}

##############################################################################################
#             BIDDING
##############################################################################################

Можливість подати цінову пропозицію користувачем ${username}
  ${bid}=  Підготувати дані для подання пропозиції  ${username}
  ${bidresponses}=  Create Dictionary  bid=${bid}
  Set To Dictionary  ${USERS.users['${username}']}  bidresponses=${bidresponses}
  ${features}=  Get Variable Value  ${USERS.users['${username}'].tender_data.data.features}  ${None}
  ${features_ids}=  Run Keyword IF  ${features}
  ...     Отримати ідентифікатори об’єктів  ${username}  features
  ...     ELSE  Set Variable  ${None}
  ${resp}=  Run As  ${username}  Подати цінову пропозицію  ${TENDER['TENDER_UAID']}  ${bid}
  Set To Dictionary  ${USERS.users['${username}'].bidresponses}  resp=${resp}


Неможливість подати цінову попрозицію без кваліфікації користувачем ${username}
  ${bid}=  Підготувати дані для подання пропозиції  ${username}
  ${bid['data'].qualified} =  Set Variable  ${False}
  Require Failure  ${username}  Подати цінову пропозицію  ${TENDER['TENDER_UAID']}  ${bid}


Можливість збільшити пропозицію до ${percent} відсотків користувачем ${username}
  ${percent}=  Convert To Number  ${percent}
  ${divider}=  Convert To Number  0.01
  ${field}=  Set Variable  value.amount
  ${value}=  Run As  ${username}  Отримати інформацію із пропозиції  ${TENDER['TENDER_UAID']}  ${field}
  ${value}=  mult_and_round  ${value}  ${percent}  ${divider}  precision=${2}
  Run as  ${username}  Змінити цінову пропозицію  ${TENDER['TENDER_UAID']}  ${field}  ${value}


Можливість зменшити пропозицію до невалідної користувачем ${username}
  ${starting_price}=  Отримати дані із тендера  ${username}  ${TENDER['TENDER_UAID']}  value.amount
  ${minimalStep}=  Отримати дані із тендера  ${username}  ${TENDER['TENDER_UAID']}  minimalStep.amount
  ${max_amount}=  Evaluate  ${starting_price}+${minimalStep}
  ${value}=  create_fake_amount  ${starting_price}  ${max_amount}
  Run As  ${username}  Змінити цінову пропозицію  ${TENDER['TENDER_UAID']}  value.amount  ${value}


Можливість завантажити документ в пропозицію користувачем ${username}
  ${file_path}  ${file_name}  ${file_content}=  create_fake_doc
  ${bid_doc_upload}=  Run As  ${username}  Завантажити документ в ставку  ${file_path}  ${TENDER['TENDER_UAID']}
  Set To Dictionary  ${USERS.users['${username}'].bidresponses}  bid_doc_upload=${bid_doc_upload}
  Remove File  ${file_path}


Можливість змінити документацію цінової пропозиції користувачем ${username}
  ${file_path}  ${file_name}  ${file_content}=  create_fake_doc
  ${docid}=  Get Variable Value  ${USERS.users['${username}'].bidresponses['bid_doc_upload']['upload_response'].data.id}
  ${bid_doc_modified}=  Run As  ${username}  Змінити документ в ставці  ${TENDER['TENDER_UAID']}  ${file_path}  ${docid}
  Set To Dictionary  ${USERS.users['${username}'].bidresponses}  bid_doc_modified=${bid_doc_modified}
  Remove File  ${file_path}


Можливість завантажити протокол аукціону в пропозицію ${bid_index} користувачем ${username}
  ${auction_protocol_path}  ${file_title}  ${file_content}=  create_fake_doc
  Run As  ${username}  Завантажити протокол аукціону  ${TENDER['TENDER_UAID']}  ${auction_protocol_path}  ${bid_index}
  Remove File  ${auction_protocol_path}


Можливість завантажити протокол аукціону в авард ${award_index} користувачем ${username}
  ${auction_protocol_path}  ${file_title}  ${file_content}=  create_fake_doc
  Run As  ${username}  Завантажити протокол аукціону в авард  ${TENDER['TENDER_UAID']}  ${auction_protocol_path}  ${award_index}
  Remove File  ${auction_protocol_path}

Можливість підтвердити цінову пропозицію учасником ${username}
  Run As  ${username}  Змінити цінову пропозицію  ${TENDER['TENDER_UAID']}  status  active

##############################################################################################
#             Cancellations
##############################################################################################

Можливість скасувати цінову пропозицію користувачем ${username}
  Run As  ${username}  Скасувати цінову пропозицію  ${TENDER['TENDER_UAID']}

##############################################################################################
#             Awarding
##############################################################################################

Можливість зареєструвати, додати документацію і підтвердити постачальника до закупівлі
  ${supplier_data}=  Підготувати дані про постачальника  ${tender_owner}
  ${file_path}  ${file_name}  ${file_content}=  create_fake_doc
  Run as  ${tender_owner}
  ...      Створити постачальника, додати документацію і підтвердити його
  ...      ${TENDER['TENDER_UAID']}
  ...      ${supplier_data}
  ...      ${file_path}
  ${doc_id}=  get_id_from_doc_name  ${file_name}
  Set to dictionary  ${USERS.users['${tender_owner}']}  award_doc_name=${file_name}  award_doc_id=${doc_id}  award_doc_content=${file_content}
  Remove File  ${file_path}


Можливість укласти угоду для закупівлі
  Run as  ${tender_owner}
  ...      Підтвердити підписання контракту
  ...      ${TENDER['TENDER_UAID']}
  ...      ${0}
  Run Keyword And Ignore Error  Remove From Dictionary  ${USERS.users['${viewer}'].tender_data.contracts[0]}  status


Звірити кількість сформованих авардів лоту із ${number_of_awards} для користувача ${username}
  ${left}=  Convert To Integer  ${number_of_awards}
  ${right}=  Run As  ${username}  Отримати кількість авардів в тендері  ${TENDER['TENDER_UAID']}
  Порівняти об'єкти  ${left}  ${right}
