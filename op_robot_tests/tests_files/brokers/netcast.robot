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
${locator.items[0].description}      xpath=//td[./text()='Предмет закупівлі']/following-sibling::td[1]
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
  Run Keyword And Ignore Error       Pre Login   ${ARGUMENTS[0]}
  Wait Until Page Contains Element   jquery=a[href="/cabinet"]
  Click Element                      jquery=a[href="/cabinet"]
  Run Keyword If                     '${username}' != 'Netcast_Viewer'   Login

Login
  [Arguments]  @{ARGUMENTS}
  Wait Until Page Contains Element   name=email   10
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
  ${cpv_id}=        Get From Dictionary   ${items[0].classification}         id
  ${cpv_id1}=       Replace String        ${cpv_id}   -   _
  ${dkpp_desc}=     Get From Dictionary   ${items[0].additionalClassifications[0]}   description
  ${dkpp_id}=       Get From Dictionary   ${items[0].additionalClassifications[0]}   id
  ${dkpp_id1}=      Replace String        ${dkpp_id}   -   _

  ${enquiry_end_date}=   Get From Dictionary         ${ARGUMENTS[1].data.enquiryPeriod}   endDate
  ${enquiry_end_date}=   convert_date_to_slash_format   ${enquiry_end_date}
  ${end_date}=      Get From Dictionary   ${ARGUMENTS[1].data.tenderPeriod}   endDate
  ${end_date}=      convert_date_to_slash_format   ${end_date}

  Selenium2Library.Switch Browser     ${ARGUMENTS[0]}
  Wait Until Page Contains Element    jquery=a[href="/tenders/new"]   30
  Click Element                       jquery=a[href="/tenders/new"]


  Wait Until Page Contains Element    name=tender_title   30
  Input text                          name=tender_title    ${title}
  Input text                          name=tender_description    ${description}
  Input text                          name=tender_value_amount   ${budget}
  Input text                          name=tender_minimalStep_amount   ${step_rate}

# Click Element             xpath=//a[@class='uploadFile']

  ${local_path} =           local_path_to_file   TestDocument.docx
  Choose File               xpath= //input[@name='upload']    ${local_path}


