*** Settings ***
Resource        keywords.robot
Resource        resource.robot
Suite Setup     Test Suite Setup
Suite Teardown  Test Suite Teardown
Library         DebugLibrary
Library        op_robot_tests.tests_files.service_keywords

*** Variables ***
${USERS}
@{used_roles}  viewer  provider  provider1


*** Test Cases ***

Можливість знайти закупівлю по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук тендера
  ...      ${USERS.users['${viewer}'].broker}
  ...      find_tender
  Завантажити дані про тендер
  Run As  ${viewer}  Пошук тендера по ідентифікатору   ${TENDER['TENDER_UAID']}

##############################################################################################
#             AUCTION
##############################################################################################

Відображення дати початку аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних аукціону
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view
  [Setup]  Дочекатись дати закінчення прийому пропозицій  ${viewer}  ${TENDER['TENDER_UAID']}
  Дочекатись дати початку періоду аукціону  ${viewer}  ${TENDER['TENDER_UAID']}
  Отримати дані із тендера  ${viewer}  ${TENDER['TENDER_UAID']}  auctionPeriod.startDate  ${TENDER['LOT_ID']}


Можливість дочекатися початку аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Процес аукціону
  ...      viewer  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}
  ...      auction
  Дочекатись дати початку аукціону  ${viewer}


Можливість вичитати посилання на аукціон
  [Tags]   ${USERS.users['${viewer}'].broker}: Процес аукціону
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      auction
  Можливість вичитати посилання на аукціон для учасника ${provider}
  Можливість вичитати посилання на аукціон для учасника ${provider1}
  Можливість вичитати посилання на аукціон для глядача ${viewer}


Можливість дочекатись першого раунду
  [Tags]   ${USERS.users['${viewer}'].broker}: Процес аукціону
  ...      viewer  provider  provider1
  ...      auction
  Відкрити сторінку аукціону для глядача  ${viewer}
  Дочекатись паузи перед першим раундом  ${viewer}
  Дочекатись завершення паузи перед першим раундом  ${viewer}
  Відкрити сторінку аукціону для учасника  ${provider}
  Відкрити сторінку аукціону для учасника  ${provider1}


Можливість проведення 1 го раунду аукціону для учасників
  [Tags]   ${USERS.users['${provider}'].broker}: Процес аукціону
  ...      provider  provider1
  ...      ${USERS.users['${provider}'].broker}
  ...      auction
  Вибрати учасника, який може зробити ставку
  Поставити максимально можливу ставку
  Дочекатистись учасником закінчення стадії ставок
  Перевірити чи ставка була прийнята
  Вибрати учасника, який може зробити ставку
  Поставити ставку більшу від максимальної на 1 грн
  Поставити максимально можливу ставку
  Дочекатистись учасником закінчення стадії ставок


Можливість дочекатись другого раунду
  [Tags]   ${USERS.users['${viewer}'].broker}: Процес аукціону
  ...      viewer
  ...      auction
  Переключитись на учасника  ${viewer}
  Дочекатись завершення паузи перед раундом  ${viewer}


Можливість проведення 2 го раунду аукціону для учасників
  [Tags]   ${USERS.users['${provider}'].broker}: Процес аукціону
  ...      provider  provider1
  ...      ${USERS.users['${provider}'].broker}
  ...      auction
  Вибрати учасника, який може зробити ставку
  Поставити малу ставку в 1 грн
  Відмінитити ставку
  Поставити максимально можливу ставку
  Дочекатистись учасником закінчення стадії ставок
  Вибрати учасника, який може зробити ставку
  Поставити максимально можливу ставку
  Дочекатистись учасником закінчення стадії ставок


Можливість дочекатись третього раунду
  [Tags]   ${USERS.users['${viewer}'].broker}: Процес аукціону
  ...      viewer
  ...      auction
  Переключитись на учасника  ${viewer}
  Дочекатись завершення паузи перед раундом  ${viewer}


Можливість проведення 3 го раунду аукціону для учасників
  [Tags]   ${USERS.users['${provider}'].broker}: Процес аукціону
  ...      provider  provider1
  ...      ${USERS.users['${provider}'].broker}
  ...      auction
  Вибрати учасника, який може зробити ставку
  Поставити нульову ставку
  Поставити максимально можливу ставку
  Дочекатистись учасником закінчення стадії ставок
  Вибрати учасника, який може зробити ставку
  Поставити малу ставку в 1 грн
  Змінити ставку на максимальну
  Дочекатистись учасником закінчення стадії ставок


