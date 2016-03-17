*** Settings ***
Library         op_robot_tests.tests_files.service_keywords
Library         String
Library         Collections
Library         Selenium2Library
Library         DebugLibrary
Resource        belowThreshold_keywords.robot
Resource        keywords.robot
Resource        resource.robot
Suite Setup     Test Suite Setup
Suite Teardown  Test Suite Teardown

*** Variables ***
${mode}         single

${role}         viewer
${broker}       Quinta

${question_id}  0

*** Test Cases ***
Можливість оголосити однопредметний тендер
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      minimal
  [Documentation]  Створення закупівлі замовником, обовязково має повертати UAID закупівлі (номер тендера),
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість оголосити тендер


Можливість додати тендерну документацію
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість додати тендерну документацію
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      critical level 2
  [Documentation]  Закупівельник ${USERS.users['${tender_owner}'].broker} завантажує документацію до оголошеної закупівлі
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість додати тендерну документацію


Можливість знайти однопредметний тендер по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук тендера по ідентифікатору
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      minimal
  Можливість знайти тендер по ідентифікатору

##############################################################################################
#             ВІДОБРАЖЕННЯ
##############################################################################################

Відображення заголовку документа однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  Відображення заголовку документа тендера


Відображення заголовку однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      minimal
  Відображення заголовку тендера


Відображення опису однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Відображення опису тендера


Відображення бюджету однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      critical level 2
  Відображення бюджету тендера


Відображення ідентифікатора однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      critical level 2
  Відображення ідентифікатора тендера


Відображення імені замовника однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      critical level 2
  Відображення імені замовника тендера


Відображення початку періоду уточнення однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Відображення початку періоду уточнення тендера


Відображення закінчення періоду уточнення однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      minimal
  Відображення закінчення періоду уточнення тендера


Відображення початку періоду прийому пропозицій однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      minimal
  Відображення початку періоду прийому пропозицій тендера


Відображення закінчення періоду прийому пропозицій однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      minimal
  Відображення закінчення періоду прийому пропозицій тендера


Відображення мінімального кроку однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Відображення мінімального кроку тендера


Відображення дати доставки позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      critical level 3
  Відображення дати доставки позицій закупівлі тендера


Відображення координат широти доставки позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Відображення координат широти доставки позицій закупівлі тендера


Відображення координат довготи доставки позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Відображення координат довготи доставки позицій закупівлі тендера


Відображення назви нас. пункту доставки позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      critical level 3
  Відображення назви нас. пункту доставки позицій закупівлі тендера


Відображення пошт. коду доставки позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Відображення пошт. коду доставки позицій закупівлі тендера


Відображення регіону доставки позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      critical level 3
  Відображення регіону доставки позицій закупівлі тендера


Відображення населеного пункту адреси доставки позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Відображення населеного пункту адреси доставки позицій закупівлі тендера


Відображення вулиці доставки позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Відображення вулиці доставки позицій закупівлі тендера


Відображення схеми класифікації позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Відображення схеми класифікації позицій закупівлі тендера


Відображення ідентифікатора класифікації позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      critical level 3
  Відображення ідентифікатора класифікації позицій закупівлі тендера


Відображення опису класифікації позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      critical level 3
  Відображення опису класифікації позицій закупівлі тендера


Відображення схеми додаткової класифікації позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Відображення схеми додаткової класифікації позицій закупівлі тендера


Відображення ідентифікатора додаткової класифікації позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      critical level 3
  Відображення ідентифікатора додаткової класифікації позицій закупівлі тендера


Відображення опису додаткової класифікації позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      critical level 3
  Відображення опису додаткової класифікації позицій закупівлі тендера


Відображення назви одиниці позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      critical level 3
  Відображення назви одиниці позицій закупівлі тендера


Відображення коду одиниці позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Відображення коду одиниці позицій закупівлі тендера


Відображення кількості позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      critical level 3
  Відображення кількості позицій закупівлі тендера


Відображення опису позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів однопредметного тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      critical level 2
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Відображення опису позицій закупівлі тендера

##############################################################################################
#             МОЖЛИВІСТЬ
##############################################################################################

Можливість редагувати однопредметний тендер
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      critical level 2
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість редагувати тендер

##############################################################################################
#             ВІДОБРАЖЕННЯ
##############################################################################################

Відображення редагованого опису однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Відображення опису тендера

##############################################################################################
#             МОЖЛИВІСТЬ
##############################################################################################

