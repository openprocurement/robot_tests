*** Settings ***
Resource           base_keywords.robot
Suite Setup        Test Suite Setup
Suite Teardown     Test Suite Teardown


*** Variables ***
${MODE}         reporting
@{USED_ROLES}   tender_owner  viewer

${NUMBER_OF_ITEMS}  ${2}
${NUMBER_OF_LOTS}   ${0}
${TENDER_MEAT}      ${False}
${LOT_MEAT}         ${False}
${ITEM_MEAT}        ${False}
${MOZ_INTEGRATION}  ${False}

*** Test Cases ***
##############################################################################################
#             MAIN
##############################################################################################

Можливість створити звіт про укладений договір
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Можливість створити процедуру
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  create_tender
  ...  level1
  ...  critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість оголосити тендер


Можливість додати документацію до звіту про укладений договір
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Можливість додати документацію до процедури
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  add_tender_doc
  ...  level2
  ...  critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість додати документацію до тендера


Можливість зареєструвати і підтвердити постачальника до звіту про укладений договір
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Можливість зареєструвати і підтвердити постачальника до процедури
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  add_award
  ...  level1
  ...  critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість зареєструвати, додати документацію і підтвердити першого постачальника до закупівлі


Можливість укласти угоду для звіту про укладений договір
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Можливість укласти угоду для процедури
  ...  ${tender_owner}
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  add_contract
  ...  level1
  ...  critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість укласти угоду для закупівлі


Можливість знайти звіт про укладений договір по ідентифікатору
  [Tags]  ${USERS.users['${viewer}'].broker}: Можливість знайти процедуру
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  find_tender
  ...  level1
  ...  critical
  Можливість знайти тендер по ідентифікатору для користувача ${viewer}

##############################################################################################
#             CONTRACTS
##############################################################################################

Відображення статусу підписаної угоди з постачальником звіту про укладений договір
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення угоди з постачальником процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  add_contract
  ...  level1
  ...  critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля contracts[0].status тендера із active для користувача ${viewer}

##############################################################################################
#             MAIN DATA
##############################################################################################

Відображення заголовку звіту про укладений договір
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення основних даних процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  ...  level2
  ...  critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля title тендера для користувача ${viewer}


Відображення заголовку звіту про укладений договір англійською мовою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення основних даних процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view_title_en
  ...  non-critical
  Звірити відображення поля title_en тендера для користувача ${viewer}


Відображення заголовку звіту про укладений договір російською мовою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення основних даних процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view_title_ru
  ...  non-critical
  Звірити відображення поля title_ru тендера для користувача ${viewer}


Відображення ідентифікатора звіту про укладений договір
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення основних даних процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  ...  level2
  ...  critical
  Звірити відображення поля tenderID тендера із ${TENDER['TENDER_UAID']} для користувача ${viewer}


Відображення опису звіту про укладений договір
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення основних даних процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  ...  level2
  ...  critical
  Звірити відображення поля description тендера для користувача ${viewer}


Відображення опису звіту про укладений договір англійською мовою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення основних даних процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view_description_en
  ...  non-critical
  Звірити відображення поля description_en тендера для користувача ${viewer}


Відображення опису звіту про укладений договір російською мовою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення основних даних процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view_description_ru
  ...  non-critical
  Звірити відображення поля description_ru тендера для користувача ${viewer}

##############################################################################################
#             MAIN DATA.VALUE
##############################################################################################

Відображення бюджету звіту про укладений договір
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення бюджету процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  ...  level2
  ...  critical
  Звірити відображення поля value.amount тендера для користувача ${viewer}


Відображення валюти звіту про укладений договір
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення бюджету процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  ...  level3
  ...  non-critical
  Звірити відображення поля value.currency тендера для користувача ${viewer}


Відображення врахованого податку в бюджет звіту про укладений договір
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення бюджету процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  ...  level3
  ...  non-critical
  Звірити відображення поля value.valueAddedTaxIncluded тендера для користувача ${viewer}

