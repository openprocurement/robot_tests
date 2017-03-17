*** Settings ***
Resource        base_keywords.robot
Suite Setup     Test Suite Setup
Suite Teardown  Test Suite Teardown

*** Variables ***
${MODE}         belowThreshold
@{USED_ROLES}   tender_owner  provider  provider1  viewer

${NUMBER_OF_ITEMS}  ${1}
${NUMBER_OF_LOTS}   ${1}
${TENDER_MEAT}      ${1}
${ITEM_MEAT}        ${1}
${LOT_MEAT}         ${1}
${lot_index}        ${0}
${award_index}      ${0}

*** Test Cases ***

##############################################################################################
#             CREATE AND FIND TENDER
##############################################################################################

Можливість оголосити однопредметний тендер
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Оголошення тендера
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  lot_complaint
  ...  tender_complaint
  ...  critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість оголосити тендер


Можливість знайти однопредметний тендер по ідентифікатору
  [Tags]  ${USERS.users['${viewer}'].broker}: Пошук тендера
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  lot_complaint
  ...  tender_complaint
  ...  critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Можливість знайти тендер по ідентифікатору для усіх користувачів

##############################################################################################
#             CREATE, ANSWER AND CONFIRM CLAIM
##############################################################################################

Можливість створити вимогу про виправлення умов закупівлі, додати до неї документацію і подати її користувачем
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  tender_complaint
  ...  critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість створити вимогу про виправлення умов закупівлі із документацією


Відображення опису вимоги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_complaint
  ...  non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля description вимоги із ${USERS.users['${provider}'].tender_claim_data.claim.data.description} для користувача ${viewer}


Відображення заголовку вимоги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_complaint
  ...  non-critical
  Звірити відображення поля title вимоги із ${USERS.users['${provider}'].tender_claim_data.claim.data.title} для користувача ${viewer}


Відображення заголовку документації вимоги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_complaint
  ...  non-critical
  Звірити відображення поля title документа ${USERS.users['${provider}'].tender_claim_data.doc_id} до скарги ${USERS.users['${provider}'].tender_claim_data.complaintID} з ${USERS.users['${provider}'].tender_claim_data.doc_name} для користувача ${viewer}


Відображення поданого статусу вимоги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_complaint
  ...  non-critical
  Звірити відображення поля status вимоги із claim для користувача ${viewer}


Можливість відповісти на вимогу про виправлення умов закупівлі
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес оскарження
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  tender_complaint
  ...  critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість відповісти на вимогу про виправлення умов закупівлі


Відображення статусу 'answered' вимоги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_complaint
  ...  non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status вимоги із answered для користувача ${viewer}


Відображення типу вирішення вимоги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_complaint
  ...  non-critical
  Звірити відображення поля resolutionType вимоги із ${USERS.users['${tender_owner}'].tender_claim_data.claim_answer.data.resolutionType} для користувача ${viewer}


Відображення вирішення вимоги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_complaint
  ...  non-critical
  Звірити відображення поля resolution вимоги із ${USERS.users['${tender_owner}'].tender_claim_data.claim_answer.data.resolution} для користувача ${viewer}


Можливість підтвердити задоволення вимоги про виправлення умов закупівлі
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  tender_complaint
  ...  critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість підтвердити задоволення вимоги про виправлення умов закупівлі


Відображення статусу 'resolved' вимоги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_complaint
  ...  non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status вимоги із resolved для користувача ${viewer}


Відображення задоволення вимоги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_complaint
  ...  non-critical
  Звірити відображення поля satisfied вимоги із ${USERS.users['${provider}'].tender_claim_data.claim_answer_confirm.data.satisfied} для користувача ${viewer}


Можливість створити вимогу про виправлення умов лоту, додати до неї документацію і подати її користувачем
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  lot_complaint
  ...  critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${lot_index}=  Convert To Integer  ${lot_index}
  Можливість створити вимогу про виправлення умов ${lot_index} лоту із документацією


