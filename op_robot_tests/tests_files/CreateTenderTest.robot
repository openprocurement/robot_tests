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
${tender_owner}   Tender Owner
${provider}   Tender User
${viewer}   Tender Viewer

${LOAD_USERS}      ["${tender_owner}", "${provider}"]

${item_id}       0
${question_id}   0


*** Test Cases ***
Можливість оголосити однопердметний тендер
  [Tags]   Owner_Tests   ${USERS.users['${tender_owner}'].broker}: Пошук тендера по ідентифікатору
  ${TENDER_ID}=  Викликати для учасника     ${tender_owner}    Створити тендер  ${INITIAL_TENDER_DATA}
  Set Global Variable    ${TENDER_ID}
  ${LAST_MODIFICATION_DATE}=  Get Current Date
  ${TENDER_DATA}=  Get Variable Value   ${INITIAL_TENDER_DATA}
  Set Global Variable   ${TENDER_DATA}
  Set Global Variable   ${LAST_MODIFICATION_DATE}

Пошук однопредметного тендера по ідентифікатору
  [Tags]   Owner_Tests   ${USERS.users['${tender_owner}'].broker}: Пошук тендера по ідентифікатору
  Дочекатись синхронізації з майданчиком    ${provider}
  Викликати для учасника   ${provider}   Пошук тендера по ідентифікатору   ${TENDER_ID}   ${TENDER_ID}

Відображення заголовоку оголошеного тендера
  [Tags]   Owner_Tests     ${USERS.users['${tender_owner}'].broker}: Запис основних даних оголошеного тендера
  Звірити поле тендера   ${provider}  title

Відображення опису оголошеного тендера
  [Tags]   Owner_Tests     ${USERS.users['${tender_owner}'].broker}: Запис основних даних оголошеного тендера
  Звірити поле тендера   ${provider}  description

Відображення бюджету оголошеного тендера
  [Tags]   Owner_Tests     ${USERS.users['${tender_owner}'].broker}: Запис основних даних оголошеного тендера
  Звірити поле тендера   ${provider}  value.amount

Відображення procuringEntity.name оголошеного тендера
  [Tags]   Owner_Tests   ${USERS.users['${tender_owner}'].broker}: Запис основних даних оголошеного тендера
  Звірити поле тендера   ${provider}  procuringEntity.name

#Відображення початоку періоду уточнення оголошеного тендера
#  [Tags]   Owner_Tests   ${USERS.users['${tender_owner}'].broker}: Запис основних даних оголошеного тендера
#  Звірити поле тендера  ${provider}  enquiryPeriod.startDate

Відображення закінчення періоду уточнення оголошеного тендера
  [Tags]   Owner_Tests   ${USERS.users['${tender_owner}'].broker}: Запис основних даних оголошеного тендера
  Звірити дату   ${provider}  enquiryPeriod.endDate

Відображення початоку періоду прийому пропозицій оголошеного тендера
  [Tags]   Owner_Tests   ${USERS.users['${tender_owner}'].broker}: Запис основних даних оголошеного тендера
  Звірити дату    ${provider}  tenderPeriod.startDate

Відображення закінчення періоду прийому пропозицій оголошеного тендера
  [Tags]   Owner_Tests   ${USERS.users['${tender_owner}'].broker}: Запис основних даних оголошеного тендера
  Звірити дату   ${provider}  tenderPeriod.endDate

Відображення мінімального кроку оголошеного тендера
  [Tags]   Owner_Tests   ${USERS.users['${tender_owner}'].broker}: Запис основних даних оголошеного тендера
  Звірити поле тендера    ${provider}  minimalStep.amount

Відображення опису позицій закупівлі однопредметного тендера
  [Tags]   Owner_Tests   ${USERS.users['${tender_owner}'].broker}: Запис полів пердметів однопредметного тендера
  Звірити поле тендера   ${provider}  items[${item_id}].description

Відображення дати доставки позицій закупівлі однопредметного тендера
  [Tags]   Owner_Tests   ${USERS.users['${tender_owner}'].broker}: Запис полів пердметів однопредметного тендера
  Звірити дату    ${provider}  items[${item_id}].deliveryDate.endDate

Відображення координат широти доставки позицій закупівлі однопредметного тендера
  [Tags]   Owner_Tests   ${USERS.users['${tender_owner}'].broker}: Запис полів пердметів однопредметного тендера
  Звірити поле тендера   ${provider}  items[${item_id}].deliveryLocation.latitude

