*** Settings ***
Library         op_robot_tests.tests_files.service_keywords
Library         String
Library         Collections
Library         Selenium2Library
Library         DebugLibrary
Resource        keywords.robot
Resource        resource.robot
Suite Setup     TestSuiteSetup
Suite Teardown  Close all browsers

*** Variables ***
${mode}         multi

${role}         viewer
${broker}       Quinta

${question_id}  1
${complaint_id}  1

*** Test Cases ***
Можливість оголосити мультилотовий тендер
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити мультилотовий тендер
  ${tender_data}=  Підготовка початкових даних
  ${tender_data}=  test_tender_data_multiple_lots  ${tender_data}
  ${TENDER_UAID}=  Викликати для учасника  ${tender_owner}  Створити тендер  ${tender_data}
  ${LAST_MODIFICATION_DATE}=  Get Current TZdate
  Set To Dictionary  ${USERS.users['${tender_owner}']}  initial_data  ${tender_data}
  Set To Dictionary  ${TENDER}   TENDER_UAID             ${TENDER_UAID}
  Set To Dictionary  ${TENDER}   LAST_MODIFICATION_DATE  ${LAST_MODIFICATION_DATE}
  Log  ${TENDER}

Пошук мультилотового тендера по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук тендера по ідентифікатору
  Дочекатись синхронізації з майданчиком    ${viewer}
  ${usernames}=  Create List  ${viewer}  ${tender_owner}  ${provider}  ${provider1}
  :FOR  ${username}  IN  @{usernames}
  \  Викликати для учасника  ${username}  Пошук тендера по ідентифікатору   ${TENDER['TENDER_UAID']}

Отримання тендера
  Дочекатись синхронізації з майданчиком    ${tender_owner}
  Викликати для учасника   ${tender_owner}   Пошук тендера по ідентифікатору   ${TENDER['TENDER_UAID']}

#######
#Операції з лотом

Створення лоту
  ${tender_data}=  Get Variable Value  ${USERS.users['${tender_owner}'].tender_data}
  ${lot}=  test lot data
  ${lotcreate}=  Викликати для учасника   ${tender_owner}  Створити лот  ${tender_data}  ${lot}
  ${lotresponses}=  Create Dictionary
  Set To Dictionary  ${lotresponses}   resp0   ${lotcreate}
  Set To Dictionary  ${USERS.users['${tender_owner}']}   lotresponses  ${lotresponses}
  log  ${lotcreate}

Можливість видалення лоту
  ${tender_data}=  Get Variable Value  ${USERS.users['${tender_owner}'].tender_data}
  ${lot}=  Get Variable Value  ${USERS.users['${tender_owner}'].lotresponses['resp0']}
  ${lotdelete}=  Викликати для учасника   ${tender_owner}  Видалити лот  ${tender_data}  ${lot}
  Log  ${lotdelete}

Повторне створення лоту
  ${tender_data}=  Get Variable Value  ${USERS.users['${tender_owner}'].tender_data}
  ${lot}=  test lot data
  ${lotcreate}=  Викликати для учасника   ${tender_owner}  Створити лот  ${tender_data}  ${lot}
  ${lotresponses}=  Create Dictionary
  Set To Dictionary  ${lotresponses}   resp   ${lotcreate}
  Set To Dictionary  ${USERS.users['${tender_owner}']}   lotresponses  ${lotresponses}
  log  ${lotcreate}

Можливість змінити цінову пропозицію у новому лоті до 8000
  ${tender_data}=  Get Variable Value  ${USERS.users['${tender_owner}'].tender_data}
  Set To Dictionary  ${USERS.users['${tender_owner}'].lotresponses['resp'].data.value}  amount   8000
  ${fixlotto8000resp}=   Викликати для учасника   ${tender_owner}  Змінити лот  ${tender_data}  ${USERS.users['${tender_owner}'].lotresponses['resp']}
  Set To Dictionary  ${USERS.users['${tender_owner}'].lotresponses}   fixlotto8000resp   ${fixlotto8000resp}
  log  ${fixlotto8000resp}

Можливість змінити цінову пропозицію у новому лоті до 100
  ${tender_data}=  Get Variable Value  ${USERS.users['${tender_owner}'].tender_data}
  Set To Dictionary  ${USERS.users['${tender_owner}'].lotresponses['resp'].data.value}  amount   8000
  ${fixlotto100resp}=   Викликати для учасника   ${tender_owner}  Змінити лот  ${tender_data}  ${USERS.users['${tender_owner}'].lotresponses['resp']}
  Set To Dictionary  ${USERS.users['${tender_owner}'].lotresponses}   fixlotto100resp   ${fixlotto100resp}
  log  ${fixlotto100resp}


#####
#Предмети закупівлі лоту

