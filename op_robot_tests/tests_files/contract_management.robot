*** Settings ***
Resource        keywords.robot
Resource        resource.robot
Resource        base_keywords.robot
Suite Setup     Test Suite Setup
Suite Teardown  Test Suite Teardown

*** Variables ***
@{used_roles}  tender_owner  viewer


*** Test Cases ***
Можливість знайти закупівлю по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук тендера
  ...      ${USERS.users['${tender_owner}'].broker}: Пошук тендера
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  Завантажити дані про тендер
  :FOR  ${username}  in  @{used_roles}
  \  Run As  ${${username}}  Пошук тендера по ідентифікатору  ${TENDER['TENDER_UAID']}
  ${CONTRACT_UAID}=  Get variable value  ${USERS.users['${tender_owner}'].tender_data.data.contracts[0].contractID}
  Set Suite Variable  ${CONTRACT_UAID}


Можливість знайти договір по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук договору
  ...      ${USERS.users['${tender_owner}'].broker}: Пошук договору
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  :FOR  ${username}  IN  @{used_roles}
  \  Run As  ${${username}}  Пошук договору по ідентифікатору  ${CONTRACT_UAID}


Можливість отримати доступ до договору
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Отримання прав доступу до договору
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  Run As  ${tender_owner}  Отримати доступ до договору  ${CONTRACT_UAID}


Можливість внести зміни до договору
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування договору
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ${change_data}=  Підготувати дані про зміну до контракту  ${tender_owner}
  Run As  ${tender_owner}  Внести зміну в договір  ${CONTRACT_UAID}  ${change_data}


Можливість додати документацію до зміни в договорі
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування договору
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ${document}=  create_fake_doc
  Run As  ${tender_owner}  Додати документацію до зміни в договорі  ${CONTRACT_UAID}  ${document}


Можливість редагувати договір
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування договору
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ${description}=  create_fake_sentence
  Run As  ${tender_owner}  Редагувати договір  ${CONTRACT_UAID}  description  ${description}


Можливість застосувати зміну
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування договору
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  Run As  ${tender_owner}  Застосувати зміну  ${CONTRACT_UAID}


Можливість завантажити документацію до договору
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Додання документації до договору
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ${document}=  create_fake_doc
  Run As  ${tender_owner}  Завантажити документацію до договору  ${CONTRACT_UAID}  ${document}


Можливість завершити договір
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Завершення договору
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  Log  ${USERS.users['${tender_owner}'].contract_data}
  ${amount}=  Get variable value  ${USERS.users['${tender_owner}'].contract_data.data.value.amount}
  Run As  ${tender_owner}  Завершити договір  ${CONTRACT_UAID}  ${amount}
