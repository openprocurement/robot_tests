*** Setting ***
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
${tender_dump_id}    0
${mode}       single

${tender_owner}  Tender_Owner
${provider}   Tender_User
${provider1}   Tender_User1
${viewer}   Tender_Viewer

${LOAD_USERS}      ["${tender_owner}", "${provider}", "${provider1}", "${viewer}"]

${item_id}       0
${question_id}   0

*** Test Cases ***
Можливість оголосити однопредметний тендер
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  [Documentation]   Створення закупівлі замовником, обовязково має повертати UAID закупівлі (номер тендера),
  ${TENDER_UAID}=  Викликати для учасника     ${tender_owner}    Створити тендер  ${INITIAL_TENDER_DATA}
  ${LAST_MODIFICATION_DATE}=  Get Current Date
  Set To Dictionary  ${TENDER}   TENDER_UAID             ${TENDER_UAID}
  Set To Dictionary  ${TENDER}   LAST_MODIFICATION_DATE  ${LAST_MODIFICATION_DATE}
  log  ${TENDER}

Пошук однопредметного тендера по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук тендера по ідентифікатору
  Дочекатись синхронізації з майданчиком    ${viewer}
  Викликати для учасника   ${viewer}   Пошук тендера по ідентифікатору   ${TENDER['TENDER_UAID']}

Можливість подати скаргу на умови
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість подати скаргу на умови
  Викликати для учасника   ${provider}   Подати скаргу    ${TENDER['TENDER_UAID']}   ${COMPLAINTS[0]}
  ${LAST_MODIFICATION_DATE}=  Get Current Date
  Set Global Variable   ${LAST_MODIFICATION_DATE}

Можливість відхилити скаргу на умови
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість відхилити скаргу на умови
  Set To Dictionary  ${COMPLAINTS[0].data}   status   declined
  Викликати для учасника   ${tender_owner}   Обробити скаргу    ${TENDER['TENDER_UAID']}  0  ${COMPLAINTS[0]}
  log many   ${COMPLAINTS[0]}
  викликати для учасника   ${viewer}   Оновити сторінку з тендером   ${TENDER['TENDER_UAID']}

Можливість відкинути скаргу на умови
  [Tags]    ${USERS.users['${tender_owner}'].broker}: Можливість відкинути скаргу на умови
  Викликати для учасника   ${provider}   Подати скаргу    ${TENDER['TENDER_UAID']}   ${COMPLAINTS[0]}
  ${LAST_MODIFICATION_DATE}=  Get Current Date
  Set Global Variable   ${LAST_MODIFICATION_DATE}
  Викликати для учасника   ${viewer}   Оновити сторінку з тендером   ${TENDER['TENDER_UAID']}
  Set To Dictionary  ${COMPLAINTS[0].data}   status   invalid
  Викликати для учасника   ${tender_owner}   Обробити скаргу    ${TENDER['TENDER_UAID']}  1  ${COMPLAINTS[0]}
  log many   ${COMPLAINTS[0]}
  ${LAST_MODIFICATION_DATE}=  Get Current Date
  Set Global Variable   ${LAST_MODIFICATION_DATE}
  Викликати для учасника   ${viewer}   Оновити сторінку з тендером   ${TENDER['TENDER_UAID']}

Можливість задовільнити скаргу на умови
  [Tags]    ${USERS.users['${provider}'].broker}: Можливість відповісти на запитання
  Викликати для учасника   ${provider}   Подати скаргу    ${TENDER['TENDER_UAID']}   ${COMPLAINTS[0]}
  ${LAST_MODIFICATION_DATE}=  Get Current Date
  Set Global Variable   ${LAST_MODIFICATION_DATE}
  Викликати для учасника   ${viewer}   Оновити сторінку з тендером   ${TENDER['TENDER_UAID']}
  Set To Dictionary  ${COMPLAINTS[0].data}   status   resolved
  Викликати для учасника   ${tender_owner}   Обробити скаргу    ${TENDER['TENDER_UAID']}  2  ${COMPLAINTS[0]}
  log many   ${COMPLAINTS[0]}
  ${LAST_MODIFICATION_DATE}=  Get Current Date
  Set Global Variable   ${LAST_MODIFICATION_DATE}
