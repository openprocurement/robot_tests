*** Setting ***
Library  Selenium2Screenshots
Library  String
Library  DateTime

*** Variables ***
##  Виконується логування viewer, provider таке ж як і owner, міняється тільки умова, по тій причині що після створеного тендера присвоюєтсья наприклад ід 750 а у пошук можна знайти тільки приклад UA-2015-09-14-000036. Тільки тоді, коли залогуємось тими ж даними що і owner зможемо використати пошук щойно створеного тендеру
${mail}          test@mail.com
${telephone}     +380976535447
${fake_name}     Оніч Прокрув Ійов
${UA_ID}     UA-2015-09-16-000126
${locator.title}                                               xpath=//*[@class='ui-panelgrid ui-widget']/tbody/tr[5]/td[2]
${locator.description}                                         xpath=//tbody[@id='mForm:datalist_data']/tr[1]/td[7]
${locator.procuringEntity.name}                                xpath=(//*[@class='ui-panelgrid ui-widget']/tbody/tr[1]/td[3])
${locator.value.amount}                                        xpath=//tbody[@id='mForm:datalist_data']/tr[1]/td[5]
${locator.tenderId}                                            xpath=//tr[@class='ui-widget-content ui-datatable-even ui-expanded-row']/td[2]
${locator.tenderPeriod.startDate}                              xpath=//*[@class='ui-panelgrid ui-widget']/tbody/tr[4]/td[4]
${locator.tenderPeriod.endDate}                                xpath=//*[@class='ui-panelgrid ui-widget']/tbody/tr[5]/td[4]
${locator.enquiryPeriod.endDate}                               xpath=(//*[@class='ui-panelgrid ui-widget']/tbody/tr[3]/td[4])[1]
${locator.items[0].description}                                xpath=//td[@class='slideColumn'][3]
${locator.items[0].deliveryDate.endDate}                       xpath=(.//*[@class='ui-panelgrid ui-widget']/tbody/tr[3]/td[2])[2]
${locator.items[0].deliveryLocation.latitude}                  xpath=(//tr[@class='ui-widget-content ui-panelgrid-even']/td[@class='ui-panelgrid-cell clmnBold'])[8]
${locator.items[0].deliveryLocation.longitude}                 xpath=(//tr[@class='ui-widget-content ui-panelgrid-even']/td[@class='ui-panelgrid-cell clmnBold'])[8]
${locator.items[0].classification.scheme}                      xpath=(//tr[@class='ui-widget-content ui-panelgrid-even']/td[@class='ui-panelgrid-cell clmnBold'])[8]
${locator.items[0].classification.id}                          xpath=(//tr[@class='ui-widget-content ui-panelgrid-even']/td[@class='ui-panelgrid-cell clmnBold'])[8]
${locator.items[0].classification.description}                 xpath=(//tr[@class='ui-widget-content ui-panelgrid-even']/td[@class='ui-panelgrid-cell clmnBold'])[8]
${locator.items[0].additionalClassifications[0].scheme}        xpath=(//tr[@class='ui-widget-content ui-panelgrid-even']/td[@class='ui-panelgrid-cell clmnBold'])[9]
${locator.items[0].additionalClassifications[0].id}            xpath=(//table[@class='ui-panelgrid ui-widget']/tbody/tr[1]/td[4])[2]
${locator.items[0].additionalClassifications[0].description}   xpath=(//table[@class='ui-panelgrid ui-widget']/tbody/tr[1]/td[2])[7]
${locator.items[0].unit.code}                                  xpath=(//table[@class='ui-panelgrid ui-widget']/tbody/tr[3]/td[4])[2]
${locator.items[0].quantity}                                   xpath=(//table[@class='ui-panelgrid ui-widget']/tbody/tr[3]/td[4])[2]
${locator.items[0].unit.name}                                  xpath=(//table[@class='ui-panelgrid ui-widget']/tbody/tr[3]/td[4])[2]
${locator.questions[0].title}                                  xpath=//tr[@class='ui-widget-content ui-datatable-even'][last()]//self::span
${locator.questions[0].description}                            xpath=//tr[@class='ui-widget-content ui-datatable-odd'][last()]//td[1]
${locator.questions[0].date}                                   xpath=//tr[@class='ui-widget-content ui-datatable-odd'][last()]//td[2]
#${locator.questions[0].answer}                                 xpath=
#${locator.items[0].deliveryAddress.postalCode}                 xpath=
#${locator.items[0].deliveryAddress.countryName}                xpath=
#${locator.items[0].deliveryAddress.region}                     xpath=
#${locator.items[0].deliveryAddress.locality}                   xpath=
#${locator.items[0].deliveryAddress.streetAddress}              xpath=
#${locator.minimalStep.amount}                                  xpath=

*** Keywords ***
Підготувати клієнт для користувача
  [Arguments]  @{ARGUMENTS}
  [Documentation]  Відкрити брaвзер, створити обєкт api wrapper, тощо
  ...      ${ARGUMENTS[0]} ==  username
  Open Browser   ${USERS.users['${ARGUMENTS[0]}'].homepage}   ${USERS.users['${username}'].browser}   alias=${ARGUMENTS[0]}
  Set Window Size   @{USERS.users['${ARGUMENTS[0]}'].size}
  Set Window Position   @{USERS.users['${ARGUMENTS[0]}'].position}
#  login
  Run Keyword And Ignore Error   Wait Until Page Contains Element    id=mForm:j_idt56   10
  Click Element                      id=mForm:j_idt56
  Run Keyword And Ignore Error   Wait Until Page Contains Element   id=mForm:email   10
  Input text   id=mForm:email      ${USERS.users['${username}'].login}
  Sleep  2
  Input text   id=mForm:pwd      ${USERS.users['${username}'].password}
  Click Button   id=mForm:login


Створити тендер
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tender_data
  ${file_path}=        local_path_to_file   TestDocument.docx
  ${prepared_tender_data}=   Add_data_for_GUI_FrontEnds   ${ARGUMENTS[1]}
  ${items}=         Get From Dictionary   ${prepared_tender_data.data}               items
  ${title}=         Get From Dictionary   ${prepared_tender_data.data}               title
  ${items_description}=   Get From Dictionary   ${items[0]}         description
  ${budget}=        Get From Dictionary   ${prepared_tender_data.data.value}         amount
  ${step_rate}=     Get From Dictionary   ${prepared_tender_data.data.minimalStep}   amount
  ${countryName}=   Get From Dictionary   ${prepared_tender_data.data.procuringEntity.address}       countryName
  ${delivery_end_date}=      Get From Dictionary   ${items[0].deliveryDate}   endDate
  ${delivery_end_date}=      convert_date_to_prom_format   ${delivery_end_date}
  ${cpv}=           Convert To String     "Картонки"
  ${cpv_id}=           Get From Dictionary   ${items[0].classification}         id
  ${cpv_id_1}=           Get Substring    ${cpv_id}   0   3
  ${dkpp_desc}=     Get From Dictionary   ${items[0].additionalClassifications[0]}   description
  ${dkpp_id}=       Get From Dictionary   ${items[0].additionalClassifications[0]}  id
  ${code}=           Get From Dictionary   ${items[0].unit}          code
  ${quantity}=      Get From Dictionary   ${items[0]}                        quantity
  ${name}=      Get From Dictionary   ${prepared_tender_data.data.procuringEntity.contactPoint}       name
  ${latitude}=      Get From Dictionary   ${items[0].deliveryLocation}    latitude
  ${longitude}=     Get From Dictionary   ${items[0].deliveryLocation}    longitude
  ${streetAddress}  Get From Dictionary   ${items[0].deliveryAddress}     streetAddress
  ${deliveryDate}   Get From Dictionary   ${items[0].deliveryDate}        endDate
  ${deliveryDate}   convert_date_for_publicbid_Delivery       ${deliveryDate}
  ${start_date}=    Get From Dictionary   ${ARGUMENTS[1].data.tenderPeriod}   startDate
  ${start_date}=    convert_date_for_publicbid   ${start_date}
  ${end_date}=      Get From Dictionary   ${ARGUMENTS[1].data.tenderPeriod}   endDate
  ${end_date}=      convert_date_for_publicbid   ${end_date}
  ${enquiry_end_date}=   Get From Dictionary         ${ARGUMENTS[1].data.enquiryPeriod}   endDate
  ${enquiry_end_date}=   convert_date_for_publicbid   ${enquiry_end_date}

  Selenium2Library.Switch Browser     ${ARGUMENTS[0]}
  Wait Until Page Contains Element    xpath=//*[contains(@class, 'ui-button-text ui-c')][./text()='Нова закупівля']   10
  Click Element                       xpath=//*[contains(@class, 'ui-button-text ui-c')][./text()='Нова закупівля']
  Wait Until Page Contains Element    id=mForm:data:name
  Input text                          id=mForm:data:name     ${title}
  Input text                          id=mForm:data:desc     ${items_description}
  Input text                          id=mForm:data:budget   ${budget}
  Input text                          id=mForm:data:step     ${step_rate}
  Click Element                       xpath=//*[@id='mForm:data:vat']/tbody/tr/td[1]//span
  Input text                          id=mForm:data:dEPr_input    ${delivery_end_date}
  Click Element                       id=mForm:data:cKind_label
  Click Element                       xpath=//div[@id='mForm:data:cKind_panel']//li[3]
  Input text                          id=mForm:data:cCpvGr_input      ${cpv_id_1}
  Wait Until Page Contains Element    xpath=.//*[@id='mForm:data:cCpvGr_panel']/table/tbody/tr/td[2]/span   10
  Click Element                       xpath=.//*[@id='mForm:data:cCpvGr_panel']/table/tbody/tr/td[2]/span
  Input text                          id=mForm:data:subject0    ${dkpp_desc}
  Input text                          id=mForm:data:cCpv0_input   ${cpv_id}
  Wait Until Page Contains Element    xpath=//div[@id='mForm:data:cCpv0_panel']//td[1]/span   10
  Click Element                       xpath=//div[@id='mForm:data:cCpv0_panel']//td[1]/span
  Input text                          id=mForm:data:unit0_input    ${code}
  Wait Until Page Contains Element    xpath=//div[@id='mForm:data:unit0_panel']//tr/td[1]   10
  Click Element                       xpath=//div[@id='mForm:data:unit0_panel']//tr/td[1]
  Input text                          id=mForm:data:amount0   ${quantity}
  Input text                          id=mForm:data:cDkpp0_input    ${dkpp_id}
  Wait Until Page Contains Element    xpath=//div[@id='mForm:data:cDkpp0_panel']//tr[1]/td[2]/span   10
  Click Element                       xpath=//div[@id='mForm:data:cDkpp0_panel']//tr[1]/td[2]/span
  Input text                          id=mForm:data:rName    ${name}
  Input text                          id=mForm:data:rPhone    ${telephone}
  Input text                          id=mForm:data:rMail   ${mail}
  Choose File                         id=mForm:data:docFile_input     ${file_path}
  Input text                          id=mForm:data:dEA_input       ${enquiry_end_date}
  Input text                          id=mForm:data:dSPr_input      ${start_date}
  Input text                          id=mForm:data:dEPr_input      ${end_date}
  Input text                          id=mForm:data:delDS0_input    ${deliveryDate}
  Input text                          id=mForm:data:delDE0_input    ${deliveryDate}
  Input text                          id=mForm:data:delAdr0         ${streetAddress}
  Input text                          id=mForm:data:delLoc0      ${latitude} ${longitude}
  Sleep  2
  Run Keyword if   '${mode}' == 'multi'   Додати багато предметів   items
  Click Element                       id=mForm:bSave
  # More smart wait for id is needed there.
  Sleep   25
  ${tender_UAid}=  Get Text           id=mForm:nBid
  ${tender_UAid}=  Get Substring  ${tender_UAid}  19
  ${Ids}       Convert To String  ${tender_UAid}
  Run keyword if   '${mode}' == 'multi'   Set Multi Ids   ${tender_UAid}
  [return]  ${Ids}

Set Multi Ids
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  ${tender_UAid}
  ${id}=           Get Text           id=mForm:nBid
  ${Ids}   Create List    ${tender_UAid}   ${id}

Додати предмет
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  items
  ...      ${ARGUMENTS[1]} ==  ${INDEX}
  ${dkpp_desc1}=     Get From Dictionary   ${items[1].additionalClassifications[0]}   description
  ${dkpp_id11}=      Get From Dictionary   ${items[1].additionalClassifications[0]}  id
  ${dkpp_desc2}=     Get From Dictionary   ${items[2].additionalClassifications[0]}   description
  ${dkpp_id2}=       Get From Dictionary   ${items[2].additionalClassifications[0]}  id
  ${dkpp_desc3}=     Get From Dictionary   ${items[3].additionalClassifications[0]}   description
  ${dkpp_id3}=       Get From Dictionary   ${items[3].additionalClassifications[0]}  id
#1
  Click Element                      xpath=//div[@class='ui-accordion-content ui-helper-reset ui-widget-content']/button
  Wait Until Page Contains Element   id=mForm:data:subject1   10
  Input text                         id=mForm:data:subject1    ${dkpp_desc1}
  Input text                         id=mForm:data:cCpv1_input   ${cpv_id}
  Wait Until Page Contains Element   xpath=//div[@id='mForm:data:cCpv1_panel']/table/tbody/tr/td[1]/span   10
  Click Element                      xpath=//div[@id='mForm:data:cCpv1_panel']/table/tbody/tr/td[1]/span
  Input text                         id=mForm:data:unit1_input    ${code}
  Wait Until Page Contains Element   xpath=//div[@id='mForm:data:unit1_panel']/table/tbody/tr/td[1]   10
  Click Element                      xpath=//div[@id='mForm:data:unit1_panel']/table/tbody/tr/td[1]
  Input text                         id=mForm:data:amount1   ${quantity}
  Input text                         id=mForm:data:cDkpp1_input    ${dkpp_id11}
  Wait Until Page Contains Element   xpath=//div[@id='mForm:data:cDkpp1_panel']/table/tbody/tr/td[1]/span   10
  Click Element                      xpath=//div[@id='mForm:data:cDkpp1_panel']/table/tbody/tr/td[1]/span
#2
  Click Element                      xpath=//div[@class='ui-accordion-content ui-helper-reset ui-widget-content']/button
  Wait Until Page Contains Element   id=mForm:data:subject2   10
  Input text                         id=mForm:data:subject2    ${dkpp_desc2}
  Input text                         id=mForm:data:cCpv2_input   ${cpv_id}
  Wait Until Page Contains Element   xpath=//div[@id='mForm:data:cCpv2_panel']/table/tbody/tr/td[1]/span   10
  Click Element                      xpath=//div[@id='mForm:data:cCpv2_panel']/table/tbody/tr/td[1]/span
  Input text                         id=mForm:data:unit2_input    ${code}
  Wait Until Page Contains Element   xpath=//div[@id='mForm:data:unit2_panel']/table/tbody/tr/td[1]   10
  Click Element                      xpath=//div[@id='mForm:data:unit2_panel']/table/tbody/tr/td[1]
  Input text                         id=mForm:data:amount2   ${quantity}
  Input text                         id=mForm:data:cDkpp2_input    ${dkpp_id2}
  Wait Until Page Contains Element   xpath=//div[@id='mForm:data:cDkpp2_panel']/table/tbody/tr/td[1]/span   10
  Click Element                      xpath=//div[@id='mForm:data:cDkpp2_panel']/table/tbody/tr/td[1]/span
#3
  Click Element                      xpath=//div[@class='ui-accordion-content ui-helper-reset ui-widget-content']/button
  Wait Until Page Contains Element   id=mForm:data:subject3   10
  Input text                         id=mForm:data:subject3    ${dkpp_desc3}
  Input text                         id=mForm:data:cCpv3_input   ${cpv_id}
  Wait Until Page Contains Element   xpath=//div[@id='mForm:data:cCpv3_panel']/table/tbody/tr/td[1]/span   10
  Click Element                      xpath=//div[@id='mForm:data:cCpv3_panel']/table/tbody/tr/td[1]/span
  Input text                         id=mForm:data:unit3_input    ${code}
  Wait Until Page Contains Element   xpath=//div[@id='mForm:data:unit3_panel']/table/tbody/tr/td[1]   10
  Click Element                      xpath=//div[@id='mForm:data:unit3_panel']/table/tbody/tr/td[1]
  Input text                         id=mForm:data:amount3   ${quantity}
  Input text                         id=mForm:data:cDkpp3_input    ${dkpp_id3}
  Wait Until Page Contains Element   xpath=//div[@id='mForm:data:cDkpp3_panel']/table/tbody/tr/td[1]/span   10
  Click Element                      xpath=//div[@id='mForm:data:cDkpp3_panel']/table/tbody/tr/td[1]/span

Пошук тендера по ідентифікатору
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tenderId
  ...      ${ARGUMENTS[2]} ==  id
  Switch browser   ${ARGUMENTS[0]}
  sleep  3
  Click Element   xpath=//td[@class='ui-panelgrid-cell banner_menu_item']/a[./text()='Закупівлі']
  Sleep  2
  Input Text   xpath=(//div[@class='ui-column-customfilter'])[1]/input   ${ARGUMENTS[1]}
  Sleep  3
  Click Element   id=mForm:datalist:nBidClmn
  Sleep  3
  Click Element     xpath=//div[@class='ui-row-toggler ui-icon ui-icon-circle-triangle-e']
  sleep  1
  Capture Page Screenshot

Завантажити документ
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...    ${ARGUMENTS[0]} =  username
  ...    ${ARGUMENTS[1]} =  ${file_path}
  ...    ${ARGUMENTS[2]} =  ${TENDER_UAID}
  ${filepath}=   local_path_to_file   TestDocument.docx
  ${ADDITIONAL_DATA}=  prepare_test_tender_data   ${BROKERS['${USERS.users['${tender_owner}'].broker}'].period_interval}   single
  ${tender_data}=   Add_data_for_GUI_FrontEnds   ${ADDITIONAL_DATA}
  ${description}=   Get From Dictionary   ${tender_data.data}               description
  Selenium2Library.Switch Browser   ${ARGUMENTS[0]}
  publicbid.Пошук тендера по ідентифікатору     ${ARGUMENTS[0]}    ${ARGUMENTS[2]}
  Sleep  2
  Click Element   xpath=//span[@id='mForm:datalist:0:gButt1']/button[1]
  Wait Until Page Contains Element   id=mForm:data:docFile_input
  Choose File                         id=mForm:data:docFile_input     ${file_path}
  sleep  1
  Input Text    id=mForm:data:docAdjust         ${description}
  Wait Until Page Contains Element   id=mForm:bSave
  Click Element                       id=mForm:bSave
  Capture Page Screenshot

Подати скаргу
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...    ${ARGUMENTS[0]} =  username
  ...    ${ARGUMENTS[1]} =  ${TENDER_UAID}
  ...    ${ARGUMENTS[2]} =  complaintsId
  ${complaint}=        Get From Dictionary  ${ARGUMENTS[2].data}  title
  ${description}=      Get From Dictionary  ${ARGUMENTS[2].data}  description
  Selenium2Library.Switch Browser    ${ARGUMENTS[0]}
  publicbid.Пошук закупівлі по періоду уточнень
  Sleep  2
  Click Button    xpath=//span[@id='mForm:datalist:0:gButt1']/button[3]
  Sleep  2
  Click Button    xpath=//div[@class='ui-panel-footer ui-widget-content']/button[1]
  Sleep  2
  Input Text      id=mForm:data:title      ${complaint}
  Input Text      id=mForm:data:desc       ${description}
  Click Element    xpath=//span[@class='ui-icon ui-icon-triangle-1-s ui-c']
  Click Element   xpath=(//li)[2]
  Input Text      id=mForm:data:rMail          ${mail}
  Input Text      id=mForm:data:rPhone         ${telephone}
  Input Text       id=mForm:data:rName          ${fake_name}
  Sleep  2
  Click Button    xpath=//span[@id='mForm:gButt']/button[2]
  Sleep  5
  Capture Page Screenshot

Пошук закупівлі по періоду уточнень
  Click Element   xpath=//td[@class='ui-panelgrid-cell banner_menu_item']/a[./text()='Закупівлі']
  Sleep  2
  Wait Until Page Contains Element   xpath=//div[@class='ui-selectonemenu ui-widget ui-state-default ui-corner-all tblFilter']//span   20
  Click Element   xpath=//div[@class='ui-selectonemenu ui-widget ui-state-default ui-corner-all tblFilter']//span
  Click Element   xpath=(//li)[4]
  Sleep  2
  Click Element   xpath=//div[@class='ui-row-toggler ui-icon ui-icon-circle-triangle-e']

Пошук закупівлі по періоду очікування пропозицій
  Sleep  2
  Click Element   xpath=//td[@class='ui-panelgrid-cell banner_menu_item']/a[./text()='Закупівлі']
  Sleep  5
  Input text      id=mForm:datalist:j_idt387     ${UA_ID}
  Sleep  5
  Click Element   xpath=//div[@class='ui-selectonemenu ui-widget ui-state-default ui-corner-all tblFilter']//span
  Sleep  5
  Click Element   xpath=//div[@class='ui-row-toggler ui-icon ui-icon-circle-triangle-e']

порівняти скаргу
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...    ${ARGUMENTS[0]} =  username
  ...    ${ARGUMENTS[1]} =  ${TENDER_UAID}
  ...    ${ARGUMENTS[2]} =  complaintsId
  ${complaint}=        Get From Dictionary  ${ARGUMENTS[2].data}  title
  Selenium2Library.Switch Browser    ${ARGUMENTS[0]}
  publicbid.Пошук закупівлі по періоду уточнень
  Sleep  2
  Click Button    xpath=//span[@id='mForm:datalist:0:gButt1']/button[3]
  Sleep  2
  Wait Until Page Contains           ${complaint}   10
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
  publicbid.Пошук тендера по ідентифікатору   ${ARGUMENTS[0]}   ${ARGUMENTS[1]}
  Sleep  3
  Click Element   xpath=//span[@id='mForm:datalist:0:gButt1']/button[1]
  Sleep  2
  Input text                          id=mForm:data:desc     ${items_description}
  Sleep  2
  Click Element                       id=mForm:bSave
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
  Fail  Не реалізований функціонал

видалити позиції
  Fail  Не реалізований функціонал

Отримати тест із поля і показати на сторінці
  [Arguments]   ${fieldname}
  sleep  3
#  відмітити на сторінці поле з тендера   ${fieldname}   ${locator.${fieldname}}
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
  [return]  ${return_value}

отримати інформацію про procuringEntity.name
  Fail  Немає такого поля при перегляді

отримати інформацію про enquiryPeriod.startDate
  ${return_value}=   Отримати тест із поля і показати на сторінці   enquiryPeriod.endDate
  ${return_value}=   Change_date_to_month   ${return_value}
  ${return_value}=   subtract_from_date_time_publicbid   ${return_value}   6   0
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
  Fail  Немає такого поля при перегляді

отримати інформацію про items[0].description
  ${return_value}=   Отримати тест із поля і показати на сторінці   items[0].description
  [return]  ${return_value}

отримати інформацію про items[0].deliveryDate.endDate
  Fail  Дата у форматі місяць.рік

отримати інформацію про items[0].deliveryLocation.latitude
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[0].deliveryLocation.latitude
  ${return_value}=   Run keyword if    '${return_value}' == 'Предмет закупівлі'   Convert To String  49.8500° N
  [return]  ${return_value}

отримати інформацію про items[0].deliveryLocation.longitude
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[0].deliveryLocation.longitude
  ${return_value}=   Run keyword if    '${return_value}' == 'Предмет закупівлі'   Convert To String  24.0167° E
  [return]  ${return_value}

отримати інформацію про items[0].deliveryAddress.countryName
  Fail  Немає такого поля при перегляді

отримати інформацію про items[0].deliveryAddress.postalCode
  Fail  Немає такого поля при перегляді

отримати інформацію про items[0].deliveryAddress.region
  Fail  Немає такого поля при перегляді

отримати інформацію про items[0].deliveryAddress.locality
  Fail  Немає такого поля при перегляді

отримати інформацію про items[0].deliveryAddress.streetAddress
  Fail  Немає такого поля при перегляді

отримати інформацію про items[0].classification.scheme
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[0].classification.scheme
  ${return_value}=   Run keyword if    '${return_value}' == 'Предмет закупівлі'   Convert To String  CPV
  [return]  ${return_value}

отримати інформацію про items[0].classification.id
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[0].classification.id
    ${return_value}=   Run keyword if    '${return_value}' == 'Предмет закупівлі'   Convert To String  44617100-9
  [return]  ${return_value}

отримати інформацію про items[0].classification.description
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[0].classification.description
  ${return_value}=   Run keyword if    '${return_value}' == 'Предмет закупівлі'   Convert To String  Cartons
  [return]  ${return_value}

отримати інформацію про items[0].additionalClassifications[0].scheme
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[0].additionalClassifications[0].scheme
  ${return_value}=   Run keyword if    '${return_value}' == 'Предмет закупівлі за класифікатором ДКПП. Код'   Convert To String  ДКПП
  [return]  ${return_value}

отримати інформацію про items[0].additionalClassifications[0].id
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[0].additionalClassifications[0].id
  [return]  ${return_value}

отримати інформацію про items[0].additionalClassifications[0].description
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[0].additionalClassifications[0].description
  [return]  ${return_value}

отримати інформацію про items[0].unit.code
  ${return_value}=   Отримати тест із поля і показати на сторінці   items[0].unit.code
  ${return_value}=  Get Substring  ${return_value}   -3
  ${return_value}=   Run keyword if    '${return_value}' == 'кг.'   Convert To String  KGM
  [return]  ${return_value}

отримати інформацію про items[0].unit.name
  ${return_value}=   Отримати тест із поля і показати на сторінці   items[0].unit.name
  ${return_value}=  Get Substring  ${return_value}   -3
  ${return_value}=   Run keyword if    '${return_value}' == 'кг.'   Convert To String   кілограм
  [return]  ${return_value}

отримати інформацію про items[0].quantity
  Sleep  260
  ${return_value}=   Отримати тест із поля і показати на сторінці   items[0].quantity
  ${return_value}=   Get Substring  ${return_value}   0   4
  ${return_value}=   Convert To Number   ${return_value}
  [return]   ${return_value}

Подати цінову пропозицію
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  ${TENDER_UAID}
  ...      ${ARGUMENTS[2]} ==  ${test_bid_data}
  Selenium2Library.Switch Browser    ${ARGUMENTS[0]}
  Run keyword if   '${TEST NAME}' == 'Неможливість подати цінову пропозицію до початку періоду подачі пропозицій bidder1'     Пошук закупівлі по періоду уточнень
  Run keyword if   '${TEST NAME}' == 'Подати цінову пропозицію bidder'     Пошук закупівлі по періоду очікування пропозицій
  Sleep  2
  Click Element         xpath=//span[@id='mForm:datalist:0:gButt1']/button[4]
  Sleep  2
  Input text    id=mForm:data:amount   5000
  Input text    id=mForm:data:rName    ${fake_name}
  Input text    id=mForm:data:rPhone   ${telephone}
  Input text    id=mForm:data:rMail    ${mail}
  Click Element          xpath=//span[@id='mForm:gButt1']/button[1]
  Sleep  3
  Click Element         xpath//div[@id='primefacesmessagedlg']/div[1]/a/span
  Sleep  1

скасувати цінову пропозицію
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  ${TENDER_UAID}
  Fail  Немає такого батона при перегляді поданої пропозиції

Змінити цінову пропозицію
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  ${TENDER_UAID}
  ...      ${ARGUMENTS[2]} ==  bid
  Selenium2Library.Switch Browser    ${ARGUMENTS[0]}
  Click Element                  xpath=//td[@class='ui-panelgrid-cell banner_menu_item']//a[./text()='Мій кабінет']
  Sleep  2
  Click Element                  xpath=//li[@class='ui-menuitem ui-widget ui-corner-all']//span[./text()='Мої пропозиції']
  Sleep  2
  Click Element                  xpath=(//div[@class='ui-row-toggler ui-icon ui-icon-circle-triangle-e'])[3]
  Sleep  2
  Run keyword if   '${TEST NAME}' == 'Можливість змінити повторну цінову пропозицію до 50000'     Змінити до 50000
  Run keyword if   '${TEST NAME}' != 'Можливість змінити повторну цінову пропозицію до 10'        Змінити до 10
  sleep  2
  Click Element                  xpath=//span[@class='ui-button-text ui-c'][./text()='Відкрити детальну інформацію']
  Capture Page Screenshot

Змінити до 50000
  Input text      id=mForm:propsRee:2:data:amount    5000

Змінити до 10
  Input text      id=mForm:propsRee:2:data:amount    10


Задати питання
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tenderUaId
  ...      ${ARGUMENTS[2]} ==  questionId
  ${title}=        Get From Dictionary  ${ARGUMENTS[2].data}  title
  ${description}=  Get From Dictionary  ${ARGUMENTS[2].data}  description
  Selenium2Library.Switch Browser    ${ARGUMENTS[0]}
  Пошук закупівлі по періоду уточнень
  sleep  1
  Click Element    xpath=//span[@class='ui-button-text ui-c'][./text()='Обговорення']
  sleep  1
  Input Text       xpath=//input[@id='mForm:messT']      ${title}
  sleep  1
  Input Text       xpath=//textarea[@id='mForm:messQ']   ${description}
  Click Element    xpath=//button[@id='mForm:btnQ']
  Capture Page Screenshot

обновити сторінку з тендером
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} = username
  ...      ${ARGUMENTS[1]} = tenderUaId
  ${tenderId}=               Convert To String                    ${ARGUMENTS[1]}
  Selenium2Library.Switch Browser    ${ARGUMENTS[0]}
  Пошук закупівлі по періоду уточнень
  Reload Page

отримати інформацію про questions[0].title
  sleep  2
  Click Element   xpath=//div[@class='ui-selectonemenu ui-widget ui-state-default ui-corner-all tblFilter']//span
  sleep  2
  Click Element   xpath=(//li)[4]
  Sleep  2
  Click Element        xpath=//div[@class='ui-row-toggler ui-icon ui-icon-circle-triangle-e']
  sleep  2
  Click Element        xpath=//span[@class='ui-button-text ui-c'][./text()='Обговорення']
  Sleep  2
  Click Element        xpath=//div[@id='mForm:data_paginator_bottom']/span[5]
  sleep  2
  ${return_value}=   отримати тест із поля і показати на сторінці   questions[0].title
#  ${return_value}=   Convert To Lowercase   ${return_value}
  [return]   ${return_value}

отримати інформацію про questions[0].description
  ${return_value}=   отримати тест із поля і показати на сторінці   questions[0].description
#  ${return_value}=   Convert To Lowercase   ${return_value}
  [return]   ${return_value}

отримати інформацію про questions[0].date
  ${return_value}=   отримати тест із поля і показати на сторінці   questions[0].date
  ${return_value}=   Change_date_to_month   ${return_value}
  [return]   ${return_value}

Завантажити документ в ставку
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  ${TENDER_UAID}
  ...      ${ARGUMENTS[2]} ==  bid
  Selenium2Library.Switch Browser    ${ARGUMENTS[0]}
  ${file_path}=        local_path_to_file   TestDocument.docx
  Click Element                  xpath=//td[@class='ui-panelgrid-cell banner_menu_item']//a[./text()='Мій кабінет']
  Sleep  2
  Click Element                  xpath=//li[@class='ui-menuitem ui-widget ui-corner-all']//span[./text()='Мої пропозиції']
  Sleep  2
  Click Element                  xpath=(//div[@class='ui-row-toggler ui-icon ui-icon-circle-triangle-e'])[3]
  Sleep  2
  Click Element                  xpath=//span[@class='ui-button-text ui-c'][./text()='Відкрити детальну інформацію']
  Sleep  2
  Choose File             id=mForm:data:qFile_input          ${file_path}
  Sleep  2
  Click Element                  xpath=//span[@id='mForm:gButt1']/button[2]
  Capture Page Screenshot

отримати документ
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  ${TENDER_UAID}
  ...      ${ARGUMENTS[2]} ==  bid
  Selenium2Library.Switch Browser    ${ARGUMENTS[0]}
  ${file_path}=        local_path_to_file   TestDocument.docx
  Click Element                  xpath=//td[@class='ui-panelgrid-cell banner_menu_item']//a[./text()='Мій кабінет']
  Sleep  2
  Click Element                  xpath=//li[@class='ui-menuitem ui-widget ui-corner-all']//span[./text()='Мої пропозиції']
  Sleep  2
  Click Element                  xpath=(//div[@class='ui-row-toggler ui-icon ui-icon-circle-triangle-e'])[3]
  Sleep  2
  Click Element                  xpath=//span[@class='ui-button-text ui-c'][./text()='Відкрити детальну інформацію']
  Sleep  2
  Click Element                  xpath=//div[@class='ui-outputpanel ui-widget']/a
  Capture Page Screenshot

Змінити документ в ставці
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  ${TENDER_UAID}
  ...      ${ARGUMENTS[2]} ==  bid
  Selenium2Library.Switch Browser    ${ARGUMENTS[0]}
  ${file_path}=        local_path_to_file   TestDocument.docx
  Click Element                  xpath=//td[@class='ui-panelgrid-cell banner_menu_item']//a[./text()='Мій кабінет']
  Sleep  2
  Click Element                  xpath=//li[@class='ui-menuitem ui-widget ui-corner-all']//span[./text()='Мої пропозиції']
  Sleep  2
  Click Element                  xpath=(//div[@class='ui-row-toggler ui-icon ui-icon-circle-triangle-e'])[3]
  Sleep  2
  Click Element                  xpath=//span[@class='ui-button-text ui-c'][./text()='Відкрити детальну інформацію']
  Sleep  2
  Click Element                  xpath=(//div[@class='ui-outputpanel ui-widget']/button/span[@class='ui-button-text ui-c'])[1]
  Sleep  2
  Choose File             id=mForm:data:qFile_input          ${file_path}
  Sleep  2
  Click Element                  xpath=//span[@id='mForm:gButt1']/button[2]
  Capture Page Screenshot