##############################################################################################
#             MAIN DATA.PROCURING ENTITY
##############################################################################################

Відображення країни замовника звіту про укладений договір
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення замовника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  ...  non-critical
  Звірити відображення поля procuringEntity.address.countryName тендера для користувача ${viewer}


Відображення населеного пункту замовника звіту про укладений договір
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення замовника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  ...  level3
  ...  non-critical
  Звірити відображення поля procuringEntity.address.locality тендера для користувача ${viewer}


Відображення поштового коду замовника звіту про укладений договір
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення замовника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  ...  level3
  ...  non-critical
  Звірити відображення поля procuringEntity.address.postalCode тендера для користувача ${viewer}


Відображення області замовника звіту про укладений договір
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення замовника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  ...  level3
  ...  non-critical
  Звірити відображення поля procuringEntity.address.region тендера для користувача ${viewer}


Відображення вулиці замовника звіту про укладений договір
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення замовника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  ...  level3
  ...  non-critical
  Звірити відображення поля procuringEntity.address.streetAddress тендера для користувача ${viewer}


Відображення контактного імені замовника звіту про укладений договір
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення замовника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  ...  level3
  ...  non-critical
  Звірити відображення поля procuringEntity.contactPoint.name тендера для користувача ${viewer}


Відображення контактного телефону замовника звіту про укладений договір
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення замовника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  ...  level3
  ...  non-critical
  Звірити відображення поля procuringEntity.contactPoint.telephone тендера для користувача ${viewer}


Відображення сайту замовника звіту про укладений договір
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення замовника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  ...  level3
  ...  non-critical
  Звірити відображення поля procuringEntity.contactPoint.url тендера для користувача ${viewer}


Відображення офіційного імені замовника звіту про укладений договір
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення замовника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  ...  level3
  ...  non-critical
  Звірити відображення поля procuringEntity.identifier.legalName тендера для користувача ${viewer}


Відображення схеми ідентифікації замовника звіту про укладений договір
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення замовника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  ...  non-critical
  Звірити відображення поля procuringEntity.identifier.scheme тендера для користувача ${viewer}


Відображення ідентифікатора замовника звіту про укладений договір
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення замовника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  ...  level3
  ...  non-critical
  Звірити відображення поля procuringEntity.identifier.id тендера для користувача ${viewer}


Відображення імені замовника звіту про укладений договір
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення замовника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  ...  level3
  ...  non-critical
  Звірити відображення поля procuringEntity.name тендера для користувача ${viewer}

##############################################################################################
#             MAIN DATA.ITEMS
##############################################################################################

Відображення опису номенклатури звіту про укладений договір
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення номенклатури процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  ...  level2
  ...  non-critical
  Звірити відображення поля description усіх предметів для користувача ${viewer}


Відображення схеми класифікації номенклатур звіту про укладений договір
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури процедури
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view
  ...      non-critical
  Звірити відображення поля classification.scheme усіх предметів для користувача ${viewer}


Відображення ідентифікатора класифікації номенклатур звіту про укладений договір
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури процедури
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view
  ...      non-critical
  Звірити відображення поля classification.id усіх предметів для користувача ${viewer}


Відображення опису класифікації номенклатур звіту про укладений договір
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури процедури
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view
  ...      non-critical
  Звірити відображення поля classification.description усіх предметів для користувача ${viewer}


Відображення кількості номенклатури звіту про укладений договір
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення номенклатури процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  ...  level2
  ...  non-critical
  Звірити відображення поля quantity усіх предметів для користувача ${viewer}


Відображення назви одиниці номенклатури звіту про укладений договір
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення номенклатури процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  ...  level2
  ...  non-critical
  Звірити відображення поля unit.name усіх предметів для користувача ${viewer}


Відображення коду одиниці номенклатури звіту про укладений договір
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення номенклатури процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  ...  non-critical
  Звірити відображення поля unit.code усіх предметів для користувача ${viewer}


