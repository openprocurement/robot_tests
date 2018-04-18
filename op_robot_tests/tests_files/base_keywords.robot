*** Settings ***
Library            op_robot_tests.tests_files.service_keywords
Library            Collections
Resource           keywords.robot
Resource           resource.robot


*** Keywords ***
Можливість оголосити тендер
  ${NUMBER_OF_LOTS}=  Convert To Integer  ${NUMBER_OF_LOTS}
  ${NUMBER_OF_ITEMS}=  Convert To Integer  ${NUMBER_OF_ITEMS}
  ${tender_parameters}=  Create Dictionary
  ...      mode=${MODE}
  ...      number_of_items=${NUMBER_OF_ITEMS}
  ...      number_of_lots=${NUMBER_OF_LOTS}
  ...      tender_meat=${${TENDER_MEAT}}
  ...      lot_meat=${${LOT_MEAT}}
  ...      item_meat=${${ITEM_MEAT}}
  ...      api_host_url=${API_HOST_URL}
  ...      moz_integration=${${MOZ_INTEGRATION}}
  ${DIALOGUE_TYPE}=  Get Variable Value  ${DIALOGUE_TYPE}
  Run keyword if  '${DIALOGUE_TYPE}' != '${None}'  Set to dictionary  ${tender_parameters}  dialogue_type=${DIALOGUE_TYPE}
  ${tender_data}=  Підготувати дані для створення тендера  ${tender_parameters}
  ${adapted_data}=  Адаптувати дані для оголошення тендера  ${tender_data}
  ${TENDER_UAID}=  Run As  ${tender_owner}  Створити тендер  ${adapted_data}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  initial_data=${adapted_data}
  Set To Dictionary  ${TENDER}  TENDER_UAID=${TENDER_UAID}


Можливість перевірити завантаження документів через Document Service
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \  ${status}=   Run Keyword And Return Status  List Should Contain Value  ${USERS.users['${username}'].tender_data.data}  documents
  \  Run Keyword If  ${status}   Exit For Loop
  ${documents}=  Get From Dictionary  ${USERS.users['${username}'].tender_data.data}  documents
  ${doc_number}=  Get Length  ${documents}
  :FOR  ${doc_index}  IN RANGE  ${doc_number}
  \  ${document_url}=  Get From Dictionary  ${USERS.users['${username}'].tender_data.data.documents[${doc_index}]}  url
  \  Should Match Regexp   ${document_url}   ^https?:\/\/public.docs(?:-sandbox)?\.openprocurement\.org\/get\/([0-9A-Fa-f]{32})   msg=Not a Document Service Upload


Можливість створити план закупівлі
  ${NUMBER_OF_ITEMS}=  Convert To Integer  ${NUMBER_OF_ITEMS}
  ${tender_parameters}=  Create Dictionary
  ...      mode=${MODE}
  ...      number_of_items=${NUMBER_OF_ITEMS}
  ...      tender_meat=${${TENDER_MEAT}}
  ...      item_meat=${${ITEM_MEAT}}
  ${DIALOGUE_TYPE}=  Get Variable Value  ${DIALOGUE_TYPE}
  Run keyword if  '${DIALOGUE_TYPE}' != '${None}'  Set to dictionary  ${tender_parameters}  dialogue_type=${DIALOGUE_TYPE}
  ${tender_data}=  Підготувати дані для створення плану  ${tender_parameters}
  ${adapted_data}=  Адаптувати дані для оголошення тендера  ${tender_data}
  ${TENDER_UAID}=  Run As  ${tender_owner}  Створити план  ${adapted_data}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  initial_data=${adapted_data}
  Set To Dictionary  ${TENDER}  TENDER_UAID=${TENDER_UAID}


Можливість знайти тендер по ідентифікатору для усіх користувачів
  :FOR  ${username}  IN  ${tender_owner}  ${provider}  ${provider1}  ${viewer}
  \  Можливість знайти тендер по ідентифікатору для користувача ${username}


Можливість знайти тендер по ідентифікатору для користувача ${username}
  Дочекатись синхронізації з майданчиком  ${username}
  Run as  ${username}  Пошук тендера по ідентифікатору  ${TENDER['TENDER_UAID']}


Можливість знайти план по ідентифікатору
  :FOR  ${username}  IN  ${tender_owner}  ${viewer}
  \  Можливість знайти план по ідентифікатору для користувача ${username}


Можливість знайти план по ідентифікатору для користувача ${username}
  Дочекатись синхронізації з майданчиком  ${username}
  Run as  ${username}  Пошук плану по ідентифікатору  ${TENDER['TENDER_UAID']}


Можливість знайти тендер за кошти донора для усіх користувачів
  :FOR  ${username}  IN  ${tender_owner}  ${provider}  ${provider1}  ${viewer}
  \  Можливість знайти тендер за кошти донора для користувача ${username}


Можливість знайти тендер за кошти донора для користувача ${username}
  Дочекатись синхронізації з майданчиком  ${username}
  ${funder_id}=  Set Variable  ${USERS.users['${tender_owner}'].initial_data.data['funders'][0]['identifier']['id']}
  Run as  ${username}  Пошук тендера за кошти донора  ${funder_id}


Можливість знайти тендер по ідентифікатору ${tender_id} та зберегти його в ${save_location} для користувача ${username}
  Дочекатись синхронізації з майданчиком  ${username}
  Run as  ${username}  Пошук тендера по ідентифікатору  ${tender_id}  ${save_location}


Можливість змінити поле ${field_name} тендера на ${field_value}
  Run As  ${tender_owner}  Внести зміни в тендер  ${TENDER['TENDER_UAID']}  ${field_name}  ${field_value}


Перевірити неможливість зміни поля ${field_name} тендера на значення ${field_value} для користувача ${username}
  Require Failure  ${username}  Внести зміни в тендер  ${TENDER['TENDER_UAID']}  ${field_name}  ${field_value}

Можливість змінити поле ${field_name} плану на ${field_value}
  Run As  ${tender_owner}  Внести зміни в план  ${TENDER['TENDER_UAID']}  ${field_name}  ${field_value}


Можливість додати документацію до тендера
  ${file_path}  ${file_name}  ${file_content}=  create_fake_doc
  Run As  ${tender_owner}  Завантажити документ  ${file_path}  ${TENDER['TENDER_UAID']}
  ${doc_id}=  get_id_from_string  ${file_name}
  ${tender_document}=  Create Dictionary
  ...      doc_name=${file_name}
  ...      doc_id=${doc_id}
  ...      doc_content=${file_content}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  tender_document=${tender_document}
  Remove File  ${file_path}


Можливість додати предмет закупівлі в тендер
  ${item}=  Підготувати дані для створення предмету закупівлі  ${USERS.users['${tender_owner}'].initial_data.data['items'][0]['classification']['id']}
  Run As  ${tender_owner}  Додати предмет закупівлі  ${TENDER['TENDER_UAID']}  ${item}
  ${item_id}=  get_id_from_object  ${item}
  ${item_data}=  Create Dictionary
  ...      item=${item}
  ...      item_id=${item_id}
  ${item_data}=  munch_dict  arg=${item_data}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  item_data=${item_data}


