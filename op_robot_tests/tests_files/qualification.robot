*** Settings ***
Resource        base_keywords.robot
Suite Setup     Test Suite Setup
Suite Teardown  Test Suite Teardown

*** Variables ***
@{used_roles}   tender_owner  viewer  provider

${award_index}      ${0}


*** Test Cases ***
##############################################################################################
#             FIND TENDER
##############################################################################################

Можливість знайти закупівлю по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук тендера
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      minimal
  ...      find_tender
  Завантажити дані про тендер
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \   ${resp}=  Run As  ${username}  Пошук тендера по ідентифікатору   ${TENDER['TENDER_UAID']}

Можливість створити вимогу про виправлення визначення переможця, додати до неї документацію і подати її користувачем
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  create_award_claim
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${award_index}=  Convert to integer  ${award_index}
  Можливість створити вимогу про виправлення визначення ${award_index} переможця із документацією


Відображення опису вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  create_award_claim
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля description вимоги про виправлення визначення ${award_index} переможця із ${USERS.users['${provider}'].claim_data.claim.data.description} для користувача ${viewer}


Відображення заголовку вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  create_award_claim
  Звірити відображення поля title вимоги про виправлення визначення ${award_index} переможця із ${USERS.users['${provider}'].claim_data.claim.data.title} для користувача ${viewer}


Відображення заголовку документації вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  create_award_claim
  Звірити відображення поля document.title вимоги про виправлення визначення ${award_index} переможця із ${USERS.users['${provider}'].claim_data.document} для користувача ${viewer}


Відображення поданого статусу вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  create_award_claim
  Звірити відображення поля status вимоги про виправлення визначення ${award_index} переможця із claim для користувача ${viewer}


Можливість відповісти на вимогу про виправлення визначення переможця
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес оскарження
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  answer_award_claim
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість відповісти на вимогу про виправлення визначення ${award_index} переможця


Відображення статусу 'answered' вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  answer_award_claim
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status вимоги про виправлення визначення ${award_index} переможця із answered для користувача ${viewer}


Відображення типу вирішення вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  answer_award_claim
  Звірити відображення поля resolutionType вимоги про виправлення визначення ${award_index} переможця із ${USERS.users['${tender_owner}'].claim_data.claim_answer.data.resolutionType} для користувача ${viewer}


Відображення вирішення вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  answer_award_claim
  Звірити відображення поля resolution вимоги про виправлення визначення ${award_index} переможця із ${USERS.users['${tender_owner}'].claim_data.claim_answer.data.resolution} для користувача ${viewer}


Можливість підтвердити задоволення вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  resolve_award_claim
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  Можливість підтвердити задоволення вимоги про виправлення визначення ${award_index} переможця

Відображення статусу 'resolved' вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  resolve_award_claim
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status вимоги про виправлення визначення ${award_index} переможця із resolved для користувача ${viewer}


Відображення задоволення вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  resolve_award_claim
  Звірити відображення поля satisfied вимоги про виправлення визначення ${award_index} переможця із ${USERS.users['${provider}'].claim_data.claim_answer_confirm.data.satisfied} для користувача ${viewer}


Можливість перетворити вимогу про виправлення визначення переможця в скаргу
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  escalate_award_claim
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  Можливість перетворити вимогу про виправлення визначення ${award_index} переможця в скаргу


Відображення статусу 'pending' після 'claim -> answered' вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  escalate_award_claim
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status вимоги про виправлення визначення ${award_index} переможця із pending для користувача ${viewer}


Відображення незадоволення вимоги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  escalate_award_claim
  Звірити відображення поля satisfied вимоги про виправлення визначення ${award_index} переможця із ${USERS.users['${provider}'].claim_data.escalation.data.satisfied} для користувача ${viewer}


Можливість скасувати вимогу/скаргу про виправлення визначення переможця
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  cancel_award_claim
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  Можливість скасувати вимогу про виправлення визначення ${award_index} переможця


Відображення статусу 'cancelled' вимоги/скарги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  cancel_award_claim
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status вимоги про виправлення визначення ${award_index} переможця із cancelled для користувача ${viewer}


Відображення причини скасування вимоги/скарги про виправлення визначення переможця
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  cancel_award_claim
  Звірити відображення поля cancellationReason вимоги про виправлення визначення ${award_index} переможця із ${USERS.users['${provider}'].claim_data.cancellation.data.cancellationReason} для користувача ${viewer}

# ##############################################################################################
# #             CREATE CLAIM
# ##############################################################################################

