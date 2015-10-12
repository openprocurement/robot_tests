*** Setting ***
Library  Selenium2Screenshots
Library  String
Library  DateTime

*** Variables ***
${locator.tenderId}                  xpath=//td[./text()='TenderID']/following-sibling::td[1]
${locator.title}                     xpath=//td[./text()='Загальна назва закупівлі']/following-sibling::td[1]
${locator.description}               xpath=//td[./text()='Предмет закупівлі']/following-sibling::td[1]
${locator.value.amount}              xpath=//td[./text()='Максимальний бюджет']/following-sibling::td[1]
${locator.minimalStep.amount}        xpath=//td[./text()='Мінімальний крок зменшення ціни']/following-sibling::td[1]
${locator.enquiryPeriod.endDate}     xpath=//td[./text()='Завершення періоду обговорення']/following-sibling::td[1]
${locator.tenderPeriod.endDate}      xpath=//td[./text()='Завершення періоду прийому пропозицій']/following-sibling::td[1]
${locator.items[0].deliveryAddress.countryName}    xpath=//td[@class='nameField'][./text()='Адреса поставки']/following-sibling::td[1]
${locator.items[0].deliveryDate.endDate}     xpath=//td[./text()='Кінцева дата поставки']/following-sibling::td[1]
${locator.items[0].classification.scheme}    xpath=//td[@class = 'nameField'][./text()='Клас CPV']
${locator.items[0].classification.id}        xpath=//td[./text()='Клас CPV']/following-sibling::td[1]/span[1]
${locator.items[0].classification.description}       xpath=//td[./text()='Клас CPV']/following-sibling::td[1]/span[2]
${locator.items[0].additionalClassifications[0].scheme}   xpath=//td[@class = 'nameField'][./text()='Клас ДКПП']
${locator.items[0].additionalClassifications[0].id}       xpath=//td[./text()='Клас ДКПП']/following-sibling::td[1]/span[1]
${locator.items[0].additionalClassifications[0].description}       xpath=//td[./text()='Клас ДКПП']/following-sibling::td[1]/span[2]
${locator.items[0].quantity}         xpath=//td[./text()='Кількість']/following-sibling::td[1]/span[1]
${locator.items[0].unit.code}        xpath=//td[./text()='Кількість']/following-sibling::td[1]/span[2]
${locator.questions[0].title}        xpath=//div[@class = 'question relative']//div[@class = 'title']
${locator.questions[0].description}  xpath = //div[@class='text']
${locator.questions[0].date}         xpath = //div[@class='date']
${locator.questions[0].answer}       xpath=//div[@class = 'answer relative']//div[@class = 'text']

*** Keywords ***
Підготувати клієнт для користувача
  [Arguments]  @{ARGUMENTS}
  [Documentation]  Відкрити брaузер, створити обєкт api wrapper, тощо
  ...      ${ARGUMENTS[0]} ==  username
  Open Browser   ${BROKERS['${USERS.users['${ARGUMENTS[0]}'].broker}'].url}   ${USERS.users['${ARGUMENTS[0]}'].browser}   alias=${ARGUMENTS[0]}
  Set Window Size       @{USERS.users['${ARGUMENTS[0]}'].size}
  Set Window Position   @{USERS.users['${ARGUMENTS[0]}'].position}
  Run Keyword If   '${username}' != 'Ua_Viewer'   Login

Login
  [Arguments]  @{ARGUMENTS}
  Wait Until Page Contains Element   name=email   10
  Sleep  1
  Input text                         name=email      ${USERS.users['${username}'].login}
  Sleep  2
  Input text                         name=password   ${USERS.users['${username}'].password}
  Wait Until Page Contains Element   xpath=//button[contains(@class, 'btn btn-danger')]
  Click Element                      xpath=//button[contains(@class, 'btn btn-danger')]


