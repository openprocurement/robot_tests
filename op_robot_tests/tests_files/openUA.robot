*** Settings ***
Resource        keywords.robot
Resource        resource.robot
Suite Setup     Test Suite Setup
Suite Teardown  Test Suite Teardown

*** Variables ***
${mode}         openua

${role}         viewer
${broker}       Quinta


*** Test Cases ***
Можливість оголосити понадпороговий однопредметний тендер
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      minimal
  [Documentation]   Створення закупівлі замовником, обовязково має повертати UAID закупівлі (номер тендера)
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${tender_data}=  Підготовка даних для створення тендера
  ${TENDER_UAID}=  Викликати для учасника  ${tender_owner}  Створити тендер  ${tender_data}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  initial_data  ${tender_data}
  Set To Dictionary  ${TENDER}   TENDER_UAID             ${TENDER_UAID}
  Log  ${TENDER}

Пошук позапорогового однопредметного тендера по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук тендера по ідентифікатору
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      minimal
  ${usernames}=  Create List  ${viewer}  ${tender_owner}  ${provider}  ${provider1}
  :FOR  ${username}  IN  @{usernames}
  \  Дочекатись синхронізації з майданчиком    ${username}
  \  Викликати для учасника  ${username}  Пошук тендера по ідентифікатору   ${TENDER['TENDER_UAID']}

Відображення типу закупівлі оголошеного тендер
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  procurementMethodType

Відображення початку періоду прийому пропозицій оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      minimal
  ${usernames}=  Create List  ${viewer}  ${provider}  ${provider1}
  :FOR  ${username}  IN  @{usernames}
  \  Звірити дату тендера  ${username}  ${USERS.users['${tender_owner}'].initial_data}  tenderPeriod.startDate

Відображення закінчення періоду прийому пропозицій оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      minimal
  ${usernames}=  Create List  ${viewer}  ${provider}  ${provider1}
  :FOR  ${username}  IN  @{usernames}
  \  Звірити дату тендера  ${username}  ${USERS.users['${tender_owner}'].initial_data}  tenderPeriod.endDate

Можливість подати вимогу на умови більше ніж за 10 днів до завершення періоду подання пропозицій
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість подати вимогу на умови
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  [Documentation]  Користувач ${USERS.users['${provider}'].broker} намагається подати скаргу на умови оголошеної закупівлі
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${claim}=  Підготовка даних для подання вимоги
  ${complaintID}=  Викликати для учасника  ${provider}
  ...      Створити вимогу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${claim}
  ${claim_data}=  Create Dictionary  claim=${claim}  complaintID=${complaintID}
  Set To Dictionary  ${USERS.users['${provider}']}  claim_data  ${claim_data}


  ${data}=  Create Dictionary  status=claim
  ${confirmation_data}=  Create Dictionary  data=${data}
  Викликати для учасника  ${provider}
  ...      Подати вимогу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['claim_data']['complaintID']}
  ...      ${confirmation_data}


Можливість скасувати вимогу на умови
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість скасувати скаргу на умови
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${cancellation_reason}=  create_fake_sentence
  ${data}=  Create Dictionary  status=cancelled  cancellationReason=${cancellation_reason}
  ${cancellation_data}=  Create Dictionary  data=${data}
  Викликати для учасника  ${provider}
  ...      Скасувати вимогу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['claim_data']['complaintID']}
  ...      ${cancellation_data}
  Set To Dictionary  ${USERS.users['${provider}'].claim_data}  cancellation  ${cancellation_data}

Подати цінову пропозицію першим учасником після оголошення тендеру
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість подати цінову пропозицію
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${bid}=  test bid data
  Log  ${bid}
  ${bidresponses}=  Create Dictionary
  Set To Dictionary  ${bidresponses}                 bid   ${bid}
  Set To Dictionary  ${USERS.users['${provider}']}   bidresponses  ${bidresponses}
  ${resp}=  Викликати для учасника   ${provider}   Подати цінову пропозицію   ${TENDER['TENDER_UAID']}   ${bid}
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses}   resp  ${resp}
  log  ${resp}

Подати цінову пропозицію другим учасником
  [Tags]   ${USERS.users['${provider1}'].broker}: Можливість подати цінову пропозицію
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${bid}=  test bid data
  Log  ${bid}
  ${bidresponses}=  Create Dictionary
  Set To Dictionary  ${bidresponses}                 bid   ${bid}
  Set To Dictionary  ${USERS.users['${provider1}']}   bidresponses  ${bidresponses}
  ${resp}=  Викликати для учасника   ${provider1}   Подати цінову пропозицію   ${TENDER['TENDER_UAID']}   ${bid}
  Set To Dictionary  ${USERS.users['${provider1}'].bidresponses}   resp  ${resp}
  log  ${resp}

