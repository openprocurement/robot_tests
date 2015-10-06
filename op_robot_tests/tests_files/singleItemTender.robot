*** Setting ***
Library  op_robot_tests.tests_files.service_keywords
Library  String
Library  Collections
Library  Selenium2Library
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
Можливість оголосити однопредметний тендер
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  [Documentation]   Створення закупівлі замовником, обовязково має повертати UAID закупівлі (номер тендера),
  ${TENDER_UAID}=  Викликати для учасника     ${tender_owner}    Створити тендер  ${INITIAL_TENDER_DATA}
  ${LAST_MODIFICATION_DATE}=  Get Current Date
  Set To Dictionary  ${TENDER}   TENDER_UAID             ${TENDER_UAID}
  Set To Dictionary  ${TENDER}   LAST_MODIFICATION_DATE  ${LAST_MODIFICATION_DATE}
  log  ${TENDER}

Можливість додати тендерну документацію
  [Tags]    ${USERS.users['${tender_owner}'].broker}: Можливість завантажити документ
  [Documentation]   Закупівельник   ${USERS.users['${tender_owner}'].broker}  завантажує документацію  до  оголошеної закупівлі
  ${filepath}=   create_fake_doc
  ${doc_upload_reply}=  Викликати для учасника   ${tender_owner}   Завантажити документ  ${filepath}  ${TENDER['TENDER_UAID']}
  ${file_upload_process_data} =  Create Dictionary   filepath=${filepath}  doc_upload_reply=${doc_upload_reply}
  log  ${file_upload_process_data}
  Set To Dictionary  ${USERS.users['${tender_owner}']}   file_upload_process_data   ${file_upload_process_data}
  Log  ${USERS.users['${tender_owner}']}


Можливість подати скаргу на умови
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість подати скаргу на умови
  [Documentation]    Користувач  ${USERS.users['${provider}'].broker}  намагається подати скаргу на умови оголошеної  закупівлі
  Викликати для учасника   ${provider}   Подати скаргу    ${TENDER['TENDER_UAID']}   ${COMPLAINTS[0]}
  ${LAST_MODIFICATION_DATE}=  Get Current Date
  Set To Dictionary  ${TENDER}   LAST_MODIFICATION_DATE  ${LAST_MODIFICATION_DATE}

Можливість побачити скаргу користувачем
  [Tags]   ${USERS.users['${provider}'].broker}: Відображення основних даних оголошеного тендера
  Викликати для учасника   ${provider}   Порівняти скаргу  ${TENDER['TENDER_UAID']}   ${COMPLAINTS[0]}

Можливість побачити скаргу анонімом
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Викликати для учасника    ${viewer}  Порівняти скаргу  ${TENDER['TENDER_UAID']}   ${COMPLAINTS[0]}

Пошук однопредметного тендера по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук тендера по ідентифікатору
  Дочекатись синхронізації з майданчиком    ${viewer}
  Викликати для учасника   ${viewer}   Пошук тендера по ідентифікатору   ${TENDER['TENDER_UAID']}

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
  ${field_response}=  Викликати для учасника    ${viewer}   Отримати інформацію із тендера  tenderID
  Should Be Equal   ${TENDER['TENDER_UAID']}   ${field_response}   Майданчик ${USERS.users['${viewer}'].broker}

Відображення procuringEntity.name оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Звірити поле тендера   ${viewer}  procuringEntity.name

Відображення початку періоду уточнення оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Звірити дату тендера  ${viewer}  enquiryPeriod.startDate

Відображення закінчення періоду уточнення оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Звірити дату тендера  ${viewer}  enquiryPeriod.endDate

Відображення початку періоду прийому пропозицій оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Звірити дату тендера   ${viewer}  tenderPeriod.startDate

Відображення закінчення періоду прийому пропозицій оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Звірити дату тендера  ${viewer}  tenderPeriod.endDate

Відображення мінімального кроку оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Звірити поле тендера   ${viewer}  minimalStep.amount

Можливість редагувати однопредметний тендер
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  Викликати для учасника   ${tender_owner}  Внести зміни в тендер    ${TENDER['TENDER_UAID']}   description     description

Можливість додати позицію закупівлі в тендер
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  Викликати для учасника   ${tender_owner}   Додати предмети закупівлі    ${TENDER['TENDER_UAID']}   3

Можливість видалити позиції закупівлі тендера
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  Викликати для учасника   ${tender_owner}   Додати предмети закупівлі   ${TENDER['TENDER_UAID']}   2


#######
#Відображення однопредметного тендера
#приедмет закупівлі, кількість, класифікатори, строки поставки, місце поставки

Відображення опису позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[${item_id}].description

Відображення дати доставки позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів однопредметного тендера
  Звірити дату тендера  ${viewer}  items[${item_id}].deliveryDate.endDate