Створити тендер
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tender_data
  ${prepared_tender_data}=   Add_data_for_GUI_FrontEnds   ${ARGUMENTS[1]}
  ${items}=         Get From Dictionary   ${ARGUMENTS[1].data}               items
  ${title}=         Get From Dictionary   ${ARGUMENTS[1].data}               title
  ${description}=   Get From Dictionary   ${ARGUMENTS[1].data}               description
  ${budget}=        Get From Dictionary   ${ARGUMENTS[1].data.value}         amount
  ${step_rate}=     Get From Dictionary   ${ARGUMENTS[1].data.minimalStep}   amount
  ${items_description}=   Get From Dictionary   ${ARGUMENTS[1].data}         description
  ${quantity}=      Get From Dictionary   ${items[0]}         quantity
  ${countryName}=   Get From Dictionary   ${ARGUMENTS[1].data.procuringEntity.address}       countryName
  ${delivery_end_date}=      Get From Dictionary   ${items[0].deliveryDate}   endDate
  ${delivery_end_date}=      convert_date_to_slash_format_with_time   ${delivery_end_date}
  ${cpv}=           Convert To String     Картонки
  ${cpv_id}=        Get From Dictionary   ${items[0].classification}         id
  ${cpv_id1}=       Replace String        ${cpv_id}   _    -
  ${dkpp_desc}=     Get From Dictionary   ${items[0].additionalClassifications[0]}   description
  ${dkpp_id}=       Get From Dictionary   ${items[0].additionalClassifications[0]}   id
  ${dkpp_id1}=      Replace String        ${dkpp_id}   -   _
  ${enquiry_start_date}=   Get From Dictionary         ${prepared_tender_data.data.enquiryPeriod}   startDate
  ${enquiry_start_date}=   convert_date_to_slash_format_with_time   ${enquiry_start_date}
  ${enquiry_end_date}=   Get From Dictionary         ${prepared_tender_data.data.enquiryPeriod}   endDate
  ${enquiry_end_date}=   convert_date_to_slash_format_with_time   ${enquiry_end_date}
  ${start_date}=      Get From Dictionary   ${prepared_tender_data.data.tenderPeriod}   startDate
  ${start_date}=      convert_date_to_slash_format_with_time   ${start_date}
  ${end_date}=      Get From Dictionary   ${prepared_tender_data.data.tenderPeriod}   endDate
  ${end_date}=      convert_date_to_slash_format_with_time   ${end_date}
  ${postalCode}     Get From Dictionary   ${items[0].deliveryAddress}     postalCode
  ${streetAddress}  Get From Dictionary   ${items[0].deliveryAddress}     streetAddress
  ${locality}  Get From Dictionary   ${items[0].deliveryAddress}     locality

  Selenium2Library.Switch Browser     ${ARGUMENTS[0]}
  Maximize Browser Window
  sleep  1
  Wait Until Page Contains Element    xpath=//a[@class='btn btn-info']    10
  Click Element                       xpath=//a[@class='btn btn-info']
  Wait Until Page Contains Element    name=title   10
  Input text                          name=title    ${title}
  Input text                          name=description    ${description}
  Input text                          name=amount   ${budget}
  Input text                          name=minimal_step  ${step_rate}
  Input text                          name=enquiry_start_date          ${enquiry_start_date}
  Input text                          name=enquiry_end_date            ${enquiry_end_date}
  Input text                          name=tender_start_date           ${start_date}
  Input text                          name=tender_end_date             ${end_date}
  Input text                          name=items[0][description]       ${items_description}
  Input text                          name=items[0][quantity]          ${quantity}
  Input text                          name=items[0][dkpp]              ${dkpp_desc}
  Sleep  1
  Click Element                       xpath=//ul[@id='ui-id-1']/li[2]
  Input text                          name=items[0][cpv]               ${cpv_id1}
  Sleep  1
  Click Element                       xpath=//ul[@id='ui-id-2']/li[1]
  sleep  2
  Input text                          name=items[0][delivery_date_start]    ${delivery_end_date}
  Input text                          name=items[0][delivery_date_end]      ${delivery_end_date}
  #Додати предмет    ${items[0]}       0
  Click Element                       id=origin-0
  Sleep  1
  Click Element     xpath=(//select[@class='form-control'])[4]//option[12]
  Input text                          name=items[0][postal_code]          ${postalCode}
  Input text                          name=items[0][locality]             ${locality}
  Input text                          name=items[0][delivery_address]     ${streetAddress}
  Click Element                       xpath=//input[@class='btn btn-lg btn-danger']
  Run Keyword if   '${mode}' == 'multi'   Додати багато предметів   items
  Wait Until Page Contains      ${title}
  Log   ${title}
  Capture Page Screenshot
#  ${tender_UAid}=   Get Text          xpath=//td[./text()='TenderID']/following-sibling::td[1]
#  ${Ids}=   Convert To String         ${tender_UAid}
#  Run keyword if   '${mode}' == 'multi'   Set Multi Ids   ${tender_UAid}
#  log  ${Ids}
#  [return]  ${Ids}

Set Multi Ids
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[1]} ==  ${tender_UAid}
  ${id}=    Get Text   xpath=//*/section[6]/table/tbody/tr[1]/td[2]
  ${Ids}=   Create List    ${tender_UAid}   ${id}

Додати предмет
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  items
  ...      ${ARGUMENTS[1]} ==  ${INDEX}
  ${dkpp_desc1}=     Get From Dictionary   ${ARGUMENTS[0].additionalClassifications[0]}   description

  Click Element                       xpath=//button[@class='btn btn-info pull-right add-item-section']
  ${index} =                          Convert To Integer     ${ARGUMENTS[1]}
  ${index} =                          Convert To Integer     ${index + 1}

  Wait Until Page Contains Element    name=items[${index}][description]   30
  Input text                          name=items[${index}][description]    ${description}
  Input text                          name=items[${index}][quantity]       ${quantity}

  Input text                          name=items[${index}][dkpp]              ${dkpp_desc1}
  Input text                          name=items[${index}][cpv]               ${cpv}

  Input text                          name=items[${index}][delivery_date_start]    ${delivery_end_date}
  Input text                          name=items[${index}][delivery_date_end]    ${delivery_end_date}
  Capture Page Screenshot

Завантажити документ
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...    ${ARGUMENTS[0]} =  username
  ...    ${ARGUMENTS[1]} =  ${file_path}
  ...    ${ARGUMENTS[2]} =  ${TENDER_UAID}
  ${filepath}=   local_path_to_file   TestDocument.docx
  Click Element                      xpath=(//a[@class='btn btn-xs btn-info']/span)[1]
  Choose File                        xpath=//label[./text()='Добавить файл']        ${filepath}
  Capture Page Screenshot

Внести зміни в тендер
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} =  username
  ...      ${ARGUMENTS[1]} =  ${TENDER_UAID}
  ...      ${ARGUMENTS[2]} =  tender_data
  ${ADDITIONAL_DATA}=  prepare_test_tender_data   ${BROKERS['${USERS.users['${tender_owner}'].broker}'].period_interval}   single
  ${tender_data}=   Add_data_for_GUI_FrontEnds   ${ADDITIONAL_DATA}
  ${items}=         Get From Dictionary   ${tender_data.data}               items
  ${items_description}=   Get From Dictionary   ${items[0]}         description
  Selenium2Library.Switch Browser    ${ARGUMENTS[0]}
  Click Element                      xpath=(//a[@class='btn btn-xs btn-info']/span)[1]
  Sleep  1
  Input text                         name=description    ${items_description}
  Capture Page Screenshot