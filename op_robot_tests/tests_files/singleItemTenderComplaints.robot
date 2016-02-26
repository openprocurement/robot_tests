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
${mode}         single
${role}         viewer
${broker}       Quinta

*** Test Cases ***
Можливість оголосити однопредметний тендер
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  from-0.12
  ${tender_data}=  Підготовка початкових даних
  ${TENDER_UAID}=  Викликати для учасника  ${tender_owner}
  ...      Створити тендер
  ...      ${tender_data}
  ${LAST_MODIFICATION_DATE}=  Get Current TZdate
  Set To Dictionary  ${TENDER}  TENDER_UAID  ${TENDER_UAID}
  Set To Dictionary  ${TENDER}  LAST_MODIFICATION_DATE  ${LAST_MODIFICATION_DATE}
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


Можливість створити вимогу про виправлення умов закупівлі
  [Tags]  ${USERS.users['${provider}'].broker}: Можливість подати вимогу про виправлення умов закупівлі
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  ${complaint}=  test_complaint_data
  ${complaint_resp}=  Викликати для учасника  ${provider}
  ...      Створити вимогу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${complaint}
  ${complaint_data}=  Create Dictionary  complaint=${complaint}  complaint_resp=${complaint_resp}
  Set To Dictionary  ${USERS.users['${provider}']}  complaint_data  ${complaint_data}
  ${COMPLAINT_NUM}=  Set variable  0
  Set suite variable  ${COMPLAINT_NUM}


Можливість додати документацію до вимоги про виправлення умов закупівлі
  [Tags]  ${USERS.users['${provider}'].broker}: Можливість додати документацію до вимоги про виправлення умов закупівлі
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
  ${document}=  create_fake_doc
  Викликати для учасника  ${provider}
  ...      Завантажити документацію до вимоги
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['complaint_data']['complaint_resp']}
  ...      ${document}
  Set To Dictionary  ${USERS.users['${provider}']['complaint_data']}  document  ${document}

##############################################################################################
#             ВІДОБРАЖЕННЯ ДЛЯ ГЛЯДАЧА
##############################################################################################

Відображення назви країни адреси автора вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення назви країни адреси автора вимоги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  from-0.12
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${provider}'].complaint_data['complaint'].data.author.address.countryName}
  ...      complaints[${COMPLAINT_NUM}].author.address.countryName


Відображення назви рос. мовою країни адреси автора вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення назви рос. мовою країни адреси автора вимоги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${provider}'].complaint_data['complaint'].data.author.address.countryName_ru}
  ...      complaints[${COMPLAINT_NUM}].author.address.countryName_ru


Відображення назви англ. мовою країни адреси автора вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення назви англ. мовою країни адреси автора вимоги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${provider}'].complaint_data['complaint'].data.author.address.countryName_en}
  ...      complaints[${COMPLAINT_NUM}].author.address.countryName_en


Відображення міста адреси автора вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення міста адреси автора вимоги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${provider}'].complaint_data['complaint'].data.author.address.locality}
  ...      complaints[${COMPLAINT_NUM}].author.address.locality


Відображення поштового коду адреси автора вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення поштового коду адреси автора вимоги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${provider}'].complaint_data['complaint'].data.author.address.postalCode}
  ...      complaints[${COMPLAINT_NUM}].author.address.postalCode


Відображення області адреси автора вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення області адреси автора вимоги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${provider}'].complaint_data['complaint'].data.author.address.region}
  ...      complaints[${COMPLAINT_NUM}].author.address.region


Відображення вулиці адреси автора вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення вулиці адреси автора вимоги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${provider}'].complaint_data['complaint'].data.author.address.streetAddress}
  ...      complaints[${COMPLAINT_NUM}].author.address.streetAddress


Відображення контактного імені автора вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення контактного імені автора вимоги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${provider}'].complaint_data['complaint'].data.author.contactPoint.name}
  ...      complaints[${COMPLAINT_NUM}].author.contactPoint.name


Відображення контактного телефону автора вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення контактного телефону автора вимоги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${provider}'].complaint_data['complaint'].data.author.contactPoint.telephone}
  ...      complaints[${COMPLAINT_NUM}].author.contactPoint.telephone


