*** Setting ***
Resource  keywords.robot
Resource  resource.robot
Resource  auction_keywords.robot


*** Test Cases ***
Valid Login
    Open Browser as observer
    Open Browser To Login Page bidder1
    Open Browser To Login Page bidder2
    Switch Browser   observer
    Auction is in standby
    Auction is between rounds → 1
    Auction is on round 1
    
auction runs 1 round
  bidder1 leaves bid 475000
  bidder2 leaves bid 470000
  Switch Browser   observer
  Auction is between rounds 1 → 2 

auction runs 2 round  
  Auction is on round 2
  bidder1 leaves bid 465000
  bidder2 leaves bid 460000
  Switch Browser   observer
  Auction is between rounds 2 → 3
  
auction is on last round
  Auction is on last round 3
  bidder1 leaves bid 455000
  bidder2 leaves bid 450000
  Switch Browser   observer
  Auction is finished
  [Teardown]  Close Browser
    