Можливість додати позицію закупівлі в тендер
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  Викликати для учасника   ${tender_owner}   Додати предмети закупівлі    ${TENDER['TENDER_UAID']}   1

Добавити предмет закупівлі до лоту
  ${items}=  Get Variable Value  ${USERS.users['${tender_owner}'].tender_data.data['items']}
  Log   ${items}
  ${lot_id}=   Get Variable Value  ${USERS.users['${tender_owner}'].lotresponses['resp'].data.id}
  Set To Dictionary  ${items[-1]}  relatedLot   ${lot_id}
  Log  ${items[-1]}
  Викликати для учасника   ${tender_owner}  Внести зміни в тендер    ${TENDER['TENDER_UAID']}   items     ${items}

Неможливість видалення лоту з прив’язаними предметами закупівлі
  ${tender_data}=  Get Variable Value  ${USERS.users['${tender_owner}'].tender_data}
  ${lot}=  Get Variable Value  ${USERS.users['${tender_owner}'].lotresponses['resp']}
  Викликати для учасника   ${tender_owner}  Видалити лот  shouldfail   ${tender_data}  ${lot}

Можливість видалити позиції закупівлі тендера
  ${items}=  Get Variable Value  ${USERS.users['${tender_owner}'].tender_data.data['items']}
  Log  ${items}
  ${resp}=  Викликати для учасника   ${tender_owner}  Внести зміни в тендер    ${TENDER['TENDER_UAID']}   items     ${items[:-1]}
  Log  ${resp}

Можливість додати тендерну документацію лоту
  [Tags]    ${USERS.users['${tender_owner}'].broker}: Можливість завантажити документ
  [Documentation]   Закупівельник   ${USERS.users['${tender_owner}'].broker}  завантажує документацію  до  оголошеної закупівлі
  ${filepath}=   create_fake_doc
  ${lot_id}=   Get Variable Value  ${USERS.users['${tender_owner}'].lotresponses['resp'].data.id}
  ${doc_upload_reply}=  Викликати для учасника   ${tender_owner}   Завантажити документ в лот  ${filepath}   ${TENDER['TENDER_UAID']}  ${lot_id}
  ${file_upload_process_data} =  Create Dictionary   filepath=${filepath}  doc_upload_reply=${doc_upload_reply}
  log  ${file_upload_process_data}
  Set To Dictionary  ${USERS.users['${tender_owner}']}   file_upload_process_data   ${file_upload_process_data}
  Log  ${lot_id}
  Log  ${USERS.users['${tender_owner}']}


#######
#Запитання до лоту

Задати питання
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість задати запитання
  ${question}=   Викликати для учасника   ${provider}   Задати питання  ${TENDER['TENDER_UAID']}   ${QUESTIONS[${question_id}]}
  log   ${question}
  ${now}=  Get Current TZdate
  Set To Dictionary  ${QUESTIONS[${question_id}].data}   date   ${now}

Відповісти на запитання
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість відповісти на запитання
  Викликати для учасника   ${tender_owner}   Відповісти на питання    ${TENDER['TENDER_UAID']}  0  ${ANSWERS[0]}
  ${now}=  Get Current TZdate
  Set To Dictionary  ${ANSWERS[${question_id}-1].data}   date   ${now}


