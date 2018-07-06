*** Settings ***
Resource             base_keywords.robot
Suite Setup          Test Suite Setup
Suite Teardown       Test Suite Teardown


*** Variables ***
${MODE}              belowThreshold

@{USED_ROLES}        dasu_user  tender_owner  provider  provider1  provider2  viewer

${NUMBER_OF_ITEMS}   ${1}
${NUMBER_OF_LOTS}    ${1}
${TENDER_MEAT}       ${True}
${LOT_MEAT}          ${True}
${ITEM_MEAT}         ${True}
${MOZ_INTEGRATION}   ${False}

*** Test Cases ***
Можливість оголосити тендер
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оголошення тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_tender
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість оголосити тендер


Можливість знайти тендер по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук тендера
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      ${USERS.users['${provider2}'].broker}
  ...      find_tender
  ...      critical
  Можливість знайти тендер по ідентифікатору для усіх користувачів


Можливість знайти тендер по ідентифікатору користувачем ДАСУ
  [Tags]   ${USERS.users['${dasu_user}'].broker}: Пошук тендера
  ...      dasu_user
  ...      ${USERS.users['${dasu_user}'].broker}
  ...      find_tender
  ...      critical
  Можливість знайти тендер по ідентифікатору для користувача ${dasu_user}


Відображення ідентифікатора тендера
  [Tags]   ${USERS.users['${dasu_user}'].broker}: Відображення основних даних тендера
  ...      dasu_user
  ...      ${USERS.users['${dasu_user}'].broker}
  ...      tender_view
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля tenderID тендера із ${TENDER['TENDER_UAID']} для користувача ${dasu_user}


Відображення імені замовника тендера
  [Tags]   ${USERS.users['${dasu_user}'].broker}: Відображення основних даних тендера
  ...      dasu_user
  ...      ${USERS.users['${dasu_user}'].broker}
  ...      tender_view
  ...      critical
  Звірити відображення поля procuringEntity.name тендера для користувача ${dasu_user}


Відображення типу оголошеного тендера
  [Tags]   ${USERS.users['${dasu_user}'].broker}: Відображення основних даних тендера
  ...      dasu_user
  ...      ${USERS.users['${dasu_user}'].broker}
  ...      tender_view
  ...      critical
  Отримати дані із поля procurementMethodType тендера для користувача ${dasu_user}


Відображення бюджету тендера
  [Tags]   ${USERS.users['${dasu_user}'].broker}: Відображення основних даних тендера
  ...      dasu_user
  ...      ${USERS.users['${dasu_user}'].broker}
  ...      tender_view
  ...      critical
  Звірити відображення поля value.amount тендера для користувача ${dasu_user}


Відображення валюти тендера
  [Tags]   ${USERS.users['${dasu_user}'].broker}: Відображення основних даних тендера
  ...      dasu_user
  ...      ${USERS.users['${dasu_user}'].broker}
  ...      tender_view
  ...      critical
  Звірити відображення поля value.currency тендера для користувача ${dasu_user}


Відображення опису номенклатур тендера
  [Tags]   ${USERS.users['${dasu_user}'].broker}: Відображення основних даних тендера
  ...      dasu_user
  ...      ${USERS.users['${dasu_user}'].broker}
  ...      tender_view
  ...      critical
  Звірити відображення поля description усіх предметів для користувача ${dasu_user}


Відображення схеми класифікації номенклатур тендера
  [Tags]   ${USERS.users['${dasu_user}'].broker}: Відображення основних даних тендера
  ...      dasu_user
  ...      ${USERS.users['${dasu_user}'].broker}
  ...      tender_view
  ...      critical
  Звірити відображення поля classification.scheme усіх предметів для користувача ${dasu_user}


