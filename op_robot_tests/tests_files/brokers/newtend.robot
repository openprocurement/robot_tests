*** Setting ***
Library  Selenium2Screenshots
Library  String
Library  DateTime

*** Variables ***
${locator.tenderId}                  jquery=h3

*** Keywords ***
Підготувати дані для оголошення тендера
  ${INITIAL_TENDER_DATA}=  prepare_test_tender_data
  [return]   ${INITIAL_TENDER_DATA}

Підготувати клієнт для користувача
  [Arguments]  @{ARGUMENTS}
  [Documentation]  Відкрити брaвзер, створити обєкт api wrapper, тощо
  ...      ${ARGUMENTS[0]} ==  username
  Open Browser   ${BROKERS['${USERS.users['${username}'].broker}'].url}   ${USERS.users['${username}'].browser}   alias=${ARGUMENTS[0]}
  Set Window Size   @{USERS.users['${ARGUMENTS[0]}'].size}
  Set Window Position   @{USERS.users['${ARGUMENTS[0]}'].position}

#  sleep   10
  Run Keyword If   '${username}' != 'Newtend_Viewer'   Login

Login
  Wait Until Page Contains Element   id=indexpage_login   20
  Click Element   id=indexpage_login
  Wait Until Page Contains Element   id=password   20
  Input text   id=login-email   ${USERS.users['${username}'].login}
  Input text   id=password   ${USERS.users['${username}'].password}
  Click Element   id=submit-login-button
  Wait Until Page Contains Element   xpath =//a[@class="close-modal-dialog"]  20
  Go to   ${USERS.users['${ARGUMENTS[0]}'].homepage}
#  Wait Until Page Contains Element   xpath=//div[@class="introjs-overlay"]   20

Створити тендер
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  initial_tender_data
## Inicialisation
  ${prepared_tender_data}=   Add_data_for_GUI_FrontEnds   ${ARGUMENTS[1]}
  ${items}=         Get From Dictionary   ${prepared_tender_data.data}               items
  ${title}=         Get From Dictionary   ${prepared_tender_data.data}               title
  ${description}=   Get From Dictionary   ${prepared_tender_data.data}               description
  ${budget}=        Get From Dictionary   ${prepared_tender_data.data.value}         amount
  ${step_rate}=     Get From Dictionary   ${prepared_tender_data.data.minimalStep}   amount
  ${start_date}=           Get From Dictionary   ${prepared_tender_data.data.tenderPeriod}    startDate
  ${end_date}=             Get From Dictionary   ${prepared_tender_data.data.tenderPeriod}    endDate
  ${enquiry_start_date}=   Get From Dictionary   ${prepared_tender_data.data.enquiryPeriod}   startDate
  ${enquiry_end_date}=     Get From Dictionary   ${prepared_tender_data.data.enquiryPeriod}   endDate

  Selenium2Library.Switch Browser    ${ARGUMENTS[0]}
  Go To                              ${USERS.users['${username}'].homepage}
  Wait Until Page Contains Element   xpath=//a[@href="#/create-tender"]   100
  Click Link                         xpath=//a[@href="#/create-tender"]
  Wait Until Page Contains           Новый тендер   100
# Input fields tender
  Input text   name=tenderName       ${title}
  Input text   name=tenderDescription   ${description}
  Input text   id=budget             ${budget}
  Click Element                      id=with-nds
  Input text   id=step               ${step_rate}
# Add Item(s)
  Додати придмет   ${items[0]}   0
  Run Keyword If   '${mode}' == 'multi'     Додати багато придметів   items
# Set tender datatimes
  Set datetime   start-date-registration    ${start_date}
  Set datetime   end-date-registration      ${end_date}
  Set datetime   end-date-qualification     ${enquiry_end_date}
  Set datetime   start-date-qualification   ${enquiry_start_date}
# Save
  Click Element                      xpath=//button[@class="btn btn-lg btn-default cancel pull-right ng-binding"]
  Wait Until Page Contains Element   xpath=//div[@ng-click="goHome()"]   30
  Click Element                      xpath=//div[@ng-click="goHome()"]
# Get Ids
  Wait Until Page Contains Element   xpath=//div[@class="title"]   30
  ${tender_UAid}=         Get Text   xpath=//div[@class="title"]
  ${Ids}=        Convert To String   ${tender_UAid}
  Run keyword if   '${mode}' == 'multi'   Set Multi Ids   ${tender_UAid}
  [return]  ${Ids}

Set Multi Ids
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  ${tender_UAid}
  ${current_location}=      Get Location
  ${id}=    Get Substring   ${current_location}   -41   -9
  ${Ids}=   Create List     ${tender_UAid}   ${id}

Set datetime
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  control_id
  ...      ${ARGUMENTS[1]} ==  date
#Pick Date
  Click Element       xpath=//input[@id="${ARGUMENTS[0]}"]/../span[@class="calendar-btn"]
  Wait Until Page Contains Element            xpath=//td[@class="text-center ng-scope"]   30
  ${datapicker_id}=   Get Element Attribute   xpath=//input[@id="${ARGUMENTS[0]}"]/..//td[@class="text-center ng-scope"]@id
  ${datapicker_id}=   Get Substring           ${datapicker_id}   0   -1
  ${date_index}=      newtend_date_picker_index   ${ARGUMENTS[1]}
  ${datapicker_id}=   Convert To String       ${datapicker_id}${date_index}
  Click Element       xpath=//input[@id="${ARGUMENTS[0]}"]/..//td[@id="${datapicker_id}"]/button
