*** Settings ***
Resource        belowThreshold_keywords.robot
Suite Setup     Test Suite Setup
Suite Teardown  Test Suite Teardown


*** Variables ***
${mode}         with_lots
@{used_roles}   tender_owner  provider  provider1  viewer


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


Відображення заголовку першого лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      lots
  Відображення title 0 лоту для усіх користувачів


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
  ...      lots add_documentation_to_lot
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість додати документацію до 0 лоту


Можливість додати предмет закупівлі
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_item
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Run Keyword IF  '${mode}'=='without_lots'  Можливість додати предмет закупівлі в тендер
  ...         ELSE IF  '${mode}'=='with_lots'  Можливість додати предмет закупівлі в 0 лот


Можливість видалити предмет закупівлі
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      delete_item
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Run Keyword IF  '${mode}'=='without_lots'  Можливість видалити предмет закупівлі з тендера
  ...         ELSE IF  '${mode}'=='with_lots'  Можливість видалити предмет закупівлі з 0 лоту


Можливість створення лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      lots  second_lot
  [Setup]  Дочекатись синхронізації з майданчиком    ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість створення лоту


Відображення заголовку другого лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      lots  second_lot  second_lot_view
  Відображення title новоствореного лоту для усіх користувачів


Можливість видалення лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      lots  second_lot  delete_second_lot
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість видалення 1 лоту


Відображення бюджету першого лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      lots
  Відображення value.amount 0 лоту для користувача ${viewer}


Можливість змінити бюджет першого лоту до 100
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      lots
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість змінити value.amount 0 лоту до 100


Можливість змінити бюджет першого лоту до 8000
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      lots
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість змінити value.amount 0 лоту до 8000


Відображення початку періоду уточнення тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Відображення дати enquiryPeriod.startDate тендера для користувача ${viewer}


Відображення закінчення періоду уточнення тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Відображення дати enquiryPeriod.endDate тендера для користувача ${viewer}

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


Можливість відповісти на запитання на тендер
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Відповідь на запитання
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      answer_question_to_tender
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість відповісти на запитання


Можливість задати запитання на перший предмет
  [Tags]   ${USERS.users['${provider}'].broker}: Задання запитання
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      question_to_item
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість задати запитання на 0 предмет користувачем ${provider}


Можливість відповісти на запитання на перший предмет
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Відповідь на запитання
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      answer_question_to_item
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість відповісти на запитання


Можливість задати запитання на перший лот
  [Tags]   ${USERS.users['${provider}'].broker}: Задання запитання
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      lots
  ...      question_to_lot
  [Setup]  Дочекатись синхронізації з майданчиком    ${provider}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість задати запитання на 0 лот користувачем ${provider}


Можливість відповісти на запитання на перший лот
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Відповідь на запитання
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      lots
  ...      answer_question_to_item
  [Setup]  Дочекатись синхронізації з майданчиком    ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість відповісти на запитання

##############################################################################################
#             BIDDING
##############################################################################################

Можливість подати пропозицію першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  [Setup]  Дочекатись дати початку прийому пропозицій  ${provider}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Run Keyword IF  '${mode}'=='without_lots'  Можливість подати цінову пропозицію на тендер користувачем ${provider}
  ...         ELSE IF  '${mode}'=='with_lots'  Можливість подати цінову пропозицію на лоти користувачем ${provider}

Можливість змінити пропозицію до 50000 першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість змінити пропозицію до 50000 користувачем ${provider}


Можливість змінити пропозицію до 10 першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість змінити пропозицію до 10 користувачем ${provider}


Можливість завантажити документ в пропозицію першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість завантажити документ в пропозицію користувачем ${provider}


Можливість змінити документацію цінової пропозиції першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      add_documentation_to_bid
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість змінити документацію цінової пропозиції користувачем ${provider}


Можливість скасувати пропозицію
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      bid_canceled
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість скасувати цінову пропозицію користувачем ${provider}


Можливість подати пропозицію другим учасником
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  [Setup]  Дочекатись дати початку прийому пропозицій  ${provider1}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Run Keyword IF  '${mode}'=='without_lots'  Можливість подати цінову пропозицію на тендер користувачем ${provider1}
  ...         ELSE IF  '${mode}'=='with_lots'  Можливість подати цінову пропозицію на лоти користувачем ${provider1}
