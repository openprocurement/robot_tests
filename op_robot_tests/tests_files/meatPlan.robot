*** Settings ***
Library         op_robot_tests.tests_files.service_keywords
Library         op_robot_tests.tests_files.service_plan_keywords
Library         String
Library         Collections
Library         Selenium2Library
Library         DebugLibrary
Resource        keywords_plan.robot
Resource        resource.robot
Suite Setup     Test Suite Plan Setup
Suite Teardown  Close all browsers

*** Variables ***
${mode}         single

${role}         viewer
${broker}       Quinta_Plan

*** Test Cases ***
Можливість створити план
  [Tags]   ${USERS.users['${plan_owner}'].broker}: Можливість створити план
  ...      tender_owner
  ...      ${USERS.users['${plan_owner}'].broker}
  ...      minimal
  [Documentation]   Створення плану
  ${plan_data}=  Підготовка початкових даних плану
  ${PLAN_UAID}=  Викликати для учасника  ${plan_owner}  Створити план  ${plan_data}
  ${LAST_MODIFICATION_DATE}=  Get Current TZdate
  Set To Dictionary  ${USERS.users['${plan_owner}']}  initial_data  ${plan_data}
  Set To Dictionary  ${PLAN}   PLAN_UAID             ${PLAN_UAID}
  Set To Dictionary  ${PLAN}   LAST_MODIFICATION_DATE  ${LAST_MODIFICATION_DATE}
  Log  ${PLAN}