Відображення кількості номенклатур тендера
  [Tags]   ${USERS.users['${dasu_user}'].broker}: Відображення основних даних тендера
  ...      dasu_user
  ...      ${USERS.users['${dasu_user}'].broker}
  ...      tender_view
  ...      critical
  Звірити відображення поля quantity усіх предметів для користувача ${dasu_user}


Відображення назви одиниці номенклатур тендера
  [Tags]   ${USERS.users['${dasu_user}'].broker}: Відображення основних даних тендера
  ...      dasu_user
  ...      ${USERS.users['${dasu_user}'].broker}
  ...      tender_view
  ...      critical
  Звірити відображення поля unit.name усіх предметів для користувача ${dasu_user}


Відображення дати кінця доставки номенклатур тендера
  [Tags]   ${USERS.users['${dasu_user}'].broker}: Відображення основних даних тендера
  ...      dasu_user
  ...      ${USERS.users['${dasu_user}'].broker}
  ...      tender_view
  ...      critical
  Звірити відображення дати deliveryDate.endDate усіх предметів для користувача ${dasu_user}


Відображення країни доставки номенклатур тендера
  [Tags]   ${USERS.users['${dasu_user}'].broker}: Відображення основних даних тендера
  ...      dasu_user
  ...      ${USERS.users['${dasu_user}'].broker}
  ...      tender_view
  ...      critical
  Звірити відображення поля deliveryAddress.countryName усіх предметів для користувача ${dasu_user}


Відображення пошт. коду доставки номенклатур тендера
  [Tags]   ${USERS.users['${dasu_user}'].broker}: Відображення основних даних тендера
  ...      dasu_user
  ...      ${USERS.users['${dasu_user}'].broker}
  ...      tender_view
  ...      critical
  Звірити відображення поля deliveryAddress.postalCode усіх предметів для користувача ${dasu_user}


Відображення регіону доставки номенклатур тендера
  [Tags]   ${USERS.users['${dasu_user}'].broker}: Відображення основних даних тендера
  ...      dasu_user
  ...      ${USERS.users['${dasu_user}'].broker}
  ...      tender_view
  ...      critical
  Звірити відображення поля deliveryAddress.region усіх предметів для користувача ${dasu_user}


Відображення статусу тендера
  [Tags]   ${USERS.users['${dasu_user}'].broker}: Відображення основних даних тендера
  ...      dasu_user
  ...      ${USERS.users['${dasu_user}'].broker}
  ...      tender_view
  ...      critical
  Отримати дані із поля status тендера для користувача ${dasu_user}


Можливість створити об'єкт моніторингу
  [Tags]   ${USERS.users['${dasu_user}'].broker}: Створення об'єкта моніторингу
  ...      dasu_user
  ...      ${USERS.users['${dasu_user}'].broker}
  ...      create_monitoring
  ...      critical
  [Teardown]  Оновити DASU_LAST_MODIFICATION_DATE
  Можливість створити об'єкт моніторингу


Можливість додати документацію до об’єкта моніторингу
  [Tags]   ${USERS.users['${dasu_user}'].broker}: Додання документації
  ...      dasu_user
  ...      ${USERS.users['${dasu_user}'].broker}
  ...      add_doc
  ...      critical
  [Setup]  Дочекатись синхронізації з ДАСУ  ${dasu_user}
  [Teardown]  Оновити DASU_LAST_MODIFICATION_DATE
  Можливість додати документацію до об'єкта моніторингу


Можливість оприлюднити рішення про початок моніторингу
  [Tags]   ${USERS.users['${dasu_user}'].broker}: Оприлюднити рішення
  ...      dasu_user
  ...      ${USERS.users['${dasu_user}'].broker}
  ...      active_monitoring
  ...      critical
  [Teardown]  Оновити DASU_LAST_MODIFICATION_DATE
  Можливість оприлюднити рішення про початок моніторингу


Можливість знайти об'єкт моніторингу по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук об'єкта моніторингу
  ...      viewer  dasu_user
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${dasu_user}'].broker}
  ...      find_monitoring
  ...      critical
  Можливість знайти об'єкт моніторингу по ідентифікатору