Можливість додати предмет закупівлі в план
  ${item}=  Підготувати дані для створення предмету закупівлі плану  ${USERS.users['${tender_owner}'].initial_data.data['items'][0]['classification']['id']}
  Run As  ${tender_owner}  Додати предмет закупівлі в план  ${TENDER['TENDER_UAID']}  ${item}
  ${item_id}=  get_id_from_object  ${item}
  ${item_data}=  Create Dictionary
  ...      item=${item}
  ...      item_id=${item_id}
  ${item_data}=  munch_dict  arg=${item_data}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  item_data=${item_data}


Можливість видалити предмет закупівлі з тендера
  Run As  ${tender_owner}  Видалити предмет закупівлі  ${TENDER['TENDER_UAID']}  ${USERS.users['${tender_owner}'].item_data.item_id}


Можливість видалити предмет закупівлі з плану
  Run As  ${tender_owner}  Видалити предмет закупівлі плану  ${TENDER['TENDER_UAID']}  ${USERS.users['${tender_owner}'].item_data.item_id}


Можливість видалити поле ${field_name} з донора ${funders_index}
  Run As  ${tender_owner}  Видалити поле з донора  ${TENDER['TENDER_UAID']}  ${funders_index}  ${field_name}


Можливість видалити донора ${funders_index}
  Run As  ${tender_owner}  Видалити донора  ${TENDER['TENDER_UAID']}  ${funders_index}


Можливість додати донора
  ${funders_data}=  create_fake_funder
  Run As  ${tender_owner}  Додати донора  ${TENDER['TENDER_UAID']}  ${funders_data}


Звірити відображення поля ${field} документа ${doc_id} із ${left} для користувача ${username}
  ${right}=  Run As  ${username}  Отримати інформацію із документа  ${TENDER['TENDER_UAID']}  ${doc_id}  ${field}
  Порівняти об'єкти  ${left}  ${right}


Звірити відображення поля ${field} тендера для усіх користувачів
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}  ${provider}  ${provider1}
  \  Звірити відображення поля ${field} тендера для користувача ${username}


Звірити відображення поля ${field} тендера із ${data} для користувача ${username}
  Звірити поле тендера із значенням  ${username}  ${TENDER['TENDER_UAID']}  ${data}  ${field}


Звірити відображення поля ${field} тендера для користувача ${username}
  Звірити поле тендера  ${username}  ${TENDER['TENDER_UAID']}  ${USERS.users['${tender_owner}'].initial_data}  ${field}


Звірити відображення поля ${field} плану для користувача ${username}
  Звірити поле плану  ${username}  ${TENDER['TENDER_UAID']}  ${USERS.users['${tender_owner}'].initial_data}  ${field}


Отримати доступ до тендера другого етапу та зберегти його
  Run as  ${tender_owner}  Отримати тендер другого етапу та зберегти його  ${USERS.users['${tender_owner}'].tender_data.data.stage2TenderID}
  ${TENDER_UAID_second_stage}=  BuiltIn.Catenate  SEPARATOR=  ${TENDER['TENDER_UAID']}  .2
  Set to dictionary  ${TENDER}  TENDER_UAID=${TENDER_UAID_second_stage}
  :FOR  ${username}  IN  ${tender_owner}  ${provider}  ${provider1}  ${viewer}
  \  Можливість знайти тендер по ідентифікатору для користувача ${username}


Звірити відображення вмісту документа ${doc_id} із ${left} для користувача ${username}
  ${file_name}=  Run as  ${username}  Отримати документ  ${TENDER['TENDER_UAID']}  ${doc_id}
  ${right}=  Get File  ${OUTPUT_DIR}${/}${file_name}
  Порівняти об'єкти  ${left}  ${right}


Отримати інформацію про документ тендера ${doc_id} ${username}
  ${file_properties} =  Run as  ${username}  Отримати інформацію про документ  ${TENDER['TENDER_UAID']}  ${doc_id}
  Set To Dictionary  ${USERS.users['${tender_owner}'].tender_document}  file_properties=${file_properties}
  Log  ${file_properties}


Отримати інформацію про документ лотів ${doc_id} ${username}
  ${file_properties} =  Run as  ${username}  Отримати інформацію про документ  ${TENDER['TENDER_UAID']}  ${doc_id}
  Set To Dictionary  ${USERS.users['${tender_owner}'].lots_documents[0]}  file_properties=${file_properties}
  Log  ${file_properties}


Звірити інформацію про документацію ${file_properties} ${username}
  ${file_contents}=  Run as  ${username}  Отримати вміст документа  ${file_properties.url}
  ${file_hash}=  get_hash  ${file_contents}
  ${new_file_properties}=  Call Method  ${USERS.users['${viewer}'].client}  get_file_properties  ${file_properties.url}  ${file_hash}
  Порівняти об'єкти  ${new_file_properties}  ${file_properties}


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
  :FOR  ${item_index}  IN RANGE  ${NUMBER_OF_ITEMS}
  \  Звірити відображення поля ${field} ${item_index} предмету для користувача ${username}


Звірити відображення ${field} усіх предметів плану для усіх користувачів
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \  Звірити відображення ${field} усіх предметів плану для користувача ${username}


Звірити відображення ${field} усіх предметів плану для користувача ${username}
  :FOR  ${item_index}  IN RANGE  ${NUMBER_OF_ITEMS}
  \  ${item_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].initial_data.data['items'][${item_index}]}
  \  Звірити поле плану із значенням  ${username}  ${TENDER['TENDER_UAID']}  ${USERS.users['${tender_owner}'].initial_data.data['items'][${item_index}].${field}}  ${field}  ${item_id}


Звірити відображення поля ${field} ${item_index} предмету для користувача ${username}
  ${item_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].initial_data.data['items'][${item_index}]}
  Звірити поле тендера із значенням  ${username}  ${TENDER['TENDER_UAID']}  ${USERS.users['${tender_owner}'].initial_data.data['items'][${item_index}].${field}}  ${field}  ${item_id}


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


Звірити відображення поля ${field} усіх донорів для усіх користувачів
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}  ${provider}  ${provider1}
  \  Звірити відображення поля ${field} усіх донорів для користувача ${username}


Звірити відображення поля ${field} усіх донорів для користувача ${username}
  :FOR  ${funders_index}  IN RANGE  ${FUNDERS}
  \  Звірити відображення поля ${field} ${funders_index} донора для користувача ${username}


