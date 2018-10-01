*** Settings ***
Resource        base_keywords.robot
Suite Setup     Test Suite Setup
Suite Teardown  Test Suite Teardown

*** Variables ***
@{used_roles}  viewer  tender_owner  provider
${MODE}  contracts


*** Test Cases ***
Можливість активувати договір
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Отримання прав доступу до договору
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      activate_contract
  [Setup]  Завантажити дані про тендер
  Дочекатись синхронізації з майданчиком  ${tender_owner}
  Run As  ${tender_owner}  Активувати контракт  ${CONTRACT_UAID}


Можливість знайти договір по ідентифікатору
  [Tags]   ${USERS.users['${provider}'].broker}: Пошук договору
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      find_contract
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  Run As  ${provider}  Пошук договору по ідентифікатору  ${CONTRACT_UAID}


Відображення опису активу
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних договору
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      contract_view_description
  Отримати дані із поля description активу в контракті для усіх користувачів


Відображення статусу 'Очікується оплата'
  [Tags]   ${USERS.users['${provider}'].broker}: Відображення основних даних договору
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      active_payment_status
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  Remove From Dictionary  ${USERS.users['${provider}'].contract_data.data}  status
  Звірити поле договору із значенням
  ...      ${provider}
  ...      ${CONTRACT_UAID}
  ...      active.payment
  ...      status


Можливість вказати дату отримання оплати в межах визначеного терміну
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування договору
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      first_milestone_met
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${dateMet}=  create_fake_date
  Run As  ${tender_owner}  Вказати дату отримання оплати  ${CONTRACT_UAID}  ${dateMet}  0


Відображення статусу 'Виконано' для першого майлстоуну
  [Tags]   ${USERS.users['${provider}'].broker}: Відображення основних даних договору
  ...      tender_owner
  ...      ${USERS.users['${provider}'].broker}
  ...      first_milestone_met
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  Remove From Dictionary  ${USERS.users['${provider}'].contract_data.data.milestones[0]}  status
  Звірити поле договору із значенням
  ...      ${provider}
  ...      ${CONTRACT_UAID}
  ...      met
  ...      milestones[0].status


Можливість вказати дату отримання оплати після кінцевої дати
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування договору
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      first_milestone_partiallyMet
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${dueDate}=  Отримати дані із договору  ${provider}  ${CONTRACT_UAID}  milestones[0].dueDate
  ${dateMet}=  create_fake_dateMet  ${dueDate}
  Run As  ${tender_owner}  Вказати дату отримання оплати  ${CONTRACT_UAID}  ${dateMet}  0


Відображення статусу 'Частково виконано' для першого майлстоуну
  [Tags]   ${USERS.users['${provider}'].broker}: Відображення основних даних договору
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      first_milestone_partiallyMet
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  Remove From Dictionary  ${USERS.users['${provider}'].contract_data.data.milestones[0]}  status
  Звірити поле договору із значенням
  ...      ${provider}
  ...      ${CONTRACT_UAID}
  ...      partiallyMet
  ...      milestones[0].status


Відображення статусу 'Договір оплачено.Очікується наказ'
  [Tags]   ${USERS.users['${provider}'].broker}: основних даних договору
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      active_approval_status
  Remove From Dictionary  ${USERS.users['${provider}'].contract_data.data}  status
  Звірити поле договору із значенням
  ...      ${provider}
  ...      ${CONTRACT_UAID}
  ...      active.approval
  ...      status


Можливіть зазначити відстуність оплати
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування договору
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      first_milestone_notMet
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Run As  ${tender_owner}  Підтвердити відсутність оплати  ${CONTRACT_UAID}  0


Відображення стaтусу 'Не виконано' для першого майлстоуна
  [Tags]   ${USERS.users['${provider}'].broker}: Відображення основних даних договору
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      first_milestone_notMet
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  Remove From Dictionary  ${USERS.users['${provider}'].contract_data.data.milestones[0]}  status
  Звірити поле договору із значенням
  ...      ${provider}
  ...      ${CONTRACT_UAID}
  ...      notMet
  ...      milestones[0].status


Можливість завантажити наказ про завершення приватизації
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування договору
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      second_milestone_approvalProtocol
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${file_path}  ${file_title}  ${file_content}=  create_fake_doc
  Run As  ${tender_owner}  Завантажити наказ про завершення приватизації  ${CONTRACT_UAID}  ${file_path}
  Remove File  ${file_path}


Можливість вказати дату прийняття наказу в межах визначеного терміну
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування договору
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      second_milestone_met
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${dateMet}=  create_fake_date
  Run As  ${tender_owner}  Вказати дату прийняття наказу  ${CONTRACT_UAID}  ${dateMet}


Відображення статусу 'Виконано' для другого майлстоуну
  [Tags]   ${USERS.users['${provider}'].broker}: Відображення основних даних договору
  ...      tender_owner
  ...      ${USERS.users['${provider}'].broker}
  ...      second_milestone_met
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  Remove From Dictionary  ${USERS.users['${provider}'].contract_data.data.milestones[1]}  status
  Звірити поле договору із значенням
  ...      ${provider}
  ...      ${CONTRACT_UAID}
  ...      met
  ...      milestones[1].status


