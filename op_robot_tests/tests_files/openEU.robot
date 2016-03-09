*** Settings ***
Resource        keywords.robot
Resource        resource.robot
Suite Setup     Test Suite Setup
Suite Teardown  Test Suite Teardown

*** Variables ***
${mode}         openeu

${role}         viewer
${broker}       Quinta


*** Test Cases ***
Можливість оголосити понадпороговий однопредметний тендер
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      minimal
  [Documentation]   Створення закупівлі замовником, обовязково має повертати UAID закупівлі (номер тендера)
  ${tender_data}=  Підготовка даних для створення тендера
  ${TENDER_UAID}=  Викликати для учасника  ${tender_owner}  Створити тендер  ${tender_data}
  ${LAST_MODIFICATION_DATE}=  Get Current TZdate
  Set To Dictionary  ${USERS.users['${tender_owner}']}  initial_data  ${tender_data}
  Set To Dictionary  ${TENDER}   TENDER_UAID             ${TENDER_UAID}
  Set To Dictionary  ${TENDER}   LAST_MODIFICATION_DATE  ${LAST_MODIFICATION_DATE}
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

Відображення закінчення періоду подання скарг на оголошений тендер
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      minimal
  ${usernames}=  Create List  ${viewer}  ${provider}  ${provider1}
  :FOR  ${username}  IN  @{usernames}
  \  Викликати для учасника  ${username}  Отримати інформацію із тендера  complaintPeriod.endDate

Можливість подати вимогу на умови більше ніж за 10 днів до завершення періоду подання пропозицій
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість подати вимогу на умови
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  [Documentation]  Користувач ${USERS.users['${provider}'].broker} намагається подати скаргу на умови оголошеної закупівлі
  ${claim}=  Підготовка даних для подання вимоги
  ${claim_resp}=  Викликати для учасника  ${provider}
  ...      Створити вимогу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${claim}
  ${claim_data}=  Create Dictionary  claim=${claim}  claim_resp=${claim_resp}
  Set To Dictionary  ${USERS.users['${provider}']}  claim_data  ${claim_data}

  ${confrimation_data}=  test_submit_claim_data  ${USERS.users['${provider}']['claim_data']['claim_resp']['data']['id']}
  Log  ${confrimation_data}
  Викликати для учасника  ${provider}
  ...      Подати вимогу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['claim_data']['claim_resp']}
  ...      ${confrimation_data}

Можливість скасувати вимогу на умови
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість скасувати скаргу на умови
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ${cancellation_reason}=  Set variable  create_fake_sentence
  ${cancellation_data}=  test_cancel_claim_data  ${USERS.users['${provider}']['claim_data']['claim_resp']['data']['id']}  ${cancellation_reason}
  Викликати для учасника  ${provider}
  ...      Скасувати вимогу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['claim_data']['claim_resp']}
  ...      ${cancellation_data}
  Set To Dictionary  ${USERS.users['${provider}'].claim_data}  cancellation  ${cancellation_data}

Подати цінову пропозицію першим учасником після оголошення тендеру
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість подати цінову пропозицію
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ${bid}=  test bid data
  Log  ${bid}
  ${bidresponses}=  Create Dictionary
  Set To Dictionary  ${bidresponses}                 bid   ${bid}
  Set To Dictionary  ${USERS.users['${provider}']}   bidresponses  ${bidresponses}
  ${resp}=  Викликати для учасника   ${provider}   Подати цінову пропозицію   ${TENDER['TENDER_UAID']}   ${bid}
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses}   resp  ${resp}
  log  ${resp}

Можливість завантажити публічний документ до пропозиції першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість прийняти пропозицію переможця
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  log   ${USERS.users['${provider}'].broker}
  ${filepath}=   create_fake_doc
  ${bid_doc_upload}=  Викликати для учасника   ${provider}   Завантажити документ в ставку  ${filepath}   ${TENDER['TENDER_UAID']}
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses}   bid_doc_upload   ${bid_doc_upload}

Можливість змінити документацію цінової пропозиції з публічної на приватну
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість прийняти пропозицію переможця
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  log   ${USERS.users['${provider}'].broker}
  ${privat_doc}=   create_data_dict  data.confidentialityRationale  "Only our company sells badgers with pink hair."
  Set To Dictionary  ${privat_doc.data}  confidentiality  buyerOnly
  ${bidid}=  Get Variable Value  ${USERS.users['${provider}'].bidresponses['resp'].data.id}
  ${docid}=  Get Variable Value  ${USERS.users['${provider}'].bidresponses['bid_doc_upload']['upload_response'].data.id}
  ${bid_doc_modified}=  Викликати для учасника   ${provider}   Змінити документацію в ставці  ${privat_doc}  ${bidid}  ${docid}
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses}   bid_doc_modified   ${bid_doc_modified}

