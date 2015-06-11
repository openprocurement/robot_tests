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
${LOAD_BROKERS}    ['Prom', 'Quinta']
${LOAD_USERS}      [ 'Prom Owner', 'Tender User']

${tender_owner}   prom_owner    #Tender Owner
${provider}   Tender User
${viewer}   Tender Viewer

${item_id}       0
${question_id}   0

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
  [Tags]   ${USERS.users['${USERS.${tender_owner}}'].broker}: Можливість оголосити тендер
  ${TENDER_ID}=  Викликати для учасника     ${USERS.${tender_owner}}   Створити тендер  ${INITIAL_TENDER_DATA}
  Set Global Variable    ${TENDER_ID}
  ${LAST_MODIFICATION_DATE}=  Get Current Date
  ${TENDER_DATA}=  Get Variable Value   ${INITIAL_TENDER_DATA}
  Set Global Variable   ${TENDER_DATA}
  Set Global Variable   ${LAST_MODIFICATION_DATE}

Пошук однопредметного тендера по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук тендера по ідентифікатору
  #Switch Browser  ${viewer}
  Дочекатись синхронізації з майданчиком    ${viewer}
  Викликати для учасника   ${provider}   Пошук тендера по ідентифікатору   ${TENDER_ID}   ${TENDER_ID}

Відображення заголовоку оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Звірити поле тендера   ${provider}  title

Відображення опису оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Звірити поле тендера   ${provider}  description

Відображення бюджету оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Звірити поле тендера   ${provider}  value.amount


######
#Відображення основних  даних оголошеного тендера:
#заголовок, опис, бюджет, тендерна документація,
#procuringEntity, періоди уточнень/прийому-пропозицій, мінімального кроку


Відображення tenderID оголошеного тендера
  [Tags]   ${USERS.users['${provider}'].broker}: Відображення основних даних оголошеного тендера
  Звірити поле тендера   ${provider}  tenderID

Відображення procuringEntity.name оголошеного тендера
  [Tags]   ${USERS.users['${provider}'].broker}: Відображення основних даних оголошеного тендера
  Звірити поле тендера   ${provider}  procuringEntity.name

Відображення початоку періоду уточнення оголошеного тендера
  [Tags]   ${USERS.users['${provider}'].broker}: Відображення основних даних оголошеного тендера
  Звірити поле тендера  ${provider}  enquiryPeriod.startDate

Відображення закінчення періоду уточнення оголошеного тендера
  [Tags]   ${USERS.users['${provider}'].broker}: Відображення основних даних оголошеного тендера
  Звірити поле тендера  ${provider}  enquiryPeriod.endDate

Відображення початоку періоду прийому пропозицій оголошеного тендера
  [Tags]   ${USERS.users['${provider}'].broker}: Відображення основних даних оголошеного тендера
  Звірити поле тендера   ${provider}  tenderPeriod.startDate

Відображення закінчення періоду прийому пропозицій оголошеного тендера
  [Tags]   ${USERS.users['${provider}'].broker}: Відображення основних даних оголошеного тендера
  Звірити поле тендера  ${provider}  tenderPeriod.endDate

Відображення мінімального кроку оголошеного тендера
  [Tags]   ${USERS.users['${provider}'].broker}: Відображення основних даних оголошеного тендера
  Звірити поле тендера   ${provider}  minimalStep.amount

#######
#Відображення однопредметного тендера
#приедмет закупівлі, кількість, класифікатори, строки поставки, місце поставки

Відображення опису позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${provider}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${provider}  items[${item_id}].description

Відображення дати доставки позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${provider}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера  ${provider}  items[${item_id}].deliveryDate.endDate

Відображення координат широти доставки позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${provider}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${provider}  items[${item_id}].deliveryLocation.latitude

Відображення координат довготи доставки позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${provider}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${provider}  items[${item_id}].deliveryLocation.longitude

Відображення назви нас. пункту доставки позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${provider}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${provider}  items[${item_id}].deliveryAddress.countryName

Відображення пошт коду доставки позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${provider}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${provider}  items[${item_id}].deliveryAddress.postalCode

Відображення регіону доставки позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${provider}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${provider}  items[${item_id}].deliveryAddress.region

Відображення locality адреси доставки позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${provider}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${provider}  items[${item_id}].deliveryAddress.locality

Відображення вулиці доставки позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${provider}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${provider}  items[${item_id}].deliveryAddress.streetAddress

Відображення схеми класифікації позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${provider}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${provider}  items[${item_id}].classification.scheme

Відображення ідентифйікатора класифікації позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${provider}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${provider}  items[${item_id}].classification.id

Відображення опису класифікації позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${provider}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${provider}  items[${item_id}].classification.description

Відображення схеми додаткової класифікації позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${provider}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${provider}  items[${item_id}].additionalClassifications.scheme

Відображення ідентифікатора додаткової класифікації позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${provider}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${provider}  items[${item_id}].additionalClassifications.id

Відображення опису додаткової класифікації позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${provider}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${provider}  items[${item_id}].additionalClassifications.description

Відображення назви одиниці позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${provider}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${provider}  items[${item_id}].unit.name

Відображення коду одиниці позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${provider}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${provider}  items[${item_id}].unit.code

Відображення кількості позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${provider}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${provider}  items[${item_id}].quantity


