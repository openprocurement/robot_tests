*** Settings ***
Resource        keywords.robot
Resource        resource.robot
Suite Setup     Test Suite Setup
Suite Teardown  Test Suite Teardown

*** Variables ***
@{USED_ROLES}   tender_owner  viewer


*** Test Cases ***
Можливість знайти лот по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук тендера по ідентифікатору
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_cancellation
  Завантажити дані про тендер
  Run As  ${viewer}  Пошук тендера по ідентифікатору   ${TENDER['TENDER_UAID']}

##############################################################################################
#             TENDER CANCELLATION
##############################################################################################

Можливість скасувати лот
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Скасування лоту
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  tender_cancellation
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість скасувати тендер


Відображення активного статусу скасування лоту
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення скасування лоту
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_cancellation
  Звірити статус скасування тендера  ${viewer}  ${TENDER['TENDER_UAID']}


Відображення статусу скасованого лоту
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення статусу скасування тендера
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_cancellation
  Звірити статус скасованого лоту  ${viewer}  ${TENDER['TENDER_UAID']}


Відображення причини скасування лоту
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення скасування лоту
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_cancellation
  Звірити поле тендера із значенням  ${viewer}  ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${tender_owner}']['cancellation_data']['cancellation_reason']}
  ...      cancellations[0].reason


Відображення опису документа до скасування лоту
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення скасування лоту
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_cancellation_description
  Звірити відображення поля description документа до скасування ${USERS.users['${tender_owner}']['cancellation_data']['document']['doc_id']} із ${USERS.users['${tender_owner}']['cancellation_data']['description']} для користувача ${viewer}


Відображення заголовку документа до скасування лоту
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення скасування лоту
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_cancellation_title
  Звірити відображення поля title документа до скасування ${USERS.users['${tender_owner}']['cancellation_data']['document']['doc_id']} із ${USERS.users['${tender_owner}']['cancellation_data']['document']['doc_name']} для користувача ${viewer}


Відображення вмісту документа до скасування лоту
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення скасування лоту
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_cancellation_doc_content
  Звірити відображення вмісту документа до скасування ${USERS.users['${tender_owner}']['cancellation_data']['document']['doc_id']} з ${USERS.users['${tender_owner}']['cancellation_data']['document']['doc_content']} для користувача ${viewer}


*** Keywords ***
Можливість скасувати тендер
  ${cancellation_data}=  Підготувати дані про скасування  ${tender_owner}
  Run As  ${tender_owner}
  ...      Скасувати закупівлю
  ...      ${TENDER['TENDER_UAID']}
  ...      ${cancellation_data['cancellation_reason']}
  ...      ${cancellation_data['document']['doc_path']}
  ...      ${cancellation_data['description']}


Можливість скасувати лот
  ${cancellation_data}=  Підготувати дані про скасування  ${tender_owner}
  Run As  ${tender_owner}
  ...      Скасувати лот
  ...      ${TENDER['TENDER_UAID']}
  ...      ${TENDER['LOT_ID']}
  ...      ${cancellation_data['cancellation_reason']}
  ...      ${cancellation_data['document']['doc_path']}
  ...      ${cancellation_data['description']}


Звірити відображення поля ${field} документа до скасування ${doc_id} із ${left} для користувача ${username}
  ${right}=  Run As  ${username}  Отримати інформацію із документа  ${TENDER['TENDER_UAID']}  ${doc_id}  ${field}
  Порівняти об'єкти  ${left}  ${right}


Звірити відображення вмісту документа до скасування ${doc_id} з ${left} для користувача ${username}
  ${file_name}=  Run as  ${username}  Отримати документ до скасування  ${TENDER['TENDER_UAID']}  ${doc_id}
  ${right}=  Get File  ${OUTPUT_DIR}${/}${file_name}
  Порівняти об'єкти  ${left}  ${right}
