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
${viewer}    Tender Viewer
${provider}   Tender User


*** Test Cases ***
Можливість оголосити багатопредметний тендер 
  [Tags]   ${USERS.users['${USERS.tender_owner}'].broker}: Можливість оголосити багатопредметний тендер 
  Викликати для учасника     ${USERS.tender_owner}   Створити багатопредметний тендер
  ${LAST_MODIFICATION_DATE}=  Get Current Date
  Set Global Variable   ${LAST_MODIFICATION_DATE}

Пошук тендера по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук тендера по ідентифікатору
  Дочекатись синхронізації з майданчиком    ${viewer}
  Викликати для учасника   ${viewer}   Пошук тендера по ідентифікатору   ${TENDER_DATA.data.tenderID}   ${TENDER_DATA.data.id}
  
Можливість редагувати однопредметний тендер
  [Tags]   ${USERS.users['${USERS.tender_owner}'].broker}: Можливість оголосити тендер
  Викликати для учасника   ${USERS.tender_owner}   Внести зміни в тендер     ${TENDER_DATA.data.id}   description     description

Можливість додати позицію закупівлі в тендер
  [Tags]   ${USERS.users['${USERS.tender_owner}'].broker}: Можливість оголосити тендер
  Викликати для учасника   ${USERS.tender_owner}   додати предмети закупівлі    ${TENDER_DATA.data.id}   3

Можливість видалити позиції закупівлі тендера
  [Tags]   ${USERS.users['${USERS.tender_owner}'].broker}: Можливість оголосити тендер
  Викликати для учасника   ${USERS.tender_owner}   додати предмети закупівлі    ${TENDER_DATA.data.id}   2
  
Подати цінову пропозицію
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість подати цінову пропозицію
  Дочекатись дати початоку прийому пропозицій
  ${bid}=  test bid data
  Log object data  ${bid}
  ${biddingresponce}=  Викликати для учасника   ${provider}   Подати цінову пропозицію   ${TENDER_DATA.data.id}   ${bid}
  Set Global Variable   ${biddingresponce}

Прийняти пропозицію переможця 
  [Tags]   ${USERS.users['${USERS.tender_owner}'].broker}: Можливість прийняти пропозицію переможця
  Дочекатись дати закінчення прийому пропозицій
  ${LAST_MODIFICATION_DATE}=  Get Current Date
  Set Global Variable   ${LAST_MODIFICATION_DATE}
  отримати останні зміни в тендері
  ${award}=  test_award_data
  ${award_data}=   Get_From_Object  ${TENDER_DATA.data}   awards[0]
  Set To Dictionary  ${award}  data  ${award_data}
  Set To Dictionary  ${award['data']}  status  active
  Викликати для учасника   ${USERS.tender_owner}   Прийняти цінову пропозицію   ${TENDER_DATA.data.id}   ${award}

