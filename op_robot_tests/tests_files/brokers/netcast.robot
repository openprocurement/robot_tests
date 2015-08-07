*** Setting ***
Library  Selenium2Screenshots
Library  String
Library  DateTime

*** Variables ***
${locator.tenderId}                  jquery=h3
${locator.title}                     jquery=tender-subject-info>div.row:contains("Назва закупівлі:")>:eq(1)>
${locator.description}               jquery=tender-subject-info>div.row:contains("Детальний опис закупівлі:")>:eq(1)>
${locator.minimalStep.amount}        jquery=tender-subject-info>div.row:contains("Мінімальний крок аукціону, грн.:")>:eq(1)>
${locator.procuringEntity.name}      jquery=customer-info>div.row:contains("Найменування:")>:eq(1)>
${locator.value.amount}              jquery=tender-subject-info>div.row:contains("Повний доступний бюджет закупівлі, грн.:")>:eq(1)>
${locator.tenderPeriod.startDate}    jquery=tender-procedure-info>div.row:contains("Початок прийому пропозицій:")>:eq(1)>
${locator.tenderPeriod.endDate}      jquery=tender-procedure-info>div.row:contains("Завершення прийому пропозицій:")>:eq(1)>
${locator.enquiryPeriod.startDate}   jquery=tender-procedure-info>div.row:contains("Початок періоду уточнень:")>:eq(1)>
${locator.enquiryPeriod.endDate}     jquery=tender-procedure-info>div.row:contains("Завершення періоду уточнень:")>:eq(1)>

*** Keywords ***
Підготувати клієнт для користувача
  [Arguments]  @{ARGUMENTS}
  [Documentation]  Відкрити брaвзер, створити обєкт api wrapper, тощо
  ...      ${ARGUMENTS[0]} ==  username
  Open Browser   ${BROKERS['${USERS.users['${ARGUMENTS[0]}'].broker}'].url}   ${USERS.users['${ARGUMENTS[0]}'].browser}   alias=${ARGUMENTS[0]}
  Set Window Size       @{USERS.users['${ARGUMENTS[0]}'].size}
  Set Window Position   @{USERS.users['${ARGUMENTS[0]}'].position}

# login
  Wait Until Page Contains Element   name=siteLogin   100
  Input text    name=siteLogin      ${BROKERS['${USERS.users['${username}'].broker}'].login}
  Input text   name=sitePass       ${BROKERS['${USERS.users['${username}'].broker}'].password}
  Click Button   xpath=.//*[@id='table1']/tbody/tr/td/form/p[3]/input

  Wait Until Page Contains Element    jquery=a[href="/cabinet"]
  Click Element                       jquery=a[href="/cabinet"]
  Wait Until Page Contains Element    name=email   100
  Input text    name=email     mail
  Sleep  1
  Input text    name=email      ${USERS.users['${username}'].login}
  Sleep  2
  Input text   name=psw        ${USERS.users['${username}'].password}
  Wait Until Page Contains Element   xpath=//button[contains(@class, 'btn')][./text()='Вхід в кабінет']   100
  Click Element                xpath=//button[contains(@class, 'btn')][./text()='Вхід в кабінет']

