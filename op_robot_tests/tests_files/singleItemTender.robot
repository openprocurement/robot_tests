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
Можливість оголосити однопредметний тендер
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  [Documentation]   Створення закупівлі замовником, обовязково має повертати UAID закупівлі (номер тендера),
  ${TENDER_UAID}=  Викликати для учасника     ${tender_owner}    Створити тендер  ${INITIAL_TENDER_DATA}
  ${LAST_MODIFICATION_DATE}=  Get Current Date
  Set To Dictionary  ${TENDER}   TENDER_UAID             ${TENDER_UAID}
  Set To Dictionary  ${TENDER}   LAST_MODIFICATION_DATE  ${LAST_MODIFICATION_DATE}
  log  ${TENDER}

Можливасть додати тендерну документацію
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
  Викликати для учасника   ${provider}   порівняти скаргу  ${TENDER['TENDER_UAID']}   ${COMPLAINTS[0]}

можливість побачити скаргу анонімом
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Викликати для учасника    ${viewer}  порівняти скаргу  ${TENDER['TENDER_UAID']}   ${COMPLAINTS[0]}

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
  ${field_response}=  Викликати для учасника    ${viewer}   отримати інформацію із тендера  tenderID
  Should Be Equal   ${TENDER['TENDER_UAID']}   ${field_response}   Майданчик ${USERS.users['${viewer}'].broker}

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

Можливість редагувати однопредметний тендер
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  Викликати для учасника   ${tender_owner}  Внести зміни в тендер    ${TENDER['TENDER_UAID']}   description     description

Можливість додати позицію закупівлі в тендер
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  Викликати для учасника   ${tender_owner}   додати предмети закупівлі    ${TENDER['TENDER_UAID']}   3

Можливість видалити позиції закупівлі тендера
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  Викликати для учасника   ${tender_owner}   додати предмети закупівлі   ${TENDER['TENDER_UAID']}   2


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
  Звірити поле тендера   ${viewer}  items[${item_id}].additionalClassifications[0].scheme

Відображення ідентифікатора додаткової класифікації позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[${item_id}].additionalClassifications[0].id

Відображення опису додаткової класифікації позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[${item_id}].additionalClassifications[0].description

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
  Викликати для учасника   ${provider}   Задати питання  ${TENDER['TENDER_UAID']}   ${QUESTIONS[${question_id}]}
  ${now}=  Get Current Date
  Set To Dictionary  ${QUESTIONS[${question_id}].data}   date   ${now}

Відображення заголовоку анонімного питання без відповіді
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення анонімного питання без відповідей
  Дочекатись синхронізації з майданчиком    ${viewer}
  Викликати для учасника   ${viewer}   обновити сторінку з тендером    ${TENDER['TENDER_UAID']}
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
  ${bidresponces}=  Create Dictionary
  ${bid_before_biddperiod_resp}=  Викликати для учасника   ${provider}   Подати цінову пропозицію  shouldfail  ${TENDER['TENDER_UAID']}   ${bid}
  Set To Dictionary  ${bidresponces}                 bid_before_biddperiod_resp  ${bid_before_biddperiod_resp}
  Set To Dictionary  ${USERS.users['${provider}']}   bidresponces  ${bidresponces}
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
  Викликати для учасника   ${viewer}   обновити сторінку з тендером   ${TENDER['TENDER_UAID']}
  Звірити поле  ${viewer}   questions[${question_id}].answer    ${ANSWERS[${question_id}].data.answer}

Можливість побачити скаргу користувачем під час періоду уточнень
  [Tags]   ${USERS.users['${provider}'].broker}: Відображення основних даних оголошеного тендера
  Викликати для учасника   ${provider}   порівняти скаргу  ${TENDER['TENDER_UAID']}   ${COMPLAINTS[0]}

можливість побачити скаргу анонімом під час періоду уточнень
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Викликати для учасника    ${viewer}  порівняти скаргу  ${TENDER['TENDER_UAID']}   ${COMPLAINTS[0]}

Подати цінову пропозицію bidder
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість подати цінову пропозицію
  Дочекатись дати початоку прийому пропозицій
  ${bid}=  test bid data
  Log  ${bid}
  ${biddingresponce0}=  Викликати для учасника   ${provider}   Подати цінову пропозицію   ${TENDER['TENDER_UAID']}   ${bid}
  Set Global Variable   ${biddingresponce0}
  log  ${biddingresponce0}

Можливість скасувати цінову пропозицію
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість скасувати цінову пропозицію
  ${biddingresponce_0}=  Викликати для учасника   ${provider}   скасувати цінову пропозицію   ${TENDER['TENDER_UAID']}   ${biddingresponce0}

Подати повторно цінову пропозицію першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість подати цінову пропозицію
  Дочекатись дати початоку прийому пропозицій
  ${bid}=  test bid data
  Log  ${bid}
  ${resp}=  Викликати для учасника   ${provider}   Подати цінову пропозицію   ${TENDER['TENDER_UAID']}   ${bid}
  Set To Dictionary  ${USERS.users['${provider}'].bidresponces}   resp   ${resp}
  log  ${resp}
  log  ${USERS.users['${provider}'].bidresponces}