Звірити відображення поля ${field} ${funders_index} донора для користувача ${username}
  Звірити поле донора  ${username}  ${TENDER['TENDER_UAID']}  ${USERS.users['${tender_owner}'].initial_data}  ${field}  ${funders_index}


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
  ${file_path}  ${file_name}  ${file_content}=  create_fake_doc
  Run As  ${tender_owner}  Завантажити документ в лот  ${file_path}  ${TENDER['TENDER_UAID']}  ${lot_id}
  ${doc_id}=  get_id_from_string  ${file_name}
  ${data}=  Create Dictionary
  ...      doc_name=${file_name}
  ...      doc_id=${doc_id}
  ...      doc_content=${file_content}
  ${empty_list}=  Create List
  ${lots_documents}=  Get variable value  ${USERS.users['${tender_owner}'].lots_documents}  ${empty_list}
  Append to list  ${lots_documents}  ${data}
  Set to dictionary  ${USERS.users['${tender_owner}']}  lots_documents=${lots_documents}
  Log  ${USERS.users['${tender_owner}'].lots_documents}
  Remove File  ${file_path}


Можливість додати документацію до всіх лотів
  :FOR  ${lot_index}  IN RANGE  ${NUMBER_OF_LOTS}
  \  Можливість додати документацію до ${lot_index} лоту


Можливість додати предмет закупівлі в ${lot_index} лот
  ${lot_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].tender_data.data.lots[${lot_index}]}
  ${item}=  Підготувати дані для створення предмету закупівлі  ${USERS.users['${tender_owner}'].initial_data.data['items'][0]['classification']['id']}
  Run As  ${tender_owner}  Додати предмет закупівлі в лот  ${TENDER['TENDER_UAID']}  ${lot_id}  ${item}
  ${item_id}=  get_id_from_object  ${item}
  ${item_data}=  Create Dictionary
  ...      item=${item}
  ...      item_id=${item_id}
  ${item_data}=  munch_dict  arg=${item_data}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  item_data=${item_data}


Звірити відображення заголовку документації до всіх лотів для користувача ${username}
  :FOR  ${lot_index}  IN RANGE  ${NUMBER_OF_LOTS}
  \  Звірити відображення поля title документа ${USERS.users['${tender_owner}'].lots_documents[${lot_index}].doc_id} із ${USERS.users['${tender_owner}'].lots_documents[${lot_index}].doc_name} для користувача ${username}


Звірити відображення вмісту документації до всіх лотів для користувача ${username}
  :FOR  ${lot_index}  IN RANGE  ${NUMBER_OF_LOTS}
  \  ${lot_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].tender_data.data.lots[${lot_index}]}
  \  Звірити відображення вмісту документа ${USERS.users['${tender_owner}'].lots_documents[${lot_index}].doc_id} до лоту ${lot_id} з ${USERS.users['${tender_owner}'].lots_documents[${lot_index}].doc_content} для користувача ${username}


Звірити відображення поля ${field} документа ${doc_id} до лоту ${lot_id} з ${left} для користувача ${username}
  ${right}=  Run As  ${username}  Отримати інформацію із документа до лоту  ${TENDER['TENDER_UAID']}  ${lot_id}  ${doc_id}  ${field}
  Порівняти об'єкти  ${left}  ${right}


Звірити відображення вмісту документа ${doc_id} до лоту ${lot_id} з ${left} для користувача ${username}
  ${file_name}=  Run as  ${username}  Отримати документ до лоту  ${TENDER['TENDER_UAID']}  ${lot_id}  ${doc_id}
  ${right}=  Get File  ${OUTPUT_DIR}${/}${file_name}
  Порівняти об'єкти  ${left}  ${right}


Можливість видалити предмет закупівлі з ${lot_index} лоту
  ${lot_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].tender_data.data.lots[${lot_index}]}
  Run As  ${tender_owner}  Видалити предмет закупівлі  ${TENDER['TENDER_UAID']}  ${USERS.users['${tender_owner}'].item_data.item_id}  ${lot_id}


Можливість створення лоту із прив’язаним предметом закупівлі
  ${lot}=  Підготувати дані для створення лоту  ${USERS.users['${tender_owner}'].tender_data.data.value.amount}
  ${item}=  Підготувати дані для створення предмету закупівлі  ${USERS.users['${tender_owner}'].initial_data.data['items'][0]['classification']['id']}
  Run As  ${tender_owner}  Створити лот із предметом закупівлі  ${TENDER['TENDER_UAID']}  ${lot}  ${item}
  ${item_id}=  get_id_from_object  ${item}
  ${item_data}=  Create Dictionary
  ...      item=${item}
  ...      item_id=${item_id}
  ${item_data}=  munch_dict  arg=${item_data}
  ${lot_id}=  get_id_from_object  ${lot.data}
  ${lot_data}=  Create Dictionary
  ...      lot=${lot}
  ...      lot_id=${lot_id}
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


Звірити відображення поля ${field} усіх лотів другого етапу для усіх користувачів
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}  ${provider}  ${provider1}
  \  Звірити відображення поля ${field} усіх лотів другого етапу для користувача ${username}


Звірити відображення поля ${field} усіх лотів для користувача ${username}
  :FOR  ${lot_index}  IN RANGE  ${NUMBER_OF_LOTS}
  \  Звірити відображення поля ${field} ${lot_index} лоту для користувача ${username}


Звірити відображення поля ${field} усіх лотів другого етапу для користувача ${username}
  :FOR  ${lot_index}  IN RANGE  ${NUMBER_OF_LOTS}
  \  Звірити відображення поля ${field} ${lot_index} лоту другого етапу для користувача ${username}


Звірити відображення поля ${field} ${lot_index} лоту для користувача ${username}
  Дочекатись синхронізації з майданчиком  ${username}
  ${lot_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].initial_data.data.lots[${lot_index}]}
  Звірити поле тендера із значенням  ${username}  ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${tender_owner}'].initial_data.data.lots[${lot_index}].${field}}  ${field}
  ...      object_id=${lot_id}

Звірити відображення поля ${field} ${lot_index} лоту другого етапу для користувача ${username}
  Дочекатись синхронізації з майданчиком  ${username}
  ${lot_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].initial_data.data.lots[${lot_index}]}
  Звірити поле тендера із значенням  ${username}  ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${tender_owner}'].second_stage_data.data.lots[${lot_index}].${field}}  ${field}
  ...      object_id=${lot_id}


Звірити відображення поля ${field} ${lot_index} лоту з ${data} для користувача ${username}
  ${lot_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].initial_data.data.lots[${lot_index}]}
  Звірити поле тендера із значенням  ${username}  ${TENDER['TENDER_UAID']}  ${data}  ${field}  ${lot_id}


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
  ${divider}=  Convert To Number  0.01
  ${value}=  mult_and_round  ${USERS.users['${tender_owner}'].tender_data.data.lots[${lot_index}].value.amount}  ${percent}  ${divider}  precision=${2}
  ${step_value}=  mult_and_round  ${USERS.users['${tender_owner}'].tender_data.data.lots[${lot_index}].minimalStep.amount}  ${percent}  ${divider}  precision=${2}
  Можливість змінити поле value.amount ${lot_index} лоту на ${value}
  Можливість змінити поле minimalStep.amount ${lot_index} лоту на ${step_value}


Можливість змінити поле ${field} ${lot_index} лоту на ${value}
  ${lot_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].tender_data.data.lots[${lot_index}]}
  Run As  ${tender_owner}  Змінити лот  ${TENDER['TENDER_UAID']}  ${lot_id}  ${field}  ${value}

