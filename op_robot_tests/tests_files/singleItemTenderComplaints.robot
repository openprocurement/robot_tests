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
${mode}         single

${role}         viewer
${broker}       Quinta

*** Test Cases ***
Можливість оголосити однопредметний тендер
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  [Documentation]   Створення закупівлі замовником, обовязково має повертати UAID закупівлі (номер тендера),
  ${tender_data}=  Підготовка початкових даних
  ${TENDER_UAID}=  Викликати для учасника  ${tender_owner}  Створити тендер  ${tender_data}
  ${LAST_MODIFICATION_DATE}=  Get Current TZdate
  Set To Dictionary  ${TENDER}   TENDER_UAID             ${TENDER_UAID}
  Set To Dictionary  ${TENDER}   LAST_MODIFICATION_DATE  ${LAST_MODIFICATION_DATE}
  log  ${TENDER}

Можливість знайти однопредметний тендер по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук тендера по ідентифікатору
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком    ${viewer}
  Викликати для учасника   ${viewer}   Пошук тендера по ідентифікатору   ${TENDER['TENDER_UAID']}

Можливість подати скаргу на умови
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість подати скаргу на умови
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      from-0.12
  [Documentation]    Користувач  ${USERS.users['${provider}'].broker}  Намагається подати скаргу на умови оголошеної  закупівлі
  [Setup]  Дочекатись синхронізації з майданчиком    ${provider}
  Викликати для учасника   ${provider}   Подати скаргу    ${TENDER['TENDER_UAID']}   ${COMPLAINTS[0]}
  ${LAST_MODIFICATION_DATE}=  Get Current TZdate
  Set Global Variable   ${LAST_MODIFICATION_DATE}

Можливість побачити скаргу користувачем
  [Tags]   ${USERS.users['${provider}'].broker}: Відображення основних даних оголошеного тендера
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      from-0.12
  [Documentation]    Користувач  ${USERS.users['${provider}'].broker}  Намагається побчати скаргу на умови оголошеної  закупівлі
  Викликати для учасника   ${provider}   Порівняти скаргу  ${TENDER['TENDER_UAID']}   ${COMPLAINTS[0]}

Можливість побачити скаргу анонімом
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      from-0.12
  [Documentation]    Користувач  ${USERS.users['${viewer}'].broker}  Намагається побачити скаргу на умови оголошеної  закупівлі
  [Setup]  Дочекатись синхронізації з майданчиком    ${viewer}
  Викликати для учасника    ${viewer}  Порівняти скаргу  ${TENDER['TENDER_UAID']}   ${COMPLAINTS[0]}

Можливість скасувати скаргу на умови
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість скасувати скаргу на умови
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      from-0.12
  [Documentation]    Користувач  ${USERS.users['${provider}'].broker}  Намагається скасувати скаргу на умови оголошеної  закупівлі
  [Setup]  Дочекатись синхронізації з майданчиком    ${tender_owner}
  Set To Dictionary  ${COMPLAINTS[0].data}   status   cancelled
  Set To Dictionary  ${COMPLAINTS[0].data}   cancellationReason   test_draft_cancellation
  Викликати для учасника   ${provider}     Обробити скаргу    ${TENDER['TENDER_UAID']}  0  ${COMPLAINTS[0]}
  log many   ${COMPLAINTS[0]}

#Можливість відхилити скаргу на умови
#  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість відхилити скаргу на умови
#  Викликати для учасника   ${provider}   Подати скаргу    ${TENDER['TENDER_UAID']}   ${COMPLAINTS[0]}
#  ${LAST_MODIFICATION_DATE}=  Get Current TZdate
#  Set Global Variable   ${LAST_MODIFICATION_DATE}
#  Викликати для учасника   ${viewer}   Оновити сторінку з тендером   ${TENDER['TENDER_UAID']}
#  Set To Dictionary  ${COMPLAINTS[0].data}   status   declined
#  Викликати для учасника   ${tender_owner}   Обробити скаргу    ${TENDER['TENDER_UAID']}  0  ${COMPLAINTS[0]}
#  log many   ${COMPLAINTS[0]}
#  викликати для учасника   ${viewer}   Оновити сторінку з тендером   ${TENDER['TENDER_UAID']}
#
#Можливість відкинути скаргу на умови
#  [Tags]    ${USERS.users['${tender_owner}'].broker}: Можливість відкинути скаргу на умови
#  Викликати для учасника   ${provider}   Подати скаргу    ${TENDER['TENDER_UAID']}   ${COMPLAINTS[0]}
#  ${LAST_MODIFICATION_DATE}=  Get Current TZdate
#  Set Global Variable   ${LAST_MODIFICATION_DATE}
#  Викликати для учасника   ${viewer}   Оновити сторінку з тендером   ${TENDER['TENDER_UAID']}
#  Set To Dictionary  ${COMPLAINTS[0].data}   status   invalid
#  Викликати для учасника   ${tender_owner}   Обробити скаргу    ${TENDER['TENDER_UAID']}  1  ${COMPLAINTS[0]}
#  log many   ${COMPLAINTS[0]}
#  ${LAST_MODIFICATION_DATE}=  Get Current TZdate
#  Set Global Variable   ${LAST_MODIFICATION_DATE}
#  Викликати для учасника   ${viewer}   Оновити сторінку з тендером   ${TENDER['TENDER_UAID']}
#
#Можливість задовільнити скаргу на умови
#  [Tags]    ${USERS.users['${provider}'].broker}: Можливість відповісти на запитання
#  Викликати для учасника   ${provider}   Подати скаргу    ${TENDER['TENDER_UAID']}   ${COMPLAINTS[0]}
#  ${LAST_MODIFICATION_DATE}=  Get Current TZdate
#  Set Global Variable   ${LAST_MODIFICATION_DATE}
#  Викликати для учасника   ${viewer}   Оновити сторінку з тендером   ${TENDER['TENDER_UAID']}
#  Set To Dictionary  ${COMPLAINTS[0].data}   status   resolved
#  Викликати для учасника   ${tender_owner}   Обробити скаргу    ${TENDER['TENDER_UAID']}  2  ${COMPLAINTS[0]}
#  log many   ${COMPLAINTS[0]}
#  ${LAST_MODIFICATION_DATE}=  Get Current TZdate
#  Set Global Variable   ${LAST_MODIFICATION_DATE}