Відображення статусу active об’єкта моніторингу
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних моніторингу
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      active_monitoring
  ...      critical
  Звірити статус об'єкта моніторингу  ${viewer}  ${MONITORING['MONITORING_UAID']}  active


Відображення дати створення об’єкта моніторингу
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних моніторингу
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      monitoring_view
  ...      critical
  Отримати дані із поля dateCreated об'єкта моніторингу для користувача ${viewer}


Відображення ідентифікатора об’єкта моніторингу
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних моніторингу
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      monitoring_view
  ...      critical
  Отримати дані із поля monitoring_id об'єкта моніторингу для користувача ${viewer}


Відображення ідентифікатора тендера об’єкта моніторингу
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних моніторингу
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      monitoring_view
  ...      critical
  Звірити відображення поля tender_id об'єкта моніторингу для користувача ${viewer}


Відображення дати прийняття рішення про проведення моніторингу
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних моніторингу
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      monitoring_view
  ...      critical
  Звірити відображення поля decision.date об'єкта моніторингу для користувача ${viewer}


Відображення опису прийняття рішення про проведення моніторингу
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних моніторингу
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      monitoring_view
  ...      critical
  Звірити відображення поля decision.description об'єкта моніторингу для користувача ${viewer}


Відображення дати публікації рішення про проведення моніторингу
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних моніторингу
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      monitoring_view
  ...      critical
  Отримати дані із поля decision.datePublished об'єкта моніторингу для користувача ${viewer}


Відображення причини для проведення моніторингу
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних моніторингу
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      monitoring_view
  ...      critical
  Звірити відображення поля reasons об'єкта моніторингу для користувача ${viewer}


Відображення дати початку періоду моніторингу
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних моніторингу
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      monitoring_view
  ...      critical
  Отримати дані із поля monitoringPeriod.startDate об'єкта моніторингу для користувача ${viewer}


Відображення дати закінчення періоду моніторингу
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних моніторингу
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      monitoring_view
  ...      critical
  Отримати дані із поля monitoringPeriod.endDate об'єкта моніторингу для користувача ${viewer}


Відображення етапу тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних моніторингу
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      monitoring_view
  ...      critical
  Звірити відображення поля procuringStages[0] об'єкта моніторингу для користувача ${viewer}


Відображення імені учасника моніторингу
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних моніторингу
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      monitoring_view
  ...      critical
  Звірити відображення поля parties[0].name об'єкта моніторингу для користувача ${viewer}


Відображення ролі учасника моніторингу
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних моніторингу
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      monitoring_view
  ...      critical
  Звірити відображення поля parties[0].roles об'єкта моніторингу для користувача ${viewer}


Відображення імені контактної особи учасника процесу моніторингу
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних моніторингу
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      monitoring_view
  ...      critical
  Звірити відображення поля parties[0].contactPoint.name об'єкта моніторингу для користувача ${viewer}


Відображення мобільного номера контактної особи учасника процесу моніторингу
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних моніторингу
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      monitoring_view
  ...      critical
  Звірити відображення поля parties[0].contactPoint.telephone об'єкта моніторингу для користувача ${viewer}


Відображення країни в адресі учасника процесу моніторингу
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних моніторингу
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      monitoring_view
  ...      critical
  Звірити відображення поля parties[0].address.countryName об'єкта моніторингу для користувача ${viewer}


Відображення вулиці в адресі учасника процесу моніторингу
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних моніторингу
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      monitoring_view
  ...      critical
  Звірити відображення поля parties[0].address.streetAddress об'єкта моніторингу для користувача ${viewer}


Відображення регіону в адресі учасника процесу моніторингу
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних моніторингу
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      monitoring_view
  ...      critical
  Звірити відображення поля parties[0].address.region об'єкта моніторингу для користувача ${viewer}