#Set time
  ${hous}=   Get Substring   ${ARGUMENTS[1]}   11   13
  ${minutes}=   Get Substring   ${ARGUMENTS[1]}   14   16
  Input text   xpath=//input[@id="${ARGUMENTS[0]}"]/../..//input[@ng-model="hours"]   ${hous}
  Input text   xpath=//input[@id="${ARGUMENTS[0]}"]/../..//input[@ng-model="minutes"]   ${minutes}

Додати придмет
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  items_n
  ...      ${ARGUMENTS[1]} ==  index
## Get values for item
  ${items_description}=   Get From Dictionary   ${ARGUMENTS[0]}                          description
  ${quantity}=      Get From Dictionary   ${ARGUMENTS[0]}                                quantity
  ${cpv}=           Convert To String     Картонки
  ${dkpp_desc}=     Get From Dictionary   ${ARGUMENTS[0].additionalClassifications[0]}   description
  ${dkpp_id}=       Get From Dictionary   ${ARGUMENTS[0].additionalClassifications[0]}   id
  ${unit}=          Get From Dictionary   ${ARGUMENTS[0].unit}                           name
  ${deliverydate_end_date}=   Get From Dictionary   ${ARGUMENTS[0].deliveryDate}   endDate
  ${countryName}=     Get From Dictionary   ${ARGUMENTS[0].deliveryAddress}   countryName
  ${ZIP}=             Get From Dictionary   ${ARGUMENTS[0].deliveryAddress}   postalCode
  ${region}=          Get From Dictionary   ${ARGUMENTS[0].deliveryAddress}   region
  ${locality}=        Get From Dictionary   ${ARGUMENTS[0].deliveryAddress}   locality
  ${streetAddress}=   Get From Dictionary   ${ARGUMENTS[0].deliveryAddress}   streetAddress
# Add item
  Input text   id=itemDescription${ARGUMENTS[1]}   ${items_description}
  Input text   id=quantity${ARGUMENTS[1]}          ${quantity}
  Click Element                      xpath=//a[contains(text(), "единицы измерения")]
  Click Element                      xpath=//a[contains(text(), "единицы измерения")]/..//a[contains(text(), '${unit}')]
# Set CPV
  Click Element                      id=classifier1${ARGUMENTS[1]}
  Wait Until Page Contains Element   xpath=//input[@class="ng-pristine ng-untouched ng-valid"]   100
  Input text                         xpath=//input[@class="ng-pristine ng-untouched ng-valid"]   ${cpv}
  Wait Until Page Contains Element   xpath=//span[contains(text(),'${cpv}')]   20
  Click Element                      xpath=//input[@class="ng-pristine ng-untouched ng-valid"]
  Click Element                      xpath=//button[@class="btn btn-default btn-lg pull-right choose ng-binding"]
# Set ДКПП
  Click Element                      id=classifier2${ARGUMENTS[1]}
  Wait Until Page Contains Element   xpath=//input[@class="ng-pristine ng-untouched ng-valid"]   100
  Input text                         xpath=//input[@class="ng-pristine ng-untouched ng-valid"]   ${dkpp_desc}
  Wait Until Page Contains Element   xpath=//span[contains(text(),'${dkpp_id}')]   100
  Click Element                      xpath=//span[contains(text(),'${dkpp_id}')]/../..//input[@class="ng-pristine ng-untouched ng-valid"]
  Click Element                      xpath=//button[@class="btn btn-default btn-lg pull-right choose ng-binding"]
# Set Delivery Address
  Click Element                      id=deliveryAddress${ARGUMENTS[1]}
  Wait Until Page Contains Element   xpath=//input[1][@class="form-control ng-pristine ng-untouched ng-valid"]   100
  Input text                         xpath=//input[1][@class="form-control ng-pristine ng-untouched ng-valid"]   ${countryName}
  Input text                         xpath=//input[1][@class="form-control ng-pristine ng-untouched ng-valid"]   ${ZIP}
  Input text                         xpath=//input[1][@class="form-control ng-pristine ng-untouched ng-valid"]   ${region}
  Input text                         xpath=//input[1][@class="form-control ng-pristine ng-untouched ng-valid"]   ${locality}
  Input text                         xpath=//input[1][@class="form-control ng-pristine ng-untouched ng-valid"]   ${streetAddress}
  Click Element                      xpath=//button[@class="btn btn-lg single-btn ng-binding"]
# Set Item Datetime
  Set datetime   end-date-delivery${ARGUMENTS[1]}         ${deliverydate_end_date}

Додати багато придметів
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  items
  ${Items_length}=   Get Length   ${items}
  : FOR    ${INDEX}    IN RANGE    1    ${Items_length}
  \   Click Element   xpath=//a[@class="icon-black plus-black remove-field ng-scope"]
  \   Додати придмет   ${items[${INDEX}]}   ${INDEX}

Пошук тендера по ідентифікатору
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  ${TENDER_UAID}
  Switch browser   ${ARGUMENTS[0]}
  Go to   ${USERS.users['${ARGUMENTS[0]}'].homepage}
  Wait Until Page Contains Element   xpath=//div[@class="search-field"]/input   20
#  ${ARGUMENTS[1]}=   Convert To String   UA-2015-06-08-000023
  Input text                         xpath=//div[@class="search-field"]/input   ${ARGUMENTS[1]}
  : FOR    ${INDEX}    IN RANGE    1    30
  \   Log To Console   .   no_newline=true
#  \   sleep       1
  \   ${count}=   Get Matching Xpath Count   xpath=//a[@class="row tender-info ng-scope"]
  \   Exit For Loop If  '${count}' == '1'
  Click Element                      xpath=//a[@class="row tender-info ng-scope"]
  Wait Until Page Contains Element   xpath=//a[@class="ng-binding ng-scope"]   30
  ${fould_title}=         Get Text   xpath=//a[@class="ng-binding ng-scope"]
  Should Be Equal   ${fould_title}   ${ARGUMENTS[1]}