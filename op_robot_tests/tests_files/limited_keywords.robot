*** Settings ***
Library            op_robot_tests.tests_files.service_keywords
Library            Collections
Resource           keywords.robot
Resource           resource.robot

*** Keywords ***
##############################################################################################
#             CANCELLATIONS
##############################################################################################
Можливість створити закупівлю для тестування скасування
  ${tender_data}=  Підготовка даних для створення тендера
  # munchify is used to make deep copy of ${tender_data}
  ${tender_data_copy}=  munchify  ${tender_data}
  ${status}  ${adapted_data}=  Run Keyword And Ignore Error  Викликати для учасника  ${tender_owner}  Підготувати дані для оголошення тендера  ${tender_data_copy}
  ${adapted_data}=  Set variable if  '${status}' == 'FAIL'  ${tender_data_copy}  ${adapted_data}
  # munchify is used to make nice log output
  ${adapted_data}=  munchify  ${adapted_data}
  Log  ${tender_data}
  Log  ${adapted_data}
  ${status}=  Run keyword and return status  Dictionaries Should Be Equal  ${adapted_data.data}  ${tender_data.data}
  Run keyword if  ${status} == ${False}  Log  Initial tender data was changed  WARN
  ${TENDER_UAID}=  Викликати для учасника  ${tender_owner}
  ...      Створити тендер
  ...      ${adapted_data}
  Set To Dictionary  ${TENDER}  TENDER_UAID=${TENDER_UAID}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  initial_data=${adapted_data}
  Log  ${TENDER}


Можливість скасувати закупівлю
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


Відображення активного статусу скасування закупівлі
  Звірити поле тендера із значенням  ${viewer}
  ...      active
  ...      cancellations[${CANCEL_NUM}].status


Відображення причини скасування закупівлі
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${tender_owner}']['cancellation_data']['cancellation_reason']}
  ...      cancellations[${CANCEL_NUM}].reason


Відображення опису документа скасування закупівлі
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${tender_owner}']['cancellation_data']['description']}
  ...      cancellations[${CANCEL_NUM}].documents[${DOC_NUM}].description


Відображення заголовку документа скасування закупівлі
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${tender_owner}']['cancellation_data']['document']}
  ...      cancellations[${CANCEL_NUM}].documents[${DOC_NUM}].title

##############################################################################################
#             MAIN
##############################################################################################

Можливість створити закупівлю
  ${tender_data}=  Підготовка даних для створення тендера
  # munchify is used to make deep copy of ${tender_data}
  ${tender_data_copy}=  munchify  ${tender_data}
  ${status}  ${adapted_data}=  Run Keyword And Ignore Error  Викликати для учасника  ${tender_owner}  Підготувати дані для оголошення тендера  ${tender_data_copy}
  ${adapted_data}=  Set variable if  '${status}' == 'FAIL'  ${tender_data_copy}  ${adapted_data}
  # munchify is used to make nice log output
  ${adapted_data}=  munchify  ${adapted_data}
  Log  ${tender_data}
  Log  ${adapted_data}
  ${status}=  Run keyword and return status  Dictionaries Should Be Equal  ${adapted_data.data}  ${tender_data.data}
  Run keyword if  ${status} == ${False}  Log  Initial tender data was changed  WARN
  ${TENDER_UAID}=  Викликати для учасника  ${tender_owner}
  ...      Створити тендер
  ...      ${adapted_data}
  Set To Dictionary  ${TENDER}  TENDER_UAID=${TENDER_UAID}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  initial_data=${adapted_data}
  Log  ${TENDER}


Можливість знайти закупівлю по ідентифікатору
  Викликати для учасника  ${viewer}
  ...      Пошук тендера по ідентифікатору
  ...      ${TENDER['TENDER_UAID']}


Можливість модифікації закупівлі
  Викликати для учасника  ${tender_owner}
  ...      Модифікувати закупівлю
  ...      ${TENDER['TENDER_UAID']}


