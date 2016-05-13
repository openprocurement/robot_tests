*** Settings ***
Resource        keywords.robot
Resource        resource.robot
Suite Setup     Test Suite Setup
Suite Teardown  Test Suite Teardown

*** Variables ***
@{used_roles}   tender_owner  viewer


*** Test Cases ***
Можливість знайти закупівлю по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук тендера по ідентифікатору
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      minimal
  Завантажити дані про тендер
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \   ${resp}=  Run As  ${username}  Пошук тендера по ідентифікатору   ${TENDER['TENDER_UAID']}

##############################################################################################
#             AWARDS
##############################################################################################

Відображення статусу кваліфікації
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Відображення основних даних оголошеного тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \   ${qualification_status}=  Отримати дані із тендера  ${tender_owner}  ${TENDER['TENDER_UAID']}  status  ${TENDER['LOT_ID']}
  \   Run Keyword IF  '${TENDER['LOT_ID']}'  Should Be Equal  ${qualification_status}  active
  \   ...         ELSE  Should Be Equal  ${qualification_status}  active.qualification


Відображення вартості номенклатури постачальника
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Відображення основних даних оголошеного тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \  Отримати дані із тендера  ${username}  ${TENDER['TENDER_UAID']}  awards[0].value.amount


Відображення імені постачальника
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Відображення основних даних оголошеного тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \  Отримати дані із тендера  ${username}  ${TENDER['TENDER_UAID']}  awards[0].suppliers[0].name


Відображення ідентифікатора постачальника
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Відображення основних даних оголошеного тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \  Отримати дані із тендера  ${username}  ${TENDER['TENDER_UAID']}  awards[0].suppliers[0].identifier.id

##############################################################################################
#             QUALIFICATION
##############################################################################################

Можливість завантажити документ рішення кваліфікаційної комісії для підтвердження постачальника
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Можливість укласти угоду для прямої закупівлі
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ${filepath}=   create_fake_doc
  Run As   ${tender_owner}   Завантажити документ рішення кваліфікаційної комісії   ${filepath}   ${TENDER['TENDER_UAID']}   0


Можливість підтвердити постачальника
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Можливість зареєструвати і підтвердити постачальника до прямої закупівлі
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  minimal
  Run As  ${tender_owner}  Підтвердити постачальника  ${TENDER['TENDER_UAID']}  0


Можливість скасувати рішення кваліфікації
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Можливість зареєструвати і підтвердити постачальника до прямої закупівлі
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  minimal
  Run As  ${tender_owner}  Скасування рішення кваліфікаційної комісії  ${TENDER['TENDER_UAID']}  0


Можливість завантажити документ рішення кваліфікаційної комісії для підтвердження нового постачальника
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Можливість укласти угоду для прямої закупівлі
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ${filepath}=   create_fake_doc
  Run As   ${tender_owner}   Завантажити документ рішення кваліфікаційної комісії   ${filepath}   ${TENDER['TENDER_UAID']}   1


Можливість підтвердити нового постачальника
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Можливість зареєструвати і підтвердити постачальника до прямої закупівлі
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  minimal
  Run As  ${tender_owner}  Підтвердити постачальника  ${TENDER['TENDER_UAID']}  1
