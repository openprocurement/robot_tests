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
${mode}         multi

${role}         viewer
${broker}       Quinta

*** Test Cases ***
Можливість оголосити багатопредметний тендер
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      minimal
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${tender_data}=  Підготовка даних для створення тендера
  ${TENDER_UAID}=  Викликати для учасника  ${tender_owner}  Створити тендер  ${tender_data}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  initial_data  ${tender_data}
  Set To Dictionary  ${TENDER}   TENDER_UAID             ${TENDER_UAID}
  log  ${TENDER}

Можливість знайти багатопредметний тендер по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук тендера по ідентифікатору
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      minimal
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \  Дочекатись синхронізації з майданчиком    ${username}
  \  Викликати для учасника  ${username}  Пошук тендера по ідентифікатору   ${TENDER['TENDER_UAID']}

Відображення опису позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів багатопредметного тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      minimal
  Звірити поля предметів закупівлі багатопредметного тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  description

Відображення дати доставки позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів багатопредметного тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      critical level 3
  Звірити дату предметів закупівлі багатопредметного тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  deliveryDate.endDate

Відображення координат широти доставки позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів багатопредметного тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Звірити поля предметів закупівлі багатопредметного тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  deliveryLocation.latitude

Відображення координат довготи доставки позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів багатопредметного тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Звірити поля предметів закупівлі багатопредметного тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  deliveryLocation.longitude

Відображення назви нас. пункту доставки позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів багатопредметного тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      critical level 3
  Звірити поля предметів закупівлі багатопредметного тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  deliveryAddress.countryName

Відображення пошт. коду доставки позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів багатопредметного тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Звірити поля предметів закупівлі багатопредметного тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  deliveryAddress.postalCode

Відображення регіону доставки позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів багатопредметного тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      critical level 3
  Звірити поля предметів закупівлі багатопредметного тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  deliveryAddress.region

Відображення locality адреси доставки позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів багатопредметного тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Звірити поля предметів закупівлі багатопредметного тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  deliveryAddress.locality

Відображення вулиці доставки позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів багатопредметного тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Звірити поля предметів закупівлі багатопредметного тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  deliveryAddress.streetAddress

Відображення схеми класифікації позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів багатопредметного тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Звірити поля предметів закупівлі багатопредметного тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  classification.scheme

Відображення ідентифікатора класифікації позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів багатопредметного тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      critical level 3
  Звірити поля предметів закупівлі багатопредметного тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  classification.id

Відображення опису класифікації позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів багатопредметного тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      critical level 3
  Звірити поля предметів закупівлі багатопредметного тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  classification.description

Відображення схеми додаткової класифікації позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів багатопредметного тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Звірити поля предметів закупівлі багатопредметного тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  additionalClassifications[0].scheme

Відображення ідентифікатора додаткової класифікації позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів багатопредметного тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      critical level 3
  Звірити поля предметів закупівлі багатопредметного тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  additionalClassifications[0].id

Відображення опису додаткової класифікації позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів багатопредметного тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      critical level 3
  Звірити поля предметів закупівлі багатопредметного тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  additionalClassifications[0].description

Відображення назви одиниці позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів багатопредметного тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      critical level 3
  Звірити поля предметів закупівлі багатопредметного тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  unit.name

Відображення коду одиниці позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів багатопредметного тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Звірити поля предметів закупівлі багатопредметного тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  unit.code

Відображення кількості позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів багатопредметного тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      critical level 3
  Звірити поля предметів закупівлі багатопредметного тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  quantity

Можливість редагувати багатопредметний тендер
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      critical level 2
  [Setup]  Дочекатись синхронізації з майданчиком    ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Викликати для учасника   ${tender_owner}  Внести зміни в тендер    ${TENDER['TENDER_UAID']}   description     description

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
