*** Setting ***
Library  op_robot_tests.tests_files.service_keywords
Library  String
LIbrary  Collections
LIbrary  Selenium2Library
Library  DebugLibrary
Resource  keywords.robot
Resource  resource.robot
Suite Setup  TestCaseSetup
Suite Teardown  Close all browsers

*** Variables ***
${tender_dump_id}    0

${LOAD_BROKERS}    ['Quinta']
${LOAD_USERS}      ['Tender Viewer', 'Tender User', 'Tender User1', 'Tender Owner']

${tender_owner}  tender_owner    #Tender Owner
${provider}   Tender User
${provider1}   Tender User1
${viewer}   Tender Viewer

${item_id}       0
${question_id}   0

#Avalable roles and users

#roles: Owner, User, Viewer

#palyers:
  #E-tender
  #Prom
  #SmartTender
  #Publicbid
  #Netcast
*** Test Cases ***
Можливість оголосити однопердметний тендер
  [Tags]   ${USERS.users['${USERS.${tender_owner}}'].broker}: Можливість оголосити тендер
  Викликати для учасника     ${USERS.${tender_owner}}   Створити тендер  ${INITIAL_TENDER_DATA}
  ${LAST_MODIFICATION_DATE}=  Get Current Date
  Set Global Variable   ${LAST_MODIFICATION_DATE}

Можливасть додати тендерну документацію
  [Tags]   ${USERS.users['${USERS.${tender_owner}}'].broker}: Можливість завантажити документ
  ${access_token}=  Get Variable Value  ${TENDER_DATA.access.token}
  Викликати для учасника   ${USERS.${tender_owner}}  Завантажити документ  ${access_token}

Можливість подати скаргу на умови
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість подати скаргу на умови
  Викликати для учасника   ${provider}   Подати скаргу    ${TENDER_DATA.data.id}   ${COMPLAINTS[0]}
  ${LAST_MODIFICATION_DATE}=  Get Current Date
  Set Global Variable   ${LAST_MODIFICATION_DATE}
  отримати останні зміни в тендері

Можливість побачити скаргу користувачем
  [Tags]   ${USERS.users['${provider}'].broker}: Відображення основних даних оголошеного тендера
  Викликати для учасника   ${provider}   порівняти скаргу  ${TENDER_DATA.data.id}   ${COMPLAINTS[0]}

можливість побачити скаргу анонімом
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Викликати для учасника    ${viewer}  порівняти скаргу  ${TENDER_DATA.data.id}   ${COMPLAINTS[0]}

Пошук однопредметного тендера по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук тендера по ідентифікатору
  #Switch Browser  ${viewer}
  Дочекатись синхронізації з майданчиком    ${viewer}
  Викликати для учасника   ${viewer}   Пошук тендера по ідентифікатору   ${TENDER_DATA.data.tenderID}   ${TENDER_DATA.data.id}

######
#Відображення основних  даних оголошеного тендера:
#заголовок, опис, бюджет, тендерна документація, 
#procuringEntity, періоди уточнень/прийому-пропозицій, мінімального кроку

Відображення заголовоку оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Звірити поле тендера   ${viewer}  title

Відображення опису оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Звірити поле тендера   ${viewer}  description

Відображення бюджету оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Звірити поле тендера   ${viewer}  value.amount

Відображення tenderID оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Звірити поле тендера   ${viewer}  tenderID

Відображення procuringEntity.name оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Звірити поле тендера   ${viewer}  procuringEntity.name

Відображення початоку періоду уточнення оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Звірити поле тендера  ${viewer}  enquiryPeriod.startDate

Відображення закінчення періоду уточнення оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Звірити поле тендера  ${viewer}  enquiryPeriod.endDate

Відображення початоку періоду прийому пропозицій оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Звірити поле тендера   ${viewer}  tenderPeriod.startDate

Відображення закінчення періоду прийому пропозицій оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Звірити поле тендера  ${viewer}  tenderPeriod.endDate

Відображення мінімального кроку оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Звірити поле тендера   ${viewer}  minimalStep.amount

Відображення тендерної документації оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  отримати останні зміни в тендері
  Звірити поле тендера   ${viewer}   documents.title
  #documents.format
  #documents.url
  #documents.datePublished
  #documents.dateModified
  #documents.id

Можливість редагувати однопредметний тендер
  [Tags]   ${USERS.users['${USERS.${tender_owner}}'].broker}: Можливість оголосити тендер
  Викликати для учасника   ${USERS.${tender_owner}}   Внести зміни в тендер     ${TENDER_DATA.data.id}   description     description