Можливість вказати дату прийняття наказу після дати виконання умов приватизації
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування договору
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      second_milestone_partiallyMet
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${dueDate}=  Отримати дані із договору  ${provider}  ${CONTRACT_UAID}  milestones[1].dueDate
  ${dateMet}=  create_fake_dateMet  ${dueDate}
  Run As  ${tender_owner}  Вказати дату прийняття наказу  ${CONTRACT_UAID}  ${dateMet}


Відображення статусу 'Частково виконано' для другого майлстоуну
  [Tags]   ${USERS.users['${provider}'].broker}: Відображення основних даних договору
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      second_milestone_partiallyMet
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  Remove From Dictionary  ${USERS.users['${provider}'].contract_data.data.milestones[1]}  status
  Звірити поле договору із значенням
  ...      ${provider}
  ...      ${CONTRACT_UAID}
  ...      partiallyMet
  ...      milestones[1].status


Відображення статусу договору в період оскарження рішення про приватизацію
  [Tags]   ${USERS.users['${provider}'].broker}: Відображення основних даних договору
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      active_status
  Remove From Dictionary  ${USERS.users['${provider}'].contract_data.data}  status
  Звірити поле договору із значенням
  ...      ${provider}
  ...      ${CONTRACT_UAID}
  ...      active
  ...      status


Можливість підтвердити відсутність наказу про приватизацію
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування договору
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      second_milestone_notMet
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${file_path}  ${file_title}  ${file_content}=  create_fake_doc
  Run As  ${tender_owner}  Підтвердити відсутність наказу про приватизацію  ${CONTRACT_UAID}  ${file_path}
  Remove File  ${file_path}


Відображення стaтусу 'Не виконано' для другого майлстоуна
  [Tags]   ${USERS.users['${provider}'].broker}: Відображення основних даних договору
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      second_milestone_notMet
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  Remove From Dictionary  ${USERS.users['${provider}'].contract_data.data.milestones[1]}  status
  Звірити поле договору із значенням
  ...      ${provider}
  ...      ${CONTRACT_UAID}
  ...      notMet
  ...      milestones[1].status


Можливість вказати дату виконання умов контракту в межах дати виконання умов приватизації
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування договору
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      third_milestone_met
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${dateMet}=  create_fake_date
  Run As  ${tender_owner}  Вказати дату виконання умов контракту  ${CONTRACT_UAID}  ${dateMet}


Відображення статусу 'Виконано' для третього майлстоуну
  [Tags]   ${USERS.users['${provider}'].broker}: Відображення основних даних договору
  ...      tender_owner
  ...      ${USERS.users['${provider}'].broker}
  ...      third_milestone_met
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  Remove From Dictionary  ${USERS.users['${provider}'].contract_data.data.milestones[2]}  status
  Звірити поле договору із значенням
  ...      ${provider}
  ...      ${CONTRACT_UAID}
  ...      met
  ...      milestones[2].status


Можливість вказати дату виконання учасником усіх умов контракту після дати виконання умов приватизації
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування договору
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      third_milestone_partiallyMet
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${dueDate}=  Отримати дані із договору  ${provider}  ${CONTRACT_UAID}  milestones[2].dueDate
  ${dateMet}=  create_fake_dateMet  ${dueDate}
  Run As  ${tender_owner}  Вказати дату виконання умов контракту  ${CONTRACT_UAID}  ${dateMet}


Відображення статусу 'Частково виконано' для третього майлстоуну
  [Tags]   ${USERS.users['${provider}'].broker}: Відображення основних даних договору
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      third_milestone_partiallyMet
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  Remove From Dictionary  ${USERS.users['${provider}'].contract_data.data.milestones[2]}  status
  Звірити поле договору із значенням
  ...      ${provider}
  ...      ${CONTRACT_UAID}
  ...      partiallyMet
  ...      milestones[2].status


Відображення статусу 'Приватизація об’єкта завершена'
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних договору
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      terminated_status
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити статус контракту
  ...      ${viewer}
  ...      ${CONTRACT_UAID}
  ...      terminated


Можливість зазначити, що умови приватизації не виконано
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування договору
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      third_milestone_notMet
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Run As  ${tender_owner}  Підтвердити невиконання умов приватизації  ${CONTRACT_UAID}


Відображення стaтусу 'Не виконано' для третього майлстоуна
  [Tags]   ${USERS.users['${provider}'].broker}: Відображення основних даних договору
  ...      ${USERS.users['${provider}'].broker}
  ...      third_milestone_notMet
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  Remove From Dictionary  ${USERS.users['${provider}'].contract_data.data.milestones[2]}  status
  Звірити поле договору із значенням
  ...      ${provider}
  ...      ${CONTRACT_UAID}
  ...      notMet
  ...      milestones[2].status


Відображення статусу 'Приватизація об’єкта неуспішна'
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних договору
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      unsuccessful_status
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити статус контракту
  ...      ${viewer}
  ...      ${CONTRACT_UAID}
  ...      unsuccessful