Відображення ідентифікатора автора вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення ідентифікатора автора вимоги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${provider}'].complaint_data['complaint'].data.author.identifier.id}
  ...      complaints[${COMPLAINT_NUM}].author.identifier.id


Відображення схеми ідентифікації автора вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення схеми ідентифікації автора вимоги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${provider}'].complaint_data['complaint'].data.author.identifier.scheme}
  ...      complaints[${COMPLAINT_NUM}].author.identifier.scheme


Відображення uri ідентифікатора автора вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення uriідентифікатора автора вимоги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${provider}'].complaint_data['complaint'].data.author.identifier.uri}
  ...      complaints[${COMPLAINT_NUM}].author.identifier.uri


Відображення імені автора вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення імені автора вимоги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${provider}'].complaint_data['complaint'].data.author.name}
  ...      complaints[${COMPLAINT_NUM}].author.name


Відображення опису вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: опису Відображення вимоги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${provider}'].complaint_data['complaint'].data.description}
  ...      complaints[${COMPLAINT_NUM}].description


Відображення заголовку вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення заголовку вимоги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${provider}'].complaint_data['complaint'].data.title}
  ...      complaints[${COMPLAINT_NUM}].title


Відображення заголовку документації вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення заголовку документації для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  from-0.12
  ${doc_num}=  Set variable  0
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${provider}'].complaint_data['document']}
  ...      complaints[${COMPLAINT_NUM}].documents[${doc_num}].title

##############################################################################################
#             ВІДОБРАЖЕННЯ ДЛЯ КОРИСТУВАЧА
##############################################################################################

Відображення назви країни адреси автора вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Відображення назви країни адреси автора вимоги для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${provider}'].complaint_data['complaint'].data.author.address.countryName}
  ...      complaints[${COMPLAINT_NUM}].author.address.countryName


Відображення назви рос. мовою країни адреси автора вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Відображення назви рос. мовою країни адреси автора вимоги для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${provider}'].complaint_data['complaint'].data.author.address.countryName_ru}
  ...      complaints[${COMPLAINT_NUM}].author.address.countryName_ru


Відображення назви англ. мовою країни адреси автора вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Відображення назви англ. мовою країни адреси автора вимоги для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${provider}'].complaint_data['complaint'].data.author.address.countryName_en}
  ...      complaints[${COMPLAINT_NUM}].author.address.countryName_en


Відображення міста адреси автора вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Відображення міста адреси автора вимоги для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${provider}'].complaint_data['complaint'].data.author.address.locality}
  ...      complaints[${COMPLAINT_NUM}].author.address.locality


Відображення поштового коду адреси автора вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Відображення поштового коду адреси автора вимоги для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${provider}'].complaint_data['complaint'].data.author.address.postalCode}
  ...      complaints[${COMPLAINT_NUM}].author.address.postalCode


Відображення області адреси автора вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Відображення області адреси автора вимоги для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${provider}'].complaint_data['complaint'].data.author.address.region}
  ...      complaints[${COMPLAINT_NUM}].author.address.region


Відображення вулиці адреси автора вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Відображення вулиці адреси автора вимоги для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${provider}'].complaint_data['complaint'].data.author.address.streetAddress}
  ...      complaints[${COMPLAINT_NUM}].author.address.streetAddress


Відображення контактного імені автора вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Відображення контактного імені автора вимоги для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${provider}'].complaint_data['complaint'].data.author.contactPoint.name}
  ...      complaints[${COMPLAINT_NUM}].author.contactPoint.name


Відображення контактного телефону автора вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Відображення контактного телефону автора вимоги для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${provider}'].complaint_data['complaint'].data.author.contactPoint.telephone}
  ...      complaints[${COMPLAINT_NUM}].author.contactPoint.telephone


Відображення ідентифікатора автора вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Відображення ідентифікатора автора вимоги для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${provider}'].complaint_data['complaint'].data.author.identifier.id}
  ...      complaints[${COMPLAINT_NUM}].author.identifier.id


Відображення схеми ідентифікації автора вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Відображення схеми ідентифікації автора вимоги для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${provider}'].complaint_data['complaint'].data.author.identifier.scheme}
  ...      complaints[${COMPLAINT_NUM}].author.identifier.scheme


