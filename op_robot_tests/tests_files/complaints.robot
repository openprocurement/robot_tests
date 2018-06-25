*** Settings ***
Resource        base_keywords.robot
Suite Setup     Test Suite Setup
Suite Teardown  Test Suite Teardown

*** Variables ***
${MODE}             belowThreshold
@{USED_ROLES}       tender_owner  provider  provider1  provider2  viewer
${MOZ_INTEGRATION}  ${False}

${NUMBER_OF_ITEMS}  ${1}
${NUMBER_OF_LOTS}   ${1}
${TENDER_MEAT}      ${0}
${ITEM_MEAT}        ${0}
${LOT_MEAT}         ${0}
${lot_index}        ${0}
${award_index}      ${0}

*** Test Cases ***

##############################################################################################
#             CREATE AND FIND TENDER LOT VIEW
##############################################################################################

Можливість оголосити однопредметний тендер
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Оголошення тендера
  ...     tender_owner
  ...     ${USERS.users['${tender_owner}'].broker}
  ...     create_tender
  ...     critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість оголосити тендер


Можливість знайти однопредметний тендер по ідентифікатору
  [Tags]  ${USERS.users['${viewer}'].broker}: Пошук тендера
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     find_tender
  ...     critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Можливість знайти тендер по ідентифікатору для усіх користувачів


Відображення заголовку лотів
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення лоту тендера
  ...     viewer  tender_owner  provider  provider1
  ...     ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...     ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...     tender_view
  ...     critical
  Звірити відображення поля title усіх лотів для усіх користувачів


Можливість подати пропозицію першим учасником
  [Tags]  ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...     provider
  ...     ${USERS.users['${provider}'].broker}
  ...     make_bid_by_provider
  ...     critical
  [Setup]  Дочекатись дати початку прийому пропозицій  ${provider}  ${TENDER['TENDER_UAID']}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати цінову пропозицію користувачем ${provider}


Можливість подати пропозицію другим учасником
  [Tags]  ${USERS.users['${provider1}'].broker}: Подання пропозиції
  ...     provider1
  ...     ${USERS.users['${provider1}'].broker}
  ...     make_bid_by_provider1
  ...     critical
  [Setup]  Дочекатись дати початку прийому пропозицій  ${provider1}  ${TENDER['TENDER_UAID']}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати цінову пропозицію користувачем ${provider1}


##############################################################################################
#             CREATE AND CANCEL CLAIM
##############################################################################################

Можливість створити чернетку вимоги про виправлення умов закупівлі
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...     provider
  ...     ${USERS.users['${provider}'].broker}
  ...     tender_complaint_draft
  ...     critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість створити чернетку вимоги про виправлення умов закупівлі


Відображення статусу 'draft' чернетки вимоги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     tender_complaint_draft
  ...     non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status для вимоги ${USERS.users['${provider}'].tender_claim_data['complaintID']} із draft для користувача ${viewer}


Можливість скасувати чернетку вимоги про виправлення умов закупівлі
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...     provider
  ...     ${USERS.users['${provider}'].broker}
  ...     tender_complaint_draft
  ...     critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість скасувати вимогу про виправлення умов закупівлі


Відображення статусу 'cancelled' чернетки вимоги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     tender_complaint_draft
  ...     non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status для вимоги ${USERS.users['${provider}'].tender_claim_data['complaintID']} із cancelled для користувача ${viewer}


Відображення причини скасування чернетки вимоги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     tender_complaint_draft
  ...     non-critical
  Звірити відображення поля cancellationReason для вимоги ${USERS.users['${provider}'].tender_claim_data['complaintID']} із ${USERS.users['${provider}'].tender_claim_data.cancellation.data.cancellationReason} для користувача ${viewer}


Можливість створити чернетку вимоги про виправлення умов лоту
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...     provider
  ...     ${USERS.users['${provider}'].broker}
  ...     lot_complaint_draft
  ...     critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість створити чернетку вимоги про виправлення умов ${lot_index} лоту


Відображення статусу 'draft' чернетки вимоги про виправлення умов лоту
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     lot_complaint_draft
  ...     non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status вимоги про виправлення умов ${lot_index} лоту із draft для користувача ${viewer}


Можливість скасувати чернетку вимоги про виправлення умов лоту
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...     provider
  ...     ${USERS.users['${provider}'].broker}
  ...     lot_complaint_draft
  ...     critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість скасувати вимогу про виправлення умов лоту


