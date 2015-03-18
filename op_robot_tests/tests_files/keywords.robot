*** Setting ***
Library  op_robot_tests.tests_files.ApiCommands
Library  String
LIbrary  Collections
LIbrary  Selenium2Library
Library   DebugLibrary

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
Init auction data
    ${auction_data}=  load_initial_data_from  auction_data.yaml
    Set Global Variable  ${auction_data}

Create api wrapper
    Init auction data
    ${API}=  prepare_api  ${api_key}
    Set Global Variable  ${API}
    LOG  ${API}
    Log Variables

Set access key on tender
    ${tender}=  set_access_key  ${tender}  ${access_token}
    Set Global Variable  ${tender}

Create tender
    ${init_tender_data}=  prepare_test_tender_data
    Log object data  ${init_tender_data}
    ${tender}=  Call Method  ${API}  create_tender  ${init_tender_data}
    Log object data  ${tender}  tender_creater
    ${access_token}=  Get Variable Value  ${tender.access.token}
    Set Global Variable  ${access_token}
    ${tender_id}=  Get Variable Value  ${tender.data.id}
    Set Global Variable  ${tender_id}
    Log   access_key: ${access_token}
    Log   tender_id: ${tender_id}
    Log Variables
    Set Global Variable  ${tender}
    [return]  ${tender}

Change tender title
    ${new_tender_sufix}=  Generate Random String  3  [NUMBERS]
    ${new_tender_title}=  Set Variable  1-QUINTA-KT-${new_tender_sufix}
    Log  new title: ${new_tender_title}
    Log object data  ${tender}
    ${tender.data.title}=  Set Variable  ${new_tender_title}
    ${tender.data.title_en}=  Set Variable  ${new_tender_title}
    ${tender.data.title_ru}=  Set Variable  ${new_tender_title}
    Log object data  ${tender}
    ${tender}=  Call Method  ${API}  patch_tender  ${tender}
    Set Global Variable  ${tender}
    Log object data  ${tender}  tender_changed_titles
    Set access key on tender

Change tender periods
    Log object data  ${tender}
    ${tender}=  set_tender_periods  ${tender}
    Log object data  ${tender}
    ${tender}=  Call Method  ${API}  patch_tender  ${tender}
    Set Global Variable  ${tender}
    Log object data  ${tender}  tender_changed_periods
    Set access key on tender

Upload tender documentation
    ${file}=  upload tender document  ${API}  ${tender}
    patch tender document  ${API}  ${tender}  ${file.data.id}

Create question
    ${question}=  test question data
    Log object data  ${question}
    ${question}=  Call Method  ${API}  create_question  ${tender}  ${question}
    Log object data  ${question}   question_created
    [return]  ${question}


Write answer on first question
    ${questions}=  Call Method  ${API}  get_questions  ${tender}
    Log object data  ${questions}
    ${question}=  Set Variable  ${questions.data[0]}
    Log object data  ${question}

    ${question}=  Call Method  ${API}  get_question  ${tender}  ${questions.data[0].id}
    Log object data  ${question}
    ${question}=  set_access_key  ${question}  ${access_token}
    Log object data  ${question}

    ${answer}=  test_question_answer_data
    Log object data  ${answer}
    ${question.data.answer}=  Set Variable  ${answer['data']['answer']}
    Log object data  ${question}
    ${question}=  Call Method  ${API}  patch_question  ${tender}  ${question}
    Log object data  ${question}
    [return]  ${question}

Review tender
    ${tender}=  Call Method  ${API}  get_tender  ${tender_id}
    Set Global Variable  ${tender}
    Log object data  ${tender}
    Set access key on tender

Wait to tender period with name ${period_name}
    log  ${tender.data.${period_name}.startDate}
    ${wait_seconds}=  calculate wait to date  ${tender.data.${period_name}.startDate}
    Sleep  ${wait_seconds}  Wait on ${period_name}
    Review tender

Wait to start of auction's worker
    Sleep  4 minutes

Submit bids
    Review tender
    Log object data  ${tender}  tender_before_submit_bids
    ${bids_items}=    Get Dictionary Items    ${auction_data.bidders}
    :FOR    ${bidder_key}  ${bidder_data}   IN  @{bids_items}
    \    ${bid}=  test bid data
    \    Log object data  ${bid}
    \    ${temp_amount}=  Get Variable Value   ${auction_data.bidders.${bidder_key}.start_bid}
    \    Log  ${temp_amount}
    \    ${bid.data.value.amount}=  Get Variable Value  ${temp_amount}
    \    ${bids_data}=  Submit in tender bid with data  ${bid}
    \    Set To Dictionary  ${auction_data.bidders.${bidder_key}}   tender_bid_data  ${bids_data}
    Log object data  ${auction_data}  auction_data_after_submit_bids
    Set Global Variable  ${auction_data}



Submit in tender bid with data
    [Arguments]   ${bid}
    ${bid_data}=  Call Method  ${API}  create_bid  ${tender}  ${bid}
    Log object data  ${bid_data}
    [return]  ${bid_data}