Відображення нас. пункту в адресі учасника процесу моніторингу
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних моніторингу
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      monitoring_view
  ...      critical
  Звірити відображення поля parties[0].address.locality об'єкта моніторингу для користувача ${viewer}


Відображення id учасника процесу моніторингу
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних моніторингу
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      monitoring_view
  ...      critical
  Отримати дані із поля parties[0].id об'єкта моніторингу для користувача ${viewer}


Відображення схеми ідентифікатора учасника процесу моніторингу
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних моніторингу
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      monitoring_view
  ...      critical
  Звірити відображення поля parties[0].identifier.scheme об'єкта моніторингу для користувача ${viewer}


Відображення id ідентифікатора учасника процесу моніторингу
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних моніторингу
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      monitoring_view
  ...      critical
  Звірити відображення поля parties[0].identifier.id об'єкта моніторингу для користувача ${viewer}


Відображення юридичної назви учасника процесу моніторингу
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних моніторингу
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      monitoring_view
  ...      critical
  Звірити відображення поля parties[0].identifier.legalName об'єкта моніторингу для користувача ${viewer}


Можливість додати учасника процесу моніторингу
  [Tags]   ${USERS.users['${dasu_user}'].broker}: Додати учасника
  ...      dasu_user
  ...      ${USERS.users['${dasu_user}'].broker}
  ...      add_party
  ...      critical
  [Teardown]  Оновити DASU_LAST_MODIFICATION_DATE
  Можливість додати учасника процесу моніторингу


Відображення імені доданого учасника
  [Tags]   ${USERS.users['${viewer}'].broker}: Додати учасника
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      add_party
  ...      critical
  [Setup]  Дочекатись синхронізації з ДАСУ  ${viewer}
  Отримати дані із поля parties[1].name об'єкта моніторингу для користувача ${viewer}


Відображення ролі доданого учасника
  [Tags]   ${USERS.users['${viewer}'].broker}: Додати учасника
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      add_party
  ...      critical
  Отримати дані із поля parties[1].roles об'єкта моніторингу для користувача ${viewer}


Відображення id доданого учасника
  [Tags]   ${USERS.users['${viewer}'].broker}: Додати учасника
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      add_party
  ...      critical
  Отримати дані із поля parties[1].id об'єкта моніторингу для користувача ${viewer}


Можливість запитати в замовника пояснення
  [Tags]   ${USERS.users['${dasu_user}'].broker}: Створення діалогу
  ...      dasu_user
  ...      ${USERS.users['${dasu_user}'].broker}
  ...      create_post
  ...      critical
  [Teardown]  Оновити DASU_LAST_MODIFICATION_DATE
  Можливість запитати в замовника пояснення


Можливість надати пояснення замовником
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Надання пояснення
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      answer_tender_owner
  ...      critical
  [Setup]  Дочекатись синхронізації з ДАСУ  ${tender_owner}
  [Teardown]  Оновити DASU_LAST_MODIFICATION_DATE
  Можливість надати пояснення замовником


Відображення опису пояснення
  [Tags]   ${USERS.users['${dasu_user}'].broker}: Надання пояснення
  ...      dasu_user
  ...      ${USERS.users['${dasu_user}'].broker}
  ...      answer_view
  ...      critical
  [Setup]  Дочекатись синхронізації з ДАСУ  ${dasu_user}
  Отримати дані із поля posts[1].description об'єкта моніторингу для користувача ${dasu_user}


Відображення заголовку пояснення
  [Tags]   ${USERS.users['${dasu_user}'].broker}: Надання пояснення
  ...      dasu_user
  ...      ${USERS.users['${dasu_user}'].broker}
  ...      answer_view
  ...      critical
  [Setup]  Дочекатись синхронізації з ДАСУ  ${dasu_user}
  Отримати дані із поля posts[1].title об'єкта моніторингу для користувача ${dasu_user}