Можливість додати документацію до закупівлі
  ${filepath}=  create_fake_doc
  Викликати для учасника  ${tender_owner}
  ...      Завантажити документ
  ...      ${filepath}
  ...      ${TENDER['TENDER_UAID']}
  ${documents}=  Create Dictionary  filepath=${filepath}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  documents=${documents}


Можливість зареєструвати і підтвердити постачальника до закупівлі
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

Відображення заголовку закупівлі
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      title


Відображення заголовку закупівлі англійською мовою
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      title_en


Відображення заголовку закупівлі російською мовою
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      title_ru


Відображення ідентифікатора закупівлі
  Звірити поле тендера із значенням  ${viewer}
  ...      ${TENDER['TENDER_UAID']}
  ...      tenderID


Відображення опису закупівлі
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      description


Відображення опису закупівлі англійською мовою
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      description_en


Відображення опису закупівлі російською мовою
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      description_ru


Відображення підстави вибору закупівлі
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      causeDescription


Відображення обгрунтування причини вибору закупівлі
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      cause

##############################################################################################
#             MAIN DATA.VALUE
##############################################################################################

Відображення бюджету закупівлі
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      value.amount


Відображення валюти закупівлі
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      value.currency


Відображення врахованого податку в бюджет закупівлі
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      value.valueAddedTaxIncluded

##############################################################################################
#             MAIN DATA.PROCURING ENTITY
##############################################################################################

Відображення країни замовника закупівлі
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      procuringEntity.address.countryName


Відображення населеного пункту замовника закупівлі
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      procuringEntity.address.locality


Відображення поштового коду замовника закупівлі
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      procuringEntity.address.postalCode


Відображення області замовника закупівлі
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      procuringEntity.address.region


Відображення вулиці замовника закупівлі
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      procuringEntity.address.streetAddress


Відображення контактного імені замовника закупівлі
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      procuringEntity.contactPoint.name


Відображення контактного телефону замовника закупівлі
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      procuringEntity.contactPoint.telephone


Відображення сайту замовника закупівлі
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      procuringEntity.contactPoint.url


Відображення офіційного імені замовника закупівлі
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      procuringEntity.identifier.legalName


Відображення схеми ідентифікації замовника закупівлі
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      procuringEntity.identifier.scheme


Відображення ідентифікатора замовника закупівлі
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      procuringEntity.identifier.id


Відображення імені замовника закупівлі
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      procuringEntity.name

##############################################################################################
#             MAIN DATA.ITEMS
##############################################################################################

Відображення опису додаткової класифікації номенклатури закупівлі
  ${ITEMS_NUM}=  Set variable  0
  Set Suite Variable  ${ITEMS_NUM}
  ${ADDITIONAL_CLASS_NUM}=  Set variable  0
  Set Suite Variable  ${ADDITIONAL_CLASS_NUM}
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      items[${ITEMS_NUM}].additionalClassifications.[${ADDITIONAL_CLASS_NUM}].description


Відображення ідентифікатора додаткової класифікації номенклатури закупівлі
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      items[${ITEMS_NUM}].additionalClassifications.[${ADDITIONAL_CLASS_NUM}].id


Відображення схеми додаткової класифікації номенклатури закупівлі
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      items[${ITEMS_NUM}].additionalClassifications.[${ADDITIONAL_CLASS_NUM}].scheme


Відображення схеми класифікації номенклатури закупівлі
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      items[${ITEMS_NUM}].classification.scheme


Відображення ідентифікатора класифікації номенклатури закупівлі
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      items[${ITEMS_NUM}].classification.id


Відображення опису класифікації номенклатури закупівлі
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      items[${ITEMS_NUM}].classification.description


Відображення опису номенклатури закупівлі
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      items[${ITEMS_NUM}].description


Відображення ідентифікатора номенклатури закупівлі
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      items[${ITEMS_NUM}].id


Відображення кількості номенклатури закупівлі
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${tender_owner}'].additional_items[${ITEMS_NUM}]['quantity']}
  ...      items[${ITEMS_NUM}].quantity


