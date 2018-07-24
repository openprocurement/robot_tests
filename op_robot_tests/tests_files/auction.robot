*** Settings ***
Resource        base_keywords.robot
Resource        resource.robot
Suite Setup     Test Suite Setup
Suite Teardown  Test Suite Teardown


*** Variables ***
@{USED_ROLES}   viewer


*** Test Cases ***
Можливість знайти закупівлю по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук тендера
  ...      ${USERS.users['${viewer}'].broker}
  ...      find_tender  level1
  Завантажити дані про тендер
  Run As  ${viewer}  Пошук тендера по ідентифікатору   ${TENDER['TENDER_UAID']}

##############################################################################################
#             AUCTION
##############################################################################################

Відображення заголовку лотів
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення лоту тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      lot_view
  ...      critical
  Отримати дані із тендера  ${viewer}  ${TENDER['TENDER_UAID']}  title  ${TENDER['LOT_ID']}


Відображення дати початку аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних аукціону
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view  level2
  [Setup]  Отримати дані із тендера   ${viewer}  ${TENDER['TENDER_UAID']}   tenderPeriod.endDate
  Дочекатись дати закінчення прийому пропозицій  ${viewer}  ${TENDER['TENDER_UAID']}
  Дочекатись дати початку періоду аукціону  ${viewer}  ${TENDER['TENDER_UAID']}
  Run Keyword If  ${NUMBER_OF_LOTS} == 0
  ...      Отримати дані із тендера  ${viewer}  ${TENDER['TENDER_UAID']}  auctionPeriod.startDate
  ...      ELSE
  ...      Отримати дані із тендера  ${viewer}  ${TENDER['TENDER_UAID']}  auctionPeriod.startDate  ${TENDER['LOT_ID']}

Можливість дочекатися початку аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Процес аукціону
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      auction
  Дочекатись дати початку аукціону  ${viewer}


Можливість вичитати посилання на аукціон для глядача
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних аукціону
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      auction  level1
  Можливість вичитати посилання на аукціон для ${viewer}


Можливість дочекатися завершення аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Процес аукціону
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      auction
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Дочекатись дати закінчення аукціону користувачем ${viewer}


Відображення дати завершення аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних аукціону
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Run Keyword If  ${NUMBER_OF_LOTS} == 0
  ...      Отримати дані із тендера  ${viewer}  ${TENDER['TENDER_UAID']}  auctionPeriod.endDate
  ...      ELSE
  ...      Отримати дані із тендера  ${viewer}  ${TENDER['TENDER_UAID']}  auctionPeriod.endDate  ${TENDER['LOT_ID']}


*** Keywords ***
Дочекатись дати початку аукціону
  [Arguments]  ${username}
  # Can't use that dirty hack here since we don't know
  # the date of auction when creating the procurement :)
  ${auctionStart}=  Run Keyword If  ${NUMBER_OF_LOTS} == 0
  ...     Отримати дані із тендера   ${username}  ${TENDER['TENDER_UAID']}   auctionPeriod.startDate
  ...     ELSE
  ...     Отримати дані із тендера   ${username}  ${TENDER['TENDER_UAID']}   auctionPeriod.startDate  ${TENDER['LOT_ID']}
  Дочекатись дати  ${auctionStart}
  Оновити LAST_MODIFICATION_DATE
  Дочекатись синхронізації з майданчиком  ${username}


Можливість вичитати посилання на аукціон для ${username}
  ${url}=  Run As  ${username}  Отримати посилання на аукціон для глядача  ${TENDER['TENDER_UAID']}  ${TENDER['LOT_ID']}
  Should Be True  '${url}'
  Should Match Regexp  ${url}  ${AUCTION_REGEXP}
  Log  URL аукціону для глядача: ${url}


Відкрити сторінку аукціону для ${username}
  ${url}=  Run as  ${username}  Отримати посилання на аукціон для глядача  ${TENDER['TENDER_UAID']}  ${TENDER['LOT_ID']}
  Open browser  ${url}  ${USERS.users['${username}'].browser}


Дочекатись дати закінчення аукціону користувачем ${username}
  Відкрити сторінку аукціону для ${username}
  ${status}  ${_}=  Run Keyword And Ignore Error  Wait Until Keyword Succeeds  61 times  30 s  Page should contain  Аукціон завершився
  Run Keyword If  '${status}' == 'FAIL'
  ...      Run Keywords
  ...      Отримати дані із тендера  ${username}  ${TENDER['TENDER_UAID']}  auctionPeriod.startDate  ${TENDER['LOT_ID']}
  ...      AND
  ...      Дочекатись дати початку аукціону  ${username}
  ...      AND
  ...      Дочекатись дати закінчення аукціону користувачем ${username}
  ...      ELSE
  ...      Run Keywords
  ...      Wait Until Keyword Succeeds  5 times  30 s  Page should not contain  очікуємо розкриття учасників
  ...      AND
  ...      Close browser
