*** Setting ***
Library  op_robot_tests.tests_files.ApiCommands
Library  String
LIbrary  Collections
LIbrary  Selenium2Library


*** Variables ***
${BROWSER}       googlechrome
${DELAY}         1
${URL}      http://cygnet.office.quintagroup.com:9001/tenders/ua3
#http://auction-sandbox.openprocurement.org/


${AUCTION_URL}    http://cygnet.office.quintagroup.com:9001/tenders/ua3
${LOGIN URL1}      ${AUCTION_URL}/login?bidder_id=d3ba84c66c9e4f34bfb33cc3c686f137&hash=4e79e605bfecbaa9ac4d0d974c541ee2988f7377
${LOGIN URL2}     ${AUCTION_URL}/login?bidder_id=5675acc9232942e8940a034994ad883e&hash=bd4a790aac32b73e853c26424b032e5a29143d1f

#$x('/html/body/div/div[1]/div/div[1]//*[contains(text(),"Аукціон завершився")]')
#[<span ng-if=​"$parent.info_timer.msg" class=​"ng-binding ng-scope">​…​</span>​]
# http://cygnet.office.quintagroup.com:9001/tenders/ua3/login?bidder_id=d3ba84c66c9e4f34bfb33cc3c686f137&hash=4e79e605bfecbaa9ac4d0d974c541ee2988f7377

*** Keywords ***
Open Browser as observer
    Open Browser    ${AUCTION_URL}    ${BROWSER}   observer
    Maximize Browser Window 
    Capture Page Screenshot 
    
Open Browser To Login Page bidder1 
    Open Browser    ${LOGIN URL1}    ${BROWSER}   bidder1
    Maximize Browser Window 
    Oauth Confirm Page Should Be Open 
    Capture Page Screenshot 
    Agree with rules
    
Open Browser To Login Page bidder2 
    Open Browser    ${LOGIN URL2}    ${BROWSER}   bidder2
    Maximize Browser Window 
    Oauth Confirm Page Should Be Open 
    Capture Page Screenshot 
    Agree with rules

Agree with rules
   Click Button    xpath=//form/div/button[1]
   #Auction Page Should Be Open
    
Oauth Confirm Page Should Be Open 
    Title Should Be    Authorization 

Auction Page Should Be Open 
   Location Should Be    ${AUCTION_URL}
   Page Should Contain   UA-11111 
   Wait Until Page Contains   до закінчення вашої черги   600
   Capture Page Screenshot

Start Browser 
  Open Browser  ${URL}   ${BROWSER}
  Capture Page Screenshot
  
Auction is in standby
  Page Should Contain    до початку аукціону   600
  ${value} =   Get Text   xpath = //p[@class="round-number ng-scope"]
  Should Be Equal   ${value}   Очікування
  Capture Page Screenshot

Auction is between rounds ${value1}
  Wait Until Page Contains   до початку раунду   600
  ${value} =  Get Text  xpath = //span[@class="round-number ng-binding"]
  Should Be Equal   ${value1}   ${value}
  Capture Page Screenshot
  
Auction is on round ${value3} 
  Wait Until Page Contains   до закінчення раунду   600
  ${round} =  Get Text   xpath = //p[@class="round-label ng-scope"]
  ${number} =  Get Text  xpath = //p[@class="round-number ng-binding"]
  Should Be Equal   ${round}    Раунд
  Should Be Equal   ${number}   ${value3} 
  Capture Page Screenshot  
  
Auction is on last round ${value3} 
  Wait Until Page Contains   до оголошення результатів   600
  ${round} =  Get Text   xpath = //p[@class="round-label ng-scope"]
  ${number} =  Get Text  xpath = //p[@class="round-number ng-binding"]
  Should Be Equal   ${round}    Раунд
  Should Be Equal   ${number}   ${value3} 
  Capture Page Screenshot
  
Auction is finished
  Wait Until Page Contains   Аукціон завершився   600
  ${value} =   Get Text   xpath = //p[@class="round-number ng-scope"]
  Should Be Equal   ${value}   Завершено
  Capture Page Screenshot
  
*** Keywords ***
#bidding keywords

#get minimum bid value
  
submit bid ${amount}
  Wait Until Page Contains   до закінчення вашої черги   300
  Input Text   xpath = //input[@id="bid"]   ${amount}
  Click Button   xpath = //button[@class="btn btn-success ng-scope"]
  Wait Until Page Contains    Заявку прийнято     10
  Page Should Not Contain  Надто висока заявка

bidder1 leaves bid ${amount}
    Switch Browser   bidder1
    submit bid ${amount}    

bidder2 leaves bid ${amount}
    Switch Browser   bidder2
    submit bid ${amount}
    
    