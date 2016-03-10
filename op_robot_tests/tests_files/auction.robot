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
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${auctionEnd}=  add_minutes_to_date  ${USERS.users['${viewer}'].tender_data.data.auctionPeriod.startDate}  21
  Дочекатись дати  ${auctionEnd}  # auction time for two bids

Відображення дати закінчення аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком    ${viewer}
  Викликати для учасника  ${viewer}  Отримати інформацію із тендера  auctionPeriod.endDate
