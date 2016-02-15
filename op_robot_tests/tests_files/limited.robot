*** Settings ***
Library            op_robot_tests.tests_files.service_keywords
Library            Collections
Resource           keywords.robot
Resource           resource.robot
Suite Setup        TestSuiteSetup
Suite Teardown     Close all browsers


*** Variables ***
${mode}         limited
${role}         viewer
${broker}       Quinta


*** Test Cases ***
Можливість створити пряму закупівлю
  ${tender_data}=  Підготовка початкових даних
  ${TENDER_UAID}=  Викликати для учасника  ${tender_owner}  Створити тендер  ${tender_data}
  Log  ${tender_data}
  ${LAST_MODIFICATION_DATE}=  Get Current TZdate
  Set To Dictionary  ${TENDER}  LAST_MODIFICATION_DATE  ${LAST_MODIFICATION_DATE}
  Set To Dictionary  ${TENDER}  TENDER_UAID  ${TENDER_UAID}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  initial_data  ${tender_data}
  Log  ${TENDER}


Можливість модифікації прямої закупівлі
  Викликати для учасника  ${tender_owner}  Модифікувати закупівлю  ${TENDER['TENDER_UAID']}


Можливість додати документацію до прямої закупівлі
  ${TENDER_DOCUMENT_FILEPATH}=  create_fake_doc
  Set suite variable  ${TENDER_DOCUMENT_FILEPATH}
  Викликати для учасника  ${tender_owner}  Завантажити документ  ${TENDER_DOCUMENT_FILEPATH}  ${TENDER['TENDER_UAID']}


Можливість зареєструвати і підтвердити постачальника до прямої закупівлі
  ${SUPP_NUM}  Set variable  0
  Set Suite Variable  ${SUPP_NUM}
  Викликати для учасника  ${tender_owner}  Додати постачальника  ${TENDER['TENDER_UAID']}
  Викликати для учасника  ${tender_owner}  Підтвердити постачальника  ${TENDER['TENDER_UAID']}  ${SUPP_NUM}


Пошук прямої закупівлі по ідентифікатору
  Дочекатись синхронізації з майданчиком  ${viewer}
  Викликати для учасника  ${viewer}  Пошук тендера по ідентифікатору  ${TENDER['TENDER_UAID']}

##############################################################################################
#             MAIN DATA
##############################################################################################

Відображення заголовку прямої закупівлі
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  title


Відображення власника прямої закупівлі
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  owner


Відображення методу прямої закупівлі
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  procurementMethod


Відображення типу методу прямої закупівлі
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  procurementMethodType


Відображення ідентифікатора прямої закупівлі
  Звірити поле тендера із значенням  ${viewer}  ${TENDER['TENDER_UAID']}  tenderID

##############################################################################################
#             MAIN DATA.VALUE
##############################################################################################

Відображення бюджету прямої закупівлі
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  value.amount


Відображення валюти прямої закупівлі
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  value.currency


Відображення врахування податку в бюджет прямої закупівлі
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  value.valueAddedTaxIncluded

##############################################################################################
#             MAIN DATA.PROCURING ENTITY
##############################################################################################

Відображення країни замовника прямої закупівлі
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  procuringEntity.address.countryName


Відображення міста замовника прямої закупівлі
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  procuringEntity.address.locality


Відображення поштового коду замовника прямої закупівлі
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  procuringEntity.address.postalCode


Відображення області замовника прямої закупівлі
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  procuringEntity.address.region


Відображення вулиці замовника прямої закупівлі
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  procuringEntity.address.streetAddress


Відображення контактного імені замовника прямої закупівлі
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  procuringEntity.contactPoint.name


Відображення контактного телефону замовника прямої закупівлі
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  procuringEntity.contactPoint.telephone


Відображення сайту замовника прямої закупівлі
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  procuringEntity.contactPoint.url


Відображення ідентифікатора замовника прямої закупівлі
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  procuringEntity.identifier.id


Відображення офіційного імені замовника прямої закупівлі
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  procuringEntity.identifier.legalName


Відображення схеми замовника прямої закупівлі
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  procuringEntity.identifier.scheme


Відображення імені замовника прямої закупівлі
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  procuringEntity.name

##############################################################################################
#             MAIN DATA.ITEMS
##############################################################################################

Відображення опису додаткової класифікації номенклатури прямої закупівлі
  ${ITEMS_NUM}  Set variable  0
  Set Suite Variable  ${ITEMS_NUM}
  ${ADDITIONAL_CLASS_NUM}  Set variable  0
  Set Suite Variable  ${ADDITIONAL_CLASS_NUM}
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  items[${ITEMS_NUM}].additionalClassifications.[${ADDITIONAL_CLASS_NUM}].description


Відображення ідентифікатора додаткової класифікації номенклатури прямої закупівлі
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  items[${ITEMS_NUM}].additionalClassifications.[${ADDITIONAL_CLASS_NUM}].id


Відображення схеми додаткової класифікації номенклатури прямої закупівлі
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  items[${ITEMS_NUM}].additionalClassifications.[${ADDITIONAL_CLASS_NUM}].scheme