Відображення координат довготи доставки позицій закупівлі однопредметного тендера
  [Tags]   Owner_Tests   ${USERS.users['${tender_owner}'].broker}: Запис полів пердметів однопредметного тендера
  Звірити поле тендера   ${provider}  items[${item_id}].deliveryLocation.longitude

Відображення назви нас. пункту доставки позицій закупівлі однопредметного тендера
  [Tags]   Owner_Tests   ${USERS.users['${tender_owner}'].broker}: Запис полів пердметів однопредметного тендера
  Звірити поле тендера   ${provider}  items[${item_id}].deliveryAddress.countryName

Відображення пошт коду доставки позицій закупівлі однопредметного тендера
  [Tags]   Owner_Tests   ${USERS.users['${tender_owner}'].broker}: Запис полів пердметів однопредметного тендера
  Звірити поле тендера   ${provider}  items[${item_id}].deliveryAddress.postalCode

Відображення регіону доставки позицій закупівлі однопредметного тендера
  [Tags]   Owner_Tests   ${USERS.users['${tender_owner}'].broker}: Запис полів пердметів однопредметного тендера
  Звірити поле тендера   ${provider}  items[${item_id}].deliveryAddress.region

Відображення locality адреси доставки позицій закупівлі однопредметного тендера
  [Tags]   Owner_Tests   ${USERS.users['${tender_owner}'].broker}: Запис полів пердметів однопредметного тендера
  Звірити поле тендера   ${provider}  items[${item_id}].deliveryAddress.locality

Відображення вулиці доставки позицій закупівлі однопредметного тендера
  [Tags]   Owner_Tests   ${USERS.users['${tender_owner}'].broker}: Запис полів пердметів однопредметного тендера
  Звірити поле тендера   ${provider}  items[${item_id}].deliveryAddress.streetAddress

Відображення схеми класифікації позицій закупівлі однопредметного тендера
  [Tags]   Owner_Tests   ${USERS.users['${tender_owner}'].broker}: Запис полів пердметів однопредметного тендера
  Звірити поле тендера   ${provider}  items[${item_id}].classification.scheme

Відображення ідентифйікатора класифікації позицій закупівлі однопредметного тендера
  [Tags]   Owner_Tests   ${USERS.users['${tender_owner}'].broker}: Запис полів пердметів однопредметного тендера
  Звірити поле тендера   ${provider}  items[${item_id}].classification.id

Відображення опису класифікації позицій закупівлі однопредметного тендера
  [Tags]   Owner_Tests   ${USERS.users['${tender_owner}'].broker}: Запис полів пердметів однопредметного тендера
  Звірити поле тендера   ${provider}  items[${item_id}].classification.description

Відображення схеми додаткової класифікації позицій закупівлі однопредметного тендера
  [Tags]   Owner_Tests   ${USERS.users['${tender_owner}'].broker}: Запис полів пердметів однопредметного тендера
  Звірити поле тендера   ${provider}  items[${item_id}].additionalClassifications.scheme

Відображення ідентифікатора додаткової класифікації позицій закупівлі однопредметного тендера
  [Tags]   Owner_Tests   ${USERS.users['${tender_owner}'].broker}: Запис полів пердметів однопредметного тендера
  Звірити поле тендера   ${provider}  items[${item_id}].additionalClassifications.id

Відображення опису додаткової класифікації позицій закупівлі однопредметного тендера
  [Tags]   Owner_Tests   ${USERS.users['${tender_owner}'].broker}: Запис полів пердметів однопредметного тендера
  Звірити поле тендера   ${provider}  items[${item_id}].additionalClassifications.description

Відображення назви одиниці позицій закупівлі однопредметного тендера
  [Tags]   Owner_Tests   ${USERS.users['${tender_owner}'].broker}: Запис полів пердметів однопредметного тендера
  Звірити поле тендера   ${provider}  items[${item_id}].unit.name

Відображення коду одиниці позицій закупівлі однопредметного тендера
  [Tags]   Owner_Tests   ${USERS.users['${tender_owner}'].broker}: Запис полів пердметів однопредметного тендера
  Звірити поле тендера   ${provider}  items[${item_id}].unit.code

Відображення кількості позицій закупівлі однопредметного тендера
  [Tags]   Owner_Tests   ${USERS.users['${tender_owner}'].broker}: Запис полів пердметів однопредметного тендера
  Звірити поле тендера   ${provider}  items[${item_id}].quantity


