*** Settings ***
Resource        base_keywords.robot
Suite Setup     Test Suite Setup
Suite Teardown  Test Suite Teardown

*** Variables ***
${MODE}         planning
@{USED_ROLES}   tender_owner  viewer


*** Test Cases ***
Можливість створити план закупівлі
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оголошення плану
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_plan
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість створити план закупівлі


Можливість знайти план по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук плану
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      find_plan
  Можливість знайти план по ідентифікатору


Відображення суми бюджету
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних плану
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      plan_view
  Звірити відображення поля budget.amount плану для користувача ${viewer}


Відображення amountNet бюджету
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних плану
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      plan_view
  Звірити відображення поля budget.amountNet плану для користувача ${viewer}


Відображення опису бюджету
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних плану
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      plan_view
  Звірити відображення поля budget.description плану для користувача ${viewer}


Відображення валюти бюджету
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних плану
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      plan_view
  Звірити відображення поля budget.currency плану для користувача ${viewer}


Відображення id бюджету
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних плану
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      plan_view
  Звірити відображення поля budget.id плану для користувача ${viewer}


Відображення id проекту в бюджеті
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних плану
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      plan_view
  Звірити відображення поля budget.project.id плану для користувача ${viewer}


Відображення назви проекту в бюджеті
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних плану
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      plan_view
  Звірити відображення поля budget.project.name плану для користувача ${viewer}


Відображення назви організації
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних плану
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      plan_view
  Звірити відображення поля procuringEntity.name плану для користувача ${viewer}


Відображення схеми ідентифікатора організації
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних плану
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      plan_view
  Звірити відображення поля procuringEntity.identifier.scheme плану для користувача ${viewer}


Відображення ідентифікатора організації
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних плану
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      plan_view
  Звірити відображення поля procuringEntity.identifier.id плану для користувача ${viewer}


Відображення легально зареєстрованої назви організації
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних плану
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      plan_view
  Звірити відображення поля procuringEntity.identifier.legalName плану для користувача ${viewer}


Відображення опису класифікації
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних плану
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      plan_view
  Звірити відображення поля classification.description плану для користувача ${viewer}


Відображення схеми класифікації
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних плану
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      plan_view
  Звірити відображення поля classification.scheme плану для користувача ${viewer}


Відображення коду класифікації
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних плану
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      plan_view
  Звірити відображення поля classification.id плану для користувача ${viewer}


Відображення дати початку періоду подання пропозицій
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних плану
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      plan_view
  Звірити відображення поля tender.tenderPeriod.startDate плану для користувача ${viewer}


Відображення опису об'єкта
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних плану
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      plan_view  level2
  ...      non-critical
  Звірити відображення description усіх предметів плану для користувача ${viewer}


Відображення кількості необхідних одиниць об'єкта
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних плану
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      plan_view
  Звірити відображення quantity усіх предметів плану для користувача ${viewer}


Відображення кінцевої дати доставки
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних плану
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      plan_view
  Звірити відображення deliveryDate.endDate усіх предметів плану для користувача ${viewer}


Відображення коду одиниці виміру
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних плану
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      plan_view
  Звірити відображення unit.code усіх предметів плану для користувача ${viewer}


Відображення назви одиниці виміру
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних плану
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      plan_view
  Звірити відображення unit.name усіх предметів плану для користувача ${viewer}


Відображення опису класифікації об'єкта
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних плану
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      plan_view
  Звірити відображення classification.description усіх предметів плану для користувача ${viewer}


Відображення схеми класифікації об'єкта
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних плану
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      plan_view
  Звірити відображення classification.scheme усіх предметів плану для користувача ${viewer}


Відображення коду класифікації об'єкта
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних плану
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      plan_view
  Звірити відображення classification.id усіх предметів плану для користувача ${viewer}


Можливість змінити опис бюджету
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування плану
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_plan
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
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
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість додати предмет закупівлі в план


Можливість видалити предмет закупівлі
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування плану
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      delete_item
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість видалити предмет закупівлі з плану