Можливість додати позицію закупівлі в тендер
  [Tags]   ${USERS.users['${USERS.${tender_owner}}'].broker}: Можливість оголосити тендер
  Викликати для учасника   ${USERS.${tender_owner}}   додати предмети закупівлі    ${TENDER_DATA.data.id}   3

Можливість видалити позиції закупівлі тендера
  [Tags]   ${USERS.users['${USERS.${tender_owner}}'].broker}: Можливість оголосити тендер
  Викликати для учасника   ${USERS.${tender_owner}}   додати предмети закупівлі    ${TENDER_DATA.data.id}   2

#######
#Відображення однопредметного тендера
#приедмет закупівлі, кількість, класифікатори, строки поставки, місце поставки

Відображення опису позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[${item_id}].description

Відображення дати доставки позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера  ${viewer}  items[${item_id}].deliveryDate.endDate

Відображення координат широти доставки позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[${item_id}].deliveryLocation.latitude

Відображення координат довготи доставки позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[${item_id}].deliveryLocation.longitude

Відображення назви нас. пункту доставки позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[${item_id}].deliveryAddress.countryName

Відображення пошт коду доставки позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[${item_id}].deliveryAddress.postalCode

Відображення регіону доставки позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[${item_id}].deliveryAddress.region

Відображення locality адреси доставки позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[${item_id}].deliveryAddress.locality

Відображення вулиці доставки позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[${item_id}].deliveryAddress.streetAddress

Відображення схеми класифікації позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[${item_id}].classification.scheme

Відображення ідентифйікатора класифікації позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[${item_id}].classification.id

Відображення опису класифікації позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[${item_id}].classification.description

Відображення схеми додаткової класифікації позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[${item_id}].additionalClassifications.scheme

Відображення ідентифікатора додаткової класифікації позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[${item_id}].additionalClassifications.id

Відображення опису додаткової класифікації позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[${item_id}].additionalClassifications.description

Відображення назви одиниці позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[${item_id}].unit.name

Відображення коду одиниці позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[${item_id}].unit.code

Відображення кількості позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[${item_id}].quantity

#######
#Відображення анонімного питання без відповідей

Задати питання
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість задати запитання
  Викликати для учасника   ${provider}  Задати питання  ${TENDER_DATA.data.id}   ${questions[${question_id}]}
  ${LAST_MODIFICATION_DATE}=  Get Current Date
  Set Global Variable   ${LAST_MODIFICATION_DATE}
  отримати останні зміни в тендері

Відображення заголовоку анонімного питання без відповіді
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення анонімного питання без відповідей
  Дочекатись синхронізації з майданчиком    ${viewer}
  Викликати для учасника   ${viewer}   обновити сторінку з тендером   ${TENDER_DATA.data.tenderID}   ${TENDER_DATA.data.id}
  Звірити поле тендера   ${viewer}  questions[${question_id}].title

Відображення опис анонімного питання без відповіді
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення анонімного питання без відповідей
  Звірити поле тендера   ${viewer}  questions[${question_id}].description

Відображення дати анонімного питання без відповіді
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення анонімного питання без відповідей
  Звірити поле тендера   ${viewer}  questions[${question_id}].date

Неможливість подати цінову пропозицію до початку періоду подачі пропозицій bidder1
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість подати цінову пропозицію
  ${bid}=  test bid data
  Log   ${bid}
  ${biddingresponce1}=  Викликати для учасника   ${provider}   Подати цінову пропозицію  shouldfail  ${TENDER_DATA.data.id}   ${bid}

#######
#Відображення відповіді на запитання
#
Відповісти на запитання
  [Tags]   ${USERS.users['${USERS.tender_owner}'].broker}: Можливість відповісти на запитання
  Викликати для учасника   ${USERS.tender_owner}   Відповісти на питання    ${TENDER_DATA.data.id}  0  ${ANSWERS[0]}
  ${LAST_MODIFICATION_DATE}=  Get Current Date
  Set Global Variable   ${LAST_MODIFICATION_DATE}
  отримати останні зміни в тендері

Відображення відповіді на запитання
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення відповіді на запитання
  Дочекатись синхронізації з майданчиком    ${viewer}
  Викликати для учасника   ${viewer}   обновити сторінку з тендером   ${TENDER_DATA.data.tenderID}   ${TENDER_DATA.data.id}
  Звірити поле тендера   ${viewer}  questions[${item_id}].answer

Можливість побачити скаргу користувачем під час періоду уточнень
  [Tags]   ${USERS.users['${provider}'].broker}: Відображення основних даних оголошеного тендера
  Викликати для учасника   ${provider}   порівняти скаргу  ${TENDER_DATA.data.id}   ${COMPLAINTS[0]}