##############################################################################################
#             FEATURES
##############################################################################################

Можливість додати неціновий показник на тендер
  ${feature}=  Підготувати дані для створення нецінового показника
  Set To Dictionary  ${feature}  featureOf=tenderer
  Run As  ${tender_owner}  Додати неціновий показник на тендер  ${TENDER['TENDER_UAID']}  ${feature}
  ${feature_id}=  get_id_from_object  ${feature}
  ${feature_data}=  Create Dictionary
  ...      feature=${feature}
  ...      feature_id=${feature_id}
  ${feature_data}=  munch_dict  arg=${feature_data}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  feature_data=${feature_data}


Можливість додати неціновий показник на ${lot_index} лот
  ${feature}=  Підготувати дані для створення нецінового показника
  Set To Dictionary  ${feature}  featureOf=lot
  ${lot_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].tender_data.data.lots[${lot_index}]}
  Run As  ${tender_owner}  Додати неціновий показник на лот  ${TENDER['TENDER_UAID']}  ${feature}  ${lot_id}
  ${feature_id}=  get_id_from_object  ${feature}
  ${feature_data}=  Create Dictionary
  ...      feature=${feature}
  ...      feature_id=${feature_id}
  ${feature_data}=  munch_dict  arg=${feature_data}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  feature_data=${feature_data}


Можливість додати неціновий показник на ${item_index} предмет
  ${feature}=  Підготувати дані для створення нецінового показника
  Set To Dictionary  ${feature}  featureOf=item
  ${item_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].tender_data.data['items'][${item_index}]}
  Run As  ${tender_owner}  Додати неціновий показник на предмет  ${TENDER['TENDER_UAID']}  ${feature}  ${item_id}
  ${feature_id}=  get_id_from_object  ${feature}
  ${feature_data}=  Create Dictionary
  ...      feature=${feature}
  ...      feature_id=${feature_id}
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


Звірити відображення поля ${field} зміни до договору для користувача ${username}
  Звірити поле зміни до договору  ${username}  ${CONTRACT_UAID}
  ...      ${USERS.users['${tender_owner}'].change_data}
  ...      ${field}


Звірити відображення поля ${field} договору із ${left} для користувача ${username}
  ${right}=  Run As  ${username}  Отримати інформацію із договору  ${CONTRACT_UAID}  ${field}
  Порівняти об'єкти  ${left}  ${right}


Звірити відображення поля ${field} документа ${doc_id} до договору з ${left} для користувача ${username}
  ${right}=  Run As  ${username}  Отримати інформацію із документа до договору  ${CONTRACT_UAID}  ${doc_id}  ${field}
  Порівняти об'єкти  ${left}  ${right}


Звірити відображення вмісту документа ${doc_id} до договору з ${left} для користувача ${username}
  ${file_name}=  Run As  ${username}  Отримати документ до договору  ${CONTRACT_UAID}  ${doc_id}
  ${right}=  Get File  ${OUTPUT_DIR}${/}${file_name}
  Порівняти об'єкти  ${left}  ${right}


Звірити відображення причин зміни договору
  ${rationale_types_from_broker}=  Run as  ${viewer}  Отримати інформацію із договору  ${CONTRACT_UAID}  changes[0].rationaleTypes
  ${rationale_types_from_robot}=  Get variable value  ${USERS.users['${tender_owner}'].change_data.data.rationaleTypes}
  Log  ${rationale_types_from_broker}
  Log  ${rationale_types_from_robot}
  ${result}=  compare_rationale_types  ${rationale_types_from_broker}  ${rationale_types_from_robot}
  Run keyword if  ${result} == ${False}  Fail  Rationale types are not equal


Додати документацію до зміни договору
  ${file_path}  ${file_name}  ${file_content}=  create_fake_doc
  ${doc_id}=  get_id_from_string  ${file_name}
  ${doc}=  Create Dictionary
  ...      id=${doc_id}
  ...      name=${file_name}
  ...      content=${file_content}
  Set to dictionary  ${USERS.users['${tender_owner}']}  change_doc=${doc}
  Run As  ${tender_owner}  Додати документацію до зміни в договорі  ${CONTRACT_UAID}  ${file_path}
  Remove File  ${file_path}


Додати документацію до договору
  ${file_path}  ${file_name}  ${file_content}=  create_fake_doc
  ${doc_id}=  get_id_from_string  ${file_name}
  ${doc}=  Create Dictionary
  ...      id=${doc_id}
  ...      name=${file_name}
  ...      content=${file_content}
  Set to dictionary  ${USERS.users['${tender_owner}']}  contract_doc=${doc}
  Run As  ${tender_owner}  Завантажити документацію до договору  ${CONTRACT_UAID}  ${file_path}
  Remove File  ${file_path}


Вказати дійсно оплачену суму
  ${amount}=  Get variable value  ${USERS.users['${tender_owner}'].contract_data.data.value.amount}
  ${amountPaid}=  Create Dictionary  amount=${amount}  valueAddedTaxIncluded=${True}  currency=UAH
  ${data}=  Create Dictionary  amountPaid=${amountPaid}
  ${data}=  Create Dictionary  data=${data}
  Set to dictionary  ${USERS.users['${tender_owner}']}  terminating_data=${data}
  Run As  ${tender_owner}  Внести зміни в договір  ${CONTRACT_UAID}  ${data}


##############################################################################################
#             QUESTIONS
##############################################################################################

Можливість задати запитання на тендер користувачем ${username}
  ${question}=  Підготувати дані для запитання
  Run As  ${username}  Задати запитання на тендер  ${TENDER['TENDER_UAID']}  ${question}
  ${now}=  Get Current TZdate
  ${question.data.date}=  Set variable  ${now}
  ${question_id}=  get_id_from_object  ${question.data}
  ${question_data}=  Create Dictionary
  ...      question=${question}
  ...      question_id=${question_id}
  ${question_data}=  munch_dict  arg=${question_data}
  Set To Dictionary  ${USERS.users['${username}']}  tender_question_data=${question_data}


Можливість задати запитання на ${lot_index} лот користувачем ${username}
  ${lot_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].tender_data.data.lots[${lot_index}]}
  ${question}=  Підготувати дані для запитання
  Run As  ${username}  Задати запитання на лот  ${TENDER['TENDER_UAID']}  ${lot_id}  ${question}
  ${now}=  Get Current TZdate
  ${question.data.date}=  Set variable  ${now}
  ${question_id}=  get_id_from_object  ${question.data}
  ${question_data}=  Create Dictionary
  ...      question=${question}
  ...      question_id=${question_id}
  ${question_data}=  munch_dict  arg=${question_data}
  Set To Dictionary  ${USERS.users['${username}']}  lots_${lot_index}_question_data=${question_data}


