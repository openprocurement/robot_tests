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
${mode}         meat

${role}         viewer
${broker}       Quinta

${question_id}  0
*** Test Cases ***
Можливість оголосити однопредметний тендер з неціновим показником
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер з неціновим показником
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      minimal
  [Documentation]   Створення закупівлі замовником, обовязково має повертати UAID закупівлі (номер тендера),
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
  Можливість задати питання

##############################################################################################
#             ВІДОБРАЖЕННЯ
##############################################################################################

Відображення заголовку анонімного питання без відповіді
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення анонімного питання без відповіді
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      critical level 2
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Відображення заголовку анонімного питання без відповіді


Відображення опису анонімного питання без відповіді
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення анонімного питання без відповіді
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      critical level 2
  Відображення опису анонімного питання без відповіді


Відображення дати анонімного питання без відповіді
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення анонімного питання без відповіді
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Відображення дати анонімного питання без відповіді

##############################################################################################
#             МОЖЛИВІСТЬ
##############################################################################################

Можливість відповісти на питання
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість відповісти на питання
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      critical level 2
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість відповісти на питання

##############################################################################################
#             ВІДОБРАЖЕННЯ
##############################################################################################

Відображення відповіді на запитання
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення відповіді на запитання
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      critical level 2
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Відображення відповіді на запитання

##############################################################################################
#             МОЖЛИВІСТЬ
##############################################################################################

Неможливість перевищити ліміт для нецінових критеріїв
  [Documentation]
  ...      `Внести зміни в тендер` should not pass in this test case.
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком    ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${invalid_features}=  test_invalid_features_data
  ${fail}=  Require Failure  ${tender_owner}  Внести зміни в тендер  ${TENDER['TENDER_UAID']}  features  ${invalid_features}
  Log   ${fail}

######
#Подання пропозицій

Неможливість подати цінову пропозицію без нецінового показника
  [Documentation]
  ...      `Подати цінову пропозицію` should not pass in this test case.
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість подати цінову пропозицію
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком    ${provider}
  Дочекатись дати початку прийому пропозицій  ${provider}
  sleep  90
  ${bid}=  test bid data
  Log  ${bid}
  ${failbid}=  Require Failure  ${provider}  Подати цінову пропозицію  ${TENDER['TENDER_UAID']}  ${bid}
  log  ${failbid}


Можливість подати цінову пропозицію з неціновим показником
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість подати цінову пропозицію
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${bid}=  test bid data meat tender
  Log  ${bid}
  ${bidresponses}=  Create Dictionary
  Set To Dictionary  ${bidresponses}                 bid   ${bid}
  Set To Dictionary  ${USERS.users['${provider}']}   bidresponses  ${bidresponses}
  ${resp}=  Викликати для учасника   ${provider}   Подати цінову пропозицію   ${TENDER['TENDER_UAID']}   ${bid}
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses}   resp  ${resp}
  log  ${resp}


Можливість змінити неціновий показник повторної цінової пропозиції до 0
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість змінити цінову пропозицію
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${fixbidparamsto0resp}=  Викликати для учасника   ${provider}   Змінити цінову пропозицію   ${TENDER['TENDER_UAID']}   parameters.0.value  0
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses}   fixbidparamsto0resp   ${fixbidparamsto0resp}
  log  ${fixbidparamsto0resp}


Можливість змінити неціновий показник повторної цінової пропозиції до 0.15
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість змінити цінову пропозицію
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${fixbidparamsto015resp}=  Викликати для учасника   ${provider}   Змінити цінову пропозицію   ${TENDER['TENDER_UAID']}   parameters.0.value  0.15
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses}   fixbidparamsto015resp   ${fixbidparamsto015resp}
  log  ${fixbidparamsto015resp}


Можливість подати цінову пропозицію з неціновим показником другим учасником
  [Tags]   ${USERS.users['${provider1}'].broker}: Можливість подати цінову пропозицію
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком    ${provider1}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Дочекатись дати початку прийому пропозицій  ${provider1}
  ${bid}=  test bid data meat tender
  Log  ${bid}
  ${bidresponses}=  Create Dictionary
  Set To Dictionary  ${bidresponses}                 bid  ${bid}
  Set To Dictionary  ${USERS.users['${provider1}']}   bidresponses  ${bidresponses}
  ${resp}=  Викликати для учасника   ${provider1}   Подати цінову пропозицію   ${TENDER['TENDER_UAID']}   ${bid}
  Set To Dictionary  ${USERS.users['${provider1}'].bidresponses}   resp  ${resp}
  log  ${resp}
  log  ${USERS.users['${provider1}'].bidresponses}

######
#Аукціон

Відображення дати початку аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      minimal
  [Setup]  Дочекатись синхронізації з майданчиком    ${viewer}
  Викликати для учасника  ${viewer}  Отримати інформацію із тендера  auctionPeriod.startDate


Очікування аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Очікування аукціону
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Дочекатись дати початку аукціону  ${viewer}
  sleep  1500


Можливість отримати результати аукціону
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Результати аукціону
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком    ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${tender_data}=  Викликати для учасника   ${tender_owner}   Пошук тендера по ідентифікатору   ${TENDER['TENDER_UAID']}
  ${result}=    chef  ${tender_data.data.bids}  ${tender_data.data.features}
  Log Many  ${result[0]}  ${tender_data.data.awards[0]}
  Log Many  ${result[0].id}  ${tender_data.data.awards[0].bid_id}
  Should Be Equal   ${result[0].id}  ${tender_data.data.awards[0].bid_id}