# Додати специфікацю початок
  Input text                          name=items[0][item_description]    ${items_description}
  Input text                          name=items[0][item_quantity]   ${quantity}
  Input text                          name=items[0][item_deliveryAddress_countryName]   ${countryName}
  Input text                          name=items[0][item_deliveryDate_endDate]       ${delivery_end_date}
  Click Element                       xpath=//a[contains(@data-class, 'cpv')][./text()='Визначити за довідником']
  sleep  1
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
# Додати специфікацю кінець


  Unselect Frame
  Input text                          name=plan_date                      ${enquiry_end_date}
  Input text                          name=tender_enquiryPeriod_endDate   ${enquiry_end_date}
  Input text                          name=tender_tenderPeriod_endDate    ${end_date}


  Додати предмет    ${items[0]}   0
  Run Keyword if   '${mode}' == 'multi'   Додати багато предметів   items
  Unselect Frame

  Click Element                       xpath= //button[@value='publicate']
  Wait Until Page Contains            Тендер опубліковано    30
  ${tender_UAid}=   Get Text          xpath=//td[./text()='TenderID']/following-sibling::td[1]
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
  ...      ${ARGUMENTS[1]} ==  ${INDEX}
  ${dkpp_desc1}=     Get From Dictionary   ${ARGUMENTS[0].additionalClassifications[0]}   description
  ${dkpp_id11}=      Get From Dictionary   ${ARGUMENTS[0].additionalClassifications[0]}   id
  ${dkpp_1id}=            Replace String   ${dkpp_id11}   -   _

  Wait Until Page Contains Element    xpath=//a[contains(@class, 'addMultiItem')][./text()='Додати предмет закупівлі']
  Click Element                       xpath=//a[contains(@class, 'addMultiItem')][./text()='Додати предмет закупівлі']
  ${index} =                          Convert To Integer     ${ARGUMENTS[1]}
  ${index} =                          Convert To Integer     ${index + 1}
  Wait Until Page Contains Element    name=items[${index}][item_description]   30
  Input text                          name=items[${index}][item_description]    ${description}
  Input text                          name=items[${index}][item_quantity]   ${quantity}

  Click Element                       xpath=(//a[contains(@data-class, 'cpv')][./text()='Визначити за довідником'])[${index} + 1]
  Select Frame                        xpath=//iframe[contains(@src,'/js/classifications/cpv/uk.htm?relation=true')]
  Input text                          id=search     ${cpv}
  Wait Until Page Contains            ${cpv_id}
  Click Element                       xpath=//a[contains(@id,'${cpv_id1}')]
  Click Element                       xpath=.//*[@id='select']
  Unselect Frame
  Click Element                       xpath=(//a[contains(@data-class, 'dkpp')][./text()='Визначити за довідником'])[${index} + 1]
  Select Frame                        xpath=//iframe[contains(@src,'/js/classifications/dkpp/uk.htm?relation=true')]
  Input text                          id=search     ${dkpp_desc1}
  Wait Until Page Contains            ${dkpp_id11}
  Click Element                       xpath=//a[contains(@id,'${dkpp_1id}')]
  Click Element                       xpath=.//*[@id='select']
  Unselect Frame
  Capture Page Screenshot

Додати багато предметів
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  items
  ${Items_length}=   Get Length   ${items}
  : FOR    ${INDEX}    IN RANGE    1    ${Items_length}
  \   Додати предмет   ${items[${INDEX}]}   ${INDEX}

додати предмети закупівлі
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} =  username
  ...      ${ARGUMENTS[1]} =  ${TENDER_UAID}
  ...      ${ARGUMENTS[2]} =  3
  ${tender_data}=  prepare_test_tender_data   ${BROKERS['${USERS.users['${tender_owner}'].broker}'].period_interval}   multi

  ${items}=         Get From Dictionary   ${tender_data.data}               items
  ${description}=   Get From Dictionary   ${tender_data.data}               description
  ${quantity}=      Get From Dictionary   ${items[0]}                       quantity
  ${cpv}=           Convert To String     Картонки
  ${cpv_id}=        Get From Dictionary   ${items[0].classification}         id
  ${cpv_id1}=       Replace String        ${cpv_id}   -   _
  ${dkpp_desc}=     Get From Dictionary   ${items[0].additionalClassifications[0]}   description
  ${dkpp_id}=       Get From Dictionary   ${items[0].additionalClassifications[0]}   id
  ${dkpp_id1}=      Replace String        ${dkpp_id}   -   _

  Selenium2Library.Switch Browser    ${ARGUMENTS[0]}
  Run keyword if   '${TEST NAME}' == 'Можливість додати позицію закупівлі в тендер'   додати позицію
  Run keyword if   '${TEST NAME}' != 'Можливість додати позицію закупівлі в тендер'   видалити позиції

додати позицію
  netcast.Пошук тендера по ідентифікатору   ${ARGUMENTS[0]}   ${ARGUMENTS[1]}
  Wait Until Page Contains Element           xpath=//a[./text()='Редагувати']   30
  Click Element                              xpath=//a[./text()='Редагувати']
  Додати багато предметів     ${ARGUMENTS[2]}
  Wait Until Page Contains Element           xpath=//button[./text()='Зберегти']   30
  Click Element                              xpath=//button[./text()='Зберегти']

видалити позиції
  netcast.Пошук тендера по ідентифікатору   ${ARGUMENTS[0]}   ${ARGUMENTS[1]}
  Wait Until Page Contains Element           xpath=//a[./text()='Редагувати']   30
  Click Element                              xpath=//a[./text()='Редагувати']
  : FOR    ${INDEX}    IN RANGE    1    ${ARGUMENTS[2]}-1
  \   sleep  5
  \   Click Element                          xpath=//a[@class='deleteMultiItem'][last()]
  \   sleep  5
  \   Click Element                          xpath=//a[@class='jBtn green']
  Wait Until Page Contains Element           xpath=//button[./text()='Зберегти']   30
  Click Element                              xpath=//button[./text()='Зберегти']

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
  sleep  1
  Execute Javascript                  window.scroll(2500,2500)
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
  Execute Javascript                  window.scroll(1500,1500)
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
  Execute Javascript                 window.scroll(1500,1500)
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
  Execute Javascript                 window.scroll(2500,2500)
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
  ...      ${ARGUMENTS[1]} = tenderUaId

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
  sleep  1
  ${return_value}=   Get Text  ${locator.${fieldname}}
  [return]  ${return_value}

отримати інформацію про title
  ${title}=   отримати тест із поля і показати на сторінці   title
  [return]  ${title.split('.')[0]}

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
  ${enquiryPeriodEndDate}=   subtract_from_time   ${enquiryPeriodEndDate}   6   5
  [return]  ${enquiryPeriodEndDate}

отримати інформацію про tenderPeriod.endDate
  ${tenderPeriodEndDate}=   отримати тест із поля і показати на сторінці   tenderPeriod.endDate
  ${tenderPeriodEndDate}=   subtract_from_time    ${tenderPeriodEndDate}   11   0
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
  log  ${questionsDate}
  [return]  ${questionsDate}

отримати інформацію про questions[0].answer
  sleep  1
  Click Element                       xpath=//a[@class='reverse tenderLink']
  sleep  1
  Click Element                       xpath=//a[@class='reverse openCPart'][span[text()='Обговорення']]
  ${questionsAnswer}=   отримати тест із поля і показати на сторінці   questions[0].answer
  [return]  ${questionsAnswer}

отримати інформацію про items[0].deliveryDate.endDate
  ${deliveryDateEndDate}=   отримати тест із поля і показати на сторінці   items[0].deliveryDate.endDate
  ${deliveryDateEndDate}=   subtract_from_time    ${deliveryDateEndDate}   15   0
  [return]  ${deliveryDateEndDate}

отримати інформацію про items[0].classification.id
  ${classificationId}=   отримати тест із поля і показати на сторінці   items[0].classification.id
  [return]  ${classificationId}

отримати інформацію про items[0].classification.description
  ${classificationDescription}=   отримати тест із поля і показати на сторінці     items[0].classification.description
  ${classificationDescription}=   Run keyword if   '${classificationDescription}' == 'Картонки'    Convert To String  Cartons
  [return]  ${classificationDescription}

отримати інформацію про items[0].additionalClassifications[0].id
  ${additionalClassificationsId}=   отримати тест із поля і показати на сторінці     items[0].additionalClassifications[0].id
  [return]  ${additionalClassificationsId}

отримати інформацію про items[0].additionalClassifications[0].description
  ${additionalClassificationsDescription}=   отримати тест із поля і показати на сторінці     items[0].additionalClassifications[0].description
  ${additionalClassificationsDescription}=   Convert To Lowercase   ${additionalClassificationsDescription}
  [return]  ${additionalClassificationsDescription}

отримати інформацію про items[0].quantity
  ${itemsQuantity}=   отримати тест із поля і показати на сторінці     items[0].quantity
  ${itemsQuantity}=   Convert To Integer    ${itemsQuantity}
  [return]  ${itemsQuantity}

отримати інформацію про items[0].unit.code
  ${unitCode}=   отримати тест із поля і показати на сторінці     items[0].unit.code
  ${unitCode}=   Run keyword if    '${unitCode}'== 'кг'   Convert To String  KGM
  [return]  ${unitCode}

отримати інформацію про procuringEntity.name
  Log       | Viewer can't see this information on Netcast        console=yes

отримати інформацію про enquiryPeriod.startDate
  Log       | Viewer can't see this information on Netcast        console=yes

отримати інформацію про tenderPeriod.startDate
  Log       | Viewer can't see this information on Netcast        console=yes

отримати інформацію про items[0].deliveryLocation.longitude
  Log       | Viewer can't see this information on Netcast        console=yes

отримати інформацію про items[0].deliveryLocation.latitude
  Log       | Viewer can't see this information on Netcast        console=yes

отримати інформацію про items[0].deliveryAddress.postalCode
  Log       | Viewer can't see this information on Netcast        console=yes

отримати інформацію про items[0].deliveryAddress.locality
  Log       | Viewer can't see this information on Netcast        console=yes

отримати інформацію про items[0].deliveryAddress.streetAddress
  Log       | Viewer can't see this information on Netcast        console=yes

отримати інформацію про items[0].deliveryAddress.region
  Log       | Viewer can't see this information on Netcast        console=yes

отримати інформацію про items[0].unit.name
  Log       | Viewer can't see this information on Netcast        console=yes