Можливість змінити повторну цінову пропозицію до 50000
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість змінити цінову пропозицію
  #Set To Dictionary  ${USERS.users['${provider}'].bidresponces['resp'].data.value}  amount   50000
  #Log   ${USERS.users['${provider}'].bidresponces['resp'].data.value}
  ${fixbidto50000resp}=  Викликати для учасника   ${provider}   Змінити цінову пропозицію   ${TENDER['TENDER_UAID']}   #${USERS.users['${provider}'].bidresponces['resp']}
#  Set To Dictionary  ${USERS.users['${provider}'].bidresponces}   fixbidto50000resp   ${fixbidto50000resp}
#  log  ${fixbidto50000resp}

Можливість змінити повторну цінову пропозицію до 10
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість змінити цінову пропозицію
  #Set To Dictionary  ${USERS.users['${provider}'].bidresponces['resp'].data.value}  amount   10
  #Log   ${USERS.users['${provider}'].bidresponces['fixbidto50000resp'].data.value}
  ${fixbidto10resp}=  Викликати для учасника   ${provider}   Змінити цінову пропозицію   ${TENDER['TENDER_UAID']}   #${USERS.users['${provider}'].bidresponces['resp']}
#  Set To Dictionary  ${USERS.users['${provider}'].bidresponces}   fixbidto10resp   ${fixbidto10resp}
# log  ${fixbidto10resp}

Завантажити документ першим учасником в повторну пропозицію
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість прийняти пропозицію переможця
  log   ${USERS.users['${provider}'].broker}
  ${filepath}=   create_fake_doc
  ${bid_doc_upload}=  Викликати для учасника   ${provider}   Завантажити документ в ставку  ${filepath}   ${TENDER['TENDER_UAID']}
  Set To Dictionary  ${USERS.users['${provider}'].bidresponces}   bid_doc_upload   ${bid_doc_upload}

порівняти документ
  [Tags]   ${USERS.users['${provider}'].broker}: вичитати документ
  ${url}=      Get Variable Value   ${USERS.users['${provider}'].bidresponces['bid_doc_upload']['upload_responce'].data.url}
  ${doc}  ${flnnm}=   Викликати для учасника   ${provider}  отримати документ   ${TENDER['TENDER_UAID']}  ${url}

  FIXME: finish the keyword

  Should Be Equal  ${flcntnt}   ${doc}
  Should Be Equal  ${flpth}   ${flnnm}

Можливість змінити документацію цінової пропозиції
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість прийняти пропозицію переможця
  log   ${USERS.users['${provider}'].broker}
  ${filepath}=   create_fake_doc
  ${bidid}=  Get Variable Value  ${USERS.users['${provider}'].bidresponces['resp'].data.id}
  ${docid}=  Get Variable Value  ${USERS.users['${provider}'].bidresponces['bid_doc_upload']['upload_responce'].data.id}
  ${bid_doc_modified}=  Викликати для учасника   ${provider}   Змінити документ в ставці  ${filepath}  ${bidid}  ${docid}
  Set To Dictionary  ${USERS.users['${provider}'].bidresponces}   bid_doc_modified   ${bid_doc_modified}

Неможливість задати запитання після закінчення періоду уточнень
  [Documentation]
  ...    "shouldfail" argument as first switches the behaviour of keyword and "Викликати для учасника" to "fail if passed"
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість задати запитання
  ${resp}=  Викликати для учасника   ${provider}  Задати питання   shouldfail   ${TENDER['TENDER_UAID']}    ${questions[${question_id}]}

Подати цінову пропозицію другим учасником
  [Tags]   ${USERS.users['${provider1}'].broker}: Можливість подати цінову пропозицію
  Дочекатись дати початоку прийому пропозицій
  ${bid}=  test bid data
  Log  ${bid}
  ${bidresponces}=  Create Dictionary
  ${resp}=  Викликати для учасника   ${provider1}   Подати цінову пропозицію   ${TENDER['TENDER_UAID']}   ${bid}
  Set To Dictionary  ${bidresponces}                 resp  ${resp}
  Set To Dictionary  ${USERS.users['${provider1}']}   bidresponces  ${bidresponces}
  log  ${resp}
  log  ${USERS.users['${provider1}'].bidresponces}

Неможливість побачити цінові пропозиції учасників під час прийому пропозицій
  [Tags]   ${USERS.users['${viewer}'].broker}: Можливість подати цінову пропозицію

  FIXME: finish the keyword

  ${field_date}=  Викликати для учасника    ${viewer}   отримати інформацію із тендера