Можливість надати висновок про відсутність порушення в тендері
  [Tags]   ${USERS.users['${dasu_user}'].broker}: Надання висновоку
  ...      dasu_user
  ...      ${USERS.users['${dasu_user}'].broker}
  ...      declined
  ...      critical
  [Setup]  Дочекатись синхронізації з ДАСУ  ${dasu_user}
  [Teardown]  Оновити DASU_LAST_MODIFICATION_DATE
  Можливість надати висновок про відсутність порушення в тендері


Можливість надати висновок про наявність порушення в тендері
  [Tags]   ${USERS.users['${dasu_user}'].broker}: Надання висновоку
  ...      dasu_user
  ...      ${USERS.users['${dasu_user}'].broker}
  ...      addressed
  ...      critical
  [Setup]  Дочекатись синхронізації з ДАСУ  ${dasu_user}
  [Teardown]  Оновити DASU_LAST_MODIFICATION_DATE
  Можливість надати висновок про наявність порушення в тендері


Можливість змінити статус об’єкта моніторингу на declined
  [Tags]   ${USERS.users['${dasu_user}'].broker}: Порушення не виявлені
  ...      dasu_user
  ...      ${USERS.users['${dasu_user}'].broker}
  ...      declined
  ...      critical
  [Setup]  Дочекатись синхронізації з ДАСУ  ${dasu_user}
  [Teardown]  Оновити DASU_LAST_MODIFICATION_DATE
  Можливість змінити статус об’єкта моніторингу на declined


Відображення статусу declined об’єкта моніторингу
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Порушення не виявлені
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      declined
  ...      critical
  [Setup]  Дочекатись синхронізації з ДАСУ  ${tender_owner}
  Звірити статус об'єкта моніторингу  ${tender_owner}  ${MONITORING['MONITORING_UAID']}  declined


Можливість змінити статус об’єкта моніторингу на addressed
  [Tags]   ${USERS.users['${dasu_user}'].broker}: Порушення виявлені
  ...      dasu_user
  ...      ${USERS.users['${dasu_user}'].broker}
  ...      addressed
  ...      critical
  [Setup]  Дочекатись синхронізації з ДАСУ  ${dasu_user}
  [Teardown]  Оновити DASU_LAST_MODIFICATION_DATE
  Можливість змінити статус об’єкта моніторингу на addressed


Відображення статусу addressed об’єкта моніторингу
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Порушення виявлені
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      addressed
  ...      critical
  [Setup]  Дочекатись синхронізації з ДАСУ  ${tender_owner}
  Звірити статус об'єкта моніторингу  ${tender_owner}  ${MONITORING['MONITORING_UAID']}  addressed


Можливість надати пояснення замовником з власної ініціативи
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Надання пояснення
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      addressed
  ...      critical
  [Setup]  Дочекатись синхронізації з ДАСУ  ${tender_owner}
  [Teardown]  Оновити DASU_LAST_MODIFICATION_DATE
  Можливість надати пояснення замовником з власної ініціативи


Відображення заголовку пояснення замовника з власної ініціативи
  [Tags]   ${USERS.users['${dasu_user}'].broker}: Надання пояснення
  ...      dasu_user
  ...      ${USERS.users['${dasu_user}'].broker}
  ...      post_view
  ...      critical
  [Setup]  Дочекатись синхронізації з ДАСУ  ${dasu_user}
  Отримати дані із поля posts[2].title об'єкта моніторингу для користувача ${dasu_user}


Відображення опису пояснення замовника з власної ініціативи
  [Tags]   ${USERS.users['${dasu_user}'].broker}: Надання пояснення
  ...      dasu_user
  ...      ${USERS.users['${dasu_user}'].broker}
  ...      post_view
  ...      critical
  Отримати дані із поля posts[2].description об'єкта моніторингу для користувача ${dasu_user}


