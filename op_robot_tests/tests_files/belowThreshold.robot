*** Settings ***
Resource        base_keywords.robot
Suite Setup     Test Suite Setup
Suite Teardown  Test Suite Teardown


*** Variables ***
${mode}            belowThreshold
@{used_roles}      tender_owner  provider  provider1  viewer

${number_of_lots}  ${1}
${meat}            ${1}


*** Test Cases ***
Можливість оголосити тендер
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оголошення тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість оголосити тендер


Можливість знайти тендер по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук тендера
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  Можливість знайти тендер по ідентифікатору для усіх учасників

##############################################################################################
#             Відображення основних даних тендера
##############################################################################################

Відображення заголовку тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля title тендера для користувача ${viewer}


Відображення опису тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Звірити відображення поля description тендера для користувача ${viewer}


Відображення бюджету тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Звірити відображення поля value.amount тендера для користувача ${viewer}


Відображення валюти тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Звірити відображення поля value.currency тендера для користувача ${viewer}


Відображення ПДВ в бюджеті тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Звірити відображення поля value.valueAddedTaxIncluded тендера для користувача ${viewer}


Відображення ідентифікатора тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Звірити відображення поля tenderID тендера із ${TENDER['TENDER_UAID']} для користувача ${viewer}


Відображення імені замовника тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Звірити відображення поля procuringEntity.name тендера для користувача ${viewer}


Відображення початку періоду уточнення тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Звірити відображення дати enquiryPeriod.startDate тендера для користувача ${viewer}


Відображення закінчення періоду уточнення тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Звірити відображення дати enquiryPeriod.endDate тендера для користувача ${viewer}


Відображення початку періоду прийому пропозицій тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Звірити відображення поля tenderPeriod.startDate тендера для усіх користувачів


Відображення закінчення періоду прийому пропозицій тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Звірити відображення поля tenderPeriod.endDate тендера для усіх користувачів


Відображення мінімального кроку тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Звірити відображення поля minimalStep.amount тендера для користувача ${viewer}

##############################################################################################
#             Відображення основних даних предмету
##############################################################################################

Відображення опису номенклатур тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля description усіх предметів для користувача ${viewer}


Відображення дати доставки номенклатур тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Звірити відображення дати deliveryDate.endDate усіх предметів для користувача ${viewer}


Відображення координати доставки номенклатур закупівлі тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Звірити відображення координат усіх предметів для користувача ${viewer}


Відображення назви нас. пункту доставки номенклатур тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Звірити відображення поля deliveryAddress.countryName усіх предметів для користувача ${viewer}


Відображення пошт. коду доставки номенклатур тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Звірити відображення поля deliveryAddress.postalCode усіх предметів для користувача ${viewer}


Відображення регіону доставки номенклатур тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Звірити відображення поля deliveryAddress.region усіх предметів для користувача ${viewer}


Відображення locality адреси доставки номенклатур тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Звірити відображення поля deliveryAddress.locality усіх предметів для користувача ${viewer}


Відображення вулиці доставки номенклатур тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Звірити відображення поля deliveryAddress.streetAddress усіх предметів для користувача ${viewer}


Відображення схеми класифікації номенклатур тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Звірити відображення поля classification.scheme усіх предметів для користувача ${viewer}


Відображення ідентифікатора класифікації номенклатур тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Звірити відображення поля classification.id усіх предметів для користувача ${viewer}


Відображення опису класифікації номенклатур тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Звірити відображення поля classification.description усіх предметів для користувача ${viewer}


Відображення схеми додаткової класифікації номенклатур тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Звірити відображення поля additionalClassifications[0].scheme усіх предметів для користувача ${viewer}


Відображення ідентифікатора додаткової класифікації номенклатур тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Звірити відображення поля additionalClassifications[0].id усіх предметів для користувача ${viewer}


Відображення опису додаткової класифікації номенклатур тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Звірити відображення поля additionalClassifications[0].description усіх предметів для користувача ${viewer}


Відображення назви одиниці номенклатур тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Звірити відображення поля unit.name усіх предметів для користувача ${viewer}


Відображення коду одиниці номенклатур тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Звірити відображення поля unit.code усіх предметів для користувача ${viewer}


Відображення кількості номенклатур тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Звірити відображення поля quantity усіх предметів для користувача ${viewer}

##############################################################################################
#             Відображення основних даних лоту
##############################################################################################

Відображення заголовку лотів
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення лоту тендера
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      lots
  Звірити відображення поля title усіх лотів для усіх користувачів


