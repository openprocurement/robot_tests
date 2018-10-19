*** Settings ***
Resource        base_keywords.robot
Resource        resource.robot
Suite Setup     Test Suite Setup
Suite Teardown  Test Suite Teardown


*** Variables ***
${RESOURCE}     plans
@{USED_ROLES}   tender_owner  viewer

*** Test Cases ***
Можливість переглянути плани
  [Tags]   ${USERS.users['${viewer}'].broker}: Читання планів
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      plan_feed
  ...      plan_view
  ...      critical
  Можливість прочитати плани