Відображення назви одиниці номенклатури закупівлі
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${tender_owner}'].additional_items[${ITEMS_NUM}]['unit']['name']}
  ...      items[${ITEMS_NUM}].unit.name


Відображення коду одиниці номенклатури закупівлі
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${tender_owner}'].additional_items[${ITEMS_NUM}]['unit']['code']}
  ...      items[${ITEMS_NUM}].unit.code


Відображення дати доставки номенклатури закупівлі
  Звірити дату тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      items[${ITEMS_NUM}].deliveryDate.endDate


Відображення координат широти доставки номенклатури закупівлі
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      items[${ITEMS_NUM}].deliveryLocation.latitude


Відображення координат довготи доставки номенклатури закупівлі
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      items[${ITEMS_NUM}].deliveryLocation.longitude


Відображення назви нас. пункту доставки номенклатури закупівлі
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      items[${ITEMS_NUM}].deliveryAddress.countryName


Відображення назви нас. пункту російською мовою доставки номенклатури закупівлі
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      items[${ITEMS_NUM}].deliveryAddress.countryName_ru


Відображення назви нас. пункту англійською мовою доставки номенклатури закупівлі
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      items[${ITEMS_NUM}].deliveryAddress.countryName_en


Відображення пошт. коду доставки номенклатури закупівлі
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      items[${ITEMS_NUM}].deliveryAddress.postalCode


Відображення регіону доставки номенклатури закупівлі
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      items[${ITEMS_NUM}].deliveryAddress.region


Відображення населеного пункту адреси доставки номенклатури закупівлі
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      items[${ITEMS_NUM}].deliveryAddress.locality


Відображення вулиці доставки номенклатури закупівлі
  Звірити поле тендера  ${viewer}
  ...      ${USERS.users['${tender_owner}'].initial_data}
  ...      items[${ITEMS_NUM}].deliveryAddress.streetAddress

##############################################################################################
#             DOCUMENTS
##############################################################################################

Відображення заголовку документа закупівлі
  ${doc_num}=  Set variable  0
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${tender_owner}']['documents']['filepath']}
  ...      documents[${doc_num}].title

##############################################################################################
#             AWARDS
##############################################################################################

Відображення підтвердженого постачальника закупівлі
  ${AWARD_NUM}=  Set variable  0
  Set Suite Variable  ${AWARD_NUM}
  Звірити поле тендера із значенням  ${viewer}
  ...      active
  ...      awards[${AWARD_NUM}].status


Відображення країни постачальника закупівлі
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${tender_owner}']['supplier_data']['data']['suppliers'][${SUPP_NUM}]['address']['countryName']}
  ...      awards[${AWARD_NUM}].suppliers[${SUPP_NUM}].address.countryName


Відображення міста постачальника закупівлі
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${tender_owner}']['supplier_data']['data']['suppliers'][${SUPP_NUM}]['address']['locality']}
  ...      awards[${AWARD_NUM}].suppliers[${SUPP_NUM}].address.locality


Відображення поштового коду постачальника закупівлі
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${tender_owner}']['supplier_data']['data']['suppliers'][${SUPP_NUM}]['address']['postalCode']}
  ...      awards[${AWARD_NUM}].suppliers[${SUPP_NUM}].address.postalCode


Відображення області постачальника закупівлі
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${tender_owner}']['supplier_data']['data']['suppliers'][${SUPP_NUM}]['address']['region']}
  ...      awards[${AWARD_NUM}].suppliers[${SUPP_NUM}].address.region


Відображення вулиці постачальника закупівлі
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${tender_owner}']['supplier_data']['data']['suppliers'][${SUPP_NUM}]['address']['streetAddress']}
  ...      awards[${AWARD_NUM}].suppliers[${SUPP_NUM}].address.streetAddress


