*** Settings ***
Resource           base_keywords.robot
Suite Setup        Test Suite Setup
Suite Teardown     Test Suite Teardown


*** Variables ***
${mode}         negotiation.quick
@{used_roles}   tender_owner  viewer

${number_of_items}  ${2}
${number_of_lots}   ${0}
${tender_meat}      ${False}
${lot_meat}      ${False}
${item_meat}      ${False}

*** Test Cases ***
##############################################################################################
#             MAIN
##############################################################################################

Можливість створити переговорну процедуру за нагальною потребою
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Можливість створити процедуру
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  create_tender
  ...  minimal
  ...  level1
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість оголосити тендер


Можливість додати документацію до переговорної процедури за нагальною потребою
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Можливість додати документацію до процедури
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  add_tender_doc
  ...  level2
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість додати документацію до тендера


Можливість зареєструвати і підтвердити постачальника до переговорної процедури за нагальною потребою
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Можливість зареєструвати і підтвердити постачальника до процедури
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  add_award
  ...  minimal
  ...  level1
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість зареєструвати, додати документацію і підтвердити постачальника до закупівлі

Можливість знайти переговорну процедуру за нагальною потребою по ідентифікатору
  [Tags]  ${USERS.users['${viewer}'].broker}: Можливість знайти процедуру
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  find_tender
  ...  minimal
  ...  level1
  Можливість знайти тендер по ідентифікатору для користувача ${viewer}

##############################################################################################
#             MAIN DATA
##############################################################################################

Відображення заголовку переговорної процедури за нагальною потребою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення основних даних процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  ...  level2
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля title тендера для користувача ${viewer}


Відображення заголовку переговорної процедури англійською мовою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення основних даних процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  Звірити відображення поля title_en тендера для користувача ${viewer}


Відображення заголовку переговорної процедури російською мовою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення основних даних процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  Звірити відображення поля title_ru тендера для користувача ${viewer}


Відображення ідентифікатора переговорної процедури за нагальною потребою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення основних даних процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  ...  level2
  Звірити відображення поля tenderID тендера із ${TENDER['TENDER_UAID']} для користувача ${viewer}


Відображення опису переговорної процедури за нагальною потребою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення основних даних процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  Звірити відображення поля description тендера для користувача ${viewer}


Відображення опису переговорної процедури за нагальною потребою англійською мовою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення основних даних процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  Звірити відображення поля description_en тендера для користувача ${viewer}


Відображення опису переговорної процедури за нагальною потребою російською мовою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення основних даних процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  Звірити відображення поля description_ru тендера для користувача ${viewer}


Відображення підстави вибору переговорної процедури за нагальгою потребою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення основних даних процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  ...  level2
  Звірити відображення поля causeDescription тендера для користувача ${viewer}


Відображення обгрунтування причини вибору переговорної процедури за нагальгою потребою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення основних даних процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  ...  level2
  Звірити відображення поля cause тендера для користувача ${viewer}

##############################################################################################
#             MAIN DATA.VALUE
##############################################################################################

Відображення бюджету переговорної процедури за нагальною потребою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення бюджету процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  ...  level2
  Звірити відображення поля value.amount тендера для користувача ${viewer}


Відображення валюти переговорної процедури за нагальною потребою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення бюджету процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  Звірити відображення поля value.currency тендера для користувача ${viewer}


Відображення врахованого податку в бюджет переговорної процедури за нагальною потребою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення бюджету процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  Звірити відображення поля value.valueAddedTaxIncluded тендера для користувача ${viewer}

##############################################################################################
#             MAIN DATA.PROCURING ENTITY
##############################################################################################

Відображення країни замовника переговорної процедури за нагальною потребою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення замовника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  Звірити відображення поля procuringEntity.address.countryName тендера для користувача ${viewer}


Відображення населеного пункту замовника переговорної процедури за нагальною потребою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення замовника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  Звірити відображення поля procuringEntity.address.locality тендера для користувача ${viewer}


Відображення поштового коду замовника переговорної процедури за нагальною потребою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення замовника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  Звірити відображення поля procuringEntity.address.postalCode тендера для користувача ${viewer}


