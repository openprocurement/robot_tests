*** Setting ***
Library  Selenium2Screenshots
Library  String
Library  DateTime

*** Variables ***
${locator.tenderId}                  jquery=h3
##Використовую такий шлях у кожного буде мінятись /yboi/. Міняйте на сві шлях до файлу
${file_add}     /home/yboi/openprocurement.robottests.buildout/Document.docx
${locator.title}                     xpath=(//div[@class = 'col-sm-8']/p[@class='ng-binding'])[6]
${locator.description}               xpath=(//div[@class = 'col-sm-8']/p[@class='ng-binding'])[7]
${locator.minimalStep.amount}        xpath=(//div[@class = 'col-sm-8']/p[@class='ng-binding'])[9]
${locator.value.amount}              xpath=(//div[@class = 'col-sm-8']/p[@class='ng-binding'])[8]

*** Keywords ***
Підготувати клієнт для користувача
  [Arguments]  @{ARGUMENTS}
  [Documentation]  Відкрити брaвзер, створити обєкт api wrapper, тощо
  ...      ${ARGUMENTS[0]} ==  username
  Open Browser   ${USERS.users['${ARGUMENTS[0]}'].homepage}   ${USERS.users['${username}'].browser}   alias=${ARGUMENTS[0]}
  Set Window Size   @{USERS.users['${ARGUMENTS[0]}'].size}
  Set Window Position   @{USERS.users['${ARGUMENTS[0]}'].position}
  Run Keyword If   '${username}' != 'E-tender_Viewer'   Login

Login
  Wait Until Page Contains Element   id=inputUsername   100
  Input text   id=inputUsername      ${USERS.users['${username}'].login}
  Wait Until Page Contains Element   id=inputPassword   100
  Input text   id=inputPassword      ${USERS.users['${username}'].password}
  Click Button   id=btn_submit

Створити тендер
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  initial_tender_data
  ${prepared_tender_data}=   Add_data_for_GUI_FrontEnds   ${ARGUMENTS[1]}
  ${items}=         Get From Dictionary   ${prepared_tender_data.data}               items
  ${title}=         Get From Dictionary   ${prepared_tender_data.data}               title
  ${description}=   Get From Dictionary   ${prepared_tender_data.data}               description
  ${budget}=        Get From Dictionary   ${prepared_tender_data.data.value}         amount
  ${step_rate}=     Get From Dictionary   ${prepared_tender_data.data.minimalStep}   amount
  ${items_description}=   Get From Dictionary   ${prepared_tender_data.data}         description
  ${quantity}=      Get From Dictionary   ${items[0]}                        quantity
  ${cpv}=           Get From Dictionary   ${items[0].classification}         id
  ${unit}=          Get From Dictionary   ${items[0].unit}                   name
  ${start_date}=    Get From Dictionary   ${prepared_tender_data.data.tenderPeriod}   startDate
  ${start_date}=    convert_date_to_etender_format   ${start_date}
  ${start_time}=    Get From Dictionary   ${prepared_tender_data.data.tenderPeriod}   startDate
  ${start_time}=    convert_time_to_etender_format   ${start_time}
  ${end_date}=      Get From Dictionary   ${prepared_tender_data.data.tenderPeriod}   endDate
  ${end_date}=      convert_date_to_etender_format   ${end_date}
  ${end_time}=      Get From Dictionary   ${prepared_tender_data.data.tenderPeriod}   endDate
  ${end_time}=   convert_time_to_etender_format      ${end_time}
  ${enquiry_end_date}=   Get From Dictionary         ${prepared_tender_data.data.enquiryPeriod}   endDate
  ${enquiry_end_date}=   convert_date_to_etender_format   ${enquiry_end_date}
  ${enquiry_end_time}=   Get From Dictionary              ${prepared_tender_data.data.enquiryPeriod}   endDate
  ${enquiry_end_time}=   convert_time_to_etender_format   ${enquiry_end_time}

  Selenium2Library.Switch Browser    ${ARGUMENTS[0]}
  Wait Until Page Contains          Мої закупівлі   100
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
  Wait Until Page Contains    [ТЕСТУВАННЯ]   100
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

Oтримати internal id по UAid
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  ${tender_UAid}
  etender.Пошук тендера по ідентифікатору   ${ARGUMENTS[0]}   ${ARGUMENTS[1]}
  ${current_location}=   Get Location
  ${tender_id}=   Fetch From Right   ${current_location}   /
  [return]  ${tender_id}

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

Пошук тендера по ідентифікатору
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  ${TENDER_UAID}
  Switch browser   ${ARGUMENTS[0]}
  Go to   ${BROKERS['${USERS.users['${username}'].broker}'].url}
  Wait Until Page Contains   Список закупівель    10
  sleep  1
  Input Text  jquery=input[ng-change='search()']  ${ARGUMENTS[1]}
  Click Link  jquery=a[ng-click='search()']
  sleep  2
  Click Link    jquery=a[href^="#/tenderDetailes"]
  Wait Until Page Contains    ${ARGUMENTS[1]}   10
  sleep  1
  Capture Page Screenshot

Подати цінову пропозицію
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  ${TENDER_UAID}
  ...      ${ARGUMENTS[2]} ==  test_bid_data

  ${bid}=        Get From Dictionary   ${ARGUMENTS[2].data.value}         amount
  etender.Пошук тендера по ідентифікатору   ${ARGUMENTS[0]}   ${ARGUMENTS[1]}
  Wait Until Page Contains          Інформація про процедуру закупівлі    100
  Wait Until Page Contains Element          id=amount   10
  Input text    id=amount                  ${bid}
  Click Element                     xpath=//button[contains(@class, 'btn btn-success')][./text()='Реєстрація пропозиції']

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

  Wait Until Page Contains Element   jquery=a[href^="#/addQuestion/"]   100
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

  Click Element                      xpath=//div[div/pre[1]]/div[1]
  Input text                         xpath=//div[textarea]/textarea            ${answer}
  Click Element                      xpath=//div[textarea]/span/button[1]

обновити сторінку з тендером
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tenderId
  ...      ${ARGUMENTS[2]} ==  id
  ${current_location}=   Get Location
  Run keyword if   '${BROKERS['${USERS.users['${username}'].broker}'].url}/#/tenderDetailes/${ARGUMENTS[2]}'=='${current_location}'  Reload Page
  Run keyword unless   '${BROKERS['${USERS.users['${username}'].broker}'].url}/#/tenderDetailes/${ARGUMENTS[2]}'=='${current_location}'  Пошук тендера по ідентифікатору   @{ARGUMENTS}
  Wait Until Page Contains    ${ARGUMENTS[1]}   10
  sleep  1

Внести зміни в тендер
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} =  username
  ...      ${ARGUMENTS[1]} =  ${TENDER_UAID}
  ${ADDITIONAL_DATA}=  prepare_test_tender_data   ${BROKERS['${USERS.users['${tender_owner}'].broker}'].period_interval}   single
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
  ${ADDITIONAL_DATA}=  prepare_test_tender_data   ${BROKERS['${USERS.users['${tender_owner}'].broker}'].period_interval}   multi
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
  Wait Until Page Contains    [ТЕСТУВАННЯ]   100

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
  Wait Until Page Contains    [ТЕСТУВАННЯ]   100

отримати інформацію із тендера
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  fieldname
  Switch browser   ${ARGUMENTS[0]}
  ${return_value}=  run keyword  отримати інформацію про ${ARGUMENTS[1]}
  Log  ${return_value}
  [return]  ${return_value}

Отримати тест із поля і показати на сторінці
  [Arguments]   ${fieldname}
  sleep  3
#  відмітити на сторінці поле з тендера   ${fieldname}   ${locator.${fieldname}}
  ${return_value}=   Get Text  ${locator.${fieldname}}
  [return]  ${return_value}

отримати інформацію про title
  ${return_value}=   Отримати тест із поля і показати на сторінці   title
  [return]  ${return_value}

отримати інформацію про description
  ${return_value}=   Отримати тест із поля і показати на сторінці   description
  [return]  ${return_value}

отримати інформацію про minimalStep.amount
  ${return_value}=   Отримати тест із поля і показати на сторінці   minimalStep.amount
  ${return_value}=   Convert To Number   ${return_value.split(' ')[0]}
  [return]  ${return_value}

отримати інформацію про value.amount
  ${return_value}=   Отримати тест із поля і показати на сторінці   value.amount
  ${return_value}=   Evaluate   "".join("${return_value}".split(' ')[:-3])
  ${return_value}=   Convert To Number   ${return_value}
  [return]  ${return_value}

Відмітити на сторінці поле з тендера
  [Arguments]   ${fieldname}  ${locator}
  ${last_note_id}=  Add pointy note   ${locator}   Found ${fieldname}   width=200  position=bottom
  Align elements horizontally    ${locator}   ${last_note_id}
  sleep  1
  Remove element   ${last_note_id}

отримати інформацію про tenderId
  ${return_value}=   отримати тест із поля і показати на сторінці   tenderId
  ${return_value}=  Get Substring  ${return_value}   10
  [return]  ${return_value}

отримати інформацію про procuringEntity.name
  ${return_value}=   Отримати тест із поля і показати на сторінці   procuringEntity.name
  [return]  ${return_value}

отримати інформацію про tenderPeriod.startDate
  ${return_value}=   Отримати тест із поля і показати на сторінці  tenderPeriod.startDate
  [return]  ${return_value}

отримати інформацію про tenderPeriod.endDate
  ${return_value}=   Отримати тест із поля і показати на сторінці  tenderPeriod.endDate
  [return]  ${return_value}

отримати інформацію про enquiryPeriod.startDate
  ${return_value}=   Отримати тест із поля і показати на сторінці  enquiryPeriod.startDate
  [return]  ${return_value}

отримати інформацію про enquiryPeriod.endDate
  ${return_value}=   Отримати тест із поля і показати на сторінці  enquiryPeriod.endDate
  [return]  ${return_value}

отримати інформацію про items[${item_id}].description
  відмітити на сторінці поле з тендера   items[${item_id}].description   jquery=tender-subject-info.ng-isolate-scope>div.row:contains("Детальний опис предмету закупівлі:")>:eq(1)>
  ${return_value}=   Get Text  jquery=tender-subject-info.ng-isolate-scope>div.row:contains("Детальний опис предмету закупівлі:")>:eq(1)>
  [return]  ${return_value}

отримати інформацію про items[${item_id}].quantity
  відмітити на сторінці поле з тендера   items[${item_id}].quantity   jquery=tender-subject-info.ng-isolate-scope>div.row:contains("Кількість:")>:eq(1)>
  ${return_value}=   Get Text  jquery=tender-subject-info.ng-isolate-scope>div.row:contains("Кількість:")>:eq(1)>
  ${return_value}=  Convert To Number   ${return_value}
  [return]  ${return_value}

отримати інформацію про items[${item_id}].classification.id
  відмітити на сторінці поле з тендера   items[0].classification.id   jquery=tender-subject-info>div.row:contains("Класифікатор CPV:")>:eq(1)>
  ${return_value}=   Get Text  jquery=tender-subject-info>div.row:contains("Класифікатор CPV:")>:eq(1)>
  [return]  ${return_value.split(' ')[0]}

отримати інформацію про items[${item_id}].classification.scheme
  відмітити на сторінці поле з тендера   items[0].classification.id   jquery=tender-subject-info>div.row:contains("CPV")>:eq(1)>
  ${return_value}=   Get Text  jquery=tender-subject-info>div.row:contains("CPV")>:eq(1)>
  [return]  ${return_value.split(' ')[0]}

отримати інформацію про items[${item_id}].classification.description
  відмітити на сторінці поле з тендера   classification.description   jquery=tender-subject-info>div.row:contains("Класифікатор CPV:")>:eq(1)>
  ${return_value}=   Get Text  jquery=tender-subject-info>div.row:contains("Класифікатор CPV:")>:eq(1)>
  ${return_value}=   catenate  @{return_value.split(' ')[1:]}
  [return]  ${return_value}

отримати інформацію про items[${item_id}].deliveryAddress
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[${item_id}].deliveryAddress
  [return]  ${return_value}

отримати інформацію про items[${item_id}].deliveryDate
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[${item_id}].deliveryDate
  [return]  ${return_value}

отримати інформацію про questions[${question_id}].title
  відмітити на сторінці поле з тендера   questions title   jquery=tender-questions>div:eq(1)>div.row:contains("Тема:")>:eq(1)>
  ${return_value}=   Get Text  jquery=tender-questions>div:eq(1)>div.row:contains("Тема:")>:eq(1)>
  [return]  ${return_value}

отримати інформацію про questions[${question_id}].description
  відмітити на сторінці поле з тендера   questions description   jquery=tender-questions>div:eq(1)>div.row:contains("Питання:")>:eq(1)>
  ${return_value}=   Get Text  jquery=tender-questions>div:eq(1)>div.row:contains("Питання:")>:eq(1)>
  [return]  ${return_value}

отримати інформацію про questions[${question_id}].date
  відмітити на сторінці поле з тендера   question date   jquery=tender-questions>div:eq(1)>div.row:contains("Дата:")>:eq(1)>
  ${return_value}=   Get Text  jquery=tender-questions>div:eq(1)>div.row:contains("Дата:")>:eq(1)>
  [return]  ${return_value}

отримати інформацію про questions[${question_id}].answer
  відмітити на сторінці поле з тендера   question answer   jquery=tender-questions>div:eq(1)>div:last>
  ${return_value}=   Get Text  jquery=tender-questions>div:eq(1)>div:last>
  [return]  ${return_value}
