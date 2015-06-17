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
${tender_dump_id}    0
${item_id}       0
${question_id}   0


${tender_owner}  Tender Owner
${provider}   Tender User
${provider1}   Tender User1
${viewer}   Tender Viewer

${LOAD_USERS}      ["${tender_owner}", "${provider}", "${provider1}", "${viewer}"]
#Avalable roles and users

#roles: Owner, User, Viewer

#palyers:
  #E-tender
  #Prom
  #SmartTender
  #Publicbid
  #Netcast

*** Test Cases ***
Можливість оголосити однопердметний тендер
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  Викликати для учасника     ${tender_owner}   Створити тендер  ${INITIAL_TENDER_DATA}
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
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість відхилити скаргу на умови
  Set To Dictionary  ${COMPLAINTS[0].data}   status   declined
  Викликати для учасника   ${tender_owner}   Обробити скаргу    ${TENDER_DATA.data.id}  0  ${COMPLAINTS[0]}
  log many   ${COMPLAINTS[0]}
  ${LAST_MODIFICATION_DATE}=  Get Current Date
  Set Global Variable   ${LAST_MODIFICATION_DATE}
  отримати останні зміни в тендері

Можливість відкинути скаргу на умови
  [Tags]    ${USERS.users['${tender_owner}'].broker}: Можливість відкинути скаргу на умови
  Викликати для учасника   ${provider}   Подати скаргу    ${TENDER_DATA.data.id}   ${COMPLAINTS[0]}
  ${LAST_MODIFICATION_DATE}=  Get Current Date
  Set Global Variable   ${LAST_MODIFICATION_DATE}
  отримати останні зміни в тендері    
  Set To Dictionary  ${COMPLAINTS[0].data}   status   invalid
  Викликати для учасника   ${tender_owner}   Обробити скаргу    ${TENDER_DATA.data.id}  1  ${COMPLAINTS[0]}
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
  Викликати для учасника   ${tender_owner}   Обробити скаргу    ${TENDER_DATA.data.id}  2  ${COMPLAINTS[0]}
  log many   ${COMPLAINTS[0]}
  ${LAST_MODIFICATION_DATE}=  Get Current Date
  Set Global Variable   ${LAST_MODIFICATION_DATE}
    


