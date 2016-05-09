*** Settings ***
Resource        base_keywords.robot
Suite Setup     Test Suite Setup
Suite Teardown  Test Suite Teardown

*** Variables ***
${mode}         belowThreshold
@{used_roles}   tender_owner  provider  provider1  viewer

${number_of_items}  ${1}
${number_of_lots}   ${1}
${meat}             ${1}

*** Test Cases ***
Можливість оголосити однопредметний тендер
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість оголосити тендер


Можливість знайти однопредметний тендер по ідентифікатору
  [Tags]  ${USERS.users['${viewer}'].broker}: Пошук тендера по ідентифікатору
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Можливість знайти тендер по ідентифікатору для усіх учасників


Можливість створити вимогу про виправлення умов закупівлі, додати до неї документацію і подати її користувачем
  [Tags]  ${USERS.users['${provider}'].broker}: Можливість створити вимогу про виправлення умов закупівлі, додати до неї документацію і подати її
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість створити вимогу із документацією

##############################################################################################
#             ВІДОБРАЖЕННЯ ДЛЯ ГЛЯДАЧА
##############################################################################################

Відображення опису вимоги
  [Tags]  ${USERS.users['${viewer}'].broker}: опису Відображення вимоги
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля description вимоги із ${USERS.users['${provider}'].claim_data.claim.data.description} для користувача ${viewer}


Відображення заголовку вимоги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення заголовку вимоги
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити відображення поля title вимоги із ${USERS.users['${provider}'].claim_data.claim.data.title} для користувача ${viewer}



Відображення заголовку документації вимоги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення заголовку документації
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити відображення поля document.title вимоги із ${USERS.users['${provider}'].claim_data.document} для користувача ${viewer}


Відображення поданого статусу вимоги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення поданого статусу вимоги
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити відображення поля status вимоги із claim для користувача ${viewer}


Можливість відповісти на вимогу про виправлення умов закупівлі
  [Tags]  ${USERS.users['${tender_owner}'].broker}:Можливість відповісти на вирішену вимогу про виправлення умов закупівлі
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість відповісти на вимогу


Відображення статусу 'answered' вимоги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення статусу 'answered' вимоги
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status вимоги із answered для користувача ${viewer}


Відображення типу вирішення вимоги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення типу вирішення вимоги
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити відображення поля resolutionType вимоги із ${USERS.users['${tender_owner}'].claim_data.claim_answer.data.resolutionType} для користувача ${viewer}


Відображення вирішення вимоги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення вирішення вимоги
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити відображення поля resolution вимоги із ${USERS.users['${tender_owner}'].claim_data.claim_answer.data.resolution} для користувача ${viewer}


Можливість підтвердити задоволення вимоги про виправлення умов закупівлі
  [Tags]  ${USERS.users['${provider}'].broker}:Можливість підтвердити задоволення вимоги про виправлення умов закупівлі
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість підтвердити задоволення вимоги про виправлення умов закупівлі

Відображення статусу 'resolved' вимоги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення статусу 'resolved' вимоги
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status вимоги із resolved для користувача ${viewer}


Відображення задоволення вимоги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення задоволення вимоги
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити відображення поля satisfied вимоги із ${USERS.users['${provider}'].claim_data.claim_answer_confirm.data.satisfied} для користувача ${viewer}


Можливість створити чернетку вимоги про виправлення умов закупівлі і скасувати її
  [Tags]  ${USERS.users['${provider}'].broker}: Можливість створити чернетку вимоги про виправлення умов закупівлі і скасувати її
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість створити чернетку вимоги
  Можливість скасувати вимогу

##############################################################################################
#             ВІДОБРАЖЕННЯ ДЛЯ ГЛЯДАЧА
##############################################################################################

Відображення статусу 'cancelled' чернетки вимоги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення статусу 'cancelled' чернетки вимоги
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status вимоги із cancelled для користувача ${viewer}


Відображення причини скасування чернетки вимоги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення причини скасування чернетки вимоги
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити відображення поля cancellationReason вимоги із ${USERS.users['${provider}'].claim_data.cancellation.data.cancellationReason} для користувача ${viewer}


Можливість створити, подати і скасувати вимогу про виправлення умов закупівлі
  [Tags]  ${USERS.users['${provider}'].broker}: Можливість створити, подати і скасувати вимогу про виправлення умов закупівлі
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість створити вимогу із документацією
  Можливість скасувати вимогу


Відображення статусу 'cancelled' після 'draft -> claim' вимоги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення статусу 'cancelled' вимоги
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status вимоги із cancelled для користувача ${viewer}


Можливість створити, подати, відповісти і після того скасувати вимогу про виправлення умов закупівлі
  [Tags]  ${USERS.users['${provider}'].broker}: Можливість створити, подати, відповісти і після того скасувати вимогу про виправлення умов закупівлі
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість створити вимогу із документацією
  Можливість відповісти на вимогу
  Можливість скасувати вимогу


Відображення статусу 'cancelled' після 'draft -> claim -> answered' вимоги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення статусу 'cancelled' після 'draft -> claim -> answered' вимоги
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status вимоги із cancelled для користувача ${viewer}


Можливість створити, подати, відповісти на вимогу і перетворити її в скаргу
  [Tags]  ${USERS.users['${provider}'].broker}: Можливість створити, подати, відповісти і після того скасувати вимогу про виправлення умов закупівлі
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість створити вимогу із документацією
  Можливість відповісти на вимогу
  Можливість перетворити вимогу в скаргу

##############################################################################################
#             ВІДОБРАЖЕННЯ ДЛЯ ГЛЯДАЧА
##############################################################################################

Відображення статусу 'pending' після 'draft -> claim -> answered' вимоги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення статусу 'cancelled' після 'draft -> claim -> answered' вимоги
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status вимоги із pending для користувача ${viewer}


Відображення незадоволення вимоги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення незадоволення вимоги
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити відображення поля satisfied вимоги із ${USERS.users['${provider}'].claim_data.escalation.data.satisfied} для користувача ${viewer}


Можливість скасувати скаргу
  [Tags]  ${USERS.users['${provider}'].broker}: Можливість скасувати скаргу
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість скасувати вимогу


Відображення статусу 'cancelled' скарги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення статусу 'cancelled' скарги
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status вимоги із cancelled для користувача ${viewer}


Відображення причини скасування скарги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення причини скасування скарги
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити відображення поля cancellationReason вимоги із ${USERS.users['${provider}'].claim_data.cancellation.data.cancellationReason} для користувача ${viewer}
