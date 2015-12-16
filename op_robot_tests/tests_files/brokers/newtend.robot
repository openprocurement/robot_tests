*** Settings ***
Library  Selenium2Screenshots
Library  String
Library  DateTime
Library  newtend_service.py

*** Variables ***
${locator.title}                     xpath=//div[@ng-bind="tender.title"]
${locator.description}               xpath=//div[@ng-bind="tender.description"]
${locator.edit.description}          name=tenderDescription
${locator.value.amount}              xpath=//div[@ng-bind="tender.value.amount"]
${locator.minimalStep.amount}        xpath=//div[@ng-bind="tender.minimalStep.amount"]
${locator.tenderId}                  xpath=//a[@class="ng-binding ng-scope"]
${locator.procuringEntity.name}      xpath=//div[@ng-bind="tender.procuringEntity.name"]
${locator.enquiryPeriod.StartDate}   id=start-date-qualification
${locator.enquiryPeriod.endDate}     id=end-date-qualification
${locator.tenderPeriod.startDate}    id=start-date-registration
${locator.tenderPeriod.endDate}      id=end-date-registration
${locator.items[0].deliveryAddress}                             id=deliveryAddress
${locator.items[0].deliveryDate.endDate}                        id=end-date-delivery
${locator.items[0].description}                                 xpath=//div[@ng-bind="item.description"]
${locator.items[0].classification.scheme}                       id=classifier
${locator.items[0].classification.scheme.title}                 xpath=//label[contains(., "Классификатор CPV")]
${locator.items[0].additional_classification[0].scheme}         id=classifier2
${locator.items[0].additional_classification[0].scheme.title}   xpath=//label[@for="classifier2"]
${locator.items[0].quantity}                                    id=quantity
${locator.items[0].unit.name}                                   xpath=//span[@class="unit ng-binding"]
${locator.edit_tender}     xpath=//button[@ng-if="actions.can_edit_tender"]
${locator.edit.add_item}   xpath=//a[@class="icon-black plus-black remove-field ng-scope"]
${locator.save}            xpath=//button[@class="btn btn-lg btn-default cancel pull-right ng-binding"]
${locator.QUESTIONS[0].title}         xpath=//span[@class="user ng-binding"]
${locator.QUESTIONS[0].description}   xpath=//span[@class="question-description ng-binding"]
${locator.QUESTIONS[0].date}          xpath=//span[@class="date ng-binding"]

*** Keywords ***
Підготувати дані для оголошення тендера
  ${INITIAL_TENDER_DATA}=  prepare_test_tender_data
  ${INITIAL_TENDER_DATA}=  Add_data_for_GUI_FrontEnds  ${INITIAL_TENDER_DATA}
  ${INITIAL_TENDER_DATA}=  Update_data_for_Newtend  ${INITIAL_TENDER_DATA}
  [return]   ${INITIAL_TENDER_DATA}

Підготувати клієнт для користувача
  [Arguments]  @{ARGUMENTS}
  [Documentation]  Відкрити браузер, створити об’єкт api wrapper, тощо
  ...      ${ARGUMENTS[0]} ==  username
  Open Browser
  ...      ${USERS.users['${ARGUMENTS[0]}'].homepage}
  ...      ${USERS.users['${ARGUMENTS[0]}'].browser}
  ...      alias=${ARGUMENTS[0]}
  Set Window Size   @{USERS.users['${ARGUMENTS[0]}'].size}
  Set Window Position   @{USERS.users['${ARGUMENTS[0]}'].position}
  Run Keyword If   '${username}' != 'Newtend_Viewer'   Login

Login
  Wait Until Page Contains Element   id=indexpage_login   20
  Click Element   id=indexpage_login
  Wait Until Page Contains Element   id=password   20
  Input text   id=login-email   ${USERS.users['${username}'].login}
  Input text   id=password   ${USERS.users['${username}'].password}
  Click Element   id=submit-login-button
  Wait Until Page Contains Element   xpath =//a[@class="close-modal-dialog"]  20
  Go to   ${USERS.users['${ARGUMENTS[0]}'].homepage}
#  Wait Until Page Contains Element   xpath=//div[@class="introjs-overlay"]   20

