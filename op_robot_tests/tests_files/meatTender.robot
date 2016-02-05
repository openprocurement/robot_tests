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
Можливість оголосити однопредметний тендер з неціновим показником
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  [Documentation]   Створення закупівлі замовником, обовязково має повертати UAID закупівлі (номер тендера),
  ${base_tender_data}=  Підготовка початкових даних
  ${tender_data}=  test_meat_tender_data  ${base_tender_data}
  ${TENDER_UAID}=  Викликати для учасника     ${tender_owner}    Створити тендер  ${tender_data}
  ${LAST_MODIFICATION_DATE}=  Get Current Date
  Set To Dictionary  ${TENDER}   TENDER_UAID             ${TENDER_UAID}
  Set To Dictionary  ${TENDER}   LAST_MODIFICATION_DATE  ${LAST_MODIFICATION_DATE}
  log  ${TENDER}

Пошук однопредметного тендера по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук тендера по ідентифікатору
  Дочекатись синхронізації з майданчиком    ${viewer}
  Викликати для учасника   ${viewer}   Пошук тендера по ідентифікатору   ${TENDER['TENDER_UAID']}

Неможливість перевищити ліміт для нецінових критеріїв
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  ${invalid_features}=  test_invalid_features_data
  ${fail}=  Викликати для учасника   ${tender_owner}  Внести зміни в тендер  shouldfail   ${TENDER['TENDER_UAID']}   features   ${invalid_features}
  Log   ${fail}

######
#Подання пропозицій

Неможливість подати цінову пропозицію без нецінового показника
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість подати цінову пропозицію
  Дочекатись дати початку прийому пропозицій
  sleep  90
  ${bid}=  test bid data
  Log  ${bid}
  ${biddingresponse0}=  Викликати для учасника   ${provider}   Подати цінову пропозицію   shouldfail   ${TENDER['TENDER_UAID']}   ${bid}
  log  ${biddingresponse0}

Подати цінову пропозицію з неціновим показником
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість подати цінову пропозицію
  ${bid}=  test bid data meat tender
  Log  ${bid}
  ${resp}=  Викликати для учасника   ${provider}   Подати цінову пропозицію   ${TENDER['TENDER_UAID']}   ${bid}
  ${biddingresponse0}=  Create Dictionary
  Set To Dictionary  ${biddingresponse0}                 resp  ${resp}
  Set To Dictionary  ${USERS.users['${provider}']}   biddingresponse0  ${biddingresponse0}
  log  ${resp}

Можливість змінити неціновий показник повторної цінової пропозиції до 0
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість змінити цінову пропозицію
  Set To Dictionary  ${USERS.users['${provider}'].biddingresponse0['resp'].data.parameters[0]}  value   0
  Log   ${USERS.users['${provider}'].biddingresponse0['resp'].data.parameters[0]}
  ${fixbidparamsto0resp}=  Викликати для учасника   ${provider}   Змінити цінову пропозицію   ${TENDER['TENDER_UAID']}   ${USERS.users['${provider}'].biddingresponse0['resp']}
  Set To Dictionary  ${USERS.users['${provider}'].biddingresponse0}   fixbidparamsto0resp   ${fixbidparamsto0resp}
  log  ${fixbidparamsto0resp}

Можливість змінити неціновий показник повторної цінової пропозиції до 0.15
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість змінити цінову пропозицію
  Set To Dictionary  ${USERS.users['${provider}'].biddingresponse0['resp'].data.parameters[0]}  value   0.15
  Log   ${USERS.users['${provider}'].biddingresponse0['resp'].data.parameters[0]}
  ${fixbidparamsto015resp}=  Викликати для учасника   ${provider}   Змінити цінову пропозицію   ${TENDER['TENDER_UAID']}   ${USERS.users['${provider}'].biddingresponse0['resp']}
  Set To Dictionary  ${USERS.users['${provider}'].biddingresponse0}   fixbidparamsto015resp   ${fixbidparamsto015resp}
  log  ${fixbidparamsto015resp}

Подати цінову пропозицію з неціновим показником другим учасником
  [Tags]   ${USERS.users['${provider1}'].broker}: Можливість подати цінову пропозицію
  Дочекатись дати початку прийому пропозицій
  ${bid}=  test bid data meat tender
  Log  ${bid}
  ${bidresponses}=  Create Dictionary
  ${resp}=  Викликати для учасника   ${provider1}   Подати цінову пропозицію   ${TENDER['TENDER_UAID']}   ${bid}
  Set To Dictionary  ${bidresponses}                 resp  ${resp}
  Set To Dictionary  ${USERS.users['${provider1}']}   bidresponses  ${bidresponses}
  log  ${resp}
  log  ${USERS.users['${provider1}'].bidresponses}

######
#Аукціон

Очікування аукціону
  Дочекатись синхронізації з майданчиком    ${tender_owner}
  ${tender_data}=  Викликати для учасника   ${tender_owner}   Пошук тендера по ідентифікатору   ${TENDER['TENDER_UAID']}
  log    ${tender_data.data.auctionPeriod.startDate}
  Дочекатись дати початку аукціону
  sleep  1500

Завершення аукціону
  Дочекатись синхронізації з майданчиком    ${tender_owner}
  ${tender_data}=  Викликати для учасника   ${tender_owner}   Пошук тендера по ідентифікатору   ${TENDER['TENDER_UAID']}
  ${result}=    chef  ${tender_data.data.bids}  ${tender_data.data.features}
  Log Many  ${result[0]}  ${tender_data.data.awards[0]}
  Log Many  ${result[0].id}  ${tender_data.data.awards[0].bid_id}
  Should Be Equal   ${result[0].id}  ${tender_data.data.awards[0].bid_id}