Можливість задати питання
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість задати запитання
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      critical level 2
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${question}=  Підготовка даних для запитання
  ${question_resp}=  Викликати для учасника  ${provider}  Задати питання  ${TENDER['TENDER_UAID']}  ${question}
  ${now}=  Get Current TZdate
  ${question.data.date}=  Set variable  ${now}
  ${question_data}=  Create Dictionary  question=${question}  question_resp=${question_resp}
  ${question_data}=  munch_dict  arg=${question_data}
  Set To Dictionary  ${USERS.users['${provider}']}  question_data=${question_data}

##############################################################################################
#             ВІДОБРАЖЕННЯ
##############################################################################################

Відображення заголовку анонімного питання без відповіді
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення анонімного питання без відповідей
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      critical level 2
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Викликати для учасника  ${viewer}  Оновити сторінку з тендером  ${TENDER['TENDER_UAID']}
  Звірити поле тендера із значенням  ${viewer}  ${USERS.users['${provider}'].question_data.question.data.title}  questions[${question_id}].title


Відображення опису анонімного питання без відповіді
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення анонімного питання без відповідей
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      critical level 2
  Звірити поле тендера із значенням  ${viewer}  ${USERS.users['${provider}'].question_data.question.data.description}  questions[${question_id}].description


Відображення дати анонімного питання без відповіді
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення анонімного питання без відповідей
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Звірити дату тендера із значенням  ${viewer}  ${USERS.users['${provider}'].question_data.question.data.date}  questions[${question_id}].date

##############################################################################################
#             МОЖЛИВІСТЬ
##############################################################################################

Неможливість подати цінову пропозицію до початку періоду подачі пропозицій першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість подати цінову пропозицію
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  ${bid}=  test bid data
  Log  ${bid}
  ${bidresponses}=  Create Dictionary  bid=${bid}
  Set To Dictionary  ${USERS.users['${provider}']}  bidresponses=${bidresponses}
  ${bid_before_bidperiod_resp}=  Require Failure  ${provider}  Подати цінову пропозицію  ${TENDER['TENDER_UAID']}  ${bid}
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses}  bid_before_bidperiod_resp=${bid_before_bidperiod_resp}
  Log  ${USERS.users['${provider}']}


Можливість відповісти на запитання
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість відповісти на запитання
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      critical level 2
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${answer}=  Підготовка даних для відповіді на запитання
  ${answer_resp}=  Викликати для учасника  ${tender_owner}  Відповісти на питання  ${TENDER['TENDER_UAID']}  ${USERS.users['${provider}']['question_data']['question_resp']}  ${answer}
  ${now}=  Get Current TZdate
  ${answer.data.date}=  Set variable  ${now}
  ${answer_data}=  Create Dictionary  answer=${answer}  answer_resp=${answer_resp}
  Set To Dictionary  ${USERS.users['${provider}']}  answer_data=${answer_data}

##############################################################################################
#             ВІДОБРАЖЕННЯ
##############################################################################################

Відображення відповіді на запитання
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення відповіді на запитання
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      critical level 2
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Викликати для учасника  ${viewer}  Оновити сторінку з тендером  ${TENDER['TENDER_UAID']}
  Звірити поле тендера із значенням  ${viewer}  ${USERS.users['${provider}']['answer_data']['answer'].data.answer}  questions[${question_id}].answer

##############################################################################################
#             МОЖЛИВІСТЬ
##############################################################################################

Можливість подати цінову пропозицію першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість подати цінову пропозицію
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Дочекатись дати початку прийому пропозицій  ${provider}
  ${bid}=  test bid data
  Log  ${bid}
  ${bidresponses}=  Create Dictionary  bid=${bid}
  Set To Dictionary  ${USERS.users['${provider}']}  bidresponses=${bidresponses}
  ${resp}=  Викликати для учасника  ${provider}  Подати цінову пропозицію  ${TENDER['TENDER_UAID']}  ${bid}
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses}  resp=${resp}
  Log  ${USERS.users['${provider}'].bidresponses}


Можливість скасувати цінову пропозицію
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість скасувати цінову пропозицію
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${canceledbidresp}=  Викликати для учасника  ${provider}  Скасувати цінову пропозицію  ${TENDER['TENDER_UAID']}  ${USERS.users['${provider}'].bidresponses['resp']}
  Log  ${canceledbidresp}


