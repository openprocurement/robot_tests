*** Settings ***
Library         op_robot_tests.tests_files.service_keywords
Library         String
Library         Collections
Library         Selenium2Library
Library         DebugLibrary
Resource        keywords.robot
Resource        resource.robot
Suite Setup     Test Suite Setup
Suite Teardown  Test Suite Teardown

*** Variables ***
${mode}         multiLot
@{used_roles}   tender_owner  provider  provider1  viewer
${complaint_id}  1


*** Test Cases ***
Можливість оголосити мультилотовий тендер
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити мультилотовий тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      minimal
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${tender_data}=  Підготовка даних для створення тендера
  ${adapted_data}=  Адаптувати дані для оголошення тендера  ${tender_owner}  ${tender_data}
  ${TENDER_UAID}=  Run As  ${tender_owner}  Створити тендер  ${adapted_data}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  initial_data=${adapted_data}
  Set To Dictionary  ${TENDER}   TENDER_UAID=${TENDER_UAID}
  Log  ${TENDER}


Можливість знайти мультилотовий тендер по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук тендера по ідентифікатору
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      minimal
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}  ${provider}  ${provider1}
  \  Дочекатись синхронізації з майданчиком    ${username}
  \  Run As  ${username}  Пошук тендера по ідентифікатору   ${TENDER['TENDER_UAID']}

Можливість додати тендерну документацію лоту
  [Tags]    ${USERS.users['${tender_owner}'].broker}: Можливість завантажити документ
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  [Documentation]   Закупівельник   ${USERS.users['${tender_owner}'].broker}  завантажує документацію  до  оголошеної закупівлі
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${lot_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].initial_data.data.lots[0]}
  ${filepath}=   create_fake_doc
  Run As   ${tender_owner}   Завантажити документ в лот  ${filepath}   ${TENDER['TENDER_UAID']}  ${lot_id}

Відображення заголовку першого лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ${lot_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].initial_data.data.lots[0]}
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data.data.lots[0].title}  title
  ...      object_id=${lot_id}

Відображення опису першого лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  ${lot_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].initial_data.data.lots[0]}
  :FOR  ${username}  IN  ${viewer}  ${provider}  ${provider1}
  \  Дочекатись синхронізації з майданчиком  ${username}
  \  Звірити поле тендера із значенням  ${username}
  \  ...      ${USERS.users['${tender_owner}'].initial_data.data.lots[0].description}  description
  \  ...      object_id=${lot_id}

#######
#Операції з лотом

Можливість створення лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком    ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${lot}=  Підготовка даних для створення лоту
  ${lot_resp}=  Run As   ${tender_owner}  Створити лот  ${TENDER['TENDER_UAID']}  ${lot}
  ${lot_id}=  get_id_from_object  ${lot.data}
  ${lot_data}=  Create Dictionary  lot=${lot}  lot_resp=${lot_resp}  lot_id=${lot_id}
  ${lot_data}=  munch_dict  arg=${lot_data}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  lot_data=${lot_data}
  log  ${lot_resp}

Можливість видалення лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Run As  ${tender_owner}  Видалити лот  ${TENDER['TENDER_UAID']}  ${USERS.users['${tender_owner}'].lot_data.lot_id}

Можливість повторого створення лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${lot}=  Підготовка даних для створення лоту
  ${lot_resp}=  Run As   ${tender_owner}  Створити лот  ${TENDER['TENDER_UAID']}  ${lot}
  ${lot_id}=  get_id_from_object  ${lot.data}
  ${lot_data}=  Create Dictionary  lot=${lot}  lot_resp=${lot_resp}  lot_id=${lot_id}
  ${lot_data}=  munch_dict  arg=${lot_data}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  lot_data=${lot_data}
  log  ${lot_resp}

Відображення заголовку другого лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${tender_owner}'].lot_data.lot.data.title}  title
  ...      object_id=${USERS.users['${tender_owner}'].lot_data.lot_id}

Відображення опису другого лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  :FOR  ${username}  IN  ${viewer}  ${provider}  ${provider1}
  \  Дочекатись синхронізації з майданчиком  ${username}
  \  Звірити поле тендера із значенням  ${username}
  \  ...      ${USERS.users['${tender_owner}'].lot_data.lot.data.description}  description
  \  ...      object_id=${USERS.users['${tender_owner}'].lot_data.lot_id}

Відображення бюджету другого лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${tender_owner}'].lot_data.lot.data.value.amount}  value.amount
  ...      object_id=${USERS.users['${tender_owner}'].lot_data.lot_id}


Можливість змінити бюджет другого лоту до 100
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Run As   ${tender_owner}  Змінити лот  ${TENDER['TENDER_UAID']}  ${USERS.users['${tender_owner}'].lot_data.lot_id}  value.amount   100


