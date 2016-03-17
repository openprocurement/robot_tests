*** Settings ***
Library            op_robot_tests.tests_files.service_keywords
Library            Collections
Resource           keywords.robot
Resource           resource.robot

*** Keywords ***
Можливість оголосити тендер
  ${tender_data}=  Підготовка даних для створення тендера
  ${TENDER_UAID}=  Викликати для учасника  ${tender_owner}  Створити тендер  ${tender_data}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  initial_data=${tender_data}
  Set To Dictionary  ${TENDER}  TENDER_UAID=${TENDER_UAID}
  Log  ${TENDER}


Можливість додати тендерну документацію
  ${filepath}=  create_fake_doc
  ${doc_upload_reply}=  Викликати для учасника  ${tender_owner}  Завантажити документ  ${filepath}  ${TENDER['TENDER_UAID']}
  ${file_upload_process_data} =  Create Dictionary  filepath=${filepath}  doc_upload_reply=${doc_upload_reply}
  Log  ${file_upload_process_data}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  documents=${file_upload_process_data}
  Log  ${USERS.users['${tender_owner}']}


Можливість знайти тендер по ідентифікатору
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}  ${provider}  ${provider1}
  \  Дочекатись синхронізації з майданчиком  ${username}
  \  Викликати для учасника  ${username}  Пошук тендера по ідентифікатору  ${TENDER['TENDER_UAID']}


Можливість редагувати однопредметний тендер
  Викликати для учасника  ${tender_owner}  Внести зміни в тендер  ${TENDER['TENDER_UAID']}  description  description


Можливість задати питання
  ${question}=  Підготовка даних для запитання
  ${question_resp}=  Викликати для учасника  ${provider}  Задати питання  ${TENDER['TENDER_UAID']}  ${question}
  ${now}=  Get Current TZdate
  ${question.data.date}=  Set variable  ${now}
  ${question_data}=  Create Dictionary  question=${question}  question_resp=${question_resp}
  ${question_data}=  munch_dict  arg=${question_data}
  Set To Dictionary  ${USERS.users['${provider}']}  question_data=${question_data}


Неможливість подати цінову пропозицію до початку періоду подачі пропозицій першим учасником
  ${bid}=  test bid data
  Log  ${bid}
  ${bidresponses}=  Create Dictionary  bid=${bid}
  Set To Dictionary  ${USERS.users['${provider}']}  bidresponses=${bidresponses}
  ${bid_before_bidperiod_resp}=  Require Failure  ${provider}  Подати цінову пропозицію  ${TENDER['TENDER_UAID']}  ${bid}
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses}  bid_before_bidperiod_resp=${bid_before_bidperiod_resp}
  Log  ${USERS.users['${provider}']}


Можливість відповісти на запитання
  ${answer}=  Підготовка даних для відповіді на запитання
  ${answer_resp}=  Викликати для учасника  ${tender_owner}  Відповісти на питання  ${TENDER['TENDER_UAID']}  ${USERS.users['${provider}']['question_data']['question_resp']}  ${answer}
  ${now}=  Get Current TZdate
  ${answer.data.date}=  Set variable  ${now}
  ${answer_data}=  Create Dictionary  answer=${answer}  answer_resp=${answer_resp}
  Set To Dictionary  ${USERS.users['${provider}']}  answer_data=${answer_data}


Можливість подати цінову пропозицію першим учасником
  Дочекатись дати початку прийому пропозицій  ${provider}
  ${bid}=  test bid data
  Log  ${bid}
  ${bidresponses}=  Create Dictionary  bid=${bid}
  Set To Dictionary  ${USERS.users['${provider}']}  bidresponses=${bidresponses}
  ${resp}=  Викликати для учасника  ${provider}  Подати цінову пропозицію  ${TENDER['TENDER_UAID']}  ${bid}
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses}  resp=${resp}
  Log  ${USERS.users['${provider}'].bidresponses}


Можливість скасувати цінову пропозицію
  ${canceledbidresp}=  Викликати для учасника  ${provider}  Скасувати цінову пропозицію  ${TENDER['TENDER_UAID']}  ${USERS.users['${provider}'].bidresponses['resp']}
  Log  ${canceledbidresp}