Відображення uri ідентифікатора автора вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Відображення uriідентифікатора автора вимоги для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${provider}'].complaint_data['complaint'].data.author.identifier.uri}
  ...      complaints[${COMPLAINT_NUM}].author.identifier.uri


Відображення імені автора вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Відображення імені автора вимоги для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${provider}'].complaint_data['complaint'].data.author.name}
  ...      complaints[${COMPLAINT_NUM}].author.name


Відображення опису вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: опису Відображення вимоги для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${provider}'].complaint_data['complaint'].data.description}
  ...      complaints[${COMPLAINT_NUM}].description


Відображення заголовку вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Відображення заголовку вимоги для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${provider}'].complaint_data['complaint'].data.title}
  ...      complaints[${COMPLAINT_NUM}].title


Відображення заголовку документації вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Відображення заголовку документації для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
  ${doc_num}=  Set variable  0
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${provider}'].complaint_data['document']}
  ...      complaints[${COMPLAINT_NUM}].documents[${doc_num}].title

##############################################################################################
#             МОЖЛИВІСТЬ
##############################################################################################

Можливість подати вимогу про виправлення умов закупівлі
  [Tags]  ${USERS.users['${provider}'].broker}: Можливість подати вимогу про виправлення умов закупівлі
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  ${confrimation_data}=  test_confirm_complaint_data  ${USERS.users['${provider}']['complaint_data']['complaint_resp']['data']['id']}
  Log  ${confrimation_data}
  Викликати для учасника  ${provider}
  ...      Подати вимогу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['complaint_data']['complaint_resp']}
  ...      ${confrimation_data}

##############################################################################################
#             ВІДОБРАЖЕННЯ ДЛЯ ГЛЯДАЧА
##############################################################################################

Відображення поданого статусу вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення поданого статусу вимоги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  from-0.12
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити поле тендера із значенням  ${provider}
  ...      claim
  ...      complaints[${COMPLAINT_NUM}].status

##############################################################################################
#             ВІДОБРАЖЕННЯ ДЛЯ КОРИСТУВАЧА
##############################################################################################

Відображення поданого статусу вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Відображення поданого статусу вимоги для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  Звірити поле тендера із значенням  ${provider}
  ...      claim
  ...      complaints[${COMPLAINT_NUM}].status

##############################################################################################
#             МОЖЛИВІСТЬ
##############################################################################################

Можливість відповісти на вирішену вимогу про виправлення умов закупівлі
  [Tags]  ${USERS.users['${tender_owner}'].broker}:Можливість відповісти на вирішену вимогу про виправлення умов закупівлі
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  from-0.12
  ${answer_data}=  test_complaint_answer_data  ${USERS.users['${provider}']['complaint_data']['complaint_resp']['data']['id']}
  Log  ${answer_data}
  Викликати для учасника  ${tender_owner}
  ...      Відповісти на вирішену вимогу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['complaint_data']['complaint_resp']}
  ...      ${answer_data}
  ${complaint_data}=  Create Dictionary  complaint_answer=${answer_data}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  complaint_data  ${complaint_data}

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
  ...      ${USERS.users['${tender_owner}'].complaint_data['complaint_answer']['data']['status']}
  ...      complaints[${COMPLAINT_NUM}].status


Відображення типу вирішення вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення типу вирішення вимоги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${tender_owner}'].complaint_data['complaint_answer']['data']['resolutionType']}
  ...      complaints[${COMPLAINT_NUM}].resolutionType


Відображення вирішення вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення вирішення вимоги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${tender_owner}'].complaint_data['complaint_answer']['data']['resolution']}
  ...      complaints[${COMPLAINT_NUM}].resolution

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
  ...      ${USERS.users['${tender_owner}'].complaint_data['complaint_answer']['data']['status']}
  ...      complaints[${COMPLAINT_NUM}].status


Відображення типу вирішення вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Відображення типу вирішення вимоги для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${tender_owner}'].complaint_data['complaint_answer']['data']['resolutionType']}
  ...      complaints[${COMPLAINT_NUM}].resolutionType


Відображення вирішення вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Відображення вирішення вимоги для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${tender_owner}'].complaint_data['complaint_answer']['data']['resolution']}
  ...      complaints[${COMPLAINT_NUM}].resolution