Можливість надати відповідь на пояснення замовника
  [Tags]   ${USERS.users['${dasu_user}'].broker}: Надання пояснення
  ...      dasu_user
  ...      ${USERS.users['${dasu_user}'].broker}
  ...      addressed
  ...      critical
  [Teardown]  Оновити DASU_LAST_MODIFICATION_DATE
  Можливість надати відповідь користувачем ДАСУ


Відображення заголовку відповіді
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Надання пояснення
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      post_view
  ...      critical
  [Setup]  Дочекатись синхронізації з ДАСУ  ${tender_owner}
  Отримати дані із поля posts[3].title об'єкта моніторингу для користувача ${tender_owner}


Відображення опису відповіді
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Надання пояснення
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      post_view
  ...      critical
  Отримати дані із поля posts[3].description об'єкта моніторингу для користувача ${tender_owner}


Можливість надати звіт про усунення порушення замовником
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Надання звіту
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      addressed
  ...      critical
  [Setup]  Дочекатись синхронізації з ДАСУ  ${tender_owner}
  [Teardown]  Оновити DASU_LAST_MODIFICATION_DATE
  Можливість надати звіт про усунення порушення замовником


Відображення опису звіту про усунення порушення замовником
  [Tags]   ${USERS.users['${dasu_user}'].broker}: Надання звіту
  ...      dasu_user
  ...      ${USERS.users['${dasu_user}'].broker}
  ...      report_view
  ...      critical
  [Setup]  Дочекатись синхронізації з ДАСУ  ${dasu_user}
  Отримати дані із поля eliminationReport.description об'єкта моніторингу для користувача ${dasu_user}


Можливість оприлюднити рішення про усунення порушення
  [Tags]   ${USERS.users['${dasu_user}'].broker}: Оприлюднити рішення
  ...      dasu_user
  ...      ${USERS.users['${dasu_user}'].broker}
  ...      addressed
  ...      critical
  [Setup]  Дочекатись синхронізації з ДАСУ  ${dasu_user}
  [Teardown]  Оновити DASU_LAST_MODIFICATION_DATE
  Можливість оприлюднути рішення про усунення порушення


Відображення опису рішення про усунення порушення
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оприлюднити рішення
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      resolution_view
  ...      critical
  [Setup]  Дочекатись синхронізації з ДАСУ  ${tender_owner}
  Отримати дані із поля eliminationResolution.description об'єкта моніторингу для користувача ${tender_owner}


Можливість зазначити, що висновок було оскаржено в суді
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оскарження в суді
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      addressed
  ...      critical
  [Setup]  Дочекатись синхронізації з ДАСУ  ${tender_owner}
  [Teardown]  Оновити DASU_LAST_MODIFICATION_DATE
  Можливість зазначити, що порушення було оскаржено в суді


Відображення опису висновку, оскарженого в суді
  [Tags]   ${USERS.users['${dasu_user}'].broker}: Оскарження в суді
  ...      dasu_user
  ...      ${USERS.users['${dasu_user}'].broker}
  ...      appeal_view
  ...      critical
  [Setup]  Дочекатись синхронізації з ДАСУ  ${dasu_user}
  Отримати дані із поля appeal.description об'єкта моніторингу для користувача ${dasu_user}


Відображення дати закінчення періоду ліквідаації
  [Tags]   ${USERS.users['${dasu_user}'].broker}: Завершення моніторингу
  ...      dasu_user
  ...      ${USERS.users['${dasu_user}'].broker}
  ...      eliminationPeriod_endDate
  ...      critical
  [Setup]  Дочекатись синхронізації з ДАСУ  ${dasu_user}
  Отримати дані із поля eliminationPeriod.endDate об'єкта моніторингу для користувача ${dasu_user}
  Дочекатись дати  ${USERS.users['${dasu_user}'].monitoring_data.data.eliminationPeriod.endDate}


