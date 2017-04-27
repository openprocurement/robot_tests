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
  ${CONTRACT_UAID}=  Get variable value  ${USERS.users['${tender_owner}'].tender_data.data.contracts[1].contractID}
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
  ${change_data}=  Підготувати дані про зміну до договору  ${tender_owner}
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
  Звірити відображення причин зміни договору


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
  Додати документацію до зміни договору


Відображення заголовку документації до зміни договору
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення документації
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      add_contract_doc  level2
  Звірити відображення поля title документа ${USERS.users['${tender_owner}']['change_doc']['id']} до договору з ${USERS.users['${tender_owner}']['change_doc']['name']} для користувача ${viewer}


Відображення належності документа до зміни договору
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення документації
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      add_contract_doc  level2
  Звірити відображення поля documentOf документа ${USERS.users['${tender_owner}']['change_doc']['id']} до договору з change для користувача ${viewer}


Відображення вмісту документації до зміни договору
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення документації
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      add_contract_doc  level2
  Звірити відображення вмісту документа ${USERS.users['${tender_owner}']['change_doc']['id']} до договору з ${USERS.users['${tender_owner}']['change_doc']['content']} для користувача ${viewer}


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
  Додати документацію до договору


Відображення заголовку документації до договору
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення документації
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      add_contract_doc  level2
  Звірити відображення поля title документа ${USERS.users['${tender_owner}']['contract_doc']['id']} до договору з ${USERS.users['${tender_owner}']['contract_doc']['name']} для користувача ${viewer}


Відображення вмісту документації до договору
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення документації
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      add_contract_doc  level2
  Звірити відображення вмісту документа ${USERS.users['${tender_owner}']['contract_doc']['id']} до договору з ${USERS.users['${tender_owner}']['contract_doc']['content']} для користувача ${viewer}


Можливість завершити договір
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Завершення договору
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Закінчити договір


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