Створити тендер
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tender_data
## Initialisation
  ${prepared_tender_data}=  Add_data_for_GUI_FrontEnds  ${ARGUMENTS[1]}
  ${prepared_tender_data}=  Update_data_for_Newtend  ${prepared_tender_data}
  ${items}=         Get From Dictionary   ${prepared_tender_data.data}               items
  ${title}=         Get From Dictionary   ${prepared_tender_data.data}               title
  ${description}=   Get From Dictionary   ${prepared_tender_data.data}               description
  ${budget}=        Get From Dictionary   ${prepared_tender_data.data.value}         amount
  ${step_rate}=     Get From Dictionary   ${prepared_tender_data.data.minimalStep}   amount
  ${start_date}=           Get From Dictionary   ${prepared_tender_data.data.tenderPeriod}    startDate
  ${end_date}=             Get From Dictionary   ${prepared_tender_data.data.tenderPeriod}    endDate
  ${enquiry_start_date}=   Get From Dictionary   ${prepared_tender_data.data.enquiryPeriod}   startDate
  ${enquiry_end_date}=     Get From Dictionary   ${prepared_tender_data.data.enquiryPeriod}   endDate

  Selenium2Library.Switch Browser    ${ARGUMENTS[0]}
  Go To                              ${USERS.users['${username}'].homepage}
  Wait Until Page Contains Element   xpath=//a[@href="#/create-tender"]   100
  Click Link                         xpath=//a[@href="#/create-tender"]
  Wait Until Page Contains           Новый тендер   100
# Input fields tender
  Input text   name=tenderName       ${title}
  Input text   ${locator.edit.description}   ${description}
  Input text   id=budget             ${budget}
  Click Element                      id=with-nds
  Input text   id=step               ${step_rate}
# Add Item(s)
  Додати придмет   ${items[0]}   0
  Run Keyword If   '${mode}' == 'multi'     Додати багато придметів   items
# Set tender datatimes
  Set datetime   start-date-registration    ${start_date}
  Set datetime   end-date-registration      ${end_date}
  Set datetime   end-date-qualification     ${enquiry_end_date}
  Set datetime   start-date-qualification   ${enquiry_start_date}
# Save
  Click Element                      ${locator.save}
  Wait Until Page Contains Element   xpath=//div[@ng-click="goHome()"]   30
  Click Element                      xpath=//div[@ng-click="goHome()"]
# Get Ids
  Wait Until Page Contains Element   xpath=//div[@class="title"]   30
  ${tender_UAid}=         Get Text   xpath=//div[@class="title"]
  ${Ids}=        Convert To String   ${tender_UAid}
  Run keyword if   '${mode}' == 'multi'   Set Multi Ids   ${tender_UAid}
  [return]  ${Ids}

Set Multi Ids
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  ${tender_UAid}
  ${current_location}=      Get Location
  ${id}=    Get Substring   ${current_location}   -41   -9
  ${Ids}=   Create List     ${tender_UAid}   ${id}

Set datetime
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  control_id
  ...      ${ARGUMENTS[1]} ==  date
#Pick Date
  Click Element       xpath=//input[@id="${ARGUMENTS[0]}"]/../span[@class="calendar-btn"]
  Wait Until Page Contains Element            xpath=//td[@class="text-center ng-scope"]   30
  ${datapicker_id}=   Get Element Attribute   xpath=//input[@id="${ARGUMENTS[0]}"]/..//td[@class="text-center ng-scope"]@id
  ${datapicker_id}=   Get Substring           ${datapicker_id}   0   -1
  ${date_index}=      newtend_date_picker_index   ${ARGUMENTS[1]}
  ${datapicker_id}=   Convert To String       ${datapicker_id}${date_index}
  Click Element       xpath=//input[@id="${ARGUMENTS[0]}"]/..//td[@id="${datapicker_id}"]/button
#Set time
  ${hous}=   Get Substring   ${ARGUMENTS[1]}   11   13
  ${minutes}=   Get Substring   ${ARGUMENTS[1]}   14   16
  Input text   xpath=//input[@id="${ARGUMENTS[0]}"]/../..//input[@ng-model="hours"]   ${hous}
  Input text   xpath=//input[@id="${ARGUMENTS[0]}"]/../..//input[@ng-model="minutes"]   ${minutes}

Додати придмет
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  items_n
  ...      ${ARGUMENTS[1]} ==  index
