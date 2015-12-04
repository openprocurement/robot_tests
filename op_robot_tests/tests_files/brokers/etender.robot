*** Setting ***
Library  Selenium2Screenshots
Library  String
Library  DateTime

*** Variables ***
${locator.tenderId}                                            jquery=h3
${locator.title}                                               jquery=tender-subject-info>div.row:contains("Назва закупівлі:")>:eq(1)>
${locator.description}                                         jquery=tender-subject-info>div.row:contains("Детальний опис закупівлі:")>:eq(1)>
${locator.minimalStep.amount}                                  xpath=(//div[@class = 'col-sm-8']/p[@class='ng-binding'])[9]
${locator.procuringEntity.name}                                jquery=customer-info>div.row:contains("Найменування:")>:eq(1)>
${locator.value.amount}                                        xpath=(//div[@class = 'col-sm-8']/p[@class='ng-binding'])[8]
${locator.tenderPeriod.startDate}                              xpath=(//div[@class = 'col-sm-8']/p[@class='ng-binding'])[3]
${locator.tenderPeriod.endDate}                                xpath=(//div[@class = 'col-sm-8']/p[@class='ng-binding'])[4]
${locator.enquiryPeriod.startDate}                             xpath=(//div[@class = 'col-sm-8']/p[@class='ng-binding'])[1]
${locator.enquiryPeriod.endDate}                               xpath=(//div[@class = 'col-sm-8']/p[@class='ng-binding'])[2]
${locator.items[0].description}                                xpath=(//div[@class = 'col-sm-8']/p[@class='ng-binding'])[12]
${locator.items[0].deliveryDate.endDate}                       xpath=(//div[@class = 'col-sm-8']/p[@class='ng-binding'])[14]
${locator.items[0].deliveryLocation.latitude}                  xpath=(//div[@class = 'col-sm-8']/p[@class='ng-binding'])[15]
${locator.items[0].deliveryLocation.longitude}                 xpath=(//div[@class = 'col-sm-8']/p[@class='ng-binding'])[15]
${locator.items[0].deliveryAddress.postalCode}                 xpath=//div[@class='col-sm-8']//span[@ng-if='item.deliveryAddress.postIndex']
${locator.items[0].deliveryAddress.countryName}                xpath=//div[@class='col-sm-8']//span[@ng-if='item.deliveryAddress.country.title']
${locator.items[0].deliveryAddress.region}                     xpath=//div[@class='col-sm-8']//span[@ng-if='item.deliveryAddress.region.title']
${locator.items[0].deliveryAddress.locality}                   xpath=//div[@class='col-sm-8']//span[@ng-if='item.deliveryAddress.city.title']
${locator.items[0].deliveryAddress.streetAddress}              xpath=//div[@class='col-sm-8']//span[@ng-if='item.deliveryAddress.addressStr']
${locator.items[0].classification.scheme}                      xpath=(//div[@class = 'col-sm-4']/p)[11]
${locator.items[0].classification.id}                          xpath=(//div[@class = 'col-sm-8']/p[@class='ng-binding'])[10]
${locator.items[0].classification.description}                 xpath=(//div[@class = 'col-sm-8']/p[@class='ng-binding'])[10]
${locator.items[0].additionalClassifications[0].scheme}        xpath=(//div[@class = 'col-sm-4']/p)[12]
${locator.items[0].additionalClassifications[0].id}            xpath=(//div[@class = 'col-sm-8']/p[@class='ng-binding'])[11]
${locator.items[0].additionalClassifications[0].description}   xpath=(//div[@class = 'col-sm-8']/p[@class='ng-binding'])[11]
${locator.items[0].unit.code}                                  xpath=(//div[@class = 'col-sm-8']/p[@class='ng-binding'])[13]
${locator.items[0].quantity}                                   xpath=(//div[@class = 'col-sm-8']/p[@class='ng-binding'])[13]
${locator.questions[0].title}                                  xpath=(//div[@class='col-sm-10']/span[@class='ng-binding'])[2]
${locator.questions[0].description}                            xpath=(//div[@class='col-sm-10']/span[@class='ng-binding'])[3]
${locator.questions[0].date}                                   xpath=(//div[@class='col-sm-10']/span[@class='ng-binding'])[1]
${locator.questions[0].answer}                                 xpath=(//div[@textarea='question.answer']/pre[@class='ng-binding'])[1]

*** Keywords ***
Підготувати дані для оголошення тендера
  ${INITIAL_TENDER_DATA}=  prepare_test_tender_data
  ${INITIAL_TENDER_DATA}=  Add_data_for_GUI_FrontEnds  ${INITIAL_TENDER_DATA}
  [return]   ${INITIAL_TENDER_DATA}

Підготувати клієнт для користувача
  [Arguments]  @{ARGUMENTS}
  [Documentation]  Відкрити брaвзер, створити обєкт api wrapper, тощо
  ...      ${ARGUMENTS[0]} ==  username
  Open Browser   ${USERS.users['${ARGUMENTS[0]}'].homepage}   ${USERS.users['${username}'].browser}   alias=${ARGUMENTS[0]}
  Set Window Size   @{USERS.users['${ARGUMENTS[0]}'].size}
  Set Window Position   @{USERS.users['${ARGUMENTS[0]}'].position}
  Run Keyword If   '${ARGUMENTS[0]}' != 'E-tender_Viewer'   Login

Login
  Wait Until Page Contains Element   id=inputUsername   10
  Input text   id=inputUsername      ${USERS.users['${username}'].login}
  Wait Until Page Contains Element   id=inputPassword   10
  Input text   id=inputPassword      ${USERS.users['${username}'].password}
  Click Button   id=btn_submit

Створити тендер
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tender_data
  ${INITIAL_TENDER_DATA}=  procuringEntity_name   ${INITIAL_TENDER_DATA}
  ${tender_data}=   Add_data_for_GUI_FrontEnds   ${ARGUMENTS[1]}
  ${items}=         Get From Dictionary   ${tender_data.data}               items
  ${title}=         Get From Dictionary   ${tender_data.data}               title
  ${description}=   Get From Dictionary   ${tender_data.data}               description
  ${budget}=        Get From Dictionary   ${tender_data.data.value}         amount
  ${step_rate}=     Get From Dictionary   ${tender_data.data.minimalStep}   amount
  ${items_description}=   Get From Dictionary   ${items[0]}         description
  ${quantity}=      Get From Dictionary   ${items[0]}                        quantity
  ${cpv}=           Get From Dictionary   ${items[0].classification}         id
  ${unit}=          Get From Dictionary   ${items[0].unit}                   name
  ${latitude}       Get From Dictionary   ${items[0].deliveryLocation}    latitude
  ${longitude}      Get From Dictionary   ${items[0].deliveryLocation}    longitude
  ${postalCode}    Get From Dictionary   ${items[0].deliveryAddress}     postalCode
  ${streetAddress}    Get From Dictionary   ${items[0].deliveryAddress}     streetAddress
  ${deliveryDate}   Get From Dictionary   ${items[0].deliveryDate}        endDate
  ${deliveryDate}   convert_date_to_etender_format        ${deliveryDate}
  ${start_date}=    Get From Dictionary   ${tender_data.data.tenderPeriod}   startDate
  ${start_date}=    convert_date_to_etender_format   ${start_date}
  ${start_time}=    Get From Dictionary   ${tender_data.data.tenderPeriod}   startDate
  ${start_time}=    convert_time_to_etender_format   ${start_time}
  ${end_date}=      Get From Dictionary   ${tender_data.data.tenderPeriod}   endDate
  ${end_date}=      convert_date_to_etender_format   ${end_date}
  ${end_time}=      Get From Dictionary   ${tender_data.data.tenderPeriod}   endDate
  ${end_time}=   convert_time_to_etender_format      ${end_time}
  ${enquiry_end_date}=   Get From Dictionary         ${tender_data.data.enquiryPeriod}   endDate
  ${enquiry_end_date}=   convert_date_to_etender_format   ${enquiry_end_date}
  ${enquiry_end_time}=   Get From Dictionary              ${tender_data.data.enquiryPeriod}   endDate
  ${enquiry_end_time}=   convert_time_to_etender_format   ${enquiry_end_time}

  Selenium2Library.Switch Browser    ${ARGUMENTS[0]}
  Wait Until Page Contains          Мої закупівлі   10
  Sleep  1
  Click Element                     xpath=//a[contains(@class, 'ng-binding')][./text()='Мої закупівлі']
  Wait Until Page Contains Element  xpath=//a[contains(@class, 'btn btn-info')]
  Sleep  1
  Click Element                     xpath=//a[contains(@class, 'btn btn-info')]
  Wait Until Page Contains Element  id=title
  Input text    id=title                  ${title}
  Input text    id=description            ${description}
  Input text    id=value                  ${budget}
  Click Element                     xpath=//div[contains(@class, 'form-group col-sm-6')]//input[@type='checkbox']
  Input text    id=minimalStep            ${step_rate}
  Input text    id=itemsDescription       ${items_description}
  Input text    id=itemsQuantity          ${quantity}
  Input text    name=delStartDate         ${deliveryDate}
  Sleep  2
  Input text    xpath=//input[@ng-model='data.items[0].deliveryDate.endDate']         ${deliveryDate}
  Input text    name=latitude             ${latitude}
  Input text    name=longitude            ${longitude}
  Click Element   xpath=//select[@name='region']//option[@label='Київська']
  Sleep  2
  Click Element   xpath=//select[@name='city']//option[@label='Київ']
  Input text    name=addressStr   ${streetAddress}
  Input text    name=postIndex    ${postalCode}
  Wait Until Page Contains Element    xpath=//select[@name="itemsUnit"]/option[@value='kilogram']
  Click Element  xpath=//select[@name="itemsUnit"]/option[@value='kilogram']
  Input text    xpath=//div[contains(@class, 'form-group col-sm-8')]//input[@name='enqPEndDate']   ${enquiry_end_date}
  Input text    xpath=//div[contains(@class, 'form-group col-sm-8')]//div[contains(@class, 'col-sm-2')]//input[@ng-model='data.enquiryPeriod.endDate']   ${enquiry_end_time}
  Input text    xpath=//div[contains(@class, 'form-group col-sm-8')]//input[@name='startDate']   ${start_date}
  Input text    xpath=//div[contains(@class, 'form-group col-sm-8')]//div[contains(@class, 'col-sm-2')]//input[@ng-model='data.tenderPeriod.startDate']   ${start_time}
  Input text    xpath=//div[contains(@class, 'form-group col-sm-8')]//input[@name='endDate']   ${end_date}
  Input text    xpath=//div[contains(@class, 'form-group col-sm-8')]//div[contains(@class, 'col-sm-2')]//input[@ng-model='data.tenderPeriod.endDate']   ${end_time}
  Sleep  2
  Click Element   xpath=//div[contains(@class, 'col-sm-2')]//input[@data-target='#classification']
  Sleep  1
  Input text      xpath=//div[contains(@class, 'modal-content')]//input[@ng-model='searchstring']   ${cpv}
  Sleep  2
  Wait Until Page Contains    ${cpv}
  Click Element   xpath=//td[contains(., '${cpv}')]
  Sleep  1
  Click Element   xpath=//div[contains(@class, 'modal-content')]//button[@ng-click='choose()']
  Sleep  1
  Додати предмет   ${items[0]}   0
  Run Keyword if   '${mode}' == 'multi'   Додати багато предметів   items
  Sleep  1
  Wait Until Page Contains Element   xpath=//div[contains(@class, 'form-actions')]//button[@type='submit']
  Click Element   xpath=//div[contains(@class, 'form-actions')]//button[@type='submit']
  Sleep  1
  Wait Until Page Contains    [ТЕСТУВАННЯ]   10
  Sleep   20
  Click Element   xpath=//*[text()='${title}']
  Sleep   5
  ${tender_UAid}=  Get Text  xpath=//div[contains(@class, "panel-heading")]
  ${tender_UAid}=  Get Substring  ${tender_UAid}   10
  ${Ids}=   Convert To String   ${tender_UAid}
  Run keyword if   '${mode}' == 'multi'   Set Multi Ids   ${ARGUMENTS[0]}   ${tender_UAid}
  [return]  ${Ids}

Set Multi Ids
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  ${tender_UAid}
  ${current_location}=      Get Location
  ${id}=    Get Substring   ${current_location}   10
  ${Ids}=   Create List     ${tender_UAid}   ${id}

Додати предмет
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  items
  ...      ${ARGUMENTS[1]} ==  ${INDEX}
  ${dkpp_desc}=     Get From Dictionary   ${ARGUMENTS[0].additionalClassifications[0]}   description
  ${dkpp_id}=       Get From Dictionary   ${ARGUMENTS[0].additionalClassifications[0]}   id
  Sleep  2
  Click Element                      xpath=(//div[contains(@class, 'col-sm-2')]//input[@data-target='#addClassification'])[${ARGUMENTS[1]}+1]
  Wait Until Element Is Visible      xpath=//div[contains(@id,'addClassification')]
  Sleep  2
  Input text                         xpath=//div[contains(@class, 'modal fade ng-scope in')]//input[@ng-model='searchstring']    ${dkpp_desc}
  Wait Until Page Contains   ${dkpp_id}
  Sleep  1
  Click Element   xpath=//td[contains(., '${dkpp_id}')]
  Click Element                      xpath=//div[contains(@class, 'modal fade ng-scope in')]//button[@ng-click='choose()']
  Sleep  2

Додати багато предметів
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  items
  ${Items_length}=   Get Length   ${items}
  : FOR    ${INDEX}    IN RANGE    1    ${Items_length}
  \   Click Element   xpath=.//*[@id='myform']/tender-form/div/button
  \   Додати предмет   ${items[${INDEX}]}   ${INDEX}

Клацнути і дочекатися
  [Arguments]  ${click_locator}  ${wanted_locator}  ${timeout}
  Click Link  ${click_locator}
  Wait Until Page Contains Element  ${wanted_locator}  ${timeout}

Шукати і знайти
  Клацнути і дочекатися  jquery=a[ng-click='search()']  jquery=a[href^="#/tenderDetailes"]  5

Пошук тендера по ідентифікатору
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  ${TENDER_UAID}
  Switch browser   ${ARGUMENTS[0]}
  ${url}=  Get Broker Property By Username  ${ARGUMENTS[0]}  url
  Go To  ${url}
  Wait Until Page Contains   Прозорі закупівлі    10
  sleep  1
  Input Text  jquery=input[ng-change='searchChange()']  ${ARGUMENTS[1]}
  sleep  1
  ${timeout_on_wait}=  Get Broker Property By Username  ${ARGUMENTS[0]}  timeout_on_wait
  ${passed}=  Run Keyword And Return Status  Wait Until Keyword Succeeds  ${timeout_on_wait} s  0 s  Шукати і знайти
  Run Keyword Unless  ${passed}  Fatal Error  Тендер не знайдено за ${timeout_on_wait} секунд
  sleep  3
  Click Link    jquery=a[href^="#/tenderDetailes"]
  Wait Until Page Contains    ${ARGUMENTS[1]}   10
  sleep  1
  Capture Page Screenshot

Завантажити документ
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  ${TENDER_UAID}
  ...      ${ARGUMENTS[2]} ==  ${Complain}
  Fail   Тест не написаний

Подати скаргу
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  ${TENDER_UAID}
  ...      ${ARGUMENTS[2]} ==  ${Complain}
  Fail  Не реалізований функціонал

порівняти скаргу
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  ${file_path}
  ...      ${ARGUMENTS[2]} ==  ${TENDER_UAID}
  Fail  Не реалізований функціонал

Подати цінову пропозицію
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  ${TENDER_UAID}
  ...      ${ARGUMENTS[2]} ==  ${test_bid_data}
  ${bid}=        Get From Dictionary   ${ARGUMENTS[2].data.value}         amount
  etender.Пошук тендера по ідентифікатору   ${ARGUMENTS[0]}   ${ARGUMENTS[1]}
  Wait Until Page Contains          Інформація про процедуру закупівлі    10
  Wait Until Page Contains Element          id=amount   10
  Input text    id=amount                  ${bid}
  Click Element                     xpath=//button[contains(@class, 'btn btn-success')][./text()='Реєстрація пропозиції']
  DEBUG
  Click Element               xpath=//div[@class='row']/button[@class='btn btn-success']

скасувати цінову пропозицію
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  ${TENDER_UAID}
  etender.Пошук тендера по ідентифікатору   ${ARGUMENTS[0]}   ${ARGUMENTS[1]}
  Click Element               xpath=//button[@class='btn-sm btn-danger ng-isolate-scope']

Оновити сторінку з тендером
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} =  username
  ...      ${ARGUMENTS[1]} =  ${TENDER_UAID}
  Selenium2Library.Switch Browser    ${ARGUMENTS[0]}
  etender.Пошук тендера по ідентифікатору    ${ARGUMENTS[0]}   ${ARGUMENTS[1]}
  Reload Page

Задати питання
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} = username
  ...      ${ARGUMENTS[1]} = ${TENDER_UAID}
  ...      ${ARGUMENTS[2]} = question_data

  ${title}=        Get From Dictionary  ${ARGUMENTS[2].data}  title
  ${description}=  Get From Dictionary  ${ARGUMENTS[2].data}  description

  Selenium2Library.Switch Browser    ${ARGUMENTS[0]}
  etender.Пошук тендера по ідентифікатору   ${ARGUMENTS[0]}   ${ARGUMENTS[1]}
  Wait Until Page Contains Element   jquery=a[href^="#/addQuestion/"]   10
  Click Element                      jquery=a[href^="#/addQuestion/"]
  Wait Until Page Contains Element   id=title
  Input text                         id=title                 ${title}
  Input text                         id=description           ${description}
  Click Element                      xpath=//div[contains(@class, 'form-actions')]//button[@type='submit']

Відповісти на питання
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} = username
  ...      ${ARGUMENTS[1]} = ${TENDER_UAID}
  ...      ${ARGUMENTS[2]} = 0
  ...      ${ARGUMENTS[3]} = answer_data

  ${answer}=     Get From Dictionary  ${ARGUMENTS[3].data}  answer

  Selenium2Library.Switch Browser    ${ARGUMENTS[0]}
  etender.Пошук тендера по ідентифікатору   ${ARGUMENTS[0]}   ${ARGUMENTS[1]}
  Wait Until Page Contains Element   xpath=//pre[@class='ng-binding'][text()='Додати відповідь']   10
  Click Element                      xpath=//pre[@class='ng-binding'][text()='Додати відповідь']
  Input text                         xpath=//div[@class='editable-controls form-group']//textarea            ${answer}
  Click Element                      xpath=//span[@class='editable-buttons']/button[@type='submit']

Внести зміни в тендер
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} =  username
  ...      ${ARGUMENTS[1]} =  ${TENDER_UAID}
  ${period_interval}=  Get Broker Property By Username  ${ARGUMENTS[0]}  period_interval
  ${ADDITIONAL_DATA}=  prepare_test_tender_data  ${period_interval}  single
  ${tender_data}=   Add_data_for_GUI_FrontEnds   ${ADDITIONAL_DATA}
  ${items}=         Get From Dictionary   ${tender_data.data}               items
  ${description}=   Get From Dictionary   ${tender_data.data}               description
  Selenium2Library.Switch Browser    ${ARGUMENTS[0]}
  etender.Пошук тендера по ідентифікатору   ${ARGUMENTS[0]}   ${ARGUMENTS[1]}
  Wait Until Page Contains Element   xpath=//a[@class='btn btn-primary ng-scope']   10
  Click Element              xpath=//a[@class='btn btn-primary ng-scope']
  Sleep  2
  Input text               id=description    ${description}
  Click Element              xpath=//button[@class='btn btn-info ng-isolate-scope']
  Capture Page Screenshot

додати предмети закупівлі
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} =  username
  ...      ${ARGUMENTS[1]} =  ${TENDER_UAID}
  ...      ${ARGUMENTS[2]} =  3
  ${period_interval}=  Get Broker Property By Username  ${ARGUMENTS[0]}  period_interval
  ${ADDITIONAL_DATA}=  prepare_test_tender_data  ${period_interval}  multi
  ${tender_data}=   Add_data_for_GUI_FrontEnds   ${ADDITIONAL_DATA}
  ${items}=         Get From Dictionary   ${tender_data.data}               items
  Selenium2Library.Switch Browser    ${ARGUMENTS[0]}
  Run keyword if   '${TEST NAME}' == 'Можливість додати позицію закупівлі в тендер'   додати позицію
  Run keyword if   '${TEST NAME}' != 'Можливість додати позицію закупівлі в тендер'   видалити позиції

додати позицію
  etender.Пошук тендера по ідентифікатору   ${ARGUMENTS[0]}   ${ARGUMENTS[1]}
  Sleep  2
  Click Element                     xpath=//a[@class='btn btn-primary ng-scope']
  Sleep  2
  : FOR    ${INDEX}    IN RANGE    1    ${ARGUMENTS[2]} +1
  \   Click Element   xpath=.//*[@id='myform']/tender-form/div/button
  \   Додати предмет   ${items[${INDEX}]}   ${INDEX}
  Sleep  2
  Click Element   xpath=//div[@class='form-actions']/button[./text()='Зберегти зміни']
  Wait Until Page Contains    [ТЕСТУВАННЯ]   10

видалити позиції
  etender.Пошук тендера по ідентифікатору   ${ARGUMENTS[0]}   ${ARGUMENTS[1]}
  Click Element                     xpath=//a[@class='btn btn-primary ng-scope']
  Sleep  2
  : FOR    ${INDEX}    IN RANGE    1    ${ARGUMENTS[2]} +1
  \   Click Element   xpath=(//button[@class='btn btn-danger ng-scope'])[last()]
  \   Sleep  1
  Sleep  2
  Wait Until Page Contains Element   xpath=//div[@class='form-actions']/button[./text()='Зберегти зміни']   10
  Click Element   xpath=//div[@class='form-actions']/button[./text()='Зберегти зміни']
  Wait Until Page Contains    [ТЕСТУВАННЯ]   10

Отримати інформацію із тендера
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  fieldname
  Switch browser   ${ARGUMENTS[0]}
  Run Keyword And Return  Отримати інформацію про ${ARGUMENTS[1]}

Отримати текст із поля і показати на сторінці
  [Arguments]   ${fieldname}
  sleep  3
#  відмітити на сторінці поле з тендера   ${fieldname}   ${locator.${fieldname}}
  ${return_value}=   Get Text  ${locator.${fieldname}}
  [return]  ${return_value}

Отримати інформацію про title
  ${return_value}=   Отримати текст із поля і показати на сторінці   title
  [return]  ${return_value}

Отримати інформацію про description
  ${return_value}=   Отримати текст із поля і показати на сторінці   description
  [return]  ${return_value}

Отримати інформацію про minimalStep.amount
  ${return_value}=   Отримати текст із поля і показати на сторінці   minimalStep.amount
  ${return_value}=   Convert To Number   ${return_value.split(' ')[0]}
  [return]  ${return_value}

Отримати інформацію про value.amount
  ${return_value}=   Отримати текст із поля і показати на сторінці  value.amount
  ${return_value}=   Evaluate   "".join("${return_value}".split(' ')[:-3])
  ${return_value}=   Convert To Number   ${return_value}
  [return]  ${return_value}

Відмітити на сторінці поле з тендера
  [Arguments]   ${fieldname}  ${locator}
  ${last_note_id}=  Add pointy note   ${locator}   Found ${fieldname}   width=200  position=bottom
  Align elements horizontally    ${locator}   ${last_note_id}
  sleep  1
  Remove element   ${last_note_id}

Отримати інформацію про tenderId
  ${return_value}=   Отримати текст із поля і показати на сторінці   tenderId
  ${return_value}=   Get Substring  ${return_value}   10
  [return]  ${return_value}

Отримати інформацію про procuringEntity.name
  ${return_value}=   Отримати текст із поля і показати на сторінці   procuringEntity.name
  [return]  ${return_value}

Отримати інформацію про tenderPeriod.startDate
  ${return_value}=   Отримати текст із поля і показати на сторінці  tenderPeriod.startDate
  ${return_value}=   Change_date_to_month   ${return_value}
  [return]  ${return_value}

Отримати інформацію про tenderPeriod.endDate
  ${return_value}=   Отримати текст із поля і показати на сторінці  tenderPeriod.endDate
  ${return_value}=   Change_date_to_month   ${return_value}
  [return]  ${return_value}

Отримати інформацію про enquiryPeriod.startDate
  ${return_value}=   Отримати текст із поля і показати на сторінці  enquiryPeriod.startDate
  ${return_value}=   Change_date_to_month   ${return_value}
  [return]  ${return_value}

Отримати інформацію про enquiryPeriod.endDate
  ${return_value}=   Отримати текст із поля і показати на сторінці  enquiryPeriod.endDate
  ${return_value}=   Change_date_to_month   ${return_value}
  [return]  ${return_value}

Change_date_to_month
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]}  ==  date
  ${day}=   Get Substring   ${ARGUMENTS[0]}   0   2
  ${month}=   Get Substring   ${ARGUMENTS[0]}  3   6
  ${year}=   Get Substring   ${ARGUMENTS[0]}   5
  ${return_value}=   Convert To String  ${month}${day}${year}
  [return]  ${return_value}

Отримати інформацію про items[0].description
  ${return_value}=   Отримати текст із поля і показати на сторінці   items[0].description
  [return]  ${return_value}

Отримати інформацію про items[0].deliveryLocation.latitude
  ${return_value}=   Отримати текст із поля і показати на сторінці   items[0].deliveryLocation.latitude
  ${return_value}=   Get Substring  ${return_value}   0   10
  [return]  ${return_value}

Отримати інформацію про items[0].deliveryLocation.longitude
  ${return_value}=   Отримати текст із поля і показати на сторінці   items[0].deliveryLocation.longitude
  ${return_value}=   Get Substring  ${return_value}   12   22
  [return]  ${return_value}

Отримати інформацію про items[0].unit.code
  ${return_value}=   Отримати текст із поля і показати на сторінці   items[0].unit.code
  ${return_value}=   Get Substring  ${return_value}   5
  Run Keyword And Return If  '${return_value}' == 'кг.'   Convert To String  KGM
  [return]  ${return_value}

Отримати інформацію про items[0].quantity
  ${return_value}=   Отримати текст із поля і показати на сторінці   items[0].quantity
  ${return_value}=   Get Substring  ${return_value}   0   4
  ${return_value}=   Convert To Number   ${return_value}
  [return]  ${return_value}

Отримати інформацію про items[0].classification.id
  ${return_value}=   Отримати текст із поля і показати на сторінці  items[0].classification.id
  [return]  ${return_value.split(' ')[0]}

Отримати інформацію про items[0].classification.scheme
  ${return_value}=   Отримати текст із поля і показати на сторінці  items[0].classification.scheme
  ${return_value}=   Get Substring  ${return_value}   0   -1
  [return]  ${return_value.split(' ')[1]}

Отримати інформацію про items[0].classification.description
  ${return_value}=   Отримати текст із поля і показати на сторінці  items[0].classification.description
  ${return_value}=   Get Substring  ${return_value}   11
  Run Keyword And Return If  '${return_value}' == 'Картонки'   Convert To String  Cartons
  [return]  ${return_value}

Отримати інформацію про items[0].additionalClassifications[0].id
  ${return_value}=   Отримати текст із поля і показати на сторінці  items[0].additionalClassifications[0].id
  [return]  ${return_value.split(' ')[0]}

Отримати інформацію про items[0].additionalClassifications[0].scheme
  ${return_value}=   Отримати текст із поля і показати на сторінці  items[0].additionalClassifications[0].scheme
  ${return_value}=   Get Substring  ${return_value}   0   -1
  [return]  ${return_value.split(' ')[1]}

Отримати інформацію про items[0].additionalClassifications[0].description
  ${return_value}=   Отримати текст із поля і показати на сторінці  items[0].additionalClassifications[0].description
  ${return_value}=   Get Substring  ${return_value}   8   60
  ${return_value}=   Remove String   ${return_value}  "
  ${return_value}=   Convert To Lowercase   ${return_value}
  [return]  ${return_value}

Отримати інформацію про items[0].deliveryAddress.postalCode
  ${return_value}=   Отримати текст із поля і показати на сторінці  items[0].deliveryAddress.postalCode
  ${return_value}=   Get Substring  ${return_value}   0   5
  [return]  ${return_value}

Отримати інформацію про items[0].deliveryAddress.countryName
  ${return_value}=   Отримати текст із поля і показати на сторінці  items[0].deliveryAddress.countryName
  ${return_value}=   Get Substring  ${return_value}   0   7
  [return]  ${return_value}

Отримати інформацію про items[0].deliveryAddress.region
  ${return_value}=  Отримати текст із поля і показати на сторінці  items[0].deliveryAddress.region
  Run Keyword And Return  Remove String  ${return_value}  ,

Отримати інформацію про items[0].deliveryAddress.locality
  ${return_value}=  Отримати текст із поля і показати на сторінці  items[0].deliveryAddress.locality
  Run Keyword And Return  Remove String  ${return_value}  ,

Отримати інформацію про items[0].deliveryAddress.streetAddress
  ${return_value}=   Отримати текст із поля і показати на сторінці  items[0].deliveryAddress.streetAddress
  [return]  ${return_value}

Отримати інформацію про items[0].deliveryDate.endDate
  ${return_value}=   Отримати текст із поля і показати на сторінці  items[0].deliveryDate.endDate
  ${time}=   Отримати текст із поля і показати на сторінці   enquiryPeriod.startDate
  ${time}=   Get Substring   ${time}   11
  ${day}=   Get Substring   ${return_value}   16   18
  ${month}=   Get Substring   ${return_value}   18   22
  ${year}=   Get Substring   ${return_value}   22
  ${return_value}=   Convert To String  ${year}${month}${day}${time}
  [return]  ${return_value}

Отримати інформацію про questions[0].title
  ${return_value}=   Отримати текст із поля і показати на сторінці   questions[0].title
  [return]  ${return_value}

Отримати інформацію про questions[0].description
  ${return_value}=   Отримати текст із поля і показати на сторінці   questions[0].description
  [return]  ${return_value}

Отримати інформацію про questions[0].date
  ${return_value}=   Отримати текст із поля і показати на сторінці   questions[0].date
  ${return_value}=   Change_date_to_month   ${return_value}
  [return]  ${return_value}

Отримати інформацію про questions[0].answer
  ${return_value}=   Отримати текст із поля і показати на сторінці   questions[0].answer
  [return]  ${return_value}
