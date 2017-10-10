*** Settings ***
Resource        base_keywords.robot
Resource        resource.robot
Suite Setup     Test Suite Setup
Suite Teardown  Test Suite Teardown
Library         Selenium2Library

*** Variables ***
@{USED_ROLES}  tender_owner  viewer  provider  provider1  provider2
${dutch_amount}  xpath=(//div[@id='stage-sealedbid-dutch-winner']//span[@class='label-price ng-binding'])
${sealedbid_amount}  xpath=(//div[contains(concat(' ', normalize-space(@class), ' '), ' sealedbid-winner ')]//span[@class='label-price ng-binding'])


*** Test Cases ***
Можливість знайти закупівлю по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук тендера
  ...      tender_owner  viewer  provider  provider1  provider2
  ...      ${USERS.users['${viewer}'].broker}
  ...      ${USERS.users['${provider}'].broker}
  ...      ${USERS.users['${provider1}'].broker}
  ...      ${USERS.users['${provider2}'].broker}
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      find_tender
  Завантажити дані про тендер
  Можливість знайти тендер по ідентифікатору для усіх користувачів


Відображення початкової вартості лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Отримати дані із поля value.amount тендера для усіх користувачів


Відображення типу оголошеного лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view
  Отримати дані із поля procurementMethodType тендера для усіх користувачів


Відображення закінчення періоду прийому пропозицій лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view_tenderPeriod  level2
  Отримати дані із поля tenderPeriod.endDate тендера для усіх користувачів

##############################################################################################
#             AUCTION
##############################################################################################

Відображення дати початку аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних аукціону
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Дочекатись дати початку періоду аукціону  ${viewer}  ${TENDER['TENDER_UAID']}
  Отримати дані із тендера  ${viewer}  ${TENDER['TENDER_UAID']}  auctionPeriod.startDate  ${TENDER['LOT_ID']}


Можливість дочекатися початку аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Процес аукціону
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      auction
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Дочекатись дати початку аукціону  ${viewer}


Можливість дочекатись голландської частини аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Процес аукціону
  ...      viewer  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}
  ...      ${USERS.users['${provider}'].broker}
  ...      auction
  Дочекатись завершення паузи перед першим раундом


Можливість подати пропозицію другим учасником
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      make_bid_by_provider1_before_dutch  level1
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати цінову пропозицію користувачем ${provider1}


Можливість завантажити фінансову ліцензію до пропозиції другим учасником
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      make_bid_by_provider1_before_dutch
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider1}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість завантажити фінансову ліцензію в пропозицію користувачем ${provider1}


Можливість долучитись до аукціону другим учасником
  [Tags]   ${USERS.users['${provider1}'].broker}: Процес аукціону
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      make_bid_by_provider1_before_dutch
  Можливість вичитати посилання на аукціон для ${provider1}
  Відкрити сторінку аукціону для ${provider1}


Можливість зробити заявку першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Процес аукціону
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      auction
  Переключитись на учасника  ${provider}
  Зробити заявку


Можливість подати пропозицію другим учасником після визначення переможця голландської частини
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      make_bid_by_provider1_after_dutch  level1
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати цінову пропозицію користувачем ${provider1}


Можливість завантажити фінансову ліцензію до пропозиції другим учасником
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      make_bid_by_provider1_after_dutch
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider1}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість завантажити фінансову ліцензію в пропозицію користувачем ${provider1}


Можливість долучитись до аукціону другим учасником після визначення переможця голландської частини
  [Tags]   ${USERS.users['${provider1}'].broker}: Процес аукціону
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      make_bid_by_provider1_after_dutch
  Можливість вичитати посилання на аукціон для ${provider1}
  Відкрити сторінку аукціону для ${provider1}


Можливість дочекатись Sealed Bid частини аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Процес аукціону
  ...      viewer  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}
  ...      ${USERS.users['${provider}'].broker}
  ...      ${USERS.users['${provider1}'].broker}
  ...      auction
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Дочекатись дати закінчення прийому пропозицій  ${provider1}  ${TENDER['TENDER_UAID']}
  Дочекатись завершення паузи перед Sealed Bid етапом


Можливість зробити ставку другим учасником
  [Tags]   ${USERS.users['${provider1}'].broker}: Процес аукціону
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      make_bid_by_provider1_during_sealedbid
  Переключитись на учасника  ${provider1}
  Подати більшу ставку, ніж переможець голландської частини


Можливість дочекатись Best Bid частини
  [Tags]   ${USERS.users['${viewer}'].broker}: Процес аукціону
  ...      viewer  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}
  ...      ${USERS.users['${provider}'].broker}
  ...      ${USERS.users['${provider1}'].broker}
  ...      make_bid_by_dutch_winner
  Дочекатись паузи перед Best Bid етапом
  Дочекатись завершення паузи перед Best Bid етапом


Можливість збільшити ставку переможцем голландської частини
  [Tags]   ${USERS.users['${provider}'].broker}: Процес аукціону
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      make_bid_by_dutch_winner
  Переключитись на учасника   ${provider}
  Підвищити ставку переможцем голландської частини