Можливість завантажити фінансовий документ до пропозиції першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість прийняти пропозицію переможця
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  log   ${USERS.users['${provider}'].broker}
  ${filepath}=   create_fake_doc
  ${doc_type}=  Set variable  financial_documents
  ${bid_doc_upload}=  Викликати для учасника   ${provider}   Завантажити документ в ставку  ${filepath}   ${TENDER['TENDER_UAID']}  ${doc_type}
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses}   bid_doc_upload   ${bid_doc_upload}

Можливість завантажити кваліфікаційний документ до пропозиції першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість прийняти пропозицію переможця
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  log   ${USERS.users['${provider}'].broker}
  ${filepath}=   create_fake_doc
  ${doc_type}=   Set variable  eligibility_documents
  ${bid_doc_upload}=  Викликати для учасника   ${provider}   Завантажити документ в ставку  ${filepath}   ${TENDER['TENDER_UAID']}  ${doc_type}
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses}   bid_doc_upload   ${bid_doc_upload}

Можливість завантажити документ для критеріїв прийнятності до пропозиції першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість прийняти пропозицію переможця
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  log   ${USERS.users['${provider}'].broker}
  ${filepath}=   create_fake_doc
  ${doc_type}=  Set variable  qualification_documents
  ${bid_doc_upload}=  Викликати для учасника   ${provider}   Завантажити документ в ставку  ${filepath}   ${TENDER['TENDER_UAID']}  ${doc_type}
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses}   bid_doc_upload   ${bid_doc_upload}

Подати цінову пропозицію другим учасником
  [Tags]   ${USERS.users['${provider1}'].broker}: Можливість подати цінову пропозицію
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
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
  ${activestatusresp}=  Викликати для учасника   ${provider}   Змінити цінову пропозицію   ${TENDER['TENDER_UAID']}   status  pending
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses}   activestatusresp   ${activestatusresp}
  log  ${activestatusresp}

Cкасувати цінову пропозицію другого учасника
  [Tags]   ${USERS.users['${provider1}'].broker}: Можливість скасувати цінову пропозицію
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ${bid}=  Get Variable Value  ${USERS.users['${provider1}'].bidresponses['resp']}
  ${bidresponses}=  Викликати для учасника   ${provider1}   Скасувати цінову пропозицію   ${TENDER['TENDER_UAID']}   ${bid}

Повторно подати цінову пропозицію другим учасником після першої зміни
  [Tags]   ${USERS.users['${provider1}'].broker}: Можливість подати цінову пропозицію
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
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
  Викликати для учасника   ${tender_owner}  Внести зміни в тендер  shouldfail  ${TENDER['TENDER_UAID']}   description     description

Неможливість подати вимогу на умови менше ніж за 10 днів до завершення періоду подання пропозицій
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість подати вимогу на умови
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  [Documentation]  Користувач ${USERS.users['${provider}'].broker} намагається подати скаргу на умови оголошеної закупівлі
  ${claim}=  Підготовка даних для подання вимоги
  ${claim_resp}=  Викликати для учасника  ${provider}
  ...      Створити вимогу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${claim}
  ${claim_data2}=  Create Dictionary  claim=${claim}  claim_resp=${claim_resp}
  Log  ${claim_data2}
  Set To Dictionary  ${USERS.users['${provider}']}  claim_data2  ${claim_data2}

  ${confrimation_data}=  test_submit_claim_data  ${USERS.users['${provider}']['claim_data2']['claim_resp']['data']['id']}
  Log  ${confrimation_data}
  Викликати для учасника  ${provider}
  ...      Подати вимогу
  ...      shouldfail
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['claim_data2']['claim_resp']}
  ...      ${confrimation_data}

Продовжити період редагування подання пропозиції на 7 днів
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ${endDate}=  add_minutes_to_date   ${USERS.users['${tender_owner}'].tender_data.data.tenderPeriod.endDate}  7
  Викликати для учасника   ${tender_owner}  Внести зміни в тендер  ${TENDER['TENDER_UAID']}   tenderPeriod.endDate     ${endDate}


Можливість подати скаргу на умови більше ніж за 4 дні до завершення періоду подання пропозицій
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість подати скаргу на умови
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  [Documentation]  Користувач ${USERS.users['${provider}'].broker} намагається подати скаргу на умови оголошеної закупівлі
  Дочекатись синхронізації з майданчиком    ${provider}
  ${claim}=  Підготовка даних для подання вимоги
  ${claim_resp}=  Викликати для учасника  ${provider}
  ...      Створити вимогу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${claim}
  ${claim_data3}=  Create Dictionary  claim=${claim}  claim_resp=${claim_resp}
  Log  ${claim_data3}
  Set To Dictionary  ${USERS.users['${provider}']}  claim_data3  ${claim_data3}

  ${escalation_data}=  test_escalate_claim_data  ${USERS.users['${provider}']['claim_data3']['claim_resp']['data']['id']}
  Log  ${escalation_data}
  Викликати для учасника  ${tender_owner}
  ...      Перетворити вимогу в скаргу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['claim_data3']['claim_resp']}
  ...      ${escalation_data}
  Set To Dictionary  ${USERS.users['${provider}'].claim_data3}  escalation  ${escalation_data}

