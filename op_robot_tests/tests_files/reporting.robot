*** Settings ***
Library            op_robot_tests.tests_files.service_keywords
Library            Collections
Resource           keywords.robot
Resource           resource.robot
Suite Setup        Test Suite Setup
Suite Teardown     Close all browsers


*** Variables ***
${mode}         reporting
${role}         viewer
${broker}       Quinta


*** Test Cases ***
##############################################################################################
#             CANCELLATIONS
##############################################################################################
Можливість створити пряму закупівлю для тестування скасування
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Можливість створити пряму закупівлю для тестування скасування
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  minimal
  ${tender_data}=  Підготовка даних для створення тендера
  ${TENDER_UAID}=  Викликати для учасника  ${tender_owner}
  ...      Створити тендер
  ...      ${tender_data}
  Log  ${tender_data}
  ${LAST_MODIFICATION_DATE}=  Get Current TZdate
  Set To Dictionary  ${TENDER}  LAST_MODIFICATION_DATE  ${LAST_MODIFICATION_DATE}
  Set To Dictionary  ${TENDER}  TENDER_UAID  ${TENDER_UAID}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  initial_data  ${tender_data}
  Log  ${TENDER}


Можливість скасувати пряму закупівлю
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Можливість скасувати пряму закупівлю
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  level2
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  ${cancellation_data}=  Підготувати дані про скасування  ${tender_owner}
  Викликати для учасника  ${tender_owner}
  ...      Скасувати закупівлю
  ...      ${TENDER['TENDER_UAID']}
  ...      ${cancellation_data['cancellation_reason']}
  ...      ${cancellation_data['document']}
  ...      ${cancellation_data['description']}
  ${CANCEL_NUM}=  Set variable  0
  Set suite variable  ${CANCEL_NUM}
  ${DOC_NUM}=  Set variable  0
  Set suite variable  ${DOC_NUM}


Відображення активного статусу скасування прямої закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення активного статусу скасування прямої закупівлі
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити поле тендера із значенням  ${viewer}
  ...      active
  ...      cancellations[${CANCEL_NUM}].status


Відображення причини скасування прямої закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення причини скасування прямої закупівлі
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${tender_owner}']['cancellation_data']['cancellation_reason']}
  ...      cancellations[${CANCEL_NUM}].reason


Відображення опису документа скасування прямої закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення опису документа скасування прямої закупівлі
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${tender_owner}']['cancellation_data']['description']}
  ...      cancellations[${CANCEL_NUM}].documents[${DOC_NUM}].description


Відображення заголовку документа скасування прямої закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення заголовку документа скасування прямої закупівлі
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${tender_owner}']['cancellation_data']['document']}
  ...      cancellations[${CANCEL_NUM}].documents[${DOC_NUM}].title

##############################################################################################
#             MAIN
##############################################################################################

Можливість створити пряму закупівлю
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Можливість створити пряму закупівлю
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  minimal
  ${tender_data}=  Підготовка даних для створення тендера
  ${TENDER_UAID}=  Викликати для учасника  ${tender_owner}
  ...      Створити тендер
  ...      ${tender_data}
  Log  ${tender_data}
  ${LAST_MODIFICATION_DATE}=  Get Current TZdate
  Set To Dictionary  ${TENDER}  LAST_MODIFICATION_DATE  ${LAST_MODIFICATION_DATE}
  Set To Dictionary  ${TENDER}  TENDER_UAID  ${TENDER_UAID}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  initial_data  ${tender_data}
  Log  ${TENDER}


Можливість знайти пряму закупівлю по ідентифікатору
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Можливість знайти пряму закупівлю по ідентифікатору
  ...  viewer
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  minimal
  Викликати для учасника  ${viewer}
  ...      Пошук тендера по ідентифікатору
  ...      ${TENDER['TENDER_UAID']}


Можливість модифікації прямої закупівлі
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Можливість модифікації прямої закупівлі
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  level2
  Викликати для учасника  ${tender_owner}
  ...      Модифікувати закупівлю
  ...      ${TENDER['TENDER_UAID']}


Можливість додати документацію до прямої закупівлі
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Можливість додати тендерну документацію до прямої закупівлі
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  level2
  ${filepath}=  create_fake_doc
  Викликати для учасника  ${tender_owner}
  ...      Завантажити документ
  ...      ${filepath}
  ...      ${TENDER['TENDER_UAID']}
  ${documents}=  Create Dictionary  filepath  ${filepath}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  documents  ${documents}


