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
#  ${last_note_id}=  Add pointy note   jquery=a[href^="#/tenderDetailes"]   Found tender with tenderID "${ARGUMENTS[1]}"   width=200  position=bottom
#  sleep  1
#  Remove element   ${last_note_id}
  Click Link    jquery=a[href^="#/tenderDetailes"]
  Wait Until Page Contains    ${ARGUMENTS[1]}   10
  sleep  1
  Capture Page Screenshot

Оновити сторінку з тендером
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tenderId
  ...      ${ARGUMENTS[2]} ==  id
  ${current_location}=   Get Location
  Run keyword if   '${BROKERS['${USERS.users['${username}'].broker}'].url}/#/tenderDetailes/${ARGUMENTS[2]}'=='${current_location}'  Reload Page
  Run keyword unless   '${BROKERS['${USERS.users['${username}'].broker}'].url}/#/tenderDetailes/${ARGUMENTS[2]}'=='${current_location}'  Пошук тендера по ідентифікатору   @{ARGUMENTS}
  Wait Until Page Contains    ${ARGUMENTS[1]}   10
  sleep  1

отримати інформацію із тендера
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  fieldname
  Switch browser   ${ARGUMENTS[0]}
  ${return_value}=  run keyword  отримати інформацію про ${ARGUMENTS[1]}
  [return]  ${return_value}

Відмітити на сторінці поле з тендера
  [Arguments]   ${fieldname}  ${locator}
  ${last_note_id}=  Add pointy note   ${locator}   Found ${fieldname}   width=200  position=bottom
  Align elements horizontally    ${locator}   ${last_note_id}
  sleep  1
  Remove element   ${last_note_id}

Отримати тест із поля і показати на сторінці
  [Arguments]   ${fieldname}
  sleep  3
#  відмітити на сторінці поле з тендера   ${fieldname}   ${locator.${fieldname}}
  ${return_value}=   Get Text  ${locator.${fieldname}}
  [return]  ${return_value}

отримати інформацію про tenderId
  ${return_value}=   Отримати тест із поля і показати на сторінці   tenderId
  [return]  ${return_value.split(' ')[1]}

отримати інформацію про title
  ${return_value}=   Отримати тест із поля і показати на сторінці   title
  [return]  ${return_value}

отримати інформацію про description
   ${return_value}=   Отримати тест із поля і показати на сторінці   description
  [return]  ${return_value}

отримати інформацію про minimalStep.amount
  ${return_value}=   Отримати тест із поля і показати на сторінці   minimalStep.amount
  ${return_value}=   Convert To Number   ${return_value.split(' ')[0]}
  [return]  ${return_value}

отримати інформацію про procuringEntity.name
  ${return_value}=   Отримати тест із поля і показати на сторінці   procuringEntity.name
  [return]  ${return_value}


отримати інформацію про value.amount
  ${return_value}=   Отримати тест із поля і показати на сторінці  value.amount
  ${return_value}=   Evaluate   "".join("${return_value}".split(' ')[:-3])
  ${return_value}=   Convert To Number   ${return_value}
  [return]  ${return_value}

отримати інформацію про tenderPeriod.startDate
  ${return_value}=   Отримати тест із поля і показати на сторінці  tenderPeriod.startDate
  [return]  ${return_value}

отримати інформацію про tenderPeriod.endDate
  ${return_value}=   Отримати тест із поля і показати на сторінці  tenderPeriod.endDate
  [return]  ${return_value}

отримати інформацію про enquiryPeriod.startDate
  ${return_value}=   Отримати тест із поля і показати на сторінці  enquiryPeriod.startDate
  [return]  ${return_value}

отримати інформацію про enquiryPeriod.endDate
  ${return_value}=   Отримати тест із поля і показати на сторінці  enquiryPeriod.endDate
  [return]  ${return_value}


отримати інформацію про items[${item_id}].description
  відмітити на сторінці поле з тендера   items[${item_id}].description   jquery=tender-subject-info.ng-isolate-scope>div.row:contains("Детальний опис предмету закупівлі:")>:eq(1)>
  ${return_value}=   Get Text  jquery=tender-subject-info.ng-isolate-scope>div.row:contains("Детальний опис предмету закупівлі:")>:eq(1)>
  [return]  ${return_value}

отримати інформацію про items[${item_id}].quantity
  відмітити на сторінці поле з тендера   items[${item_id}].quantity   jquery=tender-subject-info.ng-isolate-scope>div.row:contains("Кількість:")>:eq(1)>
  ${return_value}=   Get Text  jquery=tender-subject-info.ng-isolate-scope>div.row:contains("Кількість:")>:eq(1)>
  ${return_value}=  Convert To Number   ${return_value}
  [return]  ${return_value}

отримати інформацію про items[${item_id}].classification.id
  відмітити на сторінці поле з тендера   items[0].classification.id   jquery=tender-subject-info>div.row:contains("Класифікатор CPV:")>:eq(1)>
  ${return_value}=   Get Text  jquery=tender-subject-info>div.row:contains("Класифікатор CPV:")>:eq(1)>
  [return]  ${return_value.split(' ')[0]}

отримати інформацію про items[${item_id}].classification.scheme
  відмітити на сторінці поле з тендера   items[0].classification.id   jquery=tender-subject-info>div.row:contains("CPV")>:eq(1)>
  ${return_value}=   Get Text  jquery=tender-subject-info>div.row:contains("CPV")>:eq(1)>
  [return]  ${return_value.split(' ')[0]}

отримати інформацію про items[${item_id}].classification.description
  відмітити на сторінці поле з тендера   classification.description   jquery=tender-subject-info>div.row:contains("Класифікатор CPV:")>:eq(1)>
  ${return_value}=   Get Text  jquery=tender-subject-info>div.row:contains("Класифікатор CPV:")>:eq(1)>
  ${return_value}=   catenate  @{return_value.split(' ')[1:]}
  [return]  ${return_value}

отримати інформацію про items[${item_id}].deliveryAddress
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[${item_id}].deliveryAddress
  [return]  ${return_value}

отримати інформацію про items[${item_id}].deliveryDate
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[${item_id}].deliveryDate
  [return]  ${return_value}

отримати інформацію про questions[${question_id}].title
  відмітити на сторінці поле з тендера   questions title   jquery=tender-questions>div:eq(1)>div.row:contains("Тема:")>:eq(1)>
  ${return_value}=   Get Text  jquery=tender-questions>div:eq(1)>div.row:contains("Тема:")>:eq(1)>
  [return]  ${return_value}

отримати інформацію про questions[${question_id}].description
  відмітити на сторінці поле з тендера   questions description   jquery=tender-questions>div:eq(1)>div.row:contains("Питання:")>:eq(1)>
  ${return_value}=   Get Text  jquery=tender-questions>div:eq(1)>div.row:contains("Питання:")>:eq(1)>
  [return]  ${return_value}

отримати інформацію про questions[${question_id}].date
  відмітити на сторінці поле з тендера   question date   jquery=tender-questions>div:eq(1)>div.row:contains("Дата:")>:eq(1)>
  ${return_value}=   Get Text  jquery=tender-questions>div:eq(1)>div.row:contains("Дата:")>:eq(1)>
  [return]  ${return_value}

отримати інформацію про questions[${question_id}].answer
  відмітити на сторінці поле з тендера   question answer   jquery=tender-questions>div:eq(1)>div:last>
  ${return_value}=   Get Text  jquery=tender-questions>div:eq(1)>div:last>
  [return]  ${return_value}