Можливість редагувати однопредметний тендер більше ніж за 7 днів до завершення періоду подання пропозицій
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Викликати для учасника   ${tender_owner}  Внести зміни в тендер  ${TENDER['TENDER_UAID']}   description     description

Перевірити на зміну статус пропозицій після редагування інформації про закупівлю
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість змінити цінову пропозицію
  ...      provider  provider1
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ${usernames}=  Create List  ${provider}  ${provider1}
  :FOR  ${username}  IN  @{usernames}
  \  Дочекатись синхронізації з майданчиком    ${username}
  \  Викликати для учасника   ${username}   Пошук тендера по ідентифікатору   ${TENDER['TENDER_UAID']}
  \  ${bid}=  Викликати для учасника  ${username}  Отримати пропозицію  ${TENDER['TENDER_UAID']}
  \  Should Be Equal  ${bid.data.status}  invalid
  \  Log  ${bid}


Оновити статус цінової пропозиції першого учасника
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість змінити цінову пропозицію
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${activestatusresp}=  Викликати для учасника   ${provider}   Змінити цінову пропозицію   ${TENDER['TENDER_UAID']}   status  active
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses}   activestatusresp   ${activestatusresp}
  log  ${activestatusresp}

Cкасувати цінову пропозицію другого учасника
  [Tags]   ${USERS.users['${provider1}'].broker}: Можливість скасувати цінову пропозицію
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${bid}=  Get Variable Value  ${USERS.users['${provider1}'].bidresponses['resp']}
  ${bidresponses}=  Викликати для учасника   ${provider1}   Скасувати цінову пропозицію   ${TENDER['TENDER_UAID']}   ${bid}

Повторно подати цінову пропозицію другим учасником після першої зміни
  [Tags]   ${USERS.users['${provider1}'].broker}: Можливість подати цінову пропозицію
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${bid}=  test bid data
  Log  ${bid}
  ${bidresponses}=  Create Dictionary
  Set To Dictionary  ${bidresponses}                 bid   ${bid}
  Set To Dictionary  ${USERS.users['${provider1}']}   bidresponses  ${bidresponses}
  ${resp}=  Викликати для учасника   ${provider1}   Подати цінову пропозицію   ${TENDER['TENDER_UAID']}   ${bid}
  Set To Dictionary  ${USERS.users['${provider1}'].bidresponses}   resp  ${resp}
  log  ${resp}

Неможливість редагувати однопредметний тендер менше ніж за 7 днів до завершення періоду подання пропозицій
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ${no_edit_time}=  add_minutes_to_date  ${USERS.users['${tender_owner}'].tender_data.data.tenderPeriod.endDate}  -6
  Дочекатись дати  ${no_edit_time}
  Require Failure  ${tender_owner}  Внести зміни в тендер  ${TENDER['TENDER_UAID']}  description  description

Неможливість подати вимогу на умови менше ніж за 10 днів до завершення періоду подання пропозицій
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість подати вимогу на умови
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  [Documentation]  Користувач ${USERS.users['${provider}'].broker} намагається подати скаргу на умови оголошеної закупівлі
  ${claim}=  Підготовка даних для подання вимоги
  ${complaintID}=  Викликати для учасника  ${provider}
  ...      Створити вимогу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${claim}
  ${claim_data2}=  Create Dictionary  claim=${claim}  complaintID=${complaintID}
  Set To Dictionary  ${USERS.users['${provider}']}  claim_data2  ${claim_data2}


  ${data}=  Create Dictionary  status=claim
  ${confirmation_data}=  Create Dictionary  data=${data}
  Require Failure  ${provider}
  ...      Подати вимогу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['claim_data2']['complaintID']}
  ...      ${confirmation_data}


Продовжити період редагування подання пропозиції на 7 днів
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${endDate}=  add_minutes_to_date   ${USERS.users['${tender_owner}'].tender_data.data.tenderPeriod.endDate}  7
  Викликати для учасника   ${tender_owner}  Внести зміни в тендер  ${TENDER['TENDER_UAID']}   tenderPeriod.endDate     ${endDate}