Можливість зареєструвати і підтвердити постачальника до прямої закупівлі
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Можливість зареєструвати і підтвердити постачальника до прямої закупівлі
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  minimal
  ${SUPP_NUM}=  Set variable  0
  Set Suite Variable  ${SUPP_NUM}
  ${supplier_data}=  Підготувати дані про постачальника  ${tender_owner}
  Викликати для учасника  ${tender_owner}
  ...      Додати і підтвердити постачальника
  ...      ${TENDER['TENDER_UAID']}
  ...      ${supplier_data}

##############################################################################################
#             MAIN DATA
##############################################################################################

Відображення заголовку прямої закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення заголовку прямої закупівлі
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      title


Відображення ідентифікатора прямої закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення ідентифікатора прямої закупівлі
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити поле тендера із значенням  ${viewer}
  ...      ${TENDER['TENDER_UAID']}
  ...      tenderID

##############################################################################################
#             MAIN DATA.VALUE
##############################################################################################

Відображення бюджету прямої закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення бюджету прямої закупівлі
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      value.amount


Відображення валюти прямої закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення валюти прямої закупівлі
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      value.currency


Відображення врахованого податку в бюджет прямої закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення врахування податку в бюджет прямої закупівлі
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      value.valueAddedTaxIncluded

##############################################################################################
#             MAIN DATA.PROCURING ENTITY
##############################################################################################

Відображення країни замовника прямої закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення країни замовника прямої закупівлі
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      procuringEntity.address.countryName


Відображення населеного пункту замовника прямої закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення населеного пункту замовника прямої закупівлі
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      procuringEntity.address.locality


Відображення поштового коду замовника прямої закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення поштового коду замовника прямої закупівлі
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      procuringEntity.address.postalCode


Відображення області замовника прямої закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення області замовника прямої закупівлі
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      procuringEntity.address.region


Відображення вулиці замовника прямої закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення вулиці замовника прямої закупівлі
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      procuringEntity.address.streetAddress


Відображення контактного імені замовника прямої закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення контактного імені замовника прямої закупівлі
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      procuringEntity.contactPoint.name


Відображення контактного телефону замовника прямої закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення контактного телефону замовника прямої закупівлі
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      procuringEntity.contactPoint.telephone


Відображення сайту замовника прямої закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення сайту замовника прямої закупівлі
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      procuringEntity.contactPoint.url


Відображення офіційного імені замовника прямої закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення офіційного імені замовника прямої закупівлі
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      procuringEntity.identifier.legalName


Відображення схеми ідентифікації замовника прямої закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення схеми ідентифікації замовника прямої закупівлі
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      procuringEntity.identifier.scheme


Відображення ідентифікатора замовника прямої закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення ідентифікатора замовника прямої закупівлі
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      procuringEntity.identifier.id


Відображення імені замовника прямої закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення імені замовника прямої закупівлі
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      procuringEntity.name

##############################################################################################
#             MAIN DATA.ITEMS
##############################################################################################

Відображення опису додаткової класифікації номенклатури прямої закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення опису додаткової класифікації номенклатури прямої закупівлі
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ${ITEMS_NUM}=  Set variable  0
  Set Suite Variable  ${ITEMS_NUM}
  ${ADDITIONAL_CLASS_NUM}=  Set variable  0
  Set Suite Variable  ${ADDITIONAL_CLASS_NUM}
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      items[${ITEMS_NUM}].additionalClassifications.[${ADDITIONAL_CLASS_NUM}].description


Відображення ідентифікатора додаткової класифікації номенклатури прямої закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення ідентифікатора додаткової класифікацій номенклатури прямої закупівлі
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      items[${ITEMS_NUM}].additionalClassifications.[${ADDITIONAL_CLASS_NUM}].id


Відображення схеми додаткової класифікації номенклатури прямої закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення схеми додаткової класифікації номенклатури прямої закупівлі
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      items[${ITEMS_NUM}].additionalClassifications.[${ADDITIONAL_CLASS_NUM}].scheme


Відображення схеми класифікації номенклатури прямої закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення схеми класифікації номенклатури прямої закупівлі
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      items[${ITEMS_NUM}].classification.scheme


Відображення ідентифікатора класифікації номенклатури прямої закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення ідентифікатора класифікації номенклатури прямої закупівлі
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      items[${ITEMS_NUM}].classification.id


Відображення опису класифікації номенклатури прямої закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення опису класифікації номенклатури прямої закупівлі
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      items[${ITEMS_NUM}].classification.description