Відображення контактного телефону постачальника закупівлі
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${tender_owner}']['supplier_data']['data']['suppliers'][${SUPP_NUM}]['contactPoint']['telephone']}
  ...      awards[${AWARD_NUM}].suppliers[${SUPP_NUM}].contactPoint.telephone


Відображення контактного імені постачальника закупівлі
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${tender_owner}']['supplier_data']['data']['suppliers'][${SUPP_NUM}]['contactPoint']['name']}
  ...      awards[${AWARD_NUM}].suppliers[${SUPP_NUM}].contactPoint.name


Відображення контактного імейлу постачальника закупівлі
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${tender_owner}']['supplier_data']['data']['suppliers'][${SUPP_NUM}]['contactPoint']['email']}
  ...      awards[${AWARD_NUM}].suppliers[${SUPP_NUM}].contactPoint.email


Відображення схеми ідентифікації постачальника закупівлі
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${tender_owner}']['supplier_data']['data']['suppliers'][${SUPP_NUM}]['identifier']['scheme']}
  ...      awards[${AWARD_NUM}].suppliers[${SUPP_NUM}].identifier.scheme


Відображення офіційного імені постачальника закупівлі
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${tender_owner}']['supplier_data']['data']['suppliers'][${SUPP_NUM}]['identifier']['legalName']}
  ...      awards[${AWARD_NUM}].suppliers[${SUPP_NUM}].identifier.legalName


Відображення ідентифікатора постачальника закупівлі
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${tender_owner}']['supplier_data']['data']['suppliers'][${SUPP_NUM}]['identifier']['id']}
  ...      awards[${AWARD_NUM}].suppliers[${SUPP_NUM}].identifier.id


Відображення імені постачальника закупівлі
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${tender_owner}']['supplier_data']['data']['suppliers'][${SUPP_NUM}]['name']}
  ...      awards[${AWARD_NUM}].suppliers[${SUPP_NUM}].name


Відображення врахованого податку до ціни номенклатури постачальника закупівлі
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${tender_owner}']['supplier_data']['data']['value']['valueAddedTaxIncluded']}
  ...      awards[${AWARD_NUM}].value.valueAddedTaxIncluded


Відображення валюти ціни номенклатури постачальника закупівлі
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${tender_owner}']['supplier_data']['data']['value']['currency']}
  ...      awards[${AWARD_NUM}].value.currency


Відображення вартості номенклатури постачальника закупівлі
  Звірити поле тендера із значенням  ${viewer}
  ...      ${USERS.users['${tender_owner}']['supplier_data']['data']['value']['amount']}
  ...      awards[${AWARD_NUM}].value.amount

##############################################################################################
#             CONTRACTS
##############################################################################################

Неможливість укласти угоду для закупівлі поки не пройде stand-still період
  ${CONTR_NUM}=  Set variable  0
  Set suite variable  ${CONTR_NUM}
  Require Failure  ${tender_owner}
  ...      Підтвердити підписання контракту
  ...      ${TENDER['TENDER_UAID']}
  ...      ${CONTR_NUM}


Відображення статусу непідписаної угоди з постачальником закупівлі
  Звірити поле тендера із значенням  ${viewer}
  ...      pending
  ...      contracts[${CONTR_NUM}].status


Можливість укласти угоду для закупівлі
  ${CONTR_NUM}=  Set variable  0
  Set suite variable  ${CONTR_NUM}
  Run keyword if  '${mode}' == 'negotiation' or '${mode}' == 'negotiation.quick'
  ...      Дочекатись дати  ${USERS.users['${tender_owner}'].tender_data.data.awards[${CONTR_NUM}].complaintPeriod.endDate}
  Викликати для учасника  ${tender_owner}
  ...      Підтвердити підписання контракту
  ...      ${TENDER['TENDER_UAID']}
  ...      ${CONTR_NUM}


Відображення статусу підписаної угоди з постачальником закупівлі
  Звірити поле тендера із значенням  ${viewer}
  ...      active
  ...      contracts[${CONTR_NUM}].status
