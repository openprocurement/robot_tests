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
${mode}         single
@{used_roles}   tender_owner  provider  provider1  viewer


*** Test Cases ***
Можливість оголосити однопредметний аукціон
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити аукціон
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      minimal
  [Documentation]  Створення закупівлі замовником, обовязково має повертати UAID закупівлі (номер тендера),
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${tender_data}=  Підготовка даних для створення тендера
  ${adapted_data}=  Адаптувати дані для оголошення тендера  ${tender_owner}  ${tender_data}
  ${TENDER_UAID}=  Викликати для учасника  ${tender_owner}  Створити тендер  ${adapted_data}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  initial_data=${adapted_data}
  Set To Dictionary  ${TENDER}  TENDER_UAID=${TENDER_UAID}
  Log  ${TENDER}


Можливість додати документацію до аукціону
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість додати документацію до аукціону
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      level2
  [Documentation]  Закупівельник ${USERS.users['${tender_owner}'].broker} завантажує документацію до оголошеної закупівлі
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${filepath}=  create_fake_doc
  ${doc_upload_reply}=  Викликати для учасника  ${tender_owner}  Завантажити документ  ${filepath}  ${TENDER['TENDER_UAID']}
  ${file_upload_process_data} =  Create Dictionary  filepath=${filepath}  doc_upload_reply=${doc_upload_reply}
  Log  ${file_upload_process_data}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  file_upload_process_data=${file_upload_process_data}
  Log  ${USERS.users['${tender_owner}']}


Можливість знайти однопредметний аукціон по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Можливість знайти аукціон
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      minimal
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}  ${provider}  ${provider1}
  \  Дочекатись синхронізації з майданчиком  ${username}
  \  Викликати для учасника  ${username}  Пошук тендера по ідентифікатору  ${TENDER['TENDER_UAID']}

##############################################################################################
#             ВІДОБРАЖЕННЯ
##############################################################################################

Відображення заголовку однопредметного аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних аукціону
  ...      viewer  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      minimal
  :FOR  ${username}  IN  ${viewer}  ${provider}  ${provider1}
  \  Дочекатись синхронізації з майданчиком  ${username}
  \  Звірити поле тендера  ${username}  ${USERS.users['${tender_owner}'].initial_data}  title


Відображення опису однопредметного аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних аукціону
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  description


Відображення бюджету однопредметного аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних аукціону
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      level2
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  value.amount


Відображення валюти однопредметного аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних аукціону
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      value.currency


Відображення ПДВ в бюджеті однопредметного аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних аукціону
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      value.valueAddedTaxIncluded


Відображення auctionID однопредметного аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних аукціону
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      level2
  Звірити поле тендера із значенням  ${viewer}  ${TENDER['TENDER_UAID']}  auctionID


Відображення procuringEntity.name однопредметного аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних аукціону
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      level2
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  procuringEntity.name


Відображення початку періоду уточнення однопредметного аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних аукціону
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Звірити дату тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  enquiryPeriod.startDate


Відображення закінчення періоду уточнення однопредметного аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних аукціону
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      minimal
  Звірити дату тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  enquiryPeriod.endDate


Відображення початку періоду прийому пропозицій однопредметного аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних аукціону
  ...      viewer  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      minimal
  :FOR  ${username}  IN  ${viewer}  ${provider}  ${provider1}
  \  Дочекатись синхронізації з майданчиком  ${username}
  \  Звірити дату тендера  ${username}  ${USERS.users['${tender_owner}'].initial_data}  tenderPeriod.startDate


Відображення закінчення періоду прийому пропозицій однопредметного аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних аукціону
  ...      viewer  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      minimal
  :FOR  ${username}  IN  ${viewer}  ${provider}  ${provider1}
  \  Дочекатись синхронізації з майданчиком  ${username}
  \  Звірити дату тендера  ${username}  ${USERS.users['${tender_owner}'].initial_data}  tenderPeriod.endDate


Відображення мінімального кроку однопредметного аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних аукціону
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  minimalStep.amount


Відображення дати доставки номенклатури однопредметного аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури аукціону
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      level3
  Звірити дату тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  items[0].deliveryDate.endDate  day  absolute_delta=${True}


Відображення координат широти доставки номенклатури однопредметного аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури аукціону
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  items[0].deliveryLocation.latitude


Відображення координат довготи доставки номенклатури однопредметного аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури аукціону
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  items[0].deliveryLocation.longitude


Відображення назви нас. пункту доставки номенклатури однопредметного аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури аукціону
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      level3
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  items[0].deliveryAddress.countryName


Відображення пошт. коду доставки номенклатури однопредметного аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури аукціону
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  items[0].deliveryAddress.postalCode