Відображення опису номенклатури прямої закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення опису номенклатури прямої закупівлі
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      items[${ITEMS_NUM}].description


Відображення ідентифікатора номенклатури прямої закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення ідентифікатора номенклатури прямої закупівлі
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      items[${ITEMS_NUM}].id


Відображення кількості номенклатури прямої закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення кількості номенклатури прямої закупівлі
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${tender_owner}'].additional_items[${ITEMS_NUM}]['quantity']}
  ...      items[${ITEMS_NUM}].quantity


Відображення назви одиниці номенклатури прямої закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення назви одиниці номенклатури прямої закупівлі
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${tender_owner}'].additional_items[${ITEMS_NUM}]['unit']['name']}
  ...      items[${ITEMS_NUM}].unit.name


Відображення коду одиниці номенклатури прямої закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення коду одиниці номенклатури прямої закупівлі
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${tender_owner}'].additional_items[${ITEMS_NUM}]['unit']['code']}
  ...      items[${ITEMS_NUM}].unit.code


Відображення дати доставки номенклатури прямої закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення дати доставки номенклатури прямої закупівлі
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити дату тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      items[${ITEMS_NUM}].deliveryDate.endDate


Відображення координат широти доставки номенклатури прямої закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення координат широти доставки номенклатури прямої закупівлі
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      items[${ITEMS_NUM}].deliveryLocation.latitude


Відображення координат довготи доставки номенклатури прямої закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення координат довготи доставки номенклатури прямої закупівлі
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      items[${ITEMS_NUM}].deliveryLocation.longitude


Відображення назви нас. пункту доставки номенклатури прямої закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення назви нас. пункту доставки номенклатури прямої закупівлі
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      items[${ITEMS_NUM}].deliveryAddress.countryName


Відображення назви нас. пункту російською мовою доставки номенклатури прямої закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення назви нас. пункту російською мовою доставки номенклатури прямої закупівлі
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      items[${ITEMS_NUM}].deliveryAddress.countryName_ru


Відображення назви нас. пункту англійською мовою доставки номенклатури прямої закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення назви нас. пункту англійською мовою доставки номенклатури прямої закупівлі
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      items[${ITEMS_NUM}].deliveryAddress.countryName_en


Відображення пошт. коду доставки номенклатури прямої закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення пошт. коду доставки номенклатури прямої закупівлі
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      items[${ITEMS_NUM}].deliveryAddress.postalCode


Відображення регіону доставки номенклатури прямої закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення регіону доставки номенклатури прямої закупівлі
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      items[${ITEMS_NUM}].deliveryAddress.region


Відображення населеного пункту адреси доставки номенклатури прямої закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення населеного пункту адреси доставки номенклатури прямої закупівлі
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      items[${ITEMS_NUM}].deliveryAddress.locality


Відображення вулиці доставки номенклатури прямої закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення вулиці доставки номенклатури прямої закупівлі
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      items[${ITEMS_NUM}].deliveryAddress.streetAddress

##############################################################################################
#             DOCUMENTS
##############################################################################################

Відображення заголовку документа прямої закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення заголовку документа прямої закупівлі
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ${doc_num}=  Set variable  0
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${tender_owner}']['documents']['filepath']}
  ...      documents[${doc_num}].title

##############################################################################################
#             AWARDS
##############################################################################################

Відображення підтвердженого постачальника прямої закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення підтвердженого постачальника прямої закупівлі
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ${AWARD_NUM}=  Set variable  0
  Set Suite Variable  ${AWARD_NUM}
  Звірити поле тендера із значенням  ${viewer}
  ...      active
  ...      awards[${AWARD_NUM}].status


Відображення країни постачальника прямої закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення країни постачальника прямої закупівлі
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${tender_owner}']['supplier_data']['data']['suppliers'][${SUPP_NUM}]['address']['countryName']}
  ...      awards[${AWARD_NUM}].suppliers[${SUPP_NUM}].address.countryName


Відображення міста постачальника прямої закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення міста постачальника прямої закупівлі
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${tender_owner}']['supplier_data']['data']['suppliers'][${SUPP_NUM}]['address']['locality']}
  ...      awards[${AWARD_NUM}].suppliers[${SUPP_NUM}].address.locality


Відображення поштового коду постачальника прямої закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення поштового коду постачальника прямої закупівлі
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${tender_owner}']['supplier_data']['data']['suppliers'][${SUPP_NUM}]['address']['postalCode']}
  ...      awards[${AWARD_NUM}].suppliers[${SUPP_NUM}].address.postalCode