Можливість змінити статус об’єкта моніторингу на completed
  [Tags]   ${USERS.users['${dasu_user}'].broker}: Завершення моніторингу
  ...      dasu_user
  ...      ${USERS.users['${dasu_user}'].broker}
  ...      completed
  ...      critical
  [Teardown]  Оновити DASU_LAST_MODIFICATION_DATE
  Можливість змінити статус об’єкта моніторингу на completed


Відображення статусу completed об’єкта моніторингу
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Завершення моніторингу
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      completed
  ...      critical
  [Setup]  Дочекатись синхронізації з ДАСУ  ${tender_owner}
  Звірити статус об'єкта моніторингу  ${tender_owner}  ${MONITORING['MONITORING_UAID']}  completed


Можливість змінити статус об’єкта моніторингу на stopped
  [Tags]   ${USERS.users['${dasu_user}'].broker}: Завершення моніторингу
  ...      dasu_user
  ...      ${USERS.users['${dasu_user}'].broker}
  ...      stopped
  ...      critical
  [Setup]  Дочекатись синхронізації з ДАСУ  ${dasu_user}
  [Teardown]  Оновити DASU_LAST_MODIFICATION_DATE
  Можливість змінити статус об’єкта моніторингу на stopped


Відображення статусу stopped об’єкта моніторингу
  [Tags]   ${USERS.users['${viewer}'].broker}: Завершення моніторингу
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      stopped
  ...      critical
  [Setup]  Дочекатись синхронізації з ДАСУ  ${viewer}
  Звірити статус об'єкта моніторингу  ${viewer}  ${MONITORING['MONITORING_UAID']}  stopped


Можливість змінити статус об’єкта моніторингу на cancelled
  [Tags]   ${USERS.users['${dasu_user}'].broker}: Завершення моніторингу
  ...      dasu_user
  ...      ${USERS.users['${dasu_user}'].broker}
  ...      cancelled
  ...      critical
  [Setup]  Дочекатись синхронізації з ДАСУ  ${dasu_user}
  [Teardown]  Оновити DASU_LAST_MODIFICATION_DATE
  Можливість змінити статус об’єкта моніторингу на cancelled


Відображення статусу cancelled об’єкта моніторингу
  [Tags]   ${USERS.users['${viewer}'].broker}: Завершення моніторингу
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      cancelled
  ...      critical
  [Setup]  Дочекатись синхронізації з ДАСУ  ${viewer}
  Звірити статус об'єкта моніторингу  ${viewer}  ${MONITORING['MONITORING_UAID']}  cancelled


Відображення опису у звіті про зупинення
  [Tags]   ${USERS.users['${viewer}'].broker}: Завершення моніторингу
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      cancellation_view
  ...      critical
  [Setup]  Дочекатись синхронізації з ДАСУ  ${viewer}
  Отримати дані із поля cancellation.description об'єкта моніторингу для користувача ${viewer}


Відображення дати публікації звіту про зупинення
  [Tags]   ${USERS.users['${viewer}'].broker}: Завершення моніторингу
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      cancellation_view
  ...      critical
  Отримати дані із поля cancellation.datePublished об'єкта моніторингу для користувача ${viewer}


Можливість змінити статус об’єкта моніторингу на closed
  [Tags]   ${USERS.users['${dasu_user}'].broker}: Завершення моніторингу
  ...      dasu_user
  ...      ${USERS.users['${dasu_user}'].broker}
  ...      closed
  ...      critical
  [Teardown]  Оновити DASU_LAST_MODIFICATION_DATE
  Можливість змінити статус об’єкта моніторингу на closed


Відображення статусу closed об’єкта моніторингу
  [Tags]   ${USERS.users['${viewer}'].broker}: Завершення моніторингу
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      closed
  ...      critical
  [Setup]  Дочекатись синхронізації з ДАСУ  ${tender_owner}
  Звірити статус об'єкта моніторингу  ${tender_owner}  ${MONITORING['MONITORING_UAID']}  closed