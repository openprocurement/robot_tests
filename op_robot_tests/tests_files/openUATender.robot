*** Settings ***
Library         op_robot_tests.tests_files.service_keywords
Library         String
Library         Collections
Library         Selenium2Library
Library         DebugLibrary
Resource        keywords.robot
Resource        resource.robot
Suite Setup     TestSuiteSetup
Suite Teardown  Close all browsers

*** Variables ***
${mode}         single

${role}         viewer
${broker}       Quinta


*** Test Cases ***
Можливість оголосити позапороговий однопредметний тендер
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  [Documentation]   Створення закупівлі замовником, обовязково має повертати UAID закупівлі (номер тендера),
  ${tender_data}=  Підготовка початкових даних
  ${tender_data}=  test_open_ua_tender_data  ${tender_data}
  ${TENDER_UAID}=  Викликати для учасника  ${tender_owner}  Створити тендер  ${tender_data}
  ${LAST_MODIFICATION_DATE}=  Get Current TZdate
  Set To Dictionary  ${USERS.users['${tender_owner}']}  initial_data  ${tender_data}
  Set To Dictionary  ${TENDER}   TENDER_UAID             ${TENDER_UAID}
  Set To Dictionary  ${TENDER}   LAST_MODIFICATION_DATE  ${LAST_MODIFICATION_DATE}
  Log  ${TENDER}

Пошук позапорогового однопредметного тендера по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук тендера по ідентифікатору
  Дочекатись синхронізації з майданчиком    ${viewer}
  Викликати для учасника   ${viewer}   Пошук тендера по ідентифікатору   ${TENDER['TENDER_UAID']}


Відображення типу закупівлі оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  procurementMethodType

Можливість подати вимогу на умови більше ніж за 10 днів до завершення періоду подання пропозицій
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість подати вимогу на умови
  [Documentation]    Користувач  ${USERS.users['${provider}'].broker}  намагається подати скаргу на умови оголошеної  закупівлі
  Set To Dictionary  ${COMPLAINTS[0].data}   status   claim
  Викликати для учасника   ${provider}   Подати скаргу    ${TENDER['TENDER_UAID']}   ${COMPLAINTS[0]}

Можливість скасувати скаргу на умови
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість скасувати скаргу на умови
  Set To Dictionary  ${COMPLAINTS[0].data}   status   cancelled
  Set To Dictionary  ${COMPLAINTS[0].data}   cancellationReason   test_draft_cancellation
  Викликати для учасника   ${provider}     Обробити скаргу    ${TENDER['TENDER_UAID']}  0  ${COMPLAINTS[0]}
  Remove From Dictionary  ${COMPLAINTS[0].data}   cancellationReason   status
  Викликати для учасника   ${viewer}   Оновити сторінку з тендером   ${TENDER['TENDER_UAID']}

Подати цінову пропозицію першим учасником після оголошення тендеру
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість подати цінову пропозицію
  ${bid}=  test bid data
  Log  ${bid}
  ${bidresponses}=  Create Dictionary
  ${resp}=  Викликати для учасника   ${provider}   Подати цінову пропозицію  ${TENDER['TENDER_UAID']}   ${bid}
  Set To Dictionary  ${bidresponses}                 resp  ${resp}
  Set To Dictionary  ${USERS.users['${provider}']}   bidresponses  ${bidresponses}
  log  ${resp}
  log  ${USERS.users['${provider}'].bidresponses}

Подати цінову пропозицію другим учасником
  [Tags]   ${USERS.users['${provider1}'].broker}: Можливість подати цінову пропозицію
  ${bid}=  test bid data
  Log  ${bid}
  ${bidresponses}=  Create Dictionary
  ${resp}=  Викликати для учасника   ${provider1}   Подати цінову пропозицію   ${TENDER['TENDER_UAID']}   ${bid}
  Set To Dictionary  ${bidresponses}                 resp  ${resp}
  Set To Dictionary  ${USERS.users['${provider1}']}   bidresponses  ${bidresponses}
  log  ${resp}
  log  ${USERS.users['${provider1}'].bidresponses}

Можливість редагувати однопредметний тендер більше ніж за 7 днів до завершення періоду подання пропозицій
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  Викликати для учасника   ${tender_owner}  Внести зміни в тендер  ${TENDER['TENDER_UAID']}   description     description

Перевірити на зміну статус пропозицій після редагування інформації про закупівлю
  Дочекатись синхронізації з майданчиком    ${provider}
  Викликати для учасника   ${provider}   Пошук тендера по ідентифікатору   ${TENDER['TENDER_UAID']}
  Викликати для учасника   ${provider1}   Пошук тендера по ідентифікатору   ${TENDER['TENDER_UAID']}
  ${bid}=  Викликати для учасника  ${provider}  Отримати пропозицію  ${TENDER['TENDER_UAID']}
  ${bid1}=  Викликати для учасника  ${provider1}  Отримати пропозицію  ${TENDER['TENDER_UAID']}
  Should Be Equal  ${bid.data.status}  invalid
  Should Be Equal  ${bid1.data.status}  invalid
  Log  ${bid}

Оновити статус цінової пропозиції першого учасника
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість змінити цінову пропозицію
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses['resp'].data}  status   active
  Log   ${USERS.users['${provider}'].bidresponses['resp'].data.status}
  ${activestatusresp}=  Викликати для учасника   ${provider}   Змінити цінову пропозицію   ${TENDER['TENDER_UAID']}   ${USERS.users['${provider}'].bidresponses['resp']}
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses}   activestatusresp   ${activestatusresp}
  log  ${activestatusresp}

