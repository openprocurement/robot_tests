*** Setting ***
Library  Selenium2Screenshots
Library  String
Library  DateTime

*** Variables ***
${locator.tenderId}                                            xpath=//h2
${locator.title}                                               xpath=(//table[@class='table table-striped table-bordered']/tbody/tr[2]/td)[2]
${locator.description}                                         xpath=(//table[@class='table table-striped table-bordered']/tbody/tr[3]/td)[2]
${locator.value.amount}                                        xpath=(//table[@class='table table-striped table-bordered']/tbody/tr[4]/td)[2]
${locator.minimalStep.amount}                                  xpath=(//table[@class='table table-striped table-bordered']/tbody/tr[5]/td)[2]
${locator.procuringEntity.name}                                xpath=(//table[@class='table table-striped table-bordered']/tbody/tr[1]/td)[4]
${locator.tenderPeriod.startDate}                              xpath=(//table[@class='table table-striped table-bordered']/tbody/tr[4]/td)[1]
${locator.tenderPeriod.endDate}                                xpath=(//table[@class='table table-striped table-bordered']/tbody/tr[5]/td)[1]
${locator.enquiryPeriod.startDate}                             xpath=(//table[@class='table table-striped table-bordered']/tbody/tr[2]/td)[1]
${locator.enquiryPeriod.endDate}                               xpath=(//table[@class='table table-striped table-bordered']/tbody/tr[3]/td)[1]
${locator.items[0].description}                                xpath=(//table[@class='table table-striped table-bordered']/tbody/tr[1]/td)[3]
${locator.items[0].deliveryDate.endDate}                       xpath=//table[@class='table table-striped table-bordered']/tbody/tr[6]/td
${locator.items[0].deliveryAddress.countryName}                xpath=(//table[@class='table table-striped table-bordered']/tbody/tr[7]/td)[1]
${locator.items[0].classification.scheme}                      xpath=(//table[@class='table table-striped table-bordered']/tbody/tr[5]/th)[3]
${locator.items[0].classification.id}                          xpath=(//table[@class='table table-striped table-bordered']/tbody/tr[5]/td)[3]
${locator.items[0].additionalClassifications[0].scheme}        xpath=(//table[@class='table table-striped table-bordered']/tbody/tr[4]/th)[3]
${locator.items[0].additionalClassifications[0].id}            xpath=(//table[@class='table table-striped table-bordered']/tbody/tr[4]/td)[3]
${locator.items[0].additionalClassifications[0].description}   xpath=(//table[@class='table table-striped table-bordered']/tbody/tr[4]/td)[3]
${locator.items[0].quantity}                                   xpath=(//table[@class='table table-striped table-bordered']/tbody/tr[2]/td)[3]
${locator.items[0].unit.code}                                  xpath=(//table[@class='table table-striped table-bordered']/tbody/tr[3]/td)[3]
${locator.items[0].unit.name}                                  xpath=(//table[@class='table table-striped table-bordered']/tbody/tr[3]/td)[3]

*** Keywords ***
Підготувати клієнт для користувача
  [Arguments]  @{ARGUMENTS}
  [Documentation]  Відкрити брaузер, створити обєкт api wrapper, тощо
  ...      ${ARGUMENTS[0]} ==  username
  Open Browser   ${BROKERS['${USERS.users['${ARGUMENTS[0]}'].broker}'].url}   ${USERS.users['${ARGUMENTS[0]}'].browser}   alias=${ARGUMENTS[0]}
  Set Window Size       @{USERS.users['${ARGUMENTS[0]}'].size}
  Set Window Position   @{USERS.users['${ARGUMENTS[0]}'].position}
#  Run Keyword If   '${username}' != 'Ua_Viewer'   Login

#Login
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
  ${items_description}=   Get From Dictionary   ${items[0]}               description
  ${budget}=        Get From Dictionary   ${ARGUMENTS[1].data.value}         amount
  ${step_rate}=     Get From Dictionary   ${ARGUMENTS[1].data.minimalStep}   amount
  ${quantity}=      Get From Dictionary   ${items[0]}         quantity
  ${countryName}=   Get From Dictionary   ${ARGUMENTS[1].data.procuringEntity.address}       countryName
  ${delivery_end_date}=      Get From Dictionary   ${items[0].deliveryDate}   endDate
  ${delivery_end_date}=      convert_date_to_slash_format_with_time   ${delivery_end_date}
  ${cpv}=           Convert To String     Картонки
  ${cpv_id}=        Get From Dictionary   ${items[0].classification}         id
  ${cpv_id1}=       Replace String        ${cpv_id}   _    -
  ${dkpp_desc}=     Get From Dictionary   ${items[0].additionalClassifications[0]}   description
  ${dkpp_id}=       Get From Dictionary   ${items[0].additionalClassifications[0]}   id
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
  Click Element                       xpath=//select[@name='items[0][unit_id]']//option[20]
  Input text                          name=minimal_step  ${step_rate}
  Input text                          name=enquiry_start_date          ${enquiry_start_date}
  Input text                          name=enquiry_end_date            ${enquiry_end_date}
  Input text                          name=tender_start_date           ${start_date}
  Input text                          name=tender_end_date             ${end_date}
  Додати предмет    ${items[0]}    0
  Run Keyword if   '${mode}' == 'multi'   Додати багато предметів   items
  Click Element                       xpath=//input[@class='btn btn-lg btn-danger']
  Sleep  3
  Click Element                       xpath=//*[text()='${title}']
  Sleep  2
  Click Element                        xpath=//*[text()='Опубликовать']
  Sleep  5
  Reload Page
  Sleep  3
  Capture Page Screenshot
  ${tender_UAid}=   Get Text          xpath=//h2
  ${tender_UAid}=  Get Substring  ${tender_UAid}   7   27
  ${Ids}=   Convert To String         ${tender_UAid}
  Run keyword if   '${mode}' == 'multi'   Set Multi Ids   ${tender_UAid}
  [return]  ${Ids}

Set Multi Ids
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[1]} ==  ${tender_UAid}
  ${id}=    Get Text   xpath=//td/a
  ${Ids}=   Create List    ${tender_UAid}   ${id}

Додати предмет
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  items
  ...      ${ARGUMENTS[1]} ==  ${INDEX}
  ${dkpp_id2}=       Get From Dictionary   ${ARGUMENTS[0].additionalClassifications[0]}   id
  ${items}=         Get From Dictionary   ${INITIAL_TENDER_DATA.data}               items
  ${postalCode}     Get From Dictionary   ${items[0].deliveryAddress}     postalCode
  ${streetAddress}  Get From Dictionary   ${items[0].deliveryAddress}     streetAddress
  ${locality}  Get From Dictionary   ${items[0].deliveryAddress}     locality

  Input text                          xpath=(//div[@class='item-section']/div[@class='form-group']/div[@class='col-md-4']/input)[last()]   ${items_description}
  Input text                          xpath=(//div[@class='item-section']/div[@class='form-group']/div[@class='col-md-2']/input)[last()]   ${quantity}
  Click Element                       xpath=(//div[@class='item-section']/div[@class='form-group']/div[@class='col-md-2']/select//option[20])[last()]
  Input text                          xpath=(//div[@class='item-section']/div[@class='form-group'][2]/div[@class='col-md-8']/input[1])[last()]   ${dkpp_id2}
  Sleep  1
  Click Element                       xpath=//*[contains(text(),'${dkpp_id2}')]
  Input text                          xpath=(//div[@class='item-section']/div[@class='form-group'][3]/div[@class='col-md-8']/input[1])[last()]   ${cpv_id}
  Sleep  1
  Click Element                       xpath=(//*[contains(text(),'${cpv_id}')])[last()]
  Input text                          xpath=(//div[@class='col-md-4'][1]/div[@class='input-group date']/input[1])[last()]     ${delivery_end_date}
  Input text                          xpath=(//div[@class='col-md-4'][2]/div[@class='input-group date']/input[1])[last()]  ${delivery_end_date}
  Click Element                       xpath=(//label[@class='checkbox-inline']/input[@class='address-toggle-control origin'])[last()]
  Sleep  2
  Click Element                       xpath=(//select[@class='form-control'])[last()]//option[12]
  Input text                          xpath=(//div[@class='form-group'][3]/div[@class='col-md-4']/input[@class='form-control'])[last()]   ${postalCode}
  Input text                          xpath=(//div[@class='form-group'][4]/div[@class='col-md-4']/input[@class='form-control'])[last()]   ${locality}
  Input text                          xpath=(//div[@class='form-group'][5]/div[@class='col-md-4']/input[@class='form-control'])[last()]   ${streetAddress}

Додати багато предметів
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  items
  ${Items_length}=   Get Length   ${items}
  : FOR    ${INDEX}    IN RANGE    1    ${Items_length}
  \   Click Element   xpath=//button[@class='btn btn-info pull-right add-item-section']
  \   Додати предмет   ${items[${INDEX}]}   ${INDEX}
  Sleep  2

Завантажити документ
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...    ${ARGUMENTS[0]} =  username
  ...    ${ARGUMENTS[1]} =  ${file_path}
  ...    ${ARGUMENTS[2]} =  ${TENDER_UAID}
  ${filepath}=   local_path_to_file   TestDocument.docx
  uatender.Пошук тендера по ідентифікатору   ${ARGUMENTS[0]}   ${ARGUMENTS[1]}
  Click Element     xpath=//*[text()='Редактировать']
  Sleep  2
  Choose File       id=1        ${filepath}
  Sleep  2
  Click Element     xpath=//input[@class='btn btn-lg btn-danger']
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
  uatender.Пошук тендера по ідентифікатору   ${ARGUMENTS[0]}   ${ARGUMENTS[1]}
  Sleep  2
  Click Element                      xpath=//*[text()='Редактировать']
  Sleep  2
  Input text                         name=description    ${items_description}
  Sleep  2
  Click Element                      xpath=//input[@class='btn btn-lg btn-danger']
  Capture Page Screenshot

Подати скаргу
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...    ${ARGUMENTS[0]} =  username
  ...    ${ARGUMENTS[1]} =  ${TENDER_UAID}
  ...    ${ARGUMENTS[2]} =  complaintsId
  Fail  Поки не реалізовано

порівняти скаргу
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...    ${ARGUMENTS[0]} =  username
  ...    ${ARGUMENTS[1]} =  ${TENDER_UAID}
  ...    ${ARGUMENTS[2]} =  complaintsId
  Fail  Поки не реалізовано

Пошук тендера по ідентифікатору
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  ${TENDER_UAID}
  ...      ${ARGUMENTS[2]} ==  id
##тимчасове, поки не буде реалізований viewer, і поки немає реалізації поля для вводу ${tender_UAid}. Тоді keyword буде змінено!
  Selenium2Library.Switch Browser     ${ARGUMENTS[0]}
  Maximize Browser Window
  Go to   ${BROKERS['${USERS.users['${username}'].broker}'].url}
  Sleep  2
  Click Element                       xpath=(//*[contains(text(),'[ТЕСТУВАННЯ')])[1]
  Sleep  2

Отримати тест із поля і показати на сторінці
  [Arguments]   ${fieldname}
  sleep  3
  ${return_value}=   Get Text  ${locator.${fieldname}}
  [return]  ${return_value}

отримати інформацію із тендера
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  fieldname
  Switch browser   ${ARGUMENTS[0]}
  ${return_value}=  run keyword  отримати інформацію про ${ARGUMENTS[1]}
  [return]  ${return_value}

отримати інформацію про title
  ${return_value}=   Отримати тест із поля і показати на сторінці   title
  [return]  ${return_value}

отримати інформацію про description
  ${return_value}=   Отримати тест із поля і показати на сторінці   description
  [return]  ${return_value}

отримати інформацію про value.amount
  ${return_value}=   Отримати тест із поля і показати на сторінці   value.amount
  ${return_value}=   Get Substring    ${return_value}   0   5
  ${return_value}=   Convert To Number   ${return_value}
  [return]  ${return_value}

отримати інформацію про tenderId
  ${return_value}=   Отримати тест із поля і показати на сторінці   tenderId
  ${return_value}=   Get Substring    ${return_value}   7   27
  [return]  ${return_value}

отримати інформацію про procuringEntity.name
  Fail  Немає такого поля при перегляді

Change_date_to_month
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]}  ==  date
  ${day}=   Get Substring   ${ARGUMENTS[0]}   0   2
  ${month}=   Get Substring   ${ARGUMENTS[0]}  3   6
  ${year}=   Get Substring   ${ARGUMENTS[0]}   5
  ${return_value}=   Convert To String  ${month}${day}${year}
  [return]  ${return_value}

отримати інформацію про enquiryPeriod.startDate
  ${return_value}=   Отримати тест із поля і показати на сторінці   enquiryPeriod.startDate
  ${return_value}=   Change_date_to_month   ${return_value}
  [return]  ${return_value}

отримати інформацію про enquiryPeriod.endDate
  ${return_value}=   Отримати тест із поля і показати на сторінці   enquiryPeriod.endDate
  ${return_value}=   Change_date_to_month   ${return_value}
  [return]  ${return_value}

отримати інформацію про tenderPeriod.startDate
  ${return_value}=   Отримати тест із поля і показати на сторінці   tenderPeriod.startDate
  ${return_value}=   Change_date_to_month   ${return_value}
  [return]  ${return_value}

отримати інформацію про tenderPeriod.endDate
  ${return_value}=   Отримати тест із поля і показати на сторінці   tenderPeriod.endDate
  ${return_value}=   Change_date_to_month   ${return_value}
  [return]  ${return_value}

отримати інформацію про minimalStep.amount
  ${return_value}=   Отримати тест із поля і показати на сторінці   minimalStep.amount
  ${return_value}=   Convert To Number   ${return_value.split(' ')[0]}
  [return]  ${return_value}

додати предмети закупівлі
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} =  username
  ...      ${ARGUMENTS[1]} =  ${TENDER_UAID}
  ...      ${ARGUMENTS[2]} =  3
  ${ADDITIONAL_DATA}=  prepare_test_tender_data   ${BROKERS['${USERS.users['${tender_owner}'].broker}'].period_interval}   multi
  ${tender_data}=   Add_data_for_GUI_FrontEnds   ${ADDITIONAL_DATA}
  ${items}=         Get From Dictionary   ${tender_data.data}               items
  ${items_description}=   Get From Dictionary   ${items[0]}               description
  ${delivery_end_date}=      Get From Dictionary   ${items[0].deliveryDate}   endDate
  ${delivery_end_date}=      convert_date_to_slash_format_with_time   ${delivery_end_date}
  ${quantity}=      Get From Dictionary   ${items[0]}         quantity
  ${cpv_id}=        Get From Dictionary   ${items[0].classification}         id
  ${cpv_id1}=       Replace String        ${cpv_id}   _    -
  Selenium2Library.Switch Browser    ${ARGUMENTS[0]}
  Run keyword if   '${TEST NAME}' == 'Можливість додати позицію закупівлі в тендер'   додати позицію
  Run keyword if   '${TEST NAME}' != 'Можливість додати позицію закупівлі в тендер'   видалити позиції

додати позицію
  Click Element                        xpath=//*[text()='Мои тендеры']
  Sleep  2
  Click Element                      xpath=(//a[@class='btn btn-xs btn-info']/span)[1]
  Sleep  2
  : FOR    ${INDEX}    IN RANGE    1    ${ARGUMENTS[2]} +1
  \   Click Element   xpath=//button[@class='btn btn-info pull-right add-item-section']
  \   Додати предмет   ${items[${INDEX}]}   ${INDEX}
  Sleep  2
  Click Element   xpath=//input[@class='btn btn-lg btn-danger']
  Wait Until Page Contains    [ТЕСТУВАННЯ]   10

видалити позиції
  Fail  Немає можливості баг №493

отримати інформацію про items[0].description
  ${return_value}=   Отримати тест із поля і показати на сторінці   items[0].description
  [return]  ${return_value}

отримати інформацію про items[0].deliveryDate.endDate
  ${return_value}=   Отримати тест із поля і показати на сторінці   items[0].deliveryDate.endDate
  ${return_value}=   Get Substring    ${return_value}   21
  [return]  ${return_value}

отримати інформацію про items[0].deliveryLocation.latitude
  Fail  Немає такого поля при перегляді

отримати інформацію про items[0].deliveryLocation.longitude
  Fail  Немає такого поля при перегляді

отримати інформацію про items[0].deliveryAddress.countryName
  ${return_value}=   Отримати тест із поля і показати на сторінці   items[0].deliveryAddress.countryName
  ${return_value}=   Get Substring    ${return_value}   7   14
  ${return_value}=   Run keyword if    '${return_value}' == 'Украина'   Convert To String  Україна
  [return]  ${return_value}

отримати інформацію про items[0].deliveryAddress.postalCode
  ${return_value}=   Отримати тест із поля і показати на сторінці   items[0].deliveryAddress.countryName
  ${return_value}=   Get Substring    ${return_value}   0   5
  [return]  ${return_value}

отримати інформацію про items[0].deliveryAddress.region
  ${return_value}=   Отримати тест із поля і показати на сторінці   items[0].deliveryAddress.countryName
  ${return_value}=   Get Substring    ${return_value}   34   41
  [return]  ${return_value}

отримати інформацію про items[0].deliveryAddress.locality
  ${return_value}=   Отримати тест із поля і показати на сторінці   items[0].deliveryAddress.countryName
  ${return_value}=   Get Substring    ${return_value}   34   41
  [return]  ${return_value}

отримати інформацію про items[0].deliveryAddress.streetAddress
  ${return_value}=   Отримати тест із поля і показати на сторінці   items[0].deliveryAddress.countryName
  ${return_value}=   Get Substring    ${return_value}   43
  [return]  ${return_value}

отримати інформацію про items[0].classification.scheme
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[0].classification.scheme
  [return]  ${return_value.split(' ')[1]}

отримати інформацію про items[0].classification.id
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[0].classification.id
  [return]  ${return_value.split(' ')[0]}

отримати інформацію про items[0].classification.description
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[0].classification.id
  ${return_value}=   Get Substring    ${return_value.split(' ')[1]}   0
  ${return_value}=   Run keyword if    '${return_value}' == 'Картонки'   Convert To String  Cartons
  [return]  ${return_value}

отримати інформацію про items[0].additionalClassifications[0].scheme
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[0].additionalClassifications[0].scheme
  [return]  ${return_value.split(' ')[1]}

отримати інформацію про items[0].additionalClassifications[0].id
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[0].additionalClassifications[0].id
  [return]  ${return_value.split(' ')[0]}

отримати інформацію про items[0].additionalClassifications[0].description
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[0].additionalClassifications[0].description
  ${return_value}=   Get Substring    ${return_value}   8
  ${return_value}=   Convert To Lowercase   ${return_value}
  [return]  ${return_value}

отримати інформацію про items[0].unit.code
  ${return_value}=   Отримати тест із поля і показати на сторінці   items[0].unit.code
  ${return_value}=   Run keyword if    '${return_value}' == 'килограммы'   Convert To String  KGM
  [return]  ${return_value}

отримати інформацію про items[0].unit.name
  ${return_value}=   Отримати тест із поля і показати на сторінці   items[0].unit.name
  ${return_value}=   Run keyword if    '${return_value}' == 'килограммы'   Convert To String   кілограм
  [return]  ${return_value}

отримати інформацію про items[0].quantity
  ${return_value}=   Отримати тест із поля і показати на сторінці   items[0].quantity
  ${return_value}=   Convert To Number   ${return_value}
  [return]   ${return_value}

Відповісти на питання
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} = username
  ...      ${ARGUMENTS[1]} = ${TENDER_UAID}
  ...      ${ARGUMENTS[2]} = 0
  ...      ${ARGUMENTS[3]} = answer_data
  ${answer}=     Get From Dictionary  ${ARGUMENTS[3].data}  answer
  Selenium2Library.Switch Browser    ${ARGUMENTS[0]}
  uatender.Пошук тендера по ідентифікатору   ${ARGUMENTS[0]}   ${ARGUMENTS[1]}
  Click Element      xpath=//*[text()='Вопросы']
  Sleep  2
  Click Element      xpath=(//*[text()='Ответить'])[last()]
  Sleep  2
  Input text         name=answer     ${answer}
  Sleep  1
  Click Element      xpath=//div[@class='form-group']/input[@class='btn btn-xs btn-default']
  Capture Page Screenshot