*** Settings ***
Resource        base_keywords.robot
Resource        aboveThreshold_keywords.robot
Suite Setup     Test Suite Setup
Suite Teardown  Test Suite Teardown


*** Variables ***
${MODE}             openeu
@{USED_ROLES}       tender_owner  provider  provider1  provider2  viewer
${DIALOGUE_TYPE}    EU

${NUMBER_OF_ITEMS}  ${1}
${NUMBER_OF_LOTS}   ${1}
${TENDER_MEAT}      ${True}
${LOT_MEAT}         ${True}
${ITEM_MEAT}        ${True}
${MOZ_INTEGRATION}  ${False}
@{HISTORICAL_DATA}
${SUBMISSIONMETHODDETAILS}  quick(mode:no-auction)


*** Test Cases ***
#оголошення закупівлі

Можливість оголосити тендер
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оголошення тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_tender  level1
  ...      critical
  [Teardown]  Можливість звірити historical
  Set Suite Variable  @{HISTORICAL_DATA}  @{EMPTY}
  Можливість оголосити тендер

Можливість дочекатись початку періоду уточнень

  [Teardown]  Можливість звірити historical для очікування
  Дочекатись дати початку прийому пропозицій  ${provider}  ${TENDER['TENDER_UAID']}

#подача пропозицій


Можливість подати пропозицію першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      make_bid_by_provider  level1
  ...      critical
  [Setup]  Дочекатись дати початку прийому пропозицій  ${provider}  ${TENDER['TENDER_UAID']}
  [Teardown]  Можливість звірити historical
  Можливість подати цінову пропозицію користувачем ${provider}


Можливість подати пропозицію другим учасником
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      make_bid_by_provider1  level1
  ...      critical
  [Setup]  Дочекатись дати початку прийому пропозицій  ${provider1}  ${TENDER['TENDER_UAID']}
  [Teardown]  Можливість звірити historical
  Можливість подати цінову пропозицію користувачем ${provider1}



Можливість дочекатися початку періоду прекваліфікації
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Кваліфікація
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_approve_first_bid  level1
  ...      critical
  Дочекатись дати закінчення періоду уточнень  ${tender_owner}  ${TENDER['TENDER_UAID']}
  Run Keyword And Continue On Failure  Можливість звірити historical для очікування
  Дочекатись дати закінчення періоду подання скарг  ${tender_owner}
  Run Keyword And Continue On Failure  Можливість звірити historical для очікування
  Дочекатись дати закінчення прийому пропозицій  ${tender_owner}  ${TENDER['TENDER_UAID']}
  Run Keyword And Continue On Failure  Можливість звірити historical для очікування
  Дочекатись дати початку періоду прекваліфікації  ${tender_owner}  ${TENDER['TENDER_UAID']}
  [Teardown]  Можливість звірити historical для очікування


#кваліфікація

Можливість підтвердити першу пропозицію кваліфікації
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Кваліфікація
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_approve_first_bid  level1
  ...      critical
  [Setup]  Дочекатись дати початку періоду прекваліфікації  ${tender_owner}  ${TENDER['TENDER_UAID']}
  [Teardown]  Можливість звірити historical
  Можливість підтвердити 0 пропозицію кваліфікації


Можливість підтвердити другу пропозицію кваліфікації
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Кваліфікація
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_approve_second_bid  level1
  ...      critical
  [Teardown]  Можливість звірити historical
  Можливість підтвердити -1 пропозицію кваліфікації


Можливість затвердити остаточне рішення кваліфікації
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Кваліфікація
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_approve_qualifications  level1
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Можливість звірити historical
  Можливість затвердити остаточне рішення кваліфікації



Можливість дочекатися закінчення періоду прекваліфікації
  [Teardown]  Можливість звірити historical для очікування
  Дочекатись дати закінчення періоду прекваліфікації  ${tender_owner}  ${TENDER['TENDER_UAID']}


Можливість дочекатися початку періоду авардінгу
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  qualification
  ...  critica
  [Teardown]  Можливість звірити historical для очікування
  Дочекатись дати початку періоду кваліфікації  ${tender_owner}  ${TENDER['TENDER_UAID']}


#авардінг


Можливість підтвердити постачальника
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  qualification_approve_first_award
  ...  critical
  [Setup]  Дочекатись дати початку періоду кваліфікації  ${tender_owner}  ${TENDER['TENDER_UAID']}
  [Teardown]  Можливість звірити historical
  Run As  ${tender_owner}  Підтвердити постачальника  ${TENDER['TENDER_UAID']}  0


Відображення закінчення періоду подачі скарг на пропозицію
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Відображення основних даних тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      contract_stand_still
  ...      critical
  ${award_index}=  Отримати останній індекс  awards  ${tender_owner}  ${viewer}
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \  Отримати дані із тендера  ${username}  ${TENDER['TENDER_UAID']}  awards[${award_index}].complaintPeriod.endDate


Дочекатися закічення stand still періоду
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Процес укладання угоди
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      contract_stand_still
  ...      critical
  [Teardown]  Можливість звірити historical для очікування
  ${award_index}=  Отримати останній індекс  awards  ${tender_owner}  ${viewer}
  ${standstillEnd}=  Get Variable Value  ${USERS.users['${tender_owner}'].tender_data.data.awards[${award_index}].complaintPeriod.endDate}
  Дочекатись дати  ${standstillEnd}



#контракт

Можливість встановити дату підписання угоди
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування угоди
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_contract
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Можливість звірити historical
  ${contract_index}=  Отримати останній індекс  contracts  ${tender_owner}  ${viewer}
  ${dateSigned}=  create_fake_date
  Set to dictionary  ${USERS.users['${tender_owner}']}  dateSigned=${dateSigned}
  Run As  ${tender_owner}  Встановити дату підписання угоди  ${TENDER['TENDER_UAID']}  ${contract_index}  ${dateSigned}

Можливість укласти угоду для закупівлі
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Процес укладання угоди
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      contract_sign  level1
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Можливість звірити historical
  ${contract_index}=  Отримати останній індекс  contracts  ${tender_owner}  ${viewer}
  Run As  ${tender_owner}  Підтвердити підписання контракту  ${TENDER['TENDER_UAID']}  ${contract_index}


Відображення статусу підписаної угоди з постачальником закупівлі
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних угоди
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      contract_sign
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  [Teardown]  Можливість звірити historical
  ${contract_index}=  Отримати останній індекс  contracts  ${tender_owner}  ${viewer}
  Run As  ${viewer}  Оновити сторінку з тендером  ${TENDER['TENDER_UAID']}
  Звірити відображення поля contracts[${contract_index}].status тендера із active для користувача ${viewer}


*** Keywords ***

Можливість звірити historical
  [Documentation]
  ...       Оновити LAST_MODIFICATION_DATE
  ...       Звірити поточну версію historical
  ...       і останню версію тендера

  Оновити LAST_MODIFICATION_DATE
  Run As  ${tender_owner}  Порівняти версії тендера з останньою версією historical  ${TENDER['TENDER_UAID']}
  Run As  ${tender_owner}  Порівняти збережені версії з historical  ${TENDER['TENDER_UAID']}


Можливість звірити historical для очікування
  [Documentation]
  ...       Звірити поточну версію historical
  ...       і останню версію тендера
  Run As  ${tender_owner}  Порівняти версії тендера з останньою версією historical  ${TENDER['TENDER_UAID']}
  Run As  ${tender_owner}  Порівняти збережені версії з historical  ${TENDER['TENDER_UAID']}






