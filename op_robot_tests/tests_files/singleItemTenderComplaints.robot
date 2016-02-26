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
  ${claim}=  test_claim_data
  ${claim_resp}=  Викликати для учасника  ${provider}
  ...      Створити вимогу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${claim}
  ${claim_data}=  Create Dictionary  claim=${claim}  claim_resp=${claim_resp}
  Set To Dictionary  ${USERS.users['${provider}']}  claim_data  ${claim_data}
  ${CLAIM_NUM}=  Set variable  0
  Set suite variable  ${CLAIM_NUM}


Можливість додати документацію до вимоги про виправлення умов закупівлі
  [Tags]  ${USERS.users['${provider}'].broker}: Можливість додати документацію до вимоги про виправлення умов закупівлі
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
  ${document}=  create_fake_doc
  Викликати для учасника  ${provider}
  ...      Завантажити документацію до вимоги
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['claim_data']['claim_resp']}
  ...      ${document}
  Set To Dictionary  ${USERS.users['${provider}']['claim_data']}  document  ${document}

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
  ...      ${USERS.users['${provider}'].claim_data['claim'].data.author.address.countryName}
  ...      complaints[${CLAIM_NUM}].author.address.countryName


Відображення назви рос. мовою країни адреси автора вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення назви рос. мовою країни адреси автора вимоги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${provider}'].claim_data['claim'].data.author.address.countryName_ru}
  ...      complaints[${CLAIM_NUM}].author.address.countryName_ru


Відображення назви англ. мовою країни адреси автора вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення назви англ. мовою країни адреси автора вимоги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${provider}'].claim_data['claim'].data.author.address.countryName_en}
  ...      complaints[${CLAIM_NUM}].author.address.countryName_en


Відображення міста адреси автора вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення міста адреси автора вимоги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${provider}'].claim_data['claim'].data.author.address.locality}
  ...      complaints[${CLAIM_NUM}].author.address.locality


Відображення поштового коду адреси автора вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення поштового коду адреси автора вимоги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${provider}'].claim_data['claim'].data.author.address.postalCode}
  ...      complaints[${CLAIM_NUM}].author.address.postalCode


Відображення області адреси автора вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення області адреси автора вимоги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${provider}'].claim_data['claim'].data.author.address.region}
  ...      complaints[${CLAIM_NUM}].author.address.region


Відображення вулиці адреси автора вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення вулиці адреси автора вимоги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${provider}'].claim_data['claim'].data.author.address.streetAddress}
  ...      complaints[${CLAIM_NUM}].author.address.streetAddress


Відображення контактного імені автора вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення контактного імені автора вимоги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${provider}'].claim_data['claim'].data.author.contactPoint.name}
  ...      complaints[${CLAIM_NUM}].author.contactPoint.name


Відображення контактного телефону автора вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення контактного телефону автора вимоги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${provider}'].claim_data['claim'].data.author.contactPoint.telephone}
  ...      complaints[${CLAIM_NUM}].author.contactPoint.telephone


Відображення ідентифікатора автора вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення ідентифікатора автора вимоги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${provider}'].claim_data['claim'].data.author.identifier.id}
  ...      complaints[${CLAIM_NUM}].author.identifier.id


Відображення схеми ідентифікації автора вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення схеми ідентифікації автора вимоги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${provider}'].claim_data['claim'].data.author.identifier.scheme}
  ...      complaints[${CLAIM_NUM}].author.identifier.scheme


Відображення uri ідентифікатора автора вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення uriідентифікатора автора вимоги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${provider}'].claim_data['claim'].data.author.identifier.uri}
  ...      complaints[${CLAIM_NUM}].author.identifier.uri


Відображення імені автора вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення імені автора вимоги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${provider}'].claim_data['claim'].data.author.name}
  ...      complaints[${CLAIM_NUM}].author.name


Відображення опису вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: опису Відображення вимоги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  from-0.12
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
  ...      ${USERS.users['${provider}'].claim_data['claim'].data.author.address.countryName}
  ...      complaints[${CLAIM_NUM}].author.address.countryName


Відображення назви рос. мовою країни адреси автора вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Відображення назви рос. мовою країни адреси автора вимоги для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${provider}'].claim_data['claim'].data.author.address.countryName_ru}
  ...      complaints[${CLAIM_NUM}].author.address.countryName_ru


Відображення назви англ. мовою країни адреси автора вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Відображення назви англ. мовою країни адреси автора вимоги для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${provider}'].claim_data['claim'].data.author.address.countryName_en}
  ...      complaints[${CLAIM_NUM}].author.address.countryName_en


Відображення міста адреси автора вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Відображення міста адреси автора вимоги для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${provider}'].claim_data['claim'].data.author.address.locality}
  ...      complaints[${CLAIM_NUM}].author.address.locality


Відображення поштового коду адреси автора вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Відображення поштового коду адреси автора вимоги для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${provider}'].claim_data['claim'].data.author.address.postalCode}
  ...      complaints[${CLAIM_NUM}].author.address.postalCode