Відображення стосунку вимоги до лоту
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  lot_complaint
  ...  non-critical
  Звірити відображення поля relatedLot вимоги про виправлення умов ${lot_index} лоту із ${USERS.users['${provider}'].lot_claim_data.claim.data.relatedLot} для користувача ${viewer}


Можливість відповісти на вимогу про виправлення умов лоту
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес оскарження
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  lot_complaint
  ...  critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість відповісти на вимогу про виправлення умов лоту


Можливість підтвердити задоволення вимоги про виправлення умов лоту
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  lot_complaint
  ...  critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість підтвердити задоволення вимоги про виправлення умов лоту

##############################################################################################
#             CREATE AND CANCEL CLAIM
##############################################################################################

Можливість створити чернетку вимоги про виправлення умов закупівлі і скасувати її
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  tender_complaint
  ...  critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість створити чернетку вимоги про виправлення умов закупівлі
  Можливість скасувати вимогу про виправлення умов закупівлі


Відображення статусу 'cancelled' чернетки вимоги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_complaint
  ...  non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status вимоги із cancelled для користувача ${viewer}


Відображення причини скасування чернетки вимоги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_complaint
  ...  non-critical
  Звірити відображення поля cancellationReason вимоги із ${USERS.users['${provider}'].tender_claim_data.cancellation.data.cancellationReason} для користувача ${viewer}


Можливість створити чернетку вимоги про виправлення умов лоту і скасувати її
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  lot_complaint
  ...  critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість створити чернетку вимоги про виправлення умов ${lot_index} лоту
  Можливість скасувати вимогу про виправлення умов лоту

##############################################################################################
#             CREATE, SUBMIT AND CANCEL CLAIM
##############################################################################################

Можливість створити, подати і скасувати вимогу про виправлення умов закупівлі
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  tender_complaint
  ...  critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість створити вимогу про виправлення умов закупівлі із документацією
  Можливість скасувати вимогу про виправлення умов закупівлі


Відображення статусу 'cancelled' після 'draft -> claim' вимоги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_complaint
  ...  non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status вимоги із cancelled для користувача ${viewer}


Можливість створити, подати і скасувати вимогу про виправлення умов лоту
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  lot_complaint
  ...  critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість створити вимогу про виправлення умов ${lot_index} лоту із документацією
  Можливість скасувати вимогу про виправлення умов лоту

##############################################################################################
#             CREATE, SUBMIT, ANSWER AND CANCEL CLAIM
##############################################################################################

Можливість створити, подати, відповісти і після того скасувати вимогу про виправлення умов закупівлі
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  tender_complaint
  ...  critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість створити вимогу про виправлення умов закупівлі із документацією
  Можливість відповісти на вимогу про виправлення умов закупівлі
  Можливість скасувати вимогу про виправлення умов закупівлі


Відображення статусу 'cancelled' після 'draft -> claim -> answered' вимоги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_complaint
  ...  non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status вимоги із cancelled для користувача ${viewer}


Можливість створити, подати, відповісти і після того скасувати вимогу про виправлення умов лоту
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  lot_complaint
  ...  critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість створити вимогу про виправлення умов ${lot_index} лоту із документацією
  Можливість відповісти на вимогу про виправлення умов лоту
  Можливість скасувати вимогу про виправлення умов лоту

##############################################################################################
#             CREATE, SUBMIT, ANSWER, ESCALATE AND CANCEL CLAIM
##############################################################################################

Можливість створити, подати, відповісти на вимогу про виправлення умов закупівлі і перетворити її в скаргу
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  tender_complaint
  ...  critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість створити вимогу про виправлення умов закупівлі із документацією
  Можливість відповісти на вимогу про виправлення умов закупівлі
  Можливість перетворити вимогу про виправлення умов закупівлі в скаргу


Відображення статусу 'pending' після 'draft -> claim -> answered' вимоги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_complaint
  ...  non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status вимоги із pending для користувача ${viewer}


