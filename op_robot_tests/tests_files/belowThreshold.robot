*** Settings ***
Resource        belowThreshold_keywords.robot
Suite Setup     Test Suite Setup
Suite Teardown  Test Suite Teardown


*** Variables ***
${mode}         without_lots
@{used_roles}   tender_owner  provider  provider1  viewer


*** Test Cases ***
Можливість оголосити тендер
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість оголосити тендер


Можливість знайти тендер по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Можливість знайти тендер
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  Можливість знайти тендер по ідентифікатору


Можливість додати тендерну документацію
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість додати документацію
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість додати тендерну документацію


Можливість додати документацію до лоту
  [Tags]    ${USERS.users['${tender_owner}'].broker}: Можливість додати документацію
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      lots
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість додати документацію до лоту


Можливість добавити предмет закупівлі
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Run Keyword IF  '${mode}'=='without_lots'  Можливість добавити предмет закупівлі в тендер
  Run Keyword IF  '${mode}'=='with_lots'  Можливість добавити предмет закупівлі в лот


Можливість видалити предмет закупівлі
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Run Keyword IF  '${mode}'=='without_lots'  Можливість видалити предмет закупівлі з тендера
  Run Keyword IF  '${mode}'=='with_lots'  Можливість видалити предмет закупівлі з лоту


Можливість створення лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      lots
  [Setup]  Дочекатись синхронізації з майданчиком    ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість створення лоту


Можливість видалення лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      lots
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість видалення лоту


Відображення заголовку першого лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      lots
  Відображення title першого лоту для усіх користувачів


Відображення бюджету першого лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      lots
  Відображення value.amount першого лоту


Можливість змінити бюджет першого лоту до 100
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      lots
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість змінити value.amount першого лоту до 100


Можливість змінити бюджет першого лоту до 8000
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      lots
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість змінити value.amount першого лоту до 8000

##############################################################################################
#             QUESTIONS
##############################################################################################

Можливість задати питання на тендер
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість задати запитання
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість задати питання на тендер  ${provider}


Можливість відповісти на запитання на тендер
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість відповісти на запитання
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість відповісти на запитання


Можливість задати питання на предмет
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість задати запитання
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість задати питання на предмет  ${provider}


Можливість відповісти на запитання на предмет
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість відповісти на запитання
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість відповісти на запитання


Можливість задати питання на лот
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість задати запитання
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      lots
  [Setup]  Дочекатись синхронізації з майданчиком    ${provider}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість задати питання на лот  ${provider}


Можливість відповісти на запитання до лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість відповісти на запитання
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      lots
  [Setup]  Дочекатись синхронізації з майданчиком    ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість відповісти на запитання

##############################################################################################
#             BIDDING
##############################################################################################

Можливість подати пропозицію першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість подати цінову пропозицію
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  [Setup]  Дочекатись дати початку прийому пропозицій  ${provider}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Run Keyword IF  '${mode}'=='without_lots'  Можливість подати цінову пропозицію на тендер  ${provider}
  Run Keyword IF  '${mode}'=='with_lots'  Можливість подати цінову пропозицію на лоти  ${provider}

Можливість змінити пропозицію до 50000 першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість змінити пропозицію до 50000 першим учасником


Можливість змінити пропозицію до 10 першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість змінити пропозицію до 10 першим учасником


Можливість завантажити документ в пропозицію першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість завантажити документ в пропозицію  ${provider}


Можливість змінити документацію цінової пропозиції першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість змінити документацію цінової пропозиції  ${provider}


Можливість скасувати пропозицію
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість скасувати цінову пропозицію
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість скасувати цінову пропозицію  ${provider}

Можливість подати пропозицію другим учасником
  [Tags]   ${USERS.users['${provider1}'].broker}: Можливість подати цінову пропозицію
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  [Setup]  Дочекатись дати початку прийому пропозицій  ${provider1}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Run Keyword IF  '${mode}'=='without_lots'  Можливість подати цінову пропозицію на тендер  ${provider1}
  Run Keyword IF  '${mode}'=='with_lots'  Можливість подати цінову пропозицію на лоти  ${provider1}
