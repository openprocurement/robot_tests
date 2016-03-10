*** Settings ***
Resource        keywords.robot
Resource        resource.robot
Suite Setup     Test Suite Setup
Suite Teardown  Test Suite Teardown

*** Variables ***
${role}         viewer
${broker}       Quinta


*** Test Cases ***
Можливість знайти закупівлю по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук тендера по ідентифікатору
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      minimal
  Завантажити дані про тендер
  ${usernames}=  Create List  ${viewer}  ${tender_owner}
  :FOR  ${username}  IN  @{usernames}
  \   ${resp}=  Викликати для учасника  ${username}  Пошук тендера по ідентифікатору   ${TENDER['TENDER_UAID']}
  Log  ${resp}

##############################################################################################
#             CONTRACT
##############################################################################################

Відображення закінчення періоду подачі скарг на пропозицію
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Відображення основних даних оголошеного тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ${usernames}=  Create List  ${viewer}  ${tender_owner}
  :FOR  ${username}  IN  @{usernames}
  \  Викликати для учасника  ${username}  Отримати інформацію із тендера  awards[1].complaintPeriod.endDate

Дочекатися закічення stand still періоду
  ${standstillEnd}=  Get Variable Value  ${USERS.users['${tender_owner}'].tender_data.data.awards[1].complaintPeriod.endDate}
  Дочекатись дати  ${standstillEnd}

Можливість укласти угоду для закупівлі
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Можливість укласти угоду для прямої закупівлі
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  Викликати для учасника  ${tender_owner}  Підтвердити підписання контракту  ${TENDER['TENDER_UAID']}  1

Відображення статусу підписаної угоди з постачальником закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення статусу підписаної угоди з постачальником прямої закупівлі
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком    ${viewer}
  Викликати для учасника  ${viewer}  Оновити сторінку з тендером  ${TENDER['TENDER_UAID']}
  Звірити поле тендера із значенням  ${viewer}  active  contracts[1].status
