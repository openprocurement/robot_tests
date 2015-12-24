*** Settings ***
Library  Selenium2Screenshots
Library  String
Library  DateTime
Library  Selenium2Library
Library  Collections


*** Variables ***
${sign_in}              xpath=//a[contains(@data-afip-url, 'tab_login_cabinet')]
${login_sign_in}        xpath=//div[@data-extend='LoginForm']//input[@id='phone_email']
${password_sign_in}     xpath=//div[@data-extend='LoginForm']//input[@id='password']
${locator.title}                                                xpath=//h1
${locator.description}                                          xpath=(//p[@class='h-mv-10'])[1]
${locator.minimalStep.amount}                                   xpath=//dd[contains(@class, 'qa_min_budget')]
${locator.value.amount}                                         xpath=//dd[contains(@class, 'qa_budget_pdv')]
${locator.tenderId}                                             xpath=//dd[contains(@class, 'tender-uid')]
${locator.procuringEntity.name}                                 xpath=//dd[contains(@class, 'qa_procuring_entity')]
${locator.enquiryPeriod.startDate}                              xpath=//dd[contains(@class, 'qa_date_period_clarifications')]
${locator.enquiryPeriod.endDate}                                xpath=//dd[contains(@class, 'qa_date_period_clarifications')]
${locator.tenderPeriod.startDate}                               xpath=//dd[contains(@class, 'qa_date_submission_of_proposals')]
${locator.tenderPeriod.endDate}                                 xpath=//dd[contains(@class, 'qa_date_submission_of_proposals')]
${locator.items[0].quantity}                                    xpath=//td[contains(@class, 'qa_quantity')]/p
${locator.items[0].description}                                 xpath=//td[contains(@class, 'qa_item_name')]/p
${locator.items[0].deliveryLocation.latitude}                   xpath=//dd[contains(@class, 'qa_place_delivery')]
${locator.items[0].deliveryLocation.longitude}                  xpath=//dd[contains(@class, 'qa_place_delivery')]
${locator.items[0].unit.code}                                   xpath=//td[contains(@class, 'qa_quantity')]/p
${locator.items[0].unit.name}                                   xpath=//td[contains(@class, 'qa_quantity')]/p
${locator.items[0].deliveryAddress.postalCode}                  xpath=//dd[contains(@class, 'qa_address_delivery')]
${locator.items[0].deliveryAddress.countryName}                 xpath=//dd[contains(@class, 'qa_address_delivery')]
${locator.items[0].deliveryAddress.region}                      xpath=//dd[contains(@class, 'qa_address_delivery')]
${locator.items[0].deliveryAddress.locality}                    xpath=//dd[contains(@class, 'qa_address_delivery')]
${locator.items[0].deliveryAddress.streetAddress}               xpath=//dd[contains(@class, 'qa_address_delivery')]
${locator.items[0].deliveryDate.endDate}                        xpath=//dd[contains(@class, 'qa_delivery_period')]
${locator.items[0].classification.scheme}                       xpath=//dt[contains(@class, 'qa_cpv_name')]
${locator.items[0].classification.id}                           xpath=//dd[contains(@class, 'qa_cpv_classifier')]
${locator.items[0].classification.description}                  xpath=//dd[contains(@class, 'qa_cpv_classifier')]
${locator.items[0].additionalClassifications[0].scheme}         xpath=//dt[contains(@class, 'qa_dkpp_name')]
${locator.items[0].additionalClassifications[0].id}             xpath=//dd[contains(@class, 'qa_dkpp_classifier')]
${locator.items[0].additionalClassifications[0].description}    xpath=//dd[contains(@class, 'qa_dkpp_classifier')]



*** Keywords ***
Підготувати дані для оголошення тендера
  ${INITIAL_TENDER_DATA}=  prepare_test_tender_data
  [return]   ${INITIAL_TENDER_DATA}

Підготувати клієнт для користувача
  [Arguments]  @{ARGUMENTS}
  [Documentation]  Відкрити брaвзер, створити обєкт api wrapper, тощо
  ...      ${ARGUMENTS[0]} ==  username
  Open Browser   ${BROKERS['${USERS.users['${username}'].broker}'].url}   ${USERS.users['${username}'].browser}   alias=${ARGUMENTS[0]}
  Set Window Size       @{USERS.users['${ARGUMENTS[0]}'].size}
  Set Window Position   @{USERS.users['${ARGUMENTS[0]}'].position}
  Run Keyword If   '${username}' != 'Prom_Viewer'   Login

Login
    Click Element  ${sign_in}
    Sleep   1
    Input text      ${login_sign_in}          ${USERS.users['${username}'].login}
    Input text      ${password_sign_in}       ${USERS.users['${username}'].password}
    Click Button    id=submit_login_button
    Wait Until Page Contains Element   xpath =//div[@class='qa_political_procurement']  20


Створити тендер
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tender_data

### Создание тендера
    ${INITIAL_TENDER_DATA}=  procuringEntity_name_prom   ${INITIAL_TENDER_DATA}
    ${title}=                Get From Dictionary         ${INITIAL_TENDER_DATA.data}   title
    ${description}=          Get From Dictionary         ${INITIAL_TENDER_DATA.data}   description
    ${items}=                Get From Dictionary         ${INITIAL_TENDER_DATA.data}   items
    ${item0}=                Get From List               ${items}          0
    ${descr_lot}=            Get From Dictionary         ${item0}                        description
    ${budget}=               Get From Dictionary         ${INITIAL_TENDER_DATA.data.value}         amount
    ${unit}=                 Get From Dictionary         ${items[0].unit}                name
    ${cpv_id}=               Get From Dictionary         ${items[0].classification}      id
    ${dkpp_id}=              Get From Dictionary         ${items[0].additionalClassifications[0]}      id
    ${delivery_end}=         Get From Dictionary         ${items[0].deliveryDate}        endDate
    ${postalCode}=           Get From Dictionary         ${items[0].deliveryAddress}     postalCode
    ${locality}=             Get From Dictionary         ${items[0].deliveryAddress}     locality
    ${streetAddress}=        Get From Dictionary         ${items[0].deliveryAddress}     streetAddress
    ${latitude}=             Get From Dictionary         ${items[0].deliveryLocation}    latitude
    ${longitude}=            Get From Dictionary         ${items[0].deliveryLocation}    longitude
    ${quantity}=             Get From Dictionary         ${items[0]}                     quantity
    ${step_rate}=            Get From Dictionary         ${INITIAL_TENDER_DATA.data.minimalStep}   amount
    ${dates}=                get_all_prom_dates
    ${end_period_adjustments}=      Get From Dictionary         ${dates}        EndPeriod
    ${start_receive_offers}=        Get From Dictionary         ${dates}        StartDate
    ${end_receive_offers}=          Get From Dictionary         ${dates}        EndDate

    Selenium2Library.Switch Browser    ${ARGUMENTS[0]}
    Wait Until Page Contains Element     id=js-btn-0    20
    Click Element                        id=js-btn-0
    Wait Until Page Contains Element     id=title       20
    Input text                           id=title               ${title}
    Input text                           id=descr               ${description}
    Input text        id=state_purchases_items-0-descr          ${descr_lot}
    Input text        id=state_purchases_items-0-quantity       ${quantity}
    Click Element     id=state_purchases_items-0-unit_id_dd
    Click Element     xpath=//li[@data-value='1']
    ## Cpv
    Click Element     xpath=//div[contains(@class, 'qa_cpv_button')]
    Wait Until Page Contains Element    xpath=//div[contains(@class, 'qa_cpv_popup')]//input[contains(@data-url, 'classifier_type=cpv')]    20
    Input text        xpath=//div[contains(@class, 'qa_cpv_popup')]//input[contains(@data-url, 'classifier_type=cpv')]    ${cpv_id}
    Click Element     xpath=//div[contains(@class, 'qa_cpv_popup')]//input[contains(@data-url, 'classifier_type=cpv')]
    Press Key         xpath=//div[contains(@class, 'qa_cpv_popup')]//input[contains(@data-url, 'classifier_type=cpv')]             \\13
    Wait Until Page Contains Element      xpath=//input[contains(@data-label, '44617100-9')]      20
    Click Element     xpath=//input[contains(@data-label, '44617100-9')]
    Click Element     xpath=//div[contains(@class, 'qa_cpv_popup')]//a[contains(@class, 'classifiers-submit')]
    ## dkkp
    Wait Until Page Contains Element   xpath=//div[contains(@class, 'qa_dkpp_button')]      20
    Click Element     xpath=//div[contains(@class, 'qa_dkpp_button')]
    Wait Until Page Contains Element    xpath=//div[contains(@class, 'qa_dkpp_popup')]//input[contains(@data-url, 'classifier_type=dkpp')]    20
    Input text        xpath=//div[contains(@class, 'qa_dkpp_popup')]//input[contains(@data-url, 'classifier_type=dkpp')]    ${dkpp_id}
    Click Element     xpath=//div[contains(@class, 'qa_dkpp_popup')]//input[contains(@data-url, 'classifier_type=dkpp')]
    Press Key         xpath=//div[contains(@class, 'qa_dkpp_popup')]//input[contains(@data-url, 'classifier_type=dkpp')]             \\13
    Wait Until Page Contains Element      id=classifier_id-1228     20
    Click Element     id=classifier_id-1228
    Click Element     xpath=//div[contains(@class, 'qa_dkpp_popup')]//a[contains(@class, 'classifiers-submit')]
    Input text        id=state_purchases_items-0-date_delivery_end          ${delivery_end}
    Click Element     id=state_purchases_items-0-date_delivery_end
    Press Key         id=state_purchases_items-0-date_delivery_end             \\13
    Input text        id=state_purchases_items-0-delivery_postal_code       ${postalCode}
    ## дроп даун области
    Click Element     id=state_purchases_items-0-delivery_region_dd
    Click Element     xpath=//li[contains(@data-value, 'Киевская')]
    Input text        id=state_purchases_items-0-delivery_locality          ${locality}
    Input text        id=state_purchases_items-0-delivery_street_address    ${streetAddress}
    Input text        id=state_purchases_items-0-delivery_latitude          ${latitude.split(u'° ')[0]}
    Input text        id=state_purchases_items-0-delivery_longitude         ${longitude.split(u'° ')[0]}
    Input text        id=amount             ${budget}
    Input text      id=dt_enquiry           ${end_period_adjustments}
    Sleep   1
    Click Element   id=dt_enquiry
    Press Key       id=dt_enquiry                   \\13
    Sleep   1
    Input text      id=dt_tender_start      ${start_receive_offers}
    Click Element   id=dt_tender_start
    Press Key       id=dt_tender_start              \\13
    Sleep   1
    Input text      id=dt_tender_end        ${end_receive_offers}
    Click Element   id=dt_tender_end
    Press Key       id=dt_tender_end                \\13
    Sleep   1
    input text      id=step                 ${step_rate}
    Click Button    id=submit_button
    Sleep   1
    Wait Until Page Does Not Contain      ...   1000
    Reload Page

    ${tender_id}=     Get Text        xpath=//p[@id='qa_state_purchase_id']
    ${id}=            Remove String     ${tender_id}      ID:
    log to console      ${id}
    [return]    ${id}


Завантажити документ
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  ${filepath}
  ...      ${ARGUMENTS[2]} ==  ${id}

  Go to   ${USERS.users['${username}'].homepage}
  Input Text      id=search       ${ARGUMENTS[2]}
  Click Button    xpath=//button[@type='submit']
  Sleep   2
  Click Element   xpath=(//td[contains(@class, 'qa_item_name')]//a)[1]
  Sleep   1
  Click Element   xpath=//a[contains(@href, 'state_purchase/edit')]
  Sleep   1
  Choose File     xpath=//input[contains(@class, 'qa_state_offer_add_field')]   ${filepath}
  Sleep   2
  Reload Page
  Click Button    id=submit_button
  Sleep   3
  Capture Page Screenshot


Пошук тендера по ідентифікатору
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  ${id}

  Go to   ${BROKERS['${USERS.users['${username}'].broker}'].url}
  Input Text      id=search_text_id   ${ARGUMENTS[1]}
  Click Button    id=search_submit
  Sleep  2
  CLICK ELEMENT     xpath=(//a[contains(@href, 'net/dz/')])[1]
  Sleep  1
  Wait Until Page Contains    ${ARGUMENTS[1]}   10
  Sleep  1
  Click Element   id=show_lot_info-0
  Capture Page Screenshot


#Задати питання
#  [Arguments]  @{ARGUMENTS}
#  [Documentation]
#  ...      ${ARGUMENTS[0]} ==  username
#  ...      ${ARGUMENTS[1]} ==  tenderUaId
#  ...      ${ARGUMENTS[2]} ==  questionId
#  ${title}=        Get From Dictionary  ${ARGUMENTS[2].data}  title
#  ${description}=  Get From Dictionary  ${ARGUMENTS[2].data}  description
#
#  Selenium2Library.Switch Browser    ${ARGUMENTS[0]}
#  prom.Пошук тендера по ідентифікатору    ${ARGUMENTS[0]}   ${ARGUMENTS[1]}
#  Sleep  1
##  Execute Javascript                  window.scroll(2500,2500)
#  Wait Until Page Contains Element    xpath=//a[@class='reverse openCPart'][span[text()='Обговорення']]    20
#  Click Element                       xpath=//a[@class='reverse openCPart'][span[text()='Обговорення']]    20
#  Wait Until Page Contains Element    name=title    20
#  Input text                          name=title                 ${title}
#  Input text                          xpath=//textarea[@name='description']           ${description}
#  Click Element                       xpath=//div[contains(@class, 'buttons')]//button[@type='submit']
#  Wait Until Page Contains            ${title}   30
#  Capture Page Screenshot




### Проверка информации с тендера
Отримати інформацію із тендера
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  fieldname

  ${return_value}=  run keyword  Отримати інформацію про ${ARGUMENTS[1]}
  [return]  ${return_value}

Отримати тест із поля і показати на сторінці
  [Arguments]   ${fieldname}
  ${return_value}=   Get Text  ${locator.${fieldname}}
  [return]  ${return_value}

Отримати інформацію про title
  ${return_value}=   Отримати тест із поля і показати на сторінці   title
  [return]  ${return_value}

Отримати інформацію про description
  ${return_value}=   Отримати тест із поля і показати на сторінці   description
  [return]  ${return_value}

Отримати інформацію про value.amount
  ${return_value}=   Отримати тест із поля і показати на сторінці  value.amount
  ${return_value}=   Remove String      ${return_value}     грн.
  ${return_value}=   Convert To Number   ${return_value.replace(' ', '').replace(',', '.')}
  [return]  ${return_value}

Отримати інформацію про minimalStep.amount
  ${return_value}=   Отримати тест із поля і показати на сторінці   minimalStep.amount
  ${return_value}=    Remove String      ${return_value}     грн.
  ${return_value}=    Convert To Number   ${return_value.replace(' ', '')}
  [return]  ${return_value}

#Внести зміни в тендер
#  [Arguments]  @{ARGUMENTS}
#  [Documentation]
#  ...      ${ARGUMENTS[0]} ==  username
#  ...      ${ARGUMENTS[1]} ==  id
#  ...      ${ARGUMENTS[2]} ==  fieldname
#  ...      ${ARGUMENTS[3]} ==  fieldvalue
#
#  Go to   ${USERS.users['${username}'].homepage}
#  Input Text        id=search       ${ARGUMENTS[1]}
#  Click Button    xpath=//button[@type='submit']
#  Sleep   2
#  Click Element   xpath=(//td[contains(@class, 'qa_item_name')]//a)[1]
#  Sleep   2
#  Click Element     xpath=//a[contains(@href, 'state_purchase/edit')]
#  Sleep   1
#  Input text        id=title               ${title}
#  Input text        id=descr               ${description}
#  click element     id=submit_button
#  ${result_field}=   отримати текст із поля і показати на сторінці   ${ARGUMENTS[2]}
#  Should Be Equal   ${result_field}   ${ARGUMENTS[3]}
#  Go to     ${teneder_url}


Отримати інформацію про items[0].quantity
  ${return_value}=   Отримати тест із поля і показати на сторінці   items[0].quantity
  ${return_value}=    Convert To Number   ${return_value.split(' ')[0]}
  [return]  ${return_value}

Отримати інформацію про items[0].unit.code
  ${return_value}=   Отримати тест із поля і показати на сторінці   items[0].unit.code
  ${return_value}=   Convert To String     ${return_value.split(' ')[1]}
  ${return_value}=   Convert To String    KGM
  [return]  ${return_value}

Отримати інформацію про items[0].unit.name
  ${return_value}=   Отримати тест із поля і показати на сторінці   items[0].unit.name
  ${return_value}=   Convert To String     ${return_value.split(' ')[1]}
  ${return_value}=   convert_prom_string_to_common_string     ${return_value}
  [return]   ${return_value}

Отримати інформацію про tenderId
  ${return_value}=   Отримати тест із поля і показати на сторінці   tenderId
  [return]  ${return_value}

Отримати інформацію про procuringEntity.name
  ${return_value}=   Отримати тест із поля і показати на сторінці   procuringEntity.name
  [return]  ${return_value}

Отримати інформацію про items[0].deliveryLocation.latitude
  ${return_value}=   Отримати тест із поля і показати на сторінці   items[0].deliveryLocation.latitude
  [return]  ${return_value.split(' ')[1] + u'° N'}

Отримати інформацію про items[0].deliveryLocation.longitude
  ${return_value}=   Отримати тест із поля і показати на сторінці   items[0].deliveryLocation.longitude
  [return]  ${return_value.split(' ')[0] + u'° E'}

Отримати інформацію про tenderPeriod.startDate
  ${return_value}=    Отримати тест із поля і показати на сторінці  tenderPeriod.startDate
  ${return_value}=    convert_date_to_prom_tender_startdate      ${return_value}
  [return]    ${return_value}

Отримати інформацію про tenderPeriod.endDate
  ${return_value}=   Отримати тест із поля і показати на сторінці  tenderPeriod.endDate
  ${return_value}=    convert_date_to_prom_tender_enddate    ${return_value}
  [return]    ${return_value}

Отримати інформацію про enquiryPeriod.startDate
  ${return_value}=   Отримати тест із поля і показати на сторінці  enquiryPeriod.startDate
  Fail   Данное поле отсутвует на Prom.ua

Отримати інформацію про enquiryPeriod.endDate
  ${return_value}=   Отримати тест із поля і показати на сторінці  enquiryPeriod.endDate
  ${return_value}=    convert_date_to_prom_tender    ${return_value}
  [return]  ${return_value}

Отримати інформацію про items[0].description
  ${return_value}=   Отримати тест із поля і показати на сторінці   items[0].description
  [return]  ${return_value}

Отримати інформацію про items[0].classification.id
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[0].classification.id
  [return]  ${return_value.split(' ')[0]}

Отримати інформацію про items[0].classification.scheme
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[0].classification.scheme
  ${return_value}=    Remove String      ${return_value}     :
  [return]  ${return_value}

Отримати інформацію про items[0].classification.description
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[0].classification.description
  [return]  ${return_value.split(' ')[1]}

Отримати інформацію про items[0].additionalClassifications[0].id
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[0].additionalClassifications[0].id
  [return]  ${return_value.split(' ')[0]}

Отримати інформацію про items[0].additionalClassifications[0].scheme
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[0].additionalClassifications[0].scheme
  ${return_value}=    Remove String      ${return_value}     :
  [return]  ${return_value}

Отримати інформацію про items[0].additionalClassifications[0].description
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[0].additionalClassifications[0].description
  [return]  ${return_value[8:]}

Отримати інформацію про items[0].deliveryAddress.countryName
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[0].deliveryAddress.countryName
  ${return_value}=   Convert To String     ${return_value.split(', ')[0]}
  ${return_value}=  convert_prom_string_to_common_string    ${return_value}
  [return]   ${return_value}

Отримати інформацію про items[0].deliveryAddress.postalCode
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[0].deliveryAddress.postalCode
  [return]  ${return_value.split(', ')[1]}

Отримати інформацію про items[0].deliveryAddress.region
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[0].deliveryAddress.region
  ${return_value}=   Convert To String     ${return_value.split(', ')[2]}
  ${return_value}=   convert_prom_string_to_common_string   ${return_value}
  [return]   ${return_value}

Отримати інформацію про items[0].deliveryAddress.locality
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[0].deliveryAddress.locality
  [return]  ${return_value.split(', ')[3]}

Отримати інформацію про items[0].deliveryAddress.streetAddress
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[0].deliveryAddress.streetAddress
  [return]  ${return_value.split(', ')[4]}

## Період доставки:
Отримати інформацію про items[0].deliveryDate.endDate
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[0].deliveryDate.endDate
  ${return_value}=    convert_date_to_prom_tender      ${return_value.split(u'до ')[1]}
  [return]  ${return_value}

## не сделано
Отримати інформацію про questions[0].title
  ${return_value}=  Отримати тест із поля і показати на сторінці   questions[0].title
  [return]  ${return_value}

Отримати інформацію про questions[0].description
  ${return_value}=   Отримати тест із поля і показати на сторінці   questions[0].description
  [return]  ${return_value}

Отримати інформацію про questions[0].date
  ${return_value}=   Отримати тест із поля і показати на сторінці   questions[0].date

  [return]  ${return_value}

Отримати інформацію про questions[0].answer
  ${return_value}=   Отримати тест із поля і показати на сторінці   questions[0].answer
  [return]  ${return_value}
