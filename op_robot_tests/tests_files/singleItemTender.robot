*** Setting ***
Library  op_robot_tests.tests_files.service_keywords
Library  String
LIbrary  Collections
LIbrary  Selenium2Library
Library  DebugLibrary
Resource  keywords.robot
Suite Setup  TestCaseSetup
Suite Teardown  Close all browsers

*** Variables ***
${viewer}     Tender Viewer
#E-tender Viewer
#Prom Viewer
#SmartTender Viewer
#Publicbid Viewer

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
  
Відображення заголовоку оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Звірити поле тендера   ${viewer}  title

Відображення tenderID оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Звірити поле тендера   ${viewer}  tenderID

Відображення опису оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Звірити поле тендера   ${viewer}  description

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

Відображення бюджету оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Звірити поле тендера   ${viewer}  value.amount

Відображення мінімального кроку оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Звірити поле тендера   ${viewer}  minimalStep.amount

Відображення procuringEntity.name оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  Звірити поле тендера   ${viewer}  procuringEntity.name

Відображення предмету закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення однопредметного тендера
  Звірити поле тендера   ${viewer}  items[0].description

Відображення кількісті предметів закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення однопредметного тендера
  Звірити поле тендера   ${viewer}  items[0].quantity

Відображення класифікаторів закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення однопредметного тендера
  Звірити поле тендера   ${viewer}  items[0].classification.id
  Звірити поле тендера   ${viewer}  items[0].classification.description

Відображення місце поставки закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення однопредметного тендера
  Звірити поле тендера   ${viewer}  items[0].deliveryAddress.countryName
  Звірити поле тендера   ${viewer}  items[0].deliveryAddress.locality
  Звірити поле тендера   ${viewer}  items[0].deliveryAddress.postalCode
  Звірити поле тендера   ${viewer}  items[0].deliveryAddress.region
  Звірити поле тендера   ${viewer}  items[0].deliveryAddress.streetAddress

Відображення строки поставки закупівлі однопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення однопредметного тендера
  Звірити поле тендера   ${viewer}  items[0].deliveryDate.endDate
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

Подати цінову пропозицію
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість подати цінову пропозицію
  Дочекатись дати початоку прийому пропозицій
  ${bid}=  test bid data
  Log object data  ${bid}
  ${biddingresponce}=  Викликати для учасника   ${provider}   Подати цінову пропозицію   ${TENDER_DATA.data.id}   ${bid}
  Set Global Variable   ${biddingresponce}


Змінити цінову пропозицію
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість змінити цінову пропозицію
  Log object data   ${biddingresponce}
  Set To Dictionary  ${biddingresponce.data.value}   amount   600
  Log object data   ${biddingresponce.data.value}
  Викликати для учасника   ${provider}   Змінити цінову пропозицію   ${TENDER_DATA.data.id}   ${biddingresponce}

Прийняти пропозицію переможця 
  [Tags]   ${USERS.users['${USERS.tender_owner}'].broker}: Можливість прийняти пропозицію переможця
  Дочекатись дати закінчення прийому пропозицій
  ${LAST_MODIFICATION_DATE}=  Get Current Date
  Set Global Variable   ${LAST_MODIFICATION_DATE}
  отримати останні зміни в тендері
  ${award}=  test_award_data
  ${award_data}=   Get_From_Object  ${TENDER_DATA.data}   awards[0]
  Set To Dictionary  ${award}  data  ${award_data}
  Set To Dictionary  ${award['data']}  status  active
  Викликати для учасника   ${USERS.tender_owner}   Прийняти цінову пропозицію   ${TENDER_DATA.data.id}   ${award}