##############################################################################################
#             МОЖЛИВІСТЬ
##############################################################################################

Можливість підтвердити задоволення вимоги про виправлення умов закупівлі
  [Tags]  ${USERS.users['${provider}'].broker}:Можливість підтвердити задоволення вимоги про виправлення умов закупівлі
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
  ${confirmation_data}=  test_complaint_answer_confirmation_data
  ...      ${USERS.users['${provider}']['complaint_data']['complaint_resp']['data']['id']}
  Log  ${confirmation_data}
  Викликати для учасника  ${provider}
  ...      Підтвердити вирішення вимоги
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['complaint_data']['complaint_resp']}
  ...      ${confirmation_data}
  Set To Dictionary  ${USERS.users['${provider}']['complaint_data']}  complaint_answer_confirm  ${confirmation_data}

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
  ...      ${USERS.users['${provider}'].complaint_data['complaint_answer_confirm']['data']['status']}
  ...      complaints[${COMPLAINT_NUM}].status


Відображення задоволення вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення задоволення вимоги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${provider}'].complaint_data['complaint_answer_confirm']['data']['satisfied']}
  ...      complaints[${COMPLAINT_NUM}].satisfied

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
  ...      ${USERS.users['${provider}'].complaint_data['complaint_answer_confirm']['data']['status']}
  ...      complaints[${COMPLAINT_NUM}].status


Відображення задоволення вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Відображення задоволення вимоги для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${provider}'].complaint_data['complaint_answer_confirm']['data']['satisfied']}
  ...      complaints[${COMPLAINT_NUM}].satisfied


Можливість створити і скасувати вимогу про виправлення умов закупівлі
  [Tags]  ${USERS.users['${provider}'].broker}: Можливість створити і скасувати вимогу про виправлення умов закупівлі
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
  ${complaint}=  test_complaint_data
  ${complaint_resp}=  Викликати для учасника  ${provider}
  ...      Створити вимогу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${complaint}
  ${complaint_data2}=  Create Dictionary  complaint=${complaint}  complaint_resp=${complaint_resp}
  Log  ${complaint_data2}
  Set To Dictionary  ${USERS.users['${provider}']}  complaint_data2  ${complaint_data2}
  ${COMPLAINT_NUM}=  Set variable  1
  Set suite variable  ${COMPLAINT_NUM}


  ${cancellation_reason}=  Set variable  prosto tak :)
  ${cancellation_data}=  test_cancel_complaint_data  ${USERS.users['${provider}']['complaint_data2']['complaint_resp']['data']['id']}  ${cancellation_reason}
  Викликати для учасника  ${provider}
  ...      Скасувати вимогу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['complaint_data2']['complaint_resp']}
  ...      ${cancellation_data}
  Set To Dictionary  ${USERS.users['${provider}'].complaint_data2}  cancellation  ${cancellation_data}

##############################################################################################
#             ВІДОБРАЖЕННЯ ДЛЯ ГЛЯДАЧА
##############################################################################################

Відображення статусу 'cancelled' вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення статусу 'cancelled' вимоги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  from-0.12
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${provider}'].complaint_data2['cancellation']['data']['status']}
  ...      complaints[${COMPLAINT_NUM}].status


Відображення причини скасування вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення причини скасування вимоги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${provider}'].complaint_data2['cancellation']['data']['cancellationReason']}
  ...      complaints[${COMPLAINT_NUM}].cancellationReason

##############################################################################################
#             ВІДОБРАЖЕННЯ ДЛЯ КОРИСТУВАЧА
##############################################################################################

Відображення статусу 'cancelled' вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Відображення статусу 'cancelled' вимоги для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${provider}'].complaint_data2['cancellation']['data']['status']}
  ...      complaints[${COMPLAINT_NUM}].status


Відображення причини скасування вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Відображення причини скасування вимоги для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${provider}'].complaint_data2['cancellation']['data']['cancellationReason']}
  ...      complaints[${COMPLAINT_NUM}].cancellationReason



##############################################################################################
#             МОЖЛИВІСТЬ
##############################################################################################

