*** Settings ***
Resource        keywords.robot
Resource        resource.robot
Resource        base_keywords.robot
Suite Setup     Test Suite Setup
Suite Teardown  Test Suite Teardown


*** Variables ***
@{USED_ROLES}   viewer


*** Test Cases ***
Можливість знайти лот по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук лоту
  ...      ${USERS.users['${viewer}'].broker}
  ...      find_tender  level1
  Завантажити дані про тендер
  Run As  ${viewer}  Пошук тендера по ідентифікатору   ${TENDER['TENDER_UAID']}

##############################################################################################
#             AUCTION
##############################################################################################

Відображення закінчення періоду прийому пропозицій лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних аукціону
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view  level2
  Отримати дані із поля tenderPeriod.endDate тендера для користувача ${viewer}


Відображення дати початку аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних аукціону
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view  level2
  [Setup]  Дочекатись дати закінчення прийому пропозицій  ${viewer}  ${TENDER['TENDER_UAID']}
  Дочекатись дати початку періоду аукціону  ${viewer}  ${TENDER['TENDER_UAID']}
  Отримати дані із тендера  ${viewer}  ${TENDER['TENDER_UAID']}  auctionPeriod.startDate  ${TENDER['LOT_ID']}


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
  ...      auction_end_date
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Отримати дані із тендера  ${viewer}  ${TENDER['TENDER_UAID']}  auctionPeriod.endDate  ${TENDER['LOT_ID']}


*** Keywords ***
Дочекатись дати початку аукціону
  [Arguments]  ${username}
  # Can't use that dirty hack here since we don't know
  # the date of auction when creating the procurement :)
  ${auctionStart}=  Отримати дані із тендера   ${username}  ${TENDER['TENDER_UAID']}   auctionPeriod.startDate  ${TENDER['LOT_ID']}
  wait_and_write_to_console  ${auctionStart}
  Оновити LAST_MODIFICATION_DATE
  Дочекатись синхронізації з майданчиком  ${username}


Можливість вичитати посилання на аукціон для ${username}
  ${url}=  Run As  ${username}  Отримати посилання на аукціон для глядача  ${TENDER['TENDER_UAID']}  ${TENDER['LOT_ID']}
  Should Be True  '${url}'
  Run Keyword If  '${MODE}'=='dgfInsider'
  ...     Should Match Regexp  ${url}  ^https?:\/\/auction(?:-sandbox)?\.ea\.openprocurement\.org\/insider-auctions\/([0-9A-Fa-f]{32})
  ...     ELSE
  ...     Should Match Regexp  ${url}  ^https?:\/\/auction(?:-sandbox)?\.ea\.openprocurement\.org\/auctions\/([0-9A-Fa-f]{32})
  Log  URL аукціону для глядача: ${url}


Відкрити сторінку аукціону для ${username}
  ${url}=  Run as  ${username}  Отримати посилання на аукціон для глядача  ${TENDER['TENDER_UAID']}  ${TENDER['LOT_ID']}
  Open browser  ${url}  ${USERS.users['${username}'].browser}


Дочекатись дати закінчення аукціону користувачем ${username}
  Відкрити сторінку аукціону для ${username}
  ${status}  ${_}=  Run Keyword And Ignore Error  Wait Until Keyword Succeeds  75 times  30 s  Page should contain  Аукціон завершився
  Run Keyword If  '${status}' == 'FAIL'
  ...      Run Keywords
  ...      Отримати дані із тендера  ${username}  ${TENDER['TENDER_UAID']}  auctionPeriod.startDate  ${TENDER['LOT_ID']}
  ...      AND
  ...      Дочекатись дати початку аукціону  ${username}
  ...      AND
  ...      Дочекатись дати закінчення аукціону користувачем ${username}
  ...      ELSE
  ...      Run Keywords
  ...      Wait Until Keyword Succeeds  5 times  30 s  Page should not contain  Очікуємо на розкриття імен учасників
  ...      AND
  ...      Close browser