Відображення координат широти доставки позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[${item_id}].deliveryLocation.latitude

Відображення координат довготи доставки позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[${item_id}].deliveryLocation.longitude

Відображення назви нас. пункту доставки позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[${item_id}].deliveryAddress.countryName

Відображення пошт коду доставки позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[${item_id}].deliveryAddress.postalCode

Відображення регіону доставки позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[${item_id}].deliveryAddress.region

Відображення locality адреси доставки позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[${item_id}].deliveryAddress.locality

Відображення вулиці доставки позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[${item_id}].deliveryAddress.streetAddress

Відображення схеми класифікації позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[${item_id}].classification.scheme

Відображення ідентифікатора класифікації позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[${item_id}].classification.id

Відображення опису класифікації позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[${item_id}].classification.description

Відображення схеми додаткової класифікації позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[${item_id}].additionalClassifications[0].scheme

Відображення ідентифікатора додаткової класифікації позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[${item_id}].additionalClassifications[0].id

Відображення опису додаткової класифікації позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[${item_id}].additionalClassifications[0].description

Відображення назви одиниці позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[${item_id}].unit.name

Відображення коду одиниці позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[${item_id}].unit.code

Відображення кількості позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[${item_id}].quantity

#######
#Відображення анонімного питання без відповідей

Задати питання
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість задати запитання
  Викликати для учасника   ${provider}   Задати питання  ${TENDER['TENDER_UAID']}   ${QUESTIONS[${question_id}]}
  ${now}=  Get Current Date
  Set To Dictionary  ${QUESTIONS[${question_id}].data}   date   ${now}

Відображення заголовоку анонімного питання без відповіді
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення анонімного питання без відповідей
  Дочекатись синхронізації з майданчиком    ${viewer}
  Викликати для учасника   ${viewer}   Оновити сторінку з тендером    ${TENDER['TENDER_UAID']}
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
  ${bidresponses}=  Create Dictionary
  ${bid_before_biddperiod_resp}=  Викликати для учасника   ${provider}   Подати цінову пропозицію  shouldfail  ${TENDER['TENDER_UAID']}   ${bid}
  Set To Dictionary  ${bidresponses}                 bid_before_biddperiod_resp  ${bid_before_biddperiod_resp}
  Set To Dictionary  ${USERS.users['${provider}']}   bidresponses  ${bidresponses}
  log   ${USERS.users['${provider}']}

#######
#Відображення відповіді на запитання
#
Відповісти на запитання
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість відповісти на запитання
  Викликати для учасника   ${tender_owner}   Відповісти на питання    ${TENDER['TENDER_UAID']}  0  ${ANSWERS[0]}
  ${now}=  Get Current Date
  Set To Dictionary  ${ANSWERS[${question_id}].data}   date   ${now}

Відображення відповіді на запитання
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення відповіді на запитання
  Дочекатись синхронізації з майданчиком    ${viewer}
  Викликати для учасника   ${viewer}   Оновити сторінку з тендером   ${TENDER['TENDER_UAID']}
  Звірити поле  ${viewer}   questions[${question_id}].answer    ${ANSWERS[${question_id}].data.answer}

Можливість побачити скаргу користувачем під час періоду уточнень
  [Tags]   ${USERS.users['${provider}'].broker}: Відображення основних даних оголошеного тендера
  Викликати для учасника   ${provider}   Порівняти скаргу  ${TENDER['TENDER_UAID']}   ${COMPLAINTS[0]}

Можливість побачити скаргу анонімом під час періоду уточнень
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Викликати для учасника    ${viewer}  Порівняти скаргу  ${TENDER['TENDER_UAID']}   ${COMPLAINTS[0]}

Подати цінову пропозицію bidder
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість подати цінову пропозицію
  Дочекатись дати початку прийому пропозицій
  ${bid}=  test bid data
  Log  ${bid}
  ${biddingresponse0}=  Викликати для учасника   ${provider}   Подати цінову пропозицію   ${TENDER['TENDER_UAID']}   ${bid}
  Set Global Variable   ${biddingresponse0}
  log  ${biddingresponse0}

Можливість скасувати цінову пропозицію
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість скасувати цінову пропозицію
  ${biddingresponse_0}=  Викликати для учасника   ${provider}   Скасувати цінову пропозицію   ${TENDER['TENDER_UAID']}   ${biddingresponse0}

Подати повторно цінову пропозицію першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість подати цінову пропозицію
  Дочекатись дати початку прийому пропозицій
  ${bid}=  test bid data
  Log  ${bid}
  ${resp}=  Викликати для учасника   ${provider}   Подати цінову пропозицію   ${TENDER['TENDER_UAID']}   ${bid}
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses}   resp   ${resp}
  log  ${resp}
  log  ${USERS.users['${provider}'].bidresponses}

