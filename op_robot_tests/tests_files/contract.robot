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
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      minimal
  Завантажити дані про тендер
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \   Run As  ${username}  Пошук тендера по ідентифікатору   ${TENDER['TENDER_UAID']}

##############################################################################################
#             CONTRACT
##############################################################################################

Відображення закінчення періоду подачі скарг на пропозицію
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Відображення основних даних оголошеного тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \  Отримати дані із тендера  ${username}  awards[1].complaintPeriod.endDate


Дочекатися закічення stand still періоду
  ${standstillEnd}=  Get Variable Value  ${USERS.users['${tender_owner}'].tender_data.data.awards[1].complaintPeriod.endDate}
  Дочекатись дати  ${standstillEnd}


Можливість укласти угоду для закупівлі
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Можливість укласти угоду для прямої закупівлі
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Run As  ${tender_owner}  Підтвердити підписання контракту  ${TENDER['TENDER_UAID']}  1


Відображення статусу підписаної угоди з постачальником закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення статусу підписаної угоди з постачальником прямої закупівлі
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком    ${viewer}
  Run As  ${viewer}  Оновити сторінку з тендером  ${TENDER['TENDER_UAID']}
  Звірити поле тендера із значенням  ${viewer}  active  contracts[1].status