Відображення області замовника переговорної процедури за нагальною потребою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення замовника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  Звірити відображення поля procuringEntity.address.region тендера для користувача ${viewer}


Відображення вулиці замовника переговорної процедури за нагальною потребою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення замовника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  Звірити відображення поля procuringEntity.address.streetAddress тендера для користувача ${viewer}


Відображення контактного імені замовника переговорної процедури за нагальною потребою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення замовника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  Звірити відображення поля procuringEntity.contactPoint.name тендера для користувача ${viewer}


Відображення контактного телефону замовника переговорної процедури за нагальною потребою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення замовника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  Звірити відображення поля procuringEntity.contactPoint.telephone тендера для користувача ${viewer}


Відображення сайту замовника переговорної процедури за нагальною потребою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення замовника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  Звірити відображення поля procuringEntity.contactPoint.url тендера для користувача ${viewer}


Відображення офіційного імені замовника переговорної процедури за нагальною потребою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення замовника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  Звірити відображення поля procuringEntity.identifier.legalName тендера для користувача ${viewer}


Відображення схеми ідентифікації замовника переговорної процедури за нагальною потребою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення замовника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  Звірити відображення поля procuringEntity.identifier.scheme тендера для користувача ${viewer}


Відображення ідентифікатора замовника переговорної процедури за нагальною потребою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення замовника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  Звірити відображення поля procuringEntity.identifier.id тендера для користувача ${viewer}


Відображення імені замовника переговорної процедури за нагальною потребою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення замовника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  Звірити відображення поля procuringEntity.name тендера для користувача ${viewer}

##############################################################################################
#             MAIN DATA.ITEMS
##############################################################################################

Відображення опису додаткової класифікації номенклатури переговорної процедури за нагальною потребою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення номенклатури процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  Звірити відображення поля additionalClassifications[0].description усіх предметів для користувача ${viewer}


Відображення ідентифікатора додаткової класифікації номенклатури переговорної процедури за нагальною потребою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення номенклатури процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  Звірити відображення поля additionalClassifications[0].id усіх предметів для користувача ${viewer}


Відображення схеми додаткової класифікації номенклатури переговорної процедури за нагальною потребою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення номенклатури процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  Звірити відображення поля additionalClassifications[0].scheme усіх предметів для користувача ${viewer}


Відображення схеми класифікації номенклатури переговорної процедури за нагальною потребою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення номенклатури процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  Звірити відображення поля classification.scheme усіх предметів для користувача ${viewer}


Відображення ідентифікатора класифікації номенклатури переговорної процедури за нагальною потребою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення номенклатури процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  Звірити відображення поля classification.id усіх предметів для користувача ${viewer}


Відображення опису класифікації номенклатури переговорної процедури за нагальною потребою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення номенклатури процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  Звірити відображення поля classification.description усіх предметів для користувача ${viewer}


Відображення опису номенклатури переговорної процедури за нагальною потребою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення номенклатури процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  ...  level2
  Звірити відображення поля description усіх предметів для користувача ${viewer}


Відображення кількості номенклатури переговорної процедури за нагальною потребою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення номенклатури процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  ...  level2
  Звірити відображення поля quantity усіх предметів для користувача ${viewer}


Відображення назви одиниці номенклатури переговорної процедури за нагальною потребою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення номенклатури процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  ...  level2
  Звірити відображення поля unit.name усіх предметів для користувача ${viewer}


Відображення коду одиниці номенклатури переговорної процедури за нагальною потребою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення номенклатури процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  Звірити відображення поля unit.code усіх предметів для користувача ${viewer}


Відображення дати доставки номенклатури переговорної процедури за нагальною потребою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення номенклатури процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  Звірити відображення дати deliveryDate.endDate усіх предметів для користувача ${viewer}


Відображення координат доставки номенклатури переговорної процедури за нагальною потребою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення номенклатури процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  Звірити відображення координат усіх предметів для користувача ${viewer}