Можливість подати повторно цінову пропозицію першим учасником
  Дочекатись дати початку прийому пропозицій  ${provider}
  ${bid}=  test bid data
  Log  ${bid}
  ${bidresponses}=  Create Dictionary  bid=${bid}
  Set To Dictionary  ${USERS.users['${provider}']}  bidresponses=${bidresponses}
  ${resp}=  Викликати для учасника  ${provider}  Подати цінову пропозицію  ${TENDER['TENDER_UAID']}  ${bid}
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses}  resp=${resp}
  Log  ${USERS.users['${provider}'].bidresponses}


Можливість змінити повторну цінову пропозицію до 50000
  ${fixbidto50000resp}=  Викликати для учасника  ${provider}  Змінити цінову пропозицію  ${TENDER['TENDER_UAID']}  value.amount  50000
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses}  fixbidto50000resp=${fixbidto50000resp}
  Log  ${fixbidto50000resp}


Можливість змінити повторну цінову пропозицію до 10
  ${fixbidto10resp}=  Викликати для учасника  ${provider}  Змінити цінову пропозицію  ${TENDER['TENDER_UAID']}  value.amount  10
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses}  fixbidto10resp=${fixbidto10resp}
  Log  ${fixbidto10resp}


Можливість завантажити документ першим учасником в повторну пропозицію
  Log  ${USERS.users['${provider}'].broker}
  ${filepath}=  create_fake_doc
  ${bid_doc_upload}=  Викликати для учасника  ${provider}  Завантажити документ в ставку  ${filepath}  ${TENDER['TENDER_UAID']}
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses}  bid_doc_upload=${bid_doc_upload}


Можливість змінити документацію цінової пропозиції
  Log  ${USERS.users['${provider}'].broker}
  ${filepath}=  create_fake_doc
  ${bidid}=  Get Variable Value  ${USERS.users['${provider}'].bidresponses['resp'].data.id}
  ${docid}=  Get Variable Value  ${USERS.users['${provider}'].bidresponses['bid_doc_upload']['upload_response'].data.id}
  ${bid_doc_modified}=  Викликати для учасника  ${provider}  Змінити документ в ставці  ${filepath}  ${bidid}  ${docid}
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses}  bid_doc_modified=${bid_doc_modified}


Неможливість задати запитання після закінчення періоду уточнень
  ${question}=  Підготовка даних для запитання
  Require Failure  ${provider}  Задати питання  ${TENDER['TENDER_UAID']}  ${question}


Можливість подати цінову пропозицію другим учасником
  Дочекатись дати початку прийому пропозицій  ${provider1}
  ${bid}=  test bid data
  Log  ${bid}
  ${bidresponses}=  Create Dictionary  bid=${bid}
  Set To Dictionary  ${USERS.users['${provider1}']}  bidresponses=${bidresponses}
  ${resp}=  Викликати для учасника  ${provider1}  Подати цінову пропозицію  ${TENDER['TENDER_UAID']}  ${bid}
  Set To Dictionary  ${USERS.users['${provider1}'].bidresponses}  resp=${resp}
  Log  ${resp}
  Log  ${USERS.users['${provider1}'].bidresponses}


Неможливість побачити цінові пропозиції учасників під час прийому пропозицій
  Require Failure  ${viewer}  Отримати інформацію із тендера  bids


Можливість завантажити документ другим учасником
  Log  ${USERS.users['${provider1}'].broker}
  ${filepath}=  create_fake_doc
  ${bid_doc_upload}=  Викликати для учасника  ${provider1}  Завантажити документ в ставку  ${filepath}  ${TENDER['TENDER_UAID']}
  Set To Dictionary  ${USERS.users['${provider1}'].bidresponses}  bid_doc_upload=${bid_doc_upload}


Неможливість змінити цінову пропозицію до 50000 після закінчення прийому пропозицій
  Дочекатись дати закінчення прийому пропозицій  ${provider1}
  ${failfixbidto50000resp}=  Require Failure  ${provider1}  Змінити цінову пропозицію  ${TENDER['TENDER_UAID']}  value.amount  50000
  Set To Dictionary  ${USERS.users['${provider1}'].bidresponses}  failfixbidto50000resp=${failfixbidto50000resp}
  Log  ${failfixbidto50000resp}


