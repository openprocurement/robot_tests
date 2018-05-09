*** Settings ***
Resource        base_keywords.robot
Suite Setup     Test Suite Setup
Suite Teardown  Test Suite Teardown

*** Variables ***
${RESOURCE}     plans
${MODE}         belowThreshold
@{USED_ROLES}   tender_owner  viewer

${NUMBER_OF_ITEMS}  ${2}
${TENDER_MEAT}      ${False}
${ITEM_MEAT}        ${False}

*** Test Cases ***
Можливість створити план закупівлі
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оголошення плану
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_plan
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість створити план закупівлі


Можливість знайти план по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук плану
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      find_plan
  ...      critical
  Можливість знайти план по ідентифікатору


Відображення типу запланованого тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних плану
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      plan_view
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення типу запланованого тендера для ${viewer}


Відображення суми бюджету
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних плану
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      plan_view
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля budget.amount плану для користувача ${viewer}


Відображення опису бюджету
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних плану
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      plan_view
  ...      non-critical
  Звірити відображення поля budget.description плану для користувача ${viewer}


Відображення валюти бюджету
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних плану
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      plan_view
  ...      critical
  Звірити відображення поля budget.currency плану для користувача ${viewer}


Відображення id бюджету
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних плану
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      plan_view
  ...      non-critical
  Звірити відображення поля budget.id плану для користувача ${viewer}


Відображення id проекту в бюджеті
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних плану
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      plan_view
  ...      non-critical
  Звірити відображення поля budget.project.id плану для користувача ${viewer}


Відображення назви проекту в бюджеті
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних плану
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      plan_view
  ...      critical
  Звірити відображення поля budget.project.name плану для користувача ${viewer}


Відображення назви організації
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних плану
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      plan_view
  ...      critical
  Звірити відображення поля procuringEntity.name плану для користувача ${viewer}


Відображення схеми ідентифікатора організації
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних плану
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      plan_view
  ...      critical
  Звірити відображення поля procuringEntity.identifier.scheme плану для користувача ${viewer}


Відображення ідентифікатора організації
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних плану
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      plan_view
  ...      critical
  Звірити відображення поля procuringEntity.identifier.id плану для користувача ${viewer}


Відображення легально зареєстрованої назви організації
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних плану
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      plan_view
  ...      non-critical
  Звірити відображення поля procuringEntity.identifier.legalName плану для користувача ${viewer}


Відображення опису класифікації
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних плану
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      plan_view
  ...      non-critical
  Звірити відображення поля classification.description плану для користувача ${viewer}


Відображення схеми класифікації
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних плану
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      plan_view
  ...      non-critical
  Звірити відображення поля classification.scheme плану для користувача ${viewer}


Відображення коду класифікації
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних плану
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      plan_view
  ...      non-critical
  Звірити відображення поля classification.id плану для користувача ${viewer}


Відображення дати початку періоду подання пропозицій
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних плану
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      plan_view
  ...      critical
  Звірити відображення поля tender.tenderPeriod.startDate плану для користувача ${viewer}


Відображення опису об'єкта
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних плану
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      plan_view  level2
  ...      critical
  Звірити відображення description усіх предметів плану для користувача ${viewer}


Відображення кількості необхідних одиниць об'єкта
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних плану
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      plan_view
  ...      critical
  Звірити відображення quantity усіх предметів плану для користувача ${viewer}


Відображення кінцевої дати доставки
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних плану
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      plan_view
  ...      critical
  Звірити відображення deliveryDate.endDate усіх предметів плану для користувача ${viewer}


Відображення коду одиниці виміру
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних плану
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      plan_view
  ...      non-critical
  Звірити відображення unit.code усіх предметів плану для користувача ${viewer}


Відображення назви одиниці виміру
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних плану
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      plan_view
  ...      non-critical
  Звірити відображення unit.name усіх предметів плану для користувача ${viewer}


Відображення опису класифікації об'єкта
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних плану
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      plan_view
  ...      non-critical
  Звірити відображення classification.description усіх предметів плану для користувача ${viewer}


Відображення схеми класифікації об'єкта
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних плану
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      plan_view
  ...      non-critical
  Звірити відображення classification.scheme усіх предметів плану для користувача ${viewer}


Відображення коду класифікації об'єкта
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних плану
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      plan_view
  ...      non-critical
  Звірити відображення classification.id усіх предметів плану для користувача ${viewer}


Можливість змінити опис бюджету
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування плану
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_plan
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_description}=  create_fake_sentence
  Можливість змінити поле budget.description плану на ${new_description}


Можливість змінити суму бюджету
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування плану
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_plan
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_amount}=  create_fake_value_amount
  Можливість змінити поле budget.amount плану на ${new_amount}


Можливість змінити кінцеву дату доставки
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування плану
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_plan
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_date}=  create_fake_date
  Можливість змінити поле items[0].deliveryDate.endDate плану на ${new_date}


Можливість змінити кількість одиниць предмету закупівлі
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування плану
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_plan
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_quantity}=  create_fake_value_amount
  Можливість змінити поле items[0].quantity плану на ${new_quantity}


Можливість додати предмет закупівлі
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування плану
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_item
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість додати предмет закупівлі в план


Можливість видалити предмет закупівлі
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування плану
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      delete_item
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість видалити предмет закупівлі з плану