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
${role}         viewer
${broker}       Quinta

*** Test Cases ***
Можливість оголосити однопредметний тендер
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  from-0.12
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${tender_data}=  Підготовка даних для створення тендера
  ${adapted_data}=  Адаптувати дані для оголошення тендера  ${tender_owner}  ${tender_data}
  ${TENDER_UAID}=  Викликати для учасника  ${tender_owner}
  ...      Створити тендер
  ...      ${adapted_data}
  Set To Dictionary  ${TENDER}  TENDER_UAID  ${TENDER_UAID}
  Log  ${TENDER}


Можливість знайти однопредметний тендер по ідентифікатору для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Пошук тендера по ідентифікатору
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  from-0.12
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Викликати для учасника  ${viewer}
  ...      Пошук тендера по ідентифікатору
  ...      ${TENDER['TENDER_UAID']}


Можливість знайти однопредметний тендер по ідентифікатору для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Пошук тендера по ідентифікатору
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  Викликати для учасника  ${provider}
  ...      Пошук тендера по ідентифікатору
  ...      ${TENDER['TENDER_UAID']}


Можливість створити вимогу про виправлення умов закупівлі, додати до неї документацію і подати її
  [Tags]  ${USERS.users['${provider}'].broker}: Можливість створити вимогу про виправлення умов закупівлі, додати до неї документацію і подати її
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${claim}=  Підготовка даних для подання вимоги
  ${document}=  create_fake_doc
  ${complaintID}=  Викликати для учасника  ${provider}
  ...      Створити вимогу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${claim}
  ...      ${document}
  ${claim_data}=  Create Dictionary  claim=${claim}  complaintID=${complaintID}  document=${document}
  Set To Dictionary  ${USERS.users['${provider}']}  claim_data  ${claim_data}
  ${CLAIM_NUM}=  Set variable  0
  Set suite variable  ${CLAIM_NUM}

##############################################################################################
#             ВІДОБРАЖЕННЯ ДЛЯ ГЛЯДАЧА
##############################################################################################

Відображення опису вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: опису Відображення вимоги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  from-0.12
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${provider}'].claim_data['claim'].data.description}
  ...      complaints[${CLAIM_NUM}].description


Відображення заголовку вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення заголовку вимоги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${provider}'].claim_data['claim'].data.title}
  ...      complaints[${CLAIM_NUM}].title


Відображення заголовку документації вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення заголовку документації для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  from-0.12
  ${doc_num}=  Set variable  0
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${provider}'].claim_data['document']}
  ...      complaints[${CLAIM_NUM}].documents[${doc_num}].title


Відображення поданого статусу вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення поданого статусу вимоги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${viewer}
  ...      claim
  ...      complaints[${CLAIM_NUM}].status

##############################################################################################
#             ВІДОБРАЖЕННЯ ДЛЯ КОРИСТУВАЧА
##############################################################################################

Відображення опису вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: опису Відображення вимоги для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${provider}'].claim_data['claim'].data.description}
  ...      complaints[${CLAIM_NUM}].description


Відображення заголовку вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Відображення заголовку вимоги для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${provider}'].claim_data['claim'].data.title}
  ...      complaints[${CLAIM_NUM}].title


Відображення заголовку документації вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Відображення заголовку документації для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
  ${doc_num}=  Set variable  0
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${provider}'].claim_data['document']}
  ...      complaints[${CLAIM_NUM}].documents[${doc_num}].title


Відображення поданого статусу вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Відображення поданого статусу вимоги для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${provider}
  ...      claim
  ...      complaints[${CLAIM_NUM}].status

##############################################################################################
#             МОЖЛИВІСТЬ
##############################################################################################

Можливість відповісти на вимогу про виправлення умов закупівлі
  [Tags]  ${USERS.users['${tender_owner}'].broker}:Можливість відповісти на вирішену вимогу про виправлення умов закупівлі
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  from-0.12
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${answer_data}=  test_claim_answer_data
  Log  ${answer_data}
  Викликати для учасника  ${tender_owner}
  ...      Відповісти на вимогу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['claim_data']['complaintID']}
  ...      ${answer_data}
  ${claim_data}=  Create Dictionary  claim_answer=${answer_data}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  claim_data  ${claim_data}

##############################################################################################
#             ВІДОБРАЖЕННЯ ДЛЯ ГЛЯДАЧА
##############################################################################################

Відображення статусу 'answered' вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення статусу 'answered' вимоги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  from-0.12
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${tender_owner}'].claim_data['claim_answer']['data']['status']}
  ...      complaints[${CLAIM_NUM}].status


Відображення типу вирішення вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення типу вирішення вимоги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${tender_owner}'].claim_data['claim_answer']['data']['resolutionType']}
  ...      complaints[${CLAIM_NUM}].resolutionType