Можливість задати запитання на ${item_index} предмет користувачем ${username}
  ${item_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].tender_data.data['items'][${item_index}]}
  ${question}=  Підготувати дані для запитання
  Run As  ${username}  Задати запитання на предмет  ${TENDER['TENDER_UAID']}  ${item_id}  ${question}
  ${now}=  Get Current TZdate
  ${question.data.date}=  Set variable  ${now}
  ${question_id}=  get_id_from_object  ${question.data}
  ${question_data}=  Create Dictionary
  ...      question=${question}
  ...      question_id=${question_id}
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


Можливість відповісти на запитання на ${lot_index} лот
  ${answer}=  Підготувати дані для відповіді на запитання
  Run As  ${tender_owner}
  ...      Відповісти на запитання  ${TENDER['TENDER_UAID']}
  ...      ${answer}
  ...      ${USERS.users['${provider}'].lots_${lot_index}_question_data.question_id}
  Set To Dictionary  ${USERS.users['${provider}'].lots_${lot_index}_question_data.question.data}  answer=${answer.data.answer}


Звірити відображення поля ${field} запитання на тендер для усіх користувачів
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}  ${provider}  ${provider1}
  \  Звірити відображення поля ${field} запитання на тендер для користувача ${username}


Звірити відображення поля ${field} запитання на тендер для користувача ${username}
  Звірити поле тендера із значенням  ${username}  ${TENDER['TENDER_UAID']}  ${USERS.users['${provider}'].tender_question_data.question.data.${field}}  ${field}  ${USERS.users['${provider}'].tender_question_data.question_id}


Звірити відображення поля ${field} запитання на ${item_index} предмет для усіх користувачів
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}  ${provider}  ${provider1}
  \  Звірити відображення поля ${field} запитання на ${item_index} предмет для користувача ${username}


Звірити відображення поля ${field} запитання на ${item_index} предмет для користувача ${username}
  Звірити поле тендера із значенням  ${username}  ${TENDER['TENDER_UAID']}  ${USERS.users['${provider}'].items_${item_index}_question_data.question.data.${field}}  ${field}  ${USERS.users['${provider}'].items_${item_index}_question_data.question_id}


Звірити відображення поля ${field} запитання на ${lot_index} лот для усіх користувачів
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}  ${provider}  ${provider1}
  \  Звірити відображення поля ${field} запитання на ${lot_index} лот для користувача ${username}


Звірити відображення поля ${field} запитання на ${lot_index} лот для користувача ${username}
  Звірити поле тендера із значенням  ${username}  ${TENDER['TENDER_UAID']}  ${USERS.users['${provider}'].lots_${lot_index}_question_data.question.data.${field}}  ${field}  ${USERS.users['${provider}'].lots_${lot_index}_question_data.question_id}

##############################################################################################
#             COMPLAINTS
##############################################################################################


Можливість створити чернетку вимоги про виправлення умов закупівлі
  ${claim}=  Підготувати дані для подання вимоги
  ${complaintID}=  Run As  ${provider}
  ...      Створити чернетку вимоги про виправлення умов закупівлі
  ...      ${TENDER['TENDER_UAID']}
  ...      ${claim}
  ${claim_data}=  Create Dictionary
  ...      claim=${claim}
  ...      complaintID=${complaintID}
  ${claim_data}=  munch_dict  arg=${claim_data}
  Set To Dictionary  ${USERS.users['${provider}']}  tender_claim_data  ${claim_data}


Можливість створити чернетку вимоги про виправлення умов ${lot_index} лоту
  ${claim}=  Підготувати дані для подання вимоги
  ${lot_id}=  get_id_from_object  ${USERS.users['${provider}'].tender_data.data.lots[${lot_index}]}
  ${complaintID}=  Run As  ${provider}
  ...      Створити чернетку вимоги про виправлення умов лоту
  ...      ${TENDER['TENDER_UAID']}
  ...      ${claim}
  ...      ${lot_id}
  ${claim_data}=  Create Dictionary
  ...      claim=${claim}
  ...      complaintID=${complaintID}
  ${claim_data}=  munch_dict  arg=${claim_data}
  Set To Dictionary  ${USERS.users['${provider}']}  lot_claim_data  ${claim_data}


Можливість створити чернетку вимоги про виправлення визначення ${award_index} переможця
  ${claim}=  Підготувати дані для подання вимоги
  ${complaintID}=  Run As  ${provider}
  ...      Створити чернетку вимоги про виправлення визначення переможця
  ...      ${TENDER['TENDER_UAID']}
  ...      ${claim}
  ...      ${award_index}
  ${claim_data}=  Create Dictionary
  ...      claim=${claim}
  ...      complaintID=${complaintID}
  ${claim_data}=  munch_dict  arg=${claim_data}
  Set To Dictionary  ${USERS.users['${provider}']}  claim_data  ${claim_data}


Можливість створити вимогу про виправлення умов закупівлі із документацією
  ${claim}=  Підготувати дані для подання вимоги
  ${file_path}  ${file_name}  ${file_content}=  create_fake_doc
  ${complaintID}=  Run As  ${provider}
  ...      Створити вимогу про виправлення умов закупівлі
  ...      ${TENDER['TENDER_UAID']}
  ...      ${claim}
  ...      ${file_path}
  ${doc_id}=  get_id_from_string  ${file_name}
  ${claim_data}=  Create Dictionary
  ...      claim=${claim}
  ...      complaintID=${complaintID}
  ...      doc_name=${file_name}
  ...      doc_id=${doc_id}
  ...      doc_content=${file_content}
  ${claim_data}=  munch_dict  arg=${claim_data}
  Set To Dictionary  ${USERS.users['${provider}']}  tender_claim_data  ${claim_data}
  Remove File  ${file_path}


Можливість створити вимогу про виправлення умов ${lot_index} лоту із документацією
  ${claim}=  Підготувати дані для подання вимоги
  ${lot_id}=  get_id_from_object  ${USERS.users['${provider}'].tender_data.data.lots[${lot_index}]}
  ${file_path}  ${file_name}  ${file_content}=  create_fake_doc
  ${complaintID}=  Run As  ${provider}
  ...      Створити вимогу про виправлення умов лоту
  ...      ${TENDER['TENDER_UAID']}
  ...      ${claim}
  ...      ${lot_id}
  ...      ${file_path}
  ${doc_id}=  get_id_from_string  ${file_name}
  ${claim_data}=  Create Dictionary
  ...      claim=${claim}
  ...      complaintID=${complaintID}
  ...      doc_name=${file_name}
  ...      doc_id=${doc_id}
  ...      doc_content=${file_content}
  ${claim_data}=  munch_dict  arg=${claim_data}
  Set To Dictionary  ${USERS.users['${provider}']}  lot_claim_data  ${claim_data}
  Remove File  ${file_path}