Можливість дочекатися завершення аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Процес аукціону
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      auction
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Дочекатись дати закінчення аукціону


Відображення дати завершення аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних аукціону
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Отримати дані із тендера  ${viewer}  ${TENDER['TENDER_UAID']}  auctionPeriod.endDate  ${TENDER['LOT_ID']}


*** Keywords ***
Дочекатись дати початку аукціону
  [Arguments]  ${username}
  ${auctionStart}=  Отримати дані із тендера   ${username}  ${TENDER['TENDER_UAID']}   auctionPeriod.startDate  ${TENDER['LOT_ID']}
  wait_and_write_to_console  ${auctionStart}
  Оновити LAST_MODIFICATION_DATE
  Дочекатись синхронізації з майданчиком  ${username}


Можливість вичитати посилання на аукціон для ${username}
  ${url}=  Run Keyword If  '${username}' == '${viewer}'  Run As  ${viewer}  Отримати посилання на аукціон для глядача  ${TENDER['TENDER_UAID']}  ${TENDER['LOT_ID']}
  ...      ELSE  Run As  ${username}  Отримати посилання на аукціон для учасника  ${TENDER['TENDER_UAID']}  ${TENDER['LOT_ID']}
  Should Be True  '${url}'
  Should Match Regexp  ${url}  ^https?:\/\/auction(?:-sandbox)?\.ea\.openprocurement\.org\/insider-auctions\/([0-9A-Fa-f]{32})
  Log  URL: ${url}
  [return]  ${url}


Відкрити сторінку аукціону для ${username}
  ${url}=  Можливість вичитати посилання на аукціон для ${username}
  Open browser  ${url}  ${USERS.users['${username}'].browser}  ${username}
  Set Window Position  @{USERS['${username}']['position']}
  Set Window Size      @{USERS['${username}']['size']}
  Capture Page Screenshot
  Run Keyword Unless  '${username}' == '${viewer}'
  ...      Run Keywords
  ...      Wait Until Page Contains       Дякуємо за використання нашої системи електронних закупівель
  ...      AND
  ...      Click Element                  confirm
  Capture Page Screenshot


Дочекатись завершення паузи перед першим раундом
  Відкрити сторінку аукціону для ${viewer}
  Дочекатись паузи перед першим раундом глядачем
  Дочекатись завершення паузи перед першим раундом для користувачів


Дочекатись дати закінчення аукціону
  Переключитись на учасника  ${viewer}
  Wait Until Keyword Succeeds  61 times  30 s  Page should contain  Аукціон завершився


Дочекатись паузи перед першим раундом глядачем
  ${status}  ${_}=  Run Keyword And Ignore Error  Page should contain  Очікування
  Run Keyword If  '${status}' == 'PASS'
  ...      Run Keywords
  ...      Дочекатись дати початку аукціону  ${viewer}
  ...      AND
  ...      Wait Until Keyword Succeeds  15 times  10 s  Page should contain  до початку етапу


Дочекатись паузи перед ${stage_name} етапом
  Переключитись на учасника  ${viewer}
  Wait Until Page Contains  → ${stage_name}  15 min
  :FOR    ${username}    IN    ${provider}  ${provider1}
  \   Переключитись на учасника   ${username}
  \   Wait Until Page Contains  → ${stage_name}  30 s


Дочекатись завершення паузи перед ${stage_name} етапом
  Переключитись на учасника  ${viewer}
  Wait Until Page Does Not Contain  → ${stage_name}  15 min
  :FOR    ${username}    IN    ${provider}  ${provider1}
  \   Переключитись на учасника   ${username}
  \   Wait Until Page Does Not Contain  → ${stage_name}  30 s


Дочекатись завершення паузи перед першим раундом для користувачів
  Відкрити сторінку аукціону для ${provider}
  Переключитись на учасника  ${viewer}
  Wait Until Page Does Not Contain  → Голландського  2 min
  Переключитись на учасника  ${provider}
  Wait Until Page Does Not Contain  → Голландського  30 s


Переключитись на учасника
  [Arguments]  ${username}
  Switch Browser  ${username}


Зробити заявку
  Wait Until Page Contains Element  id=place-bid-button
  Click Element  id=place-bid-button
  Wait Until Page Contains  Ви


Подати більшу ставку, ніж переможець голландської частини
  Поставити ставку  1  Заявку прийнято  ${dutch_amount}


Підвищити ставку переможцем голландської частини
  Поставити ставку  1  Заявку прийнято  ${sealedbid_amount}


Поставити ставку
  [Arguments]  ${step}  ${msg}  ${locator}
  Wait Until Page Contains Element  ${locator}
  ${last_amount}=  Get Text  ${locator}
  ${last_amount}=  convert_amount_string_to_float  ${last_amount}
  ${amount}=  Evaluate  ${last_amount}+${step}
  ${input_amount}=  Convert To String  ${amount}
  Input Text  id=bid-amount-input  ${input_amount}
  Capture Page Screenshot
  Click Element  id=place-bid-button
  Wait Until Page Contains  ${msg}  10s
  Capture Page Screenshot