Відображення вирішення вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення вирішення вимоги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${tender_owner}'].claim_data['claim_answer']['data']['resolution']}
  ...      complaints[${CLAIM_NUM}].resolution

##############################################################################################
#             ВІДОБРАЖЕННЯ ДЛЯ КОРИСТУВАЧА
##############################################################################################

Відображення статусу 'answered' вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Відображення статусу 'answered' вимоги для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${tender_owner}'].claim_data['claim_answer']['data']['status']}
  ...      complaints[${CLAIM_NUM}].status


Відображення типу вирішення вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Відображення типу вирішення вимоги для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${tender_owner}'].claim_data['claim_answer']['data']['resolutionType']}
  ...      complaints[${CLAIM_NUM}].resolutionType


Відображення вирішення вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Відображення вирішення вимоги для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${tender_owner}'].claim_data['claim_answer']['data']['resolution']}
  ...      complaints[${CLAIM_NUM}].resolution

##############################################################################################
#             МОЖЛИВІСТЬ
##############################################################################################

Можливість підтвердити задоволення вимоги про виправлення умов закупівлі
  [Tags]  ${USERS.users['${provider}'].broker}:Можливість підтвердити задоволення вимоги про виправлення умов закупівлі
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${data}=  Create Dictionary  status=resolved  satisfied=${True}
  ${confirmation_data}=  Create Dictionary  data=${data}
  Викликати для учасника  ${provider}
  ...      Підтвердити вирішення вимоги
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['claim_data']['complaintID']}
  ...      ${confirmation_data}
  Set To Dictionary  ${USERS.users['${provider}']['claim_data']}  claim_answer_confirm  ${confirmation_data}

##############################################################################################
#             ВІДОБРАЖЕННЯ ДЛЯ ГЛЯДАЧА
##############################################################################################

Відображення статусу 'resolved' вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення статусу 'resolved' вимоги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  from-0.12
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${provider}'].claim_data['claim_answer_confirm']['data']['status']}
  ...      complaints[${CLAIM_NUM}].status


Відображення задоволення вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення задоволення вимоги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${provider}'].claim_data['claim_answer_confirm']['data']['satisfied']}
  ...      complaints[${CLAIM_NUM}].satisfied

##############################################################################################
#             ВІДОБРАЖЕННЯ ДЛЯ КОРИСТУВАЧА
##############################################################################################

Відображення статусу 'resolved' вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Відображення статусу 'resolved' вимоги для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${provider}'].claim_data['claim_answer_confirm']['data']['status']}
  ...      complaints[${CLAIM_NUM}].status


Відображення задоволення вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Відображення задоволення вимоги для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${provider}'].claim_data['claim_answer_confirm']['data']['satisfied']}
  ...      complaints[${CLAIM_NUM}].satisfied

##############################################################################################
#             МОЖЛИВІСТЬ
##############################################################################################

Можливість створити чернетку вимоги про виправлення умов закупівлі і скасувати її
  [Tags]  ${USERS.users['${provider}'].broker}: Можливість створити чернетку вимоги про виправлення умов закупівлі і скасувати її
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${claim}=  Підготовка даних для подання вимоги
  ${complaintID}=  Викликати для учасника  ${provider}
  ...      Створити чернетку вимоги
  ...      ${TENDER['TENDER_UAID']}
  ...      ${claim}
  ${claim_data2}=  Create Dictionary  claim=${claim}  complaintID=${complaintID}
  Set To Dictionary  ${USERS.users['${provider}']}  claim_data2  ${claim_data2}
  ${CLAIM_NUM}=  Set variable  1
  Set suite variable  ${CLAIM_NUM}


  ${cancellation_reason}=  create_fake_sentence
  ${data}=  Create Dictionary  status=cancelled  cancellationReason=${cancellation_reason}
  ${cancellation_data}=  Create Dictionary  data=${data}
  Викликати для учасника  ${provider}
  ...      Скасувати вимогу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['claim_data2']['complaintID']}
  ...      ${cancellation_data}
  Set To Dictionary  ${USERS.users['${provider}'].claim_data2}  cancellation  ${cancellation_data}

##############################################################################################
#             ВІДОБРАЖЕННЯ ДЛЯ ГЛЯДАЧА
##############################################################################################

Відображення статусу 'cancelled' чернетки вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення статусу 'cancelled' чернетки вимоги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  from-0.12
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${provider}'].claim_data2['cancellation']['data']['status']}
  ...      complaints[${CLAIM_NUM}].status


Відображення причини скасування чернетки вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення причини скасування чернетки вимоги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${provider}'].claim_data2['cancellation']['data']['cancellationReason']}
  ...      complaints[${CLAIM_NUM}].cancellationReason