Відображення схеми класифікації номенклатури прямої закупівлі
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  items[${ITEMS_NUM}].classification.scheme


Відображення ідентифікатора класифікації номенклатури прямої закупівлі
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  items[${ITEMS_NUM}].classification.id


Відображення опису класифікації номенклатури прямої закупівлі
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  items[${ITEMS_NUM}].classification.description


Відображення опису номенклатури прямої закупівлі
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  items[${ITEMS_NUM}].description


Відображення ідентифікатора номенклатури прямої закупівлі
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  items[${ITEMS_NUM}].id


Відображення кількості номенклатури прямої закупівлі
  ${foo_id}  Set variable  0
  ${foo_token}  Set variable  0
  ${data}=  modify_tender  ${foo_id}  ${foo_token}
  Звірити поле тендера із значенням  ${viewer}  ${data['data']['items'][${ITEMS_NUM}]['quantity']}  items[${ITEMS_NUM}].quantity


Відображення назви одиниці номенклатури прямої закупівлі
  ${foo_id}  Set variable  0
  ${foo_token}  Set variable  0
  ${data}=  modify_tender  ${foo_id}  ${foo_token}
  Звірити поле тендера із значенням  ${viewer}  ${data['data']['items'][${ITEMS_NUM}]['unit']['name']}  items[${ITEMS_NUM}].unit.name


Відображення коду одиниці номенклатури прямої закупівлі
  ${foo_id}  Set variable  0
  ${foo_token}  Set variable  0
  ${data}=  modify_tender  ${foo_id}  ${foo_token}
  Звірити поле тендера із значенням  ${viewer}  ${data['data']['items'][${ITEMS_NUM}]['unit']['code']}  items[${ITEMS_NUM}].unit.code

##############################################################################################
#             DOCUMENTS
##############################################################################################

Відображення заголовку документа прямої закупівлі
  ${doc_num}  Set variable  0
  Звірити поле тендера із значенням  ${viewer}  ${tender_document_filepath}  documents[${doc_num}].title

##############################################################################################
#             AWARDS
##############################################################################################

Відображення підтвердженого постачальника прямої закупівлі
  ${AWARD_NUM}  Set variable  0
  Set Suite Variable  ${AWARD_NUM}
  ${supp_data}=  test_supplier_data
  Set Suite Variable  ${supp_data}
  Звірити поле тендера із значенням  ${viewer}  active  awards[${AWARD_NUM}].status


Відображення країни постачальника прямої закупівлі
  Звірити поле тендера із значенням  ${viewer}  ${supp_data['data']['suppliers'][${SUPP_NUM}]['address']['countryName']}  awards[${AWARD_NUM}].suppliers[${SUPP_NUM}].address.countryName


Відображення міста постачальника прямої закупівлі
  Звірити поле тендера із значенням  ${viewer}  ${supp_data['data']['suppliers'][${SUPP_NUM}]['address']['locality']}  awards[${AWARD_NUM}].suppliers[${SUPP_NUM}].address.locality


Відображення поштового коду постачальника прямої закупівлі
  Звірити поле тендера із значенням  ${viewer}  ${supp_data['data']['suppliers'][${SUPP_NUM}]['address']['postalCode']}  awards[${AWARD_NUM}].suppliers[${SUPP_NUM}].address.postalCode


Відображення області постачальника прямої закупівлі
  Звірити поле тендера із значенням  ${viewer}  ${supp_data['data']['suppliers'][${SUPP_NUM}]['address']['region']}  awards[${AWARD_NUM}].suppliers[${SUPP_NUM}].address.region


Відображення вулиці постачальника прямої закупівлі
  Звірити поле тендера із значенням  ${viewer}  ${supp_data['data']['suppliers'][${SUPP_NUM}]['address']['streetAddress']}  awards[${AWARD_NUM}].suppliers[${SUPP_NUM}].address.streetAddress


Відображення контактного телефону постачальника прямої закупівлі
  Звірити поле тендера із значенням  ${viewer}  ${supp_data['data']['suppliers'][${SUPP_NUM}]['contactPoint']['telephone']}  awards[${AWARD_NUM}].suppliers[${SUPP_NUM}].contactPoint.telephone


Відображення контактного імені постачальника прямої закупівлі
  Звірити поле тендера із значенням  ${viewer}  ${supp_data['data']['suppliers'][${SUPP_NUM}]['contactPoint']['name']}  awards[${AWARD_NUM}].suppliers[${SUPP_NUM}].contactPoint.name


Відображення контактного імейлу постачальника прямої закупівлі
  Звірити поле тендера із значенням  ${viewer}  ${supp_data['data']['suppliers'][${SUPP_NUM}]['contactPoint']['email']}  awards[${AWARD_NUM}].suppliers[${SUPP_NUM}].contactPoint.email


Відображення схеми постачальника прямої закупівлі
  Звірити поле тендера із значенням  ${viewer}  ${supp_data['data']['suppliers'][${SUPP_NUM}]['identifier']['scheme']}  awards[${AWARD_NUM}].suppliers[${SUPP_NUM}].identifier.scheme