# Можливість створити вимогу про виправлення визначення переможця, додати до неї документацію і подати її користувачем
#   [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
#   ...  provider
#   ...  ${USERS.users['${provider}'].broker}
#   ...  award_complaint
#   [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
#   [Teardown]  Оновити LAST_MODIFICATION_DATE
#   ${award_index}=  Convert To Integer  ${award_index}
#   Можливість створити вимогу про виправлення визначення ${award_index} переможця із документацією


# Відображення опису вимоги
#   [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
#   ...  viewer
#   ...  ${USERS.users['${viewer}'].broker}
#   ...  award_complaint
#   [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
#   Звірити відображення поля description вимоги про виправлення визначення ${award_index} переможця із ${USERS.users['${provider}'].claim_data.claim.data.description} для користувача ${viewer}


# Відображення заголовку вимоги
#   [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
#   ...  viewer
#   ...  ${USERS.users['${viewer}'].broker}
#   ...  award_complaint
#   Звірити відображення поля title вимоги про виправлення визначення ${award_index} переможця із ${USERS.users['${provider}'].claim_data.claim.data.title} для користувача ${viewer}


# Відображення заголовку документації вимоги
#   [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
#   ...  viewer
#   ...  ${USERS.users['${viewer}'].broker}
#   ...  award_complaint
#   Звірити відображення поля document.title вимоги про виправлення визначення ${award_index} переможця із ${USERS.users['${provider}'].claim_data.document} для користувача ${viewer}


# Відображення поданого статусу вимоги
#   [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
#   ...  viewer
#   ...  ${USERS.users['${viewer}'].broker}
#   ...  award_complaint
#   Звірити відображення поля status вимоги про виправлення визначення ${award_index} переможця із claim для користувача ${viewer}

# ##############################################################################################
# #             ANSWER TO CLAIM
# ##############################################################################################

# Можливість відповісти на вимогу про виправлення визначення переможцця
#   [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес оскарження
#   ...  tender_owner
#   ...  ${USERS.users['${tender_owner}'].broker}
#   ...  award_complaint
#   [Teardown]  Оновити LAST_MODIFICATION_DATE
#   Можливість відповісти на вимогу про виправлення визначення ${award_index} переможця


# Відображення статусу 'answered' вимоги
#   [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
#   ...  viewer
#   ...  ${USERS.users['${viewer}'].broker}
#   ...  award_complaint
#   [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
#   Звірити відображення поля status вимоги про виправлення визначення ${award_index} переможця із answered для користувача ${viewer}


# Відображення типу вирішення вимоги
#   [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
#   ...  viewer
#   ...  ${USERS.users['${viewer}'].broker}
#   ...  award_complaint
#   Звірити відображення поля resolutionType вимоги про виправлення визначення ${award_index} переможця із ${USERS.users['${tender_owner}'].claim_data.claim_answer.data.resolutionType} для користувача ${viewer}


# Відображення вирішення вимоги
#   [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
#   ...  viewer
#   ...  ${USERS.users['${viewer}'].broker}
#   ...  award_complaint
#   Звірити відображення поля resolution вимоги про виправлення визначення ${award_index} переможця із ${USERS.users['${tender_owner}'].claim_data.claim_answer.data.resolution} для користувача ${viewer}

# ##############################################################################################
# #             CONFIRM CLAIM REQUIREMENTS SATISFACTION
# ##############################################################################################

# Можливість підтвердити задоволення вимоги про виправлення визначення переможця
#   [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
#   ...  provider
#   ...  ${USERS.users['${provider}'].broker}
#   ...  award_complaint
#   [Teardown]  Оновити LAST_MODIFICATION_DATE
#   Можливість підтвердити задоволення вимоги про виправлення визначення ${award_index} переможця


# Відображення статусу 'resolved' вимоги
#   [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
#   ...  viewer
#   ...  ${USERS.users['${viewer}'].broker}
#   ...  award_complaint
#   [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
#   Звірити відображення поля status вимоги про виправлення визначення ${award_index} переможця із resolved для користувача ${viewer}


# Відображення задоволення вимоги
#   [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
#   ...  viewer
#   ...  ${USERS.users['${viewer}'].broker}
#   ...  award_complaint
#   Звірити відображення поля satisfied вимоги про виправлення визначення ${award_index} переможця із ${USERS.users['${provider}'].claim_data.claim_answer_confirm.data.satisfied} для користувача ${viewer}

# ##############################################################################################
# #             CREATE AND CANCEL CLAIM
# ##############################################################################################