можливість побачити скаргу анонімом під час періоду уточнень
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Викликати для учасника    ${viewer}  порівняти скаргу  ${TENDER_DATA.data.id}   ${COMPLAINTS[0]}

Подати цінову пропозицію bidder1
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість подати цінову пропозицію
  Дочекатись дати початоку прийому пропозицій
  ${bid}=  test bid data
  Log  ${bid}
  ${biddingresponce1}=  Викликати для учасника   ${provider}   Подати цінову пропозицію   ${TENDER_DATA.data.id}   ${bid}
  Set Global Variable   ${biddingresponce1}
  log  ${biddingresponce1}

Можливість змінити цінову пропозицію до 50000
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість змінити цінову пропозицію
  Set To Dictionary  ${biddingresponce1.data.value}   amount   50000
  Log   ${biddingresponce1.data.value}
  ${biddingresponce2}=  Викликати для учасника   ${provider}   Змінити цінову пропозицію   ${TENDER_DATA.data.id}   ${biddingresponce1}
  Set Global Variable   ${biddingresponce2}
  log  ${biddingresponce2}

Можливість змінити цінову пропозицію до 1
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість змінити цінову пропозицію
  Set To Dictionary  ${biddingresponce1.data.value}   amount   1
  Log   ${biddingresponce1.data.value}
  ${biddingresponce3}=  Викликати для учасника   ${provider}   Змінити цінову пропозицію   ${TENDER_DATA.data.id}   ${biddingresponce1}
  Set Global Variable   ${biddingresponce3}
  log  ${biddingresponce3}

Завантажити документ першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість прийняти пропозицію переможця
  log   ${USERS.users['${provider}'].broker}
  log  ${biddingresponce1}
  ${bid_id}=  get variable value  ${biddingresponce1.data.id}
  ${token1}=  Get Variable Value  ${biddingresponce1.access.token}
  log  ${token1}
  Викликати для учасника   ${provider}  Завантажити документ в ставку    ${token1}  ${bid_id}

#Можливість змінити документацію цінової пропозиції

Можливість скасувати цінову пропозицію
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість скасувати цінову пропозицію
  ${biddingresponce4}=  Викликати для учасника   ${provider}   скасувати цінову пропозицію   ${TENDER_DATA.data.id}   ${biddingresponce1}
  Set Global Variable   ${biddingresponce4}
  log  ${biddingresponce4}

Неможливість задати запитання після закінчення періоду уточнень
  [Documentation]
  ...    "shouldfail" argument as first switches the behaviour of keyword and "Викликати для учасника" to "fail if passed"
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість задати запитання
  ${resp}=  Викликати для учасника   ${provider}  Задати питання   shouldfail   ${TENDER_DATA.data.id}   ${questions[${question_id}]}

Подати цінову пропозицію bidder2
  [Tags]   ${USERS.users['${provider1}'].broker}: Можливість подати цінову пропозицію
  Дочекатись дати початоку прийому пропозицій
  ${bid}=  test bid data
  Log  ${bid}
  ${biddingresponce5}=  Викликати для учасника   ${provider1}   Подати цінову пропозицію   ${TENDER_DATA.data.id}   ${bid}
  Set Global Variable   ${biddingresponce5}
  log  ${biddingresponce5}

Неможливість побачити цінові пропозиції учасників під час прийому пропозицій
  [Tags]   ${USERS.users['${viewer}'].broker}: Можливість подати цінову пропозицію
  ${field_date}=  Викликати для учасника    ${viewer}   отримати інформацію із тендера  B

Завантажити документ другим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість прийняти пропозицію переможця
  log   ${USERS.users['${provider1}'].broker}
  ${bid_id2}=   get variable value   ${biddingresponce5.data.id}
  ${token2}=  Get Variable Value  ${biddingresponce5.access.token}
  log  ${token2}
  Викликати для учасника   ${provider1}  Завантажити документ в ставку   ${token2}  ${bid_id2}

Можливість побачити скаргу користувачем під час подачі пропозицій
  [Tags]   ${USERS.users['${provider}'].broker}: Відображення основних даних оголошеного тендера
  Викликати для учасника   ${provider}   порівняти скаргу  ${TENDER_DATA.data.id}   ${COMPLAINTS[0]}

можливість побачити скаргу анонімом під час подачі пропозицій
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Викликати для учасника    ${viewer}  порівняти скаргу  ${TENDER_DATA.data.id}   ${COMPLAINTS[0]}