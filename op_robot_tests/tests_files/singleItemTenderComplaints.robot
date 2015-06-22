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
${item_id}       0
${question_id}   0


${tender_owner}  Tender_Owner
${provider}   Tender_User
${provider1}   Tender_User1
${viewer}   Tender_Viewer

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
  ${ids}=  Викликати для учасника     ${tender_owner}    Створити тендер  ${INITIAL_TENDER_DATA}
  ${TENDER_ID}=   Get From List   ${ids}  0  
  ${TENDER_ID1}=  Get From List   ${ids}  1 
  Set Global Variable    ${TENDER_ID}
  Set Global Variable    ${TENDER_ID1}
  ${LAST_MODIFICATION_DATE}=  Get Current Date
  Set Global Variable   ${LAST_MODIFICATION_DATE}
  
Пошук однопредметного тендера по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук тендера по ідентифікатору
  Дочекатись синхронізації з майданчиком    ${viewer}
  Викликати для учасника   ${viewer}   Пошук тендера по ідентифікатору   ${TENDER_ID}   ${TENDER_ID}

Можливість подати скаргу на умови
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість подати скаргу на умови
  Викликати для учасника   ${provider}   Подати скаргу    ${TENDER_ID}   ${COMPLAINTS[0]}
  ${LAST_MODIFICATION_DATE}=  Get Current Date
  Set Global Variable   ${LAST_MODIFICATION_DATE}

Можливість відхилити скаргу на умови
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість відхилити скаргу на умови
  Set To Dictionary  ${COMPLAINTS[0].data}   status   declined
  Викликати для учасника   ${tender_owner}   Обробити скаргу    ${TENDER_ID}  0  ${COMPLAINTS[0]}
  log many   ${COMPLAINTS[0]}
  викликати для учасника   ${viewer}   обновити сторінку з тендером   ${TENDER_ID}   ${TENDER_ID}

Можливість відкинути скаргу на умови
  [Tags]    ${USERS.users['${tender_owner}'].broker}: Можливість відкинути скаргу на умови
  Викликати для учасника   ${provider}   Подати скаргу    ${TENDER_ID}   ${COMPLAINTS[0]}
  ${LAST_MODIFICATION_DATE}=  Get Current Date
  Set Global Variable   ${LAST_MODIFICATION_DATE}
  Викликати для учасника   ${viewer}   обновити сторінку з тендером   ${TENDER_ID}   ${TENDER_ID}
  Set To Dictionary  ${COMPLAINTS[0].data}   status   invalid
  Викликати для учасника   ${tender_owner}   Обробити скаргу    ${TENDER_ID}  1  ${COMPLAINTS[0]}
  log many   ${COMPLAINTS[0]}
  ${LAST_MODIFICATION_DATE}=  Get Current Date
  Set Global Variable   ${LAST_MODIFICATION_DATE}
  Викликати для учасника   ${viewer}   обновити сторінку з тендером   ${TENDER_ID}   ${TENDER_ID}
  
Можливість задовільнити скаргу на умови
  [Tags]    ${USERS.users['${provider}'].broker}: Можливість відповісти на запитання
  Викликати для учасника   ${provider}   Подати скаргу    ${TENDER_ID}   ${COMPLAINTS[0]}
  ${LAST_MODIFICATION_DATE}=  Get Current Date
  Set Global Variable   ${LAST_MODIFICATION_DATE}
  Викликати для учасника   ${viewer}   обновити сторінку з тендером   ${TENDER_ID}   ${TENDER_ID}
  Set To Dictionary  ${COMPLAINTS[0].data}   status   resolved
  Викликати для учасника   ${tender_owner}   Обробити скаргу    ${TENDER_ID}  2  ${COMPLAINTS[0]}
  log many   ${COMPLAINTS[0]}
  ${LAST_MODIFICATION_DATE}=  Get Current Date
  Set Global Variable   ${LAST_MODIFICATION_DATE}
    