# Можливість створити чернетку вимоги про виправлення визначення переможця і скасувати її
#   [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
#   ...  provider
#   ...  ${USERS.users['${provider}'].broker}
#   ...  award_complaint
#   [Teardown]  Оновити LAST_MODIFICATION_DATE
#   Можливість створити чернетку вимоги про виправлення визначення ${award_index} переможця
#   Можливість скасувати вимогу про виправлення визначення ${award_index} переможця


# Відображення статусу 'cancelled' чернетки вимоги
#   [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
#   ...  viewer
#   ...  ${USERS.users['${viewer}'].broker}
#   ...  award_complaint
#   [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
#   Звірити відображення поля status вимоги про виправлення визначення ${award_index} переможця із cancelled для користувача ${viewer}


# Відображення причини скасування чернетки вимоги
#   [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
#   ...  viewer
#   ...  ${USERS.users['${viewer}'].broker}
#   ...  award_complaint
#   Звірити відображення поля cancellationReason вимоги про виправлення визначення ${award_index} переможця із ${USERS.users['${provider}'].claim_data.cancellation.data.cancellationReason} для користувача ${viewer}

# ##############################################################################################
# #             CREATE, SUBMIT AND CANCEL CLAIM
# ##############################################################################################

# Можливість створити, подати і скасувати вимогу про виправлення визначення переможця
#   [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
#   ...  provider
#   ...  ${USERS.users['${provider}'].broker}
#   ...  award_complaint
#   [Teardown]  Оновити LAST_MODIFICATION_DATE
#   Можливість створити вимогу про виправлення визначення ${award_index} переможця із документацією
#   Можливість скасувати вимогу про виправлення визначення ${award_index} переможця


# Відображення статусу 'cancelled' після 'draft -> claim' вимоги
#   [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
#   ...  viewer
#   ...  ${USERS.users['${viewer}'].broker}
#   ...  award_complaint
#   [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
#   Звірити відображення поля status вимоги про виправлення визначення ${award_index} переможця із cancelled для користувача ${viewer}

# ##############################################################################################
# #             CREATE, SUBMIT, ANSWER AND CANCEL CLAIM
# ##############################################################################################

# Можливість створити, подати, відповісти і після того скасувати вимогу про виправлення визначення переможця
#   [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
#   ...  provider
#   ...  ${USERS.users['${provider}'].broker}
#   ...  award_complaint
#   [Teardown]  Оновити LAST_MODIFICATION_DATE
#   Можливість створити вимогу про виправлення визначення ${award_index} переможця із документацією
#   Можливість відповісти на вимогу про виправлення визначення ${award_index} переможця
#   Можливість скасувати вимогу про виправлення визначення ${award_index} переможця


# Відображення статусу 'cancelled' після 'draft -> claim -> answered' вимоги
#   [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
#   ...  viewer
#   ...  ${USERS.users['${viewer}'].broker}
#   ...  award_complaint
#   [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
#   Звірити відображення поля status вимоги про виправлення визначення ${award_index} переможця із cancelled для користувача ${viewer}

# ##############################################################################################
# #             CREATE, SUBMIT, ANSWER AND ESCALATE CLAIM
# ##############################################################################################

# Можливість створити, подати, відповісти на вимогу про виправлення визначення переможця і перетворити її в скаргу
#   [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
#   ...  provider
#   ...  ${USERS.users['${provider}'].broker}
#   ...  award_complaint
#   [Teardown]  Оновити LAST_MODIFICATION_DATE
#   Можливість створити вимогу про виправлення визначення ${award_index} переможця із документацією
#   Можливість відповісти на вимогу про виправлення визначення ${award_index} переможця
#   Можливість перетворити вимогу про виправлення визначення ${award_index} переможця в скаргу


# Відображення статусу 'pending' після 'draft -> claim -> answered' вимоги
#   [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
#   ...  viewer
#   ...  ${USERS.users['${viewer}'].broker}
#   ...  award_complaint
#   [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
#   Звірити відображення поля status вимоги про виправлення визначення ${award_index} переможця із pending для користувача ${viewer}


# Відображення незадоволення вимоги
#   [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
#   ...  viewer
#   ...  ${USERS.users['${viewer}'].broker}
#   ...  award_complaint
#   Звірити відображення поля satisfied вимоги про виправлення визначення ${award_index} переможця із ${USERS.users['${provider}'].claim_data.escalation.data.satisfied} для користувача ${viewer}

# ##############################################################################################
# #             CANCEL COMPLAINT
# ##############################################################################################

# Можливість скасувати скаргу про виправлення визначення переможця
#   [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
#   ...  provider
#   ...  ${USERS.users['${provider}'].broker}
#   ...  award_complaint
#   [Teardown]  Оновити LAST_MODIFICATION_DATE
#   Можливість скасувати вимогу про виправлення визначення ${award_index} переможця


