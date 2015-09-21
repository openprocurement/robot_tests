*** Setting ***
Library  Selenium2Screenshots
Library  String
Library  DateTime

*** Variables ***
${mail}          test@mail.com
${telephone}     +380976535447
${fake_name}     Оніч Прокрув Ійов
${locator.title}                                               xpath=(//td[@class='ui-panelgrid-cell'])[28]
${locator.description}                                         xpath=//td[@class='slideColumn'][3]
#${locator.minimalStep.amount}                                  xpath=
#${locator.procuringEntity.name}                                xpath=
${locator.value.amount}                                        xpath=//tbody[@id='mForm:datalist_data']/tr[1]/td[4]
${locator.tenderId}                                            xpath=//tr[@class='ui-widget-content ui-datatable-even ui-expanded-row']/td[2]
#${locator.tenderPeriod.startDate}                              xpath=
#${locator.tenderPeriod.endDate}                                xpath=
#${locator.enquiryPeriod.startDate}                             xpath=
#${locator.enquiryPeriod.endDate}                               xpath=
#${locator.items[0].description}                                xpath=
#${locator.items[0].deliveryDate.endDate}                       xpath=
#${locator.items[0].deliveryLocation.latitude}                  xpath=
#${locator.items[0].deliveryLocation.longitude}                 xpath=
#${locator.items[0].deliveryAddress.postalCode}                 xpath=
#${locator.items[0].deliveryAddress.countryName}                xpath=
#${locator.items[0].deliveryAddress.region}                     xpath=
#${locator.items[0].deliveryAddress.locality}                   xpath=
#${locator.items[0].deliveryAddress.streetAddress}              xpath=
#${locator.items[0].classification.scheme}                      xpath=
#${locator.items[0].classification.id}                          xpath=
#${locator.items[0].classification.description}                 xpath=
#${locator.items[0].additionalClassifications[0].scheme}        xpath=
#${locator.items[0].additionalClassifications[0].id}            xpath=
#${locator.items[0].additionalClassifications[0].description}   xpath=
#${locator.items[0].unit.code}                                  xpath=
#${locator.items[0].quantity}                                   xpath=
${locator.questions[0].title}                                   xpath=//div[4]/span/div/div[2]/div[1]/div[2]/table/tbody/tr[1]/td[1]/span
#${locator.questions[0].description}                            xpath=
#${locator.questions[0].date}                                   xpath=
#${locator.questions[0].answer}                                 xpath=

*** Keywords ***
Підготувати клієнт для користувача
  [Arguments]  @{ARGUMENTS}
  [Documentation]  Відкрити брaвзер, створити обєкт api wrapper, тощо
  ...      ${ARGUMENTS[0]} ==  username
  Open Browser   ${USERS.users['${ARGUMENTS[0]}'].homepage}   ${USERS.users['${username}'].browser}   alias=${ARGUMENTS[0]}
  Set Window Size   @{USERS.users['${ARGUMENTS[0]}'].size}
  Set Window Position   @{USERS.users['${ARGUMENTS[0]}'].position}
#  Run Keyword If   '${username}' != 'Publicbid_Viewer'   Login
#  login
  Run Keyword And Ignore Error   Wait Until Page Contains Element    id=mForm:j_idt54   10
  Click Element                      id=mForm:j_idt54
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
  ${description}=   Get From Dictionary   ${prepared_tender_data.data}               description
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

  Selenium2Library.Switch Browser     ${ARGUMENTS[0]}
  Wait Until Page Contains Element    xpath=//*[contains(@class, 'ui-button-text ui-c')][./text()='Нова закупівля']   10
  Click Element                       xpath=//*[contains(@class, 'ui-button-text ui-c')][./text()='Нова закупівля']
  Wait Until Page Contains Element    id=mForm:data:name
  Input text                          id=mForm:data:name     ${title}
  Input text                          id=mForm:data:desc     ${description}
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
  Sleep  2
#  Додати предмет   ${items[0]}   0
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
  sleep  1
  Click Element    xpath=(//a[@class='ui-commandlink ui-widget'])[2]
  Sleep  2
  Input Text   xpath=(//div[@class='ui-column-customfilter'])[1]/input   ${ARGUMENTS[1]}
  Click Element   id=mForm:datalist:nBidClmn
  Sleep  2
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
  Selenium2Library.Switch Browser   ${ARGUMENTS[0]}
  publicbid.Пошук тендера по ідентифікатору     ${ARGUMENTS[0]}    ${ARGUMENTS[2]}
  Sleep  2
  Click Element   xpath=//span[@id='mForm:datalist:0:gButt1']/button[1]
  Wait Until Page Contains Element   id=mForm:data:docFile_input
  Choose File                         id=mForm:data:docFile_input     ${file_path}
  sleep  1
  Input Text    id=mForm:data:docAdjust          add file
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
  Capture Page Screenshot

Пошук закупівлі по періоду уточнень
  sleep  2
  Click Element   xpath=(//td[@class='ui-panelgrid-cell banner_menu_item']/a)[1]
  sleep  2
  Click Element   xpath=//div[@class='ui-selectonemenu ui-widget ui-state-default ui-corner-all tblFilter']//span
  sleep  2
  Click Element   xpath=(//li)[4]
  sleep  2
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
  ${ADDITIONAL_DATA}=  prepare_test_tender_data   ${BROKERS['${USERS.users['${tender_owner}'].broker}'].period_interval}   single
  ${tender_data}=   Add_data_for_GUI_FrontEnds   ${ADDITIONAL_DATA}
  ${description}=   Get From Dictionary   ${tender_data.data}               description
  Selenium2Library.Switch Browser    ${ARGUMENTS[0]}
  publicbid.Пошук тендера по ідентифікатору   ${ARGUMENTS[0]}   ${ARGUMENTS[1]}
  Click Element   xpath=//span[@id='mForm:datalist:0:gButt1']/button[1]
  Sleep  2
  Input text                          id=mForm:data:desc     ${description}
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