Відображення назви нас. пункту доставки номенклатури переговорної процедури за нагальною потребою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення номенклатури процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  Звірити відображення поля deliveryAddress.countryName усіх предметів для користувача ${viewer}


Відображення назви нас. пункту російською мовою доставки номенклатури переговорної процедури за нагальною потребою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення номенклатури процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  Звірити відображення поля deliveryAddress.countryName_ru усіх предметів для користувача ${viewer}


Відображення назви нас. пункту англійською мовою доставки номенклатури переговорної процедури за нагальною потребою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення номенклатури процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  Звірити відображення поля deliveryAddress.countryName_en усіх предметів для користувача ${viewer}


Відображення пошт. коду доставки номенклатури переговорної процедури за нагальною потребою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення номенклатури процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  Звірити відображення поля deliveryAddress.postalCode усіх предметів для користувача ${viewer}


Відображення регіону доставки номенклатури переговорної процедури за нагальною потребою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення номенклатури процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  Звірити відображення поля deliveryAddress.region усіх предметів для користувача ${viewer}


Відображення населеного пункту адреси доставки номенклатури переговорної процедури за нагальною потребою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення номенклатури процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  Звірити відображення поля deliveryAddress.locality усіх предметів для користувача ${viewer}


Відображення вулиці доставки номенклатури переговорної процедури за нагальною потребою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення номенклатури процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_view
  Звірити відображення поля deliveryAddress.streetAddress усіх предметів для користувача ${viewer}

##############################################################################################
#             DOCUMENTS
##############################################################################################

Відображення заголовку документа переговорної процедури за нагальною потребою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення документації процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  add_tender_doc
  Звірити відображення поля documents[0].title тендера із ${USERS.users['${tender_owner}']['documents']['filepath']} для користувача ${viewer}

##############################################################################################
#             AWARDS
##############################################################################################

Відображення документації до постачальника
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення постачальника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  award_view
  ...  level2
  Звірити відображення поля awards[0].documents[0].title тендера із ${USERS.users['${tender_owner}'].award_document} для користувача ${viewer}

Відображення підтвердженого постачальника переговорної процедури за нагальною потребою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення постачальника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  award_view
  ...  level2
  Звірити відображення поля awards[0].status тендера із active для користувача ${viewer}


Відображення країни постачальника переговорної процедури за нагальною потребою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення постачальника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  award_view
  Звірити відображення поля awards[0].suppliers[0].address.countryName тендера із ${USERS.users['${tender_owner}']['supplier_data']['data']['suppliers'][0]['address']['countryName']} для користувача ${viewer}


Відображення міста постачальника переговорної процедури за нагальною потребою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення постачальника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  award_view
  Звірити відображення поля awards[0].suppliers[0].address.locality тендера із ${USERS.users['${tender_owner}']['supplier_data']['data']['suppliers'][0]['address']['locality']} для користувача ${viewer}


Відображення поштового коду постачальника переговорної процедури за нагальною потребою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення постачальника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  award_view
  Звірити відображення поля awards[0].suppliers[0].address.postalCode тендера із ${USERS.users['${tender_owner}']['supplier_data']['data']['suppliers'][0]['address']['postalCode']} для користувача ${viewer}


Відображення області постачальника переговорної процедури за нагальною потребою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення постачальника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  award_view
  Звірити відображення поля awards[0].suppliers[0].address.region тендера із ${USERS.users['${tender_owner}']['supplier_data']['data']['suppliers'][0]['address']['region']} для користувача ${viewer}


Відображення вулиці постачальника переговорної процедури за нагальною потребою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення постачальника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  award_view
  Звірити відображення поля awards[0].suppliers[0].address.streetAddress тендера із ${USERS.users['${tender_owner}']['supplier_data']['data']['suppliers'][0]['address']['streetAddress']} для користувача ${viewer}


Відображення контактного телефону постачальника переговорної процедури за нагальною потребою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення постачальника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  award_view
  Звірити відображення поля awards[0].suppliers[0].contactPoint.telephone тендера із ${USERS.users['${tender_owner}']['supplier_data']['data']['suppliers'][0]['contactPoint']['telephone']} для користувача ${viewer}