Можливість дочекатися завершення аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Процес аукціону
  ...      viewer
  ...      auction
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Переключитись на учасника  ${viewer}
  Дочекатись дати закінчення аукціону для ${viewer}


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
  # Can't use that dirty hack here since we don't know
  # the date of auction when creating the procurement :)
  ${auctionStart}=  Отримати дані із тендера   ${username}  ${TENDER['TENDER_UAID']}   auctionPeriod.startDate  ${TENDER['LOT_ID']}
  Дочекатись дати  ${auctionStart}
  Оновити LAST_MODIFICATION_DATE
  Дочекатись синхронізації з майданчиком  ${username}


Можливість вичитати посилання на аукціон для глядача ${username}
  ${url}=  Run As  ${username}  Отримати посилання на аукціон для глядача  ${TENDER['TENDER_UAID']}  ${TENDER['LOT_ID']}
  Should Be True  '${url}'
  Should Match Regexp  ${url}  ^https?:\/\/auction(?:-sandbox)?\.openprocurement\.org\/tenders\/([0-9A-Fa-f]{32})
  Log  URL аукціону для глядача: ${url}


Можливість вичитати посилання на аукціон для учасника ${username}
  ${url}=  Run As  ${username}  Отримати посилання на аукціон для учасника  ${TENDER['TENDER_UAID']}  ${TENDER['LOT_ID']}
  Should Be True  '${url}'
  Should Match Regexp  ${url}  ^https?:\/\/auction(?:-sandbox)?\.openprocurement\.org\/tenders\/([0-9A-Fa-f]{32})
  Log  URL аукціону для глядача: ${url}


Відкрити сторінку аукціону для глядача
  [Arguments]  ${username}
  ${url}=  Run as  ${username}  Отримати посилання на аукціон для глядача  ${TENDER['TENDER_UAID']}  ${TENDER['LOT_ID']}
  Open browser  ${url}  ${USERS.users['${username}'].browser}  ${username}
  Set Window Position   @{USERS['${username}']['position']}
  Set Window Size       @{USERS['${username}']['size']}

Відкрити сторінку аукціону для учасника
  [Arguments]  ${username}
  ${url}=  Run as  ${username}  Отримати посилання на аукціон для учасника  ${TENDER['TENDER_UAID']}  ${TENDER['LOT_ID']}
  Open browser  ${url}  ${USERS.users['${username}'].browser}  ${username}
  Set Window Position   @{USERS['${username}']['position']}
  Set Window Size       @{USERS['${username}']['size']}
  sleep                      2s
  Click Element              xpath=//button[contains(@class, 'btn btn-success')]


Дочекатись дати закінчення аукціону для ${username}
  ${status}  ${_}=  Run Keyword And Ignore Error  Wait Until Keyword Succeeds  61 times  30 s  Page should contain  Аукціон завершився
  Run Keyword If  '${status}' == 'FAIL'
  ...      Run Keywords
  ...      Отримати дані із тендера  ${username}  ${TENDER['TENDER_UAID']}  auctionPeriod.startDate  ${TENDER['LOT_ID']}
  ...      AND
  ...      Дочекатись дати початку аукціону  ${username}
  ...      AND
  ...      Дочекатись дати закінчення аукціону для ${username}
  ...      ELSE
  ...      Run Keywords
  ...      Wait Until Keyword Succeeds  15 times  30 s  Page should not contain  Очікуємо на розкриття імен учасників
  ...      AND
  ...      Close browser


Дочекатись паузи перед першим раундом
  [Arguments]  ${username}
  ${status}  ${_}=  Run Keyword And Ignore Error  Page should contain  Очікування
  Run Keyword If  '${status}' == 'PASS'
  ...      Run Keywords
  ...      Дочекатись дати початку аукціону  ${username}
  ...      AND
  ...      Wait Until Keyword Succeeds  5 times  30 s  Page should contain   до початку раунду


Дочекатись завершення паузи перед раундом
  [Arguments]  ${username}
  ${status}  ${_}=  Run Keyword And Ignore Error  Page should contain  до початку раунду
  Run Keyword And Return If  '${status}' == 'FAIL'  Get Current Date
  ${date}=  Get Current Date
  Wait Until Keyword Succeeds  15 times  30 s  Page should not contain  до початку раунду
  ${new_date}=  Get Current Date
  ${time}=  Subtract Date From Date  ${new_date}  ${date}
  Should Be True  ${time} < 140 and ${time} > 100