Можливість подати повторно цінову пропозицію першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість подати цінову пропозицію
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      minimal
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Дочекатись дати початку прийому пропозицій  ${provider}
  ${bid}=  test bid data
  Log  ${bid}
  ${bidresponses}=  Create Dictionary  bid=${bid}
  Set To Dictionary  ${USERS.users['${provider}']}  bidresponses=${bidresponses}
  ${resp}=  Викликати для учасника  ${provider}  Подати цінову пропозицію  ${TENDER['TENDER_UAID']}  ${bid}
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses}  resp=${resp}
  Log  ${USERS.users['${provider}'].bidresponses}


Можливість змінити повторну цінову пропозицію до 50000
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість змінити цінову пропозицію
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${fixbidto50000resp}=  Викликати для учасника  ${provider}  Змінити цінову пропозицію  ${TENDER['TENDER_UAID']}  value.amount  50000
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses}  fixbidto50000resp=${fixbidto50000resp}
  Log  ${fixbidto50000resp}


Можливість змінити повторну цінову пропозицію до 10
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість змінити цінову пропозицію
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${fixbidto10resp}=  Викликати для учасника  ${provider}  Змінити цінову пропозицію  ${TENDER['TENDER_UAID']}  value.amount  10
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses}  fixbidto10resp=${fixbidto10resp}
  Log  ${fixbidto10resp}


Можливість завантажити документ першим учасником в повторну пропозицію
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість прийняти пропозицію переможця
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      critical level 2
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Log  ${USERS.users['${provider}'].broker}
  ${filepath}=  create_fake_doc
  ${bid_doc_upload}=  Викликати для учасника  ${provider}  Завантажити документ в ставку  ${filepath}  ${TENDER['TENDER_UAID']}
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses}  bid_doc_upload=${bid_doc_upload}


Можливість змінити документацію цінової пропозиції
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість прийняти пропозицію переможця
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Log  ${USERS.users['${provider}'].broker}
  ${filepath}=  create_fake_doc
  ${bidid}=  Get Variable Value  ${USERS.users['${provider}'].bidresponses['resp'].data.id}
  ${docid}=  Get Variable Value  ${USERS.users['${provider}'].bidresponses['bid_doc_upload']['upload_response'].data.id}
  ${bid_doc_modified}=  Викликати для учасника  ${provider}  Змінити документ в ставці  ${filepath}  ${bidid}  ${docid}
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses}  bid_doc_modified=${bid_doc_modified}


Неможливість задати запитання після закінчення періоду уточнень
  [Documentation]
  ...      `Задати питання` should not pass in this test case.
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість задати запитання
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ${question}=  Підготовка даних для запитання
  Require Failure  ${provider}  Задати питання  ${TENDER['TENDER_UAID']}  ${question}


Можливість подати цінову пропозицію другим учасником
  [Tags]   ${USERS.users['${provider1}'].broker}: Можливість подати цінову пропозицію
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      minimal
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider1}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Дочекатись дати початку прийому пропозицій  ${provider1}
  ${bid}=  test bid data
  Log  ${bid}
  ${bidresponses}=  Create Dictionary  bid=${bid}
  Set To Dictionary  ${USERS.users['${provider1}']}  bidresponses=${bidresponses}
  ${resp}=  Викликати для учасника  ${provider1}  Подати цінову пропозицію  ${TENDER['TENDER_UAID']}  ${bid}
  Set To Dictionary  ${USERS.users['${provider1}'].bidresponses}  resp=${resp}
  Log  ${resp}
  Log  ${USERS.users['${provider1}'].bidresponses}


Неможливість побачити цінові пропозиції учасників під час прийому пропозицій
  [Tags]   ${USERS.users['${viewer}'].broker}: Можливість подати цінову пропозицію
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Require Failure  ${viewer}  Отримати інформацію із тендера  bids


Можливість завантажити документ другим учасником
  [Tags]   ${USERS.users['${provider1}'].broker}: Можливість прийняти пропозицію переможця
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      critical level 2
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider1}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Log  ${USERS.users['${provider1}'].broker}
  ${filepath}=  create_fake_doc
  ${bid_doc_upload}=  Викликати для учасника  ${provider1}  Завантажити документ в ставку  ${filepath}  ${TENDER['TENDER_UAID']}
  Set To Dictionary  ${USERS.users['${provider1}'].bidresponses}  bid_doc_upload=${bid_doc_upload}


