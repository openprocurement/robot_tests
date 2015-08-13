*** Setting ***
Library  Selenium2Screenshots
Library  String
Library  DateTime

*** Variables ***
${locator.tenderId}                  jquery=h3
${file_path}                         local_path_to_file("TestDocument.docx")

*** Keywords ***
Підготувати клієнт для користувача
  [Arguments]  @{ARGUMENTS}
  [Documentation]  Відкрити брaвзер, створити обєкт api wrapper, тощо
  ...      ${ARGUMENTS[0]} ==  username
  Open Browser   ${BROKERS['${USERS.users['${ARGUMENTS[0]}'].broker}'].url}   ${USERS.users['${ARGUMENTS[0]}'].browser}   alias=${ARGUMENTS[0]}
  Set Window Size       @{USERS.users['${ARGUMENTS[0]}'].size}
  Set Window Position   @{USERS.users['${ARGUMENTS[0]}'].position}
  Run Keyword And Ignore Error   Pre Login   ${ARGUMENTS[0]}

  Wait Until Page Contains Element    jquery=a[href="/cabinet"]
  Click Element                       jquery=a[href="/cabinet"]
  Wait Until Page Contains Element    name=email   10
  Input text    name=email     mail
  Sleep  1
  Input text    name=email      ${USERS.users['${username}'].login}
  Sleep  2
  Input text   name=psw        ${USERS.users['${username}'].password}
  Wait Until Page Contains Element   xpath=//button[contains(@class, 'btn')][./text()='Вхід в кабінет']   100
  Click Element                xpath=//button[contains(@class, 'btn')][./text()='Вхід в кабінет']

Pre Login
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...    ${ARGUMENTS[0]} ==  username
  Wait Until Page Contains Element   name=siteLogin   10
  Input text    name=siteLogin      ${BROKERS['${USERS.users['${username}'].broker}'].login}
  Input text   name=sitePass       ${BROKERS['${USERS.users['${username}'].broker}'].password}
  Click Button   xpath=.//*[@id='table1']/tbody/tr/td/form/p[3]/input

Створити тендер
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tender_data
  ${prepared_tender_data}=   Add_data_for_GUI_FrontEnds   ${ARGUMENTS[1]}
  ${items}=         Get From Dictionary   ${prepared_tender_data.data}               items
  ${title}=         Get From Dictionary   ${prepared_tender_data.data}               title
  ${description}=   Get From Dictionary   ${prepared_tender_data.data}               description
  ${budget}=        Get From Dictionary   ${prepared_tender_data.data.value}         amount
  ${step_rate}=     Get From Dictionary   ${prepared_tender_data.data.minimalStep}   amount
  ${items_description}=   Get From Dictionary   ${prepared_tender_data.data}         description
  ${quantity}=      Get From Dictionary   ${items[0]}         quantity
  ${countryName}=   Get From Dictionary   ${prepared_tender_data.data.procuringEntity.address}       countryName
  ${delivery_end_date}=      Get From Dictionary   ${items[0].deliveryDate}   endDate
  ${delivery_end_date}=      convert_date_to_slash_format   ${delivery_end_date}
  ${cpv}=           Convert To String   Картонки
  ${cpv_id}=           Get From Dictionary   ${items[0].classification}         id
  ${cpv_id1}=       Replace String   ${cpv_id}   -   _
  ${dkpp_desc}=     Get From Dictionary   ${items[0].additionalClassifications[0]}   description
  ${dkpp_id}=       Get From Dictionary   ${items[0].additionalClassifications[0]}  id
  ${dkpp_id1}=      Replace String   ${dkpp_id}   -   _
  ${enquiry_end_date}=   Get From Dictionary         ${prepared_tender_data.data.enquiryPeriod}   endDate
  ${enquiry_end_date}=   convert_date_to_slash_format   ${enquiry_end_date}
  ${end_date}=      Get From Dictionary   ${prepared_tender_data.data.tenderPeriod}   endDate
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
  Click Element                       xpath=//a[@class ='uploadFile']
  Choose File                         xpath=//a[@class ='uploadFile']       ${file_path}
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
  ${tender_UAid}=   Get Text          xpath=//*/section[6]/table/tbody/tr[2]/td[2]
  ${Ids}=   Convert To String         ${tender_UAid}
  Run keyword if   '${mode}' == 'multi'   Set Multi Ids   ${tender_UAid}
  [return]  ${Ids}

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
  Switch browser   ${ARGUMENTS[0]}
  Go to   ${BROKERS['${USERS.users['${username}'].broker}'].url}
  Wait Until Page Contains            Держзакупівлі.онлайн   10
#  sleep  1
  Click Element                       xpath=//a[text()='Закупівлі']
  Click Element                       xpath=//select[@name='filter[object]']/option[@value='tenderID']
  Input text                          xpath=//input[@name='filter[search]']  ${ARGUMENTS[1]}
  Click Element                       xpath=//button[@class='btn'][./text()='Пошук']
  Wait Until Page Contains    ${ARGUMENTS[1]}   10
  sleep  1
  Capture Page Screenshot

Задати питання
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tenderUaId
  ...      ${ARGUMENTS[2]} ==  questionId
  ${title}=        Get From Dictionary  ${ARGUMENTS[2].data}  title
  ${description}=  Get From Dictionary  ${ARGUMENTS[2].data}  description

  Selenium2Library.Switch Browser    ${ARGUMENTS[0]}
  netcast.Пошук тендера по ідентифікатору    ${ARGUMENTS[0]}   ${ARGUMENTS[1]}

  Click Element                       xpath=//a[@class='reverse tenderLink']
  Wait Until Page Contains Element    xpath=//a[@class='reverse openCPart'][span[text()='Обговорення']]    20
  Click Element                       xpath=//a[@class='reverse openCPart'][span[text()='Обговорення']]
  Wait Until Page Contains Element    name=title
  Input text                          name=title                 ${title}
  Input text                          xpath=//textarea[@name='description']           ${description}
  Click Element                       xpath=//div[contains(@class, 'buttons')]//button[@type='submit']
  Wait Until Page Contains            ${title}   30
  Capture Page Screenshot

Відповісти на питання
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} = username
  ...      ${ARGUMENTS[1]} = tenderUaId
  ...      ${ARGUMENTS[2]} = 0
  ...      ${ARGUMENTS[3]} = answer_data

  ${answer}=     Get From Dictionary  ${ARGUMENTS[3].data}  answer
  Selenium2Library.Switch Browser    ${ARGUMENTS[0]}
  netcast.Пошук тендера по ідентифікатору   ${ARGUMENTS[0]}   ${ARGUMENTS[1]}

  Click Element                      xpath=//a[@class='reverse tenderLink']
  Click Element                      xpath=//a[@class='reverse openCPart'][span[text()='Обговорення']]
  Input text                         xpath=//textarea[@name='answer']            ${answer}
  Click Element                      xpath=//div[1]/div[3]/form/div/table/tbody/tr/td[2]/button
  Wait Until Page Contains           ${answer}   30
  Capture Page Screenshot