# Відображення статусу 'cancelled' скарги
#   [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
#   ...  viewer
#   ...  ${USERS.users['${viewer}'].broker}
#   ...  award_complaint
#   [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
#   Звірити відображення поля status вимоги про виправлення визначення ${award_index} переможця із cancelled для користувача ${viewer}


# Відображення причини скасування скарги
#   [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
#   ...  viewer
#   ...  ${USERS.users['${viewer}'].broker}
#   ...  award_complaint
#   [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
#   Звірити відображення поля cancellationReason вимоги про виправлення визначення ${award_index} переможця із ${USERS.users['${provider}'].claim_data.cancellation.data.cancellationReason} для користувача ${viewer}

# ##############################################################################################
# #             AWARDS
# ##############################################################################################

# Відображення статусу кваліфікації
#   [Tags]   ${USERS.users['${tender_owner}'].broker}: Відображення основних даних кваліфікації
#   ...      tender_owner
#   ...      ${USERS.users['${tender_owner}'].broker}
#   :FOR  ${username}  IN  ${viewer}  ${tender_owner}
#   \   ${qualification_status}=  Отримати дані із тендера  ${tender_owner}  ${TENDER['TENDER_UAID']}  status  ${TENDER['LOT_ID']}
#   \   Run Keyword IF  '${TENDER['LOT_ID']}'  Should Be Equal  ${qualification_status}  active
#   \   ...         ELSE  Should Be Equal  ${qualification_status}  active.qualification


# Відображення вартості номенклатури постачальника
#   [Tags]   ${USERS.users['${tender_owner}'].broker}: Відображення основних даних постачальника
#   ...      tender_owner
#   ...      ${USERS.users['${tender_owner}'].broker}
#   :FOR  ${username}  IN  ${viewer}  ${tender_owner}
#   \  Отримати дані із тендера  ${username}  ${TENDER['TENDER_UAID']}  awards[0].value.amount


# Відображення імені постачальника
#   [Tags]   ${USERS.users['${tender_owner}'].broker}: Відображення основних даних постачальника
#   ...      tender_owner
#   ...      ${USERS.users['${tender_owner}'].broker}
#   :FOR  ${username}  IN  ${viewer}  ${tender_owner}
#   \  Отримати дані із тендера  ${username}  ${TENDER['TENDER_UAID']}  awards[0].suppliers[0].name


# Відображення ідентифікатора постачальника
#   [Tags]   ${USERS.users['${tender_owner}'].broker}: Відображення основних даних постачальника
#   ...      tender_owner
#   ...      ${USERS.users['${tender_owner}'].broker}
#   :FOR  ${username}  IN  ${viewer}  ${tender_owner}
#   \  Отримати дані із тендера  ${username}  ${TENDER['TENDER_UAID']}  awards[0].suppliers[0].identifier.id

# ##############################################################################################
# #             QUALIFICATION
# ##############################################################################################

# Можливість завантажити документ рішення кваліфікаційної комісії для підтвердження постачальника
#   [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
#   ...  tender_owner
#   ...  ${USERS.users['${tender_owner}'].broker}
#   ${filepath}=   create_fake_doc
#   Run As   ${tender_owner}   Завантажити документ рішення кваліфікаційної комісії   ${filepath}   ${TENDER['TENDER_UAID']}   0


# Можливість підтвердити постачальника
#   [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
#   ...  tender_owner
#   ...  ${USERS.users['${tender_owner}'].broker}
#   ...  minimal
#   Run As  ${tender_owner}  Підтвердити постачальника  ${TENDER['TENDER_UAID']}  0


# Можливість скасувати рішення кваліфікації
#   [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
#   ...  tender_owner
#   ...  ${USERS.users['${tender_owner}'].broker}
#   ...  minimal
#   Run As  ${tender_owner}  Скасування рішення кваліфікаційної комісії  ${TENDER['TENDER_UAID']}  0


# Можливість завантажити документ рішення кваліфікаційної комісії для підтвердження нового постачальника
#   [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
#   ...  tender_owner
#   ...  ${USERS.users['${tender_owner}'].broker}
#   ${filepath}=   create_fake_doc
#   Run As   ${tender_owner}   Завантажити документ рішення кваліфікаційної комісії   ${filepath}   ${TENDER['TENDER_UAID']}   1


# Можливість підтвердити нового постачальника
#   [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
#   ...  tender_owner
#   ...  ${USERS.users['${tender_owner}'].broker}
#   ...  minimal
#   Run As  ${tender_owner}  Підтвердити постачальника  ${TENDER['TENDER_UAID']}  1
