*** Settings ***
Resource        base_keywords.robot
Resource        resource.robot
Suite Setup     Test Suite Setup
Suite Teardown  Test Suite Teardown

*** Variables ***
@{USED_ROLES}   tender_owner  viewer
${MODE}  auctions

*** Test Cases ***
Можливість знайти процедуру по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук лоту
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      find_tender  level1
  Завантажити дані про тендер
  Можливість знайти тендер по ідентифікатору для усіх користувачів

##############################################################################################
#             CONTRACT
##############################################################################################

Можливість встановити дату підписання угоди
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування угоди
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      dateSigned
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${dateSigned}=  create_fake_dateSigned
  Set to dictionary  ${USERS.users['${tender_owner}']}  dateSigned=${dateSigned}
  Run As  ${tender_owner}  Встановити дату підписання угоди  ${TENDER['TENDER_UAID']}  -1  ${dateSigned}


Відображення дати підписання угоди
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних угоди
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      dateSigned_view
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля contracts[-1].dateSigned тендера із ${USERS.users['${tender_owner}'].dateSigned} для користувача ${viewer}


Можливість завантажити угоду до лоту
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Завантаження документів щодо угоди
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  contract_sign_upload
  [Teardown]  Оновити LMD і дочекатись синхронізації  ${tender_owner}
  ${file_path}  ${file_title}  ${file_content}=  create_fake_doc
  Run As  ${tender_owner}  Завантажити угоду до тендера  ${TENDER['TENDER_UAID']}  -1  ${file_path}
  Remove File  ${file_path}


Можливість укласти угоду для лоту
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес укладання угоди
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  contract_sign  level1
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Run As  ${tender_owner}  Підтвердити підписання контракту  ${TENDER['TENDER_UAID']}  -1


Відображення статусу підписаної угоди
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення основних даних угоди
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  contract_sign_view
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Run As  ${viewer}  Оновити сторінку з тендером  ${TENDER['TENDER_UAID']}
  Звірити поле тендера із значенням  ${viewer}  ${TENDER['TENDER_UAID']}  active  contracts[-1].status


Відображення статусу завершеної процедури
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення основних даних аукціону
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_status_complete
  Звірити статус завершення тендера  ${viewer}  ${TENDER['TENDER_UAID']}


Можливість завантажити протокол скасування контракту
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...     tender_owner
  ...     ${USERS.users['${tender_owner}'].broker}
  ...     cancel_second_contract
  [Teardown]  Оновити LMD і дочекатись синхронізації  ${tender_owner}
  Можливість завантажити протокол скасування в контракт -1 користувачем ${tender_owner}


Можливість скасувати контракт
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...     tender_owner
  ...     ${USERS.users['${tender_owner}'].broker}
  ...     cancel_second_contract
  [Teardown]  Оновити LMD і дочекатись синхронізації  ${tender_owner}
  Run As  ${tender_owner}  Скасувати контракт  ${TENDER['TENDER_UAID']}  -1


Відображення статусу скасованої угоди
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення основних даних угоди
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  second_contract_cancel_view
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Run As  ${viewer}  Оновити сторінку з тендером  ${TENDER['TENDER_UAID']}
  Звірити поле тендера із значенням  ${viewer}  ${TENDER['TENDER_UAID']}  cancelled  contracts[-1].status


Відображення статусу неуспішної процедури
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  status_unsuccessful
  Звірити cтатус неуспішного тендера  ${viewer}  ${TENDER['TENDER_UAID']}
