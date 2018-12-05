*** Settings ***
Resource        keywords.robot
Resource        base_keywords.robot
Suite Setup     Test Suite Setup
Suite Teardown  Test Suite Teardown


*** Variables ***
@{USED_ROLES}   viewer  provider  provider1


*** Test Cases ***
Можливість знайти лот по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук лоту
  ...      ${USERS.users['${viewer}'].broker}
  ...      find_tender
  Завантажити дані про тендер
  Run As  ${viewer}  Пошук тендера по ідентифікатору   ${TENDER['TENDER_UAID']}

##############################################################################################
#             AUCTION
##############################################################################################

Відображення закінчення періоду уточнень аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних аукціону
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view
  Отримати дані із поля enquiryPeriod.endDate тендера для користувача ${viewer}


Відображення дати початку аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних аукціону
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view
  [Setup]  Дочекатись дати закінчення періоду уточнень  ${viewer}  ${TENDER['TENDER_UAID']}
  Дочекатись дати початку періоду аукціону  ${viewer}  ${TENDER['TENDER_UAID']}
  Отримати дані із тендера  ${viewer}  ${TENDER['TENDER_UAID']}  auctionPeriod.startDate


Можливість дочекатися початку аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Процес аукціону
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      auction
  Дочекатись дати початку аукціону  ${viewer}


Можливість дочекатись першого раунду
  [Tags]   ${USERS.users['${viewer}'].broker}: Процес аукціону
  ...      viewer  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}
  ...      ${USERS.users['${provider}'].broker}
  ...      ${USERS.users['${provider1}'].broker}
  ...      auction
  Дочекатись перший раунд всіма користувачами


Можливість вибрати мову
  [Tags]   ${USERS.users['${viewer}'].broker}: Процес аукціону
  ...      viewer  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}
  ...      ${USERS.users['${provider}'].broker}
  ...      ${USERS.users['${provider1}'].broker}
  ...      auction
  Змінити мову аукціону


Погодитись на запропоновану ставку першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Процес аукціону
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      auction
  Переключитись на учасника  ${provider}
  Погодитись на запропоновану ставку


Можливість дочекатись другого раунду
  [Tags]   ${USERS.users['${viewer}'].broker}: Процес аукціону
  ...      viewer  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}
  ...      ${USERS.users['${provider}'].broker}
  ...      ${USERS.users['${provider1}'].broker}
  ...      auction
  Дочекатись паузи перед наступним раундом
  Дочекатись завершення паузи перед наступним раундом
  Перевірити результати 1 раунду


Підвищити ставку другим учасником
  [Tags]   ${USERS.users['${provider1}'].broker}: Процес аукціону
  ...      provider
  ...      ${USERS.users['${provider1}'].broker}
  ...      auction
  Переключитись на учасника  ${provider1}
  Обрати ставку з випадаючого меню


Можливість дочекатись третього раунду
  [Tags]   ${USERS.users['${viewer}'].broker}: Процес аукціону
  ...      viewer  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}
  ...      ${USERS.users['${provider}'].broker}
  ...      ${USERS.users['${provider1}'].broker}
  ...      auction
  Дочекатись паузи перед наступним раундом
  Дочекатись завершення паузи перед наступним раундом
  Перевірити результати 2 раунду


Погодитись на ставку першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Процес аукціону
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      auction
  Переключитись на учасника  ${provider}
  Погодитись на запропоновану ставку


Можливість дочекатись четвертого раунду
  [Tags]   ${USERS.users['${viewer}'].broker}: Процес аукціону
  ...      viewer  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}
  ...      ${USERS.users['${provider}'].broker}
  ...      ${USERS.users['${provider1}'].broker}
  ...      auction
  Дочекатись паузи перед наступним раундом
  Дочекатись завершення паузи перед наступним раундом
  Перевірити результати 3 раунду


Можливість дочекатися завершення аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Процес аукціону
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      auction
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Дочекатись дати закінчення аукціону користувачем ${viewer}


Перевірити результати аукціону
  [Tags]   ${USERS.users['${provider}'].broker}: Процес аукціону
  ...      viewer
  ...      ${USERS.users['${provider}'].broker}
  ...      auction
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${winner}=  Run As  ${provider}  Отримати інформацію із пропозиції  ${TENDER['TENDER_UAID']}  tenderers[0].name
  Перевірити результати аукціону  ${winner}


Відображення дати завершення аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних аукціону
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      auction_end_date
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Отримати дані із тендера  ${viewer}  ${TENDER['TENDER_UAID']}  auctionPeriod.endDate


*** Keywords ***
Дочекатись дати початку аукціону
  [Arguments]  ${username}
  wait_and_write_to_console  ${USERS.users['${viewer}'].tender_data.data.auctionPeriod.startDate}
  Оновити LAST_MODIFICATION_DATE
  Дочекатись синхронізації з майданчиком  ${username}


