*** Setting ***
Library  Selenium2Screenshots
Library  String
Library  DateTime

*** Variables ***
${file_path}                         local_path_to_file("TestDocument.docx")
${locator.tenderId}                  xpath=//td[./text()='TenderID']/following-sibling::td[1]
${locator.title}                     xpath=//td[./text()='Загальна назва закупівлі']/following-sibling::td[1]
${locator.description}               xpath=//td[./text()='Предмет закупівлі']/following-sibling::td[1]
${locator.value.amount}              xpath=//td[./text()='Максимальний бюджет']/following-sibling::td[1]
${locator.minimalStep.amount}        xpath=//td[./text()='Крок зменшення ціни']/following-sibling::td[1]
${locator.enquiryPeriod.endDate}     xpath=//td[./text()='Завершення періоду обговорення']/following-sibling::td[1]
${locator.tenderPeriod.endDate}      xpath=//td[./text()='Завершення періоду прийому пропозицій']/following-sibling::td[1]
${locator.items[0].deliveryAddress.countryName}    xpath=//td[@class='nameField'][./text()='Адреса поставки']/following-sibling::td[1]
${locator.items[0].deliveryDate}     xpath=//td[./text()='Кінцева дата поставки']/following-sibling::td[1]
${locator.items[0].classification.scheme}          xpath=//td[@class = 'nameField'][./text()='Клас CPV']
${locator.items[0].additionalClassifications[0].scheme}   xpath=//td[@class = 'nameField'][./text()='Клас ДКПП']
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
  Run Keyword And Ignore Error       Pre Login   ${ARGUMENTS[0]}
  Wait Until Page Contains Element   jquery=a[href="/cabinet"]
  Click Element                      jquery=a[href="/cabinet"]
  Run Keyword If                     '${username}' != 'Netcast_Viewer'   Login

Login
  [Arguments]  @{ARGUMENTS}
  Wait Until Page Contains Element   name=email   10
  Input text    name=email     mail
  Sleep  1
  Input text                         name=email      ${USERS.users['${username}'].login}
  Sleep  2
  Input text                         name=psw        ${USERS.users['${username}'].password}
  Wait Until Page Contains Element   xpath=//button[contains(@class, 'btn')][./text()='Вхід в кабінет']   20
  Click Element                      xpath=//button[contains(@class, 'btn')][./text()='Вхід в кабінет']

Pre Login
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...    ${ARGUMENTS[0]} ==  username
  Wait Until Page Contains Element   name=siteLogin   10
  Input text                         name=siteLogin      ${BROKERS['${USERS.users['${username}'].broker}'].login}
  Input text                         name=sitePass       ${BROKERS['${USERS.users['${username}'].broker}'].password}
  Click Button                       xpath=.//*[@id='table1']/tbody/tr/td/form/p[3]/input

Створити тендер
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tender_data
  #{tender_data}=   Add_time_for_GUI_FrontEnds   ${ARGUMENTS[1]}
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
  ${cpv}=           Convert To String   Картонки
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
  Click Element                       xpath=//a[text()='Закупівлі']
  sleep  1
  Click Element                       xpath=//select[@name='filter[object]']/option[@value='tenderID']
  Input text                          xpath=//input[@name='filter[search]']  ${ARGUMENTS[1]}
  Click Element                       xpath=//button[@class='btn'][./text()='Пошук']
  Wait Until Page Contains            ${ARGUMENTS[1]}   10
  Capture Page Screenshot
  sleep  1
  Click Element                       xpath=//a[@class='reverse tenderLink']

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

  Wait Until Page Contains Element    xpath=//a[@class='reverse openCPart'][span[text()='Обговорення']]    20
  Click Element                       xpath=//a[@class='reverse openCPart'][span[text()='Обговорення']]
  Wait Until Page Contains Element    name=title    20
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
  Selenium2Library.Switch Browser     ${ARGUMENTS[0]}
  netcast.Пошук тендера по ідентифікатору   ${ARGUMENTS[0]}   ${ARGUMENTS[1]}

  Wait Until Page Contains Element    xpath=//a[@class='reverse openCPart'][span[text()='Обговорення']]    20
  Click Element                       xpath=//a[@class='reverse openCPart'][span[text()='Обговорення']]
  Wait Until Page Contains Element    xpath=//textarea[@name='answer']    20
  Input text                          xpath=//textarea[@name='answer']            ${answer}
  Click Element                       xpath=//div[1]/div[3]/form/div/table/tbody/tr/td[2]/button
  Wait Until Page Contains            ${answer}   30
  Capture Page Screenshot

Подати скаргу
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} = username
  ...      ${ARGUMENTS[1]} = tenderUaId
  ...      ${ARGUMENTS[2]} = complaintsId
  ${complaint}=        Get From Dictionary  ${ARGUMENTS[2].data}  title
  ${description}=      Get From Dictionary  ${ARGUMENTS[2].data}  description

  Selenium2Library.Switch Browser    ${ARGUMENTS[0]}
  netcast.Пошук тендера по ідентифікатору   ${ARGUMENTS[0]}   ${ARGUMENTS[1]}
  sleep  1
  Click Element                      xpath=//a[@class='reverse openCPart'][span[text()='Скарги']]
  Wait Until Page Contains Element   name=title    20
  Input text                         name=title                 ${complaint}
  Input text                         xpath=//textarea[@name='description']           ${description}
  Click Element                      xpath=//div[contains(@class, 'buttons')]//button[@type='submit']
  Wait Until Page Contains           ${complaint}   30
  Capture Page Screenshot

