*** Settings ***
Library         op_robot_tests.tests_files.service_keywords
Library         String
Library         Collections
Library         Selenium2Library
Library         DebugLibrary
Resource        keywords.robot
Resource        resource.robot
Suite Setup     Test Suite Setup
Suite Teardown  Test Suite Teardown

*** Variables ***
${mode}         multi
@{used_roles}   tender_owner  provider  provider1  viewer
${complaint_id}  1


*** Test Cases ***
Можливість оголосити мультилотовий тендер
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити мультилотовий тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      minimal
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${tender_data}=  Підготовка даних для створення тендера
  ${tender_data}=  test_tender_data_multiple_lots  ${tender_data}
  ${adapted_data}=  Адаптувати дані для оголошення тендера  ${tender_owner}  ${tender_data}
  ${TENDER_UAID}=  Викликати для учасника  ${tender_owner}  Створити тендер  ${adapted_data}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  initial_data=${adapted_data}
  Set To Dictionary  ${TENDER}   TENDER_UAID             ${TENDER_UAID}
  Log  ${TENDER}

Можливість знайти мультилотовий тендер по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук тендера по ідентифікатору
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      minimal
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}  ${provider}  ${provider1}
  \  Дочекатись синхронізації з майданчиком    ${username}
  \  Викликати для учасника  ${username}  Пошук тендера по ідентифікатору   ${TENDER['TENDER_UAID']}

#######
#Операції з лотом

Можливість створення лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком    ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${tender_data}=  Get Variable Value  ${USERS.users['${tender_owner}'].tender_data}
  ${lot}=  Підготовка даних для створення лоту
  ${lotcreate}=  Викликати для учасника   ${tender_owner}  Створити лот  ${tender_data}  ${lot}
  ${lotresponses}=  Create Dictionary
  Set To Dictionary  ${lotresponses}   resp0   ${lotcreate}
  Set To Dictionary  ${USERS.users['${tender_owner}']}   lotresponses  ${lotresponses}
  log  ${lotcreate}

Можливість видалення лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${tender_data}=  Get Variable Value  ${USERS.users['${tender_owner}'].tender_data}
  ${lot}=  Get Variable Value  ${USERS.users['${tender_owner}'].lotresponses['resp0']}
  ${lotdelete}=  Викликати для учасника   ${tender_owner}  Видалити лот  ${tender_data}  ${lot}
  Log  ${lotdelete}

Можливість повторого створення лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${tender_data}=  Get Variable Value  ${USERS.users['${tender_owner}'].tender_data}
  ${lot}=  Підготовка даних для створення лоту
  ${lotcreate}=  Викликати для учасника   ${tender_owner}  Створити лот  ${tender_data}  ${lot}
  ${lotresponses}=  Create Dictionary
  Set To Dictionary  ${lotresponses}   resp   ${lotcreate}
  Set To Dictionary  ${USERS.users['${tender_owner}']}   lotresponses  ${lotresponses}
  log  ${lotcreate}

Можливість змінити бюджет нового лоту до 8000
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${tender_data}=  Get Variable Value  ${USERS.users['${tender_owner}'].tender_data}
  Set To Dictionary  ${USERS.users['${tender_owner}'].lotresponses['resp'].data.value}  amount   8000
  ${fixlotto8000resp}=   Викликати для учасника   ${tender_owner}  Змінити лот  ${tender_data}  ${USERS.users['${tender_owner}'].lotresponses['resp']}
  Set To Dictionary  ${USERS.users['${tender_owner}'].lotresponses}   fixlotto8000resp   ${fixlotto8000resp}
  log  ${fixlotto8000resp}

Можливість змінити бюджет нового лоту до 100
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${tender_data}=  Get Variable Value  ${USERS.users['${tender_owner}'].tender_data}
  Set To Dictionary  ${USERS.users['${tender_owner}'].lotresponses['resp'].data.value}  amount   8000
  ${fixlotto100resp}=   Викликати для учасника   ${tender_owner}  Змінити лот  ${tender_data}  ${USERS.users['${tender_owner}'].lotresponses['resp']}
  Set To Dictionary  ${USERS.users['${tender_owner}'].lotresponses}   fixlotto100resp   ${fixlotto100resp}
  log  ${fixlotto100resp}


#####
#Предмети закупівлі лоту

Можливість додати позицію закупівлі в тендер
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Викликати для учасника   ${tender_owner}   Додати предмети закупівлі    ${TENDER['TENDER_UAID']}   1

Можливість добавити предмет закупівлі до лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${items}=  Get Variable Value  ${USERS.users['${tender_owner}'].tender_data.data['items']}
  Log   ${items}
  ${lot_id}=   Get Variable Value  ${USERS.users['${tender_owner}'].lotresponses['resp'].data.id}
  Set To Dictionary  ${items[-1]}  relatedLot   ${lot_id}
  Log  ${items[-1]}
  Викликати для учасника   ${tender_owner}  Внести зміни в тендер    ${TENDER['TENDER_UAID']}   items     ${items}

