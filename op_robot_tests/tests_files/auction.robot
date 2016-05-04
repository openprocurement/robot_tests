*** Settings ***
Resource        keywords.robot
Resource        resource.robot
Suite Setup     Test Suite Setup
Suite Teardown  Test Suite Teardown


*** Variables ***
@{used_roles}   viewer  provider  provider1

*** Test Cases ***
Можливість знайти закупівлю по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук тендера по ідентифікатору
  ...      ${USERS.users['${viewer}'].broker}
  Завантажити дані про тендер
  Run As  ${viewer}  Пошук тендера по ідентифікатору   ${TENDER['TENDER_UAID']}

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
  Дочекатись дати початку аукціону  ${viewer}


Можливість вичитати посилання на аукціон для глядача
  [Tags]   ${USERS.users['${viewer}'].broker}: Участь в аукціоні
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  [Setup]  Дочекатись дати закінчення прийому пропозицій  ${viewer}
  ${url}=  Викликати для учасника  ${viewer}  Отримати посилання на аукціон для глядача  ${TENDER['TENDER_UAID']}  ${TENDER['LOT_ID']}
  Should Be True  '${url}'
  Should Match Regexp  ${url}  ^https?:\/\/auction(?:-sandbox)?\.openprocurement\.org\/tenders\/([0-9A-Fa-f]{32})
  Log  URL аукціону для глядача: ${url}


Можливість вичитати посилання на участь в аукціоні для першого учасника
  [Tags]   ${USERS.users['${provider}'].broker}: Участь в аукціоні
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  ${url}=  Викликати для учасника  ${provider}  Отримати посилання на аукціон для учасника  ${TENDER['TENDER_UAID']}  ${TENDER['LOT_ID']}
  Should Be True  '${url}'
  Should Match Regexp  ${url}  ^https?:\/\/auction(?:-sandbox)?\.openprocurement\.org\/tenders\/([0-9A-Fa-f]{32})
  Log  URL аукціону для першого учасника: ${url}


Можливість вичитати посилання на участь в аукціоні для другого учасника
  [Tags]   ${USERS.users['${provider1}'].broker}: Участь в аукціоні
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider1}
  ${url}=  Викликати для учасника  ${provider1}  Отримати посилання на аукціон для учасника  ${TENDER['TENDER_UAID']}  ${TENDER['LOT_ID']}
  Should Be True  '${url}'
  Should Match Regexp  ${url}  ^https?:\/\/auction(?:-sandbox)?\.openprocurement\.org\/tenders\/([0-9A-Fa-f]{32})
  Log  URL аукціону для другого учасника: ${url}


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
  [Setup]  Дочекатись синхронізації з майданчиком    ${viewer}
  Отримати дані із тендера  ${viewer}  auctionPeriod.endDate  ${TENDER['LOT_ID']}
