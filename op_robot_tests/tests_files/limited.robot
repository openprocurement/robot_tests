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
${mode}         limited
${role}         viewer
${broker}       Quinta


*** Test Cases ***
Можливість створити пряму закупівлю
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість створити тендер
  ${tender_data}=  Підготовка початкових даних
  ${TENDER_UAID}=  Викликати для учасника  ${tender_owner}  Створити тендер  ${tender_data}
  ${LAST_MODIFICATION_DATE}=  Get Current TZdate
  Set To Dictionary  ${USERS.users['${tender_owner}']}  initial_data  ${tender_data}
  Set To Dictionary  ${TENDER}   TENDER_UAID             ${TENDER_UAID}
  Set To Dictionary  ${TENDER}   LAST_MODIFICATION_DATE  ${LAST_MODIFICATION_DATE}
  log  ${TENDER}
  log  ${tender_data}


Пошук прямої закупівлі по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук тендера по ідентифікатору
  Дочекатись синхронізації з майданчиком    ${viewer}
  Викликати для учасника   ${viewer}   Пошук тендера по ідентифікатору   ${TENDER['TENDER_UAID']}
  Log  ${TENDER['TENDER_UAID']}


Можливість додати документацію до прямої закупівлі
  [Tags]    ${USERS.users['${tender_owner}'].broker}: Можливість завантажити документацію
  [Documentation]   Закупівельник   ${USERS.users['${tender_owner}'].broker}  завантажує документацію  до  оголошеної закупівлі
  ${filepath}=   create_fake_doc
  ${doc_upload_reply}=  Викликати для учасника   ${tender_owner}   Завантажити документ  ${filepath}  ${TENDER['TENDER_UAID']}
  ${file_upload_process_data}=  Create Dictionary   filepath=${filepath}  doc_upload_reply=${doc_upload_reply}
  log  ${file_upload_process_data}
  Set To Dictionary  ${USERS.users['${tender_owner}']}   file_upload_process_data   ${file_upload_process_data}
  Log  ${USERS.users['${tender_owner}']}


Можливість зареєструвати і підтвердити постачальника
  ${award_response}=  Викликати для учасника  ${tender_owner}   Додати постачальника  ${TENDER['TENDER_UAID']}
  Log  ${award_response}
  ${award_confirmation_response}=  Викликати для учасника  ${tender_owner}   Підтвердити постачальника  ${TENDER['TENDER_UAID']}
  log  ${award_confirmation_response}


Можливість укласти угоду
  ${contract_confirmation_response}=  Викликати для учасника  ${tender_owner}  Підтвердити підписання контракту  shouldfail   ${TENDER['TENDER_UAID']}
  log  ${contract_confirmation_response}


Можливість сформувати запит на скасування
  ${cancellation_response}=  Викликати для учасника  ${tender_owner}   Додати запит на скасування    ${TENDER['TENDER_UAID']}
  log  ${cancellation_response}
  Set To Dictionary  ${USERS.users['${tender_owner}']}   cancellation_response_field  ${cancellation_response}
  log  ${USERS.users['${tender_owner}']['cancellation_response_field']}


Можливість додати документацію до запиту на скасування
  ${filepath}=   create_fake_doc
  ${doc_upload_reply}=  Викликати для учасника   ${tender_owner}   Завантажити документацію до запиту на скасування  ${filepath}  ${TENDER['TENDER_UAID']}
  log  ${doc_upload_reply}
  ${file_upload_process_data}=  Create Dictionary   filepath=${filepath}  doc_upload_reply=${doc_upload_reply}
  log  ${file_upload_process_data}
  Set To Dictionary  ${USERS.users['${tender_owner}']}   file_upload_process_data   ${file_upload_process_data}


Можливість змінити опис процедури і інші поля
  ${cancellation_document_updated_data}=  Викликати для учасника  ${tender_owner}  Змінити опис документа в скасуванні   ${TENDER['TENDER_UAID']}
  log  ${cancellation_document_updated_data}


Можливість завантажити нову версію документа до запиту на скасування
  ${filepath}=   create_fake_doc
  ${doc_upload_reply}=  Викликати для учасника   ${tender_owner}  Завантажити нову версію документа до запиту на скасування  ${filepath}
  log  ${doc_upload_reply}


Можливість активувати скасування закупівлі
  ${cancellation_confirmation_response}=  Викликати для учасника  ${tender_owner}  Підтвердити скасування закупівлі    ${TENDER['TENDER_UAID']}
  log  ${cancellation_confirmation_response}