##############################################################################################
#             ВІДОБРАЖЕННЯ ДЛЯ КОРИСТУВАЧА
##############################################################################################

Відображення статусу 'cancelled' чернетки вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Відображення статусу 'cancelled' чернетки вимоги для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${provider}'].claim_data2['cancellation']['data']['status']}
  ...      complaints[${CLAIM_NUM}].status


Відображення причини скасування чернетки вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Відображення причини скасування чернетки вимоги для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${provider}'].claim_data2['cancellation']['data']['cancellationReason']}
  ...      complaints[${CLAIM_NUM}].cancellationReason

##############################################################################################
#             МОЖЛИВІСТЬ
##############################################################################################

Можливість створити, подати і скасувати вимогу про виправлення умов закупівлі
  [Tags]  ${USERS.users['${provider}'].broker}: Можливість створити, подати і скасувати вимогу про виправлення умов закупівлі
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${claim}=  Підготовка даних для подання вимоги
  ${complaintID}=  Викликати для учасника  ${provider}
  ...      Створити вимогу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${claim}
  ${claim_data3}=  Create Dictionary  claim=${claim}  complaintID=${complaintID}
  Set To Dictionary  ${USERS.users['${provider}']}  claim_data3  ${claim_data3}
  ${CLAIM_NUM}=  Set variable  2
  Set suite variable  ${CLAIM_NUM}


  ${cancellation_reason}=  create_fake_sentence
  ${data}=  Create Dictionary  status=cancelled  cancellationReason=${cancellation_reason}
  ${cancellation_data}=  Create Dictionary  data=${data}
  Викликати для учасника  ${provider}
  ...      Скасувати вимогу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['claim_data3']['complaintID']}
  ...      ${cancellation_data}
  Set To Dictionary  ${USERS.users['${provider}'].claim_data3}  cancellation  ${cancellation_data}

##############################################################################################
#             ВІДОБРАЖЕННЯ ДЛЯ ГЛЯДАЧА
##############################################################################################

Відображення статусу 'cancelled' після 'draft -> claim' вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення статусу 'cancelled' вимоги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  from-0.12
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${provider}'].claim_data3['cancellation']['data']['status']}
  ...      complaints[${CLAIM_NUM}].status

##############################################################################################
#             ВІДОБРАЖЕННЯ ДЛЯ КОРИСТУВАЧА
##############################################################################################

Відображення статусу 'cancelled' після 'draft -> claim' вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Відображення статусу 'cancelled' вимоги для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${provider}'].claim_data3['cancellation']['data']['status']}
  ...      complaints[${CLAIM_NUM}].status

##############################################################################################
#             МОЖЛИВІСТЬ
##############################################################################################

Можливість створити, подати, відповісти і після того скасувати вимогу про виправлення умов закупівлі
  [Tags]  ${USERS.users['${provider}'].broker}: Можливість створити, подати, відповісти і після того скасувати вимогу про виправлення умов закупівлі
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${claim}=  Підготовка даних для подання вимоги
  ${complaintID}=  Викликати для учасника  ${provider}
  ...      Створити вимогу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${claim}
  ${claim_data4}=  Create Dictionary  claim=${claim}  complaintID=${complaintID}
  Set To Dictionary  ${USERS.users['${provider}']}  claim_data4  ${claim_data4}
  ${CLAIM_NUM}=  Set variable  3
  Set suite variable  ${CLAIM_NUM}


  ${answer_data}=  test_claim_answer_data
  Log  ${answer_data}
  Викликати для учасника  ${tender_owner}
  ...      Відповісти на вимогу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['claim_data4']['complaintID']}
  ...      ${answer_data}


  ${cancellation_reason}=  create_fake_sentence
  ${data}=  Create Dictionary  status=cancelled  cancellationReason=${cancellation_reason}
  ${cancellation_data}=  Create Dictionary  data=${data}
  Викликати для учасника  ${provider}
  ...      Скасувати вимогу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['claim_data4']['complaintID']}
  ...      ${cancellation_data}
  Set To Dictionary  ${USERS.users['${provider}'].claim_data4}  cancellation  ${cancellation_data}

##############################################################################################
#             ВІДОБРАЖЕННЯ ДЛЯ ГЛЯДАЧА
##############################################################################################

Відображення статусу 'cancelled' після 'draft -> claim -> answered' вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення статусу 'cancelled' після 'draft -> claim -> answered' вимоги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  from-0.12
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Log  ${USERS.users['${viewer}'].tender_data}
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${provider}'].claim_data4['cancellation']['data']['status']}
  ...      complaints[${CLAIM_NUM}].status

##############################################################################################
#             ВІДОБРАЖЕННЯ ДЛЯ КОРИСТУВАЧА
##############################################################################################

