*** Setting ***
Documentation    Tests to verify observer account and users bids order 

Resource  keywords.robot
Resource  resource.robot
Resource  auction_keywords.robot
LIbrary  Selenium2Library

*** Test Cases ***

Valid Login
  [Tags]
  [Documentation]    Opens a browser for observer and both users agrees 
  ...                with rules as users, waits auction start, checks auction status
  Open ${BROWSER} browser as viewer and go to ${AUCTION_URL}
  get time and state
  Open ${BROWSER} browser as bidder1 and go to ${LOGIN URL1}
  login as bidder
  Open ${BROWSER} browser as bidder2 and go to ${LOGIN URL2}
  login as bidder
  Switch Browser   viewer
  #Auction is in standby
  Auction is between rounds → 1
  Auction is on round 1 with state: до закінчення раунду

invalid bids test
  [Tags]
  [Documentation]    bidders make thair bids on round 1, test verifies if bids are accepted
  ...                and no errors appears
  Switch Browser   bidder1
  Auction Page Should Be Open
  wait for your turn
  submit bid --1
  submit bid -1
  submit bid 999999999999
  edit bid to -999999999999
  edit bid to 9999.9999999
  edit bid to -9999.9999999
  edit bid to 0.999999999999
  edit bid to -0,999999999999
  edit bid to 9999,9999999
  edit bid to -9999,9999999
  edit bid to 0,999999999999
  edit bid to -0,999999999999
  submit over limit bid
  submit low bid 
  Switch Browser   viewer
   
auction runs 1 round
  [Tags]
  [Documentation]    bidders make thair bids on round 1, test verifies if bids are accepted
  ...                and no errors appears
  Switch Browser   bidder1
  Auction Page Should Be Open
  wait for your turn
  place bid as part of limit with coefficient 0.95
  Switch Browser   bidder2
  wait for your turn
  place bid as part of limit with coefficient 0.97
  Switch Browser   viewer
  Auction is between rounds 1 → 2 

auction runs 2 round 
  [Tags]
  [Documentation]    bidders make thair bids on round 2, test verifies if bids are accepted
  ...                and no errors appears
  Auction is on round 2 with state: до закінчення раунду
  Switch Browser   bidder1
  Auction Page Should Be Open
  wait for your turn
  place bid as part of limit with coefficient 0.90
  Switch Browser   bidder2
  wait for your turn
  place bid as part of limit with coefficient 0.92
  Switch Browser   viewer
  Auction is between rounds 2 → 3
  
auction is on last round
  [Tags]
  [Documentation]    bidders make thair bids on last round, test verifies if bids are accepted
  ...                and no errors appears, auctin is finished and all browsers are closed
  Auction is on round 3 with state: до оголошення результатів
  Switch Browser   bidder1
  Auction Page Should Be Open
  wait for your turn
  place bid as part of limit with coefficient 0.80
  Switch Browser   bidder2
  wait for your turn
  place bid as part of limit with coefficient 0.78
  Switch Browser   viewer
  Auction is finished
  [Teardown]  Close All Browsers