Відображення регіону доставки номенклатури однопредметного аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури аукціону
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      level3
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  items[0].deliveryAddress.region


Відображення locality адреси доставки номенклатури однопредметного аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури аукціону
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  items[0].deliveryAddress.locality


Відображення вулиці доставки номенклатури однопредметного аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури аукціону
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  items[0].deliveryAddress.streetAddress


Відображення схеми класифікації номенклатури однопредметного аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури аукціону
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  items[0].classification.scheme


Відображення ідентифікатора класифікації номенклатури однопредметного аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури аукціону
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      level3
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  items[0].classification.id


Відображення опису класифікації номенклатури однопредметного аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури аукціону
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      level3
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  items[0].classification.description


Відображення назви одиниці номенклатури однопредметного аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури аукціону
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      level3
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  items[0].unit.name


Відображення коду одиниці номенклатури однопредметного аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури аукціону
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  items[0].unit.code


Відображення кількості номенклатури однопредметного аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури аукціону
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      level3
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  items[0].quantity

##############################################################################################
#             МОЖЛИВІСТЬ
##############################################################################################

Можливість редагувати однопредметний аукціон
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати аукціон
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      level2
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Викликати для учасника  ${tender_owner}  Внести зміни в тендер  ${TENDER['TENDER_UAID']}  description  description

##############################################################################################
#             ВІДОБРАЖЕННЯ
##############################################################################################

Відображення опису номенклатури однопредметного аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури аукціону
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      level2
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  items[0].description

##############################################################################################
#             МОЖЛИВІСТЬ
##############################################################################################

Можливість задати питання
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість задати запитання
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      level2
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${question}=  Підготовка даних для запитання
  ${question_resp}=  Викликати для учасника  ${provider}  Задати питання  ${TENDER['TENDER_UAID']}  ${question}
  ${now}=  Get Current TZdate
  ${question.data.date}=  Set variable  ${now}
  ${question_id}=  get_id_from_object  ${question.data}
  ${question_data}=  Create Dictionary  question=${question}  question_resp=${question_resp}  question_id=${question_id}
  ${question_data}=  munch_dict  arg=${question_data}
  Set To Dictionary  ${USERS.users['${provider}']}  question_data=${question_data}

##############################################################################################
#             ВІДОБРАЖЕННЯ
##############################################################################################

Відображення заголовку анонімного питання без відповіді
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення запитання
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      level2
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Викликати для учасника  ${viewer}  Оновити сторінку з тендером  ${TENDER['TENDER_UAID']}
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${provider}'].question_data.question.data.title}  title
  ...      object_id=${USERS.users['${provider}'].question_data.question_id}


Відображення опису анонімного питання без відповіді
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення запитання
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      level2
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${provider}'].question_data.question.data.description}  description
  ...      object_id=${USERS.users['${provider}'].question_data.question_id}


Відображення дати анонімного питання без відповіді
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення запитання
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Звірити дату тендера із значенням  ${viewer}
  ...      ${USERS.users['${provider}'].question_data.question.data.date}  date
  ...      object_id=${USERS.users['${provider}'].question_data.question_id}

##############################################################################################
#             МОЖЛИВІСТЬ
##############################################################################################

Неможливість подати цінову пропозицію до початку періоду подачі пропозицій першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  ${bid}=  Підготувати дані для подання пропозиції
  Log  ${bid}
  ${bidresponses}=  Create Dictionary  bid=${bid}
  Set To Dictionary  ${USERS.users['${provider}']}  bidresponses=${bidresponses}
  ${bid_before_bidperiod_resp}=  Require Failure  ${provider}  Подати цінову пропозицію  ${TENDER['TENDER_UAID']}  ${bid}
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses}  bid_before_bidperiod_resp=${bid_before_bidperiod_resp}
  Log  ${USERS.users['${provider}']}


Можливість відповісти на запитання
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість відповісти на запитання
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      level2
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${answer}=  Підготовка даних для відповіді на запитання
  ${answer_resp}=  Викликати для учасника  ${tender_owner}
  ...      Відповісти на питання  ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['question_data']['question_resp']}  ${answer}
  ...      question_id=${USERS.users['${provider}'].question_data.question_id}
  ${now}=  Get Current TZdate
  ${answer.data.date}=  Set variable  ${now}
  ${answer_data}=  Create Dictionary  answer=${answer}  answer_resp=${answer_resp}
  Set To Dictionary  ${USERS.users['${provider}']}  answer_data=${answer_data}

##############################################################################################
#             ВІДОБРАЖЕННЯ
##############################################################################################

Відображення відповіді на запитання
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення відповіді на запитання
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      level2
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Викликати для учасника  ${viewer}  Оновити сторінку з тендером  ${TENDER['TENDER_UAID']}
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${provider}']['answer_data']['answer'].data.answer}  answer
  ...      object_id=${USERS.users['${provider}'].question_data.question_id}

