*** Setting ***
Library  Selenium2Screenshots
Library  String
Library  DateTime
Library           Selenium2Library
Library           ApiCommands
Library           Collections


*** Variables ***
${HOMEPAGE}       http://my.dz-test.net/cabinet/sign-in?sp=1&next=%2Fcabinet%2Fpurchases%2Fstate_purchase
${BROWSER}        chrome
${LOGIN}        r.zaporozhets@smartweb.com.ua
${PASSWORD}     1234

*** Keywords ***
Підготувати клієнт для користувача
  [Arguments]  ${username}
  log many  @{ARGUMENTS}
  log  ${username}
  [Documentation]  Відкрити брaвзер, створити обєкт api wrapper, тощо
  Open Browser   ${BROKERS['${USERS.users['${username}'].broker}'].url}   ${USERS.users['${username}'].browser}   alias=${username}
  Set Window Position   @{USERS.users['${username}'].position}
  #Set Window Size       @{USERS.users['${username}'].size}
  Log Variables

Go to homepage
    Switch Browser  Prom Owner
    Go To   ${HOMEPAGE}

Login
    Input text    id=phone_email    ${LOGIN}
    Input text    id=password    ${PASSWORD}
    Click Button    id=submit_login_button

#TODO: tender data should pass as args make converter from client initial data to prom initial data

Створити тендер
    [Arguments]  @{ARGUMENTS}
    log many  @{ARGUMENTS}

    Go to homepage
    Sleep   10
    Wait Until Page Contains Element     id=phone_email

    Login
    Sleep   3

    ${start_date}=    Get From Dictionary  ${ARGUMENTS[1].data.tenderPeriod}   startDate
    ${end_date}=      Get From Dictionary  ${ARGUMENTS[1].data.tenderPeriod}   endDate

    ${enquiry_start_date}=    Get From Dictionary  ${ARGUMENTS[1].data.enquiryPeriod}   startDate
    ${enquiry_end_date}=      Get From Dictionary  ${ARGUMENTS[1].data.enquiryPeriod}   endDate

    ${items}=  Get From Dictionary    ${ARGUMENTS[1].data}   items
    ${delivery_date}=  Get From Dictionary    ${items[0].deliveryDate}   endDate

    ${title}=   Get From Dictionary    ${ARGUMENTS[1].data}   title
    ${description}=  Get From Dictionary    ${ARGUMENTS[1].data}   description

    ${quantity}=  Get From Dictionary    ${items[0]}   quantity
    ${budget}=  Get From Dictionary    ${ARGUMENTS[1].data.value}   amount
    ${step_rate}=  Get From Dictionary    ${ARGUMENTS[1].data.minimalStep}   amount

    Click Element    id=js-btn-0
    Input text    id=title      ${title}
    Input text    id=descr      ${description}
    Input text    id=quantity      ${quantity}
    Input text    id=amount      ${budget}
    Click Element    xpath=//a[contains(@data-target, 'container-cpv')]
    Click Element    xpath=//div[contains(@class, 'qa_container_cpv_popup')]//input[@type='checkbox'][@value='16662']
    Click Element    xpath=//div[contains(@class, 'qa_container_cpv_popup')]//a[contains(@data-target, 'classifiers-inputs-cpv')]

    Click Element    xpath=//a[contains(@data-target, 'container-dkpp')]
    Click Element    xpath=//div[contains(@class, 'qa_container_dkpp_popup')]//input[@type='checkbox'][@value='4']
    Click Element    xpath=//div[contains(@class, 'qa_container_dkpp_popup')]//a[contains(@data-target, 'classifiers-inputs-dkpp')]
    Sleep   3
    Input text  id=dt_enquiry   ${enquiry_end_date}
    Sleep   5
    Input text  id=dt_tender_start   ${start_date}
    Sleep   5
    Input text  id=dt_tender_end    ${end_date}
    Sleep   5
    Input text  id=step   ${step_rate}
    Sleep   5
    Click Button    id=submit_button
    Wait Until Page Contains Element     xpath=//td[@id="qa_state_purchase_id"]/p
    ${id}=  Get Text  xpath=//td[@id="qa_state_purchase_id"]/p

    log  ${id}
    Should Not Be Equal As Strings   ${id}   ожидание...

    [return]  ${id}

Пошук тендера по ідентифікатору
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tenderId
  ...      ${ARGUMENTS[2]} ==  id
  Switch browser   ${ARGUMENTS[0]}
  ${current_location}=   Get Location
  Run keyword if   '${BROKERS['${USERS.users['${username}'].broker}'].url}/#/tenderDetailes/${ARGUMENTS[2]}'=='${current_location}'  Reload Page
  Go to   ${BROKERS['${USERS.users['${username}'].broker}'].url}
  Wait Until Page Contains   Допороговые закупки Украины   10
  sleep  1
  Input Text   id=search  ${ARGUMENTS[1]}
  Click Button   id=search_submit
  sleep  2
  ${last_note_id}=  Add pointy note   jquery=a[href^="#/tenderDetailes"]   Found tender with tenderID "${ARGUMENTS[1]}"   width=200  position=bottom
  sleep  1
  Remove element   ${last_note_id}
  Click Link    jquery=a[href^="#/tenderDetailes"]
  Wait Until Page Contains    ${ARGUMENTS[1]}   10
  sleep  1
  Capture Page Screenshot