Неможливість видалення лоту з прив’язаними предметами закупівлі
  [Documentation]
  ...      `Видалити лот` should not pass in this test case.
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ${tender_data}=  Get Variable Value  ${USERS.users['${tender_owner}'].tender_data}
  ${lot}=  Get Variable Value  ${USERS.users['${tender_owner}'].lotresponses['resp']}
  Require Failure  ${tender_owner}  Видалити лот  ${tender_data}  ${lot}

Можливість видалити позиції закупівлі тендера
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${items}=  Get Variable Value  ${USERS.users['${tender_owner}'].tender_data.data['items']}
  Log  ${items}
  ${resp}=  Викликати для учасника   ${tender_owner}  Внести зміни в тендер    ${TENDER['TENDER_UAID']}   items     ${items[:-1]}
  Log  ${resp}

Можливість додати тендерну документацію лоту
  [Tags]    ${USERS.users['${tender_owner}'].broker}: Можливість завантажити документ
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  [Documentation]   Закупівельник   ${USERS.users['${tender_owner}'].broker}  завантажує документацію  до  оголошеної закупівлі
  [Teardown]  Оновити LAST_MODIFICATION_DATE
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

Можливість задати питання
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість задати запитання
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком    ${provider}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${question}=  Підготовка даних для запитання
  ${question_resp}=  Викликати для учасника   ${provider}   Задати питання  ${TENDER['TENDER_UAID']}   ${question}
  ${now}=  Get Current TZdate
  ${question.data.date}=  Set variable  ${now}
  ${question_id}=  get_id_from_field  ${question.data.description}
  ${question_data}=  Create Dictionary  question=${question}  question_resp=${question_resp}  question_id=${question_id}
  ${question_data}=  munch_dict  arg=${question_data}
  Set To Dictionary  ${USERS.users['${provider}']}  question_data  ${question_data}


Можливість відповісти на запитання
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість відповісти на запитання
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком    ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${answer}=  Підготовка даних для відповіді на запитання
  ${answer_resp}=  Викликати для учасника  ${tender_owner}
  ...      Відповісти на питання  ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['question_data']['question_resp']}  ${answer}
  ...      question_id=${USERS.users['${provider}'].question_data.question_id}
  ${now}=  Get Current TZdate
  ${answer.data.date}=  Set variable  ${now}
  ${answer_data}=  Create Dictionary  answer=${answer}  answer_resp=${answer_resp}
  Set To Dictionary  ${USERS.users['${provider}']}  answer_data  ${answer_data}

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
  ...      viewer  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      minimal
  :FOR  ${username}  IN  ${viewer}  ${provider}  ${provider1}
  \  Дочекатись синхронізації з майданчиком    ${username}
  \  Звірити дату тендера  ${username}  ${USERS.users['${tender_owner}'].initial_data}  tenderPeriod.startDate

Відображення закінчення періоду прийому пропозицій оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  ...      viewer  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      minimal
  :FOR  ${username}  IN  ${viewer}  ${provider}  ${provider1}
  \  Дочекатись синхронізації з майданчиком    ${username}
  \  Звірити дату тендера  ${username}  ${USERS.users['${tender_owner}'].initial_data}  tenderPeriod.endDate

Неможливість подати цінову пропозицію до початку періоду подачі пропозицій
  [Documentation]
  ...      `Подати цінову пропозицію` should not pass in this test case.
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість подати цінову пропозицію
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком    ${provider}
  ${bid}=  test lots bid data
  Log   ${bid}
  ${bidresponses}=  Create Dictionary
  Set To Dictionary  ${bidresponses}                 bid  ${bid}
  Set To Dictionary  ${USERS.users['${provider}']}   bidresponses  ${bidresponses}
  ${bid_before_bidperiod_resp}=  Require Failure  ${provider}  Подати цінову пропозицію  ${TENDER['TENDER_UAID']}  ${bid}
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses}   bid_before_bidperiod_resp  ${bid_before_bidperiod_resp}
  log   ${USERS.users['${provider}']}

Неможливість подати цінову пропозицію без прив’язки до лоту
  [Documentation]
  ...      `Подати цінову пропозицію` should not pass in this test case.
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість подати цінову пропозицію
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком    ${provider}
  Дочекатись дати початку прийому пропозицій  ${provider}
  ${bid}=  test bid data
  Log   ${bid}
  ${bidresponses}=  Create Dictionary
  Set To Dictionary  ${bidresponses}                 bid  ${bid}
  Set To Dictionary  ${USERS.users['${provider}']}   bidresponses  ${bidresponses}
  ${no_lot_bid_resp}=  Require Failure  ${provider}  Подати цінову пропозицію  ${TENDER['TENDER_UAID']}  ${bid}
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses}   no_lot_bid_resp  ${no_lot_bid_resp}
  log   ${USERS.users['${provider}']}

Можливість подати цінову пропозицію першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість подати цінову пропозицію
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${bid}=  test lots bid data
  Log  ${bid}
  ${bidresponses}=  Create Dictionary
  Set To Dictionary  ${bidresponses}                 bid  ${bid}
  Set To Dictionary  ${USERS.users['${provider}']}   bidresponses  ${bidresponses}
  ${resp}=  Викликати для учасника   ${provider}   Подати цінову пропозицію   ${TENDER['TENDER_UAID']}   ${bid}
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses}   resp  ${resp}
  log   ${USERS.users['${provider}']}