Завантажити документ другим учасником
  [Tags]   ${USERS.users['${provider1}'].broker}: Можливість прийняти пропозицію переможця
  log   ${USERS.users['${provider1}'].broker}
  ${filepath}=   create_fake_doc
  ${bid_doc_upload}=  Викликати для учасника   ${provider1}   Завантажити документ в ставку  ${filepath}   ${TENDER['TENDER_UAID']}
  Set To Dictionary  ${USERS.users['${provider1}'].bidresponces}   bid_doc_upload   ${bid_doc_upload}

Можливість побачити скаргу користувачем під час подачі пропозицій
  [Tags]   ${USERS.users['${provider}'].broker}: Відображення основних даних оголошеного тендера
  Викликати для учасника   ${provider}   порівняти скаргу  ${TENDER['TENDER_UAID']}    ${COMPLAINTS[0]}

можливість побачити скаргу анонімом під час подачі пропозицій
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Викликати для учасника    ${viewer}  порівняти скаргу  ${TENDER['TENDER_UAID']}    ${COMPLAINTS[0]}

Неможливість змінити цінову пропозицію до 50000 після закінчення прийому пропозицій
  [Tags]   ${USERS.users['${provider1}'].broker}: Неможливість змінити цінову пропозицію до 50000 після закінчення прийому пропозицій
  Дочекатись дати закінчення прийому пропозицій
  Set To Dictionary  ${USERS.users['${provider1}'].bidresponces['resp'].data.value}  amount   50000
  Log   ${USERS.users['${provider1}'].bidresponces['resp'].data.value}
  ${failfixbidto50000resp}=  Викликати для учасника   ${provider1}   Змінити цінову пропозицію  shouldfail  ${TENDER['TENDER_UAID']}   ${USERS.users['${provider1}'].bidresponces['resp']}
  Set To Dictionary  ${USERS.users['${provider1}'].bidresponces}   failfixbidto50000resp   ${failfixbidto50000resp}
  log  ${failfixbidto50000resp}

Неможливість змінити цінову пропозицію до 1 після закінчення прийому пропозицій
  [Tags]   ${USERS.users['${provider1}'].broker}: Неможливість змінити цінову пропозицію до 1 після закінчення прийому пропозицій
  Set To Dictionary  ${USERS.users['${provider1}'].bidresponces['resp'].data.value}  amount   1
  Log   ${USERS.users['${provider1}'].bidresponces['resp'].data.value}
  ${failfixbidto1resp}=  Викликати для учасника   ${provider1}   Змінити цінову пропозицію  shouldfail  ${TENDER['TENDER_UAID']}   ${USERS.users['${provider1}'].bidresponces['resp']}
  Set To Dictionary  ${USERS.users['${provider1}'].bidresponces}   failfixbidto1resp   ${failfixbidto1resp}
  log  ${failfixbidto1resp}

Неможливість скасувати цінову пропозицію
  [Tags]   ${USERS.users['${provider1}'].broker}: Можливість скасувати цінову пропозицію
  ${biddingresponce}=  Викликати для учасника   ${provider1}   скасувати цінову пропозицію  shouldfail   ${TENDER['TENDER_UAID']}   ${USERS.users['${provider1}'].bidresponces['resp']}

Неможливість завантажити документ другим учасником після закінчення прийому пропозицій
  [Tags]   ${USERS.users['${provider1}'].broker}: Неможливість документ першим учасником після закінчення прийому пропозицій
  ${filepath}=   create_fake_doc
  ${bid_doc_upload_fail}=  Викликати для учасника   ${provider1}   Завантажити документ в ставку   shouldfail   ${filepath}   ${TENDER['TENDER_UAID']}
  Set To Dictionary  ${USERS.users['${provider1}'].bidresponces}   bid_doc_upload_fail   ${bid_doc_upload_fail}

Неможливість змінити існуючу документацію цінової пропозиції після закінчення прийому пропозицій
  [Tags]   ${USERS.users['${provider1}'].broker}:
  ${filepath}=   create_fake_doc
  ${bidid}=  Get Variable Value  ${USERS.users['${provider1}'].bidresponces['resp'].data.id}
  ${docid}=  Get Variable Value  ${USERS.users['${provider1}'].bidresponces['bid_doc_upload']['upload_responce'].data.id}
  ${bid_doc_modified_failed}=  Викликати для учасника   ${provider1}   Змінити документ в ставці  shouldfail  ${filepath}  ${bidid}  ${docid}
  Set To Dictionary  ${USERS.users['${provider}'].bidresponces}   bid_doc_modified_failed   ${bid_doc_modified_failed}

Вичитати цінову пропозицію
  #sleep  120
  [Tags]   ${USERS.users['${provider1}'].broker}: Можливість подати цінову пропозицію
  ${bidid}=  Get Variable Value  ${USERS.users['${provider1}'].bidresponces['resp'].data.id}
  ${token}=  Get Variable Value  ${USERS.users['${provider1}'].bidresponces['resp'].access.token}
  ${bids}=  Викликати для учасника   ${provider1}   Отримати пропозиції   ${TENDER['TENDER_UAID']}   ${bidid}   ${token}
  log  ${bids}