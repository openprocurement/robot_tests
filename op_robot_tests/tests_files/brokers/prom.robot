*** Settings ***
Library  Selenium2Screenshots
Library  String
Library  DateTime
Library  Selenium2Library
Library  Collections


*** Variables ***
## Данные для логинна
${sign_in}              xpath=//a[contains(@data-afip-url, 'tab_login_cabinet')]
${login_sign_in}        xpath=//div[@data-extend='LoginForm']//input[@id='phone_email']
${password_sign_in}     xpath=//div[@data-extend='LoginForm']//input[@id='password']

## Данные для проверки уже готового созданого тендера
# Начало Тендера
${locator.title}                        xpath=//h1
${locator.description}                  xpath=(//p[@class='h-mv-10'])[1]
${locator.minimalStep.amount}           xpath=//dd[contains(@class, 'qa_min_budget')]
${locator.value.amount}                 xpath=//dd[contains(@class, 'qa_budget_pdv')]
${locator.tenderId}                     xpath=//dd[contains(@class, 'tender-uid')]
${locator.procuringEntity.name}         xpath=//dd[contains(@class, 'qa_procuring_entity')]
${locator.enquiryPeriod.startDate}       xpath=//dd[contains(@class, 'qa_date_period_clarifications')]
${locator.enquiryPeriod.endDate}       xpath=//dd[contains(@class, 'qa_date_period_clarifications')]
${locator.tenderPeriod.startDate}      xpath=//dd[contains(@class, 'qa_date_submission_of_proposals')]
${locator.tenderPeriod.endDate}        xpath=//dd[contains(@class, 'qa_date_submission_of_proposals')]

${locator.items[0].quantity}                                    xpath=//td[contains(@class, 'qa_quantity')]/p
${locator.items[0].description}                                 xpath=//td[contains(@class, 'qa_item_name')]/p
${locator.tenderPeriod.endDate}                                 xpath=//dd[contains(@class, 'qa_date_period_clarifications')]
${locator.items[0].deliveryLocation.latitude}                   xpath=//dd[contains(@class, 'qa_place_delivery')]
${locator.items[0].deliveryLocation.longitude}                  xpath=//dd[contains(@class, 'qa_place_delivery')]
${locator.items[0].unit.code}                                   xpath=//td[contains(@class, 'qa_quantity')]/p
${locator.items[0].unit.name}                                   xpath=//td[contains(@class, 'qa_quantity')]/p

${locator.items[0].deliveryAddress.postalCode}                  xpath=//dd[contains(@class, 'qa_address')]
${locator.items[0].deliveryAddress.countryName}                 xpath=//dd[contains(@class, 'qa_address')]
${locator.items[0].deliveryAddress.region}                      xpath=//dd[contains(@class, 'qa_address')]
${locator.items[0].deliveryAddress.locality}                    xpath=//dd[contains(@class, 'qa_address')]
${locator.items[0].deliveryAddress.streetAddress}               xpath=//dd[contains(@class, 'qa_address')]
${locator.items[0].deliveryDate.endDate}                        xpath=//dd[contains(@class, 'qa_delivery_period')]


${locator.items[0].classification.scheme}                       xpath=//dt[contains(@class, 'item-term')][contains(text(), 'CPV')]
${locator.items[0].classification.id}                           xpath=//dd[contains(@class, 'qa_cpv_classifier')]
${locator.items[0].classification.description}                  xpath=//dd[contains(@class, 'qa_cpv_classifier')]

${locator.items[0].additionalClassifications[0].scheme}         xpath=//dt[contains(@class, 'item-term')][contains(text(), 'ДКПП')]
${locator.items[0].additionalClassifications[0].id}             xpath=//dd[contains(@class, 'qa_dkpp_classifier')]
${locator.items[0].additionalClassifications[0].description}    xpath=//dd[contains(@class, 'qa_dkpp_classifier')]




#${locator.edit_tender}     xpath=//button[@ng-if="actions.can_edit_tender"]
#${locator.edit.add_item}   xpath=//a[@class="icon-black plus-black remove-field ng-scope"]
#${locator.save}            xpath=//button[@class="btn btn-lg btn-default cancel pull-right ng-binding"]
#${locator.QUESTIONS[0].title}         xpath=//span[@class="user ng-binding"]
#${locator.QUESTIONS[0].description}   xpath=//span[@class="question-description ng-binding"]
#${locator.QUESTIONS[0].date}

*** Keywords ***
Підготувати дані для оголошення тендера
  [Arguments]  @{ARGUMENTS}
  ${INITIAL_TENDER_DATA}=  prepare_test_tender_data_from_Prom     ${ARGUMENTS[1]}     ${ARGUMENTS[2]}
  [return]   ${INITIAL_TENDER_DATA}

Підготувати клієнт для користувача
  [Arguments]  @{ARGUMENTS}
  [Documentation]  Відкрити брaвзер, створити обєкт api wrapper, тощо
  ...      ${ARGUMENTS[0]} ==  username
  Open Browser   ${BROKERS['${USERS.users['${username}'].broker}'].url}   ${USERS.users['${username}'].browser}   alias=${ARGUMENTS[0]}
  Set Window Size   @{USERS.users['${ARGUMENTS[0]}'].size}
  Set Window Position   @{USERS.users['${ARGUMENTS[0]}'].position}
  Run Keyword If   '${username}' != 'Prom_Viewer'   Login

Login
    Click Element  ${sign_in}
    Sleep   1
    Input text      ${login_sign_in}     ${USERS.users['${username}'].login}
    Input text      ${password_sign_in}       ${USERS.users['${username}'].password}
    Click Button    id=submit_login_button
    Wait Until Page Contains Element   xpath =//div[@class='qa_political_procurement']  20


Створити тендер
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tender_data

    Login
### Создание тендера
    ${INITIAL_TENDER_DATA}=  procuringEntity_name_prom   ${INITIAL_TENDER_DATA}
    ${title}=             Get From Dictionary       ${INITIAL_TENDER_DATA.data}   title
    ${description}=       Get From Dictionary       ${INITIAL_TENDER_DATA.data}   description
    ${items}=             Get From Dictionary       ${INITIAL_TENDER_DATA.data}   items
    ${item0}=             Get From List             ${items}          0
    ${descr_lot}=         Get From Dictionary       ${item0}                        description
    ${budget}=            Get From Dictionary       ${INITIAL_TENDER_DATA.data.value}         amount
    ${unit}=              Get From Dictionary       ${items[0].unit}                name
    ${cpv_id}=            Get From Dictionary       ${items[0].classification}      id
    ${dkpp_id}=           Get From Dictionary       ${items[0].additionalClassifications[0]}      id
    ${delivery_end}=      Get From Dictionary       ${items[0].deliveryDate}        endDate
    ${delivery_end}=      convert_date_to_prom_delivery_format        ${delivery_end}
    ${postalCode}=        Get From Dictionary       ${items[0].deliveryAddress}     postalCode
    ${streetAddress}=     Get From Dictionary       ${items[0].deliveryAddress}     streetAddress
    ${latitude}=          Get From Dictionary       ${items[0].deliveryLocation}    latitude
    ${longitude}=         Get From Dictionary       ${items[0].deliveryLocation}    longitude
    ${quantity}=          Get From Dictionary       ${items[0]}                     quantity
    ${dates}=             get_all_prom_dates
    ${end_period_adjustments}=      Get From Dictionary         ${dates}        EndPeriod
    ${start_receive_offers}=        Get From Dictionary         ${dates}        StartDate
    ${end_receive_offers}=          Get From Dictionary         ${dates}        EndDate

    Wait Until Page Contains Element     id=js-btn-0
    Click Element                        id=js-btn-0
    Wait Until Page Contains Element     id=title
    Input text                           id=title               ${title}
    Input text                           id=descr               ${description}
    Input text        id=state_purchases_items-0-descr          ${descr_lot}
    Input text        id=state_purchases_items-0-quantity       ${quantity}
    Click Element     id=state_purchases_items-0-unit_id_dd
    Click Element     xpath=//li[@data-value='1']

    ## Cpv
    Click Element    xpath=//div[contains(@class, 'qa_cpv')]
    Wait Until Page Contains Element    xpath=//div[contains(@class, 'qa_container_cpv_popup')]//input[contains(@data-url, 'classifier_type=cpv')]
    Input text        xpath=//div[contains(@class, 'qa_container_cpv_popup')]//input[contains(@data-url, 'classifier_type=cpv')]    ${cpv_id}
    Click Element  xpath=//div[contains(@class, 'qa_container_cpv_popup')]//input[contains(@data-url, 'classifier_type=cpv')]
    Press Key   xpath=//div[contains(@class, 'qa_container_cpv_popup')]//input[contains(@data-url, 'classifier_type=cpv')]             \\13
    Wait Until Page Contains Element      xpath=//input[contains(@data-label, '44617100-9')]
    Click Element     xpath=//input[contains(@data-label, '44617100-9')]
    Click Element     xpath=//div[contains(@class, 'qa_container_cpv_popup')]//a[contains(@class, 'classifiers-submit')]
    ## dkkp
    Wait Until Page Contains Element   xpath=//div[contains(@class, 'qa_dkpp')]
    Click Element    xpath=//div[contains(@class, 'qa_dkpp')]
    Wait Until Page Contains Element    xpath=//div[contains(@class, 'qa_container_dkpp_popup')]//input[contains(@data-url, 'classifier_type=dkpp')]
    Input text        xpath=//div[contains(@class, 'qa_container_dkpp_popup')]//input[contains(@data-url, 'classifier_type=dkpp')]    ${dkpp_id}
    Click Element  xpath=//div[contains(@class, 'qa_container_dkpp_popup')]//input[contains(@data-url, 'classifier_type=dkpp')]
    Press Key   xpath=//div[contains(@class, 'qa_container_dkpp_popup')]//input[contains(@data-url, 'classifier_type=dkpp')]             \\13
    Wait Until Page Contains Element      id=classifier_id-1228
    Click Element     id=classifier_id-1228
    Click Element     xpath=//div[contains(@class, 'qa_container_dkpp_popup')]//a[contains(@class, 'classifiers-submit')]
    Input text  id=state_purchases_items-0-date_delivery_end    ${delivery_end}
    Click Element  id=state_purchases_items-0-date_delivery_end
    Press Key   id=state_purchases_items-0-date_delivery_end             \\13
    Input text  state_purchases_items-0-delivery_postal_code    ${postalCode}
    Input text     id=state_purchases_items-0-delivery_street_address   ${streetAddress}
    Input text     id=state_purchases_items-0-delivery_latitude      ${latitude}
    Input text     id=state_purchases_items-0-delivery_longitude     ${longitude}
    Input text     id=amount           ${budget}

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

    Click Button    id=submit_button
    Sleep   1
    Wait Until Page Does Not Contain      ...   1000
    Reload Page

    ${tender_id}=     Get Text        xpath=//p[@id='qa_state_purchase_id']
    ${id}=            Remove String     ${tender_id}      ID:
#    Log To Console   ${id}
    [return]    ${id}


Пошук тендера по ідентифікатору
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  ${id}

  Switch browser   ${ARGUMENTS[0]}
  ${current_location}=   Get Location
  Go to   ${BROKERS['${USERS.users['${username}'].broker}'].url}
  sleep  1
  Input Text      id=search_text_id  ${ARGUMENTS[1]}
  Click Button    id=search_submit
  sleep  3
  CLICK ELEMENT     xpath=(//a[contains(@href, 'net/dz/')])[1]
  sleep  1
  Wait Until Page Contains    ${ARGUMENTS[1]}   10
  sleep  1
  CLICK ELEMENT   id=show_lot_info-0
  Capture Page Screenshot



### Проверка информации с тендера
Отримати інформацію із тендера
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  fieldname
  Switch browser   ${ARGUMENTS[0]}
  ${return_value}=  run keyword  Отримати інформацію про ${ARGUMENTS[1]}
  [return]  ${return_value}

Отримати тест із поля і показати на сторінці
  [Arguments]   ${fieldname}
  sleep  3
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

Отримати інформацію про items[0].quantity
  ${return_value}=   Отримати тест із поля і показати на сторінці   items[0].quantity
  ${return_value}=    Convert To Number   ${return_value.split(' ')[0]}
  [return]  ${return_value}

Отримати інформацію про items[0].unit.code
  ${return_value}=   Отримати тест із поля і показати на сторінці   items[0].unit.code
  ${return_value}=   ${return_value.split(' ')[1]}
  ${return_value}=   Convert To String    KGM
  [return]  ${return_value}

Отримати інформацію про items[0].unit.name
  ${return_value}=   Отримати тест із поля і показати на сторінці   items[0].unit.name
  [return]  ${return_value.split(' ')[1]}

Отримати інформацію про tenderId
  ${return_value}=   Отримати тест із поля і показати на сторінці   tenderId
  [return]  ${return_value}

Отримати інформацію про procuringEntity.name
  ${return_value}=   Отримати тест із поля і показати на сторінці   procuringEntity.name
  [return]  ${return_value}

Отримати інформацію про items[0].deliveryLocation.latitude
  ${return_value}=   Отримати тест із поля і показати на сторінці   items[0].deliveryLocation.latitude
  [return]  ${return_value.split(' ')[1]}

Отримати інформацію про items[0].deliveryLocation.longitude
  ${return_value}=   Отримати тест із поля і показати на сторінці   items[0].deliveryLocation.longitude
  [return]  ${return_value.split(' ')[0]}


## Подача пропозицій
Отримати інформацію про tenderPeriod.startDate
  ${return_value}=   Отримати тест із поля і показати на сторінці  tenderPeriod.startDate
  [return]  ${return_value.[:14]}


Отримати інформацію про tenderPeriod.endDate
  ${return_value}=   Отримати тест із поля і показати на сторінці  tenderPeriod.endDate
  [return]  ${return_value.[17:]}


## Період уточнень до:
Отримати інформацію про enquiryPeriod.startDate
  ${return_value}=   Отримати тест із поля і показати на сторінці  enquiryPeriod.startDate
  Fail   Реализоват автоматический ввод данных

Отримати інформацію про enquiryPeriod.endDate
  ${return_value}=   Отримати тест із поля і показати на сторінці  enquiryPeriod.endDate
  ${return_value}=   Remove String      ${return_value}       до
  [return]  ${return_value}

Отримати інформацію про items[0].description
  ${return_value}=   Отримати тест із поля і показати на сторінці   items[0].description
  [return]  ${return_value}



#Change_date_to_month
#  [Arguments]  @{ARGUMENTS}
#  [Documentation]
#  ...      ${ARGUMENTS[0]}  ==  date
#  ${day}=   Get Substring   ${ARGUMENTS[0]}   0   2
#  ${month}=   Get Substring   ${ARGUMENTS[0]}  3   6
#  ${year}=   Get Substring   ${ARGUMENTS[0]}   5
#  ${return_value}=   Convert To String  ${month}${day}${year}
#  [return]  ${return_value}



Отримати інформацію про items[0].classification.id
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[0].classification.id
  [return]  ${return_value.split(' ')[0]}

Отримати інформацію про items[0].classification.scheme
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[0].classification.scheme
  ${return_value}=   Get Text       ${return_value}
  [return]  ${return_value}

Отримати інформацію про items[0].classification.description
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[0].classification.description
  [return]  ${return_value.split(' ')[1]}

Отримати інформацію про items[0].additionalClassifications[0].id
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[0].additionalClassifications[0].id
  [return]  ${return_value.split(' ')[0]}

Отримати інформацію про items[0].additionalClassifications[0].scheme
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[0].additionalClassifications[0].scheme
  ${return_value}=   Get Text       ${return_value}
  [return]  ${return_value}

Отримати інформацію про items[0].additionalClassifications[0].description
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[0].additionalClassifications[0].description
  [return]  ${return_value[8:]}

Отримати інформацію про items[0].deliveryAddress.postalCode
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[0].deliveryAddress.postalCode
  [return]  ${return_value.split(', ')[0]}

Отримати інформацію про items[0].deliveryAddress.countryName
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[0].deliveryAddress.countryName
  [return]  ${return_value.split(', ')[1]}

Отримати інформацію про items[0].deliveryAddress.region
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[0].deliveryAddress.region
  [return]  ${return_value.split(', ')[2]}

Отримати інформацію про items[0].deliveryAddress.locality
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[0].deliveryAddress.locality
  [return]  ${return_value.split(', ')[3]}

Отримати інформацію про items[0].deliveryAddress.streetAddress
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[0].deliveryAddress.streetAddress
  [return]  ${return_value}

## Період доставки:
Отримати інформацію про items[0].deliveryDate.endDate
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[0].deliveryDate.endDate
  log   ${return_value}
  [return]  ${return_value.split(u'до ')}

Отримати інформацію про questions[0].title
  ${return_value}=   отримати тест із поля і показати на сторінці   questions[0].title
  [return]  ${return_value}

Отримати інформацію про questions[0].description
  ${return_value}=   отримати тест із поля і показати на сторінці   questions[0].description
  [return]  ${return_value}

Отримати інформацію про questions[0].date
  ${return_value}=   отримати тест із поля і показати на сторінці   questions[0].date
  ${return_value}=   Change_date_to_month   ${return_value}
  [return]  ${return_value}

Отримати інформацію про questions[0].answer
  ${return_value}=   отримати тест із поля і показати на сторінці   questions[0].answer
  [return]  ${return_value}