Можливість скасувати скаргу на умови
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість скасувати скаргу на умови
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ${cancellation_reason}=  Set variable  create_fake_sentence
  ${cancellation_data}=  test_cancel_claim_data  ${USERS.users['${provider}']['claim_data3']['claim_resp']['data']['id']}  ${cancellation_reason}
  Викликати для учасника  ${provider}
  ...      Скасувати вимогу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['claim_data3']['claim_resp']}
  ...      ${cancellation_data}
  Set To Dictionary  ${USERS.users['${provider}'].claim_data3}  cancellation  ${cancellation_data}

Можливість редагувати однопредметний тендер після продовження періоду подання пропозицій
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
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
  ${activestatusresp}=  Викликати для учасника   ${provider}   Змінити цінову пропозицію   ${TENDER['TENDER_UAID']}   status  pending
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses}   activestatusresp   ${activestatusresp}
  log  ${activestatusresp}


Повторно подати цінову пропозицію другим учасником після другої зміни
  [Tags]   ${USERS.users['${provider1}'].broker}: Можливість подати цінову пропозицію
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
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
  [Documentation]  Користувач ${USERS.users['${provider}'].broker} намагається подати скаргу на умови оголошеної закупівлі
  Дочекатись дати закінчення періоду подання скарг  ${provider}
  Дочекатись синхронізації з майданчиком    ${provider}
  ${claim}=  Підготовка даних для подання вимоги
  ${claim_resp}=  Викликати для учасника  ${provider}
  ...      Створити вимогу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${claim}
  ${claim_data4}=  Create Dictionary  claim=${claim}  claim_resp=${claim_resp}
  Log  ${claim_data4}
  Set To Dictionary  ${USERS.users['${provider}']}  claim_data4  ${claim_data4}

  ${escalation_data}=  test_escalate_claim_data  ${USERS.users['${provider}']['claim_data4']['claim_resp']['data']['id']}
  Log  ${escalation_data}
  Викликати для учасника  ${tender_owner}
  ...      Перетворити вимогу в скаргу
  ...      shouldfail
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['claim_data4']['claim_resp']}
  ...      ${escalation_data}
  Set To Dictionary  ${USERS.users['${provider}'].claim_data4}  escalation  ${escalation_data}

####
#  Qualification
Відображення статусу першої пропозиції кваліфікації
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Відображення основних даних оголошеного тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  Дочекатись дати закінчення прийому пропозицій  ${tender_owner}
  Дочекатись синхронізації з майданчиком    ${tender_owner}
  Звірити поле тендера із значенням  ${tender_owner}  pending  qualifications[0].status

Відображення статусу другої пропозиції кваліфікації
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Відображення основних даних оголошеного тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  Дочекатись дати закінчення прийому пропозицій  ${tender_owner}
  Дочекатись синхронізації з майданчиком    ${tender_owner}
  Звірити поле тендера із значенням  ${tender_owner}  pending  qualifications[1].status

Можливість завантажити документ у кваліфікацію пропозиції першого учасника
  [Tags]   ${USERS.users['${tender_owner}'].broker}:
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  log   ${USERS.users['${tender_owner}'].broker}
  ${filepath}=   create_fake_doc
  Викликати для учасника   ${tender_owner}   Завантажити документ у кваліфікацію  ${filepath}   ${TENDER['TENDER_UAID']}  0

Можливість підтвердити першу пропозицію кваліфікації
  [Tags]   ${USERS.users['${tender_owner}'].broker}:
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  Викликати для учасника  ${tender_owner}  Підтвердити кваліфікацію  ${TENDER['TENDER_UAID']}  0

Можливість завантажити документ у кваліфікацію пропозиції другого учасника
  [Tags]   ${USERS.users['${tender_owner}'].broker}:
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  log   ${USERS.users['${tender_owner}'].broker}
  ${filepath}=   create_fake_doc
  Викликати для учасника   ${tender_owner}   Завантажити документ у кваліфікацію  ${filepath}   ${TENDER['TENDER_UAID']}  1

Можливість відхилити другу пропозицію кваліфікації
  [Tags]   ${USERS.users['${tender_owner}'].broker}:
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  Викликати для учасника  ${tender_owner}  Відхилити кваліфікацію  ${TENDER['TENDER_UAID']}  1

Можливість скасувати рішення кваліфікації для другої пропопозиції
  [Tags]   ${USERS.users['${tender_owner}'].broker}:
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  Викликати для учасника  ${tender_owner}  Скасувати кваліфікацію  ${TENDER['TENDER_UAID']}  1

Можливість підтвердити другу пропозицію кваліфікації
  [Tags]   ${USERS.users['${tender_owner}'].broker}:
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  Викликати для учасника  ${tender_owner}  Підтвердити кваліфікацію  ${TENDER['TENDER_UAID']}  2
