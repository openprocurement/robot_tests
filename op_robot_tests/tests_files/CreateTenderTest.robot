*** Setting ***
Library  op_robot_tests.tests_files.service_keywords
Library  String
LIbrary  Collections
LIbrary  Selenium2Library
Library  DebugLibrary
Resource  keywords.robot
Resource  resource.robot
Suite Setup  TestCaseSetup
Suite Teardown  Close all browsers

*** Variables ***
${tender_dump_id}    0
${LOAD_BROKERS}    ['Prom'] #['Prom', 'Quinta']
${LOAD_USERS}      [ 'Prom Owner'] #'Tender Viewer', 'Tender User'

${tender_owner}   prom_owner    #Tender Owner
${provider}   Tender User
${viewer}   Tender Viewer

${item_id}       0
${question_id}   0

#Avalable roles and users

#roles: Owner, User, Viewer 

#palyers:
  #E-tender 
  #Prom 
  #SmartTender 
  #Publicbid 
  #Netcast 

*** Test Cases ***
Можливість оголосити однопердметний тендер
  [Tags]   ${USERS.users['${USERS.${tender_owner}}'].broker}: Можливість оголосити тендер
  Викликати для учасника     ${USERS.${tender_owner}}   Створити тендер  ${INITIAL_TENDER_DATA}
  ${LAST_MODIFICATION_DATE}=  Get Current Date
  Set Global Variable   ${LAST_MODIFICATION_DATE}