Можливість створити вимогу про виправлення визначення ${award_index} переможця із документацією
  ${claim}=  Підготувати дані для подання вимоги
  ${file_path}  ${file_name}  ${file_content}=  create_fake_doc
  ${complaintID}=  Run As  ${provider}
  ...      Створити вимогу про виправлення визначення переможця
  ...      ${TENDER['TENDER_UAID']}
  ...      ${claim}
  ...      ${award_index}
  ...      ${file_path}
  ${doc_id}=  get_id_from_string  ${file_name}
  ${claim_data}=  Create Dictionary
  ...      claim=${claim}
  ...      complaintID=${complaintID}
  ...      doc_name=${file_name}
  ...      doc_id=${doc_id}
  ...      doc_content=${file_content}
  ${claim_data}=  munch_dict  arg=${claim_data}
  Set To Dictionary  ${USERS.users['${provider}']}  claim_data  ${claim_data}
  Remove File  ${file_path}


Можливість скасувати вимогу про виправлення умов закупівлі
  ${cancellation_reason}=  create_fake_sentence
  ${data}=  Create Dictionary
  ...      status=cancelled
  ...      cancellationReason=${cancellation_reason}
  ${cancellation_data}=  Create Dictionary  data=${data}
  ${cancellation_data}=  munch_dict  arg=${cancellation_data}
  Run As  ${provider}
  ...      Скасувати вимогу про виправлення умов закупівлі
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['tender_claim_data']['complaintID']}
  ...      ${cancellation_data}
  Set To Dictionary  ${USERS.users['${provider}'].tender_claim_data}  cancellation  ${cancellation_data}
  Wait until keyword succeeds
  ...      40 min 15 sec
  ...      15 sec
  ...      Звірити статус вимоги/скарги
  ...      ${provider}
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['tender_claim_data']['complaintID']}
  ...      cancelled


Можливість скасувати вимогу про виправлення умов лоту
  ${cancellation_reason}=  create_fake_sentence
  ${data}=  Create Dictionary
  ...      status=cancelled
  ...      cancellationReason=${cancellation_reason}
  ${cancellation_data}=  Create Dictionary  data=${data}
  ${cancellation_data}=  munch_dict  arg=${cancellation_data}
  Run As  ${provider}
  ...      Скасувати вимогу про виправлення умов лоту
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['lot_claim_data']['complaintID']}
  ...      ${cancellation_data}
  Set To Dictionary  ${USERS.users['${provider}'].lot_claim_data}  cancellation  ${cancellation_data}
  Wait until keyword succeeds
  ...      40 min 15 sec
  ...      15 sec
  ...      Звірити статус вимоги/скарги
  ...      ${provider}
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['lot_claim_data']['complaintID']}
  ...      cancelled


Можливість скасувати вимогу/скаргу про виправлення визначення ${award_index} переможця, надавши їй статус ${claim_status}
  ${cancellation_reason}=  create_fake_sentence
  ${status}=  Set variable  ${claim_status}
  ${data}=  Create Dictionary
  ...      status=${status}
  ...      cancellationReason=${cancellation_reason}
  ${cancellation_data}=  Create Dictionary  data=${data}
  ${cancellation_data}=  munch_dict  arg=${cancellation_data}
  Run As  ${provider}
  ...      Скасувати вимогу про виправлення визначення переможця
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['claim_data']['complaintID']}
  ...      ${cancellation_data}
  ...      ${award_index}
  Set To Dictionary  ${USERS.users['${provider}'].claim_data}  cancellation  ${cancellation_data}
  Wait until keyword succeeds
  ...      40 min 15 sec
  ...      15 sec
  ...      Звірити статус вимоги/скарги
  ...      ${provider}
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['claim_data']['complaintID']}
  ...      ${status}
  ...      ${award_index}


Можливість перетворити вимогу про виправлення умов закупівлі в скаргу
  ${data}=  Create Dictionary
  ...      status=pending
  ...      satisfied=${False}
  ${escalation_data}=  Create Dictionary  data=${data}
  ${escalation_data}=  munch_dict  arg=${escalation_data}
  Run As  ${provider}
  ...      Перетворити вимогу про виправлення умов закупівлі в скаргу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['tender_claim_data']['complaintID']}
  ...      ${escalation_data}
  Set To Dictionary  ${USERS.users['${provider}'].tender_claim_data}  escalation  ${escalation_data}
  Wait until keyword succeeds
  ...      40 min 15 sec
  ...      15 sec
  ...      Звірити статус вимоги/скарги
  ...      ${provider}
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['tender_claim_data']['complaintID']}
  ...      pending


Можливість перетворити вимогу про виправлення умов лоту в скаргу
  ${data}=  Create Dictionary
  ...      status=pending
  ...      satisfied=${False}
  ${escalation_data}=  Create Dictionary  data=${data}
  ${escalation_data}=  munch_dict  arg=${escalation_data}
  Run As  ${provider}
  ...      Перетворити вимогу про виправлення умов лоту в скаргу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['lot_claim_data']['complaintID']}
  ...      ${escalation_data}
  Set To Dictionary  ${USERS.users['${provider}'].lot_claim_data}  escalation  ${escalation_data}
  Wait until keyword succeeds
  ...      40 min 15 sec
  ...      15 sec
  ...      Звірити статус вимоги/скарги
  ...      ${provider}
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['lot_claim_data']['complaintID']}
  ...      pending


Можливість перетворити вимогу про виправлення визначення ${award_index} переможця в скаргу
  ${data}=  Create Dictionary
  ...      status=pending
  ...      satisfied=${False}
  ${escalation_data}=  Create Dictionary  data=${data}
  ${escalation_data}=  munch_dict  arg=${escalation_data}
  Run As  ${provider}
  ...      Перетворити вимогу про виправлення визначення переможця в скаргу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['claim_data']['complaintID']}
  ...      ${escalation_data}
  ...      ${award_index}
  Set To Dictionary  ${USERS.users['${provider}'].claim_data}  escalation  ${escalation_data}
  Wait until keyword succeeds
  ...      40 min 15 sec
  ...      15 sec
  ...      Звірити статус вимоги/скарги
  ...      ${provider}
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['claim_data']['complaintID']}
  ...      pending
  ...      ${award_index}


Звірити відображення поля ${field} для вимоги ${complaintID} із ${data} для користувача ${username}
  Звірити поле скарги із значенням
  ...      ${username}
  ...      ${TENDER['TENDER_UAID']}
  ...      ${data}
  ...      ${field}
  ...      ${complaintID}


Звірити відображення поля ${field} вимоги про виправлення умов ${lot_index} лоту із ${data} для користувача ${username}
  Звірити поле скарги із значенням
  ...      ${username}
  ...      ${TENDER['TENDER_UAID']}
  ...      ${data}
  ...      ${field}
  ...      ${USERS.users['${provider}'].lot_claim_data['complaintID']}
  ...      ${lot_index}


Звірити відображення поля ${field} вимоги про виправлення визначення ${award_index} переможця із ${data} для користувача ${username}
  Звірити поле скарги із значенням
  ...      ${username}
  ...      ${TENDER['TENDER_UAID']}
  ...      ${data}
  ...      ${field}
  ...      ${USERS.users['${provider}'].claim_data['complaintID']}
  ...      ${award_index}


