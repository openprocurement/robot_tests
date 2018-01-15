*** Settings ***
Resource        base_keywords.robot
Suite Setup     Test Suite Setup
Suite Teardown  Test Suite Teardown

*** Variables ***
@{USED_ROLES}       tender_owner  viewer
${MOZ_INTEGRATION}  ${False}


*** Test Cases ***
Можливість оголосити тендер
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оголошення тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_tender
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість оголосити тендер


Можливість знайти тендер по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук тендера
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      find_tender
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  :FOR  ${username}  IN  ${tender_owner}  ${viewer}
  \  Можливість знайти тендер по ідентифікатору для користувача ${username}

##############################################################################################
#             LOT CANCELLATION
##############################################################################################

Можливість скасувати лот
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Скасування лота
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  lot_cancellation
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість скасувати 0 лот


Відображення активного статусу скасування лота
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення скасування лота
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  lot_cancellation
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  ${cancellation_index}=  Отримати останній індекс  cancellations  ${tender_owner}  ${viewer}
  Звірити поле тендера із значенням  ${viewer}  ${TENDER['TENDER_UAID']}
  ...      active
  ...      cancellations[${cancellation_index}].status


Відображення причини скасування лота
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення скасування лота
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  lot_cancellation
  ${cancellation_index}=  Отримати останній індекс  cancellations  ${tender_owner}  ${viewer}
  Звірити поле тендера із значенням  ${viewer}  ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${tender_owner}']['lot_cancellation_data']['cancellation_reason']}
  ...      cancellations[${cancellation_index}].reason


Відображення опису документа до скасування лота
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення скасування лота
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  lot_cancellation
  Звірити відображення поля description документа ${USERS.users['${tender_owner}']['lot_cancellation_data']['document']['doc_id']} до скасування ${USERS.users['${tender_owner}']['lot_cancellation_data']['cancellation_id']} із ${USERS.users['${tender_owner}']['lot_cancellation_data']['description']} для користувача ${viewer}


Відображення заголовку документа до скасування лота
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення скасування лота
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  lot_cancellation
  Звірити відображення поля title документа ${USERS.users['${tender_owner}']['lot_cancellation_data']['document']['doc_id']} до скасування ${USERS.users['${tender_owner}']['lot_cancellation_data']['cancellation_id']} із ${USERS.users['${tender_owner}']['lot_cancellation_data']['document']['doc_name']} для користувача ${viewer}


Відображення вмісту документа до скасування лота
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення скасування лота
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  lot_cancellation
  Звірити відображення вмісту документа ${USERS.users['${tender_owner}']['lot_cancellation_data']['document']['doc_id']} до скасування ${USERS.users['${tender_owner}']['lot_cancellation_data']['cancellation_id']} з ${USERS.users['${tender_owner}']['lot_cancellation_data']['document']['doc_content']} для користувача ${viewer}

##############################################################################################
#             TENDER CANCELLATION
##############################################################################################

Можливість скасувати тендер
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Скасування тендера
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  tender_cancellation
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість скасувати тендер


Відображення активного статусу скасування тендера
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення скасування тендера
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_cancellation
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  ${cancellation_index}=  Отримати останній індекс  cancellations  ${tender_owner}  ${viewer}
  Звірити поле тендера із значенням  ${viewer}  ${TENDER['TENDER_UAID']}
  ...      active
  ...      cancellations[${cancellation_index}].status


Відображення причини скасування тендера
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення скасування тендера
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_cancellation
  ${cancellation_index}=  Отримати останній індекс  cancellations  ${tender_owner}  ${viewer}
  Звірити поле тендера із значенням  ${viewer}  ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${tender_owner}']['tender_cancellation_data']['cancellation_reason']}
  ...      cancellations[${cancellation_index}].reason


Відображення опису документа до скасування тендера
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення скасування тендера
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_cancellation
  Звірити відображення поля description документа ${USERS.users['${tender_owner}']['tender_cancellation_data']['document']['doc_id']} до скасування ${USERS.users['${tender_owner}']['tender_cancellation_data']['cancellation_id']} із ${USERS.users['${tender_owner}']['tender_cancellation_data']['description']} для користувача ${viewer}


Відображення заголовку документа до скасування тендера
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення скасування тендера
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_cancellation
  Звірити відображення поля title документа ${USERS.users['${tender_owner}']['tender_cancellation_data']['document']['doc_id']} до скасування ${USERS.users['${tender_owner}']['tender_cancellation_data']['cancellation_id']} із ${USERS.users['${tender_owner}']['tender_cancellation_data']['document']['doc_name']} для користувача ${viewer}


Відображення вмісту документа до скасування тендера
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення скасування тендера
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_cancellation
  Звірити відображення вмісту документа ${USERS.users['${tender_owner}']['tender_cancellation_data']['document']['doc_id']} до скасування ${USERS.users['${tender_owner}']['tender_cancellation_data']['cancellation_id']} з ${USERS.users['${tender_owner}']['tender_cancellation_data']['document']['doc_content']} для користувача ${viewer}

##############################################################################################
#             DELETING LOT
##############################################################################################

Неможливість видалення лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      delete_lot
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Run Keyword And Expect Error  *  Можливість видалення 1 лоту


*** Keywords ***
Можливість скасувати тендер
  ${cancellation_data}=  Підготувати дані про скасування
  Run As  ${tender_owner}
  ...      Скасувати закупівлю
  ...      ${TENDER['TENDER_UAID']}
  ...      ${cancellation_data['cancellation_reason']}
  ...      ${cancellation_data['document']['doc_path']}
  ...      ${cancellation_data['description']}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  tender_cancellation_data=${cancellation_data}


Можливість скасувати ${index} лот
  ${cancellation_data}=  Підготувати дані про скасування
  ${lot_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].initial_data.data.lots[${index}]}
  Run As  ${tender_owner}
  ...      Скасувати лот
  ...      ${TENDER['TENDER_UAID']}
  ...      ${lot_id}
  ...      ${cancellation_data['cancellation_reason']}
  ...      ${cancellation_data['document']['doc_path']}
  ...      ${cancellation_data['description']}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  lot_cancellation_data=${cancellation_data}


Звірити відображення поля ${field} документа ${doc_id} до скасування ${cancel_id} із ${left} для користувача ${username}
  ${right}=  Run As  ${username}  Отримати інформацію із документа до скасування  ${TENDER['TENDER_UAID']}  ${cancel_id}  ${doc_id}  ${field}
  Порівняти об'єкти  ${left}  ${right}


Звірити відображення вмісту документа ${doc_id} до скасування ${cancel_id} з ${left} для користувача ${username}
  ${file_name}=  Run as  ${username}  Отримати документ до скасування  ${TENDER['TENDER_UAID']}  ${cancel_id}  ${doc_id}
  ${right}=  Get File  ${OUTPUT_DIR}${/}${file_name}
  Порівняти об'єкти  ${left}  ${right}
