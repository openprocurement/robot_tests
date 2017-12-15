*** Settings ***
Resource        base_keywords.robot
Suite Setup     Test Suite Setup
Suite Teardown  Test Suite Teardown

*** Variables ***
@{USED_ROLES}   tender_owner  viewer


*** Test Cases ***
Possibility to find a procurement by identificator
  [Tags]   ${USERS.users['${viewer}'].broker}: Tender search
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      find_tender  level1
  Завантажити дані про тендер
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \   Run As  ${username}  Пошук тендера по ідентифікатору  ${TENDER['TENDER_UAID']}

##############################################################################################
#             CONTRACT
##############################################################################################

Displaying of complaint period end date
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Displaying of main tender data
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      tender_view
  ${award_index}=  Отримати останній індекс  awards  ${viewer}
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \  Отримати дані із тендера  ${username}  ${TENDER['TENDER_UAID']}  awards[${award_index}].complaintPeriod.endDate


Possibility to wait until stand-still period end date
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Contract signing process
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      contract_sign
  ${award_index}=  Отримати останній індекс  awards  ${viewer}
  ${standstillEnd}=  Get Variable Value  ${USERS.users['${tender_owner}'].tender_data.data.awards[${award_index}].complaintPeriod.endDate}
  Дочекатись дати  ${standstillEnd}


Displaying of contract value amount
  [Tags]   ${USERS.users['${viewer}'].broker}: Displaying of main contract data
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      contract_view
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  ${award_index}=  Отримати останній індекс  awards  ${viewer}
  Отримати дані із поля awards[${award_index}].value.amount тендера для користувача ${viewer}


Impossibility to edit contract value amount
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Contract editing
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_contract
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_amount}=  create_fake_value_amount
  Неможливість змінити поле value.amount договору на значення ${new_amount}


Impossibility to edit contract amount performance value
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Contract editing
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_contract
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_amountPerformance}=  create_fake_value_amount
  Неможливість змінити поле value.amountPerformance договору на значення ${new_amountPerformance}


Impossibility to edit contract annual costs reduction value
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Contract editing
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_contract
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_annualCostsReduction}=  create_fake_21_amount
  Неможливість змінити поле value.annualCostsReduction договору на значення ${new_annualCostsReduction}


Impossibility to edit contract duration days
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Contract editing
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_contract
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_contractDuration_days}=  create_fake_amount  364
  ${new_contractDuration_days}=  Convert To Integer  ${new_contractDuration_days}
  Неможливість змінити поле value.contractDuration.days договору на значення ${new_contractDuration_days}


Impossibility to edit contract duration years
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Contract editing
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_contract
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_contractDuration_years}=  create_fake_amount  15
  ${new_contractDuration_years}=  Convert To Integer  ${new_contractDuration_years}
  Неможливість змінити поле value.contractDuration.years договору на значення ${new_contractDuration_years}


Possibility to define contract signing date
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Contract editing
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_contract
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${contract_index}=  Отримати останній індекс  contracts  ${viewer}
  ${dateSigned}=  create_fake_date
  Set to dictionary  ${USERS.users['${tender_owner}']}  dateSigned=${dateSigned}
  Run As  ${tender_owner}  Встановити дату підписання угоди  ${TENDER['TENDER_UAID']}  ${contract_index}  ${dateSigned}


Displaying of contract signing date
  [Tags]   ${USERS.users['${viewer}'].broker}: Displaying of main contract data
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      contract_view
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  ${contract_index}=  Отримати останній індекс  contracts  ${viewer}
  Звірити відображення поля contracts[${contract_index}].dateSigned тендера із ${USERS.users['${tender_owner}'].dateSigned} для користувача ${viewer}


Possibility to indicate contract duration period
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Contract editing
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_contract
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${contract_index}=  Отримати останній індекс  contracts  ${viewer}
  ${startDate}=  create_fake_date
  ${endDate}=  add_minutes_to_date  ${startDate}  10
  Set to dictionary  ${USERS.users['${tender_owner}']}  contract_startDate=${startDate}  contract_endDate=${endDate}
  Run As  ${tender_owner}  Вказати період дії угоди  ${TENDER['TENDER_UAID']}  ${contract_index}  ${startDate}  ${endDate}


Displaying of contract period start date
  [Tags]   ${USERS.users['${viewer}'].broker}: Displaying of main contract data
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      contract_view
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  ${contract_index}=  Отримати останній індекс  contracts  ${viewer}
  Звірити відображення поля contracts[${contract_index}].period.startDate тендера із ${USERS.users['${tender_owner}'].contract_startDate} для користувача ${viewer}


Displaying of contract period end date
  [Tags]   ${USERS.users['${viewer}'].broker}: Displaying of main contract data
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      contract_view
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  ${contract_index}=  Отримати останній індекс  contracts  ${viewer}
  Звірити відображення поля contracts[${contract_index}].period.endDate тендера із ${USERS.users['${tender_owner}'].contract_endDate} для користувача ${viewer}


Possibility to upload documentation to a contract
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Documentation uploading to contract
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_doc_to_contract
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${contract_index}=  Отримати останній індекс  contracts  ${viewer}
  Можливість завантажити документ в ${contract_index} угоду користувачем ${tender_owner}


Displaying of document title
  [Tags]   ${USERS.users['${viewer}'].broker}: Displaying of documentation
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      add_doc_to_contract
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля title документа ${USERS.users['${tender_owner}']['contract_doc']['id']} із ${USERS.users['${tender_owner}']['contract_doc']['name']} для користувача ${viewer}


Displaying of document content
  [Tags]   ${USERS.users['${viewer}'].broker}: Displaying of documentation
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      add_doc_to_contract
  Звірити відображення вмісту документа ${USERS.users['${tender_owner}']['contract_doc']['id']} із ${USERS.users['${tender_owner}']['contract_doc']['content']} для користувача ${viewer}


Displaying of document relation to a tender
  [Tags]   ${USERS.users['${viewer}'].broker}: Displaying of documentation
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      add_doc_to_contract
  Звірити відображення поля documentOf документа ${USERS.users['${tender_owner}']['contract_doc']['id']} із tender для користувача ${viewer}


Possibility to sign a procurement contract
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Contract signing process
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      contract_sign  level1
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${contract_index}=  Отримати останній індекс  contracts  ${viewer}
  Run As  ${tender_owner}  Підтвердити підписання контракту  ${TENDER['TENDER_UAID']}  ${contract_index}


Displaying of the status of contract signed with a provider
  [Tags]   ${USERS.users['${viewer}'].broker}: Displaying of main contract data
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      contract_sign
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  ${contract_index}=  Отримати останній індекс  contracts  ${viewer}
  Run As  ${viewer}  Оновити сторінку з тендером  ${TENDER['TENDER_UAID']}
  Звірити відображення поля contracts[${contract_index}].status тендера із active для користувача ${viewer}