Неможливість змінити цінову пропозицію до 1 після закінчення прийому пропозицій
  ${failfixbidto1resp}=  Require Failure  ${provider1}  Змінити цінову пропозицію  ${TENDER['TENDER_UAID']}  value.amount  1
  Set To Dictionary  ${USERS.users['${provider1}'].bidresponses}  failfixbidto1resp=${failfixbidto1resp}
  Log  ${failfixbidto1resp}


Неможливість скасувати цінову пропозицію
  ${biddingresponse}=  Require Failure  ${provider1}  Скасувати цінову пропозицію  ${TENDER['TENDER_UAID']}  ${USERS.users['${provider1}'].bidresponses['resp']}


Неможливість завантажити документ другим учасником після закінчення прийому пропозицій
  ${filepath}=   create_fake_doc
  ${bid_doc_upload_fail}=  Require Failure  ${provider1}  Завантажити документ в ставку  ${filepath}  ${TENDER['TENDER_UAID']}
  Set To Dictionary  ${USERS.users['${provider1}'].bidresponses}  bid_doc_upload_fail=${bid_doc_upload_fail}


Неможливість змінити існуючу документацію цінової пропозиції після закінчення прийому пропозицій
  ${filepath}=  create_fake_doc
  ${bidid}=  Get Variable Value  ${USERS.users['${provider1}'].bidresponses['resp'].data.id}
  ${docid}=  Get Variable Value  ${USERS.users['${provider1}'].bidresponses['bid_doc_upload']['upload_response'].data.id}
  ${bid_doc_modified_failed}=  Require Failure  ${provider1}  Змінити документ в ставці  ${filepath}  ${bidid}  ${docid}
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses}  bid_doc_modified_failed=${bid_doc_modified_failed}


Можливість вичитати посилання на аукціон для глядача
  Дочекатись дати закінчення прийому пропозицій  ${viewer}
  Sleep  120
  ${url}=  Викликати для учасника  ${viewer}  Отримати посилання на аукціон для глядача  ${TENDER['TENDER_UAID']}
  Should Be True  '${url}'
  Should Match Regexp  ${url}  ^https?:\/\/auction(?:-sandbox)?\.openprocurement\.org\/tenders\/([0-9A-Fa-f]{32})
  Log  URL аукціону для глядача: ${url}


Можливість вичитати посилання на участь в аукціоні для першого учасника
  ${url}=  Викликати для учасника  ${provider}  Отримати посилання на аукціон для учасника  ${TENDER['TENDER_UAID']}
  Should Be True  '${url}'
  Should Match Regexp  ${url}  ^https?:\/\/auction(?:-sandbox)?\.openprocurement\.org\/tenders\/([0-9A-Fa-f]{32})
  Log  URL аукціону для першого учасника: ${url}


Можливість вичитати посилання на участь в аукціоні для другого учасника
  ${url}=  Викликати для учасника  ${provider1}  Отримати посилання на аукціон для учасника  ${TENDER['TENDER_UAID']}
  Should Be True  '${url}'
  Should Match Regexp  ${url}  ^https?:\/\/auction(?:-sandbox)?\.openprocurement\.org\/tenders\/([0-9A-Fa-f]{32})
  Log  URL аукціону для другого учасника: ${url}

##############################################################################################
#             ВІДОБРАЖЕННЯ
##############################################################################################

Відображення заголовку тендера
  :FOR  ${username}  IN  ${viewer}  ${provider}  ${provider1}
  \  Дочекатись синхронізації з майданчиком  ${username}
  \  Звірити поле тендера  ${username}  ${USERS.users['${tender_owner}'].initial_data}  title


Відображення заголовку документа тендера
  ${doc_num}=  Set variable  0
  :FOR  ${username}  IN  ${viewer}  ${provider}  ${provider1}
  \  Дочекатись синхронізації з майданчиком  ${username}
  \  Звірити поле тендера із значенням  ${username}
  \  ...      ${USERS.users['${tender_owner}']['documents']['filepath']}
  \  ...      documents[${doc_num}].title