Відображення дати доставки номенклатури звіту про укладений договір
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення номенклатури процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  ...  level3
  ...  non-critical
  Звірити відображення дати deliveryDate.endDate усіх предметів для користувача ${viewer}


Відображення координат доставки номенклатури звіту про укладений договір
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення номенклатури процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  ...  non-critical
  Звірити відображення координат усіх предметів для користувача ${viewer}


Відображення назви країни доставки номенклатури звіту про укладений договір
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення номенклатури процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  ...  level3
  ...  non-critical
  Звірити відображення поля deliveryAddress.countryName усіх предметів для користувача ${viewer}


Відображення назви країни російською мовою доставки номенклатури звіту про укладений договір
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення номенклатури процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view_countryName_ru
  ...  non-critical
  Звірити відображення поля deliveryAddress.countryName_ru усіх предметів для користувача ${viewer}


Відображення назви країни англійською мовою доставки номенклатури звіту про укладений договір
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення номенклатури процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view_countryName_en
  ...  non-critical
  Звірити відображення поля deliveryAddress.countryName_en усіх предметів для користувача ${viewer}


Відображення пошт. коду доставки номенклатури звіту про укладений договір
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення номенклатури процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  ...  level3
  ...  non-critical
  Звірити відображення поля deliveryAddress.postalCode усіх предметів для користувача ${viewer}


Відображення регіону доставки номенклатури звіту про укладений договір
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення номенклатури процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  ...  level3
  ...  non-critical
  Звірити відображення поля deliveryAddress.region усіх предметів для користувача ${viewer}


Відображення населеного пункту адреси доставки номенклатури звіту про укладений договір
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення номенклатури процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  ...  level3
  ...  non-critical
  Звірити відображення поля deliveryAddress.locality усіх предметів для користувача ${viewer}


Відображення вулиці доставки номенклатури звіту про укладений договір
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення номенклатури процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  ...  level3
  ...  non-critical
  Звірити відображення поля deliveryAddress.streetAddress усіх предметів для користувача ${viewer}

##############################################################################################
#             DOCUMENTS
##############################################################################################

Відображення заголовку документа звіту про укладений договір
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення документації процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  add_tender_doc
  ...  level3
  ...  non-critical
  Звірити відображення поля documents[0].title тендера із ${USERS.users['${tender_owner}']['tender_document']['doc_name']} для користувача ${viewer}

##############################################################################################
#             AWARDS
##############################################################################################

Відображення документації стосовно доданого постачальника
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення постачальника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  award_view
  ...  level2
  ...  non-critical
  Звірити відображення поля awards[0].documents[0].title тендера із ${USERS.users['${tender_owner}'].award_doc_name} для користувача ${viewer}


Відображення підтвердженого постачальника звіту про укладений договір
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення постачальника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  award_view
  ...  level2
  ...  non-critical
  Звірити відображення поля awards[0].status тендера із active для користувача ${viewer}


Відображення країни постачальника звіту про укладений договір
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення постачальника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  award_view
  ...  non-critical
  Звірити відображення поля awards[0].suppliers[0].address.countryName тендера із ${USERS.users['${tender_owner}']['supplier_data']['data']['suppliers'][0]['address']['countryName']} для користувача ${viewer}


Відображення міста постачальника звіту про укладений договір
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення постачальника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  award_view
  ...  level3
  ...  non-critical
  Звірити відображення поля awards[0].suppliers[0].address.locality тендера із ${USERS.users['${tender_owner}']['supplier_data']['data']['suppliers'][0]['address']['locality']} для користувача ${viewer}


Відображення поштового коду постачальника звіту про укладений договір
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення постачальника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  award_view
  ...  level3
  ...  non-critical
  Звірити відображення поля awards[0].suppliers[0].address.postalCode тендера із ${USERS.users['${tender_owner}']['supplier_data']['data']['suppliers'][0]['address']['postalCode']} для користувача ${viewer}