Відображення області адреси автора вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Відображення області адреси автора вимоги для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${provider}'].claim_data['claim'].data.author.address.region}
  ...      complaints[${CLAIM_NUM}].author.address.region


Відображення вулиці адреси автора вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Відображення вулиці адреси автора вимоги для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${provider}'].claim_data['claim'].data.author.address.streetAddress}
  ...      complaints[${CLAIM_NUM}].author.address.streetAddress


Відображення контактного імені автора вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Відображення контактного імені автора вимоги для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${provider}'].claim_data['claim'].data.author.contactPoint.name}
  ...      complaints[${CLAIM_NUM}].author.contactPoint.name


Відображення контактного телефону автора вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Відображення контактного телефону автора вимоги для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${provider}'].claim_data['claim'].data.author.contactPoint.telephone}
  ...      complaints[${CLAIM_NUM}].author.contactPoint.telephone


Відображення ідентифікатора автора вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Відображення ідентифікатора автора вимоги для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${provider}'].claim_data['claim'].data.author.identifier.id}
  ...      complaints[${CLAIM_NUM}].author.identifier.id


Відображення схеми ідентифікації автора вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Відображення схеми ідентифікації автора вимоги для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${provider}'].claim_data['claim'].data.author.identifier.scheme}
  ...      complaints[${CLAIM_NUM}].author.identifier.scheme


Відображення uri ідентифікатора автора вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Відображення uriідентифікатора автора вимоги для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${provider}'].claim_data['claim'].data.author.identifier.uri}
  ...      complaints[${CLAIM_NUM}].author.identifier.uri


Відображення імені автора вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Відображення імені автора вимоги для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${provider}'].claim_data['claim'].data.author.name}
  ...      complaints[${CLAIM_NUM}].author.name


Відображення опису вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: опису Відображення вимоги для користувача
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
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

##############################################################################################
#             МОЖЛИВІСТЬ
##############################################################################################

Можливість подати вимогу про виправлення умов закупівлі
  [Tags]  ${USERS.users['${provider}'].broker}: Можливість подати вимогу про виправлення умов закупівлі
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
  ${confrimation_data}=  test_submit_claim_data  ${USERS.users['${provider}']['claim_data']['claim_resp']['data']['id']}
  Log  ${confrimation_data}
  Викликати для учасника  ${provider}
  ...      Подати вимогу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['claim_data']['claim_resp']}
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
  ...      complaints[${CLAIM_NUM}].status

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
  ...      complaints[${CLAIM_NUM}].status

##############################################################################################
#             МОЖЛИВІСТЬ
##############################################################################################

Можливість відповісти на вирішену вимогу про виправлення умов закупівлі
  [Tags]  ${USERS.users['${tender_owner}'].broker}:Можливість відповісти на вирішену вимогу про виправлення умов закупівлі
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  from-0.12
  ${answer_data}=  test_claim_answer_data  ${USERS.users['${provider}']['claim_data']['claim_resp']['data']['id']}
  Log  ${answer_data}
  Викликати для учасника  ${tender_owner}
  ...      Відповісти на вирішену вимогу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['claim_data']['claim_resp']}
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
  ${confirmation_data}=  test_claim_answer_satisfying_data
  ...      ${USERS.users['${provider}']['claim_data']['claim_resp']['data']['id']}
  Log  ${confirmation_data}
  Викликати для учасника  ${provider}
  ...      Підтвердити вирішення вимоги
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['claim_data']['claim_resp']}
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

Можливість створити і скасувати вимогу про виправлення умов закупівлі
  [Tags]  ${USERS.users['${provider}'].broker}: Можливість створити і скасувати вимогу про виправлення умов закупівлі
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  from-0.12
  ${claim}=  test_claim_data
  ${claim_resp}=  Викликати для учасника  ${provider}
  ...      Створити вимогу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${claim}
  ${claim_data2}=  Create Dictionary  claim=${claim}  claim_resp=${claim_resp}
  Log  ${claim_data2}
  Set To Dictionary  ${USERS.users['${provider}']}  claim_data2  ${claim_data2}
  ${CLAIM_NUM}=  Set variable  1
  Set suite variable  ${CLAIM_NUM}


  ${cancellation_reason}=  Set variable  prosto tak :)
  ${cancellation_data}=  test_cancel_claim_data  ${USERS.users['${provider}']['claim_data2']['claim_resp']['data']['id']}  ${cancellation_reason}
  Викликати для учасника  ${provider}
  ...      Скасувати вимогу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['claim_data2']['claim_resp']}
  ...      ${cancellation_data}
  Set To Dictionary  ${USERS.users['${provider}'].claim_data2}  cancellation  ${cancellation_data}

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
  ...      ${USERS.users['${provider}'].claim_data2['cancellation']['data']['status']}
  ...      complaints[${CLAIM_NUM}].status


Відображення причини скасування вимоги для глядача
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення причини скасування вимоги для глядача
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  from-0.12
  Звірити поле тендера із значенням  ${provider}
  ...      ${USERS.users['${provider}'].claim_data2['cancellation']['data']['cancellationReason']}
  ...      complaints[${CLAIM_NUM}].cancellationReason

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
  ...      ${USERS.users['${provider}'].claim_data2['cancellation']['data']['status']}
  ...      complaints[${CLAIM_NUM}].status


