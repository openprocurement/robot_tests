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
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Викликати для учасника  ${viewer}
  ...      Пошук тендера по ідентифікатору
  ...      ${TENDER['TENDER_UAID']}


Можливість знайти однопредметний тендер по ідентифікатору для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Пошук тендера по ідентифікатору
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  Викликати для учасника  ${provider}
  ...      Пошук тендера по ідентифікатору
  ...      ${TENDER['TENDER_UAID']}


Можливість створити вимогу про виправлення умов закупівлі
  [Tags]  ${USERS.users['${provider}'].broker}: Можливість подати вимогу про виправлення умов закупівлі
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  Викликати для учасника  ${provider}
  ...      Створити вимогу
  ...      ${TENDER['TENDER_UAID']}


Можливість додати документацію до вимоги про виправлення умов закупівлі
  [Tags]  ${USERS.users['${provider}'].broker}: Можливість додати документацію до вимоги про виправлення умов закупівлі
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ${COMPLAINT_NUM}=  Set variable  0
  Set suite variable  ${COMPLAINT_NUM}
  Викликати для учасника  ${provider}
  ...      Завантажити документацію до вимоги
  ...      ${TENDER['TENDER_UAID']}
  ...      ${COMPLAINT_NUM}

##############################################################################################
#             ВІДОБРАЖЕННЯ ДЛЯ ГЛЯДАЧА
##############################################################################################

Відображення назви країни адреси автора вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення назви країни адреси автора вимоги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${provider}'].complaints.data.author.address.countryName}
  ...      complaints[${COMPLAINT_NUM}].author.address.countryName


Відображення назви рос. мовою країни адреси автора вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення назви рос. мовою країни адреси автора вимоги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${provider}'].complaints.data.author.address.countryName_ru}
  ...      complaints[${COMPLAINT_NUM}].author.address.countryName_ru


Відображення назви англ. мовою країни адреси автора вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення назви англ. мовою країни адреси автора вимоги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${provider}'].complaints.data.author.address.countryName_en}
  ...      complaints[${COMPLAINT_NUM}].author.address.countryName_en


Відображення міста адреси автора вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення міста адреси автора вимоги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${provider}'].complaints.data.author.address.locality}
  ...      complaints[${COMPLAINT_NUM}].author.address.locality


Відображення поштового коду адреси автора вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення поштового коду адреси автора вимоги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${provider}'].complaints.data.author.address.postalCode}
  ...      complaints[${COMPLAINT_NUM}].author.address.postalCode


Відображення області адреси автора вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення області адреси автора вимоги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${provider}'].complaints.data.author.address.region}
  ...      complaints[${COMPLAINT_NUM}].author.address.region


Відображення вулиці адреси автора вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення вулиці адреси автора вимоги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${provider}'].complaints.data.author.address.streetAddress}
  ...      complaints[${COMPLAINT_NUM}].author.address.streetAddress


Відображення контактного імені автора вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення контактного імені автора вимоги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${provider}'].complaints.data.author.contactPoint.name}
  ...      complaints[${COMPLAINT_NUM}].author.contactPoint.name


Відображення контактного телефону автора вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення контактного телефону автора вимоги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${provider}'].complaints.data.author.contactPoint.telephone}
  ...      complaints[${COMPLAINT_NUM}].author.contactPoint.telephone


Відображення ідентифікатора автора вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення ідентифікатора автора вимоги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${provider}'].complaints.data.author.identifier.id}
  ...      complaints[${COMPLAINT_NUM}].author.identifier.id


Відображення схеми ідентифікації автора вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення схеми ідентифікації автора вимоги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${provider}'].complaints.data.author.identifier.scheme}
  ...      complaints[${COMPLAINT_NUM}].author.identifier.scheme


Відображення uri ідентифікатора автора вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення uriідентифікатора автора вимоги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${provider}'].complaints.data.author.identifier.uri}
  ...      complaints[${COMPLAINT_NUM}].author.identifier.uri