## Get values for item
  ${items_description}=   Get From Dictionary   ${ARGUMENTS[0]}                          description
  ${quantity}=      Get From Dictionary   ${ARGUMENTS[0]}                                quantity
  ${cpv}=           Convert To String     Картонки
  ${dkpp_desc}=     Get From Dictionary   ${ARGUMENTS[0].additionalClassifications[0]}   description
  ${dkpp_id}=       Get From Dictionary   ${ARGUMENTS[0].additionalClassifications[0]}   id
  ${unit}=          Get From Dictionary   ${ARGUMENTS[0].unit}                           name
  ${deliverydate_end_date}=   Get From Dictionary   ${ARGUMENTS[0].deliveryDate}   endDate
  ${countryName}=     Get From Dictionary   ${ARGUMENTS[0].deliveryAddress}   countryName
  ${ZIP}=             Get From Dictionary   ${ARGUMENTS[0].deliveryAddress}   postalCode
  ${region}=          Get From Dictionary   ${ARGUMENTS[0].deliveryAddress}   region
  ${locality}=        Get From Dictionary   ${ARGUMENTS[0].deliveryAddress}   locality
  ${streetAddress}=   Get From Dictionary   ${ARGUMENTS[0].deliveryAddress}   streetAddress

  Set datetime   end-date-delivery${ARGUMENTS[1]}         ${deliverydate_end_date}
# Set CPV
  Wait Until Page Contains Element   id=classifier1${ARGUMENTS[1]}
  Click Element                      id=classifier1${ARGUMENTS[1]}
  Wait Until Page Contains Element   xpath=//input[@class="ng-pristine ng-untouched ng-valid"]   100
  Input text                         xpath=//input[@class="ng-pristine ng-untouched ng-valid"]   ${cpv}
  Wait Until Page Contains Element   xpath=//span[contains(text(),'${cpv}')]   20
  Click Element                      xpath=//input[@class="ng-pristine ng-untouched ng-valid"]
  Click Element                      xpath=//button[@class="btn btn-default btn-lg pull-right choose ng-binding"]
# Set ДКПП
  Click Element                      id=classifier2${ARGUMENTS[1]}
  Wait Until Page Contains Element   xpath=//input[@class="ng-pristine ng-untouched ng-valid"]   100
  Input text                         xpath=//input[@class="ng-pristine ng-untouched ng-valid"]   ${dkpp_desc}
  Wait Until Page Contains Element   xpath=//span[contains(text(),'${dkpp_id}')]   100
  Click Element                      xpath=//span[contains(text(),'${dkpp_id}')]/../..//input[@class="ng-pristine ng-untouched ng-valid"]
  Click Element                      xpath=//button[@class="btn btn-default btn-lg pull-right choose ng-binding"]
# Set Delivery Address
  Click Element                      id=deliveryAddress${ARGUMENTS[1]}
  Wait Until Page Contains Element   xpath=//input[@ng-model="deliveryAddress.postalCode"]   20
  Input text                         xpath=//input[@ng-model="deliveryAddress.postalCode"]   ${ZIP}
  Input text                         xpath=//input[@ng-model="deliveryAddress.region"]   ${region}
  Input text                         xpath=//input[@ng-model="deliveryAddress.locality"]   ${locality}
  Input text                         xpath=//input[@ng-model="deliveryAddress.streetAddress"]   ${streetAddress}
  Click Element                      xpath=//button[@class="btn btn-lg single-btn ng-binding"]
# Add item main info
  Click Element                      xpath=//a[contains(text(), "единицы измерения")]
  Click Element                      xpath=//a[contains(text(), "единицы измерения")]/..//a[contains(text(), '${unit}')]
  Input text   id=quantity${ARGUMENTS[1]}          ${quantity}
  Input text   id=itemDescription${ARGUMENTS[1]}   ${items_description}

Додати багато придметів
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  items
  ${Items_length}=   Get Length   ${items}
  : FOR    ${INDEX}    IN RANGE    1    ${Items_length}
  \   Click Element   ${locator.edit.add_item}
  \   Додати придмет   ${items[${INDEX}]}   ${INDEX}

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

Пошук тендера по ідентифікатору
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  ${TENDER_UAID}
  Switch browser   ${ARGUMENTS[0]}
  Go to   ${USERS.users['${ARGUMENTS[0]}'].homepage}