Порівняти скаргу
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} = username
  ...      ${ARGUMENTS[1]} = tenderUaId
  ...      ${ARGUMENTS[2]} = complaintsData
  ${complaint}=        Get From Dictionary  ${ARGUMENTS[2].data}  title
  ${description}=      Get From Dictionary  ${ARGUMENTS[2].data}  description

  Selenium2Library.Switch Browser    ${ARGUMENTS[0]}
  netcast.Пошук тендера по ідентифікатору   ${ARGUMENTS[0]}   ${ARGUMENTS[1]}
  sleep  1
  Click Element                      xpath=//a[@class='reverse openCPart'][span[text()='Скарги']]
  Wait Until Page Contains           ${complaint}   30
  Capture Page Screenshot



Внести зміни в тендер
  #  Тест написано для уже існуючого тендеру, що знаходиться у чернетках користувача
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} = username
  ...      ${ARGUMENTS[1]} = description

  Selenium2Library.Switch Browser    ${ARGUMENTS[0]}
  Click Element                      xpath=//a[@class='reverse'][./text()='Мої закупівлі']
  Wait Until Page Contains Element   xpath=//a[@class='reverse'][./text()='Чернетки']   30
  Click Element                      xpath=//a[@class='reverse'][./text()='Чернетки']
  Wait Until Page Contains Element   xpath=//a[@class='reverse tenderLink']    30
  Click Element                      xpath=//a[@class='reverse tenderLink']
  sleep  1
  Click Element                      xpath=//a[@class='button save'][./text()='Редагувати']
  sleep  1
  Input text                         name=tender_title   ${ARGUMENTS[1]}
  sleep  1
  Click Element                      xpath=//button[@class='saveDraft']
  Wait Until Page Contains           ${ARGUMENTS[1]}   30
  Capture Page Screenshot

обновити сторінку з тендером
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} = username
  ...      ${ARGUMENTS[1]} = description

  Selenium2Library.Switch Browser    ${ARGUMENTS[0]}
  netcast.Пошук тендера по ідентифікатору    ${ARGUMENTS[0]}   ${ARGUMENTS[1]}
  Reload Page

отримати інформацію із тендера
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  fieldname
  Switch browser   ${ARGUMENTS[0]}
  ${return_value}=  run keyword  отримати інформацію про ${ARGUMENTS[1]}
  [return]  ${return_value}

отримати тест із поля і показати на сторінці
  [Arguments]   ${fieldname}
  sleep  5
  ${return_value}=   Get Text  ${locator.${fieldname}}
  [return]  ${return_value}

отримати інформацію про title
  ${title}=   отримати тест із поля і показати на сторінці   title
  [return]  ${title}

отримати інформацію про description
  ${description}=   отримати тест із поля і показати на сторінці   description
  [return]  ${description}

отримати інформацію про tenderId
  ${tenderId}=   отримати тест із поля і показати на сторінці   tenderId
  [return]  ${tenderId}

отримати інформацію про value.amount
  ${valueAmount}=   отримати тест із поля і показати на сторінці   value.amount
  ${valueAmount}=   Convert To Number   ${valueAmount.split(' ')[0]}
  [return]  ${valueAmount}

отримати інформацію про minimalStep.amount
  ${minimalStepAmount}=   отримати тест із поля і показати на сторінці   minimalStep.amount
  ${minimalStepAmount}=   Convert To Number   ${minimalStepAmount.split(' ')[0]}
  [return]  ${minimalStepAmount}

отримати інформацію про enquiryPeriod.endDate
  ${enquiryPeriodEndDate}=   отримати тест із поля і показати на сторінці   enquiryPeriod.endDate
  [return]  ${enquiryPeriodEndDate}

отримати інформацію про tenderPeriod.endDate
  ${tenderPeriodEndDate}=   отримати тест із поля і показати на сторінці   tenderPeriod.endDate
  [return]  ${tenderPeriodEndDate}

отримати інформацію про items[0].deliveryAddress.countryName
  ${countryName}=   отримати тест із поля і показати на сторінці   items[0].deliveryAddress.countryName
  [return]  ${countryName}

отримати інформацію про items[0].classification.scheme
  ${classificationScheme}=   отримати тест із поля і показати на сторінці   items[0].classification.scheme
  [return]  ${classificationScheme.split(' ')[1]}

отримати інформацію про items[0].additionalClassifications[0].scheme
  ${additionalClassificationsScheme}=   отримати тест із поля і показати на сторінці   items[0].additionalClassifications[0].scheme
  [return]  ${additionalClassificationsScheme.split(' ')[1]}

отримати інформацію про questions[0].title
  sleep  1
  Click Element                       xpath=//a[@class='reverse tenderLink']
  sleep  1
  Click Element                       xpath=//a[@class='reverse openCPart'][span[text()='Обговорення']]
  ${questionsTitle}=   отримати тест із поля і показати на сторінці   questions[0].title
  ${questionsTitle}=   Convert To Lowercase   ${questionsTitle}
  [return]  ${questionsTitle.capitalize().split('.')[0] + '.'}

отримати інформацію про questions[0].description
  ${questionsDescription}=   отримати тест із поля і показати на сторінці   questions[0].description
  [return]  ${questionsDescription}

отримати інформацію про questions[0].date
  ${questionsDate}=   отримати тест із поля і показати на сторінці   questions[0].date
  [return]  ${questionsDate}

отримати інформацію про questions[0].answer
  sleep  1
  Click Element                       xpath=//a[@class='reverse tenderLink']
  sleep  1
  Click Element                       xpath=//a[@class='reverse openCPart'][span[text()='Обговорення']]
  ${questionsAnswer}=   отримати тест із поля і показати на сторінці   questions[0].answer
  [return]  ${questionsAnswer}
