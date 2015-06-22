*** Setting ***
Library  op_robot_tests.tests_files.service_keywords
Library  String
LIbrary  Collections
LIbrary  Selenium2Library
Library  DebugLibrary
Resource  keywords.robot
Resource  resource.robot
Suite Setup  TestSuiteSetup
Suite Teardown  Close all browsers

*** Variables ***
${tender_dump_id}    0
${mode}       single

${tender_owner}  Tender_Owner
${provider}   Tender_User
${provider1}   Tender_User1
${viewer}   Tender_Viewer

${LOAD_USERS}      ["${tender_owner}", "${provider}", "${provider1}", "${viewer}"]

${item_id}       0
${question_id}   0

*** Test Cases ***
Можливість оголосити однопердметний тендер
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  ${ids}=  Викликати для учасника     ${tender_owner}    Створити тендер  ${INITIAL_TENDER_DATA}
  ${TENDER_ID}=   Get From List   ${ids}  0  
  ${INTERNAL_TENDER_ID}=  Get From List   ${ids}  1 
  Set Global Variable    ${INTERNAL_TENDER_ID}
  Set Global Variable    ${TENDER_ID}
  ${LAST_MODIFICATION_DATE}=  Get Current Date
  Set Global Variable   ${LAST_MODIFICATION_DATE}

Можливасть додати тендерну документацію
  [Tags]    ${USERS.users['${tender_owner}'].broker}: Можливість завантажити документ
  Викликати для учасника   ${tender_owner}   Завантажити документ  ${INTERNAL_TENDER_ID}

Можливість подати скаргу на умови
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість подати скаргу на умови
  Викликати для учасника   ${provider}   Подати скаргу    ${INTERNAL_TENDER_ID}   ${COMPLAINTS[0]}
  ${LAST_MODIFICATION_DATE}=  Get Current Date
  Set Global Variable   ${LAST_MODIFICATION_DATE}

Можливість побачити скаргу користувачем
  [Tags]   ${USERS.users['${provider}'].broker}: Відображення основних даних оголошеного тендера
  Викликати для учасника   ${provider}   порівняти скаргу  ${INTERNAL_TENDER_ID}   ${COMPLAINTS[0]}

можливість побачити скаргу анонімом
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Викликати для учасника    ${viewer}  порівняти скаргу  ${INTERNAL_TENDER_ID}   ${COMPLAINTS[0]}

Пошук однопредметного тендера по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук тендера по ідентифікатору
  Дочекатись синхронізації з майданчиком    ${viewer}
  Викликати для учасника   ${viewer}   Пошук тендера по ідентифікатору   ${TENDER_ID}  ${INTERNAL_TENDER_ID}
  
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
  ${field_response}=  Викликати для учасника    ${viewer}   отримати інформацію із тендера  tenderID
  Should Be Equal   ${TENDER_ID}   ${field_response}   Майданчик ${USERS.users['${viewer}'].broker}

Відображення procuringEntity.name оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Звірити поле тендера   ${viewer}  procuringEntity.name

Відображення початоку періоду уточнення оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Звірити дату тендера  ${viewer}  enquiryPeriod.startDate

Відображення закінчення періоду уточнення оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Звірити дату тендера  ${viewer}  enquiryPeriod.endDate

Відображення початоку періоду прийому пропозицій оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Звірити дату тендера   ${viewer}  tenderPeriod.startDate

Відображення закінчення періоду прийому пропозицій оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Звірити дату тендера  ${viewer}  tenderPeriod.endDate

Відображення мінімального кроку оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Звірити поле тендера   ${viewer}  minimalStep.amount

Відображення тендерної документації оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Звірити поле тендера   ${viewer}   documents.title
  #documents.format
  #documents.url
  #documents.datePublished
  #documents.dateModified
  #documents.id

Можливість редагувати однопредметний тендер
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  Викликати для учасника   ${tender_owner}  Внести зміни в тендер    ${INTERNAL_TENDER_ID}   description     description

