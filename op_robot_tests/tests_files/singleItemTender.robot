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
${viewer}   E-tender Viewer
#E-tender Viewer
#Prom Viewer
#SmartTender Viewer
#Publicbid Viewer
#Netcast Viewer

${provider}   Tender User
${item_id}       0
${question_id}   0
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
  Звірити дату  ${viewer}  enquiryPeriod.startDate

Відображення закінчення періоду уточнення оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Звірити дату   ${viewer}  enquiryPeriod.endDate

Відображення початоку періоду прийому пропозицій оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Звірити дату   ${viewer}  tenderPeriod.startDate

Відображення закінчення періоду прийому пропозицій оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Звірити дату  ${viewer}  tenderPeriod.endDate

Відображення мінімального кроку оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Звірити поле тендера   ${viewer}  minimalStep.amount
  
#######
#Відображення однопредметного тендера
#приедмет закупівлі, кількість, класифікатори, строки поставки, місце поставки

Відображення опису позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[${item_id}].description
  
Відображення дати доставки позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера  ${viewer}  items[${item_id}].deliveryDate.endDate
  
Відображення координат широти доставки позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[${item_id}].deliveryLocation.latitude
  
Відображення координат довготи доставки позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[${item_id}].deliveryLocation.longitude
  
Відображення назви нас. пункту доставки позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[${item_id}].deliveryAddress.countryName
  
Відображення пошт коду доставки позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[${item_id}].deliveryAddress.postalCode
  
Відображення регіону доставки позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[${item_id}].deliveryAddress.region
  
Відображення locality адреси доставки позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[${item_id}].deliveryAddress.locality
  
Відображення вулиці доставки позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[${item_id}].deliveryAddress.streetAddress
  
Відображення схеми класифікації позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[${item_id}].classification.scheme
  
Відображення ідентифйікатора класифікації позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[${item_id}].classification.id
  
Відображення опису класифікації позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[${item_id}].classification.description
  
Відображення схеми додаткової класифікації позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[${item_id}].additionalClassifications.scheme
  
Відображення ідентифікатора додаткової класифікації позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[${item_id}].additionalClassifications.id
  
Відображення опису додаткової класифікації позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[${item_id}].additionalClassifications.description
  
Відображення назви одиниці позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[${item_id}].unit.name
  
Відображення коду одиниці позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[${item_id}].unit.code
  
Відображення кількості позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле тендера   ${viewer}  items[${item_id}].quantity

#######
#Відображення анонімного питання без відповідей

Задати питання
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість задати запитання
  Викликати для учасника   ${provider}   Задати питання    ${TENDER_DATA.data.id}   ${questions[${question_id}]}
  ${LAST_MODIFICATION_DATE}=  Get Current Date
  Set Global Variable   ${LAST_MODIFICATION_DATE}
  отримати останні зміни в тендері

Відображення заголовоку анонімного питання без відповіді
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення анонімного питання без відповідей
  Дочекатись синхронізації з майданчиком    ${viewer}
  Викликати для учасника   ${viewer}   обновити сторінку з тендером   ${TENDER_DATA.data.tenderID}   ${TENDER_DATA.data.id}
  Звірити поле тендера   ${viewer}  questions[${question_id}].title

Відображення опис анонімного питання без відповіді
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення анонімного питання без відповідей
  Звірити поле тендера   ${viewer}  questions[${question_id}].description

Відображення дати анонімного питання без відповіді
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення анонімного питання без відповідей
  Звірити поле тендера   ${viewer}  questions[${question_id}].date
  
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
  Звірити поле тендера   ${viewer}  questions[${item_id}].answer