Get particular urls for bids
    ${bids_items}=    Get Dictionary Items    ${auction_data.bidders}
    :FOR   ${bidder_key}  ${bidder_data}   IN   @{bids_items}
    \    ${approved_bid}=  Call Method  ${API}  get_bid  ${tender}   ${bidder_data.tender_bid_data.data.id}  ${bidder_data.tender_bid_data.access.token}
    \    Log object data   ${approved_bid}
    \    Log   ${approved_bid.data.participationUrl}
    \    Set To Dictionary     ${auction_data.bidders.${bidder_key}}   start_url     ${approved_bid.data.participationUrl}
    Log object data  ${auction_data}  auction_data_after_get_particular_urls
    Set Global Variable  ${auction_data}


Get auction url for observer
    Review tender
    Set To Dictionary     ${auction_data.observer}  start_url   ${tender.data.auctionUrl}
    Log object data    ${auction_data}  auction_data_after_add_auction_url
    Set Global Variable  ${auction_data}


Wait to end of auction
    Sleep  1 minutes  Wait to end of auction


Activate award
    Review tender
    Log object data    ${tender}   tender_after_add_auction
    ${awards}=  Call Method  ${API}  get_awards  ${tender}
    Log object data  ${awards}  awards
    ${award_approve}=  create_approve_award_request_data  ${awards.data[0].id}
    Log object data  ${award_approve}
    ${approved_award}=  Call Method  ${API}  patch_award  ${tender}  ${award_approve}
    Log object data  ${approved_award}   award_approved
    ${award_canceled}=  create_approve_award_request_data  ${awards.data[0].id}
    Set To Dictionary   ${award_canceled.data}    status   cancelled
    Log object data  ${award_canceled}
    ${canceled_award}=  Call Method  ${API}  patch_award  ${tender}  ${award_canceled}
    Log object data  ${canceled_award}   award_canceled
    ${awards}=  Call Method  ${API}  get_awards  ${tender}
    Log object data  ${awards}  awards_after_cancel_one

Game process begin
    Open Browser To bidder0 Login Page
    Open Browser To bidder1 Login Page
    Open Browser as observer
    Auction is on round 1
    bidder1 leaves bid 40000
    Capture Page Screenshot
    bidder0 leaves bid 39000
    Capture Page Screenshot
    Auction is finished
    Capture Page Screenshot

Open Browser To ${bidder} Login Page
    Open Browser  ${auction_data.bidders.${bidder}.start_url}  ${auction_data.bidders.${bidder}.browser}  ${bidder}
    Maximize Browser Window
    Oauth Confirm Page Should Be Open
    ${bidder} agree with rules
    Sleep  2
    Capture Page Screenshot


Open Browser as observer
    Open Browser   ${auction_data.observer.start_url}    ${auction_data.observer.browser}   observer
    Maximize Browser Window
    Capture Page Screenshot

Oauth Confirm Page Should Be Open
    Title Should Be    Authorization
    Capture Page Screenshot

${bidder} agree with rules
  Click Element   css=.btn.btn-success
  Wait Until Page Contains   ${tender.data.tenderID}   20
  Capture Page Screenshot


submit bid ${amount} on auction
  Wait Until Page Contains   до закінчення вашої черги   600
  Input Text   xpath = //input[@id="bid-amount-input"]   ${amount}
  Click Button   xpath = //button[@id="place-bid-button"]
  Wait Until Page Contains    Заявку прийнято     10
  Page Should Not Contain  Надто висока заявка

${bidder} leaves bid ${amount}
    Switch Browser   ${bidder}
    submit bid ${amount} on auction


Auction is finished
  Wait Until Page Contains   Аукціон завершився   700
  ${value} =   Get Text   xpath= //p[@class="round-number ng-scope"]
  Should Be Equal   ${value}   Завершено
  Capture Page Screenshot

Auction is on round ${value3}
  Wait Until Page Contains   до закінчення раунду   1200
  ${round} =  Get Text   xpath = //p[@class="round-label ng-scope"]
  ${number} =  Get Text  xpath = //p[@class="round-number ng-binding"]
  Should Be Equal   ${round}    Раунд
  Should Be Equal   ${number}   ${value3}
  Capture Page Screenshot
  



*** Keywords ***
Open ${browser_type} browser as ${person} and go to ${location}
    Open Browser    ${location}    ${browser_type}   ${person}
    Maximize Browser Window 
    Capture Page Screenshot 

login as bidder
    #Oauth Confirm Page Should Be Open 
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
  
Auction on round ${round_number} with state: ${message}
  Wait Until Page Contains   ${message}   ${timeout}
  ${round} =  Get Text   xpath = //p[@class="round-label ng-scope"]
  ${number} =  Get Text  xpath = //p[@class="round-number ng-binding"]
  Should Be Equal   ${round}    Раунд
  Should Be Equal   ${number}   ${round_number} 
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
  Log many   ${message_list}  WARN
  [return]  ${message_list}
  Capture Page Screenshot
  
get time and state
  ${text}=    Get text   xpath = //timer[@timerid=1]
  ${state}=   Evaluate    " ".join(map(str,'${text}'.split(" ")[-3:]))
  ${time}=    Evaluate     " ".join(map(str,'${text}'.split(" ")[0:-3]))
  [return]   ${state}   ${time}   
  
  