Відображення області постачальника звіту про укладений договір
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення постачальника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  award_view
  ...  level3
  ...  non-critical
  Звірити відображення поля awards[0].suppliers[0].address.region тендера із ${USERS.users['${tender_owner}']['supplier_data']['data']['suppliers'][0]['address']['region']} для користувача ${viewer}


Відображення вулиці постачальника звіту про укладений договір
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення постачальника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  award_view
  ...  level3
  ...  non-critical
  Звірити відображення поля awards[0].suppliers[0].address.streetAddress тендера із ${USERS.users['${tender_owner}']['supplier_data']['data']['suppliers'][0]['address']['streetAddress']} для користувача ${viewer}


Відображення контактного телефону постачальника звіту про укладений договір
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення постачальника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  award_view
  ...  level3
  ...  non-critical
  Звірити відображення поля awards[0].suppliers[0].contactPoint.telephone тендера із ${USERS.users['${tender_owner}']['supplier_data']['data']['suppliers'][0]['contactPoint']['telephone']} для користувача ${viewer}


Відображення контактного імені постачальника звіту про укладений договір
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення постачальника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  award_view
  ...  level3
  ...  non-critical
  Звірити відображення поля awards[0].suppliers[0].contactPoint.name тендера із ${USERS.users['${tender_owner}']['supplier_data']['data']['suppliers'][0]['contactPoint']['name']} для користувача ${viewer}


Відображення контактного імейлу постачальника звіту про укладений договір
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення постачальника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  award_view
  ...  level3
  ...  non-critical
  Звірити відображення поля awards[0].suppliers[0].contactPoint.email тендера із ${USERS.users['${tender_owner}']['supplier_data']['data']['suppliers'][0]['contactPoint']['email']} для користувача ${viewer}


Відображення схеми ідентифікації постачальника звіту про укладений договір
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення постачальника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  award_view
  ...  non-critical
  Звірити відображення поля awards[0].suppliers[0].identifier.scheme тендера із ${USERS.users['${tender_owner}']['supplier_data']['data']['suppliers'][0]['identifier']['scheme']} для користувача ${viewer}


Відображення офіційного імені постачальника звіту про укладений договір
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення постачальника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  award_view
  ...  level3
  ...  non-critical
  Звірити відображення поля awards[0].suppliers[0].identifier.legalName тендера із ${USERS.users['${tender_owner}']['supplier_data']['data']['suppliers'][0]['identifier']['legalName']} для користувача ${viewer}


Відображення ідентифікатора постачальника звіту про укладений договір
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення постачальника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  award_view
  ...  level3
  ...  non-critical
  Звірити відображення поля awards[0].suppliers[0].identifier.id тендера із ${USERS.users['${tender_owner}']['supplier_data']['data']['suppliers'][0]['identifier']['id']} для користувача ${viewer}


Відображення імені постачальника звіту про укладений договір
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення постачальника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  award_view
  ...  level3
  ...  non-critical
  Звірити відображення поля awards[0].suppliers[0].name тендера із ${USERS.users['${tender_owner}']['supplier_data']['data']['suppliers'][0]['name']} для користувача ${viewer}


Відображення врахованого податку до ціни номенклатури постачальника звіту про укладений договір
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення постачальника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  award_view
  ...  level3
  ...  non-critical
  Звірити відображення поля awards[0].value.valueAddedTaxIncluded тендера із ${USERS.users['${tender_owner}']['supplier_data']['data']['value']['valueAddedTaxIncluded']} для користувача ${viewer}


Відображення валюти ціни номенклатури постачальника звіту про укладений договір
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення постачальника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  award_view
  ...  level3
  ...  non-critical
  Звірити відображення поля awards[0].value.currency тендера із ${USERS.users['${tender_owner}']['supplier_data']['data']['value']['currency']} для користувача ${viewer}


Відображення вартості номенклатури постачальника звіту про укладений договір
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення постачальника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  award_view
  ...  level2
  ...  non-critical
  Звірити відображення поля awards[0].value.amount тендера із ${USERS.users['${tender_owner}']['supplier_data']['data']['value']['amount']} для користувача ${viewer}
