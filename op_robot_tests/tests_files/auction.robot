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
  ...      ${USERS.users['${viewer}'].broker}
  Завантажити дані про тендер
  Викликати для учасника  ${viewer}  Пошук тендера по ідентифікатору   ${TENDER['TENDER_UAID']}

##############################################################################################
#             AUCTION
##############################################################################################

Відображення дати початку аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком    ${viewer}
  Отримати дані із тендера  ${viewer}  auctionPeriod.startDate  ${TENDER['LOT_ID']}


Можливість дочекатися початку аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Можливість дочекатися початку аукціону
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Дочекатись дати початку аукціону  ${viewer}  ${TENDER['LOT_ID']}


Можливість дочекатися завершення аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Можливість дочекатися завершення аукціону
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Відкрити сторінку аукціону для глядача
  Wait Until Keyword Succeeds  61 times  30 s  Page should contain  Аукціон завершився
  Wait Until Keyword Succeeds  5 times  30 s  Page should not contain  очікуємо розкриття учасників
  Close browser


Відображення дати завершення аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Отримати дані із тендера  ${viewer}  auctionPeriod.endDate  ${TENDER['LOT_ID']}


*** Keywords ***
Відкрити сторінку аукціону для глядача
  ${url}=  Run as  ${viewer}  Отримати посилання на аукціон для глядача  ${TENDER['TENDER_UAID']}  ${TENDER['LOT_ID']}
  Open browser  ${url}  ${USERS.users['${viewer}'].browser}