Відображення імені автора вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення імені автора вимоги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${provider}'].complaints.data.author.name}
  ...      complaints[${COMPLAINT_NUM}].author.name


Відображення опису вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: опису Відображення вимоги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${provider}'].complaints.data.description}
  ...      complaints[${COMPLAINT_NUM}].description


Відображення заголовку вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення заголовку вимоги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${provider}'].complaints.data.title}
  ...      complaints[${COMPLAINT_NUM}].title


Відображення заголовку документації вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення заголовку документації для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ${doc_num}=  Set variable  0
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${provider}'].compl_doc}
  ...      complaints[${COMPLAINT_NUM}].documents[${doc_num}].title

##############################################################################################
#             ВІДОБРАЖЕННЯ ДЛЯ КОРИСТУВАЧА
##############################################################################################

Відображення назви країни адреси автора вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Відображення назви країни адреси автора вимоги для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${provider}'].complaints.data.author.address.countryName}
  ...      complaints[${COMPLAINT_NUM}].author.address.countryName


Відображення назви рос. мовою країни адреси автора вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Відображення назви рос. мовою країни адреси автора вимоги для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${provider}'].complaints.data.author.address.countryName_ru}
  ...      complaints[${COMPLAINT_NUM}].author.address.countryName_ru


Відображення назви англ. мовою країни адреси автора вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Відображення назви англ. мовою країни адреси автора вимоги для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${provider}'].complaints.data.author.address.countryName_en}
  ...      complaints[${COMPLAINT_NUM}].author.address.countryName_en


Відображення міста адреси автора вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Відображення міста адреси автора вимоги для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${provider}'].complaints.data.author.address.locality}
  ...      complaints[${COMPLAINT_NUM}].author.address.locality


Відображення поштового коду адреси автора вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Відображення поштового коду адреси автора вимоги для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${provider}'].complaints.data.author.address.postalCode}
  ...      complaints[${COMPLAINT_NUM}].author.address.postalCode


Відображення області адреси автора вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Відображення області адреси автора вимоги для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${provider}'].complaints.data.author.address.region}
  ...      complaints[${COMPLAINT_NUM}].author.address.region


Відображення вулиці адреси автора вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Відображення вулиці адреси автора вимоги для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${provider}'].complaints.data.author.address.streetAddress}
  ...      complaints[${COMPLAINT_NUM}].author.address.streetAddress


Відображення контактного імені автора вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Відображення контактного імені автора вимоги для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${provider}'].complaints.data.author.contactPoint.name}
  ...      complaints[${COMPLAINT_NUM}].author.contactPoint.name


Відображення контактного телефону автора вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Відображення контактного телефону автора вимоги для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${provider}'].complaints.data.author.contactPoint.telephone}
  ...      complaints[${COMPLAINT_NUM}].author.contactPoint.telephone


Відображення ідентифікатора автора вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Відображення ідентифікатора автора вимоги для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${provider}'].complaints.data.author.identifier.id}
  ...      complaints[${COMPLAINT_NUM}].author.identifier.id


Відображення схеми ідентифікації автора вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Відображення схеми ідентифікації автора вимоги для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${provider}'].complaints.data.author.identifier.scheme}
  ...      complaints[${COMPLAINT_NUM}].author.identifier.scheme


Відображення uri ідентифікатора автора вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Відображення uriідентифікатора автора вимоги для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${provider}'].complaints.data.author.identifier.uri}
  ...      complaints[${COMPLAINT_NUM}].author.identifier.uri


Відображення імені автора вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Відображення імені автора вимоги для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${provider}'].complaints.data.author.name}
  ...      complaints[${COMPLAINT_NUM}].author.name


Відображення опису вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: опису Відображення вимоги для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${provider}'].complaints.data.description}
  ...      complaints[${COMPLAINT_NUM}].description


Відображення заголовку вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Відображення заголовку вимоги для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${provider}'].complaints.data.title}
  ...      complaints[${COMPLAINT_NUM}].title


