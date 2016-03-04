*** Settings ***
Library            op_robot_tests.tests_files.service_keywords
Library            Collections
Resource           keywords.robot
Resource           resource.robot
Suite Setup        Test Suite Setup
Suite Teardown     Close all browsers


*** Variables ***
${mode}         limited
${role}         viewer
${broker}       Quinta


*** Test Cases ***
Можливість створити пряму закупівлю
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${tender_data}=  Підготовка початкових даних
  ${TENDER_UAID}=  Викликати для учасника  ${tender_owner}  Створити тендер  ${tender_data}
  Log  ${tender_data}
  Set To Dictionary  ${TENDER}  TENDER_UAID  ${TENDER_UAID}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  initial_data  ${tender_data}
  Log  ${TENDER}


Можливість модифікації закупівлі
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Log  ${TENDER['LAST_MODIFICATION_DATE']}
  Викликати для учасника  ${tender_owner}  Модифікувати закупівлю


Можливість додати документацію до прямої закупівлі
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Log  ${TENDER['LAST_MODIFICATION_DATE']}
  ${TENDER_DOCUMENT_FILEPATH}=  create_fake_doc
  Set suite variable  ${TENDER_DOCUMENT_FILEPATH}
  Викликати для учасника  ${tender_owner}  Завантажити документ  ${TENDER_DOCUMENT_FILEPATH}  ${TENDER['TENDER_UAID']}


Можливість зареєструвати і підтвердити постачальника
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Log  ${TENDER['LAST_MODIFICATION_DATE']}
  Викликати для учасника  ${tender_owner}  Додати постачальника
  Викликати для учасника  ${tender_owner}  Підтвердити постачальника


Пошук прямої закупівлі по ідентифікатору
  Дочекатись синхронізації з майданчиком  ${viewer}
  Викликати для учасника  ${viewer}  Пошук тендера по ідентифікатору  ${TENDER['TENDER_UAID']}

##############################################################################################
#             MAIN DATA
##############################################################################################

Відображення title
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  title


Відображення owner
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  owner


Відображення procurement method
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  procurementMethod


Відображення procurement method type
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  procurementMethodType


Відображення tenderID
  Звірити поле тендера із значенням  ${viewer}  ${TENDER['TENDER_UAID']}  tenderID

##############################################################################################
#             MAIN DATA.VALUE
##############################################################################################

Відображення value.amount
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  value.amount


Відображення value.currency
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  value.currency


Відображення value.valueAddedTaxIncluded
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  value.valueAddedTaxIncluded

##############################################################################################
#             MAIN DATA.PROCURING ENTITY
##############################################################################################

Відображення procuringEntity.address.countryName
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  procuringEntity.address.countryName


Відображення procuringEntity.address.locality
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  procuringEntity.address.locality


Відображення procuringEntity.address.postalCode
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  procuringEntity.address.postalCode


Відображення procuringEntity.address.region
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  procuringEntity.address.region


Відображення procuringEntity.address.streetAddress
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  procuringEntity.address.streetAddress


Відображення procuringEntity.contactPoint.name
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  procuringEntity.contactPoint.name


Відображення procuringEntity.contactPoint.telephone
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  procuringEntity.contactPoint.telephone


Відображення procuringEntity.contactPoint.url
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  procuringEntity.contactPoint.url


Відображення procuringEntity.identifier.id
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  procuringEntity.identifier.id


Відображення procuringEntity.identifier.legalName
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  procuringEntity.identifier.legalName


Відображення procuringEntity.identifier.scheme
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  procuringEntity.identifier.scheme


Відображення procuringEntity.name
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  procuringEntity.name

##############################################################################################
#             MAIN DATA.ITEMS
##############################################################################################

Відображення items[0].additionalClassifications.[0].description
  ${ITEMS_NUM}  Set variable  0
  Set Suite Variable  ${ITEMS_NUM}
  ${ADDITIONAL_CLASS_NUM}  Set variable  0
  Set Suite Variable  ${ADDITIONAL_CLASS_NUM}
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  items[${ITEMS_NUM}].additionalClassifications.[${ADDITIONAL_CLASS_NUM}].description


Відображення items[0].additionalClassifications.[0].id
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  items[${ITEMS_NUM}].additionalClassifications.[${ADDITIONAL_CLASS_NUM}].id


Відображення items[0].additionalClassifications.[0].scheme
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  items[${ITEMS_NUM}].additionalClassifications.[${ADDITIONAL_CLASS_NUM}].scheme


Відображення items[0].classification.scheme
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  items[${ITEMS_NUM}].classification.scheme


Відображення items[0].classification.id
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  items[${ITEMS_NUM}].classification.id