Можливість змінити бюджет другого лоту до 8000
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Run As   ${tender_owner}  Змінити лот  ${TENDER['TENDER_UAID']}  ${USERS.users['${tender_owner}'].lot_data.lot_id}  value.amount   8000

#####
#Предмети закупівлі лоту

Можливість добавити предмет закупівлі до другого лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${item}=  Підготовка даних для створення предмету закупівлі
  Run As   ${tender_owner}   Додати предмет закупівлі в лот    ${TENDER['TENDER_UAID']}  ${USERS.users['${tender_owner}'].lot_data.lot_id}   ${item}

Неможливість видалення лоту з прив’язаними предметами закупівлі
  [Documentation]
  ...      `Видалити лот` should not pass in this test case.
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ${lot_id}=  Get Variable Value  ${USERS.users['${tender_owner}'].lot_data.lot_id}
  Require Failure  ${tender_owner}  Видалити лот  ${TENDER['TENDER_UAID']}  ${lot_id}


#######
#Запитання до лоту

Можливість задати питання до лоту
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість задати запитання
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком    ${provider}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${lot_id}=  Get Variable Value  ${USERS.users['${tender_owner}'].lot_data.lot_id}
  ${question}=  Підготовка даних для запитання
  ${question_resp}=  Run As   ${provider}   Задати питання до лоту  ${TENDER['TENDER_UAID']}  ${lot_id}  ${question}
  ${now}=  Get Current TZdate
  ${question.data.date}=  Set variable  ${now}
  ${question_id}=  get_id_from_object  ${question.data}
  ${question_data}=  Create Dictionary  question=${question}  question_resp=${question_resp}  question_id=${question_id}
  ${question_data}=  munch_dict  arg=${question_data}
  Set To Dictionary  ${USERS.users['${provider}']}  question_data=${question_data}


Можливість відповісти на запитання до лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість відповісти на запитання
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком    ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${answer}=  Підготовка даних для відповіді на запитання
  ${answer_resp}=  Run As  ${tender_owner}
  ...      Відповісти на питання  ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['question_data']['question_resp']}  ${answer}
  ...      question_id=${USERS.users['${provider}'].question_data.question_id}
  ${now}=  Get Current TZdate
  ${answer.data.date}=  Set variable  ${now}
  ${answer_data}=  Create Dictionary  answer=${answer}  answer_resp=${answer_resp}
  Set To Dictionary  ${USERS.users['${provider}']}  answer_data=${answer_data}

######
#Подання пропозицій

Відображення початку періоду прийому пропозицій оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  ...      viewer  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      minimal
  :FOR  ${username}  IN  ${viewer}  ${provider}  ${provider1}
  \  Дочекатись синхронізації з майданчиком    ${username}
  \  Звірити дату тендера  ${username}  ${USERS.users['${tender_owner}'].initial_data}  tenderPeriod.startDate

Відображення закінчення періоду прийому пропозицій оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  ...      viewer  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      minimal
  :FOR  ${username}  IN  ${viewer}  ${provider}  ${provider1}
  \  Дочекатись синхронізації з майданчиком    ${username}
  \  Звірити дату тендера  ${username}  ${USERS.users['${tender_owner}'].initial_data}  tenderPeriod.endDate

Неможливість подати цінову пропозицію до початку періоду подачі пропозицій
  [Documentation]
  ...      `Подати цінову пропозицію` should not pass in this test case.
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість подати цінову пропозицію
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком    ${provider}
  @{lots_ids}=  Отримати ідентифікатори об’єктів  ${provider}  lots
  ${bid}=  Підготувати дані для подання пропозиції
  ${bid_before_bidperiod_resp}=  Require Failure  ${provider}  Подати цінову пропозицію на лоти  ${TENDER['TENDER_UAID']}  ${bid}  ${lots_ids}
  log   ${bid_before_bidperiod_resp}

Неможливість подати цінову пропозицію без прив’язки до лоту
  [Documentation]
  ...      `Подати цінову пропозицію` should not pass in this test case.
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість подати цінову пропозицію
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком    ${provider}
  Дочекатись дати початку прийому пропозицій  ${provider}
  ${bid}=  Підготувати дані для подання пропозиції
  ${no_lot_bid_resp}=  Require Failure  ${provider}  Подати цінову пропозицію  ${TENDER['TENDER_UAID']}  ${bid}
  log   ${no_lot_bid_resp}