Відображення незадоволення вимоги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_complaint
  ...  non-critical
  Звірити відображення поля satisfied вимоги із ${USERS.users['${provider}'].tender_claim_data.escalation.data.satisfied} для користувача ${viewer}


Можливість скасувати скаргу про виправлення умов закупівлі
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  tender_complaint
  ...  critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість скасувати вимогу про виправлення умов закупівлі


Відображення статусу 'cancelled' скарги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_complaint
  ...  non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status вимоги із cancelled для користувача ${viewer}


Відображення причини скасування скарги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_complaint
  ...  non-critical
  Звірити відображення поля cancellationReason вимоги із ${USERS.users['${provider}'].tender_claim_data.cancellation.data.cancellationReason} для користувача ${viewer}


Можливість створити, подати, відповісти на вимогу про виправлення умов лоту і перетворити її в скаргу
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  lot_complaint
  ...  critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість створити вимогу про виправлення умов ${lot_index} лоту із документацією
  Можливість відповісти на вимогу про виправлення умов лоту
  Можливість перетворити вимогу про виправлення умов лоту в скаргу


Можливість скасувати скаргу про виправлення умов лоту
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  lot_complaint
  ...  critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість скасувати вимогу про виправлення умов лоту

##############################################################################################
#             AWARD COMPLAINTS
##############################################################################################

Можливість подати пропозицію першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      make_bid_by_provider  level1
  ...      critical
  [Setup]  Дочекатись дати початку прийому пропозицій  ${provider}  ${TENDER['TENDER_UAID']}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати цінову пропозицію користувачем ${provider}


Можливість подати пропозицію другим учасником
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      make_bid_by_provider1  level1
  ...      critical
  [Setup]  Дочекатись дати початку прийому пропозицій  ${provider1}  ${TENDER['TENDER_UAID']}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати цінову пропозицію користувачем ${provider1}
  Дочекатись дати закінчення прийому пропозицій  ${provider1}  ${TENDER['TENDER_UAID']}
  Дочекатись дати початку періоду кваліфікації  ${provider1}  ${TENDER['TENDER_UAID']}


Можливість створити вимогу про виправлення визначення переможця, додати до неї документацію і подати її користувачем
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  award_complaint
  ...  critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${award_index}=  Convert To Integer  ${award_index}
  Можливість створити вимогу про виправлення визначення ${award_index} переможця із документацією


Відображення опису вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  award_complaint
  ...  non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля description вимоги про виправлення визначення ${award_index} переможця із ${USERS.users['${provider}'].claim_data.claim.data.description} для користувача ${viewer}


Відображення заголовку вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  award_complaint
  ...  non-critical
  Звірити відображення поля title вимоги про виправлення визначення ${award_index} переможця із ${USERS.users['${provider}'].claim_data.claim.data.title} для користувача ${viewer}


Відображення заголовку документації вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  award_complaint
  ...  non-critical
  Звірити відображення поля title документа ${USERS.users['${provider}'].claim_data.doc_id} до скарги ${USERS.users['${provider}'].claim_data.complaintID} з ${USERS.users['${provider}'].claim_data.doc_name} для користувача ${viewer}


Відображення поданого статусу вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  award_complaint
  ...  non-critical
  Звірити відображення поля status вимоги про виправлення визначення ${award_index} переможця із claim для користувача ${viewer}


Можливість відповісти на вимогу про виправлення визначення переможця
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес оскарження
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  award_complaint
  ...  critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість відповісти на вимогу про виправлення визначення ${award_index} переможця


Відображення статусу 'answered' вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  award_complaint
  ...  non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status вимоги про виправлення визначення ${award_index} переможця із answered для користувача ${viewer}


Відображення типу вирішення вимоги вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  award_complaint
  ...  non-critical
  Звірити відображення поля resolutionType вимоги про виправлення визначення ${award_index} переможця із ${USERS.users['${tender_owner}'].claim_data.claim_answer.data.resolutionType} для користувача ${viewer}