Відображення області постачальника прямої закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення області постачальника прямої закупівлі
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${tender_owner}']['supplier_data']['data']['suppliers'][${SUPP_NUM}]['address']['region']}
  ...      awards[${AWARD_NUM}].suppliers[${SUPP_NUM}].address.region


Відображення вулиці постачальника прямої закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення вулиці постачальника прямої закупівлі
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${tender_owner}']['supplier_data']['data']['suppliers'][${SUPP_NUM}]['address']['streetAddress']}
  ...      awards[${AWARD_NUM}].suppliers[${SUPP_NUM}].address.streetAddress


Відображення контактного телефону постачальника прямої закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення контактного телефону постачальника прямої закупівлі
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${tender_owner}']['supplier_data']['data']['suppliers'][${SUPP_NUM}]['contactPoint']['telephone']}
  ...      awards[${AWARD_NUM}].suppliers[${SUPP_NUM}].contactPoint.telephone


Відображення контактного імені постачальника прямої закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення контактного імені постачальника прямої закупівлі
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${tender_owner}']['supplier_data']['data']['suppliers'][${SUPP_NUM}]['contactPoint']['name']}
  ...      awards[${AWARD_NUM}].suppliers[${SUPP_NUM}].contactPoint.name


Відображення контактного імейлу постачальника прямої закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення контактного імейлу постачальника прямої закупівлі
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${tender_owner}']['supplier_data']['data']['suppliers'][${SUPP_NUM}]['contactPoint']['email']}
  ...      awards[${AWARD_NUM}].suppliers[${SUPP_NUM}].contactPoint.email


Відображення схеми ідентифікації постачальника прямої закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення схеми ідентифікації постачальника прямої закупівлі
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${tender_owner}']['supplier_data']['data']['suppliers'][${SUPP_NUM}]['identifier']['scheme']}
  ...      awards[${AWARD_NUM}].suppliers[${SUPP_NUM}].identifier.scheme


Відображення офіційного імені постачальника прямої закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення офіційного імені постачальника прямої закупівлі
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${tender_owner}']['supplier_data']['data']['suppliers'][${SUPP_NUM}]['identifier']['legalName']}
  ...      awards[${AWARD_NUM}].suppliers[${SUPP_NUM}].identifier.legalName


Відображення ідентифікатора постачальника прямої закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення ідентифікатора постачальника прямої закупівлі
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${tender_owner}']['supplier_data']['data']['suppliers'][${SUPP_NUM}]['identifier']['id']}
  ...      awards[${AWARD_NUM}].suppliers[${SUPP_NUM}].identifier.id


Відображення імені постачальника прямої закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення імені постачальника прямої закупівлі
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${tender_owner}']['supplier_data']['data']['suppliers'][${SUPP_NUM}]['name']}
  ...      awards[${AWARD_NUM}].suppliers[${SUPP_NUM}].name


Відображення врахованого податку до ціни номенклатури постачальника прямої закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення врахованого податку до ціни номенклатури постачальника прямої закупівлі
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${tender_owner}']['supplier_data']['data']['value']['valueAddedTaxIncluded']}
  ...      awards[${AWARD_NUM}].value.valueAddedTaxIncluded


Відображення валюти ціни номенклатури постачальника прямої закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення валюти ціни номенклатури постачальника прямої закупівлі
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${tender_owner}']['supplier_data']['data']['value']['currency']}
  ...      awards[${AWARD_NUM}].value.currency


Відображення вартості номенклатури постачальника прямої закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення валюти ціни номенклатури постачальника прямої закупівлі
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${tender_owner}']['supplier_data']['data']['value']['amount']}
  ...      awards[${AWARD_NUM}].value.amount

##############################################################################################
#             CONTRACTS
##############################################################################################

Можливість укласти угоду для прямої закупівлі
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Можливість укласти угоду для прямої закупівлі
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  ${CONTR_NUM}=  Set variable  0
  Set suite variable  ${CONTR_NUM}
  Викликати для учасника  ${tender_owner}
  ...      Підтвердити підписання контракту
  ...      ${TENDER['TENDER_UAID']}
  ...      ${CONTR_NUM}


Відображення статусу підписаної угоди з постачальником прямої закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення статусу підписаної угоди з постачальником прямої закупівлі
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити поле тендера із значенням  ${viewer}
  ...      active
  ...      contracts[${CONTR_NUM}].status
