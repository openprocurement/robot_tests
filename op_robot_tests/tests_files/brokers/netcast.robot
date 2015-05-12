*** Setting ***
Library  Selenium2Screenshots
Library  String
Library  DateTime

*** Variables ***
${locator.tenderId}                  jquery=h3
${locator.title}                     jquery=tender-subject-info>div.row:contains("Назва закупівлі:")>:eq(1)>
${locator.description}               jquery=tender-subject-info>div.row:contains("Детальний опис закупівлі:")>:eq(1)>
${locator.minimalStep.amount}        jquery=tender-subject-info>div.row:contains("Мінімальний крок аукціону, грн.:")>:eq(1)>
${locator.procuringEntity.name}      jquery=customer-info>div.row:contains("Найменування:")>:eq(1)>
${locator.value.amount}              jquery=tender-subject-info>div.row:contains("Повний доступний бюджет закупівлі, грн.:")>:eq(1)>
${locator.tenderPeriod.startDate}    jquery=tender-procedure-info>div.row:contains("Початок прийому пропозицій:")>:eq(1)>
${locator.tenderPeriod.endDate}      jquery=tender-procedure-info>div.row:contains("Завершення прийому пропозицій:")>:eq(1)>
${locator.enquiryPeriod.startDate}   jquery=tender-procedure-info>div.row:contains("Початок періоду уточнень:")>:eq(1)>
${locator.enquiryPeriod.endDate}     jquery=tender-procedure-info>div.row:contains("Завершення періоду уточнень:")>:eq(1)>


*** Keywords ***
Підготувати клієнт для користувача
  [Arguments]  ${username}
  [Documentation]  Відкрити брaвзер, створити обєкт api wrapper, тощо
  Open Browser   ${BROKERS['${USERS.users['${username}'].broker}'].url}   ${USERS.users['${username}'].browser}   alias=${username}
  Set Window Position   @{USERS.users['${username}'].position}
  Set Window Size       @{USERS.users['${username}'].size}
  Log Variables

Пошук тендера по ідентифікатору
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tenderId
  ...      ${ARGUMENTS[2]} ==  id
  Switch browser   ${ARGUMENTS[0]}
  ${current_location}=   Get Location
  Run keyword if   '${BROKERS['${USERS.users['${username}'].broker}'].url}/#/tenderDetailes/${ARGUMENTS[2]}'=='${current_location}'  Reload Page
  Go to   ${BROKERS['${USERS.users['${username}'].broker}'].url}
  Wait Until Page Contains   E-TENDER - центр електронної торгівлі   10
  sleep  1
  Input Text  jquery=input[ng-change='search()']  ${ARGUMENTS[1]}
  Click Link  jquery=a[ng-click='search()']
  sleep  2
  ${last_note_id}=  Add pointy note   jquery=a[href^="#/tenderDetailes"]   Found tender with tenderID "${ARGUMENTS[1]}"   width=200  position=bottom
  sleep  1
  Remove element   ${last_note_id}
  Click Link    jquery=a[href^="#/tenderDetailes"]
  Wait Until Page Contains    ${ARGUMENTS[1]}   10
  sleep  1
  Capture Page Screenshot