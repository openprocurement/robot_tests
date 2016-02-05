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


Пошук прямої закупівлі по ідентифікатору
  Дочекатись синхронізації з майданчиком  ${viewer}
  Викликати для учасника  ${viewer}  Пошук тендера по ідентифікатору  ${TENDER['TENDER_UAID']}


Можливість додати документацію до прямої закупівлі
  ${filepath}=  create_fake_doc
  Викликати для учасника  ${tender_owner}  Завантажити документ  ${filepath}  ${TENDER['TENDER_UAID']}


Можливість зареєструвати і підтвердити постачальника
  Викликати для учасника  ${tender_owner}  Додати постачальника
  Викликати для учасника  ${tender_owner}  Підтвердити постачальника  ${TENDER['TENDER_UAID']}


Можливість укласти угоду
  Викликати для учасника  ${tender_owner}  Підтвердити підписання контракту  shouldfail


Можливість сформувати запит на скасування
  Викликати для учасника  ${tender_owner}  Додати запит на скасування
  Викликати для учасника  ${tender_owner}  Завантажити документацію до запиту на скасування


Можливість змінити опис процедури і інші поля
  Викликати для учасника  ${tender_owner}  Змінити опис документа в скасуванні


Можливість завантажити нову версію документа до запиту на скасування
  Викликати для учасника  ${tender_owner}  Завантажити нову версію документа до запиту на скасування


Можливість активувати скасування закупівлі
  Викликати для учасника  ${tender_owner}  Підтвердити скасування закупівлі