Відображення заголовку документації вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Відображення заголовку документації для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ${doc_num}=  Set variable  0
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${provider}'].compl_doc}
  ...      complaints[${COMPLAINT_NUM}].documents[${doc_num}].title

##############################################################################################
#             МОЖЛИВІСТЬ
##############################################################################################

Можливість подати вимогу про виправлення умов закупівлі
  [Tags]  ${USERS.users['${provider}'].broker}: Можливість подати вимогу про виправлення умов закупівлі
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  Викликати для учасника  ${provider}
  ...      Подати вимогу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${COMPLAINT_NUM}

##############################################################################################
#             ВІДОБРАЖЕННЯ ДЛЯ ГЛЯДАЧА
##############################################################################################

Відображення поданого статусу вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення поданого статусу вимоги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
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
  Викликати для учасника  ${tender_owner}
  ...      Відповісти на вирішену вимогу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${COMPLAINT_NUM}

##############################################################################################
#             ВІДОБРАЖЕННЯ ДЛЯ ГЛЯДАЧА
##############################################################################################

Відображення статусу 'answered' вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення статусу 'answered' вимоги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${tender_owner}'].compl_answer['data']['status']}
  ...      complaints[${COMPLAINT_NUM}].status

Відображення типу вирішення вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення типу вирішення вимоги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${tender_owner}'].compl_answer['data']['resolutionType']}
  ...      complaints[${COMPLAINT_NUM}].resolutionType


Відображення вирішення вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення вирішення вимоги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${tender_owner}'].compl_answer['data']['resolution']}
  ...      complaints[${COMPLAINT_NUM}].resolution

##############################################################################################
#             ВІДОБРАЖЕННЯ ДЛЯ КОРИСТУВАЧА
##############################################################################################

Відображення статусу 'answered' вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Відображення статусу 'answered' вимоги для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${tender_owner}'].compl_answer['data']['status']}
  ...      complaints[${COMPLAINT_NUM}].status


Відображення типу вирішення вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Відображення типу вирішення вимоги для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${tender_owner}'].compl_answer['data']['resolutionType']}
  ...      complaints[${COMPLAINT_NUM}].resolutionType


Відображення вирішення вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Відображення вирішення вимоги для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${tender_owner}'].compl_answer['data']['resolution']}
  ...      complaints[${COMPLAINT_NUM}].resolution

##############################################################################################
#             МОЖЛИВІСТЬ
##############################################################################################

Можливість підтвердити задоволення вимоги про виправлення умов закупівлі
  [Tags]  ${USERS.users['${provider}'].broker}:Можливість підтвердити вирішення вимоги про виправлення умов закупівлі
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  Викликати для учасника  ${provider}
  ...      Підтвердити вирішення вимоги
  ...      ${TENDER['TENDER_UAID']}
  ...      ${COMPLAINT_NUM}

##############################################################################################
#             ВІДОБРАЖЕННЯ ДЛЯ ГЛЯДАЧА
##############################################################################################

Відображення статусу 'resolved' вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення статусу 'answered' вимоги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${provider}'].compl_answer_confirm['data']['status']}
  ...      complaints[${COMPLAINT_NUM}].status


Відображення задоволення вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення статусу 'answered' вимоги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${provider}'].compl_answer_confirm['data']['satisfied']}
  ...      complaints[${COMPLAINT_NUM}].satisfied

##############################################################################################
#             ВІДОБРАЖЕННЯ ДЛЯ КОРИСТУВАЧА
##############################################################################################

Відображення статусу 'resolved' вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Відображення статусу 'answered' вимоги для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${provider}'].compl_answer_confirm['data']['status']}
  ...      complaints[${COMPLAINT_NUM}].status


Відображення задоволення вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Відображення статусу 'answered' вимоги для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${provider}'].compl_answer_confirm['data']['satisfied']}
  ...      complaints[${COMPLAINT_NUM}].satisfied
