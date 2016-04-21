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
${mode}         multiItem
@{used_roles}   tender_owner  provider  provider1  viewer


*** Test Cases ***
Можливість оголосити багатопредметний тендер
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      minimal
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${tender_data}=  Підготовка даних для створення тендера
  ${adapted_data}=  Адаптувати дані для оголошення тендера  ${tender_owner}  ${tender_data}
  ${TENDER_UAID}=  Run As  ${tender_owner}  Створити тендер  ${adapted_data}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  initial_data=${adapted_data}
  Set To Dictionary  ${TENDER}   TENDER_UAID             ${TENDER_UAID}
  log  ${TENDER}

Можливість знайти багатопредметний тендер по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук тендера по ідентифікатору
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      minimal
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \  Дочекатись синхронізації з майданчиком    ${username}
  \  Run As  ${username}  Пошук тендера по ідентифікатору   ${TENDER['TENDER_UAID']}

Відображення опису позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів багатопредметного тендера
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      minimal
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \  Звірити поля предметів закупівлі багатопредметного тендера  ${username}  ${USERS.users['${tender_owner}'].initial_data}  description

Відображення дати доставки позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів багатопредметного тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      level3
  Звірити дату предметів закупівлі багатопредметного тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  deliveryDate.endDate  day  absolute_delta=${True}

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
  ...      level3
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
  ...      level3
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
  ...      level3
  Звірити поля предметів закупівлі багатопредметного тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  classification.id

Відображення опису класифікації позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів багатопредметного тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      level3
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
  ...      level3
  Звірити поля предметів закупівлі багатопредметного тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  additionalClassifications[0].id

Відображення опису додаткової класифікації позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів багатопредметного тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      level3
  Звірити поля предметів закупівлі багатопредметного тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  additionalClassifications[0].description

Відображення назви одиниці позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів багатопредметного тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      level3
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
  ...      level3
  Звірити поля предметів закупівлі багатопредметного тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  quantity

Можливість редагувати багатопредметний тендер
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      level2
  [Setup]  Дочекатись синхронізації з майданчиком    ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Run As   ${tender_owner}  Внести зміни в тендер    ${TENDER['TENDER_UAID']}   description     description

Можливість додати шосту позицію закупівлі в тендер
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      level2
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${item}=  Підготовка даних для створення предмету закупівлі
  Run As   ${tender_owner}   Додати предмет закупівлі    ${TENDER['TENDER_UAID']}   ${item}
  ${item_id}=  get_id_from_object  ${item}
  ${item_data}=  Create Dictionary  item=${item}  item_id=${item_id}
  ${item_data}=  munch_dict  arg=${item_data}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  item_data=${item_data}

Відображення опису нової шостої позиції закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів багатопредметного тендера
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      level2
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \  Дочекатись синхронізації з майданчиком    ${username}
  \  Звірити поле тендера із значенням  ${username}  ${USERS.users['${tender_owner}'].item_data.item.description}  description  ${USERS.users['${tender_owner}'].item_data.item_id}

Можливість додати сьому позицію закупівлі в тендер
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      level2
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${item}=  Підготовка даних для створення предмету закупівлі
  Run As   ${tender_owner}   Додати предмет закупівлі    ${TENDER['TENDER_UAID']}   ${item}
  ${item_id}=  get_id_from_object  ${item}
  ${item_data}=  Create Dictionary  item=${item}  item_id=${item_id}
  ${item_data}=  munch_dict  arg=${item_data}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  item_data=${item_data}

Відображення опису нової сьомої позиції закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів багатопредметного тендера
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      level2
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \  Дочекатись синхронізації з майданчиком    ${username}
  \  Звірити поле тендера із значенням  ${username}  ${USERS.users['${tender_owner}'].item_data.item.description}  description  ${USERS.users['${tender_owner}'].item_data.item_id}

Можливість видалити п’яту позицію закупівлі тендера
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      level2
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${item_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].tender_data.data['items'][4]}
  Run As  ${tender_owner}  Видалити предмет закупівлі  ${TENDER['TENDER_UAID']}  ${item_id}