Відображення статусу 'cancelled' чернетки вимоги про виправлення умов лоту
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     lot_complaint_draft
  ...     non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status вимоги про виправлення умов ${lot_index} лоту із cancelled для користувача ${viewer}

##############################################################################################
#             CREATE, SUBMIT AND CANCEL CLAIM
##############################################################################################

Можливість створити, подати і скасувати вимогу про виправлення умов закупівлі
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...     provider
  ...     ${USERS.users['${provider}'].broker}
  ...     tender_complaint
  ...     critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість створити вимогу про виправлення умов закупівлі із документацією
  Можливість скасувати вимогу про виправлення умов закупівлі


Відображення статусу 'cancelled' після 'draft -> claim' вимоги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     tender_complaint
  ...     non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status для вимоги ${USERS.users['${provider}'].tender_claim_data['complaintID']} із cancelled для користувача ${viewer}


Можливість створити, подати і скасувати вимогу про виправлення умов лоту
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...     provider
  ...     ${USERS.users['${provider}'].broker}
  ...     lot_complaint
  ...     critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість створити вимогу про виправлення умов ${lot_index} лоту із документацією
  Можливість скасувати вимогу про виправлення умов лоту

##############################################################################################
#             CREATE, SUBMIT, ANSWER AND CANCEL CLAIM
##############################################################################################

