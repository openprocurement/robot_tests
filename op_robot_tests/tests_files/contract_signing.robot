*** Settings ***
Resource        base_keywords.robot
Suite Setup     Test Suite Setup
Suite Teardown  Test Suite Teardown

*** Variables ***
@{USED_ROLES}   tender_owner  viewer


*** Test Cases ***
Можливість знайти закупівлю по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук тендера
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      find_tender  level1
  Завантажити дані про тендер
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \   Run As  ${username}  Пошук тендера по ідентифікатору  ${TENDER['TENDER_UAID']}

##############################################################################################
#             CONTRACT
##############################################################################################

Відображення закінчення періоду подачі скарг на пропозицію
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Відображення основних даних тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      tender_view
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \  Отримати дані із тендера  ${username}  ${TENDER['TENDER_UAID']}  awards[1].complaintPeriod.endDate


Дочекатися закічення stand still періоду
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Процес укладання угоди
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      contract_sign
  ${standstillEnd}=  Get Variable Value  ${USERS.users['${tender_owner}'].tender_data.data.awards[1].complaintPeriod.endDate}
  Дочекатись дати  ${standstillEnd}


Відображення вартості угоди
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних угоди
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      contract_view
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Отримати дані із поля awards[1].value.amount тендера для користувача ${viewer}


Можливість редагувати вартість угоди
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування угоди
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_contract
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${award_amount}=  Get From Dictionary  ${USERS.users['${viewer}'].tender_data.data.awards[1].value}  amount
  ${amount}=  create_fake_amount  ${award_amount}
  Set to dictionary  ${USERS.users['${tender_owner}']}  new_amount=${amount}
  Run As  ${tender_owner}  Редагувати угоду  ${TENDER['TENDER_UAID']}  1  value.amount  ${amount}


Відображення відредагованої вартості угоди
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних угоди
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      contract_view
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Remove From Dictionary  ${USERS.users['${viewer}'].tender_data.data.contracts[1].value}  amount
  Звірити відображення поля contracts[1].value.amount тендера із ${USERS.users['${tender_owner}'].new_amount} для користувача ${viewer}


Можливість встановити дату підписання угоди
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування угоди
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_contract
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${dateSigned}=  create_fake_date
  Set to dictionary  ${USERS.users['${tender_owner}']}  dateSigned=${dateSigned}
  Run As  ${tender_owner}  Встановити дату підписання угоди  ${TENDER['TENDER_UAID']}  1  ${dateSigned}


Відображення дати підписання угоди
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних угоди
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      contract_view
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля contracts[1].dateSigned тендера із ${USERS.users['${tender_owner}'].dateSigned} для користувача ${viewer}


Можливість вказати період дії угоди
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування угоди
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_contract
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${startDate}=  create_fake_date
  ${endDate}=  add_minutes_to_date  ${startDate}  10
  Set to dictionary  ${USERS.users['${tender_owner}']}  contract_startDate=${startDate}  contract_endDate=${endDate}
  Run As  ${tender_owner}  Вказати період дії угоди  ${TENDER['TENDER_UAID']}  1  ${startDate}  ${endDate}


Відображення дати початку дії угоди
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних угоди
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      contract_view
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля contracts[1].period.startDate тендера із ${USERS.users['${tender_owner}'].contract_startDate} для користувача ${viewer}


Відображення дати завершення дії угоди
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних угоди
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      contract_view
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля contracts[1].period.endDate тендера із ${USERS.users['${tender_owner}'].contract_endDate} для користувача ${viewer}


Можливість завантажити документацію в угоду
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Завантаження документації в угоду
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_doc_to_contract
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість завантажити документ в 1 угоду користувачем ${tender_owner}


Відображення заголовку документа
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення документації
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      add_doc_to_contract
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля title документа ${USERS.users['${tender_owner}']['contract_doc']['id']} із ${USERS.users['${tender_owner}']['contract_doc']['name']} для користувача ${viewer}


Відображення вмісту документа
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення документації
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      add_doc_to_contract
  Звірити відображення вмісту документа ${USERS.users['${tender_owner}']['contract_doc']['id']} із ${USERS.users['${tender_owner}']['contract_doc']['content']} для користувача ${viewer}


Відображення прив'язки документа до тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення документації
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      add_doc_to_contract
  Звірити відображення поля documentOf документа ${USERS.users['${tender_owner}']['contract_doc']['id']} із tender для користувача ${viewer}


Можливість укласти угоду для закупівлі
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Процес укладання угоди
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      contract_sign  level1
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Run As  ${tender_owner}  Підтвердити підписання контракту  ${TENDER['TENDER_UAID']}  1


Відображення статусу підписаної угоди з постачальником закупівлі
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних угоди
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      contract_sign
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Run As  ${viewer}  Оновити сторінку з тендером  ${TENDER['TENDER_UAID']}
  Звірити відображення поля contracts[1].status тендера із active для користувача ${viewer}