Відображення items[0].classification.description
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  items[${ITEMS_NUM}].classification.description


Відображення items[0].description
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  items[${ITEMS_NUM}].description


Відображення items[0].id
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  items[${ITEMS_NUM}].id


Відображення items[0].quantity
  ${foo_id}  Set variable  0
  ${foo_token}  Set variable  0
  ${data}=  modify_tender  ${foo_id}  ${foo_token}
  Звірити поле тендера із значенням  ${viewer}  ${data['data']['items'][${ITEMS_NUM}]['quantity']}  items[${ITEMS_NUM}].quantity


Відображення items[0].unit.name
  ${foo_id}  Set variable  0
  ${foo_token}  Set variable  0
  ${data}=  modify_tender  ${foo_id}  ${foo_token}
  Звірити поле тендера із значенням  ${viewer}  ${data['data']['items'][${ITEMS_NUM}]['unit']['name']}  items[${ITEMS_NUM}].unit.name


Відображення items[0].unit.code
  ${foo_id}  Set variable  0
  ${foo_token}  Set variable  0
  ${data}=  modify_tender  ${foo_id}  ${foo_token}
  Звірити поле тендера із значенням  ${viewer}  ${data['data']['items'][${ITEMS_NUM}]['unit']['code']}  items[${ITEMS_NUM}].unit.code

##############################################################################################
#             DOCUMENTS
##############################################################################################

Відображення documents[0].title
  ${doc_num}  Set variable  0
  Звірити поле тендера із значенням  ${viewer}  ${tender_document_filepath}  documents[${doc_num}].title

##############################################################################################
#             AWARDS
##############################################################################################

Відображення awards[0].status (active)
  ${AWARD_NUM}  Set variable  0
  Set Suite Variable  ${AWARD_NUM}
  ${SUPP_NUM}  Set variable  0
  Set Suite Variable  ${SUPP_NUM}
  ${supp_data}=  test_supplier_data
  Set Suite Variable  ${supp_data}
  ${award_status}  Set variable  active
  Звірити поле тендера із значенням  ${viewer}  ${award_status}  awards[${AWARD_NUM}].status


Відображення awards[0].suppliers[0].address.countryName
  Звірити поле тендера із значенням  ${viewer}  ${supp_data['data']['suppliers'][${SUPP_NUM}]['address']['countryName']}  awards[${AWARD_NUM}].suppliers[${SUPP_NUM}].address.countryName


Відображення awards[0].suppliers[0].address.locality
  Звірити поле тендера із значенням  ${viewer}  ${supp_data['data']['suppliers'][${SUPP_NUM}]['address']['locality']}  awards[${AWARD_NUM}].suppliers[${SUPP_NUM}].address.locality


Відображення awards[0].suppliers[0].address.postalCode
  Звірити поле тендера із значенням  ${viewer}  ${supp_data['data']['suppliers'][${SUPP_NUM}]['address']['postalCode']}  awards[${AWARD_NUM}].suppliers[${SUPP_NUM}].address.postalCode


Відображення awards[0].suppliers[0].address.region
  Звірити поле тендера із значенням  ${viewer}  ${supp_data['data']['suppliers'][${SUPP_NUM}]['address']['region']}  awards[${AWARD_NUM}].suppliers[${SUPP_NUM}].address.region


Відображення awards[0].suppliers[0].address.streetAddress
  Звірити поле тендера із значенням  ${viewer}  ${supp_data['data']['suppliers'][${SUPP_NUM}]['address']['streetAddress']}  awards[${AWARD_NUM}].suppliers[${SUPP_NUM}].address.streetAddress


Відображення awards[0].suppliers[0].contactPoint.telephone
  Звірити поле тендера із значенням  ${viewer}  ${supp_data['data']['suppliers'][${SUPP_NUM}]['contactPoint']['telephone']}  awards[${AWARD_NUM}].suppliers[${SUPP_NUM}].contactPoint.telephone


Відображення awards[0].suppliers[0].contactPoint.name
  Звірити поле тендера із значенням  ${viewer}  ${supp_data['data']['suppliers'][${SUPP_NUM}]['contactPoint']['name']}  awards[${AWARD_NUM}].suppliers[${SUPP_NUM}].contactPoint.name


Відображення awards[0].suppliers[0].contactPoint.email
  Звірити поле тендера із значенням  ${viewer}  ${supp_data['data']['suppliers'][${SUPP_NUM}]['contactPoint']['email']}  awards[${AWARD_NUM}].suppliers[${SUPP_NUM}].contactPoint.email


Відображення awards[0].suppliers[0].identifier.scheme
  Звірити поле тендера із значенням  ${viewer}  ${supp_data['data']['suppliers'][${SUPP_NUM}]['identifier']['scheme']}  awards[${AWARD_NUM}].suppliers[${SUPP_NUM}].identifier.scheme


