*** Settings ***
Resource        base_keywords.robot
Suite Setup     Test Suite Setup
Suite Teardown  Test Suite Teardown

*** Variables ***
${MODE}         planning
@{USED_ROLES}   tender_owner  provider  provider1  viewer


*** Test Cases ***
Можливість створити план закупівлі
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оголошення плану
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_plan  level1
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість створити план закупівлі


Можливість знайти план по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук плану
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      find_plan  level1
  ...      critical
  Можливість знайти план по ідентифікатору для усіх користувачів


Відображення суми бюджету для користувача
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних плану
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      plan_view  level2
  ...      non-critical
  Звірити відображення поля budget.amount плану для користувача ${viewer}


Відображення amountNet бюджету для користувача
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних плану
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      plan_view  level2
  ...      non-critical
  Звірити відображення поля budget.amountNet плану для користувача ${viewer}


Відображення опису бюджету для користувача
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних плану
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      plan_view  level2
  ...      non-critical
  Звірити відображення поля budget.description плану для користувача ${viewer}


Відображення валюти бюджету для користувача
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних плану
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      plan_view  level2
  ...      non-critical
  Звірити відображення поля budget.currency плану для користувача ${viewer}


Відображення id бюджету для користувача
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних плану
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      plan_view  level2
  ...      non-critical
  Звірити відображення поля budget.id плану для користувача ${viewer}


Відображення id проекту в бюджеті для користувача
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних плану
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      plan_view  level2
  ...      non-critical
  Звірити відображення поля budget.project.id плану для користувача ${viewer}


Відображення назви проекту в бюджеті для користувача
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних плану
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      plan_view  level2
  ...      non-critical
  Звірити відображення поля budget.project.name плану для користувача ${viewer}


Відображення назви організації
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних плану
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      plan_view  level2
  ...      non-critical
  Звірити відображення поля procuringEntity.name плану для користувача ${viewer}


Відображення схеми ідентифікатора організації
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних плану
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      plan_view  level2
  ...      non-critical
  Звірити відображення поля procuringEntity.identifier.scheme плану для користувача ${viewer}


Відображення ідентифікатора організації
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних плану
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      plan_view  level2
  ...      non-critical
  Звірити відображення поля procuringEntity.identifier.id плану для користувача ${viewer}


Відображення легально зареєстрованої назви організації
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних плану
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      plan_view  level2
  ...      non-critical
  Звірити відображення поля procuringEntity.identifier.legalName плану для користувача ${viewer}


Відображення опису класифікації
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних плану
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      plan_view  level2
  ...      non-critical
  Звірити відображення поля classification.description плану для користувача ${viewer}


Відображення схеми класифікації
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних плану
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      plan_view  level2
  ...      non-critical
  Звірити відображення поля classification.scheme плану для користувача ${viewer}


Відображення коду класифікації
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних плану
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      plan_view  level2
  ...      non-critical
  Звірити відображення поля classification.id плану для користувача ${viewer}


Відображення дати початку періоду подання пропозицій
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних плану
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      plan_view  level2
  ...      non-critical
  Звірити відображення поля tender.tenderPeriod.startDate плану для користувача ${viewer}


Відображення опису об'єкта
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних плану
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      plan_view  level2
  ...      non-critical
  Звірити відображення поля items.[-1].description плану для користувача ${viewer}


Відображення кількості необхідних одиниць об'єкта
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних плану
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      plan_view  level2
  ...      non-critical
  Звірити відображення поля items.[-1].quantity плану для користувача ${viewer}


Відображення кінцевої дати доставки
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних плану
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      plan_view  level2
  ...      non-critical
  Звірити відображення поля items.[-1].deliveryDate.endDate плану для користувача ${viewer}


Відображення коду одиниці виміру
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних плану
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      plan_view  level2
  ...      non-critical
  Звірити відображення поля items.[-1].unit.code плану для користувача ${viewer}


Відображення назви одиниці виміру
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних плану
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      plan_view  level2
  ...      non-critical
  Звірити відображення поля items.[-1].unit.name плану для користувача ${viewer}


Відображення опису класифікації об'єкта
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних плану
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      plan_view  level2
  ...      non-critical
  Звірити відображення поля items.[-1].classification.description плану для користувача ${viewer}


Відображення схеми класифікації об'єкта
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних плану
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      plan_view  level2
  ...      non-critical
  Звірити відображення поля items.[-1].classification.scheme плану для користувача ${viewer}


Відображення коду класифікації об'єкта
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних плану
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      plan_view  level2
  ...      non-critical
  Звірити відображення поля items.[-1].classification.id плану для користувача ${viewer}


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
  ${value}=  Convert To Number  9999999
  ${new_amount}=  create_fake_amount  ${value}
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
  ${value}=  Convert To Number  99
  ${new_quantity}=  create_fake_amount  ${value}
  Можливість змінити поле items[0].quantity плану на ${new_quantity}