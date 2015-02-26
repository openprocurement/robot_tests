*** Setting ***
Resource  keywords.robot
Resource  resource.robot

*** Test Cases ***
Tender process
    [tags]   all_stages
    Create api wrapper
    Create tender
    Change tender title
    Upload tender documentation
    Change tender periods
    Create question
    Write answer on first question
    Wait to tender period with name tenderPeriod
    Submit bids
    Review tender
    Wait to start of auction's worker
    Get particular urls for bids
    Get auction url for observer
    Game process begin
    Wait to end of auction
    Review tender
    Activate award
    [Teardown]  Close all browsers