######
#Cкарга на лот
#
#
#####  Дочекатися скарг на лот
#
#
#Можливість подати скаргу на лот
#  [Tags]   ${USERS.users['${provider}'].broker}: Можливість подати скаргу на умови
#  [Documentation]    Користувач  ${USERS.users['${provider}'].broker}  намагається подати скаргу на умови оголошеної  закупівлі
#  Викликати для учасника   ${provider}   Подати скаргу    ${TENDER['TENDER_UAID']}   ${COMPLAINTS[${complaint_id}]}
#  ${LAST_MODIFICATION_DATE}=  Get Current Date
#  Set Global Variable   ${LAST_MODIFICATION_DATE}
#
#Можливість побачити скаргу користувачем
#  [Tags]   ${USERS.users['${provider}'].broker}: Відображення основних даних оголошеного тендера
#  Викликати для учасника   ${provider}   Порівняти скаргу  ${TENDER['TENDER_UAID']}   ${COMPLAINTS[${complaint_id}]}
#
#Можливість побачити скаргу анонімом
#  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
#  Викликати для учасника    ${viewer}  Порівняти скаргу  ${TENDER['TENDER_UAID']}   ${COMPLAINTS[${complaint_id}]}
#
#Можливість відхилити скаргу на лот
#  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість відхилити скаргу на умови
#  Set To Dictionary  ${COMPLAINTS[0].data}   status   declined
#  Викликати для учасника   ${tender_owner}   Обробити скаргу    ${TENDER['TENDER_UAID']}  0  ${COMPLAINTS[${complaint_id}]}
#  log many   ${COMPLAINTS[${complaint_id}]}
#  викликати для учасника   ${viewer}   Оновити сторінку з тендером   ${TENDER['TENDER_UAID']}
#
#Можливість відкинути скаргу на лот
#  [Tags]    ${USERS.users['${tender_owner}'].broker}: Можливість відкинути скаргу на умови
#  Викликати для учасника   ${provider}   Подати скаргу    ${TENDER['TENDER_UAID']}   ${COMPLAINTS[${complaint_id}]}
#  ${LAST_MODIFICATION_DATE}=  Get Current Date
#  Set Global Variable   ${LAST_MODIFICATION_DATE}
#  Викликати для учасника   ${viewer}   Оновити сторінку з тендером   ${TENDER['TENDER_UAID']}
#  Set To Dictionary  ${COMPLAINTS[0].data}   status   invalid
#  Викликати для учасника   ${tender_owner}   Обробити скаргу    ${TENDER['TENDER_UAID']}  1  ${COMPLAINTS[${complaint_id}]}
#  log many   ${COMPLAINTS[${complaint_id}]}
#  ${LAST_MODIFICATION_DATE}=  Get Current Date
#  Set Global Variable   ${LAST_MODIFICATION_DATE}
# Викликати для учасника   ${viewer}   Оновити сторінку з тендером   ${TENDER['TENDER_UAID']}
#
#Можливість задовільнити скаргу на лот
#  [Tags]    ${USERS.users['${provider}'].broker}: Можливість відповісти на запитання
#  Викликати для учасника   ${provider}   Подати скаргу    ${TENDER['TENDER_UAID']}   ${COMPLAINTS[${complaint_id}]}
#  ${LAST_MODIFICATION_DATE}=  Get Current Date
#  Set Global Variable   ${LAST_MODIFICATION_DATE}
#  Викликати для учасника   ${viewer}   Оновити сторінку з тендером   ${TENDER['TENDER_UAID']}
#  Set To Dictionary  ${COMPLAINTS[0].data}   status   resolved
#  Викликати для учасника   ${tender_owner}   Обробити скаргу    ${TENDER['TENDER_UAID']}  2  ${COMPLAINTS[${complaint_id}]}
#  log many   ${COMPLAINTS[${complaint_id}]}
#  ${LAST_MODIFICATION_DATE}=  Get Current Date
#  Set Global Variable   ${LAST_MODIFICATION_DATE}
#
######
#Подання пропозицій

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

Неможливість подати цінову пропозицію до початку періоду подачі пропозицій
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість подати цінову пропозицію
  ${bid}=  test lots bid data
  Log   ${bid}
  ${bidresponses}=  Create Dictionary
  ${bid_before_bidperiod_resp}=  Викликати для учасника   ${provider}   Подати цінову пропозицію  shouldfail  ${TENDER['TENDER_UAID']}   ${bid}
  Set To Dictionary  ${bidresponses}                 bid_before_bidperiod_resp  ${bid_before_bidperiod_resp}
  Set To Dictionary  ${USERS.users['${provider}']}   bidresponses  ${bidresponses}
  log   ${USERS.users['${provider}']}

Неможливість подати цінову пропозицію без прив’язки до лоту
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість подати цінову пропозицію
  Дочекатись дати початку прийому пропозицій  ${provider}
  ${bid}=  test bid data
  Log   ${bid}
  ${bidresponses}=  Create Dictionary
  ${no_lot_bid_resp}=  Викликати для учасника   ${provider}   Подати цінову пропозицію  shouldfail  ${TENDER['TENDER_UAID']}   ${bid}
  Set To Dictionary  ${bidresponses}                 no_lot_bid_resp  ${no_lot_bid_resp}
  Set To Dictionary  ${USERS.users['${provider}']}   bidresponses  ${bidresponses}
  log   ${USERS.users['${provider}']}

Подати цінову пропозицію першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість подати цінову пропозицію
  ${bid}=  test lots bid data
  Log  ${bid}
  ${biddingresponse0}=  Викликати для учасника   ${provider}   Подати цінову пропозицію   ${TENDER['TENDER_UAID']}   ${bid}
  Set Global Variable   ${biddingresponse0}
  log  ${biddingresponse0}

Можливість скасувати цінову пропозицію
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість скасувати цінову пропозицію
  ${biddingresponse_0}=  Викликати для учасника   ${provider}   Скасувати цінову пропозицію   ${TENDER['TENDER_UAID']}   ${biddingresponse0}

Подати повторно цінову пропозицію першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість подати цінову пропозицію
  Дочекатись дати початку прийому пропозицій  ${provider}
  ${bid}=  test lots bid data
  Log  ${bid}
  ${resp}=  Викликати для учасника   ${provider}   Подати цінову пропозицію   ${TENDER['TENDER_UAID']}   ${bid}
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses}   resp   ${resp}
  log  ${resp}
  log  ${USERS.users['${provider}'].bidresponses}