Cкасувати цінову пропозицію другого учасника
  [Tags]   ${USERS.users['${provider1}'].broker}: Можливість скасувати цінову пропозицію
  ${bid}=  Get Variable Value  ${USERS.users['${provider1}'].bidresponses['resp']}
  ${bidresponses}=  Викликати для учасника   ${provider1}   Скасувати цінову пропозицію   ${TENDER['TENDER_UAID']}   ${bid}

Повторно подати цінову пропозицію другим учасником після першої зміни
  [Tags]   ${USERS.users['${provider1}'].broker}: Можливість подати цінову пропозицію
  ${bid}=  test bid data
  Log  ${bid}
  ${bidresponses}=  Create Dictionary
  ${resp}=  Викликати для учасника   ${provider1}   Подати цінову пропозицію   ${TENDER['TENDER_UAID']}   ${bid}
  Set To Dictionary  ${bidresponses}                 resp  ${resp}
  Set To Dictionary  ${USERS.users['${provider1}']}   bidresponses  ${bidresponses}
  log  ${resp}
  log  ${USERS.users['${provider1}'].bidresponses}

Неможливість редагувати однопредметний тендер менше ніж за 7 днів до завершення періоду подання пропозицій
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  Sleep  480
  Викликати для учасника   ${tender_owner}  Внести зміни в тендер  shouldfail  ${TENDER['TENDER_UAID']}   description     description

Неможливість подати вимогу на умови менще ніж за 10 днів до завершення періоду подання пропозицій
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість подати вимогу на умови
  [Documentation]    Користувач  ${USERS.users['${provider}'].broker}  намагається подати скаргу на умови оголошеної  закупівлі
  Set To Dictionary  ${COMPLAINTS[0].data}   status   claim
  Викликати для учасника   ${provider}   Подати скаргу   shouldfail   ${TENDER['TENDER_UAID']}   ${COMPLAINTS[0]}

Продовжити період редагування подання пропозиції на 7 днів
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  ${tender_data}=  Викликати для учасника   ${tender_owner}   Пошук тендера по ідентифікатору   ${TENDER['TENDER_UAID']}
  ${endDate}=  get_future_date   ${tender_data.data.tenderPeriod.endDate}  7
  Викликати для учасника   ${tender_owner}  Внести зміни в тендер  ${TENDER['TENDER_UAID']}   tenderPeriod.endDate     ${endDate}

Можливість редагувати однопредметний тендер після продовження періоду подання пропозицій
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  Викликати для учасника   ${tender_owner}  Внести зміни в тендер  ${TENDER['TENDER_UAID']}   description     description

Перевірити на зміну статус пропозицій після редагування інформації про закупівлю після другої зміни
  Дочекатись синхронізації з майданчиком    ${provider}
  Викликати для учасника   ${provider}   Пошук тендера по ідентифікатору   ${TENDER['TENDER_UAID']}
  Викликати для учасника   ${provider1}   Пошук тендера по ідентифікатору   ${TENDER['TENDER_UAID']}
  ${bid}=  Викликати для учасника  ${provider}  Отримати пропозицію  ${TENDER['TENDER_UAID']}
  ${bid1}=  Викликати для учасника  ${provider1}  Отримати пропозицію  ${TENDER['TENDER_UAID']}
  Should Be Equal  ${bid.data.status}  invalid
  Should Be Equal  ${bid1.data.status}  invalid
  Log  ${bid}

Оновити статус цінової пропозиції першого учасника після другої зміни
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість змінити цінову пропозицію
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses['resp'].data}  status   active
  Log   ${USERS.users['${provider}'].bidresponses['resp'].data.status}
  ${activestatusresp}=  Викликати для учасника   ${provider}   Змінити цінову пропозицію   ${TENDER['TENDER_UAID']}   ${USERS.users['${provider}'].bidresponses['resp']}
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses}   activestatusresp   ${activestatusresp}
  log  ${activestatusresp}

Повторно подати цінову пропозицію другим учасником після другої зміни
  [Tags]   ${USERS.users['${provider1}'].broker}: Можливість подати цінову пропозицію
  ${bid}=  test bid data
  Log  ${bid}
  ${bidresponses}=  Create Dictionary
  ${resp}=  Викликати для учасника   ${provider1}   Подати цінову пропозицію   ${TENDER['TENDER_UAID']}   ${bid}
  Set To Dictionary  ${bidresponses}                 resp  ${resp}
  Set To Dictionary  ${USERS.users['${provider1}']}   bidresponses  ${bidresponses}
  log  ${resp}
  log  ${USERS.users['${provider1}'].bidresponses}

Неможливість подати скаргу на умови менше ніж за 4 днів до завершення періоду подання пропозицій
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість подати скаргу на умови
  [Documentation]    Користувач  ${USERS.users['${provider}'].broker}  намагається подати скаргу на умови оголошеної  закупівлі
  ${tender_data}=  Викликати для учасника   ${tender_owner}   Пошук тендера по ідентифікатору   ${TENDER['TENDER_UAID']}
  Log  ${tender_data.data.complaintPeriod.endDate}
  Дочекатись Дати   ${tender_data.data.complaintPeriod.endDate}
  Дочекатись синхронізації з майданчиком    ${provider}
  Set To Dictionary  ${COMPLAINTS[0].data}   status   pending
  Викликати для учасника   ${provider}   Подати скаргу   shouldfail   ${TENDER['TENDER_UAID']}   ${COMPLAINTS[0]}
