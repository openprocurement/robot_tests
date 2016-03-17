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
${mode}         meat

${role}         viewer
${broker}       Quinta

*** Test Cases ***
Можливість оголосити однопредметний тендер з неціновим показником
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер з неціновим показником
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      minimal
  [Documentation]   Створення закупівлі замовником, обовязково має повертати UAID закупівлі (номер тендера),
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${tender_data}=  Підготовка даних для створення тендера
  ${TENDER_UAID}=  Викликати для учасника  ${tender_owner}  Створити тендер  ${tender_data}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  initial_data  ${tender_data}
  Set To Dictionary  ${TENDER}   TENDER_UAID             ${TENDER_UAID}
  Log  ${TENDER}


Можливість знайти однопредметний тендер по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук тендера по ідентифікатору
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      minimal
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}  ${provider}  ${provider1}
  \  Дочекатись синхронізації з майданчиком    ${username}
  \  Викликати для учасника  ${username}  Пошук тендера по ідентифікатору   ${TENDER['TENDER_UAID']}


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

Відображення початку періоду прийому пропозицій оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук тендера по ідентифікатору
  ...      viewer  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${provider}'].broker}
  ...      ${USERS.users['${provider1}'].broker}
  ...      minimal
  :FOR  ${username}  IN  ${viewer}  ${provider}  ${provider1}
  \  Дочекатись синхронізації з майданчиком    ${username}
  \  Звірити дату тендера  ${username}  ${USERS.users['${tender_owner}'].initial_data}  tenderPeriod.startDate


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