Відображення awards[0].suppliers[0].identifier.legalName
  Звірити поле тендера із значенням  ${viewer}  ${supp_data['data']['suppliers'][${SUPP_NUM}]['identifier']['legalName']}  awards[${AWARD_NUM}].suppliers[${SUPP_NUM}].identifier.legalName


Відображення awards[0].suppliers[0].identifier.id
  Звірити поле тендера із значенням  ${viewer}  ${supp_data['data']['suppliers'][${SUPP_NUM}]['identifier']['id']}  awards[${AWARD_NUM}].suppliers[${SUPP_NUM}].identifier.id


Відображення awards[0].suppliers[0].name
  Звірити поле тендера із значенням  ${viewer}  ${supp_data['data']['suppliers'][${SUPP_NUM}]['name']}  awards[${AWARD_NUM}].suppliers[${SUPP_NUM}].name


Відображення awards[0].value.valueAddedTaxIncluded
  Звірити поле тендера із значенням  ${viewer}  ${supp_data['data']['value']['valueAddedTaxIncluded']}  awards[${AWARD_NUM}].value.valueAddedTaxIncluded


Відображення awards[0].value.currency
  Звірити поле тендера із значенням  ${viewer}  ${supp_data['data']['value']['currency']}  awards[${AWARD_NUM}].value.currency


Відображення awards[0].value.amount
  Звірити поле тендера із значенням  ${viewer}  ${supp_data['data']['value']['amount']}  awards[${AWARD_NUM}].value.amount

##############################################################################################
#             CONTRACTS
##############################################################################################

Неможливість укласти угоду доки не пройде stand-still period
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Викликати для учасника  ${tender_owner}  Підтвердити підписання контракту  shouldfail


Відображення contracts.status (pending)
  ${contr_num}  Set Variable  0
  ${contract_status}  Set variable  pending
  Звірити поле тендера із значенням  ${viewer}  ${contract_status}  contracts[${contr_num}].status

##############################################################################################
#             CANCELLATIONS
##############################################################################################

Можливість сформувати запит на скасування
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Викликати для учасника  ${tender_owner}  Додати запит на скасування
  Викликати для учасника  ${tender_owner}  Завантажити документацію до запиту на скасування


Можливість змінити опис документа в скасуванні
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Викликати для учасника  ${tender_owner}  Змінити опис документа в скасуванні


Можливість завантажити нову версію документа до запиту на скасування
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Викликати для учасника  ${tender_owner}  Завантажити нову версію документа до запиту на скасування
  Дочекатись синхронізації з майданчиком  ${viewer}
  Викликати для учасника  ${viewer}  Оновити сторінку з тендером  ${TENDER['TENDER_UAID']}


Можливість активувати скасування закупівлі
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Викликати для учасника  ${tender_owner}  Підтвердити скасування закупівлі
  Дочекатись синхронізації з майданчиком  ${viewer}
  Викликати для учасника  ${viewer}  Оновити сторінку з тендером  ${TENDER['TENDER_UAID']}


Відображення cancellations[0].status (active)
  ${CANCEL_NUM}=  Set variable  0
  Set suite variable  ${CANCEL_NUM}
  ${cancellation_status}  Set variable  active
  Звірити поле тендера із значенням  ${viewer}  ${cancellation_status}  cancellations[${CANCEL_NUM}].status


Відображення cancellations[0].cancellationOf
  ${CANCEL_NUM}  Set Variable  0
  ${FIRST_DOC}  Set Variable  0
  ${SECOND_DOC}  Set Variable  1
  Set Suite Variable  ${CANCEL_NUM}
  Set Suite Variable  ${FIRST_DOC}
  Set Suite Variable  ${SECOND_DOC}
  Звірити поле тендера із значенням  ${viewer}  ${CANCELLATION_REASON}  cancellations[${CANCEL_NUM}].reason


Відображення cancellations[0].documents[0].description
  Звірити поле тендера із значенням  ${viewer}  ${CANCELLATION_DOCUMENT_DESCRIPTION}  cancellations[${CANCEL_NUM}].documents[${FIRST_DOC}].description


Відображення cancellations[0].documents[0].title
  Звірити поле тендера із значенням  ${viewer}  ${FIRST_CANCELLATION_DOCUMENT}  cancellations[${CANCEL_NUM}].documents[${FIRST_DOC}].title


Відображення cancellations[0].documents[1].title
  Звірити поле тендера із значенням  ${viewer}  ${SECOND_CANCELLATION_DOCUMENT}  cancellations[${CANCEL_NUM}].documents[${SECOND_DOC}].title
