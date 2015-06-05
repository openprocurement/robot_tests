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
${LOAD_USERS}      ['Tender Viewer', 'Tender User', 'Prom Owner', 'Tender Owner']

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

  
Можливість оголосити однопердметний тендер брокером
  [Tags]   ${USERS.users['${USERS.${tender_owner}}'].broker}: Можливість оголосити тендер
  ${INITIAL_DATA}=  prepare_prom_tender_data
  Set Global Variable  ${INITIAL_DATA}
  ${id}=   Викликати для учасника     ${USERS.${tender_owner}}   Створити тендер   ${INITIAL_DATA}
  log  ${id}
  Set Global Variable  ${id}
  
Отримати оголошений однопердметний тендер
  [Tags]   ${USERS.users['${USERS.${tender_owner}}'].broker}: Можливість оголосити тендер  
  ${tender_data}=  Call Method  ${USERS.users['Tender Viewer'].client}  get_tender  ${id} 
  log  ${tender_data}
  Log Object Data   ${tender_data}
  Set Global Variable  ${tender_data}
  

Відображення заголовоку оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  #Debug 
  Звірити поле створеного тендера   ${INITIAL_DATA}   ${tender_data}   data.title

Відображення опису оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Звірити поле створеного тендера   ${INITIAL_DATA}   ${tender_data}  data.description
  
Відображення бюджету оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Звірити поле створеного тендера   ${INITIAL_DATA}   ${tender_data}  data.value.amount
 
Відображення tenderID оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Звірити поле створеного тендера   ${INITIAL_DATA}   ${tender_data}  data.tenderID

Відображення procuringEntity.name оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Звірити поле створеного тендера   ${INITIAL_DATA}   ${tender_data}  data.procuringEntity.name
  
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
  Звірити поле створеного тендера   ${INITIAL_DATA}   ${tender_data}  data.minimalStep.amount
  
#######
#Відображення однопредметного тендера
#приедмет закупівлі, кількість, класифікатори, строки поставки, місце поставки

Відображення опису позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле створеного тендера   ${INITIAL_DATA}   ${tender_data}  data.items[${item_id}].description
  
Відображення дати доставки позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле створеного тендера  ${viewer}  data.items[${item_id}].deliveryDate.endDate
  
Відображення координат широти доставки позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле створеного тендера   ${INITIAL_DATA}   ${tender_data}  data.items[${item_id}].deliveryLocation.latitude
  
Відображення координат довготи доставки позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле створеного тендера   ${INITIAL_DATA}   ${tender_data}  data.items[${item_id}].deliveryLocation.longitude
  
Відображення назви нас. пункту доставки позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле створеного тендера   ${INITIAL_DATA}   ${tender_data}  data.items[${item_id}].deliveryAddress.countryName
  
Відображення пошт коду доставки позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле створеного тендера   ${INITIAL_DATA}   ${tender_data}  data.items[${item_id}].deliveryAddress.postalCode
  
Відображення регіону доставки позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле створеного тендера   ${INITIAL_DATA}   ${tender_data}  data.items[${item_id}].deliveryAddress.region
  
Відображення locality адреси доставки позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле створеного тендера   ${INITIAL_DATA}   ${tender_data}  data.items[${item_id}].deliveryAddress.locality
  
Відображення вулиці доставки позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле створеного тендера   ${INITIAL_DATA}   ${tender_data}  data.items[${item_id}].deliveryAddress.streetAddress
  
Відображення схеми класифікації позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле створеного тендера   ${INITIAL_DATA}   ${tender_data}  data.items[${item_id}].classification.scheme
  
Відображення ідентифйікатора класифікації позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле створеного тендера   ${INITIAL_DATA}   ${tender_data}  data.items[${item_id}].classification.id
  
Відображення опису класифікації позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле створеного тендера   ${INITIAL_DATA}   ${tender_data}  data.items[${item_id}].classification.description
  
Відображення схеми додаткової класифікації позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле створеного тендера   ${INITIAL_DATA}   ${tender_data}  data.items[${item_id}].additionalClassifications.scheme
  
Відображення ідентифікатора додаткової класифікації позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле створеного тендера   ${INITIAL_DATA}   ${tender_data}  data.items[${item_id}].additionalClassifications.id
  
Відображення опису додаткової класифікації позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле створеного тендера   ${INITIAL_DATA}   ${tender_data}  data.items[${item_id}].additionalClassifications.description
  
Відображення назви одиниці позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле створеного тендера   ${INITIAL_DATA}   ${tender_data}  data.items[${item_id}].unit.name
  
Відображення коду одиниці позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле створеного тендера   ${INITIAL_DATA}   ${tender_data}  data.items[${item_id}].unit.code
  
Відображення кількості позицій закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів пердметів однопредметного тендера
  Звірити поле створеного тендера   ${INITIAL_DATA}   ${tender_data}  data.items[${item_id}].quantity