Можливість змінити повторну цінову пропозицію до 2000
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість змінити цінову пропозицію
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses['resp'].data.lotValues[0].value}  amount   2000
  Log   ${USERS.users['${provider}'].bidresponses['resp'].data.lotValues[0].value}
  ${fixbidto50000resp}=  Викликати для учасника   ${provider}   Змінити цінову пропозицію   ${TENDER['TENDER_UAID']}   ${USERS.users['${provider}'].bidresponses['resp']}
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses}   fixbidto50000resp   ${fixbidto50000resp}
  log  ${fixbidto50000resp}

Можливість змінити повторну цінову пропозицію до 100
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість змінити цінову пропозицію
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses['resp'].data.lotValues[0].value}  amount   100
  Log   ${USERS.users['${provider}'].bidresponses['fixbidto50000resp'].data.lotValues[0].value}
  ${fixbidto10resp}=  Викликати для учасника   ${provider}   Змінити цінову пропозицію   ${TENDER['TENDER_UAID']}   ${USERS.users['${provider}'].bidresponses['resp']}
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses}   fixbidto10resp   ${fixbidto10resp}
  log  ${fixbidto10resp}

Подати цінову пропозицію другим учасником
  [Tags]   ${USERS.users['${provider1}'].broker}: Можливість подати цінову пропозицію
  Дочекатись дати початку прийому пропозицій  ${provider1}
  ${bid}=  test lots bid data
  Log  ${bid}
  ${bidresponses}=  Create Dictionary
  ${resp}=  Викликати для учасника   ${provider1}   Подати цінову пропозицію   ${TENDER['TENDER_UAID']}   ${bid}
  Set To Dictionary  ${bidresponses}                 resp  ${resp}
  Set To Dictionary  ${USERS.users['${provider1}']}   bidresponses  ${bidresponses}
  log  ${resp}
  log  ${USERS.users['${provider1}'].bidresponses}

Неможливість побачити цінові пропозиції учасників під час прийому пропозицій
  [Tags]   ${USERS.users['${viewer}'].broker}: Можливість подати цінову пропозицію
  ${bids}=  Викликати для учасника    ${viewer}   Отримати інформацію із тендера  bids
  Should Be Equal    ${bids}   ${None}

Неможливість змінити цінову пропозицію до 50000 після закінчення прийому пропозицій
  [Tags]   ${USERS.users['${provider1}'].broker}: Неможливість змінити цінову пропозицію до 50000 після закінчення прийому пропозицій
  Дочекатись дати закінчення прийому пропозицій  ${provider1}
  Set To Dictionary  ${USERS.users['${provider1}'].bidresponses['resp'].data.lotValues[0].value}  amount   50000
  Log   ${USERS.users['${provider1}'].bidresponses['resp'].data.lotValues[0].value}
  ${failfixbidto50000resp}=  Викликати для учасника   ${provider1}   Змінити цінову пропозицію  shouldfail  ${TENDER['TENDER_UAID']}   ${USERS.users['${provider1}'].bidresponses['resp']}
  Set To Dictionary  ${USERS.users['${provider1}'].bidresponses}   failfixbidto50000resp   ${failfixbidto50000resp}
  log  ${failfixbidto50000resp}

Неможливість змінити цінову пропозицію до 1 після закінчення прийому пропозицій
  [Tags]   ${USERS.users['${provider1}'].broker}: Неможливість змінити цінову пропозицію до 1 після закінчення прийому пропозицій
  Set To Dictionary  ${USERS.users['${provider1}'].bidresponses['resp'].data.lotValues[0].value}  amount   1
  Log   ${USERS.users['${provider1}'].bidresponses['resp'].data.lotValues[0].value}
  ${failfixbidto1resp}=  Викликати для учасника   ${provider1}   Змінити цінову пропозицію  shouldfail  ${TENDER['TENDER_UAID']}   ${USERS.users['${provider1}'].bidresponses['resp']}
  Set To Dictionary  ${USERS.users['${provider1}'].bidresponses}   failfixbidto1resp   ${failfixbidto1resp}
  log  ${failfixbidto1resp}

Неможливість скасувати цінову пропозицію
  [Tags]   ${USERS.users['${provider1}'].broker}: Можливість скасувати цінову пропозицію
  ${biddingresponse}=  Викликати для учасника   ${provider1}   Скасувати цінову пропозицію  shouldfail   ${TENDER['TENDER_UAID']}   ${USERS.users['${provider1}'].bidresponses['resp']}

Отримання тендера після закінчення прийому пропозицій
  Дочекатись синхронізації з майданчиком    ${viewer}
  Викликати для учасника   ${viewer}   Пошук тендера по ідентифікатору   ${TENDER['TENDER_UAID']}
