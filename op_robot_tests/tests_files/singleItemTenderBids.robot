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
${viewer}    Tender Viewer
${provider}   Tender User
${provider1}   Tender User

*** Test Cases ***
Можливість оголосити однопердметний тендер
  [Tags]   ${USERS.users['${USERS.tender_owner}'].broker}: Можливість оголосити тендер
  Викликати для учасника     ${USERS.tender_owner}   Створити тендер
  ${LAST_MODIFICATION_DATE}=  Get Current Date
  Set Global Variable   ${LAST_MODIFICATION_DATE}
  
Завантажити документ закупівельником
  [Tags]   ${USERS.users['${USERS.tender_owner}'].broker}: Можливість завантажити документ
  ${access_token}=  Get Variable Value  ${TENDER_DATA.access.token}
  Викликати для учасника   ${USERS.tender_owner}  Завантажити документ  ${access_token}
  
Пошук однопредметного тендера по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук тендера по ідентифікатору
  Дочекатись синхронізації з майданчиком    ${viewer}
  Викликати для учасника   ${viewer}   Пошук тендера по ідентифікатору   ${TENDER_DATA.data.tenderID}   ${TENDER_DATA.data.id}
 
Подати цінову пропозицію bidder1 
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість подати цінову пропозицію
  Дочекатись дати початоку прийому пропозицій
  ${bid}=  test bid data
  Log object data  ${bid}
  ${biddingresponce1}=  Викликати для учасника   ${provider}   Подати цінову пропозицію   ${TENDER_DATA.data.id}   ${bid}
  Set Global Variable   ${biddingresponce1}
  log  ${biddingresponce1}
  
#Завантажити документ першим учасником
#  [Tags]   ${USERS.users['${provider}'].broker}: Можливість прийняти пропозицію переможця
#  log   ${USERS.users['${provider}'].broker}
#  log  ${biddingresponce1}
#  ${token1}=  Get Variable Value  ${biddingresponce1.access.token}
#  Викликати для учасника   ${provider}  Завантажити документ    ${token1}

Подати цінову пропозицію bidder2 
  [Tags]   ${USERS.users['${provider1}'].broker}: Можливість подати цінову пропозицію
  Дочекатись дати початоку прийому пропозицій
  ${bid}=  test bid data
  Log object data  ${bid}
  ${biddingresponce2}=  Викликати для учасника   ${provider1}   Подати цінову пропозицію   ${TENDER_DATA.data.id}   ${bid}
  Set Global Variable   ${biddingresponce2}
  log  ${biddingresponce2}

#Завантажити документ другим учасником
#  [Tags]   ${USERS.users['${provider}'].broker}: Можливість прийняти пропозицію переможця
#  log   ${USERS.users['${provider1}'].broker}
#  ${token2}=  Get Variable Value  ${biddingresponce2.access.token}
#  Викликати для учасника   ${provider1}  Завантажити документ   ${token2}
  
Змінити цінову пропозицію
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість змінити цінову пропозицію
  Log object data   ${biddingresponce1}
  Set To Dictionary  ${biddingresponce1.data.value}   amount   400
  Log object data   ${biddingresponce1.data.value}
  Викликати для учасника   ${provider}   Змінити цінову пропозицію   ${TENDER_DATA.data.id}   ${biddingresponce1}