Можливість відповісти ${status} на вимогу про виправлення умов ${tender_or_lot}
  ${answer_data}=  test_claim_answer_data  ${status}
  Log  ${answer_data}
  ${data}=  Set Variable If  '${tender_or_lot}' == 'tender'  ${USERS.users['${provider}']['tender_claim_data']['complaintID']}  ${USERS.users['${provider}']['lot_claim_data']['complaintID']}
  Run As  ${tender_owner}
  ...      Відповісти на вимогу про виправлення умов закупівлі
  ...      ${TENDER['TENDER_UAID']}
  ...      ${data}
  ...      ${answer_data}
  ${claim_data}=  Create Dictionary  claim_answer=${answer_data}
  ${claim_data}=  munch_dict  arg=${claim_data}
  Run Keyword If  '${tender_or_lot}' == 'tender'
  ...       Set To Dictionary  ${USERS.users['${tender_owner}']}  tender_claim_data  ${claim_data}
  ...       ELSE
  ...       Set To Dictionary  ${USERS.users['${tender_owner}']}  lot_claim_data  ${claim_data}
  Wait until keyword succeeds
  ...      40 min 15 sec
  ...      15 sec
  ...      Звірити статус вимоги/скарги
  ...      ${provider}
  ...      ${TENDER['TENDER_UAID']}
  ...      ${data}
  ...      answered


Можливість відповісти ${status} на вимогу про виправлення визначення ${award_index} переможця
  ${answer_data}=  test_claim_answer_data  ${status}
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
  Wait until keyword succeeds
  ...      40 min 15 sec
  ...      15 sec
  ...      Звірити статус вимоги/скарги
  ...      ${provider}
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['claim_data']['complaintID']}
  ...      answered
  ...      ${award_index}


Можливість підтвердити задоволення вимоги про виправлення умов закупівлі
  ${data}=  Create Dictionary
  ...      satisfied=${True}
  ${confirmation_data}=  Create Dictionary  data=${data}
  ${confirmation_data}=  munch_dict  arg=${confirmation_data}
  Run As  ${provider}
  ...      Підтвердити вирішення вимоги про виправлення умов закупівлі
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['tender_claim_data']['complaintID']}
  ...      ${confirmation_data}
  Set To Dictionary  ${USERS.users['${provider}']['tender_claim_data']}  claim_answer_confirm  ${confirmation_data}


Можливість заперечити незадоволення вимоги про виправлення умов закупівлі для ${status} відповіді
  ${data}=  Create Dictionary
  ...      satisfied=${False}
  ${confirmation_data}=  Create Dictionary  data=${data}
  ${confirmation_data}=  munch_dict  arg=${confirmation_data}
  Run As  ${provider}
  ...      Підтвердити вирішення вимоги про виправлення умов закупівлі
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['tender_claim_data']['complaintID']}
  ...      ${confirmation_data}
  Set To Dictionary  ${USERS.users['${provider}']['tender_claim_data']}  claim_answer_confirm  ${confirmation_data}


Можливість підтвердити задоволення вимоги про виправлення умов лоту
  ${data}=  Create Dictionary
  ...      satisfied=${True}
  ${confirmation_data}=  Create Dictionary  data=${data}
  ${confirmation_data}=  munch_dict  arg=${confirmation_data}
  Run As  ${provider}
  ...      Підтвердити вирішення вимоги про виправлення умов лоту
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['lot_claim_data']['complaintID']}
  ...      ${confirmation_data}
  Set To Dictionary  ${USERS.users['${provider}']['lot_claim_data']}  claim_answer_confirm  ${confirmation_data}


Можливість підтвердити задоволення вимоги про виправлення визначення ${award_index} переможця
  ${data}=  Create Dictionary
  ...       satisfied=${True}
  ${confirmation_data}=  Create Dictionary  data=${data}
  ${confirmation_data}=  munch_dict  arg=${confirmation_data}
  Run As  ${provider}
  ...      Підтвердити вирішення вимоги про виправлення визначення переможця
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['claim_data']['complaintID']}
  ...      ${confirmation_data}
  ...      ${award_index}
  Set To Dictionary  ${USERS.users['${provider}']['claim_data']}  claim_answer_confirm  ${confirmation_data}
  Wait until keyword succeeds
  ...      40 min 15 sec
  ...      15 sec
  ...      Звірити статус вимоги/скарги
  ...      ${provider}
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['claim_data']['complaintID']}
  ...      resolved
  ...      ${award_index}


Звірити відображення поля ${field} документа ${doc_id} до скарги ${complaintID} з ${left} для користувача ${username}
  ${right}=  Run As  ${username}  Отримати інформацію із документа до скарги  ${TENDER['TENDER_UAID']}  ${complaintID}  ${doc_id}  ${field}
  Порівняти об'єкти  ${left}  ${right}


Звірити відображення вмісту документа ${doc_id} до скарги ${complaintID} з ${left} для користувача ${username}
  ${file_name}=  Run as  ${username}  Отримати документ до скарги  ${TENDER['TENDER_UAID']}  ${complaintID}  ${doc_id}
  ${right}=  Get File  ${OUTPUT_DIR}${/}${file_name}
  Порівняти об'єкти  ${left}  ${right}

##############################################################################################
#             BIDDING
##############################################################################################

Можливість подати цінову пропозицію користувачем ${username}
  ${bid}=  Підготувати дані для подання пропозиції
  ${bidresponses}=  Create Dictionary  bid=${bid}
  Set To Dictionary  ${USERS.users['${username}']}  bidresponses=${bidresponses}
  ${lots}=  Get Variable Value  ${USERS.users['${tender_owner}'].initial_data.data.lots}  ${None}
  ${lots_ids}=  Run Keyword IF  ${lots}
  ...     Отримати ідентифікатори об’єктів  ${username}  lots
  ...     ELSE  Set Variable  ${None}
  ${features}=  Get Variable Value  ${USERS.users['${tender_owner}'].initial_data.data.features}  ${None}
  ${features_ids}=  Run Keyword IF  ${features}
  ...     Отримати ідентифікатори об’єктів  ${username}  features
  ...     ELSE  Set Variable  ${None}
  Run As  ${username}  Подати цінову пропозицію  ${TENDER['TENDER_UAID']}  ${bid}  ${lots_ids}  ${features_ids}


Можливість подати цінову пропозицію на другий етап ${index} користувачем ${username}
  ${bid}=  Підготувати дані для подання пропозиції для другого етапу  ${index}
  ${bidresponses}=  Create Dictionary  bid=${bid}
  Set To Dictionary  ${USERS.users['${username}']}  bidresponses=${bidresponses}
  ${lots}=  Get Variable Value  ${USERS.users['${username}'].tender_data.data.lots}  ${None}
  ${lots_ids}=  Run Keyword IF  ${lots}
  ...     Отримати ідентифікатори об’єктів  ${username}  lots
  ...     ELSE  Set Variable  ${None}
  ${features}=  Get Variable Value  ${USERS.users['${username}'].tender_data.data.features}  ${None}
  ${features_ids}=  Run Keyword IF  ${features}
  ...     Отримати ідентифікатори об’єктів  ${username}  features
  ...     ELSE  Set Variable  ${None}
  Run As  ${username}  Подати цінову пропозицію  ${TENDER['TENDER_UAID']}  ${bid}  ${lots_ids}  ${features_ids}