Можливість змінити повторну цінову пропозицію до 50000
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість змінити цінову пропозицію
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses['resp'].data.value}  amount   50000
  Log   ${USERS.users['${provider}'].bidresponses['resp'].data.value}
  ${fixbidto50000resp}=  Викликати для учасника   ${provider}   Змінити цінову пропозицію   ${TENDER['TENDER_UAID']}   ${USERS.users['${provider}'].bidresponses['resp']}
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses}   fixbidto50000resp   ${fixbidto50000resp}
  log  ${fixbidto50000resp}

Можливість змінити повторну цінову пропозицію до 10
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість змінити цінову пропозицію
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses['resp'].data.value}  amount   10
  Log   ${USERS.users['${provider}'].bidresponses['fixbidto50000resp'].data.value}
  ${fixbidto10resp}=  Викликати для учасника   ${provider}   Змінити цінову пропозицію   ${TENDER['TENDER_UAID']}   ${USERS.users['${provider}'].bidresponses['resp']}
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses}   fixbidto10resp   ${fixbidto10resp}
  log  ${fixbidto10resp}

Завантажити документ першим учасником в повторну пропозицію
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість прийняти пропозицію переможця
  log   ${USERS.users['${provider}'].broker}
  ${filepath}=   create_fake_doc
  ${bid_doc_upload}=  Викликати для учасника   ${provider}   Завантажити документ в ставку  ${filepath}   ${TENDER['TENDER_UAID']}
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses}   bid_doc_upload   ${bid_doc_upload}

Порівняти документ
  [Tags]   ${USERS.users['${provider}'].broker}: Порівняти документ
  ${url}=      Get Variable Value   ${USERS.users['${provider}'].bidresponses['bid_doc_upload']['upload_response'].data.url}
  ${doc}  ${flnnm}=   Викликати для учасника   ${provider}  Отримати документ   ${TENDER['TENDER_UAID']}  ${url}
  ${flpth}=  Get Variable Value   ${USERS.users['${provider}'].bidresponses['bid_doc_upload']['upload_response'].data.title}
  ${flcntnt} =  get file contents  ${flpth}
  log  ${flcntnt}
  log  ${flpth}
  log  ${doc}
  log  ${flnnm}

  Should Be Equal  ${flcntnt}   ${doc}
  Should Be Equal  ${flpth}   ${flnnm}

Можливість змінити документацію цінової пропозиції
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість прийняти пропозицію переможця
  log   ${USERS.users['${provider}'].broker}
  ${filepath}=   create_fake_doc
  ${bidid}=  Get Variable Value  ${USERS.users['${provider}'].bidresponses['resp'].data.id}
  ${docid}=  Get Variable Value  ${USERS.users['${provider}'].bidresponses['bid_doc_upload']['upload_response'].data.id}
  ${bid_doc_modified}=  Викликати для учасника   ${provider}   Змінити документ в ставці  ${filepath}  ${bidid}  ${docid}
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses}   bid_doc_modified   ${bid_doc_modified}

Неможливість задати запитання після закінчення періоду уточнень
  [Documentation]
  ...    "shouldfail" argument as first switches the behaviour of keyword and "Викликати для учасника" to "fail if passed"
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість задати запитання
  ${resp}=  Викликати для учасника   ${provider}  Задати питання   shouldfail   ${TENDER['TENDER_UAID']}    ${questions[${question_id}]}

Подати цінову пропозицію другим учасником
  [Tags]   ${USERS.users['${provider1}'].broker}: Можливість подати цінову пропозицію
  Дочекатись дати початку прийому пропозицій
  ${bid}=  test bid data
  Log  ${bid}
  ${bidresponses}=  Create Dictionary
  ${resp}=  Викликати для учасника   ${provider1}   Подати цінову пропозицію   ${TENDER['TENDER_UAID']}   ${bid}
  Set To Dictionary  ${bidresponses}                 resp  ${resp}
  Set To Dictionary  ${USERS.users['${provider1}']}   bidresponses  ${bidresponses}
  log  ${resp}
  log  ${USERS.users['${provider1}'].bidresponses}

Неможливість побачити цінові пропозиції учасників під час прийому пропозицій
  [Tags]   ${USERS.users['${viewer}'].broker}: Можливість подати цінову пропозицію
  ${bids}=  Викликати для учасника    ${viewer}   Отримати інформацію із тендера  bids
  Should Be Equal    ${bids}   ${None}

Завантажити документ другим учасником
  [Tags]   ${USERS.users['${provider1}'].broker}: Можливість прийняти пропозицію переможця
  log   ${USERS.users['${provider1}'].broker}
  ${filepath}=   create_fake_doc
  ${bid_doc_upload}=  Викликати для учасника   ${provider1}   Завантажити документ в ставку  ${filepath}   ${TENDER['TENDER_UAID']}
  Set To Dictionary  ${USERS.users['${provider1}'].bidresponses}   bid_doc_upload   ${bid_doc_upload}