#Можливість додати позицію закупівлі в тендер
#  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
#  Викликати для учасника   ${tender_owner}   додати предмети закупівлі    ${INTERNAL_TENDER_ID}   3
#
#Можливість видалити позиції закупівлі тендера
#  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
#  Викликати для учасника   ${tender_owner}   додати предмети закупівлі   ${INTERNAL_TENDER_ID}   2

#######
#Відображення однопредметного тендера
#приедмет закупівлі, кількість, класифікатори, строки поставки, місце поставки

Відображення опису позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[${item_id}].description

Відображення дати доставки позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити дату тендера  ${viewer}  items[${item_id}].deliveryDate.endDate

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
  Викликати для учасника   ${provider}   Задати питання  ${INTERNAL_TENDER_ID}   ${QUESTIONS[${question_id}]}
  ${now}=  Get Current Date
  Set To Dictionary  ${QUESTIONS[${question_id}].data}   date   ${now}

Відображення заголовоку анонімного питання без відповіді
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення анонімного питання без відповідей
  Дочекатись синхронізації з майданчиком    ${viewer}
  Викликати для учасника   ${viewer}   обновити сторінку з тендером    ${TENDER_ID}   ${INTERNAL_TENDER_ID}   
  Звірити поле  ${viewer}   questions[${question_id}].title   ${QUESTIONS[${question_id}].data.title}

Відображення опис анонімного питання без відповіді
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення анонімного питання без відповідей
  Звірити поле  ${viewer}  questions[${question_id}].description    ${QUESTIONS[${question_id}].data.description}

Відображення дати анонімного питання без відповіді
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення анонімного питання без відповідей
  Звірити дату  ${viewer}  questions[${question_id}].date   ${QUESTIONS[${question_id}].data.date}  

Неможливість подати цінову пропозицію до початку періоду подачі пропозицій bidder1
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість подати цінову пропозицію
  ${bid}=  test bid data
  Log   ${bid}
  ${biddingresponce1}=  Викликати для учасника   ${provider}   Подати цінову пропозицію  shouldfail  ${INTERNAL_TENDER_ID}   ${bid}

#######
#Відображення відповіді на запитання
#
Відповісти на запитання
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість відповісти на запитання
  Викликати для учасника   ${tender_owner}   Відповісти на питання    ${INTERNAL_TENDER_ID}  0  ${ANSWERS[0]}
  ${now}=  Get Current Date
  Set To Dictionary  ${ANSWERS[${question_id}].data}   date   ${now}

Відображення відповіді на запитання
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення відповіді на запитання
  Дочекатись синхронізації з майданчиком    ${viewer}
  Викликати для учасника   ${viewer}   обновити сторінку з тендером   ${TENDER_ID}   ${INTERNAL_TENDER_ID}   
  Звірити поле  ${viewer}   questions[${question_id}].answer    ${ANSWERS[${question_id}].data.answer}

Можливість побачити скаргу користувачем під час періоду уточнень
  [Tags]   ${USERS.users['${provider}'].broker}: Відображення основних даних оголошеного тендера
  Викликати для учасника   ${provider}   порівняти скаргу  ${INTERNAL_TENDER_ID}   ${COMPLAINTS[0]}

можливість побачити скаргу анонімом під час періоду уточнень
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Викликати для учасника    ${viewer}  порівняти скаргу  ${INTERNAL_TENDER_ID}   ${COMPLAINTS[0]}

Подати цінову пропозицію bidder1
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість подати цінову пропозицію
  Дочекатись дати початоку прийому пропозицій
  ${bid}=  test bid data
  Log  ${bid}
  ${biddingresponce1}=  Викликати для учасника   ${provider}   Подати цінову пропозицію   ${INTERNAL_TENDER_ID}   ${bid}
  Set Global Variable   ${biddingresponce1}
  log  ${biddingresponce1}