### Індексація на тестовому сервері відключена, як наслідок пошук по UAid не працює, отож застосовую обхід цієї функціональності для розблокування наступних тестів
#  Wait Until Page Contains Element   xpath=//div[@class="search-field"]/input   20
#  #${ARGUMENTS[1]}=   Convert To String   UA-2015-06-08-000023
#  Input text                         xpath=//div[@class="search-field"]/input   ${ARGUMENTS[1]}
#  : FOR    ${INDEX}    IN RANGE    1    30
#  \   Log To Console   .   no_newline=true
#  \   sleep       1
#  \   ${count}=   Get Matching Xpath Count   xpath=//a[@class="row tender-info ng-scope"]
#  \   Exit For Loop If  '${count}' == '1'
  Sleep   2
  Go to   ${USERS.users['${ARGUMENTS[0]}'].homepage}
  ${ARGUMENTS[1]}=   Convert To String   Воркераунд для проходженя наступних тестів - пошук не працює.
###
  Wait Until Page Contains Element   xpath=(//a[@class="row tender-info ng-scope"])   20
  Sleep   5
  Click Element                      xpath=(//a[@class="row tender-info ng-scope"])
  Wait Until Page Contains Element   xpath=//a[@class="ng-binding ng-scope"]|//span[@class="ng-binding ng-scope"]   30

отримати інформацію із тендера
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  fieldname
  Switch browser   ${ARGUMENTS[0]}
  Run Keyword And Return  Отримати інформацію про ${ARGUMENTS[1]}

отримати текст із поля і показати на сторінці
  [Arguments]   ${fieldname}
  sleep  1
  ${return_value}=   Get Text  ${locator.${fieldname}}
  [return]  ${return_value}

отримати інформацію про title
  ${title}=   отримати текст із поля і показати на сторінці   title
  [return]  ${title}

отримати інформацію про description
  ${description}=   отримати текст із поля і показати на сторінці   description
  [return]  ${description}

отримати інформацію про tenderId
  ${tenderId}=   отримати текст із поля і показати на сторінці   tenderId
  [return]  ${tenderId}

отримати інформацію про value.amount
  ${valueAmount}=   отримати текст із поля і показати на сторінці   value.amount
  ${valueAmount}=   Convert To Number   ${valueAmount.split(' ')[0]}
  [return]  ${valueAmount}

отримати інформацію про minimalStep.amount
  ${minimalStepAmount}=   отримати текст із поля і показати на сторінці   minimalStep.amount
  ${minimalStepAmount}=   Convert To Number   ${minimalStepAmount.split(' ')[0]}
  [return]  ${minimalStepAmount}

Внести зміни в тендер
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  id
  ...      ${ARGUMENTS[2]} ==  fieldname
  ...      ${ARGUMENTS[3]} ==  fieldvalue
  Switch browser   ${ARGUMENTS[0]}
  Click button     ${locator.edit_tender}
  Wait Until Page Contains Element   ${locator.edit.${ARGUMENTS[2]}}   20
  Input Text       ${locator.edit.${ARGUMENTS[2]}}   ${ARGUMENTS[3]}
  Click Element    ${locator.save}
  Wait Until Page Contains Element   ${locator.${ARGUMENTS[2]}}    20
  ${result_field}=   отримати текст із поля і показати на сторінці   ${ARGUMENTS[2]}
  Should Be Equal   ${result_field}   ${ARGUMENTS[3]}

отримати інформацію про procuringEntity.name
  ${procuringEntity_name}=   отримати текст із поля і показати на сторінці   procuringEntity.name
  [return]  ${procuringEntity_name}

отримати інформацію про enquiryPeriod.endDate
  ${enquiryPeriodEndDate}=   отримати текст із поля і показати на сторінці   enquiryPeriod.endDate
  [return]  ${enquiryPeriodEndDate}

отримати інформацію про tenderPeriod.startDate
  ${tenderPeriodStartDate}=   отримати текст із поля і показати на сторінці   tenderPeriod.startDate
  [return]  ${tenderPeriodStartDate}

отримати інформацію про tenderPeriod.endDate
  ${tenderPeriodEndDate}=   отримати текст із поля і показати на сторінці   tenderPeriod.endDate
  [return]  ${tenderPeriodEndDate}

отримати інформацію про enquiryPeriod.startDate
  ${enquiryPeriodStartDate}=   отримати текст із поля і показати на сторінці   enquiryPeriod.StartDate
  [return]  ${enquiryPeriodStartDate}

отримати інформацію про items[0].description
  ${description}=   отримати текст із поля і показати на сторінці   items[0].description
  [return]  ${description}

отримати інформацію про items[0].deliveryDate.endDate
  ${deliveryDate_endDate}=   отримати текст із поля і показати на сторінці   items[0].deliveryDate.endDate
  [return]  ${deliveryDate_endDate}

отримати інформацію про items[0].deliveryLocation.latitude
  Fail  Не реалізований функціонал

отримати інформацію про items[0].deliveryLocation.longitude
  Fail  Не реалізований функціонал

## Delivery Address
отримати інформацію про items[0].deliveryAddress.countryName
  ${Delivery_Address}=   отримати текст із поля і показати на сторінці   items[0].deliveryAddress
  [return]  ${Delivery_Address.split(', ')[1]}

отримати інформацію про items[0].deliveryAddress.postalCode
  ${Delivery_Address}=   отримати текст із поля і показати на сторінці   items[0].deliveryAddress
  [return]  ${Delivery_Address.split(', ')[0]}

отримати інформацію про items[0].deliveryAddress.region
  ${Delivery_Address}=   отримати текст із поля і показати на сторінці   items[0].deliveryAddress
  [return]  ${Delivery_Address.split(', ')[2]}

отримати інформацію про items[0].deliveryAddress.locality
  ${Delivery_Address}=   отримати текст із поля і показати на сторінці   items[0].deliveryAddress
  [return]  ${Delivery_Address.split(', ')[3]}

отримати інформацію про items[0].deliveryAddress.streetAddress
  ${Delivery_Address}=   отримати текст із поля і показати на сторінці   items[0].deliveryAddress
  ${Delivery_Address}=   Get Substring   ${Delivery_Address}=    0   -2
  [return]  ${Delivery_Address.split(', ')[4]}

##CPV
отримати інформацію про items[0].classification.scheme
  ${classificationScheme}=   отримати текст із поля і показати на сторінці   items[0].classification.scheme.title
  [return]  ${classificationScheme.split(' ')[1]}

отримати інформацію про items[0].classification.id
  ${classification_id}=   отримати текст із поля і показати на сторінці   items[0].classification.scheme
  [return]  ${classification_id.split(' - ')[0]}

отримати інформацію про items[0].classification.description
  ${classification_description}=   отримати текст із поля і показати на сторінці   items[0].classification.scheme
  Run Keyword And Return If  '${classification_description}' == '44617100-9 - Картонки'   Convert To String   Cartons
  [return]  ${classification_description}

##ДКПП
отримати інформацію про items[0].additionalClassifications[0].scheme
  ${additional_classificationScheme}=   отримати текст із поля і показати на сторінці   items[0].additional_classification[0].scheme.title
  [return]  ${additional_classificationScheme.split(' ')[1]}

отримати інформацію про items[0].additionalClassifications[0].id
  ${additional_classification_id}=   отримати текст із поля і показати на сторінці   items[0].additional_classification[0].scheme
  [return]  ${additional_classification_id.split(' - ')[0]}

отримати інформацію про items[0].additionalClassifications[0].description
  ${additional_classification_description}=   отримати текст із поля і показати на сторінці   items[0].additional_classification[0].scheme
  ${additional_classification_description}=   Convert To Lowercase   ${additional_classification_description}
  ${additional_classification_description}=   Get Substring   ${additional_classification_description}=    0   -2
  [return]  ${additional_classification_description.split(' - ')[1]}

##item
отримати інформацію про items[0].unit.name
  ${unit_name}=   отримати текст із поля і показати на сторінці   items[0].unit.name
  Run Keyword And Return If  '${unit_name}' == 'килограммы'   Convert To String   кілограм
  [return]  ${unit_name}

отримати інформацію про items[0].unit.code
  Fail  Не реалізований функціонал
  ${unit_code}=   отримати текст із поля і показати на сторінці   items[0].unit.code
  [return]  ${unit_code}

отримати інформацію про items[0].quantity
  ${quantity}=   отримати текст із поля і показати на сторінці   items[0].quantity
  ${quantity}=   Convert To Number   ${quantity}
  [return]  ${quantity}

додати предмети закупівлі
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} =  username
  ...      ${ARGUMENTS[1]} =  ${TENDER_UAID}
  ...      ${ARGUMENTS[2]} =  3
  ${period_interval}=  Get Broker Property By Username  ${ARGUMENTS[0]}  period_interval
  ${ADDITIONAL_DATA}=  prepare_test_tender_data  ${period_interval}  multi
  ${items}=         Get From Dictionary   ${ADDITIONAL_DATA.data}               items
  Selenium2Library.Switch Browser    ${ARGUMENTS[0]}
  Wait Until Page Contains Element   ${locator.edit_tender}    10
  Click Element                      ${locator.edit_tender}
  Wait Until Page Contains Element   ${locator.edit.add_item}  10
  Input text   ${locator.edit.description}   description
  Run keyword if   '${TEST NAME}' == 'Можливість додати позицію закупівлі в тендер'   додати позицію
  Run keyword if   '${TEST NAME}' != 'Можливість додати позицію закупівлі в тендер'   забрати позицію
  Wait Until Page Contains Element   ${locator.save}           10
  Click Element   ${locator.save}
  Wait Until Page Contains Element   ${locator.description}    20

додати позицію
###  Не видно контролів додати пропозицію в хромі, потрібно скролити, скрол не працює. Обхід: додати лише 1 пропозицію + редагувати description для скролу.
  Click Element    ${locator.edit.add_item}
  Додати придмет   ${items[1]}   1

забрати позицію
  Click Element   xpath=//a[@title="Добавить лот"]/preceding-sibling::a

Задати питання
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} = username
  ...      ${ARGUMENTS[1]} = ${TENDER_UAID}
  ...      ${ARGUMENTS[2]} = question_data
  ${title}=        Get From Dictionary  ${ARGUMENTS[2].data}  title
  ${description}=  Get From Dictionary  ${ARGUMENTS[2].data}  description
  Selenium2Library.Switch Browser    ${ARGUMENTS[0]}
  newtend.Пошук тендера по ідентифікатору   ${ARGUMENTS[0]}   ${ARGUMENTS[1]}
  Click Element   xpath=//a[contains(text(), "Уточнения")]
  Wait Until Page Contains Element   xpath=//button[@class="btn btn-lg btn-default question-btn ng-binding ng-scope"]   20
  Click Element   xpath=//button[@class="btn btn-lg btn-default question-btn ng-binding ng-scope"]
  Wait Until Page Contains Element   xpath=//input[@ng-model="title"]   10
  Input text   xpath=//input[@ng-model="title"]   ${title}
  Input text    xpath=//textarea[@ng-model="message"]   ${description}
  Click Element   xpath=//div[@ng-click="sendQuestion()"]
  Wait Until Page Contains    ${description}   20