Відображення причини скасування вимоги для користувача
  [Tags]  ${USERS.users['${provider}'].broker}: Відображення причини скасування вимоги для користувача
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
  ${claim}=  test_claim_data
  ${claim_resp}=  Викликати для учасника  ${provider}
  ...      Створити вимогу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${claim}
  ${claim_data3}=  Create Dictionary  claim=${claim}  claim_resp=${claim_resp}
  Log  ${claim_data3}
  Set To Dictionary  ${USERS.users['${provider}']}  claim_data3  ${claim_data3}
  ${CLAIM_NUM}=  Set variable  2
  Set suite variable  ${CLAIM_NUM}


  ${confrimation_data}=  test_submit_claim_data  ${USERS.users['${provider}']['claim_data3']['claim_resp']['data']['id']}
  Log  ${confrimation_data}
  Викликати для учасника  ${provider}
  ...      Подати вимогу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['claim_data3']['claim_resp']}
  ...      ${confrimation_data}


  ${cancellation_reason}=  Set variable  prosto tak :)
  ${cancellation_data}=  test_cancel_claim_data  ${USERS.users['${provider}']['claim_data3']['claim_resp']['data']['id']}  ${cancellation_reason}
  Викликати для учасника  ${provider}
  ...      Скасувати вимогу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['claim_data3']['claim_resp']}
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
  ${claim}=  test_claim_data
  ${claim_resp}=  Викликати для учасника  ${provider}
  ...      Створити вимогу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${claim}
  ${claim_data4}=  Create Dictionary  claim=${claim}  claim_resp=${claim_resp}
  Log  ${claim_data4}
  Set To Dictionary  ${USERS.users['${provider}']}  claim_data4  ${claim_data4}
  ${CLAIM_NUM}=  Set variable  3
  Set suite variable  ${CLAIM_NUM}


  ${confrimation_data}=  test_submit_claim_data  ${USERS.users['${provider}']['claim_data4']['claim_resp']['data']['id']}
  Log  ${confrimation_data}
  Викликати для учасника  ${provider}
  ...      Подати вимогу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['claim_data4']['claim_resp']}
  ...      ${confrimation_data}


  ${answer_data}=  test_claim_answer_data  ${USERS.users['${provider}']['claim_data4']['claim_resp']['data']['id']}
  Log  ${answer_data}
  Викликати для учасника  ${tender_owner}
  ...      Відповісти на вирішену вимогу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['claim_data4']['claim_resp']}
  ...      ${answer_data}


  ${cancellation_reason}=  Set variable  prosto tak :)
  ${cancellation_data}=  test_cancel_claim_data  ${USERS.users['${provider}']['claim_data4']['claim_resp']['data']['id']}  ${cancellation_reason}
  Викликати для учасника  ${provider}
  ...      Скасувати вимогу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['claim_data4']['claim_resp']}
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
  ${claim}=  test_claim_data
  ${claim_resp}=  Викликати для учасника  ${provider}
  ...      Створити вимогу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${claim}
  ${claim_data5}=  Create Dictionary  claim=${claim}  claim_resp=${claim_resp}
  Log  ${claim_data5}
  Set To Dictionary  ${USERS.users['${provider}']}  claim_data5  ${claim_data5}
  ${CLAIM_NUM}=  Set variable  4
  Set suite variable  ${CLAIM_NUM}


  ${confrimation_data}=  test_submit_claim_data  ${USERS.users['${provider}']['claim_data5']['claim_resp']['data']['id']}
  Log  ${confrimation_data}
  Викликати для учасника  ${provider}
  ...      Подати вимогу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['claim_data5']['claim_resp']}
  ...      ${confrimation_data}


  ${answer_data}=  test_claim_answer_data  ${USERS.users['${provider}']['claim_data5']['claim_resp']['data']['id']}
  Log  ${answer_data}
  Викликати для учасника  ${tender_owner}
  ...      Відповісти на вирішену вимогу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['claim_data5']['claim_resp']}
  ...      ${answer_data}


  ${escalation_data}=  test_escalate_claim_data  ${USERS.users['${provider}']['claim_data5']['claim_resp']['data']['id']}
  Log  ${escalation_data}
  Викликати для учасника  ${tender_owner}
  ...      Перетворити вимогу в скаргу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['claim_data5']['claim_resp']}
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
  ${cancellation_reason}=  Set variable  prosto tak :)
  ${cancellation_data}=  test_cancel_claim_data  ${USERS.users['${provider}']['claim_data5']['claim_resp']['data']['id']}  ${cancellation_reason}
  Викликати для учасника  ${provider}
  ...      Скасувати вимогу
  ...      ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['claim_data5']['claim_resp']}
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
  ...      ${USERS.users['${provider}'].claim_data2['cancellation']['data']['cancellationReason']}
  ...      complaints[${CLAIM_NUM}].cancellationReason