Відображення контактного імені постачальника переговорної процедури за нагальною потребою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення постачальника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  award_view
  Звірити відображення поля awards[0].suppliers[0].contactPoint.name тендера із ${USERS.users['${tender_owner}']['supplier_data']['data']['suppliers'][0]['contactPoint']['name']} для користувача ${viewer}


Відображення контактного імейлу постачальника переговорної процедури за нагальною потребою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення постачальника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  award_view
  Звірити відображення поля awards[0].suppliers[0].contactPoint.email тендера із ${USERS.users['${tender_owner}']['supplier_data']['data']['suppliers'][0]['contactPoint']['email']} для користувача ${viewer}


Відображення схеми ідентифікації постачальника переговорної процедури за нагальною потребою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення постачальника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  award_view
  Звірити відображення поля awards[0].suppliers[0].identifier.scheme тендера із ${USERS.users['${tender_owner}']['supplier_data']['data']['suppliers'][0]['identifier']['scheme']} для користувача ${viewer}


Відображення офіційного імені постачальника переговорної процедури за нагальною потребою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення постачальника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  award_view
  Звірити відображення поля awards[0].suppliers[0].identifier.legalName тендера із ${USERS.users['${tender_owner}']['supplier_data']['data']['suppliers'][0]['identifier']['legalName']} для користувача ${viewer}


Відображення ідентифікатора постачальника переговорної процедури за нагальною потребою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення постачальника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  award_view
  Звірити відображення поля awards[0].suppliers[0].identifier.id тендера із ${USERS.users['${tender_owner}']['supplier_data']['data']['suppliers'][0]['identifier']['id']} для користувача ${viewer}


Відображення імені постачальника переговорної процедури за нагальною потребою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення постачальника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  award_view
  Звірити відображення поля awards[0].suppliers[0].name тендера із ${USERS.users['${tender_owner}']['supplier_data']['data']['suppliers'][0]['name']} для користувача ${viewer}


Відображення врахованого податку до ціни номенклатури постачальника переговорної процедури за нагальною потребою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення постачальника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  award_view
  Звірити відображення поля awards[0].value.valueAddedTaxIncluded тендера із ${USERS.users['${tender_owner}']['supplier_data']['data']['value']['valueAddedTaxIncluded']} для користувача ${viewer}


Відображення валюти ціни номенклатури постачальника переговорної процедури за нагальною потребою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення постачальника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  award_view
  Звірити відображення поля awards[0].value.currency тендера із ${USERS.users['${tender_owner}']['supplier_data']['data']['value']['currency']} для користувача ${viewer}


Відображення вартості номенклатури постачальника переговорної процедури за нагальною потребою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення постачальника процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  award_view
  ...  level2
  Звірити відображення поля awards[0].value.amount тендера із ${USERS.users['${tender_owner}']['supplier_data']['data']['value']['amount']} для користувача ${viewer}

##############################################################################################
#             CONTRACTS
##############################################################################################

Неможливість укласти угоду для переговорної процедури за нагальною потребою поки не пройде stand-still період
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Можливість укласти угоду для процедури
  ...  ${tender_owner}
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  add_contract
  ...  level2
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  Run keyword and expect error  *  Можливість укласти угоду для закупівлі


Відображення статусу непідписаної угоди з постачальником переговорної процедури за нагальною потребою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення угоди з постачальником процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  add_contract
  ...  level2
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля contracts[0].status тендера із pending для користувача ${viewer}


Можливість укласти угоду для переговорної процедури за нагальною потребою
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Можливість укласти угоду для процедури
  ...  ${tender_owner}
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  add_contract
  ...  level1
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Дочекатись дати  ${USERS.users['${tender_owner}'].tender_data.data.awards[0].complaintPeriod.endDate}
  Можливість укласти угоду для закупівлі


Відображення статусу підписаної угоди з постачальником переговорної процедури за нагальною потребою
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення угоди з постачальником процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  add_contract
  ...  level1
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля contracts[0].status тендера із active для користувача ${viewer}
