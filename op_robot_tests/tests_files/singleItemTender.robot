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
${viewer}     Tender Viewer
#E-tender Viewer
#Prom Viewer
#SmartTender Viewer
#Publicbid Viewer
#Netcast Viewer

${provider}   Tender User


*** Test Cases ***
Можливість оголосити однопердметний тендер
  [Tags]   ${USERS.users['${USERS.tender_owner}'].broker}: Можливість оголосити тендер
  Викликати для учасника     ${USERS.tender_owner}   Створити тендер
  ${LAST_MODIFICATION_DATE}=  Get Current Date
  Set Global Variable   ${LAST_MODIFICATION_DATE}

Пошук однопредметного тендера по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук тендера по ідентифікатору
  #Switch Browser  ${viewer}
  Дочекатись синхронізації з майданчиком    ${viewer}
  Викликати для учасника   ${viewer}   Пошук тендера по ідентифікатору   ${TENDER_DATA.data.tenderID}   ${TENDER_DATA.data.id}

######
#Відображення основних  даних оголошеного тендера:
#заголовок, опис, бюджет, тендерна документація, 
#procuringEntity, періоди уточнень/прийому-пропозицій, мінімального кроку
# TO DO: тендерна документація

Відображення заголовоку оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Звірити поле тендера   ${viewer}  title

Відображення опису оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Звірити поле тендера   ${viewer}  description
  
Відображення бюджету оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Звірити поле тендера   ${viewer}  value.amount
 
Відображення tenderID оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Звірити поле тендера   ${viewer}  tenderID

Відображення procuringEntity.name оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Звірити поле тендера   ${viewer}  procuringEntity.name
  
Відображення початоку періоду уточнення оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Звірити поле тендера   ${viewer}  enquiryPeriod.startDate

Відображення закінчення періоду уточнення оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Звірити поле тендера   ${viewer}  enquiryPeriod.endDate

Відображення початоку періоду прийому пропозицій оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Звірити поле тендера   ${viewer}  tenderPeriod.startDate

Відображення закінчення періоду прийому пропозицій оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Звірити поле тендера   ${viewer}  tenderPeriod.endDate

Відображення мінімального кроку оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Звірити поле тендера   ${viewer}  minimalStep.amount
  
#######
#Відображення однопредметного тендера
#приедмет закупівлі, кількість, класифікатори, строки поставки, місце поставки

Відображення опису позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[0].description
  
Відображення дати доставки позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[0].deliveryDate.endDate
  
Відображення координат широти доставки позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[0].deliveryLocation.latitude
  
Відображення координат довготи доставки позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[0].deliveryLocation.longitude
  
Відображення назви нас. пункту доставки позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[0].deliveryAddress.countryName
  
Відображення пошт коду доставки позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[0].deliveryAddress.postalCode
  
Відображення регіону доставки позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[0].deliveryAddress.region
  
Відображення locality адреси доставки позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[0].deliveryAddress.locality
  
Відображення вулиці доставки позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[0].deliveryAddress.streetAddress
  
Відображення схеми класифікації позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[0].classification.scheme
  
Відображення ідентифйікатора класифікації позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[0].classification.id
  
Відображення опису класифікації позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[0].classification.description
  
Відображення схеми додаткової класифікації позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[0].additionalClassifications.scheme
  
Відображення ідентифікатора додаткової класифікації позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[0].additionalClassifications.id
  
Відображення опису додаткової класифікації позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[0].additionalClassifications.description
  
Відображення назви одиниці позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[0].unit.name
  
Відображення коду одиниці позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[0].unit.code
  
Відображення кількості позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[0].quantity

#######
#Відображення анонімного питання без відповідей

Задати питання
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість задати запитання
  Викликати для учасника   ${provider}   Задати питання    ${TENDER_DATA.data.id}   ${QUESTIONS[0]}
  ${LAST_MODIFICATION_DATE}=  Get Current Date
  Set Global Variable   ${LAST_MODIFICATION_DATE}
  отримати останні зміни в тендері

Відображення заголовоку анонімного питання без відповіді
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення анонімного питання без відповідей
  Дочекатись синхронізації з майданчиком    ${viewer}
  Викликати для учасника   ${viewer}   обновити сторінку з тендером   ${TENDER_DATA.data.tenderID}   ${TENDER_DATA.data.id}
  Звірити поле тендера   ${viewer}  questions[0].title

Відображення опис анонімного питання без відповіді
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення анонімного питання без відповідей
  Звірити поле тендера   ${viewer}  questions[0].description

Відображення дати анонімного питання без відповіді
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення анонімного питання без відповідей
  Звірити поле тендера   ${viewer}  questions[0].date
  
#######
#Відображення відповіді на запитання
#
Відповісти на запитання
  [Tags]   ${USERS.users['${USERS.tender_owner}'].broker}: Можливість відповісти на запитання
  Викликати для учасника   ${USERS.tender_owner}   Відповісти на питання    ${TENDER_DATA.data.id}  0  ${ANSWERS[0]}
  ${LAST_MODIFICATION_DATE}=  Get Current Date
  Set Global Variable   ${LAST_MODIFICATION_DATE}
  отримати останні зміни в тендері

Відображення відповіді на запитання
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення відповіді на запитання
  Дочекатись синхронізації з майданчиком    ${viewer}
  Викликати для учасника   ${viewer}   обновити сторінку з тендером   ${TENDER_DATA.data.tenderID}   ${TENDER_DATA.data.id}
  Звірити поле тендера   ${viewer}  questions[0].answer