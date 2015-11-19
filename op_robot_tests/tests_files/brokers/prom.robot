*** Settings ***
Library  Selenium2Screenshots
Library  String
Library  DateTime
Library  Selenium2Library
Library  Collections


*** Variables ***
## Данные для логинна
${sign_in}              xpath=//a[contains(@data-afip-url, 'tab_login_cabinet')]
${login_sign_in}        //div[@data-extend='LoginForm']//input[@id='phone_email']
${password_sign_in}     //div[@data-extend='LoginForm']//input[@id='password']

## Данные для проверки уже готового созданого тендера
# Начало Тендера
${locator.title}                     id=title
${locator.description}               id=descr
#Список товарів та послуг що закуповуються
${locator.edit.description}          id=state_purchases_items-0-descr
${locator.value.amount}              id=state_purchases_items-0-quantity

${locator.minimalStep.amount}        id=step
${locator.tenderId}                  xpath=//a[@class="ng-binding ng-scope"]
${locator.procuringEntity.name}      xpath=//div[@ng-bind="tender.procuringEntity.name"]
${locator.enquiryPeriod.StartDate}   id=start-date-qualification
${locator.enquiryPeriod.endDate}     id=end-date-qualification
${locator.tenderPeriod.startDate}    id=start-date-registration
${locator.tenderPeriod.endDate}      id=end-date-registration

#Доставка
${locator.items[0].deliveryAddress}                             id=state_purchases_items-0-delivery_street_address
${locator.items[0].deliveryDate.endDate}                        id=state_purchases_items-0-date_delivery_end

${locator.items[0].description}                                 xpath=//div[@ng-bind="item.description"]

${locator.items[0].classification.scheme}                       xpath=//div[contains(@class, 'qa_cpv')]
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
${locator.QUESTIONS[0].date}

*** Keywords ***
Підготувати дані для оголошення тендера
  ${INITIAL_TENDER_DATA}=  prepare_test_tender_data
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
    Sleep   1
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
    ${INITIAL_TENDER_DATA}=  procuringEntity_name   ${INITIAL_TENDER_DATA}

    ${title}=             Get From Dictionary       ${INITIAL_TENDER_DATA.data}   title
    ${description}=       Get From Dictionary       ${INITIAL_TENDER_DATA.data}   description
    ${items}=             Get From Dictionary       ${INITIAL_TENDER_DATA.data}   items
    ${item0}=             Get From List             ${items}          0
    ${descr_lot}=         Get From Dictionary       ${item0}                        description
    ${quantity}=          Get From Dictionary       ${items[0]}                     quantity
    ${unit}=              Get From Dictionary       ${items[0].unit}                name
    ${cpv_id}=            Get From Dictionary       ${items[0].classification}      id
    ${dkpp_id}=           Get From Dictionary       ${items[0].additionalClassifications[0]}      id

    ${delivery_end}=      Get From Dictionary       ${items[0].deliveryDate}        endDate
    ${delivery_end}=      convert_date_to_prom_delivery_format        ${delivery_end}
    ${postalCode}=        Get From Dictionary       ${items[0].deliveryAddress}     postalCode

    ${streetAddress}=     Get From Dictionary       ${items[0].deliveryAddress}     streetAddress
#    ${latitude}=          Get From Dictionary       ${items[0].deliveryLocation}    latitude
#    ${longitude}=         Get From Dictionary       ${items[0].deliveryLocation}    longitude

    ${budget}=            Get From Dictionary       ${INITIAL_TENDER_DATA.data.value}       amount
    ${dates}=             get_all_prom_dates
    ${end_period_adjustments}=      Get From Dictionary         ${dates}        EndPeriod
    ${start_receive_offers}=        Get From Dictionary         ${dates}        StartDate
    ${end_receive_offers}=          Get From Dictionary         ${dates}        EndDate
#    Log To Console   ${quantity}

    Wait Until Page Contains Element     id=js-btn-0
    Click Element                        id=js-btn-0
    Wait Until Page Contains Element     id=title
    Input text                           id=title           ${title}
    Input text                           id=descr           ${description}
    Input text        id=state_purchases_items-0-descr      ${descr_lot}
    Input text        id=state_purchases_items-0-quantity   ${quantity}
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
#    Input text     id=state_purchases_items-0-delivery_latitude      ${latitude}
#    Input text     id=state_purchases_items-0-delivery_longitude     ${longitude}
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

    Sleep   8
    Reload Page
    Wait until element contains     xpath=//p[@id='qa_state_purchase_id']//span 

    ${id}=   Wait Until Keyword Succeeds   240sec   3sec   ID:
    [return]  ${id}
#
#
#Get tender id
#    ${id}=  Get Text  xpath=//td[@id="qa_state_purchase_id"]/p
#    Should Not Be Equal As Strings   ${id}   ожидание...
#    [return]  ${id}
#
#Пошук тендера по ідентифікатору
#  [Arguments]  @{ARGUMENTS}
#  [Documentation]
#  ...      ${ARGUMENTS[0]} ==  username
#  ...      ${ARGUMENTS[1]} ==  tenderId
#  ...      ${ARGUMENTS[2]} ==  id
#  Switch browser   ${ARGUMENTS[0]}
#  ${current_location}=   Get Location
#  Run keyword if   '${BROKERS['${USERS.users['${username}'].broker}'].url}/#/tenderDetailes/${ARGUMENTS[2]}'=='${current_location}'  Reload Page
#  Go to   ${BROKERS['${USERS.users['${username}'].broker}'].url}
#  Wait Until Page Contains   Допороговые закупки Украины   10
#  sleep  1
#  Input Text   id=search  ${ARGUMENTS[1]}
#  Click Button   id=search_submit
#  sleep  2
#  ${last_note_id}=  Add pointy note   jquery=a[href^="#/tenderDetailes"]   Found tender with tenderID "${ARGUMENTS[1]}"   width=200  position=bottom
#  sleep  1
#  Remove element   ${last_note_id}
#  Click Link    jquery=a[href^="#/tenderDetailes"]
#  Wait Until Page Contains    ${ARGUMENTS[1]}   10
#  sleep  1
#  Capture Page Screenshot