##############################################################################################
#             МОЖЛИВІСТЬ
##############################################################################################

Можливість подати цінову пропозицію першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  [Setup]  Дочекатись дати початку прийому пропозицій  ${provider}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${bid}=  Підготувати дані для подання пропозиції
  Log  ${bid}
  ${bidresponses}=  Create Dictionary  bid=${bid}
  Set To Dictionary  ${USERS.users['${provider}']}  bidresponses=${bidresponses}
  ${resp}=  Викликати для учасника  ${provider}  Подати цінову пропозицію  ${TENDER['TENDER_UAID']}  ${bid}
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses}  resp=${resp}
  Log  ${USERS.users['${provider}'].bidresponses}


Можливість скасувати цінову пропозицію
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${canceledbidresp}=  Викликати для учасника  ${provider}  Скасувати цінову пропозицію  ${TENDER['TENDER_UAID']}  ${USERS.users['${provider}'].bidresponses['resp']}
  Log  ${canceledbidresp}


Можливість подати повторно цінову пропозицію першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      minimal
  [Setup]  Дочекатись дати початку прийому пропозицій  ${provider}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${bid}=  Підготувати дані для подання пропозиції
  Log  ${bid}
  ${bidresponses}=  Create Dictionary  bid=${bid}
  Set To Dictionary  ${USERS.users['${provider}']}  bidresponses=${bidresponses}
  ${resp}=  Викликати для учасника  ${provider}  Подати цінову пропозицію  ${TENDER['TENDER_UAID']}  ${bid}
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses}  resp=${resp}
  Log  ${USERS.users['${provider}'].bidresponses}


Можливість змінити повторну цінову пропозицію до 90000
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${fixbidto90000resp}=  Викликати для учасника  ${provider}  Змінити цінову пропозицію  ${TENDER['TENDER_UAID']}  value.amount  90000
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses}  fixbidto90000resp=${fixbidto90000resp}
  Log  ${fixbidto90000resp}


Можливість змінити повторну цінову пропозицію до 50001
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${fixbidto50001resp}=  Викликати для учасника  ${provider}  Змінити цінову пропозицію  ${TENDER['TENDER_UAID']}  value.amount  50001
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses}  fixbidto50001resp=${fixbidto50001resp}
  Log  ${fixbidto50001resp}


Можливість завантажити документ першим учасником в повторну пропозицію
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      level2
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Log  ${USERS.users['${provider}'].broker}
  ${filepath}=  create_fake_doc
  ${bid_doc_upload}=  Викликати для учасника  ${provider}  Завантажити документ в ставку  ${filepath}  ${TENDER['TENDER_UAID']}
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses}  bid_doc_upload=${bid_doc_upload}


Можливість змінити документацію цінової пропозиції
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Log  ${USERS.users['${provider}'].broker}
  ${filepath}=  create_fake_doc
  ${bidid}=  Get Variable Value  ${USERS.users['${provider}'].bidresponses['resp'].data.id}
  ${docid}=  Get Variable Value  ${USERS.users['${provider}'].bidresponses['bid_doc_upload']['upload_response'].data.id}
  ${bid_doc_modified}=  Викликати для учасника  ${provider}  Змінити документ в ставці  ${filepath}  ${bidid}  ${docid}
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses}  bid_doc_modified=${bid_doc_modified}


Неможливість задати запитання після закінчення періоду уточнень
  [Documentation]
  ...      `Задати питання` should not pass in this test case.
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість задати запитання
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ${question}=  Підготовка даних для запитання
  Require Failure  ${provider}  Задати питання  ${TENDER['TENDER_UAID']}  ${question}


Можливість подати цінову пропозицію другим учасником
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      minimal
  [Setup]  Дочекатись дати початку прийому пропозицій  ${provider1}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${bid}=  Підготувати дані для подання пропозиції
  Log  ${bid}
  ${bidresponses}=  Create Dictionary  bid=${bid}
  Set To Dictionary  ${USERS.users['${provider1}']}  bidresponses=${bidresponses}
  ${resp}=  Викликати для учасника  ${provider1}  Подати цінову пропозицію  ${TENDER['TENDER_UAID']}  ${bid}
  Set To Dictionary  ${USERS.users['${provider1}'].bidresponses}  resp=${resp}
  Log  ${resp}
  Log  ${USERS.users['${provider1}'].bidresponses}


Неможливість побачити цінові пропозиції учасників під час прийому пропозицій
  [Tags]   ${USERS.users['${viewer}'].broker}: Подання пропозиції
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Require Failure  ${viewer}  Отримати інформацію із тендера  bids


