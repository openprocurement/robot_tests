*** Setting ***
Library  op_robot_tests.tests_files.ApiCommands
Library  String
LIbrary  Collections
LIbrary  Selenium2Library
LIbrary  DebugLibrary

*** Variables ***
${testingURL}   http://run.plnkr.co/plunks/Y8A38p9pOYImC3rHD26B/
${text}      497 000 або менше
${BROWSER}       googlechrome
${DELAY}         1
${URL}      http://cygnet.office.quintagroup.com:9001/tenders/ua3
${AUCTION_URL}    http://cygnet.office.quintagroup.com:9001/tenders/ua3
${LOGIN URL1}      ${AUCTION_URL}/login?bidder_id=d3ba84c66c9e4f34bfb33cc3c686f137&hash=4e79e605bfecbaa9ac4d0d974c541ee2988f7377
${LOGIN URL2}     ${AUCTION_URL}/login?bidder_id=5675acc9232942e8940a034994ad883e&hash=bd4a790aac32b73e853c26424b032e5a29143d1f
${timeout}     600    
${timeout2}     300 
${timeout3}     10 
${jscode}     var xx = document.querySelectorAll("span.bids-form-alert-msg");var y = [];for (var i = 0; i < xx.length; i++){y.push(xx[i].innerHTML);};console.log(y);return y;

*** Keywords ***
Open ${browser_type} browser as ${person} and go to ${location}
    Open Browser    ${location}    ${browser_type}   ${person}
    Maximize Browser Window 
    Capture Page Screenshot 

login as bidder
    Oauth Confirm Page Should Be Open 
    Capture Page Screenshot 
    Agree with rules 

Agree with rules
   Click Button    xpath=//form/div/button[1]
   Auction Page Should Be Open
    
Oauth Confirm Page Should Be Open 
    Title Should Be    Authorization 

Auction Page Should Be Open 
   Location Should Be    ${AUCTION_URL}
   Page Should Contain   UA-2015-02-14-000001
   Capture Page Screenshot
  
wait for your turn 
  Wait Until Page Contains   до закінчення вашої черги   ${timeout}
  
###########  Auction page contents   #########################################   
Auction is in standby
  Page Should Contain    до початку аукціону   ${timeout}
  ${auction_stasus} =   Get Text   xpath = //p[@class="round-number ng-scope"]
  Should Be Equal   ${auction_stasus}   Очікування
  Capture Page Screenshot

Auction is between rounds ${round_number}
  Wait Until Page Contains   до початку раунду   ${timeout}
  ${auction_stasus} =  Get Text  xpath = //span[@class="round-number ng-binding"]
  Should Be Equal   ${round_number}   ${auction_stasus}
  Capture Page Screenshot
  
Auction is on round ${round_number} with state: ${message}
  Wait Until Page Contains   ${message}   ${timeout}
  ${round} =  Get Text   xpath = //p[@class="round-label ng-scope"]
  ${number} =  Get Text  xpath = //p[@class="round-number ng-binding"]
  Should Be Equal   ${round}    Раунд
  Should Be Equal   ${number}   ${round_number} 
  Capture Page Screenshot    
    
Auction is finished
  Wait Until Page Contains   Аукціон завершився   ${timeout}
  ${auction_status} =   Get Text   xpath = //p[@class="round-number ng-scope"]
  Should Be Equal   ${auction_status}   Завершено
  Capture Page Screenshot
  
###########   bidding keywords   #########################################
 
submit bid ${amount}
  Run Keyword And Ignore Error   Click Button   xpath = //button[@id="edit-bid-button"]
  Input Text   xpath = //input[@id="bid-amount-input"]   ${amount}
  Click Button   xpath = //button[@id="place-bid-button"]
  get the messages 
  Capture Page Screenshot
  
place bid as part of limit with coefficient ${coef}
  ${limit} =  get upper bid limit value
  ${bid} =    Evaluate  int(${limit}*${coef})
  submit bid ${bid}
  Capture Page Screenshot

submit over limit bid
  place bid as part of limit with coefficient 1.1

submit low bid 
  place bid as part of limit with coefficient 0.09

refuse bid 
  Click Button   xpath = //button[@id="cancel-bid-button"]
  get the messages
  Capture Page Screenshot
 
edit bid to ${amount}
  Run Keyword And Ignore Error   Click Button   xpath = //button[@id="edit-bid-button"]
  submit bid ${amount}
  Capture Page Screenshot
    
get upper bid limit value
  Capture Page Screenshot
  ${text} =    Get text   xpath = //div/form/span[@class="ng-binding"]
  ${maxbid} =   Evaluate  int(''.join('${text}'.split(" ")[0:-2]))
  [return]  ${maxbid}
  Capture Page Screenshot
 
get the messages
  Sleep  1s
  ${message_list}=   Execute Javascript   ${jscode}
  [return]  ${message_list}
  Capture Page Screenshot
  
get time 
  ${text} =    Get text   xpath = //timer[@timerid=1]