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
Можливість оголосити однопредметний тендер
  [Tags]   ${USERS.users['${USERS.tender_owner}'].broker}: Можливість оголосити тендер
  Викликати для учасника     ${USERS.tender_owner}   Створити тендер
  ${LAST_MODIFICATION_DATE}=  Get Current Date
  Set Global Variable   ${LAST_MODIFICATION_DATE}

Пошук тендера по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук тендера по ідентифікатору
  Дочекатись синхронізації з майданчиком    ${viewer}
  Викликати для учасника   ${viewer}   Пошук тендера по ідентифікатору   ${TENDER_DATA.data.tenderID}   ${TENDER_DATA.data.id}
  
Можливість подати скаргу на умови
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість подати скаргу на умови
  Викликати для учасника   ${provider}   Подати скаргу    ${TENDER_DATA.data.id}   ${COMPLAINTS[0]}
  ${LAST_MODIFICATION_DATE}=  Get Current Date
  Set Global Variable   ${LAST_MODIFICATION_DATE}
  отримати останні зміни в тендері  

Можливість відхилити скаргу на умови
  [Tags]   ${USERS.users['${USERS.tender_owner}'].broker}: Можливість відхилити скаргу на умови
  Set To Dictionary  ${COMPLAINTS[0].data}   status   declined
  Викликати для учасника   ${USERS.tender_owner}   Обробити скаргу    ${TENDER_DATA.data.id}  0  ${COMPLAINTS[0]}
  log many   ${COMPLAINTS[0]}
  ${LAST_MODIFICATION_DATE}=  Get Current Date
  Set Global Variable   ${LAST_MODIFICATION_DATE}
  отримати останні зміни в тендері

Можливість відкинути скаргу на умови
  [Tags]    ${USERS.users['${USERS.tender_owner}'].broker}: Можливість відкинути скаргу на умови
  Викликати для учасника   ${provider}   Подати скаргу    ${TENDER_DATA.data.id}   ${COMPLAINTS[0]}
  ${LAST_MODIFICATION_DATE}=  Get Current Date
  Set Global Variable   ${LAST_MODIFICATION_DATE}
  отримати останні зміни в тендері    
  Set To Dictionary  ${COMPLAINTS[0].data}   status   invalid
  Викликати для учасника   ${USERS.tender_owner}   Обробити скаргу    ${TENDER_DATA.data.id}  1  ${COMPLAINTS[0]}
  log many   ${COMPLAINTS[0]}
  ${LAST_MODIFICATION_DATE}=  Get Current Date
  Set Global Variable   ${LAST_MODIFICATION_DATE}
  отримати останні зміни в тендері
  
Можливість задовільнити скаргу на умови
  [Tags]    ${USERS.users['${provider}'].broker}: Можливість відповісти на запитання
  Викликати для учасника   ${provider}   Подати скаргу    ${TENDER_DATA.data.id}   ${COMPLAINTS[0]}
  ${LAST_MODIFICATION_DATE}=  Get Current Date
  Set Global Variable   ${LAST_MODIFICATION_DATE}
  отримати останні зміни в тендері      
  Set To Dictionary  ${COMPLAINTS[0].data}   status   resolved
  Викликати для учасника   ${USERS.tender_owner}   Обробити скаргу    ${TENDER_DATA.data.id}  2  ${COMPLAINTS[0]}
  log many   ${COMPLAINTS[0]}
  ${LAST_MODIFICATION_DATE}=  Get Current Date
  Set Global Variable   ${LAST_MODIFICATION_DATE}
    


