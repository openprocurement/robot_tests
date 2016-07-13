*** Settings ***
Resource        keywords.robot
Resource        resource.robot
Suite Setup     Test Suite Setup
Suite Teardown  Test Suite Teardown

*** Variables ***
@{used_roles}   tender_owner  viewer


*** Test Cases ***
Можливість знайти закупівлю по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук тендера по ідентифікатору
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_cancelation  lot_cancelation  delete_lot
  Завантажити дані про тендер
  Run As  ${viewer}  Пошук тендера по ідентифікатору   ${TENDER['TENDER_UAID']}

##############################################################################################
#             TENDER CANCELLATION
##############################################################################################
Можливість скасувати тендер
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Скасування тендера
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  tender_cancelation
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість скасувати тендер


Відображення активного статусу скасування тендера
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення скасування тендера
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_cancelation
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Відображення активного статусу скасування


Відображення причини скасування тендера
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення скасування тендера
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_cancelation
  Відображення причини скасування


Відображення опису документа скасування тендера
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення скасування тендера
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_cancelation
  Відображення опису документа скасування


Відображення заголовку документа скасування тендера
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення скасування тендера
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_cancelation
  Відображення заголовку документа скасування

##############################################################################################
#             LOT CANCELLATION
##############################################################################################

Можливість скасувати лот
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Скасування лота
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  lot_cancelation
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість скасувати лот


Відображення активного статусу скасування лота
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення скасування лота
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  lot_cancelation
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Відображення активного статусу скасування


Відображення причини скасування лота
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення скасування лота
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  lot_cancelation
  Відображення причини скасування


Відображення опису документа скасування лота
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення скасування лота
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  lot_cancelation
  Відображення опису документа скасування


Відображення заголовку документа скасування лота
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення скасування лота
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  lot_cancelation
  Відображення заголовку документа скасування

##############################################################################################
#             DELETING LOT
##############################################################################################

Неможливість видалення лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      delete_lot
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Require Failure  ${tender_owner}  Видалити лот  ${TENDER['TENDER_UAID']}  ${TENDER['LOT_ID']}


*** Keywords ***
Можливість скасувати тендер
  ${cancellation_data}=  Підготувати дані про скасування  ${tender_owner}
  Run As  ${tender_owner}
  ...      Скасувати закупівлю
  ...      ${TENDER['TENDER_UAID']}
  ...      ${cancellation_data['cancellation_reason']}
  ...      ${cancellation_data['filename']}
  ...      ${cancellation_data['description']}


Можливість скасувати лот
  ${cancellation_data}=  Підготувати дані про скасування  ${tender_owner}
  Run As  ${tender_owner}
  ...      Скасувати лот
  ...      ${TENDER['TENDER_UAID']}
  ...      ${TENDER['LOT_ID']}
  ...      ${cancellation_data['cancellation_reason']}
  ...      ${cancellation_data['filepath']}
  ...      ${cancellation_data['description']}


Відображення активного статусу скасування
  Звірити поле тендера із значенням  ${viewer}  ${TENDER['TENDER_UAID']}
  ...      active
  ...      cancellations[0].status


Відображення причини скасування
  Звірити поле тендера із значенням  ${viewer}  ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${tender_owner}']['cancellation_data']['cancellation_reason']}
  ...      cancellations[0].reason


Відображення опису документа скасування
  Звірити поле тендера із значенням  ${viewer}  ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${tender_owner}']['cancellation_data']['description']}
  ...      cancellations[0].documents[0].description


Відображення заголовку документа скасування
  Звірити поле тендера із значенням  ${viewer}  ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${tender_owner}']['cancellation_data']['filename']}
  ...      cancellations[0].documents[0].title
