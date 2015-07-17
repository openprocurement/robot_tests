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
${mode}  multi
${tender_dump_id}    0
${item_id}       0
${question_id}   0

${tender_owner}  Tender_Owner
${provider}   Tender_User
${viewer}   Tender_Viewer
${LOAD_USERS}      ["${tender_owner}", "${provider}", "${viewer}"]


*** Test Cases ***

Можливість оголосити багатопредметний тендер
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  ${ids}=  Викликати для учасника     ${tender_owner}   Багатопредметний тендер   ${INITIAL_TENDER_DATA}
  ${TENDER_ID}=   Get From List   ${ids}  0
  ${INTERNAL_TENDER_ID}=  Get From List   ${ids}  1
  Set Global Variable    ${INTERNAL_TENDER_ID}
  Set Global Variable    ${TENDER_ID}
  ${LAST_MODIFICATION_DATE}=  Get Current Date
  Set Global Variable   ${LAST_MODIFICATION_DATE}

Отримати багатопредметний тендер по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук тендера по ідентифікатору
  Дочекатись синхронізації з майданчиком    ${viewer}
  Викликати для учасника   ${viewer}   Пошук тендера по ідентифікатору   ${TENDER_ID}  ${INTERNAL_TENDER_ID}

Відображення опису позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів багатопредметного тендера
  Звірити поля предметів закупівлі багатопредметного тендера  ${viewer}  description

Відображення дати доставки позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів багатопредметного тендера
  Звірити поля предметів закупівлі багатопредметного тендера  ${viewer}  deliveryDate.endDate

Відображення координат широти доставки позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів багатопредметного тендера
  Звірити поля предметів закупівлі багатопредметного тендера  ${viewer}  deliveryLocation.latitude

Відображення координат довготи доставки позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів багатопредметного тендера
  Звірити поля предметів закупівлі багатопредметного тендера  ${viewer}  deliveryLocation.longitude

Відображення назви нас. пункту доставки позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів багатопредметного тендера
  Звірити поля предметів закупівлі багатопредметного тендера  ${viewer}  deliveryAddress.countryName

Відображення пошт коду доставки позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів багатопредметного тендера
  Звірити поля предметів закупівлі багатопредметного тендера   ${viewer}  deliveryAddress.postalCode

Відображення регіону доставки позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів багатопредметного тендера
  Звірити поля предметів закупівлі багатопредметного тендера   ${viewer}  deliveryAddress.region

Відображення locality адреси доставки позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів багатопредметного тендера
  Звірити поля предметів закупівлі багатопредметного тендера   ${viewer}  deliveryAddress.locality

Відображення вулиці доставки позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів багатопредметного тендера
  Звірити поля предметів закупівлі багатопредметного тендера   ${viewer}  deliveryAddress.streetAddress

Відображення схеми класифікації позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів багатопредметного тендера
  Звірити поля предметів закупівлі багатопредметного тендера   ${viewer}  classification.scheme

Відображення ідентифйікатора класифікації позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів багатопредметного тендера
  Звірити поля предметів закупівлі багатопредметного тендера   ${viewer}  classification.id

Відображення опису класифікації позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів багатопредметного тендера
  Звірити поля предметів закупівлі багатопредметного тендера   ${viewer}  classification.description

Відображення схеми додаткової класифікації позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів багатопредметного тендера
  Звірити поля предметів закупівлі багатопредметного тендера   ${viewer}  additionalClassifications.scheme

Відображення ідентифікатора додаткової класифікації позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів багатопредметного тендера
  Звірити поля предметів закупівлі багатопредметного тендера   ${viewer}  additionalClassifications.id

Відображення опису додаткової класифікації позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів багатопредметного тендера
  Звірити поля предметів закупівлі багатопредметного тендера   ${viewer}  additionalClassifications.description

Відображення назви одиниці позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів багатопредметного тендера
  Звірити поля предметів закупівлі багатопредметного тендера  ${viewer}  unit.name

Відображення коду одиниці позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів багатопредметного тендера
  Звірити поля предметів закупівлі багатопредметного тендера   ${viewer}  unit.code

Відображення кількості позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів багатопредметного тендера
  Звірити поля предметів закупівлі багатопредметного тендера  ${viewer}  quantity