Можливість подати цінову пропозицію першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість подати цінову пропозицію
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  @{lots_ids}=  Отримати ідентифікатори об’єктів  ${provider}  lots
  ${bid}=  Підготувати дані для подання пропозиції
  ${bidresponses}=  Create Dictionary  bid=${bid}
  Set To Dictionary  ${USERS.users['${provider}']}   bidresponses=${bidresponses}
  ${resp}=  Run As  ${provider}  Подати цінову пропозицію на лоти  ${TENDER['TENDER_UAID']}  ${bid}  ${lots_ids}
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses}   resp=${resp}

Можливість скасувати цінову пропозицію
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість скасувати цінову пропозицію
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${canceledbidresp}=  Run As   ${provider}   Скасувати цінову пропозицію   ${TENDER['TENDER_UAID']}   ${USERS.users['${provider}'].bidresponses['resp']}
  Log  ${canceledbidresp}

Можливість подати повторно цінову пропозицію першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість подати цінову пропозицію
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Дочекатись дати початку прийому пропозицій  ${provider}
  @{lots_ids}=  Отримати ідентифікатори об’єктів  ${provider}  lots
  ${bid}=  Підготувати дані для подання пропозиції
  ${bidresponses}=  Create Dictionary  bid=${bid}
  Set To Dictionary  ${USERS.users['${provider}']}   bidresponses=${bidresponses}
  ${resp}=  Run As  ${provider}  Подати цінову пропозицію на лоти  ${TENDER['TENDER_UAID']}  ${bid}  ${lots_ids}
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses}   resp=${resp}

Можливість змінити повторну цінову пропозицію до 2000
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість змінити цінову пропозицію
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${fixbidto2000resp}=  Run As   ${provider}   Змінити цінову пропозицію   ${TENDER['TENDER_UAID']}   lotValues.0.value.amount  2000
  log  ${fixbidto2000resp}

Можливість змінити повторну цінову пропозицію до 10
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість змінити цінову пропозицію
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${fixbidto10resp}=  Run As   ${provider}   Змінити цінову пропозицію   ${TENDER['TENDER_UAID']}   lotValues.0.value.amount  10
  log  ${fixbidto10resp}

Можливість подати цінову пропозицію другим учасником
  [Tags]   ${USERS.users['${provider1}'].broker}: Можливість подати цінову пропозицію
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком    ${provider1}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Дочекатись дати початку прийому пропозицій  ${provider1}
  @{lots_ids}=  Отримати ідентифікатори об’єктів  ${provider1}  lots
  ${bid}=  Підготувати дані для подання пропозиції
  ${bidresponses}=  Create Dictionary  bid=${bid}
  Set To Dictionary  ${USERS.users['${provider1}']}   bidresponses=${bidresponses}
  ${resp}=  Run As  ${provider1}  Подати цінову пропозицію на лоти  ${TENDER['TENDER_UAID']}  ${bid}  ${lots_ids}
  Set To Dictionary  ${USERS.users['${provider1}'].bidresponses}   resp=${resp}

Неможливість побачити цінові пропозиції учасників під час прийому пропозицій
  [Tags]   ${USERS.users['${viewer}'].broker}: Можливість подати цінову пропозицію
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком    ${viewer}
  Require Failure  ${viewer}  Отримати інформацію із тендера  bids

Неможливість змінити цінову пропозицію до 2000 після закінчення прийому пропозицій
  [Documentation]
  ...      `Змінити цінову пропозицію` should not pass in this test case.
  [Tags]   ${USERS.users['${provider1}'].broker}: Неможливість змінити цінову пропозицію до 2000 після закінчення прийому пропозицій
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком    ${provider1}
  Дочекатись дати закінчення прийому пропозицій  ${provider1}
  ${failfixbidto2000resp}=  Require Failure  ${provider1}  Змінити цінову пропозицію  ${TENDER['TENDER_UAID']}  lotValues.0.value.amount  2000
  log  ${failfixbidto2000resp}

Неможливість змінити цінову пропозицію до 1 після закінчення прийому пропозицій
  [Documentation]
  ...      `Змінити цінову пропозицію` should not pass in this test case.
  [Tags]   ${USERS.users['${provider1}'].broker}: Неможливість змінити цінову пропозицію до 1 після закінчення прийому пропозицій
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ${failfixbidto1resp}=  Require Failure  ${provider1}  Змінити цінову пропозицію  ${TENDER['TENDER_UAID']}  lotValues.0.value.amount  1
  log  ${failfixbidto1resp}

Неможливість скасувати цінову пропозицію
  [Documentation]
  ...      `Скасувати цінову пропозицію` should not pass in this test case.
  [Tags]   ${USERS.users['${provider1}'].broker}: Можливість скасувати цінову пропозицію
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ${biddingresponse}=  Require Failure  ${provider1}  Скасувати цінову пропозицію  ${TENDER['TENDER_UAID']}  ${USERS.users['${provider1}'].bidresponses['resp']}
  log  ${biddingresponse}
