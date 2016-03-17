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
${mode}         multiItem

${role}         viewer
${broker}       Quinta

*** Test Cases ***
Можливість оголосити багатопредметний тендер
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      minimal
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


Можливість знайти багатопредметний тендер по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук тендера по ідентифікатору
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      minimal
  Можливість знайти тендер по ідентифікатору


##############################################################################################
#             ВІДОБРАЖЕННЯ
##############################################################################################

Відображення заголовку документа багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  Відображення заголовку документа тендера


Відображення заголовку багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      minimal
  Відображення заголовку тендера


Відображення опису багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Відображення опису тендера


Відображення бюджету багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      critical level 2
  Відображення бюджету тендера


Відображення ідентифікатора багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      critical level 2
  Відображення ідентифікатора тендера


Відображення імені замовника багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      critical level 2
  Відображення імені замовника тендера


Відображення початку періоду уточнення багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Відображення початку періоду уточнення тендера


Відображення закінчення періоду уточнення багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      minimal
  Відображення закінчення періоду уточнення тендера


Відображення початку періоду прийому пропозицій багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      minimal
  Відображення початку періоду прийому пропозицій тендера


Відображення закінчення періоду прийому пропозицій багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      minimal
  Відображення закінчення періоду прийому пропозицій тендера


Відображення мінімального кроку багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Відображення мінімального кроку тендера


Відображення дати доставки позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      critical level 3
  Відображення дати доставки позицій закупівлі тендера


Відображення координат широти доставки позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Відображення координат широти доставки позицій закупівлі тендера


Відображення координат довготи доставки позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Відображення координат довготи доставки позицій закупівлі тендера


Відображення назви нас. пункту доставки позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      critical level 3
  Відображення назви нас. пункту доставки позицій закупівлі тендера


Відображення пошт. коду доставки позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Відображення пошт. коду доставки позицій закупівлі тендера


Відображення регіону доставки позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      critical level 3
  Відображення регіону доставки позицій закупівлі тендера


Відображення населеного пункту адреси доставки позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Відображення населеного пункту адреси доставки позицій закупівлі тендера


Відображення вулиці доставки позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Відображення вулиці доставки позицій закупівлі тендера


Відображення схеми класифікації позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Відображення схеми класифікації позицій закупівлі тендера


Відображення ідентифікатора класифікації позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      critical level 3
  Відображення ідентифікатора класифікації позицій закупівлі тендера


Відображення опису класифікації позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      critical level 3
  Відображення опису класифікації позицій закупівлі тендера


Відображення схеми додаткової класифікації позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Відображення схеми додаткової класифікації позицій закупівлі тендера


Відображення ідентифікатора додаткової класифікації позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      critical level 3
  Відображення ідентифікатора додаткової класифікації позицій закупівлі тендера


Відображення опису додаткової класифікації позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      critical level 3
  Відображення опису додаткової класифікації позицій закупівлі тендера


Відображення назви одиниці позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      critical level 3
  Відображення назви одиниці позицій закупівлі тендера


Відображення коду одиниці позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Відображення коду одиниці позицій закупівлі тендера


Відображення кількості позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      critical level 3
  Відображення кількості позицій закупівлі тендера

##############################################################################################
#             МОЖЛИВІСТЬ
##############################################################################################

Можливість редагувати багатопредметний тендер
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

Відображення редагованого опису багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Відображення опису тендера

##############################################################################################
#             МОЖЛИВІСТЬ
##############################################################################################

Можливість додати позицію закупівлі в тендер
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      critical level 2
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Викликати для учасника   ${tender_owner}   Додати предмети закупівлі    ${TENDER['TENDER_UAID']}   3

Можливість видалити позиції закупівлі тендера
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      critical level 2
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Викликати для учасника   ${tender_owner}   Відняти предмети закупівлі   ${TENDER['TENDER_UAID']}   2