Можливість побачити скаргу користувачем під час подачі пропозицій
  [Tags]   ${USERS.users['${provider}'].broker}: Відображення основних даних оголошеного тендера
  Викликати для учасника   ${provider}   Порівняти скаргу  ${TENDER['TENDER_UAID']}    ${COMPLAINTS[0]}

Можливість побачити скаргу анонімом під час подачі пропозицій
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Викликати для учасника    ${viewer}  Порівняти скаргу  ${TENDER['TENDER_UAID']}    ${COMPLAINTS[0]}

Неможливість змінити цінову пропозицію до 50000 після закінчення прийому пропозицій
  [Tags]   ${USERS.users['${provider1}'].broker}: Неможливість змінити цінову пропозицію до 50000 після закінчення прийому пропозицій
  Дочекатись дати закінчення прийому пропозицій
  Set To Dictionary  ${USERS.users['${provider1}'].bidresponses['resp'].data.value}  amount   50000
  Log   ${USERS.users['${provider1}'].bidresponses['resp'].data.value}
  ${failfixbidto50000resp}=  Викликати для учасника   ${provider1}   Змінити цінову пропозицію  shouldfail  ${TENDER['TENDER_UAID']}   ${USERS.users['${provider1}'].bidresponses['resp']}
  Set To Dictionary  ${USERS.users['${provider1}'].bidresponses}   failfixbidto50000resp   ${failfixbidto50000resp}
  log  ${failfixbidto50000resp}

Неможливість змінити цінову пропозицію до 1 після закінчення прийому пропозицій
  [Tags]   ${USERS.users['${provider1}'].broker}: Неможливість змінити цінову пропозицію до 1 після закінчення прийому пропозицій
  Set To Dictionary  ${USERS.users['${provider1}'].bidresponses['resp'].data.value}  amount   1
  Log   ${USERS.users['${provider1}'].bidresponses['resp'].data.value}
  ${failfixbidto1resp}=  Викликати для учасника   ${provider1}   Змінити цінову пропозицію  shouldfail  ${TENDER['TENDER_UAID']}   ${USERS.users['${provider1}'].bidresponses['resp']}
  Set To Dictionary  ${USERS.users['${provider1}'].bidresponses}   failfixbidto1resp   ${failfixbidto1resp}
  log  ${failfixbidto1resp}

Неможливість скасувати цінову пропозицію
  [Tags]   ${USERS.users['${provider1}'].broker}: Можливість скасувати цінову пропозицію
  ${biddingresponse}=  Викликати для учасника   ${provider1}   Скасувати цінову пропозицію  shouldfail   ${TENDER['TENDER_UAID']}   ${USERS.users['${provider1}'].bidresponses['resp']}

Неможливість завантажити документ другим учасником після закінчення прийому пропозицій
  [Tags]   ${USERS.users['${provider1}'].broker}: Неможливість документ першим учасником після закінчення прийому пропозицій
  ${filepath}=   create_fake_doc
  ${bid_doc_upload_fail}=  Викликати для учасника   ${provider1}   Завантажити документ в ставку   shouldfail   ${filepath}   ${TENDER['TENDER_UAID']}
  Set To Dictionary  ${USERS.users['${provider1}'].bidresponses}   bid_doc_upload_fail   ${bid_doc_upload_fail}

Неможливість змінити існуючу документацію цінової пропозиції після закінчення прийому пропозицій
  [Tags]   ${USERS.users['${provider1}'].broker}:
  ${filepath}=   create_fake_doc
  ${bidid}=  Get Variable Value  ${USERS.users['${provider1}'].bidresponses['resp'].data.id}
  ${docid}=  Get Variable Value  ${USERS.users['${provider1}'].bidresponses['bid_doc_upload']['upload_response'].data.id}
  ${bid_doc_modified_failed}=  Викликати для учасника   ${provider1}   Змінити документ в ставці  shouldfail  ${filepath}  ${bidid}  ${docid}
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses}   bid_doc_modified_failed   ${bid_doc_modified_failed}


Вичитати цінову пропозицію
  sleep  120
  [Tags]   ${USERS.users['${provider1}'].broker}: Можливість подати цінову пропозицію
  ${bidid}=  Get Variable Value  ${USERS.users['${provider1}'].bidresponses['resp'].data.id}
  ${token}=  Get Variable Value  ${USERS.users['${provider1}'].bidresponses['resp'].access.token}
  ${bids}=  Викликати для учасника   ${provider1}   Отримати пропозиції   ${TENDER['TENDER_UAID']}   ${bidid}   ${token}
  log  ${bids}