Можливість змінити цінову пропозицію до 50000
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість змінити цінову пропозицію
  Set To Dictionary  ${biddingresponce1.data.value}   amount   50000
  Log   ${biddingresponce1.data.value}
  ${biddingresponce2}=  Викликати для учасника   ${provider}   Змінити цінову пропозицію   ${INTERNAL_TENDER_ID}   ${biddingresponce1}
  Set Global Variable   ${biddingresponce2}
  log  ${biddingresponce2}

Можливість змінити цінову пропозицію до 1
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість змінити цінову пропозицію
  Set To Dictionary  ${biddingresponce1.data.value}   amount   1
  Log   ${biddingresponce1.data.value}
  ${biddingresponce3}=  Викликати для учасника   ${provider}   Змінити цінову пропозицію   ${INTERNAL_TENDER_ID}   ${biddingresponce1}
  Set Global Variable   ${biddingresponce3}
  log  ${biddingresponce3}

Завантажити документ першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість прийняти пропозицію переможця
  log   ${USERS.users['${provider}'].broker}
  log  ${biddingresponce1}
  ${bid_id}=  get variable value  ${biddingresponce1.data.id}
  ${token1}=  Get Variable Value  ${biddingresponce1.access.token}
  log  ${token1}
  ${upload_doc_responce}=   Викликати для учасника   ${provider}  Завантажити документ в ставку    ${token1}  ${bid_id}
  Set Global Variable   ${upload_doc_responce}
  
Можливість змінити документацію цінової пропозиції
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість прийняти пропозицію переможця
  log   ${USERS.users['${provider}'].broker}
  log  ${biddingresponce1}
  ${bid_id}=  get variable value  ${biddingresponce1.data.id}
  ${token1}=  Get Variable Value  ${biddingresponce1.access.token}
  ${upload_doc_responce_id}=  get variable value  ${upload_doc_responce.data.id}
  log  ${token1} 
  Викликати для учасника   ${provider}  Змінити документ в ставці    ${token1}  ${bid_id}  ${upload_doc_responce_id}

Можливість скасувати цінову пропозицію
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість скасувати цінову пропозицію
  ${biddingresponce4}=  Викликати для учасника   ${provider}   скасувати цінову пропозицію   ${INTERNAL_TENDER_ID}   ${biddingresponce1}
  Set Global Variable   ${biddingresponce4}
  log  ${biddingresponce4}

Неможливість задати запитання після закінчення періоду уточнень
  [Documentation]
  ...    "shouldfail" argument as first switches the behaviour of keyword and "Викликати для учасника" to "fail if passed"
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість задати запитання
  ${resp}=  Викликати для учасника   ${provider}  Задати питання   shouldfail   ${INTERNAL_TENDER_ID}   ${questions[${question_id}]}

Подати цінову пропозицію bidder2
  [Tags]   ${USERS.users['${provider1}'].broker}: Можливість подати цінову пропозицію
  Дочекатись дати початоку прийому пропозицій
  ${bid}=  test bid data
  Log  ${bid}
  ${biddingresponce5}=  Викликати для учасника   ${provider1}   Подати цінову пропозицію   ${INTERNAL_TENDER_ID}   ${bid}
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
  Викликати для учасника   ${provider}   порівняти скаргу  ${INTERNAL_TENDER_ID}   ${COMPLAINTS[0]}

можливість побачити скаргу анонімом під час подачі пропозицій
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Викликати для учасника    ${viewer}  порівняти скаргу  ${INTERNAL_TENDER_ID}   ${COMPLAINTS[0]}
  

Неможливість змінити цінову пропозицію до 50000 після закінчення прийому пропозицій
  [Tags]   ${USERS.users['${provider1}'].broker}: Неможливість змінити цінову пропозицію до 50000 після закінчення прийому пропозицій
  Дочекатись дати закінчення прийому пропозицій
  Set To Dictionary  ${biddingresponce1.data.value}   amount   50000
  Log   ${biddingresponce5.data.value}
  ${biddingresponce6}=  Викликати для учасника   ${provider1}   Змінити цінову пропозицію  shouldfail  ${INTERNAL_TENDER_ID}   ${biddingresponce5}
  Set Global Variable   ${biddingresponce6}
  log  ${biddingresponce6}
 
