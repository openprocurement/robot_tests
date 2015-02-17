*** Setting ***
Library  op_robot_tests.tests_files.ApiCommands
Library  String
LIbrary  Collections


*** Keywords ***
Create api wrapper
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
    Log object data  ${tender}
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
    Log object data  ${tender}
    Set access key on tender

Change tender periods
    Log object data  ${tender}
    ${tender}=  set_tender_periods  ${tender}
    Log object data  ${tender}
    ${tender}=  Call Method  ${API}  patch_tender  ${tender}
    Set Global Variable  ${tender}
    Log object data  ${tender}
    Set access key on tender

Upload tender documentation
    ${file}=  upload tender document  ${API}  ${tender}
    patch tender document  ${API}  ${tender}  ${file.data.id}

Create question
    ${question}=  test question data
    Log object data  ${question}
    ${question}=  Call Method  ${API}  create_question  ${tender}  ${question}
    Log object data  ${question}
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

Wait to TenderPeriod
    Sleep  2 minutes 10 seconds  Wait on TenderPeriod status

Wait to start of auction's worker 
    Sleep  4 minutes 

Submit bids
    ${bids} =  Create Dictionary
    Log object data  ${bids}
    :FOR    ${index}   IN RANGE    2
    \    ${bid}=  test bid data
    \    Log object data  ${bid}
    \    ${temp_amount}=  Evaluate  ${bid['data']['value']['amount']} - ${index} 
    \    Log  ${temp_amount}
    \    ${bid.data.value.amount}=  Get Variable Value  ${temp_amount}
    \    ${bids_data}=  Submit bid with data  ${bid}
    \    Set To Dictionary  ${bids}   ${index}   ${bids_data}
    Set Global Variable  ${bids}
    Log object data  ${bids}



Submit bid with data
    [Arguments]   ${bid}
    ${bid_data}=  Call Method  ${API}  create_bid  ${tender}  ${bid}
    Log object data  ${bid_data}
    [return]  ${bid_data}


Get particular urls for bids
    ${bids_items}=    Get Dictionary Items    ${bids}
    :FOR    ${index}  ${bid}   IN   @{bids_items}
    \    ${approved_bid}=  Call Method  ${API}  get_bid  ${tender}   ${bid.data.id}  ${bid.access.token}
    \    Log object data   ${approved_bid}
    \    Log   ${approved_bid.data.participationUrl}


Wait to end of auction 
    Sleep  45 minutes  Wait to end of auction


Activate award
    ${awards}=  Call Method  ${API}  get_awards  ${tender}
    Log object data  ${awards}
    # :FOR    ${award}   IN   @{awards.data}
    # \    
    # award_id = [i['id'] for i in awards.data if i['status'] == 'pending'][0]
    # active_award = munchify({"data": {"status": "active", "id": award_id}})
    # award = api.patch_award(tender, active_award)
    # write_yaml('award_active.yaml', award)