Можливість завантажити документ другим учасником
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      level2
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider1}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Log  ${USERS.users['${provider1}'].broker}
  ${filepath}=  create_fake_doc
  ${bid_doc_upload}=  Викликати для учасника  ${provider1}  Завантажити документ в ставку  ${filepath}  ${TENDER['TENDER_UAID']}
  Set To Dictionary  ${USERS.users['${provider1}'].bidresponses}  bid_doc_upload=${bid_doc_upload}


Неможливість змінити цінову пропозицію до 90000 після закінчення прийому пропозицій
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  [Setup]  Дочекатись дати закінчення прийому пропозицій  ${provider1}
  ${failfixbidto90000resp}=  Require Failure  ${provider1}  Змінити цінову пропозицію  ${TENDER['TENDER_UAID']}  value.amount  90000
  Set To Dictionary  ${USERS.users['${provider1}'].bidresponses}  failfixbidto90000resp=${failfixbidto90000resp}
  Log  ${failfixbidto90000resp}


Неможливість змінити цінову пропозицію до 50001 після закінчення прийому пропозицій
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ${failfixbidto50001resp}=  Require Failure  ${provider1}  Змінити цінову пропозицію  ${TENDER['TENDER_UAID']}  value.amount  50001
  Set To Dictionary  ${USERS.users['${provider1}'].bidresponses}  failfixbidto50001resp=${failfixbidto50001resp}
  Log  ${failfixbidto50001resp}


Неможливість скасувати цінову пропозицію після закінчення прийому пропозицій
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ${biddingresponse}=  Require Failure  ${provider1}  Скасувати цінову пропозицію  ${TENDER['TENDER_UAID']}  ${USERS.users['${provider1}'].bidresponses['resp']}


Неможливість завантажити документ другим учасником після закінчення прийому пропозицій
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ${filepath}=   create_fake_doc
  ${bid_doc_upload_fail}=  Require Failure  ${provider1}  Завантажити документ в ставку  ${filepath}  ${TENDER['TENDER_UAID']}
  Set To Dictionary  ${USERS.users['${provider1}'].bidresponses}  bid_doc_upload_fail=${bid_doc_upload_fail}


Неможливість змінити існуючу документацію цінової пропозиції після закінчення прийому пропозицій
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції
  ...      ${USERS.users['${provider1}'].broker}:
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ${filepath}=  create_fake_doc
  ${bidid}=  Get Variable Value  ${USERS.users['${provider1}'].bidresponses['resp'].data.id}
  ${docid}=  Get Variable Value  ${USERS.users['${provider1}'].bidresponses['bid_doc_upload']['upload_response'].data.id}
  ${bid_doc_modified_failed}=  Require Failure  ${provider1}  Змінити документ в ставці  ${filepath}  ${bidid}  ${docid}
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses}  bid_doc_modified_failed=${bid_doc_modified_failed}


Можливість вичитати посилання на аукціон для глядача
  [Tags]   ${USERS.users['${viewer}'].broker}: Участь в аукціоні
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      minimal
  [Setup]  Дочекатись дати закінчення прийому пропозицій  ${viewer}
  ${url}=  Викликати для учасника  ${viewer}  Отримати посилання на аукціон для глядача  ${TENDER['TENDER_UAID']}
  Should Be True  '${url}'
  Should Match Regexp  ${url}  ^https?:\/\/auction(?:-sandbox)?\.ea\.openprocurement\.org\/auctions\/([0-9A-Fa-f]{32})
  Log  URL аукціону для глядача: ${url}


Можливість вичитати посилання на участь в аукціоні для першого учасника
  [Tags]   ${USERS.users['${provider}'].broker}: Участь в аукціоні
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      minimal
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  ${url}=  Викликати для учасника  ${provider}  Отримати посилання на аукціон для учасника  ${TENDER['TENDER_UAID']}
  Should Be True  '${url}'
  Should Match Regexp  ${url}  ^https?:\/\/auction(?:-sandbox)?\.ea\.openprocurement\.org\/auctions\/([0-9A-Fa-f]{32})
  Log  URL аукціону для першого учасника: ${url}


Можливість вичитати посилання на участь в аукціоні для другого учасника
  [Tags]   ${USERS.users['${provider1}'].broker}: Участь в аукціоні
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      minimal
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider1}
  ${url}=  Викликати для учасника  ${provider1}  Отримати посилання на аукціон для учасника  ${TENDER['TENDER_UAID']}
  Should Be True  '${url}'
  Should Match Regexp  ${url}  ^https?:\/\/auction(?:-sandbox)?\.ea\.openprocurement\.org\/auctions\/([0-9A-Fa-f]{32})
  Log  URL аукціону для другого учасника: ${url}