Відображення опису лотів
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення лоту тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      lots
  Звірити відображення поля description усіх лотів для користувача ${viewer}


Відображення бюджету лотів
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення лоту тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      lots
  Звірити відображення поля value.amount усіх лотів для користувача ${viewer}


Відображення валюти лотів
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення лоту тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      lots
  Звірити відображення поля value.currency усіх лотів для користувача ${viewer}


Відображення ПДВ в бюджеті лотів
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення лоту тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      lots
  Звірити відображення поля value.valueAddedTaxIncluded усіх лотів для користувача ${viewer}

##############################################################################################
#             Відображення основних даних предмету
##############################################################################################

Відображення заголовку нецінових показників
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення лоту тендера
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      meat
  Звірити відображення поля title усіх нецінових показників для усіх користувачів


Відображення опису нецінових показників
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення лоту тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      meat
  Звірити відображення поля description усіх нецінових показників для користувача ${viewer}


Відображення відношення нецінових показників
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення лоту тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      meat
  Звірити відображення поля featureOf усіх нецінових показників для користувача ${viewer}

##############################################################################################
#             Редагування тендера
##############################################################################################

Можливість додати документацію до тендера
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Додання документації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_documentation_to_tender
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість додати документацію до тендера


Можливість додати документацію до першого лоту
  [Tags]    ${USERS.users['${tender_owner}'].broker}: Додання документації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      lots  add_documentation_to_lot
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість додати документацію до 0 лоту


Можливість зменшити бюджет першого лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      lots
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість змінити на 98 відсотки бюджет 0 лоту


Можливість збільшити бюджет першого лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      lots
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість змінити на 103 відсотки бюджет 0 лоту


Можливість створення лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      lots  second_lot
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість створення лоту


Відображення заголовку нового лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення лоту тендера
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      lots  second_lot  second_lot_view
  Звірити відображення поля title у новоствореному лоті для усіх користувачів


Можливість додати предмет закупівлі
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_item
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Run Keyword IF  ${number_of_lots} == 0
  ...      Можливість додати предмет закупівлі в тендер
  ...      ELSE
  ...      Можливість додати предмет закупівлі в -1 лот


Можливість видалити предмет закупівлі
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      delete_item
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Run Keyword IF  ${number_of_lots} == 0
  ...      Можливість видалити предмет закупівлі з тендера
  ...      ELSE
  ...      Можливість видалити предмет закупівлі з -1 лоту


Можливість видалення лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      lots  second_lot  delete_second_lot
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість видалення -1 лоту

##############################################################################################
#             QUESTIONS
##############################################################################################

Можливість задати запитання на тендер
  [Tags]   ${USERS.users['${provider}'].broker}: Задання запитання
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      question_to_tender
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість задати запитання на тендер користувачем ${provider}


Відображення заголовку анонімного питання на тендер без відповіді
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення запитання
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля title запитання для усіх користувачів


Відображення опису анонімного питання на тендер без відповіді
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення запитання
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Звірити відображення поля description запитання для користувача ${viewer}


Можливість відповісти на запитання на тендер
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Відповідь на запитання
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      answer_question_to_tender
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість відповісти на запитання


Відображення відповіді на запитання на тендер
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення відповіді на запитання
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля answer запитання для користувача ${viewer}


Можливість задати запитання на перший предмет
  [Tags]   ${USERS.users['${provider}'].broker}: Задання запитання
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      question_to_item
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість задати запитання на 0 предмет користувачем ${provider}


Відображення заголовку анонімного питання на перший предмет без відповіді
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення запитання
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      question_to_item
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля title запитання для усіх користувачів


Відображення опису анонімного питання на перший предмет без відповіді
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення запитання
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      question_to_item
  Звірити відображення поля description запитання для користувача ${viewer}


Можливість відповісти на запитання на перший предмет
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Відповідь на запитання
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      answer_question_to_item
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість відповісти на запитання


Відображення відповіді на запитання на перший предмет
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення відповіді на запитання
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      answer_question_to_item
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля answer запитання для користувача ${viewer}


Можливість задати запитання на перший лот
  [Tags]   ${USERS.users['${provider}'].broker}: Задання запитання
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      lots  question_to_lot
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість задати запитання на 0 лот користувачем ${provider}


Відображення заголовку анонімного питання на перший лот без відповіді
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення запитання
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      lots  question_to_lot
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля title запитання для усіх користувачів