Відображення статусу 'cancelled' після 'draft -> claim -> answered' вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Відображення статусу 'cancelled' після 'draft -> claim -> answered' вимоги для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${provider}'].claim_data4['cancellation']['data']['status']}
  ...      complaints[${CLAIM_NUM}].status

##############################################################################################
#             МОЖЛИВІСТЬ
##############################################################################################

Можливість створити, подати, відповісти на вимогу і перетворити її в скаргу
  [Tags]  ${USERS.users['${provider}'].broker}: Можливість створити, подати, відповісти і після того скасувати вимогу про виправлення умов закупівлі
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${claim}=  Підготовка даних для подання вимоги
  ${complaintID}=  Викликати для учасника  ${provider}
  ...      Створити вимогу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${claim}
  ${claim_data5}=  Create Dictionary  claim=${claim}  complaintID=${complaintID}
  Set To Dictionary  ${USERS.users['${provider}']}  claim_data5  ${claim_data5}
  ${CLAIM_NUM}=  Set variable  4
  Set suite variable  ${CLAIM_NUM}


  ${answer_data}=  test_claim_answer_data
  Log  ${answer_data}
  Викликати для учасника  ${tender_owner}
  ...      Відповісти на вимогу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['claim_data5']['complaintID']}
  ...      ${answer_data}

  ${data}=  Create Dictionary  status=pending  satisfied=${False}
  ${escalation_data}=  Create Dictionary  data=${data}
  Викликати для учасника  ${provider}
  ...      Перетворити вимогу в скаргу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['claim_data5']['complaintID']}
  ...      ${escalation_data}
  Set To Dictionary  ${USERS.users['${provider}'].claim_data5}  escalation  ${escalation_data}

##############################################################################################
#             ВІДОБРАЖЕННЯ ДЛЯ ГЛЯДАЧА
##############################################################################################

Відображення статусу 'pending' після 'draft -> claim -> answered' вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення статусу 'cancelled' після 'draft -> claim -> answered' вимоги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  from-0.12
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Log  ${USERS.users['${viewer}'].tender_data}
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${provider}'].claim_data5['escalation']['data']['status']}
  ...      complaints[${CLAIM_NUM}].status


Відображення незадоволення вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення незадоволення вимоги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${provider}'].claim_data5['escalation']['data']['satisfied']}
  ...      complaints[${CLAIM_NUM}].satisfied

##############################################################################################
#             ВІДОБРАЖЕННЯ ДЛЯ КОРИСТУВАЧА
##############################################################################################

Відображення статусу 'pending' після 'draft -> claim -> answered' вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Відображення статусу 'cancelled' після 'draft -> claim -> answered' вимоги для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${provider}'].claim_data5['escalation']['data']['status']}
  ...      complaints[${CLAIM_NUM}].status


Відображення незадоволення вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Відображення незадоволення вимоги для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${provider}'].claim_data5['escalation']['data']['satisfied']}
  ...      complaints[${CLAIM_NUM}].satisfied

##############################################################################################
#             МОЖЛИВІСТЬ
##############################################################################################

Можливість скасувати скаргу
  [Tags]  ${USERS.users['${provider}'].broker}: Можливість скасувати скаргу
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${cancellation_reason}=  create_fake_sentence
  ${data}=  Create Dictionary  status=cancelled  cancellationReason=${cancellation_reason}
  ${cancellation_data}=  Create Dictionary  data=${data}
  Викликати для учасника  ${provider}
  ...      Скасувати вимогу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['claim_data5']['complaintID']}
  ...      ${cancellation_data}
  Set To Dictionary  ${USERS.users['${provider}'].claim_data5}  cancellation  ${cancellation_data}

##############################################################################################
#             ВІДОБРАЖЕННЯ ДЛЯ ГЛЯДАЧА
##############################################################################################

Відображення статусу 'cancelled' скарги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення статусу 'cancelled' скарги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  from-0.12
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${provider}'].claim_data5['cancellation']['data']['status']}
  ...      complaints[${CLAIM_NUM}].status


Відображення причини скасування скарги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення причини скасування скарги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${provider}'].claim_data5['cancellation']['data']['cancellationReason']}
  ...      complaints[${CLAIM_NUM}].cancellationReason

##############################################################################################
#             ВІДОБРАЖЕННЯ ДЛЯ КОРИСТУВАЧА
##############################################################################################

Відображення статусу 'cancelled' скарги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Відображення статусу 'cancelled' скарги для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${provider}'].claim_data5['cancellation']['data']['status']}
  ...      complaints[${CLAIM_NUM}].status


Відображення причини скасування скарги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Відображення причини скасування скарги для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${provider}'].claim_data5['cancellation']['data']['cancellationReason']}
  ...      complaints[${CLAIM_NUM}].cancellationReason
