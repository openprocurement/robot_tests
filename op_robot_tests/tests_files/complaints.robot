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
${lot_index}        ${0}

*** Test Cases ***
Можливість оголосити однопредметний тендер
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Оголошення тендера
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  lot_complaint
  ...  tender_complaint
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${lot_index}=  Convert To Integer  ${lot_index}
  Можливість оголосити тендер


Можливість знайти однопредметний тендер по ідентифікатору
  [Tags]  ${USERS.users['${viewer}'].broker}: Пошук тендера
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  lot_complaint
  ...  tender_complaint
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Можливість знайти тендер по ідентифікатору для усіх учасників


Можливість створити вимогу про виправлення умов закупівлі, додати до неї документацію і подати її користувачем
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  tender_complaint
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість створити вимогу про виправлення умов закупівлі із документацією


Можливість створити вимогу про виправлення умов лоту, додати до неї документацію і подати її користувачем
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  lot_complaint
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість створити вимогу про виправлення умов ${lot_index} лоту із документацією

##############################################################################################
#             ВІДОБРАЖЕННЯ ДЛЯ ГЛЯДАЧА
##############################################################################################

Відображення опису вимоги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  lot_complaint
  ...  tender_complaint
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля description вимоги із ${USERS.users['${provider}'].claim_data.claim.data.description} для користувача ${viewer}


Відображення заголовку вимоги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  lot_complaint
  ...  tender_complaint
  Звірити відображення поля title вимоги із ${USERS.users['${provider}'].claim_data.claim.data.title} для користувача ${viewer}



Відображення заголовку документації вимоги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  lot_complaint
  ...  tender_complaint
  Звірити відображення поля document.title вимоги із ${USERS.users['${provider}'].claim_data.document} для користувача ${viewer}


Відображення стосунку вимоги до лоту
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  lot_complaint
  Звірити відображення поля relatedLot вимоги із ${USERS.users['${provider}'].claim_data.claim.data.relatedLot} для користувача ${viewer}


Відображення поданого статусу вимоги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  lot_complaint
  ...  tender_complaint
  Звірити відображення поля status вимоги із claim для користувача ${viewer}


Можливість відповісти на вимогу про виправлення умов закупівлі
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес оскарження
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  tender_complaint
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість відповісти на вимогу про виправлення умов закупівлі


Можливість відповісти на вимогу про виправлення умов лоту
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес оскарження
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  lot_complaint
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість відповісти на вимогу про виправлення умов лоту


Відображення статусу 'answered' вимоги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  lot_complaint
  ...  tender_complaint
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status вимоги із answered для користувача ${viewer}


Відображення типу вирішення вимоги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  lot_complaint
  ...  tender_complaint
  Звірити відображення поля resolutionType вимоги із ${USERS.users['${tender_owner}'].claim_data.claim_answer.data.resolutionType} для користувача ${viewer}


Відображення вирішення вимоги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  lot_complaint
  ...  tender_complaint
  Звірити відображення поля resolution вимоги із ${USERS.users['${tender_owner}'].claim_data.claim_answer.data.resolution} для користувача ${viewer}


Можливість підтвердити задоволення вимоги про виправлення умов закупівлі
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  tender_complaint
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість підтвердити задоволення вимоги про виправлення умов закупівлі


Можливість підтвердити задоволення вимоги про виправлення умов лоту
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  lot_complaint
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість підтвердити задоволення вимоги про виправлення умов лоту


Відображення статусу 'resolved' вимоги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  lot_complaint
  ...  tender_complaint
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status вимоги із resolved для користувача ${viewer}


Відображення задоволення вимоги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  lot_complaint
  ...  tender_complaint
  Звірити відображення поля satisfied вимоги із ${USERS.users['${provider}'].claim_data.claim_answer_confirm.data.satisfied} для користувача ${viewer}


Можливість створити чернетку вимоги про виправлення умов закупівлі і скасувати її
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  tender_complaint
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість створити чернетку вимоги про виправлення умов закупівлі
  Можливість скасувати вимогу про виправлення умов закупівлі