Можливість скасувати цінову пропозицію
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість скасувати цінову пропозицію
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${canceledbidresp}=  Викликати для учасника   ${provider}   Скасувати цінову пропозицію   ${TENDER['TENDER_UAID']}   ${USERS.users['${provider}'].bidresponses['resp']}
  Log  ${canceledbidresp}

Можливість подати повторно цінову пропозицію першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість подати цінову пропозицію
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Дочекатись дати початку прийому пропозицій  ${provider}
  ${bid}=  test lots bid data
  Log  ${bid}
  ${bidresponses}=  Create Dictionary
  Set To Dictionary  ${bidresponses}   bid   ${bid}
  Set To Dictionary  ${USERS.users['${provider}']}   bidresponses   ${bidresponses}
  ${resp}=  Викликати для учасника   ${provider}   Подати цінову пропозицію   ${TENDER['TENDER_UAID']}   ${bid}
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses}   resp   ${resp}
  log  ${USERS.users['${provider}'].bidresponses}

Можливість змінити повторну цінову пропозицію до 2000
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість змінити цінову пропозицію
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${fixbidto2000resp}=  Викликати для учасника   ${provider}   Змінити цінову пропозицію   ${TENDER['TENDER_UAID']}   lotValues.0.value.amount  2000
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses}   fixbidto2000resp   ${fixbidto2000resp}
  log  ${fixbidto2000resp}

Можливість змінити повторну цінову пропозицію до 10
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість змінити цінову пропозицію
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${fixbidto10resp}=  Викликати для учасника   ${provider}   Змінити цінову пропозицію   ${TENDER['TENDER_UAID']}   lotValues.0.value.amount  10
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses}   fixbidto10resp   ${fixbidto10resp}
  log  ${fixbidto10resp}

Можливість подати цінову пропозицію другим учасником
  [Tags]   ${USERS.users['${provider1}'].broker}: Можливість подати цінову пропозицію
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком    ${provider1}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Дочекатись дати початку прийому пропозицій  ${provider1}
  ${bid}=  test lots bid data
  Log  ${bid}
  ${bidresponses}=  Create Dictionary
  Set To Dictionary  ${bidresponses}                 bid  ${bid}
  Set To Dictionary  ${USERS.users['${provider1}']}   bidresponses  ${bidresponses}
  ${resp}=  Викликати для учасника   ${provider1}   Подати цінову пропозицію   ${TENDER['TENDER_UAID']}   ${bid}
  Set To Dictionary  ${USERS.users['${provider1}'].bidresponses}    resp  ${resp}
  log  ${resp}
  log  ${USERS.users['${provider1}'].bidresponses}

Неможливість побачити цінові пропозиції учасників під час прийому пропозицій
  [Tags]   ${USERS.users['${viewer}'].broker}: Можливість подати цінову пропозицію
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком    ${viewer}
  Require Failure  ${viewer}  Отримати інформацію із тендера  bids

Неможливість змінити цінову пропозицію до 2000 після закінчення прийому пропозицій
  [Documentation]
  ...      `Змінити цінову пропозицію` should not pass in this test case.
  [Tags]   ${USERS.users['${provider1}'].broker}: Неможливість змінити цінову пропозицію до 2000 після закінчення прийому пропозицій
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком    ${provider1}
  Дочекатись дати закінчення прийому пропозицій  ${provider1}
  ${failfixbidto2000resp}=  Require Failure  ${provider1}  Змінити цінову пропозицію  ${TENDER['TENDER_UAID']}  lotValues.0.value.amount  2000
  Set To Dictionary  ${USERS.users['${provider1}'].bidresponses}   failfixbidto2000resp   ${failfixbidto2000resp}
  log  ${failfixbidto2000resp}

Неможливість змінити цінову пропозицію до 1 після закінчення прийому пропозицій
  [Documentation]
  ...      `Змінити цінову пропозицію` should not pass in this test case.
  [Tags]   ${USERS.users['${provider1}'].broker}: Неможливість змінити цінову пропозицію до 1 після закінчення прийому пропозицій
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ${failfixbidto1resp}=  Require Failure  ${provider1}  Змінити цінову пропозицію  ${TENDER['TENDER_UAID']}  lotValues.0.value.amount  1
  Set To Dictionary  ${USERS.users['${provider1}'].bidresponses}   failfixbidto1resp   ${failfixbidto1resp}
  log  ${failfixbidto1resp}

Неможливість скасувати цінову пропозицію
  [Documentation]
  ...      `Скасувати цінову пропозицію` should not pass in this test case.
  [Tags]   ${USERS.users['${provider1}'].broker}: Можливість скасувати цінову пропозицію
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ${biddingresponse}=  Require Failure  ${provider1}  Скасувати цінову пропозицію  ${TENDER['TENDER_UAID']}  ${USERS.users['${provider1}'].bidresponses['resp']}