Створити тендер
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tender_data

  ${items}=         Get From Dictionary   ${ARGUMENTS[1].data}               items
  ${title}=         Get From Dictionary   ${ARGUMENTS[1].data}               title
  ${description}=   Get From Dictionary   ${ARGUMENTS[1].data}               description
  ${budget}=        Get From Dictionary   ${ARGUMENTS[1].data.value}         amount
  ${step_rate}=     Get From Dictionary   ${ARGUMENTS[1].data.minimalStep}   amount
  ${items_description}=   Get From Dictionary   ${ARGUMENTS[1].data}         description
  ${quantity}=      Get From Dictionary   ${items[0]}         quantity
  ${countryName}=   Get From Dictionary   ${ARGUMENTS[1].data.procuringEntity.address}       countryName
  ${delivery_end_date}=      Get From Dictionary   ${items[0].deliveryDate}   endDate
  ${delivery_end_date}=      convert_date_to_slash_format   ${delivery_end_date}
  ${cpv}=           Get From Dictionary   ${items[0].classification}          description_ua
  ${cpv_id}=           Get From Dictionary   ${items[0].classification}         id
  ${cpv_id1}=       Replace String   ${cpv_id}   -   _
  ${dkpp_desc}=     Get From Dictionary   ${items[0].additionalClassifications[0]}   description
  ${dkpp_id}=       Get From Dictionary   ${items[0].additionalClassifications[0]}  id
  ${dkpp_id1}=      Replace String   ${dkpp_id}   -   _
  ${enquiry_end_date}=   Get From Dictionary         ${ARGUMENTS[1].data.enquiryPeriod}   endDate
  ${enquiry_end_date}=   convert_date_to_slash_format   ${enquiry_end_date}
  ${end_date}=      Get From Dictionary   ${ARGUMENTS[1].data.tenderPeriod}   endDate
  ${end_date}=      convert_date_to_slash_format   ${end_date}

  Selenium2Library.Switch Browser     ${ARGUMENTS[0]}
  Wait Until Page Contains Element    jquery=a[href="/tenders/new"]   100
  Click Element                       jquery=a[href="/tenders/new"]
  Wait Until Page Contains Element    name=tender_title   100
  Input text                          name=tender_title    ${title}
  Input text                          name=tender_description    ${description}
  Input text                          name=tender_value_amount   ${budget}
  Input text                          name=tender_minimalStep_amount   ${step_rate}
  Input text                          name=items[0][item_description]    ${items_description}
  Input text                          name=items[0][item_quantity]   ${quantity}
  Input text                          name=items[0][item_deliveryAddress_countryName]   ${countryName}
  Input text                          name=items[0][item_deliveryDate_endDate]       ${delivery_end_date}
  Click Element                       xpath=//a[contains(@data-class, 'cpv')][./text()='Визначити за довідником']
  Select Frame                        xpath=//iframe[contains(@src,'/js/classifications/cpv/uk.htm?relation=true')]
  Input text                          id=search     ${cpv}
  Wait Until Page Contains            ${cpv_id}
  Click Element                       xpath=//a[contains(@id,'${cpv_id1}')]
  Click Element                       xpath=.//*[@id='select']
  Unselect Frame
  Click Element                       xpath=//a[contains(@data-class, 'dkpp')][./text()='Визначити за довідником']
  Select Frame                        xpath=//iframe[contains(@src,'/js/classifications/dkpp/uk.htm?relation=true')]
  Input text                          id=search     ${dkpp_desc}
  Wait Until Page Contains            ${dkpp_id}
  Click Element                       xpath=//a[contains(@id,'${dkpp_id1}')]
  Click Element                       xpath=.//*[@id='select']
  Unselect Frame
  Input text                          name=tender_enquiryPeriod_endDate   ${enquiry_end_date}
  Input text                          name=tender_tenderPeriod_endDate    ${end_date}
  Run Keyword if   '${mode}' == 'multi'   Додати предмет   items
  Wait Until Page Contains Element    name=do    100
  Click Element                       name=do
  Wait Until Page Contains Element    xpath=//a[contains(@class, 'button pubBtn')]    100
  Click Element                       xpath=//a[contains(@class, 'button pubBtn')]
  Wait Until Page Contains            Тендер опубліковано    100
  ${tender_UAid}=  Get Text           xpath=//*/section[6]/table/tbody/tr[2]/td[2]
  ${id}=           Get Text           xpath=//*/section[6]/table/tbody/tr[1]/td[2]
  ${Ids}   Create List    ${tender_UAid}   ${id}
  [return]  ${Ids}