Відображення опису анонімного питання на перший лот без відповіді
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення запитання
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      lots  question_to_lot
  Звірити відображення поля description запитання для користувача ${viewer}


Можливість відповісти на запитання на перший лот
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Відповідь на запитання
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      lots  answer_question_to_item
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість відповісти на запитання


Відображення відповіді на запитання на перший лот
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення відповіді на запитання
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      lots  answer_question_to_item
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля answer запитання для користувача ${viewer}

##############################################################################################
#             BIDDING
##############################################################################################

Неможливість подати пропозицію до початку періоду подачі пропозицій першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  Run Keyword And Expect Error  *  Можливість подати цінову пропозицію користувачем ${provider}


Неможливість подати цінову пропозицію без прив’язки до лоту
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      lots
  [Setup]  Дочекатись дати початку прийому пропозицій  ${provider}
  Неможливість подати цінову пропозицію без прив’язки до лоту користувачем ${provider}


Неможливість подати цінову пропозицію без нецінових показників
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      meat
  [Setup]  Дочекатись дати початку прийому пропозицій  ${provider}
  Неможливість подати цінову пропозицію без нецінових показників користувачем ${provider}


Можливість подати пропозицію першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      first_bid
  [Setup]  Дочекатись дати початку прийому пропозицій  ${provider}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати цінову пропозицію користувачем ${provider}

Можливість змінити пропозицію до 50000 першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      first_bid
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість змінити пропозицію до 50000 користувачем ${provider}


Можливість змінити пропозицію до 10 першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      first_bid
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість змінити пропозицію до 10 користувачем ${provider}


Можливість завантажити документ в пропозицію першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      first_bid
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість завантажити документ в пропозицію користувачем ${provider}


Можливість змінити документацію цінової пропозиції першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      add_documentation_to_bid
  ...      first_bid
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість змінити документацію цінової пропозиції користувачем ${provider}


Можливість скасувати пропозицію
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      first_bid  first_bid_canceled
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість скасувати цінову пропозицію користувачем ${provider}


Можливість подати пропозицію другим учасником
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      second_bid
  [Setup]  Дочекатись дати початку прийому пропозицій  ${provider1}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати цінову пропозицію користувачем ${provider1}


Неможливість побачити цінові пропозиції учасників під час прийому пропозицій
  [Tags]   ${USERS.users['${viewer}'].broker}: Подання пропозиції
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Require Failure  ${viewer}  Отримати інформацію із тендера  bids

##############################################################################################
#             AUCTION PERIOD
##############################################################################################

Неможливість завантажити документ першим учасником після закінчення прийому пропозицій
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      second_bid
  Run Keyword And Expect Error  *  Можливість завантажити документ в пропозицію користувачем ${provider}

Неможливість змінити існуючу документацію пропозиції першим учасником після закінчення прийому пропозицій
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      second_bid
  Run Keyword And Expect Error  *  Можливість змінити документацію цінової пропозиції користувачем ${provider}


Неможливість задати запитання на тендер після закінчення періоду уточнень
  [Tags]   ${USERS.users['${provider}'].broker}: Задання запитання
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      question_to_tender
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  Run Keyword And Expect Error  *  Можливість задати запитання на тендер користувачем ${provider}

Неможливість задати запитання на перший предмет після закінчення періоду уточнень
  [Tags]   ${USERS.users['${provider}'].broker}: Задання запитання
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      question_to_item
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  Run Keyword And Expect Error  *  Можливість задати запитання на 0 предмет користувачем ${provider}

Неможливість задати запитання на перший лот після закінчення періоду уточнень
  [Tags]   ${USERS.users['${provider}'].broker}: Задання запитання
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      lots  question_to_lot
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  Run Keyword And Expect Error  *  Можливість задати запитання на 0 лот користувачем ${provider}


Неможливість змінити цінову пропозицію до 50000 другим учасником після закінчення прийому пропозицій
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      second_bid
  [Setup]  Дочекатись дати закінчення прийому пропозицій  ${provider1}
  Run Keyword And Expect Error  *  Можливість змінити пропозицію до 50000 користувачем ${provider1}


Неможливість змінити цінову пропозицію до 1 другим учасником після закінчення прийому пропозицій
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      second_bid
  Run Keyword And Expect Error  *  Можливість змінити пропозицію до 1 користувачем ${provider1}

Неможливість скасувати пропозицію другим учасником після закінчення прийому пропозицій
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      second_bid
  Run Keyword And Expect Error  *  Можливість скасувати цінову пропозицію користувачем ${provider1}