Неможливість змінити цінову пропозицію до 50000 після закінчення прийому пропозицій
  [Tags]   ${USERS.users['${provider1}'].broker}: Неможливість змінити цінову пропозицію до 50000 після закінчення прийому пропозицій
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  Дочекатись дати закінчення прийому пропозицій  ${provider1}
  ${failfixbidto50000resp}=  Require Failure  ${provider1}  Змінити цінову пропозицію  ${TENDER['TENDER_UAID']}  value.amount  50000
  Set To Dictionary  ${USERS.users['${provider1}'].bidresponses}  failfixbidto50000resp=${failfixbidto50000resp}
  Log  ${failfixbidto50000resp}


Неможливість змінити цінову пропозицію до 1 після закінчення прийому пропозицій
  [Tags]   ${USERS.users['${provider1}'].broker}: Неможливість змінити цінову пропозицію до 1 після закінчення прийому пропозицій
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ${failfixbidto1resp}=  Require Failure  ${provider1}  Змінити цінову пропозицію  ${TENDER['TENDER_UAID']}  value.amount  1
  Set To Dictionary  ${USERS.users['${provider1}'].bidresponses}  failfixbidto1resp=${failfixbidto1resp}
  Log  ${failfixbidto1resp}


Неможливість скасувати цінову пропозицію
  [Tags]   ${USERS.users['${provider1}'].broker}: Можливість скасувати цінову пропозицію
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ${biddingresponse}=  Require Failure  ${provider1}  Скасувати цінову пропозицію  ${TENDER['TENDER_UAID']}  ${USERS.users['${provider1}'].bidresponses['resp']}


Неможливість завантажити документ другим учасником після закінчення прийому пропозицій
  [Tags]   ${USERS.users['${provider1}'].broker}: Неможливість завантажити документ першим учасником після закінчення прийому пропозицій
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ${filepath}=   create_fake_doc
  ${bid_doc_upload_fail}=  Require Failure  ${provider1}  Завантажити документ в ставку  ${filepath}  ${TENDER['TENDER_UAID']}
  Set To Dictionary  ${USERS.users['${provider1}'].bidresponses}  bid_doc_upload_fail=${bid_doc_upload_fail}


Неможливість змінити існуючу документацію цінової пропозиції після закінчення прийому пропозицій
  [Tags]   ${USERS.users['${provider1}'].broker}:
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ${filepath}=  create_fake_doc
  ${bidid}=  Get Variable Value  ${USERS.users['${provider1}'].bidresponses['resp'].data.id}
  ${docid}=  Get Variable Value  ${USERS.users['${provider1}'].bidresponses['bid_doc_upload']['upload_response'].data.id}
  ${bid_doc_modified_failed}=  Require Failure  ${provider1}  Змінити документ в ставці  ${filepath}  ${bidid}  ${docid}
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses}  bid_doc_modified_failed=${bid_doc_modified_failed}


Можливість вичитати посилання на аукціон для глядача
  [Tags]   ${USERS.users['${viewer}'].broker}: Можливість подати цінову пропозицію
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      minimal
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Дочекатись дати закінчення прийому пропозицій  ${viewer}
  Sleep  120
  ${url}=  Викликати для учасника  ${viewer}  Отримати посилання на аукціон для глядача  ${TENDER['TENDER_UAID']}
  Should Be True  '${url}'
  Should Match Regexp  ${url}  ^https?:\/\/auction(?:-sandbox)?\.openprocurement\.org\/tenders\/([0-9A-Fa-f]{32})
  Log  URL аукціону для глядача: ${url}


Можливість вичитати посилання на участь в аукціоні для першого учасника
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість подати цінову пропозицію
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      minimal
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${url}=  Викликати для учасника  ${provider}  Отримати посилання на аукціон для учасника  ${TENDER['TENDER_UAID']}
  Should Be True  '${url}'
  Should Match Regexp  ${url}  ^https?:\/\/auction(?:-sandbox)?\.openprocurement\.org\/tenders\/([0-9A-Fa-f]{32})
  Log  URL аукціону для першого учасника: ${url}


Можливість вичитати посилання на участь в аукціоні для другого учасника
  [Tags]   ${USERS.users['${provider1}'].broker}: Можливість подати цінову пропозицію
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      minimal
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider1}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${url}=  Викликати для учасника  ${provider1}  Отримати посилання на аукціон для учасника  ${TENDER['TENDER_UAID']}
  Should Be True  '${url}'
  Should Match Regexp  ${url}  ^https?:\/\/auction(?:-sandbox)?\.openprocurement\.org\/tenders\/([0-9A-Fa-f]{32})
  Log  URL аукціону для другого учасника: ${url}