Неможливість подати цінову пропозицію без прив’язки до лоту користувачем ${username}
  ${bid}=  Підготувати дані для подання пропозиції
  ${values}=  Get Variable Value  ${bid.data.lotValues[0]}
  Remove From Dictionary  ${bid.data}  lotValues
  Set_To_Object  ${bid}  data  ${values}
  Require Failure  ${username}  Подати цінову пропозицію  ${TENDER['TENDER_UAID']}  ${bid}


Неможливість подати цінову пропозицію без нецінових показників користувачем ${username}
  ${bid}=  Підготувати дані для подання пропозиції
  Remove From Dictionary  ${bid.data}  parameters
  Require Failure  ${username}  Подати цінову пропозицію  ${TENDER['TENDER_UAID']}  ${bid}


Можливість зменшити пропозицію до ${percent} відсотків користувачем ${username}
  ${percent}=  Convert To Number  ${percent}
  ${divider}=  Convert To Number  0.01
  ${field}=  Set variable if  ${NUMBER_OF_LOTS} == 0  value.amount  lotValues[0].value.amount
  ${value}=  Run As  ${username}  Отримати інформацію із пропозиції  ${TENDER['TENDER_UAID']}  ${field}
  ${value}=  mult_and_round  ${value}  ${percent}  ${divider}  precision=${2}
  Run as  ${username}  Змінити цінову пропозицію  ${TENDER['TENDER_UAID']}  ${field}  ${value}


Можливість завантажити документ в пропозицію користувачем ${username}
  ${file_path}  ${file_name}  ${file_content}=  create_fake_doc
  ${doc_id}=  get_id_from_string  ${file_name}
  ${bid_document_data}=  Create Dictionary
  ...      doc_name=${file_name}
  ...      doc_content=${file_content}
  ...      doc_id=${doc_id}
  Run As  ${username}  Завантажити документ в ставку  ${file_path}  ${TENDER['TENDER_UAID']}
  Set To Dictionary  ${USERS.users['${username}']}  bid_document=${bid_document_data}
  Remove File  ${file_path}


Можливість змінити документацію цінової пропозиції користувачем ${username}
  ${file_path}  ${file_name}  ${file_content}=  create_fake_doc
  ${doc_id}=  get_id_from_string  ${file_name}
  ${bid_document_modified_data}=  Create Dictionary
  ...      doc_name=${file_name}
  ...      doc_content=${file_content}
  ...      doc_id=${doc_id}
  Run As  ${username}  Змінити документ в ставці  ${TENDER['TENDER_UAID']}  ${file_path}  ${USERS.users['${username}']['bid_document']['doc_id']}
  Set To Dictionary  ${USERS.users['${username}']}  bid_document_modified=${bid_document_modified_data}
  Remove File  ${file_path}

##############################################################################################
#             Cancellations
##############################################################################################

Можливість скасувати цінову пропозицію користувачем ${username}
  Run As  ${username}  Скасувати цінову пропозицію  ${TENDER['TENDER_UAID']}

##############################################################################################
#             Awarding
##############################################################################################

Можливість зареєструвати, додати документацію і підтвердити першого постачальника до закупівлі
  ${lotIndex} =  Set Variable If  ${NUMBER_OF_LOTS} > 0  0  -1
  ${supplier_data}=  Підготувати дані про постачальника  ${tender_owner}  ${lotIndex}
  ${file_path}  ${file_name}  ${file_content}=  create_fake_doc
  Run as  ${tender_owner}
  ...      Створити постачальника, додати документацію і підтвердити його
  ...      ${TENDER['TENDER_UAID']}
  ...      ${supplier_data}
  ...      ${file_path}
  ${doc_id}=  get_id_from_string  ${file_name}
  Set to dictionary  ${USERS.users['${tender_owner}']}  award_doc_name=${file_name}  award_doc_id=${doc_id}  award_doc_content=${file_content}
  Remove File  ${file_path}


Можливість завантажити документ в ${contract_index} угоду користувачем ${username}
  ${file_path}  ${file_name}  ${file_content}=  create_fake_doc
  ${doc_id}=  get_id_from_string  ${file_name}
  ${doc}=  Create Dictionary
  ...      id=${doc_id}
  ...      name=${file_name}
  ...      content=${file_content}
  Set to dictionary  ${USERS.users['${tender_owner}']}  contract_doc=${doc}
  Run As  ${username}  Завантажити документ в угоду  ${file_path}  ${TENDER['TENDER_UAID']}  ${contract_index}
  Remove File  ${file_path}


Можливість укласти угоду для закупівлі
  Run as  ${tender_owner}
  ...      Підтвердити підписання контракту
  ...      ${TENDER['TENDER_UAID']}
  ...      ${0}
  Run Keyword And Ignore Error  Remove From Dictionary  ${USERS.users['${viewer}'].tender_data.data.contracts[0]}  status

##############################################################################################
#             Pre-Qualifications
##############################################################################################

Дочекатися перевірки прекваліфікацій
  [Documentation]
  ...       [Arguments] Username, tender uaid
  ...       [Description]  Waint until edr bridge check qualifications
  ...       [Return]  Nothing
  [Arguments]  ${username}  ${tender_uaid}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  :FOR  ${qualification}  IN  @{tender.data.qualifications}
  \   ${res}=  Wait until keyword succeeds
  \   ...      10 min 15 sec
  \   ...      30 sec
  \   ...      Перевірити документ прекваліфікіції ${qualification.id} для користувача ${username} в тендері ${tender_uaid}


Перевірити документ прекваліфікіції ${qualification_id} для користувача ${username} в тендері ${tender_uaid}
  ${document}=  openprocurement_client.Отримати останній документ прекваліфікації з типом registerExtract  ${username}  ${tender_uaid}  ${qualification_id}
  Порівняти об'єкти  ${document['documentType']}  registerExtract

##############################################################################################
#             Qualifications
##############################################################################################

Дочекатися перевірки кваліфікацій
  [Documentation]
  ...       [Arguments] Username, tender uaid
  ...       [Description]  Waint until edr bridge create check award
  ...       [Return]  Nothing
  [Arguments]  ${username}  ${tender_uaid}
  ${tender}=  openprocurement_client.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  :FOR  ${award}  IN  @{tender.data.awards}
  \   Wait until keyword succeeds
  \   ...      10 min 15 sec
  \   ...      30 sec
  \   ...      Перевірити документ кваліфікіції ${award.id} для користувача ${username} в тендері ${tender_uaid}


Перевірити документ кваліфікіції ${award_id} для користувача ${username} в тендері ${tender_uaid}
  ${document}=  openprocurement_client.Отримати останній документ кваліфікації з типом registerExtract  ${username}  ${tender_uaid}  ${award_id}
  Порівняти об'єкти  ${document['documentType']}  registerExtract