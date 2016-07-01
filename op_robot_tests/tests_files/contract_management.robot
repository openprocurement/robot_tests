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


Можливість внести зміну до договору
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування договору
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${change_data}=  Підготувати дані про зміну до контракту  ${tender_owner}
  Run As  ${tender_owner}  Внести зміну в договір  ${CONTRACT_UAID}  ${change_data}


Відображення пояснення причини створення зміни договору
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення зміни договору
  ...      tender_owner
  ...      ${USERS.users['${viewer}'].broker}
  Звірити відображення поля rationale зміни до договору для користувача ${viewer}


Відображення причин зміни договору
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення зміни договору
  ...      tender_owner
  ...      ${USERS.users['${viewer}'].broker}
  # here we need to receive list of rationale types from broker
  ${rationale_types_from_broker}=  Run as  ${viewer}  Отримати інформацію із договору  ${CONTRACT_UAID}  changes[0].rationaleTypes
  ${rationale_types_from_robot}=  Get variable value  ${USERS.users['${tender_owner}'].change_data.data.rationaleTypes}
  Log  ${rationale_types_from_broker}
  Log  ${rationale_types_from_robot}
  ${result}=  compare_rationale_types  ${rationale_types_from_broker}  ${rationale_types_from_robot}
  Run keyword if  ${result} == ${False}  Fail  Rationale types are not equal


Відображення пояснення причини зміни договору англійською мовою
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення зміни договору
  ...      tender_owner
  ...      ${USERS.users['${viewer}'].broker}
  Звірити відображення поля rationale_en зміни до договору для користувача ${viewer}


Відображення пояснення причини зміни договору російською мовою
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення зміни договору
  ...      tender_owner
  ...      ${USERS.users['${viewer}'].broker}
  Звірити відображення поля rationale_ru зміни до договору для користувача ${viewer}


Відображення непідтвердженого статусу зміни договору
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення зміни договору
  ...      tender_owner
  ...      ${USERS.users['${viewer}'].broker}
   Звірити поле зміни до договору із значенням
  ...     ${viewer}
  ...     ${CONTRACT_UAID}
  ...     pending
  ...     status


Можливість додати документацію до зміни договору
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування договору
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${document}=  create_fake_doc
  Set to dictionary  ${USERS.users['${tender_owner}']}  change_document=${document}
  Run As  ${tender_owner}  Додати документацію до зміни в договорі  ${CONTRACT_UAID}  ${document}


Відображення заголовку документації до зміни договору
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення документації
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      add_contract_doc  level2
  Звірити відображення поля documents[0].title договору із ${USERS.users['${tender_owner}']['change_document']} для користувача ${viewer}


Відображення належності документа до зміни договору
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення документації
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      add_contract_doc  level2
  Звірити відображення поля documents[0].documentOf договору із change для користувача ${viewer}


Можливість редагувати договір
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування договору
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${description}=  create_fake_sentence
  Set to dictionary  ${USERS.users['${tender_owner}']}  new_description=${description}
  Run As  ${tender_owner}  Редагувати договір  ${CONTRACT_UAID}  description  ${description}


Можливість застосувати зміну договору
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування договору
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Run As  ${tender_owner}  Застосувати зміну  ${CONTRACT_UAID}
  Set to dictionary  ${USERS.users['${tender_owner}'].change_data.data}  status=active


Відображення зміненого опису договору
  [Tags]   ${USERS.users['${viewer}'].broker}: Редагування договору
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view  level2
  Звірити поле договору із значенням
  ...     ${viewer}
  ...     ${CONTRACT_UAID}
  ...     ${USERS.users['${tender_owner}'].new_description}
  ...     description


Відображення підтвердженого статусу зміни договору
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення зміни договору
  ...      tender_owner
  ...      ${USERS.users['${viewer}'].broker}
  Звірити поле зміни до договору із значенням
  ...     ${viewer}
  ...     ${CONTRACT_UAID}
  ...     active
  ...     status


Можливість завантажити документацію до договору
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Додання документації до договору
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${document}=  create_fake_doc
  Set to dictionary  ${USERS.users['${tender_owner}']}  contract_document=${document}
  Run As  ${tender_owner}  Завантажити документацію до договору  ${CONTRACT_UAID}  ${document}


Відображення заголовку документації до договору
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення документації
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      add_contract_doc  level2
  Звірити відображення поля documents[1].title договору із ${USERS.users['${tender_owner}']['contract_document']} для користувача ${viewer}


Можливість завершити договір
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Завершення договору
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${amount}=  Get variable value  ${USERS.users['${tender_owner}'].contract_data.data.value.amount}
  ${data}=  Create Dictionary  status=terminated
  ${amountPaid}=  Create Dictionary  amount=${amount}  valueAddedTaxIncluded=${True}  currency=UAH
  ${data}=  Create Dictionary  data=${data}
  Set to dictionary  ${data.data}  amountPaid=${amountPaid}
  Set to dictionary  ${USERS.users['${tender_owner}']}  terminating_data=${data}
  Run As  ${tender_owner}  Завершити договір  ${CONTRACT_UAID}  ${data}


Відображення обсягу дійсно оплаченої суми в договорі
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних договору
  ...      tender_owner
  ...      ${USERS.users['${viewer}'].broker}
  Звірити відображення поля amountPaid.amount договору із ${USERS.users['${tender_owner}']['terminating_data'].data.amountPaid.amount} для користувача ${tender_owner}


Відображення врахованого ПДВ в дійсно оплачену суму в договорі
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних договору
  ...      tender_owner
  ...      ${USERS.users['${viewer}'].broker}
  Звірити відображення поля amountPaid.valueAddedTaxIncluded договору із ${USERS.users['${tender_owner}']['terminating_data'].data.amountPaid.valueAddedTaxIncluded} для користувача ${tender_owner}


Відображення валюти дійсно оплааченої суми в договорі
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних договору
  ...      tender_owner
  ...      ${USERS.users['${viewer}'].broker}
  Звірити відображення поля amountPaid.currency договору із ${USERS.users['${tender_owner}']['terminating_data'].data.amountPaid.currency} для користувача ${tender_owner}