Можливість створити, подати, відповісти і після того скасувати вимогу про виправлення умов закупівлі
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...     provider  tender_owner
  ...     ${USERS.users['${provider}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...     tender_complaint
  ...     critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість створити вимогу про виправлення умов закупівлі із документацією
  Дочекатись синхронізації з майданчиком  ${tender_owner}
  Можливість відповісти resolved на вимогу про виправлення умов tender
  Дочекатись синхронізації з майданчиком  ${provider}
  Можливість скасувати вимогу про виправлення умов закупівлі


Відображення статусу 'cancelled' після 'draft -> claim -> answered' вимоги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     tender_complaint
  ...     non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status для вимоги ${USERS.users['${provider}'].tender_claim_data['complaintID']} із cancelled для користувача ${viewer}


Можливість створити, подати, відповісти і після того скасувати вимогу про виправлення умов лоту
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...     provider
  ...     ${USERS.users['${provider}'].broker}
  ...     lot_complaint
  ...     critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість створити вимогу про виправлення умов ${lot_index} лоту із документацією
  Дочекатись синхронізації з майданчиком  ${tender_owner}
  Можливість відповісти resolved на вимогу про виправлення умов lot
  Можливість скасувати вимогу про виправлення умов лоту

##############################################################################################
#             CREATE, ANSWER AND CONFIRM CLAIM
##############################################################################################

Можливість створити вимогу про виправлення умов закупівлі, додати до неї документацію і подати її користувачем
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...     provider
  ...     ${USERS.users['${provider}'].broker}
  ...     tender_complaint
  ...     critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість створити вимогу про виправлення умов закупівлі із документацією


Відображення опису вимоги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     tender_complaint
  ...     non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля description для вимоги ${USERS.users['${provider}'].tender_claim_data['complaintID']} із ${USERS.users['${provider}'].tender_claim_data.claim.data.description} для користувача ${viewer}


Відображення заголовку вимоги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     tender_complaint
  ...     non-critical
  Звірити відображення поля title для вимоги ${USERS.users['${provider}'].tender_claim_data['complaintID']} із ${USERS.users['${provider}'].tender_claim_data.claim.data.title} для користувача ${viewer}


Відображення заголовку документації вимоги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     tender_complaint
  ...     non-critical
  Звірити відображення поля title документа ${USERS.users['${provider}'].tender_claim_data.doc_id} до скарги ${USERS.users['${provider}'].tender_claim_data.complaintID} з ${USERS.users['${provider}'].tender_claim_data.doc_name} для користувача ${viewer}


Відображення поданого статусу вимоги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     tender_complaint
  ...     non-critical
  Звірити відображення поля status для вимоги ${USERS.users['${provider}'].tender_claim_data['complaintID']} із claim для користувача ${viewer}


Можливість відповісти на вимогу про виправлення умов закупівлі
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес оскарження
  ...     tender_owner
  ...     ${USERS.users['${tender_owner}'].broker}
  ...     tender_complaint
  ...     critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість відповісти resolved на вимогу про виправлення умов tender


Відображення статусу 'answered' вимоги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     tender_complaint
  ...     non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status для вимоги ${USERS.users['${provider}'].tender_claim_data['complaintID']} із answered для користувача ${viewer}


Відображення типу вирішення вимоги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     tender_complaint
  ...     non-critical
  Звірити відображення поля resolutionType для вимоги ${USERS.users['${provider}'].tender_claim_data['complaintID']} із ${USERS.users['${tender_owner}'].tender_claim_data.claim_answer.data.resolutionType} для користувача ${viewer}


Відображення вирішення вимоги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     tender_complaint
  ...     non-critical
  Звірити відображення поля resolution для вимоги ${USERS.users['${provider}'].tender_claim_data['complaintID']} із ${USERS.users['${tender_owner}'].tender_claim_data.claim_answer.data.resolution} для користувача ${viewer}


Можливість підтвердити задоволення вимоги про виправлення умов закупівлі
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...     provider
  ...     ${USERS.users['${provider}'].broker}
  ...     tender_complaint
  ...     critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість підтвердити задоволення вимоги про виправлення умов закупівлі


Відображення задоволення вимоги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     tender_complaint
  ...     non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Звірити відображення поля satisfied для вимоги ${USERS.users['${provider}'].tender_claim_data['complaintID']} із ${USERS.users['${provider}'].tender_claim_data.claim_answer_confirm.data.satisfied} для користувача ${viewer}


Відображення статусу 'resolved' вимоги
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     tender_complaint
  ...     non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status для вимоги ${USERS.users['${provider}'].tender_claim_data['complaintID']} із resolved для користувача ${viewer}


Можливість створити вимогу про виправлення умов закупівлі, додати документацію і подати її користувачем
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...     provider
  ...     ${USERS.users['${provider}'].broker}
  ...     tender_complaint
  ...     critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість створити вимогу про виправлення умов закупівлі із документацією


Можливість незадовільно відповісти на вимогу про виправлення умов закупівлі
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес оскарження
  ...     tender_owner
  ...     ${USERS.users['${tender_owner}'].broker}
  ...     tender_complaint
  ...     critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість відповісти declined на вимогу про виправлення умов tender


Можливість створити вимогу про виправлення умов лоту, додати до неї документацію і подати її
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...     provider
  ...     ${USERS.users['${provider}'].broker}
  ...     lot_complaint
  ...     critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${lot_index}=  Convert To Integer  ${lot_index}
  Можливість створити вимогу про виправлення умов ${lot_index} лоту із документацією


Можливість відхилити вимогу про виправлення умов лоту
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес оскарження
  ...     tender_owner
  ...     ${USERS.users['${tender_owner}'].broker}
  ...     lot_complaint
  ...     critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість відповісти invalid на вимогу про виправлення умов lot


Можливість дочекатись дати закінчення прийому пропозицій
  [Tags]  ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...     provider
  ...     ${USERS.users['${provider}'].broker}
  ...     tenderPeriod_endDate
  ...     critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Дочекатись дати закінчення прийому пропозицій  ${provider}  ${TENDER['TENDER_UAID']}


Відображення кінцевих статусів двох останніх вимог
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     tender_complaint
  ...     non-critical
  [Setup]  Дочекатись зміни статусу вимоги  ${provider}  invalid  ${USERS.users['${provider}'].lot_claim_data['complaintID']}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Звірити відображення поля status вимоги про виправлення умов ${lot_index} лоту із invalid для користувача ${viewer}
  Звірити відображення поля status для вимоги ${USERS.users['${provider}'].tender_claim_data['complaintID']} із declined для користувача ${viewer}

##############################################################################################
#             AWARD COMPLAINTS
##############################################################################################

Можливість дочекатись дати початку періоду кваліфікації
  [Tags]  ${USERS.users['${provider}'].broker}: Подання кваліфікації
  ...     provider
  ...     ${USERS.users['${provider}'].broker}
  ...     awardPeriod_startDate
  ...     critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Дочекатись дати початку періоду кваліфікації  ${provider}  ${TENDER['TENDER_UAID']}


Можливість підтвердити учасника
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...     tender_owner
  ...     ${USERS.users['${tender_owner}'].broker}
  ...     qualification_approve_first_award
  ...     critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${file_path}  ${file_name}  ${file_content}=   create_fake_doc
  Run As  ${tender_owner}  Завантажити документ рішення кваліфікаційної комісії  ${file_path}  ${TENDER['TENDER_UAID']}  0
  Run As  ${tender_owner}  Підтвердити постачальника  ${TENDER['TENDER_UAID']}  0
  Remove File  ${file_path}


Можливість створити вимогу про виправлення визначення переможця, додати до неї документацію і подати її користувачем
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...     provider
  ...     ${USERS.users['${provider}'].broker}
  ...     award_complaint_before_resolved
  ...     critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${award_index}=  Convert To Integer  ${award_index}
  Можливість створити вимогу про виправлення визначення ${award_index} переможця із документацією


Відображення опису вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     award_complaint_before_resolved
  ...     non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля description вимоги про виправлення визначення ${award_index} переможця із ${USERS.users['${provider}'].claim_data.claim.data.description} для користувача ${viewer}


Відображення заголовку вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     award_complaint_before_resolved
  ...     non-critical
  Звірити відображення поля title вимоги про виправлення визначення ${award_index} переможця із ${USERS.users['${provider}'].claim_data.claim.data.title} для користувача ${viewer}


Відображення заголовку документації вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     award_complaint_before_resolved
  ...     non-critical
  Звірити відображення поля title документа ${USERS.users['${provider}'].claim_data.doc_id} до скарги ${USERS.users['${provider}'].claim_data.complaintID} з ${USERS.users['${provider}'].claim_data.doc_name} для користувача ${viewer}


Відображення поданого статусу вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     award_complaint_before_resolved
  ...     non-critical
  Звірити відображення поля status вимоги про виправлення визначення ${award_index} переможця із claim для користувача ${viewer}


Можливість відповісти на вимогу про виправлення визначення переможця
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес оскарження
  ...     tender_owner
  ...     ${USERS.users['${tender_owner}'].broker}
  ...     award_complaint_before_resolved
  ...     critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість відповісти resolved на вимогу про виправлення визначення ${award_index} переможця


Відображення статусу 'answered' вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     award_complaint_before_resolved
  ...     non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status вимоги про виправлення визначення ${award_index} переможця із answered для користувача ${viewer}


Відображення типу вирішення вимоги вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     award_complaint_before_resolved
  ...     non-critical
  Звірити відображення поля resolutionType вимоги про виправлення визначення ${award_index} переможця із ${USERS.users['${tender_owner}'].claim_data.claim_answer.data.resolutionType} для користувача ${viewer}


Відображення вирішення вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     award_complaint_before_resolved
  ...     non-critical
  Звірити відображення поля resolution вимоги про виправлення визначення ${award_index} переможця із ${USERS.users['${tender_owner}'].claim_data.claim_answer.data.resolution} для користувача ${viewer}


Можливість підтвердити задоволення вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...     provider
  ...     ${USERS.users['${provider}'].broker}
  ...     below_award_complaint_before_resolved
  ...     critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість підтвердити задоволення вимоги про виправлення визначення ${award_index} переможця


Відображення статусу 'resolved' вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     below_award_complaint_before_resolved
  ...     non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status вимоги про виправлення визначення ${award_index} переможця із resolved для користувача ${viewer}


Відображення задоволення вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     below_award_complaint_before_resolved
  ...     non-critical
  Звірити відображення поля satisfied вимоги про виправлення визначення ${award_index} переможця із ${USERS.users['${provider}'].claim_data.claim_answer_confirm.data.satisfied} для користувача ${viewer}


Можливість створити чернетку вимоги про виправлення визначення переможця і скасувати її
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...     provider
  ...     ${USERS.users['${provider}'].broker}
  ...     award_complaint_draft
  ...     critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість створити чернетку вимоги про виправлення визначення ${award_index} переможця
  Можливість скасувати вимогу/скаргу про виправлення визначення ${award_index} переможця, надавши їй статус cancelled


Відображення статусу 'cancelled' чернетки вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     award_complaint_draft
  ...     non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status вимоги про виправлення визначення ${award_index} переможця із cancelled для користувача ${viewer}


Відображення причини скасування чернетки вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     award_complaint_draft
  ...     non-critical
  Звірити відображення поля cancellationReason вимоги про виправлення визначення ${award_index} переможця із ${USERS.users['${provider}'].claim_data.cancellation.data.cancellationReason} для користувача ${viewer}


Можливість створити, подати і скасувати вимогу про виправлення визначення переможця
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...     provider
  ...     ${USERS.users['${provider}'].broker}
  ...     award_complaint
  ...     critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість створити вимогу про виправлення визначення ${award_index} переможця із документацією
  Можливість скасувати вимогу/скаргу про виправлення визначення ${award_index} переможця, надавши їй статус cancelled


Відображення статусу 'cancelled' після 'draft -> claim' вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     award_complaint
  ...     non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status вимоги про виправлення визначення ${award_index} переможця із cancelled для користувача ${viewer}


Можливість створити, подати, відповісти і після того скасувати вимогу про виправлення визначення переможця
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...     provider
  ...     ${USERS.users['${provider}'].broker}
  ...     award_complaint
  ...     critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість створити вимогу про виправлення визначення ${award_index} переможця із документацією
  Дочекатись синхронізації з майданчиком  ${tender_owner}
  Можливість відповісти resolved на вимогу про виправлення визначення ${award_index} переможця
  Дочекатись синхронізації з майданчиком  ${provider}
  Можливість скасувати вимогу/скаргу про виправлення визначення ${award_index} переможця, надавши їй статус cancelled


Відображення статусу 'cancelled' після 'answered' вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     award_complaint
  ...     non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status вимоги про виправлення визначення ${award_index} переможця із cancelled для користувача ${viewer}


Можливість створити скаргу про виправлення визначення переможця
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...     provider
  ...     ${USERS.users['${provider}'].broker}
  ...     openua_award_complaint
  ...     critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість створити скаргу про виправлення визначення ${award_index} переможця із документацією

Відображення статусу 'pending' скарги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     openua_award_complaint
  ...     non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status вимоги про виправлення визначення ${award_index} переможця із pending для користувача ${viewer}


Можливість скасувати скаргу про виправлення визначення переможця
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...     provider
  ...     ${USERS.users['${provider}'].broker}
  ...     openua_award_complaint
  ...     critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість скасувати вимогу/скаргу про виправлення визначення ${award_index} переможця, надавши їй статус stopping


Відображення статусу 'stopping' скарги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     openua_award_complaint
  ...     non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status вимоги про виправлення визначення ${award_index} переможця із stopping для користувача ${viewer}


Відображення причини скасування скарги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     openua_award_complaint
  ...     non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля cancellationReason вимоги про виправлення визначення ${award_index} переможця із ${USERS.users['${provider}'].claim_data.cancellation.data.cancellationReason} для користувача ${viewer}


Можливість створити вимогу про виправлення визначення переможця, додати документацію і подати її переможцем
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...     provider
  ...     ${USERS.users['${provider}'].broker}
  ...     award_complaint
  ...     critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${award_index}=  Convert To Integer  ${award_index}
  Можливість створити вимогу про виправлення визначення ${award_index} переможця із документацією


Відображення закінчення періоду подачі скарг на пропозицію
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Відображення основних даних тендера
  ...     tender_owner
  ...     ${USERS.users['${tender_owner}'].broker}
  ...     award_complaint
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \  Отримати дані із тендера  ${username}  ${TENDER['TENDER_UAID']}  awards[${award_index}].complaintPeriod.endDate


Дочекатися закічення stand still періоду
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес укладання угоди
  ...     tender_owner
  ...     ${USERS.users['${tender_owner}'].broker}
  ...     award_complaint
  ${standstillEnd}=  Get Variable Value  ${USERS.users['${tender_owner}'].tender_data.data.awards[${award_index}].complaintPeriod.endDate}
  Дочекатись дати  ${standstillEnd}


Можливість укласти угоду для закупівлі
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес укладання угоди
  ...     tender_owner
  ...     ${USERS.users['${tender_owner}'].broker}
  ...     below_award_complaint
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Run As  ${tender_owner}  Підтвердити підписання контракту  ${TENDER['TENDER_UAID']}  ${award_index}


Відображення статусу 'ignored' вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     below_award_complaint
  ...     non-critical
  [Setup]  Дочекатись зміни статусу вимоги  ${provider}  ignored  ${USERS.users['${provider}']['claim_data']['complaintID']}  ${award_index}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Звірити відображення поля status вимоги про виправлення визначення ${award_index} переможця із ignored для користувача ${viewer}