Дочекатись завершення паузи перед першим раундом
  [Arguments]  ${username}
  ${status}  ${_}=  Run Keyword And Ignore Error  Page should contain  до початку раунду
  Run Keyword And Return If  '${status}' == 'FAIL'  Get Current Date
  ${date}=  Get Current Date
  Wait Until Keyword Succeeds  15 times  30 s  Page should not contain  до початку раунду
  ${new_date}=  Get Current Date
  ${time}=  Subtract Date From Date  ${new_date}  ${date}
  Should Be True  ${time} < 310 and ${time} > 270


Дочекатись глядачем закінчення стадії ставок
  ${status}  ${_}=  Run Keyword And Ignore Error  Page should contain  до закінчення раунду
  Run Keyword And Return If  '${status}' == 'FAIL'  Get Current Date
  ${date}=  Get Current Date
  Wait Until Keyword Succeeds  15 times  30 s  Page should not contain  до закінчення раунду
  ${new_date}=  Get Current Date
  ${time}=  Subtract Date From Date  ${new_date}  ${date}
  Should Be True  ${time} < 250 and ${time} > 210


Дочекатистись учасником закінчення стадії ставок
  ${status}  ${_}=  Run Keyword And Ignore Error  Page should contain    до закінчення вашої черги
  Run Keyword And Return If  '${status}' == 'PASS'
  ...      Wait Until Keyword Succeeds  5 times  30 s  Page should not contain   до закінчення вашої черги


Дочекатись оголошення результатів
  [Arguments]  ${username}
  ${status}  ${_}=  Run Keyword And Ignore Error  Page should contain  до оголошення результатів
  Run Keyword And Return If  '${status}' == 'FAIL'  Get Current Date
  ${date}=  Get Current Date
  Wait Until Keyword Succeeds  5 times  30 s  Page should not contain  до оголошення результатів
  ${new_date}=  Get Current Date
  ${time}=  Subtract Date From Date  ${new_date}  ${date}
  Should Be True  ${time} < 250 and ${time} > 210


Переключитись на учасника
  [Arguments]  ${user_id}
  Selenium2Library.Switch Browser    ${user_id}
  ${CURRENT_USER}=  set variable    ${user_id}
  Set Global Variable   ${CURRENT_USER}


Поставити максимально можливу ставку
  Wait Until Page Contains Element    id=max_bid_amount_price
  ${last_amount}=     Get Text    id=max_bid_amount_price
  Поставити ставку   ${last_amount}   Заявку прийнято


Поставити ставку більшу від максимальної на ${extra_amount} грн
  Wait Until Page Contains Element    id=max_bid_amount_price
  ${last_amount}=     Get Text    id=max_bid_amount_price
  ${last_amount}=     convert_amount_string_to_float    ${last_amount}
  ${last_amount}=    Evaluate      ${last_amount}+${extra_amount}
  Поставити ставку   ${last_amount}   Надто висока заявка


Поставити ставку
  [Arguments]    ${amount}  ${msg}
  ${amount}=   Convert To String     ${amount}
  Set To Dictionary    ${USERS['${CURRENT_USER}']}   last_amount=${amount}
  Capture Page Screenshot
  Click Element                 id=clear-bid-button
  Capture Page Screenshot
  Input Text      id=bid-amount-input      ${USERS['${CURRENT_USER}']['last_amount']}
  Sleep  3s
  Wait Until Element Is Visible    id=place-bid-button    10s
  Sleep  7s
  Capture Page Screenshot
  Click Element                id=place-bid-button
  Wait Until Page Contains     ${msg}    30s
  Capture Page Screenshot


Відмінитити ставку
  Click Element                id=cancel-bid-button
  Wait Until Page Contains     Заявку відмінено      10s


Змінити ставку на максимальну
  Click Element                id=edit-bid-button
  Click Element                id=clear-bid-button
  Поставити максимально можливу ставку


Вибрати учасника, який може зробити ставку
  :FOR    ${username}    IN    ${provider}  ${provider1}
  \   Переключитись на учасника   ${username}
  \   ${status}  ${_}=  Run Keyword And Ignore Error  Page Should Contain  до закінчення вашої черги
  \   Run Keyword If  '${status}' == 'PASS'    Exit For Loop


Поставити малу ставку в ${last_amount} грн
  Wait Until Page Contains Element    id=max_bid_amount_price
  Поставити ставку   ${last_amount}   Ви ввели дуже малу суму


Поставити нульову ставку
  Wait Until Page Contains Element    id=max_bid_amount_price
  Поставити ставку   0   Bid amount is required


Перевірити чи ставка була прийнята
  Page Should Contain   ${USERS['${CURRENT_USER}']['last_amount']}