обновити сторінку з тендером
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} = username
  ...      ${ARGUMENTS[1]} = ${TENDER_UAID}
  Selenium2Library.Switch Browser    ${ARGUMENTS[0]}
  Reload Page
  Wait Until Page Contains   ${ARGUMENTS[1]}   20

отримати інформацію про QUESTIONS[0].title
  Wait Until Page Contains Element   xpath=//span[contains(text(), "Уточнения")]   20
  Click Element              xpath=//span[contains(text(), "Уточнения")]
  Wait Until Page Contains   Вы не можете задавать вопросы    20
  ${resp}=   отримати текст із поля і показати на сторінці   QUESTIONS[0].title
  [return]  ${resp}

отримати інформацію про QUESTIONS[0].description
  ${resp}=   отримати текст із поля і показати на сторінці   QUESTIONS[0].description
  [return]  ${resp}

отримати інформацію про QUESTIONS[0].date
  ${resp}=   отримати текст із поля і показати на сторінці   QUESTIONS[0].date
  ${resp}=   Change_day_to_month   ${resp}
  [return]  ${resp}

Change_day_to_month
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]}  ==  date
  ${day}=   Get Substring   ${ARGUMENTS[0]}   0   2
  ${month}=   Get Substring   ${ARGUMENTS[0]}  3   6
  ${rest}=   Get Substring   ${ARGUMENTS[0]}   5
  ${return_value}=   Convert To String  ${month}${day}${rest}
  [return]  ${return_value}
