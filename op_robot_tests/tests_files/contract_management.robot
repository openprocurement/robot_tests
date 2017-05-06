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
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
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
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
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
Можливість редагувати опис причини зміни договору
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування зміни
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_change
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_rationale}=  create_fake_sentence
  Set to dictionary  ${USERS.users['${tender_owner}']}  new_rationale=${new_rationale}
  Run As  ${tender_owner}  Редагувати зміну  ${CONTRACT_UAID}  rationale  ${new_rationale}




Можливість редагувати назву договору
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування договору
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_contract
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${title}=  create_fake_title
  Set to dictionary  ${USERS.users['${tender_owner}']}  new_title=${title}
  Run As  ${tender_owner}  Редагувати поле договору  ${CONTRACT_UAID}  title  ${title}


Можливість редагувати вартість договору
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування договору
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_contract
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${value.amount}=  create_fake_value_amount
  Set to dictionary  ${USERS.users['${tender_owner}']}  new_amount=${value.amount}
  Run As  ${tender_owner}  Редагувати поле договору  ${CONTRACT_UAID}  value.amount  ${value.amount}


Можливість редагувати дату завершення дії договору
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування договору
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_contract
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${endDate}=  create_fake_date
  Set to dictionary  ${USERS.users['${tender_owner}']}  new_endDate=${endDate}
  Run As  ${tender_owner}  Редагувати поле договору  ${CONTRACT_UAID}  period.endDate  ${endDate}


Можливість редагувати дату початку дії договору
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування договору
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_contract
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${startDate}=  create_fake_date
  ${period.startDate}=  add_minutes_to_date  ${startDate}  -20
  Set to dictionary  ${USERS.users['${tender_owner}']}  new_startDate=${period.startDate}
  Run As  ${tender_owner}  Редагувати поле договору  ${CONTRACT_UAID}  period.startDate  ${period.startDate}


Можливість застосувати зміну договору
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування договору
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      apply_change
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  ${dateSigned}=  create_fake_date
  Run As  ${tender_owner}  Застосувати зміну  ${CONTRACT_UAID}  ${dateSigned}
  Set to dictionary  ${USERS.users['${tender_owner}'].change_data.data}  status=active


Відображення відредагованого опису договору
  [Tags]   ${USERS.users['${viewer}'].broker}: Редагування договору
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view
  Звірити поле договору із значенням
  ...      ${viewer}
  ...      ${CONTRACT_UAID}
  ...      ${USERS.users['${tender_owner}'].new_description}
  ...      description


Відображення відредагованого опису причини зміни договору
  [Tags]   ${USERS.users['${viewer}'].broker}: Редагування зміни договору
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      modify_change
  Remove From Dictionary  ${USERS.users['${viewer}'].contract_data.data.changes[0]}  rationale
  Звірити поле договору із значенням
  ...      ${viewer}
  ...      ${CONTRACT_UAID}
  ...      ${USERS.users['${tender_owner}'].new_rationale}
  ...      changes[0].rationale


Відображення відредагованої назви договору
  [Tags]   ${USERS.users['${viewer}'].broker}: Редагування договору
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      modify_contract
  Звірити поле договору із значенням
  ...      ${viewer}
  ...      ${CONTRACT_UAID}
  ...      ${USERS.users['${tender_owner}'].new_title}
  ...      title


Відображення відредагованої вартості договору
  [Tags]   ${USERS.users['${viewer}'].broker}: Редагування договору
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view  level2
  Звірити поле договору із значенням
  ...     ${viewer}
  ...     ${CONTRACT_UAID}
  ...     ${USERS.users['${tender_owner}'].new_description}
  ...     description
Відображення відредагованої дати початку дії договору
  [Tags]   ${USERS.users['${viewer}'].broker}: Редагування договору
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      modify_contract
  Звірити поле договору із значенням
  ...      ${viewer}
  ...      ${CONTRACT_UAID}
  ...      ${USERS.users['${tender_owner}'].new_startDate}
  ...      period.startDate


Відображення відредагованої дати завершення дії договору
  [Tags]   ${USERS.users['${viewer}'].broker}: Редагування договору
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      modify_contract
  Звірити поле договору із значенням
  ...      ${viewer}
  ...      ${CONTRACT_UAID}
  ...      ${USERS.users['${tender_owner}'].new_endDate}
  ...      period.endDate


Відображення підтвердженого статусу зміни договору
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення зміни договору
  ...      tender_owner
  ...      ${USERS.users['${viewer}'].broker}
  Звірити поле зміни до договору із значенням
  ...     ${viewer}
  ...     ${CONTRACT_UAID}
  ...     active
  ...     status
Неможливість додати документ до зміни договору після застосування зміни
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування договору
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_change_contract_doc
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Run keyword and expect error  *  Додати документацію до зміни договору


Неможливість редагувати опис причини зміни договору після застосування зміни
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування зміни договору
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_change
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_rationale}=  create_fake_sentence
  Run keyword and expect error  *  Run As  ${tender_owner}  Редагувати зміну  ${CONTRACT_UAID}  rationale  ${new_rationale}


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


Відображення належності документа до договору
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення документації
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      add_contract_doc
  Звірити відображення поля documentOf документа ${USERS.users['${tender_owner}']['contract_doc']['id']} до договору з contract для користувача ${viewer}


Можливість вказати причини розірвання договору
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування договору
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      termination_reasons
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${terminationDetails}=  create_fake_sentence
  Run As  ${tender_owner}  Редагувати поле договору  ${CONTRACT_UAID}  terminationDetails  ${terminationDetails}


Можливість редагувати причини розірвання договору
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування договору
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      termination_reasons
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${terminationDetails}=  create_fake_sentence
  Set to dictionary  ${USERS.users['${tender_owner}']}  new_termination_details=${terminationDetails}
  Run As  ${tender_owner}  Редагувати поле договору  ${CONTRACT_UAID}  terminationDetails  ${terminationDetails}


Відображення відредагованих причин розірвання договору
  [Tags]   ${USERS.users['${viewer}'].broker}: Редагування договору
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      termination_reasons
  Звірити поле договору із значенням
  ...      ${viewer}
  ...      ${CONTRACT_UAID}
  ...      ${USERS.users['${tender_owner}'].new_termination_details}
  ...      terminationDetails


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