Додати предмет
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  items
  ${dkpp_desc1}=     Get From Dictionary   ${items[1].additionalClassifications[0]}   description
  ${dkpp_id11}=      Get From Dictionary   ${items[1].additionalClassifications[0]}  id
  ${dkpp_1id}=            Replace String   ${dkpp_id11}   -   _
  ${dkpp_desc2}=     Get From Dictionary   ${items[2].additionalClassifications[0]}   description
  ${dkpp_id2}=       Get From Dictionary   ${items[2].additionalClassifications[0]}  id
  ${dkpp_id2_1}=          Replace String   ${dkpp_id2}   -   _
  ${dkpp_desc3}=     Get From Dictionary   ${items[3].additionalClassifications[0]}   description
  ${dkpp_id3}=       Get From Dictionary   ${items[3].additionalClassifications[0]}  id
  ${dkpp_id3_1}=          Replace String   ${dkpp_id3}   -   _

  Wait Until Page Contains Element    xpath=//a[contains(@class, 'addMultiItem')][./text()='Додати предмет закупівлі']
  Click Element                       xpath=//a[contains(@class, 'addMultiItem')][./text()='Додати предмет закупівлі']
  Wait Until Page Contains Element    name=items[1][item_description]   100
  Input text                          name=items[1][item_description]    ${description}
  Input text                          name=items[1][item_quantity]   ${quantity}
  Click Element                       xpath=(//a[contains(@data-class, 'cpv')][./text()='Визначити за довідником'])[2]
  Select Frame                        xpath=//iframe[contains(@src,'/js/classifications/cpv/uk.htm?relation=true')]
  Input text                          id=search     ${cpv}
  Wait Until Page Contains            ${cpv_id}
  Click Element                       xpath=//a[contains(@id,'${cpv_id1}')]
  Click Element                       xpath=.//*[@id='select']
  Unselect Frame
  Click Element                       xpath=(//a[contains(@data-class, 'dkpp')][./text()='Визначити за довідником'])[2]
  Select Frame                        xpath=//iframe[contains(@src,'/js/classifications/dkpp/uk.htm?relation=true')]
  Input text                          id=search     ${dkpp_desc1}
  Wait Until Page Contains            ${dkpp_id11}
  Click Element                       xpath=//a[contains(@id,'${dkpp_1id}')]
  Click Element                       xpath=.//*[@id='select']
  Unselect Frame
  Click Element                       xpath=//a[contains(@class, 'addMultiItem')][./text()='Додати предмет закупівлі']
  Wait Until Page Contains Element    name=items[2][item_description]   100
  Input text                          name=items[2][item_description]    ${description}
  Input text                          name=items[2][item_quantity]   ${quantity}
  Click Element                       xpath=(//a[contains(@data-class, 'cpv')][./text()='Визначити за довідником'])[3]
  Select Frame                        xpath=//iframe[contains(@src,'/js/classifications/cpv/uk.htm?relation=true')]
  Input text                          id=search     ${cpv}
  Wait Until Page Contains            ${cpv_id}
  Click Element                       xpath=//a[contains(@id,'${cpv_id1}')]
  Click Element                       xpath=.//*[@id='select']
  Unselect Frame
  Click Element                       xpath=(//a[contains(@data-class, 'dkpp')][./text()='Визначити за довідником'])[3]
  Select Frame                        xpath=//iframe[contains(@src,'/js/classifications/dkpp/uk.htm?relation=true')]
  Input text                          id=search     ${dkpp_desc2}
  Wait Until Page Contains            ${dkpp_id2}
  Click Element                       xpath=//a[contains(@id,'${dkpp_id2_1}')]
  Click Element                       xpath=.//*[@id='select']
  Unselect Frame
  Click Element                       xpath=//a[contains(@class, 'addMultiItem')][./text()='Додати предмет закупівлі']
  Wait Until Page Contains Element    name=items[3][item_description]   100
  Input text                          name=items[3][item_description]    ${description}
  Input text                          name=items[3][item_quantity]   ${quantity}
  Click Element                       xpath=(//a[contains(@data-class, 'cpv')][./text()='Визначити за довідником'])[4]
  Select Frame                        xpath=//iframe[contains(@src,'/js/classifications/cpv/uk.htm?relation=true')]
  Input text                          id=search     ${cpv}
  Wait Until Page Contains            ${cpv_id}
  Click Element                       xpath=//a[contains(@id,'${cpv_id1}')]
  Click Element                       xpath=.//*[@id='select']
  Unselect Frame
  Click Element                       xpath=(//a[contains(@data-class, 'dkpp')][./text()='Визначити за довідником'])[4]
  Select Frame                        xpath=//iframe[contains(@src,'/js/classifications/dkpp/uk.htm?relation=true')]
  Input text                          id=search     ${dkpp_desc3}
  Wait Until Page Contains            ${dkpp_id3}
  Click Element                       xpath=//a[contains(@id,'${dkpp_id3_1}')]
  Click Element                       xpath=.//*[@id='select']
  Unselect Frame
  Input text                          name=tender_enquiryPeriod_endDate   ${enquiry_end_date}
  Input text                          name=tender_tenderPeriod_endDate    ${end_date}


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
  Wait Until Page Contains   E-TENDER - центр електронної торгівлі   10
  sleep  1
  Input Text  jquery=input[ng-change='search()']  ${ARGUMENTS[1]}
  Click Link  jquery=a[ng-click='search()']
  sleep  2
  ${last_note_id}=  Add pointy note   jquery=a[href^="#/tenderDetailes"]   Found tender with tenderID "${ARGUMENTS[1]}"   width=200  position=bottom
  sleep  1
  Remove element   ${last_note_id}
  Click Link    jquery=a[href^="#/tenderDetailes"]
  Wait Until Page Contains    ${ARGUMENTS[1]}   10
  sleep  1
  Capture Page Screenshot

Задати питання
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tenderId
  ...      ${ARGUMENTS[2]} ==  id
  ${title}=        Get From Dictionary  ${ARGUMENTS[2].data}  title
  ${description}=  Get From Dictionary  ${ARGUMENTS[2].data}  description

  Selenium2Library.Switch Browser    ${ARGUMENTS[0]}
  netcast.Пошук тендера по ідентифікатору    ${ARGUMENTS[0]}   ${ARGUMENTS[1]}   ${TENDER_ID}

  Wait Until Page Contains Element   jquery=a[href^="#/addQuestions/"]   30
  Click Element                      jquery=a[href^="#/addQuestions/"]
