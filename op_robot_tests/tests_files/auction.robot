*** Settings ***
Resource        keywords.robot
Resource        resource.robot
Suite Setup     Test Suite Setup
Suite Teardown  Test Suite Teardown

*** Variables ***
${role}         viewer
${broker}       Quinta


*** Test Cases ***
Пошук позапорогового однопредметного тендера по ідентифікатору
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
  Викликати для учасника  ${viewer}  Отримати інформацію із тендера  auctionPeriod.startDate


Очікування початку аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Очікування аукціону
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Дочекатись дати початку аукціону  ${viewer}

Очікування завершення аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Очікування аукціону
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  sleep  1500

Відображення дати закінчення аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Викликати для учасника  ${viewer}  Отримати інформацію із тендера  auctionPeriod.endDate