Неможливість змінити цінову пропозицію до 1 після закінчення прийому пропозицій
  [Tags]   ${USERS.users['${provider1}'].broker}: Неможливість змінити цінову пропозицію до 1 після закінчення прийому пропозицій
  Set To Dictionary  ${biddingresponce5.data.value}   amount   1
  Log   ${biddingresponce1.data.value}
  ${biddingresponce7}=  Викликати для учасника   ${provider1}   Змінити цінову пропозицію  shouldfail  ${INTERNAL_TENDER_ID}   ${biddingresponce5}
  Set Global Variable   ${biddingresponce7}
  log  ${biddingresponce3}

Неможливість скасувати цінову пропозицію
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість скасувати цінову пропозицію
  ${biddingresponce8}=  Викликати для учасника   ${provider}   скасувати цінову пропозицію   shouldfail  ${INTERNAL_TENDER_ID}   ${biddingresponce5}
  Set Global Variable   ${biddingresponce4}
  log  ${biddingresponce8}

Неможливість завантажити документ другим учасником після закінчення прийому пропозицій
  [Tags]   ${USERS.users['${provider}'].broker}: Неможливість документ першим учасником після закінчення прийому пропозицій
  log   ${USERS.users['${provider1}'].broker}
  log  ${biddingresponce5}
  ${bid_id}=  get variable value  ${biddingresponce5.data.id}
  ${token1}=  Get Variable Value  ${biddingresponce5.access.token}
  log  ${token1}
  ${upload_doc_responce2}=   Викликати для учасника   ${provider1}  Завантажити документ в ставку   shouldfail   ${token1}  ${bid_id}
  log  ${upload_doc_responce_id2}
  Set Global Variable   ${upload_doc_responce2}
  
Неможливість змінити документацію цінової пропозиції після закінчення прийому пропозицій
  [Tags]   ${USERS.users['${provider}'].broker}: Неможливість змінити документацію цінової пропозиції після закінчення прийому пропозицій
  log   ${USERS.users['${provider}'].broker}
  log  ${biddingresponce5}
  ${bid_id}=  get variable value  ${biddingresponce5.data.id}
  ${token1}=  Get Variable Value  ${biddingresponce5.access.token}
  ${upload_doc_responce_id2}=  get variable value  ${upload_doc_responce2.data.id}
  log  ${upload_doc_responce_id2}
  log  ${token1} 
  Викликати для учасника   ${provider1}  Змінити документ в ставці   shouldfail   ${token1}  ${bid_id}  ${upload_doc_responce_id2}
  
  
Неможливість змінити існуючу документацію цінової пропозиції після закінчення прийому пропозицій
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість прийняти пропозицію переможця
  log   ${USERS.users['${provider}'].broker}
  log  ${biddingresponce1}
  ${bid_id}=  get variable value  ${biddingresponce1.data.id}
  ${token1}=  Get Variable Value  ${biddingresponce1.access.token}
  ${upload_doc_responce_id}=  get variable value  ${upload_doc_responce.data.id}
  log  ${token1} 
  Викликати для учасника   ${provider}  Змінити документ в ставці    ${token1}  ${bid_id}  ${upload_doc_responce_id}


Неможливість скасувати цінову пропозицію після закінчення прийому пропозицій
  [Tags]   ${USERS.users['${provider}'].broker}: Неможливість скасувати цінову пропозицію після закінчення прийому пропозицій
  ${biddingresponce8}=  Викликати для учасника   ${provider1}   скасувати цінову пропозицію   shouldfail   ${INTERNAL_TENDER_ID}   ${biddingresponce5}
  Set Global Variable   ${biddingresponce8}
  log  ${biddingresponce8}