Відображення вирішення вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  award_complaint
  ...  non-critical
  Звірити відображення поля resolution вимоги про виправлення визначення ${award_index} переможця із ${USERS.users['${tender_owner}'].claim_data.claim_answer.data.resolution} для користувача ${viewer}


Можливість підтвердити задоволення вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  award_complaint
  ...  critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість підтвердити задоволення вимоги про виправлення визначення ${award_index} переможця


Відображення статусу 'resolved' вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  award_complaint
  ...  non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status вимоги про виправлення визначення ${award_index} переможця із resolved для користувача ${viewer}


Відображення задоволення вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  award_complaint
  ...  non-critical
  Звірити відображення поля satisfied вимоги про виправлення визначення ${award_index} переможця із ${USERS.users['${provider}'].claim_data.claim_answer_confirm.data.satisfied} для користувача ${viewer}


Можливість створити чернетку вимоги про виправлення визначення переможця і скасувати її
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  award_complaint
  ...  critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість створити чернетку вимоги про виправлення визначення ${award_index} переможця
  Можливість скасувати вимогу про виправлення визначення ${award_index} переможця


Відображення статусу 'cancelled' чернетки вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  award_complaint
  ...  non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status вимоги про виправлення визначення ${award_index} переможця із cancelled для користувача ${viewer}


Відображення причини скасування чернетки вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  award_complaint
  ...  non-critical
  Звірити відображення поля cancellationReason вимоги про виправлення визначення ${award_index} переможця із ${USERS.users['${provider}'].claim_data.cancellation.data.cancellationReason} для користувача ${viewer}


Можливість створити, подати і скасувати вимогу про виправлення визначення переможця
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  award_complaint
  ...  critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість створити вимогу про виправлення визначення ${award_index} переможця із документацією
  Можливість скасувати вимогу про виправлення визначення ${award_index} переможця


Відображення статусу 'cancelled' після 'draft -> claim' вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  award_complaint
  ...  non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status вимоги про виправлення визначення ${award_index} переможця із cancelled для користувача ${viewer}


Можливість створити, подати, відповісти і після того скасувати вимогу про виправлення визначення переможця
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  award_complaint
  ...  critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість створити вимогу про виправлення визначення ${award_index} переможця із документацією
  Можливість відповісти на вимогу про виправлення визначення ${award_index} переможця
  Можливість скасувати вимогу про виправлення визначення ${award_index} переможця


Відображення статусу 'cancelled' після 'draft -> claim -> answered' вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  award_complaint
  ...  non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status вимоги про виправлення визначення ${award_index} переможця із cancelled для користувача ${viewer}


Можливість створити, подати, відповісти на вимогу про виправлення визначення переможця і перетворити її в скаргу
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  award_complaint
  ...  critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість створити вимогу про виправлення визначення ${award_index} переможця із документацією
  Можливість відповісти на вимогу про виправлення визначення ${award_index} переможця
  Можливість перетворити вимогу про виправлення визначення ${award_index} переможця в скаргу


Відображення статусу 'pending' після 'draft -> claim -> answered' вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  award_complaint
  ...  non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status вимоги про виправлення визначення ${award_index} переможця із pending для користувача ${viewer}


Відображення незадоволення вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  award_complaint
  ...  non-critical
  Звірити відображення поля satisfied вимоги про виправлення визначення ${award_index} переможця із ${USERS.users['${provider}'].claim_data.escalation.data.satisfied} для користувача ${viewer}


Можливість скасувати скаргу про виправлення визначення переможця
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  award_complaint
  ...  critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість скасувати вимогу про виправлення визначення ${award_index} переможця


Відображення статусу 'cancelled' скарги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  award_complaint
  ...  non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status вимоги про виправлення визначення ${award_index} переможця із cancelled для користувача ${viewer}


Відображення причини скасування скарги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  award_complaint
  ...  non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля cancellationReason вимоги про виправлення визначення ${award_index} переможця із ${USERS.users['${provider}'].claim_data.cancellation.data.cancellationReason} для користувача ${viewer}