Можливість подати скаргу на умови більше ніж за 4 дні до завершення періоду подання пропозицій
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість подати скаргу на умови
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  [Documentation]  Користувач ${USERS.users['${provider}'].broker} намагається подати скаргу на умови оголошеної закупівлі
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Дочекатись синхронізації з майданчиком    ${provider}
  ${claim}=  Підготовка даних для подання вимоги
  ${complaintID}=  Викликати для учасника  ${provider}
  ...      Створити вимогу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${claim}
  ${claim_data3}=  Create Dictionary  claim=${claim}  complaintID=${complaintID}
  Set To Dictionary  ${USERS.users['${provider}']}  claim_data3  ${claim_data3}

  ${data}=  Create Dictionary  status=pending  satisfied=${False}
  ${escalation_data}=  Create Dictionary  data=${data}
  Викликати для учасника  ${provider}
  ...      Перетворити вимогу в скаргу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['claim_data3']['complaintID']}
  ...      ${escalation_data}
  Set To Dictionary  ${USERS.users['${provider}'].claim_data3}  escalation  ${escalation_data}

Можливість скасувати скаргу на умови
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість скасувати скаргу на умови
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${cancellation_reason}=  create_fake_sentence
  ${data}=  Create Dictionary  status=cancelled  cancellationReason=${cancellation_reason}
  ${cancellation_data}=  Create Dictionary  data=${data}
  Викликати для учасника  ${provider}
  ...      Скасувати вимогу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['claim_data3']['complaintID']}
  ...      ${cancellation_data}
  Set To Dictionary  ${USERS.users['${provider}'].claim_data3}  cancellation  ${cancellation_data}



Можливість редагувати однопредметний тендер після продовження періоду подання пропозицій
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Викликати для учасника   ${tender_owner}  Внести зміни в тендер  ${TENDER['TENDER_UAID']}   description     description


Перевірити на зміну статус пропозицій після редагування інформації про закупівлю після другої зміни
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість змінити цінову пропозицію
  ...      provider  provider1
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ${usernames}=  Create List  ${provider}  ${provider1}
  :FOR  ${username}  IN  @{usernames}
  \  Дочекатись синхронізації з майданчиком    ${username}
  \  Викликати для учасника   ${username}   Пошук тендера по ідентифікатору   ${TENDER['TENDER_UAID']}
  \  ${bid}=  Викликати для учасника  ${username}  Отримати пропозицію  ${TENDER['TENDER_UAID']}
  \  Should Be Equal  ${bid.data.status}  invalid
  \  Log  ${bid}


Можливість оновити статус цінової пропозиції першого учасника після другої зміни
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість змінити цінову пропозицію
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${activestatusresp}=  Викликати для учасника   ${provider}   Змінити цінову пропозицію   ${TENDER['TENDER_UAID']}   status  active
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses}   activestatusresp   ${activestatusresp}
  log  ${activestatusresp}


Повторно подати цінову пропозицію другим учасником після другої зміни
  [Tags]   ${USERS.users['${provider1}'].broker}: Можливість подати цінову пропозицію
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${bid}=  test bid data
  Log  ${bid}
  ${bidresponses}=  Create Dictionary
  Set To Dictionary  ${bidresponses}                 bid   ${bid}
  Set To Dictionary  ${USERS.users['${provider1}']}   bidresponses  ${bidresponses}
  ${resp}=  Викликати для учасника   ${provider1}   Подати цінову пропозицію   ${TENDER['TENDER_UAID']}   ${bid}
  Set To Dictionary  ${USERS.users['${provider1}'].bidresponses}   resp  ${resp}
  log  ${resp}


Неможливість подати скаргу на умови менше ніж за 4 дні до завершення періоду подання пропозицій
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість подати скаргу на умови
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  [Documentation]    Користувач  ${USERS.users['${provider}'].broker}  намагається подати скаргу на умови оголошеної  закупівлі
  Log  ${USERS.users['${provider}'].tender_data.data.complaintPeriod.endDate}
  Дочекатись дати закінчення періоду подання скарг  ${provider}
  Дочекатись синхронізації з майданчиком    ${provider}
  ${claim}=  Підготовка даних для подання вимоги
  ${complaintID}=  Викликати для учасника  ${provider}
  ...      Створити вимогу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${claim}
  ${claim_data4}=  Create Dictionary  claim=${claim}  complaintID=${complaintID}
  Set To Dictionary  ${USERS.users['${provider}']}  claim_data4  ${claim_data4}


  ${data}=  Create Dictionary  status=pending  satisfied=${False}
  ${escalation_data}=  Create Dictionary  data=${data}
  Викликати для учасника  ${provider}
  ...      Перетворити вимогу в скаргу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['claim_data4']['complaintID']}
  ...      ${escalation_data}
  Set To Dictionary  ${USERS.users['${provider}'].claim_data4}  escalation  ${escalation_data}
