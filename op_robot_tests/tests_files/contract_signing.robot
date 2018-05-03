*** Settings ***
Resource        base_keywords.robot
Resource        resource.robot
Suite Setup     Test Suite Setup
Suite Teardown  Test Suite Teardown

*** Variables ***
@{USED_ROLES}   tender_owner  viewer


*** Test Cases ***
Можливість знайти лот по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук лоту
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      find_tender  level1
  Завантажити дані про тендер
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \   Run As  ${username}  Пошук тендера по ідентифікатору   ${TENDER['TENDER_UAID']}

##############################################################################################
#             CONTRACT
##############################################################################################

Можливість продовжити період підписання договору
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Продовження періоду підписання договору
  ...     tender_owner
  ...     ${USERS.users['${tender_owner}'].broker}
  ...     prolongation
  ${prolongation_data}=  Підготувати дані для пролонгації  ${tender_owner}
  Run As  ${tender_owner}  Продовжити період підписання договору  ${TENDER['TENDER_UAID']}  ${prolongation_data}  -1


Можливість завантажити протокол, що санкціонує пролонгацію
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Продовження періоду підписання договору
  ...     tender_owner
  ...     ${USERS.users['${tender_owner}'].broker}
  ...     prolongation
  [Teardown]  Оновити LMD і дочекатись синхронізації  ${tender_owner}
  Можливість завантажити протокол пролонгації в контракт -1 користувачем ${tender_owner}


Відображення номера рішення пролонгації
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення основних даних пролонгації
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     prolongation_view
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля decisionID пролонгації для користувача ${viewer}


Відображення опису пояснення причини пролонгації
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення основних даних пролонгації
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     prolongation_view
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля description пролонгації для користувача ${viewer}


Відображення дати рішення ФГВФО стосовно пролонгації
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення основних даних пролонгації
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     prolongation_view
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля datePublished пролонгації для користувача ${viewer}


Відображення причини пролонгації підписання договору
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення основних даних пролонгації
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     prolongation_view
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля reason пролонгації для користувача ${viewer}


Можливість підтвердити пролонгацію підписання договору
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Продовження періоду підписання договору
  ...     tender_owner
  ...     ${USERS.users['${tender_owner}'].broker}
  ...     prolongation
  [Teardown]  Оновити LMD і дочекатись синхронізації  ${tender_owner}
  Run As  ${tender_owner}  Підтвердити пролонгацію  ${TENDER['TENDER_UAID']}  -1


Відображення підтвердженого статусу пролонгації
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення основних даних пролонгації
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     prolongation_view
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити поле пролонганції підписання угоди із значенням
  ...     ${viewer}
  ...     ${TENDER['TENDER_UAID']}
  ...     applied
  ...     status


Можливість вказати дату отримання оплати
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес укладання угоди
  ...     tender_owner
  ...     ${USERS.users['${tender_owner}'].broker}
  ...     datePaid
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${datePaid}=  create_fake_date
  Set to dictionary  ${USERS.users['${tender_owner}']}  datePaid=${datePaid}
  Run As  ${tender_owner}  Вказати дату отримання оплати  ${TENDER['TENDER_UAID']}  -1  ${datePaid}


Відображення дати отримання оплати
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення основних даних угоди
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     datePaid
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля contracts[-1].datePaid тендера із ${USERS.users['${tender_owner}'].datePaid} для користувача ${viewer}


Можливість повторно продовжити період підписання договору
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Продовження періоду підписання договору
  ...     tender_owner
  ...     ${USERS.users['${tender_owner}'].broker}
  ...     prolongation
  ${prolongation_data}=  Підготувати дані для пролонгації  ${tender_owner}
  Run As  ${tender_owner}  Продовжити період підписання договору  ${TENDER['TENDER_UAID']}  ${prolongation_data}  -1
  Можливість завантажити протокол пролонгації в контракт -1 користувачем ${tender_owner}
  Run As  ${tender_owner}  Підтвердити пролонгацію  ${TENDER['TENDER_UAID']}  -1


Неможливість втретє продовжити період підписання договору
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Продовження періоду підписання договору
  ...     tender_owner
  ...     ${USERS.users['${tender_owner}'].broker}
  ...     prolongation
  ${prolongation_data}=  Підготувати дані для пролонгації  ${tender_owner}
  Run As  ${tender_owner}  Продовжити період підписання договору  ${TENDER['TENDER_UAID']}  ${prolongation_data}  -1
  Можливість завантажити протокол пролонгації в контракт -1 користувачем ${tender_owner}
  Require Failure  ${tender_owner}  Підтвердити пролонгацію  ${TENDER['TENDER_UAID']}  -1


Можливість завантажити угоду до лоту
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Завантаження документів щодо угоди
  ...     tender_owner
  ...     ${USERS.users['${tender_owner}'].broker}
  ...     contract_sign_upload
  [Teardown]  Оновити LMD і дочекатись синхронізації  ${tender_owner}
  ${file_path}  ${file_title}  ${file_content}=  create_fake_doc
  Run As  ${tender_owner}  Завантажити угоду до тендера  ${TENDER['TENDER_UAID']}  -1  ${file_path}
  Remove File  ${file_path}


Можливість укласти угоду для лоту
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес укладання угоди
  ...     tender_owner
  ...     ${USERS.users['${tender_owner}'].broker}
  ...     contract_sign  level1
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Run As  ${tender_owner}  Підтвердити підписання контракту  ${TENDER['TENDER_UAID']}  -1


Відображення статусу підписаної угоди
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення основних даних угоди
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     contract_sign_view
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Run As  ${viewer}  Оновити сторінку з тендером  ${TENDER['TENDER_UAID']}
  Звірити поле тендера із значенням  ${viewer}  ${TENDER['TENDER_UAID']}  active  contracts[0].status


Відображення статусу завершення лоту
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     tender_view
  Звірити статус завершення тендера  ${viewer}  ${TENDER['TENDER_UAID']}