Відкрити сторінку аукціону для ${username}
  ${url}=  Можливість вичитати посилання на аукціон для ${username}
  Open browser  ${url}    ${USERS.users['${username}'].browser}  ${username}
  Set Window Position     @{USERS['${username}']['position']}
  Set Window Size         @{USERS['${username}']['size']}
  Run Keyword Unless     '${username}' == '${viewer}'
  ...      Run Keywords
  ...      Wait Until Page Contains    Дякуємо за використання електронної торгової системи ProZorro.Продажі
  ...      AND
  ...      Click Element               confirm


Дочекатись перший раунд всіма користувачами
  :FOR  ${username}  IN  ${viewer}  ${provider}  ${provider1}
  \  Відкрити сторінку аукціону для ${username}
  \  Page Should Contain  до завершення раунду


Можливість вичитати посилання на аукціон для ${username}
  ${url}=  Run Keyword If  '${username}' == '${viewer}'  Run As  ${viewer}  Отримати посилання на аукціон для глядача  ${TENDER['TENDER_UAID']}
  ...      ELSE  Run As  ${username}  Отримати посилання на аукціон для учасника  ${TENDER['TENDER_UAID']}
  Should Be True  '${url}'
  Should Match Regexp  ${url}  ^https?:\/\/sandbox\.ea2\.openprocurement\.auction\/texas-auctions\/([0-9A-Fa-f]{32})
  Log  URL: ${url}
  [return]  ${url}


Переключитись на учасника
  [Arguments]  ${username}
  Switch Browser  ${username}
  ${CURRENT_USER}=  Set Variable  ${username}
  Set Global Variable  ${CURRENT_USER}


Змінити мову аукціону
  :FOR  ${username}  IN  ${viewer}  ${provider}  ${provider1}
  \  Переключитись на учасника  ${username}
  \  Вибрати мову


Вибрати мову
  Click Element              xpath=(//div[@class='clock-container__burger-icon'])
  Wait Until Page Contains   Browser ID
  Wait Until Page Contains   Session ID
  Wait Until Page Contains   Стартова ціна
  Click Element              Русский
  Wait Until Page Contains   Шаг увеличение торгов
  Click Element              Українська
  Wait Until Page Contains   Крок зростання торгів
  Click Element              English
  Wait Until Page Contains   Step auction of Bid
  Click Element              xpath=(//div[@class='clock-container__burger-icon'])


Погодитись на запропоновану ставку
  Wait Until Page Contains Element    xpath=(//button[contains(text(),'Accept')])
  ${bid_amount}=  Get Text            xpath=(//h3[@class='approval-mount'])
  Set Suite Variable                  ${bid_amount}
  Click Element                       xpath=(//button[contains(text(),'Accept')])


Дочекатись паузи перед наступним раундом
  :FOR    ${username}    IN    ${viewer}  ${provider}  ${provider1}
  \  Переключитись на учасника  ${username}
  \  Wait Until Page Contains   until the round starts  4 s
  \  Capture Page Screenshot


Дочекатись завершення паузи перед наступним раундом
  :FOR    ${username}    IN    ${viewer}  ${provider}  ${provider1}
  \  Переключитись на учасника  ${username}
  \  Wait Until Page Contains   until the round ends  200 s
  \  Capture Page Screenshot


Обрати ставку з випадаючого меню
  Wait Until Page Contains Element   xpath=(//input[@class='search arrow-false'])
  Click Element                      xpath=(//input[@class='search arrow-false'])
  ${list_values}=  Get WebElements   xpath=(//li[@class='autocomplete-result'])
  ${value}=  Evaluate  random.choice($list_values)  modules=random
  ${bid_amount}=  Get Text           ${value}
  ${bid_amount}=  format_amount      ${bid_amount}
  Set Suite Variable                 ${bid_amount}
  Click Element                      ${value}
  Click Element                      xpath=(//button[contains(text(),'Announce')])


Перевірити результати ${index} раунду
  Element Should Contain    xpath=(//div[@class='list-rounds-container']//div[${index}]/div/div[2]/h4)    ${bid_amount}


Дочекатись дати закінчення аукціону користувачем ${username}
  Переключитись на учасника   ${viewer}
  Wait Until Keyword Succeeds  10 times  30 s  Page should contain  Auction is completed by the licitator
  Page should contain  Sold


Перевірити результати аукціону
  [Arguments]    ${winner}
  Wait Until Page Contains  Announcement
  ${winner_name}=  Convert To Uppercase  ${winner}
  Element Should Contain    xpath=(//div[@class='round-container_participant-expended round-container_participant-expended_max'])    ${winner_name}