Можливість створити, подати і скасувати вимогу про виправлення умов закупівлі
  [Tags]  ${USERS.users['${provider}'].broker}: Можливість створити, подати і скасувати вимогу про виправлення умов закупівлі
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
  ${complaint}=  test_complaint_data
  ${complaint_resp}=  Викликати для учасника  ${provider}
  ...      Створити вимогу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${complaint}
  ${complaint_data3}=  Create Dictionary  complaint=${complaint}  complaint_resp=${complaint_resp}
  Log  ${complaint_data3}
  Set To Dictionary  ${USERS.users['${provider}']}  complaint_data3  ${complaint_data3}
  ${COMPLAINT_NUM}=  Set variable  2
  Set suite variable  ${COMPLAINT_NUM}


  ${confrimation_data}=  test_confirm_complaint_data  ${USERS.users['${provider}']['complaint_data3']['complaint_resp']['data']['id']}
  Log  ${confrimation_data}
  Викликати для учасника  ${provider}
  ...      Подати вимогу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['complaint_data3']['complaint_resp']}
  ...      ${confrimation_data}


  ${cancellation_reason}=  Set variable  prosto tak :)
  ${cancellation_data}=  test_cancel_complaint_data  ${USERS.users['${provider}']['complaint_data3']['complaint_resp']['data']['id']}  ${cancellation_reason}
  Викликати для учасника  ${provider}
  ...      Скасувати вимогу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['complaint_data3']['complaint_resp']}
  ...      ${cancellation_data}
  Set To Dictionary  ${USERS.users['${provider}'].complaint_data3}  cancellation  ${cancellation_data}

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
  ...      ${USERS.users['${provider}'].complaint_data3['cancellation']['data']['status']}
  ...      complaints[${COMPLAINT_NUM}].status

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
  ...      ${USERS.users['${provider}'].complaint_data3['cancellation']['data']['status']}
  ...      complaints[${COMPLAINT_NUM}].status




Можливість створити, подати, відповісти і після того скасувати вимогу про виправлення умов закупівлі
  [Tags]  ${USERS.users['${provider}'].broker}: Можливість створити, подати, відповісти і після того скасувати вимогу про виправлення умов закупівлі
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
  ${complaint}=  test_complaint_data
  ${complaint_resp}=  Викликати для учасника  ${provider}
  ...      Створити вимогу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${complaint}
  ${complaint_data4}=  Create Dictionary  complaint=${complaint}  complaint_resp=${complaint_resp}
  Log  ${complaint_data4}
  Set To Dictionary  ${USERS.users['${provider}']}  complaint_data4  ${complaint_data4}
  ${COMPLAINT_NUM}=  Set variable  3
  Set suite variable  ${COMPLAINT_NUM}


  ${confrimation_data}=  test_confirm_complaint_data  ${USERS.users['${provider}']['complaint_data4']['complaint_resp']['data']['id']}
  Log  ${confrimation_data}
  Викликати для учасника  ${provider}
  ...      Подати вимогу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['complaint_data4']['complaint_resp']}
  ...      ${confrimation_data}


  ${answer_data}=  test_complaint_answer_data  ${USERS.users['${provider}']['complaint_data4']['complaint_resp']['data']['id']}
  Log  ${answer_data}
  Викликати для учасника  ${tender_owner}
  ...      Відповісти на вирішену вимогу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['complaint_data4']['complaint_resp']}
  ...      ${answer_data}


  ${cancellation_reason}=  Set variable  prosto tak :)
  ${cancellation_data}=  test_cancel_complaint_data  ${USERS.users['${provider}']['complaint_data4']['complaint_resp']['data']['id']}  ${cancellation_reason}
  Викликати для учасника  ${provider}
  ...      Скасувати вимогу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['complaint_data4']['complaint_resp']}
  ...      ${cancellation_data}
  Set To Dictionary  ${USERS.users['${provider}'].complaint_data4}  cancellation  ${cancellation_data}

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
  ...      ${USERS.users['${provider}'].complaint_data4['cancellation']['data']['status']}
  ...      complaints[${COMPLAINT_NUM}].status

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
  ...      ${USERS.users['${provider}'].complaint_data3['cancellation']['data']['status']}
  ...      complaints[${COMPLAINT_NUM}].status
