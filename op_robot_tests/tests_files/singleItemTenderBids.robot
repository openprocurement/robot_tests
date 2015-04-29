*** Setting ***
Library  op_robot_tests.tests_files.service_keywords
Library  String
LIbrary  Collections
LIbrary  Selenium2Library
Library  DebugLibrary
Resource  keywords.robot
Suite Setup  TestCaseSetup
Suite Teardown  Close all browsers

*** Variables ***
${viewer}    Tender Viewer
# Tender Viewer
${provider}   Tender User


*** Test Cases ***
Можливість оголосити однопердметний тендер
  [Tags]   ${USERS.users['${USERS.tender_owner}'].broker}: Можливість оголосити тендер
  Викликати для учасника     ${USERS.tender_owner}   Створити тендер
  ${LAST_MODIFICATION_DATE}=  Get Current Date
  Set Global Variable   ${LAST_MODIFICATION_DATE}

Пошук однопредметного тендера по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук тендера по ідентифікатору
  Дочекатись синхронізації з майданчиком    ${viewer}
  Викликати для учасника   ${viewer}   Пошук тендера по ідентифікатору   ${TENDER_DATA.data.tenderID}   ${TENDER_DATA.data.id}
 
Подати цінову пропозицію bidder1
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість подати цінову пропозицію
  Дочекатись дати початоку прийому пропозицій
  ${bid}=  test bid data
  Log object data  ${bid}
  ${biddingresponce}=  Викликати для учасника   ${provider}   Подати цінову пропозицію   ${TENDER_DATA.data.id}   ${bid}
  Set Global Variable   ${biddingresponce} 

#Подати цінову пропозицію bidder2
#  [Tags]   ${USERS.users['${provider2}'].broker}: Можливість подати цінову пропозицію
#  Дочекатись дати початоку прийому пропозицій
#  ${bid}=  test bid data
#  Log object data  ${bid}
#  ${biddingresponce}=  Викликати для учасника   ${provider2}   Подати цінову пропозицію   ${TENDER_DATA.data.id}   ${bid}
#  Set Global Variable   ${biddingresponce}

Змінити цінову пропозицію
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість змінити цінову пропозицію
  Log object data   ${biddingresponce}
  Set To Dictionary  ${biddingresponce.data.value}   amount   600
  Log object data   ${biddingresponce.data.value}
  Викликати для учасника   ${provider}   Змінити цінову пропозицію   ${TENDER_DATA.data.id}   ${biddingresponce}

Прийняти пропозицію переможця 
  [Tags]   ${USERS.users['${USERS.tender_owner}'].broker}: Можливість прийняти пропозицію переможця
  Дочекатись дати закінчення прийому пропозицій
  ${LAST_MODIFICATION_DATE}=  Get Current Date
  Set Global Variable   ${LAST_MODIFICATION_DATE}
  отримати останні зміни в тендері
  ${award}=  test_award_data
  ${award_data}=   Get_From_Object  ${TENDER_DATA.data}   awards[0]
  Set To Dictionary  ${award}  data  ${award_data}
  Set To Dictionary  ${award['data']}  status  active
  Викликати для учасника   ${USERS.tender_owner}   Прийняти цінову пропозицію   ${TENDER_DATA.data.id}   ${award}