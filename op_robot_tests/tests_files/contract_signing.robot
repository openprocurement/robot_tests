*** Settings ***
Resource        keywords.robot
Resource        resource.robot
Suite Setup     Test Suite Setup
Suite Teardown  Test Suite Teardown

*** Variables ***
@{USED_ROLES}   tender_owner  viewer


*** Test Cases ***
Можливість знайти закупівлю по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук тендера
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      find_tender  level1
  Завантажити дані про тендер
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \   Run As  ${username}  Пошук тендера по ідентифікатору   ${TENDER['TENDER_UAID']}

##############################################################################################
#             CONTRACT
##############################################################################################

Відображення закінчення періоду подачі скарг на пропозицію
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Відображення основних даних тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      tender_view
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \  Отримати дані із тендера  ${username}  ${TENDER['TENDER_UAID']}  awards[-1].complaintPeriod.endDate


Об'єднати можливі контракти
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Об'єднати можливі контракти
  ...     tender_owner
  ...     ${USERS.users['${tender_owner}'].broker}
  ...     merge_contracts
  ${base_identifire_id}=  Get Variable Value  ${USERS.users['${tender_owner}'].tender_data.data.contracts[-1].suppliers[0].identifier.id}
  ${base_identifire_scheme}=  Get Variable Value  ${USERS.users['${tender_owner}'].tender_data.data.contracts[-1].suppliers[0].identifier.scheme}
  ${contract_id}=  Get Variable Value  ${USERS.users['${tender_owner}'].tender_data.data.contracts[-1].id}
  ${additional_awards}=  Run as  ${tender_owner}  Отримати всі id виграшів з однаковими identifier  ${TENDER['TENDER_UAID']}  ${base_identifire_id}  ${base_identifire_scheme}  ${contract_id}
  Log  ${additional_awards}
  Run As  ${tender_owner}  Об'єднати контракти  ${TENDER['TENDER_UAID']}  ${contract_id}  ${additional_awards}


Дочекатися закічення stand still періоду
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Процес укладання угоди
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      contract_sign
  ${standstillEnd}=  Get Variable Value  ${USERS.users['${tender_owner}'].tender_data.data.awards[-1].complaintPeriod.endDate}
  Дочекатись дати  ${standstillEnd}


Можливість укласти угоду для закупівлі
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес укладання угоди
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  contract_sign  level1
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Run As  ${tender_owner}  Підтвердити підписання контракту  ${TENDER['TENDER_UAID']}  -1


Відображення статусу підписаної угоди з постачальником закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення основних даних угоди
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  contract_sign
  [Setup]  Дочекатись синхронізації з майданчиком    ${viewer}
  Run As  ${viewer}  Оновити сторінку з тендером  ${TENDER['TENDER_UAID']}
  Звірити поле тендера із значенням  ${viewer}  ${TENDER['TENDER_UAID']}  active  contracts[-1].status