Відображення офіційного імені постачальника прямої закупівлі
  Звірити поле тендера із значенням  ${viewer}  ${supp_data['data']['suppliers'][${SUPP_NUM}]['identifier']['legalName']}  awards[${AWARD_NUM}].suppliers[${SUPP_NUM}].identifier.legalName


Відображення ідентифікатора постачальника прямої закупівлі
  Звірити поле тендера із значенням  ${viewer}  ${supp_data['data']['suppliers'][${SUPP_NUM}]['identifier']['id']}  awards[${AWARD_NUM}].suppliers[${SUPP_NUM}].identifier.id


Відображення імені постачальника прямої закупівлі
  Звірити поле тендера із значенням  ${viewer}  ${supp_data['data']['suppliers'][${SUPP_NUM}]['name']}  awards[${AWARD_NUM}].suppliers[${SUPP_NUM}].name


Відображення врахованого податку до ціни номенклатури постачальника прямої закупівлі
  Звірити поле тендера із значенням  ${viewer}  ${supp_data['data']['value']['valueAddedTaxIncluded']}  awards[${AWARD_NUM}].value.valueAddedTaxIncluded


Відображення валюти ціни номенклатури постачальника прямої закупівлі
  Звірити поле тендера із значенням  ${viewer}  ${supp_data['data']['value']['currency']}  awards[${AWARD_NUM}].value.currency


Відображення вартості номенклатури постачальника прямої закупівлі
  Звірити поле тендера із значенням  ${viewer}  ${supp_data['data']['value']['amount']}  awards[${AWARD_NUM}].value.amount

##############################################################################################
#             CONTRACTS
##############################################################################################

Неможливість укласти угоду доки не пройде stand-still period прямої закупівлі
  ${CONTR_NUM}  Set Variable  0
  Set suite variable  ${CONTR_NUM}
  Викликати для учасника  ${tender_owner}  Підтвердити підписання контракту  shouldfail    ${TENDER['TENDER_UAID']}  ${CONTR_NUM}


Відображення непідписаної угоди з постачальником прямої закупівлі
  Звірити поле тендера із значенням  ${viewer}  pending  contracts[${CONTR_NUM}].status

##############################################################################################
#             CANCELLATIONS
##############################################################################################

Можливість сформувати запит на скасування прямої закупівлі
  ${CANCEL_NUM}  Set variable  0
  Set suite variable  ${CANCEL_NUM}
  Викликати для учасника  ${tender_owner}  Додати запит на скасування  ${TENDER['TENDER_UAID']}
  Викликати для учасника  ${tender_owner}  Завантажити документацію до запиту на скасування  ${TENDER['TENDER_UAID']}  ${CANCEL_NUM}


Можливість змінити опис документа в скасуванні прямої закупівлі
  ${FIRST_DOC}  Set Variable  0
  Set Suite Variable  ${FIRST_DOC}
  Викликати для учасника  ${tender_owner}  Змінити опис документа в скасуванні  ${TENDER['TENDER_UAID']}  ${CANCEL_NUM}  ${FIRST_DOC}


Можливість завантажити нову версію документа до запиту на скасування прямої закупівлі
  Викликати для учасника  ${tender_owner}  Завантажити нову версію документа до запиту на скасування  ${TENDER['TENDER_UAID']}  ${CANCEL_NUM}  ${FIRST_DOC}
  ${SECOND_DOC}  Set Variable  1
  Set Suite Variable  ${SECOND_DOC}
  Дочекатись синхронізації з майданчиком  ${viewer}
  Викликати для учасника  ${viewer}  Оновити сторінку з тендером  ${TENDER['TENDER_UAID']}


Можливість активувати скасування прямої закупівлі
  Викликати для учасника  ${tender_owner}  Підтвердити скасування закупівлі  ${TENDER['TENDER_UAID']}  ${CANCEL_NUM}
  Дочекатись синхронізації з майданчиком  ${viewer}
  Викликати для учасника  ${viewer}  Оновити сторінку з тендером  ${TENDER['TENDER_UAID']}


Відображення активного статусу скасування прямої закупівлі
  Звірити поле тендера із значенням  ${viewer}  active  cancellations[${CANCEL_NUM}].status


Відображення причини скасування прямої закупівлі
  Звірити поле тендера із значенням  ${viewer}  ${CANCELLATION_REASON}  cancellations[${CANCEL_NUM}].reason


Відображення опису документа скасування прямої закупівлі
  Звірити поле тендера із значенням  ${viewer}  ${CANCELLATION_DOCUMENT_DESCRIPTION}  cancellations[${CANCEL_NUM}].documents[${FIRST_DOC}].description


Відображення заголовку першого документа скасування прямої закупівлі
  Звірити поле тендера із значенням  ${viewer}  ${FIRST_CANCELLATION_DOCUMENT}  cancellations[${CANCEL_NUM}].documents[${FIRST_DOC}].title


Відображення заголовку другого документа скасування прямої закупівлі
  Звірити поле тендера із значенням  ${viewer}  ${SECOND_CANCELLATION_DOCUMENT}  cancellations[${CANCEL_NUM}].documents[${SECOND_DOC}].title