Можливість створити чернетку вимоги про виправлення умов закупівлі і скасувати її
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  lot_complaint
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість створити чернетку вимоги про виправлення умов ${lot_index} лоту
  Можливість скасувати вимогу про виправлення умов лоту

##############################################################################################
#             ВІДОБРАЖЕННЯ ДЛЯ ГЛЯДАЧА
##############################################################################################

Відображення статусу 'cancelled' чернетки вимоги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  lot_complaint
  ...  tender_complaint
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status вимоги із cancelled для користувача ${viewer}


Відображення причини скасування чернетки вимоги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  lot_complaint
  ...  tender_complaint
  Звірити відображення поля cancellationReason вимоги із ${USERS.users['${provider}'].claim_data.cancellation.data.cancellationReason} для користувача ${viewer}


Можливість створити, подати і скасувати вимогу про виправлення умов закупівлі
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  tender_complaint
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість створити вимогу про виправлення умов закупівлі із документацією
  Можливість скасувати вимогу про виправлення умов закупівлі


Можливість створити, подати і скасувати вимогу про виправлення умов лоту
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  lot_complaint
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість створити вимогу про виправлення умов ${lot_index} лоту із документацією
  Можливість скасувати вимогу про виправлення умов лоту


Відображення статусу 'cancelled' після 'draft -> claim' вимоги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  lot_complaint
  ...  tender_complaint
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status вимоги із cancelled для користувача ${viewer}


Можливість створити, подати, відповісти і після того скасувати вимогу про виправлення умов закупівлі
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  tender_complaint
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість створити вимогу про виправлення умов закупівлі із документацією
  Можливість відповісти на вимогу про виправлення умов закупівлі
  Можливість скасувати вимогу про виправлення умов закупівлі


Можливість створити, подати, відповісти і після того скасувати вимогу про виправлення умов лоту
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  lot_complaint
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість створити вимогу про виправлення умов ${lot_index} лоту із документацією
  Можливість відповісти на вимогу про виправлення умов лоту
  Можливість скасувати вимогу про виправлення умов лоту


Відображення статусу 'cancelled' після 'draft -> claim -> answered' вимоги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  lot_complaint
  ...  tender_complaint
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status вимоги із cancelled для користувача ${viewer}


Можливість створити, подати, відповісти на вимогу про виправлення умов закупівлі і перетворити її в скаргу
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  tender_complaint
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість створити вимогу про виправлення умов закупівлі із документацією
  Можливість відповісти на вимогу про виправлення умов закупівлі
  Можливість перетворити вимогу про виправлення умов закупівлі в скаргу


Можливість створити, подати, відповісти на вимогу про виправлення умов лоту і перетворити її в скаргу
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  lot_complaint
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість створити вимогу про виправлення умов ${lot_index} лоту із документацією
  Можливість відповісти на вимогу про виправлення умов лоту
  Можливість перетворити вимогу про виправлення умов лоту в скаргу

##############################################################################################
#             ВІДОБРАЖЕННЯ ДЛЯ ГЛЯДАЧА
##############################################################################################

Відображення статусу 'pending' після 'draft -> claim -> answered' вимоги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  lot_complaint
  ...  tender_complaint
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status вимоги із pending для користувача ${viewer}


Відображення незадоволення вимоги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  lot_complaint
  ...  tender_complaint
  Звірити відображення поля satisfied вимоги із ${USERS.users['${provider}'].claim_data.escalation.data.satisfied} для користувача ${viewer}


Можливість скасувати скаргу про виправлення умов закупівлі
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  tender_complaint
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість скасувати вимогу про виправлення умов закупівлі


Можливість скасувати скаргу про виправлення умов лоту
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  lot_complaint
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість скасувати вимогу про виправлення умов лоту


Відображення статусу 'cancelled' скарги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  lot_complaint
  ...  tender_complaint
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status вимоги із cancelled для користувача ${viewer}


Відображення причини скасування скарги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  lot_complaint
  ...  tender_complaint
  Звірити відображення поля cancellationReason вимоги із ${USERS.users['${provider}'].claim_data.cancellation.data.cancellationReason} для користувача ${viewer}