Відображення опису тендера
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  description


Відображення бюджету тендера
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  value.amount


Відображення ідентифікатора тендера
  Звірити поле тендера із значенням  ${viewer}  ${TENDER['TENDER_UAID']}  tenderID


Відображення імені замовника тендера
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  procuringEntity.name


Відображення початку періоду уточнення тендера
  Звірити дату тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  enquiryPeriod.startDate


Відображення закінчення періоду уточнення тендера
  Звірити дату тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  enquiryPeriod.endDate


Відображення початку періоду прийому пропозицій тендера
  :FOR  ${username}  IN  ${viewer}  ${provider}  ${provider1}
  \  Дочекатись синхронізації з майданчиком  ${username}
  \  Звірити дату тендера  ${username}  ${USERS.users['${tender_owner}'].initial_data}  tenderPeriod.startDate


Відображення закінчення періоду прийому пропозицій тендера
  :FOR  ${username}  IN  ${viewer}  ${provider}  ${provider1}
  \  Дочекатись синхронізації з майданчиком  ${username}
  \  Звірити дату тендера  ${username}  ${USERS.users['${tender_owner}'].initial_data}  tenderPeriod.endDate


Відображення мінімального кроку тендера
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  minimalStep.amount


Відображення дати доставки позицій закупівлі тендера
  Звірити дату тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  items[0].deliveryDate.endDate


Відображення координат широти доставки позицій закупівлі тендера
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  items[0].deliveryLocation.latitude


Відображення координат довготи доставки позицій закупівлі тендера
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  items[0].deliveryLocation.longitude


Відображення назви нас. пункту доставки позицій закупівлі тендера
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  items[0].deliveryAddress.countryName


Відображення пошт. коду доставки позицій закупівлі тендера
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  items[0].deliveryAddress.postalCode


Відображення регіону доставки позицій закупівлі тендера
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  items[0].deliveryAddress.region


Відображення населеного пункту адреси доставки позицій закупівлі тендера
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  items[0].deliveryAddress.locality


Відображення вулиці доставки позицій закупівлі тендера
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  items[0].deliveryAddress.streetAddress


Відображення схеми класифікації позицій закупівлі тендера
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  items[0].classification.scheme


Відображення ідентифікатора класифікації позицій закупівлі тендера
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  items[0].classification.id


Відображення опису класифікації позицій закупівлі тендера
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  items[0].classification.description


Відображення схеми додаткової класифікації позицій закупівлі тендера
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  items[0].additionalClassifications[0].scheme


Відображення ідентифікатора додаткової класифікації позицій закупівлі тендера
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  items[0].additionalClassifications[0].id


Відображення опису додаткової класифікації позицій закупівлі тендера
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  items[0].additionalClassifications[0].description


Відображення назви одиниці позицій закупівлі тендера
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  items[0].unit.name


Відображення коду одиниці позицій закупівлі тендера
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  items[0].unit.code


Відображення кількості позицій закупівлі тендера
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  items[0].quantity


Відображення опису позицій закупівлі тендера
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  items[0].description


Відображення заголовку анонімного питання без відповіді
  Викликати для учасника  ${viewer}  Оновити сторінку з тендером  ${TENDER['TENDER_UAID']}
  Звірити поле тендера із значенням  ${viewer}  ${USERS.users['${provider}'].question_data.question.data.title}  questions[${question_id}].title


Відображення опису анонімного питання без відповіді
  Звірити поле тендера із значенням  ${viewer}  ${USERS.users['${provider}'].question_data.question.data.description}  questions[${question_id}].description


Відображення дати анонімного питання без відповіді
  Звірити дату тендера із значенням  ${viewer}  ${USERS.users['${provider}'].question_data.question.data.date}  questions[${question_id}].date


Відображення відповіді на запитання
  Викликати для учасника  ${viewer}  Оновити сторінку з тендером  ${TENDER['TENDER_UAID']}
  Звірити поле тендера із значенням  ${viewer}  ${USERS.users['${provider}']['answer_data']['answer'].data.answer}  questions[${question_id}].answer
