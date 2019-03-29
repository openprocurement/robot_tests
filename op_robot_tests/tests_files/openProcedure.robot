*** Settings ***
Resource        base_keywords.robot
Suite Setup     Test Suite Setup
Suite Teardown  Test Suite Teardown


*** Variables ***
@{USED_ROLES}       tender_owner  provider  provider1  provider2  viewer

${NUMBER_OF_ITEMS}  ${1}
${TENDER_MEAT}      ${True}
${LOT_MEAT}         ${True}
${ITEM_MEAT}        ${True}


*** Test Cases ***
Можливість оголосити лот
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оголошення лоту
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_tender
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість оголосити тендер


Можливість знайти лот по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук лоту
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      find_tender
  Можливість знайти тендер по ідентифікатору для усіх користувачів

##############################################################################################
#             Відображення основних даних лоту
##############################################################################################

Відображення заголовку лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view
  Звірити відображення поля title тендера для користувача ${viewer}


Відображення мінімальної кількості учасників ацкуіону
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view_min_bids_number
  Звірити відображення поля minNumberOfQualifiedBids тендера для користувача ${viewer}


Відображення організатора аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view_landLease
  Звірити відображення поля lotHolder тендера для користувача ${viewer}


Відображення розміру реєстраційного внеску
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view_landLease
  Звірити відображення поля registrationFee.amount тендера для користувача ${viewer}


Відображення валюти реєстраційного внеску
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view_landLease
  Звірити відображення поля registrationFee.currency тендера для користувача ${viewer}


Відображення опису банківських реквізитів
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view_landLease
  Звірити відображення поля bankAccount.description тендера для користувача ${viewer}


Відображення найменування банку
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view_landLease
  Звірити відображення поля bankAccount.bankName тендера для користувача ${viewer}


Відображення схеми ідентифікатора акаунта банку
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view_landLease
  Звірити відображення поля bankAccount.accountIdentification[0].scheme тендера для користувача ${viewer}


Відображення номера ідентифікатора акаунта банку
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view_landLease
  Звірити відображення поля bankAccount.accountIdentification[0].id тендера для користувача ${viewer}


Відображення опису ідентифікатора акаунта банку
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view_landLease
  Звірити відображення поля bankAccount.accountIdentification[0].description тендера для користувача ${viewer}


Відображення вартості підготовки лоту до торгів
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view_landLease
  Звірити відображення поля budgetSpent.amount тендера для користувача ${viewer}


Відображення валюти вартості підготовки лоту до торгів
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view_landLease
  Звірити відображення поля budgetSpent.currency тендера для користувача ${viewer}


Відображення включеного податку до вартості підготовки лоту до торгів
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view_landLease
  Звірити відображення поля budgetSpent.valueAddedTaxIncluded тендера для користувача ${viewer}


Відображення типу умови контракту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view_landLease
  Звірити відображення поля contractTerms.type тендера для користувача ${viewer}


Відображення тривалості оренди
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view_landLease
  Звірити відображення поля contractTerms.leaseTerms.leaseDuration тендера для користувача ${viewer}


Відображення номера лоту замовника
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view_landLease
  Звірити відображення поля lotIdentifier тендера для користувача ${viewer}


Відображення номера лоту ФГВ
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view_dgf_id
  Звірити відображення поля dgfID тендера для користувача ${viewer}


Відображення поля "Лоти виставляються"
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view_tenderAttempts
  Звірити поле tenderAttempts тендера для користувача ${viewer}


Відображення опису лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view
  Звірити відображення поля description тендера для користувача ${viewer}


Відображення початкової вартості лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      tender_view
  Звірити відображення поля value.amount тендера для усіх користувачів


Відображення валюти лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view
  Звірити відображення поля value.currency тендера для користувача ${viewer}


Відображення ПДВ в бюджеті лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view
  Звірити відображення поля value.valueAddedTaxIncluded тендера для користувача ${viewer}


Відображення ідентифікатора лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view
  Звірити відображення поля auctionID тендера із ${TENDER['TENDER_UAID']} для користувача ${viewer}


Відображення імені організатора лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view
  Звірити відображення поля procuringEntity.name тендера для користувача ${viewer}


Відображення завершення періоду редагування лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      tender_view
  Отримати дані із поля rectificationPeriod.endDate тендера для усіх користувачів


Відображення початку періоду уточнення лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      tender_view_enquiryPeriod
  Отримати дані із поля enquiryPeriod.startDate тендера для усіх користувачів


Відображення закінчення періоду уточнення лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      tender_view_enquiryPeriod
  Отримати дані із поля enquiryPeriod.endDate тендера для усіх користувачів


Відображення початку періоду прийому пропозицій лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      tender_view_tenderPeriod_startDate
  Отримати дані із поля tenderPeriod.startDate тендера для усіх користувачів


Відображення закінчення періоду прийому пропозицій лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      tender_view_tenderPeriod
  Отримати дані із поля tenderPeriod.endDate тендера для усіх користувачів


Відображення мінімального кроку лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      tender_view
  Звірити відображення поля minimalStep.amount тендера для усіх користувачів


Відображення типу оголошеного лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      tender_view
  Звірити відображення поля procurementMethodType тендера для усіх користувачів

##############################################################################################
#             Відображення основних даних предмету
##############################################################################################

Відображення опису активів лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення активів лоту
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      tender_view
  Звірити відображення поля description усіх предметів для усіх користувачів


Відображення назви країни доставки активів лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view
  Звірити відображення поля address.countryName усіх предметів для користувача ${viewer}


Відображення пошт. коду доставки активів лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view
  Звірити відображення поля address.postalCode усіх предметів для користувача ${viewer}


Відображення регіону доставки активів лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view
  Звірити відображення поля address.region усіх предметів для користувача ${viewer}


Відображення нас. пункту доставки активів лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view
  Звірити відображення поля address.locality усіх предметів для користувача ${viewer}


Відображення вулиці доставки активів лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view
  Звірити відображення поля address.streetAddress усіх предметів для користувача ${viewer}


Відображення схеми класифікації активів лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення активів лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view
  Звірити відображення поля classification.scheme усіх предметів для користувача ${viewer}


Відображення ідентифікатора класифікації активів лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення активів лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view
  Звірити відображення поля classification.id усіх предметів для користувача ${viewer}


Відображення опису класифікації активів лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення активів лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view
  Звірити відображення поля classification.description усіх предметів для користувача ${viewer}


Відображення схеми додаткової класифікації активів лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення активів лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view_additionalClassifications
  Звірити відображення поля additionalClassifications[0].scheme усіх предметів для користувача ${viewer}


Відображення ідентифікатора додаткової класифікації активів лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення активів лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view_additionalClassifications
  Звірити відображення поля additionalClassifications[0].id усіх предметів для користувача ${viewer}


Відображення опису додаткової класифікації активів лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення активів лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view
  Звірити поле additionalClassifications[0].description тендера усіх предметів для користувача ${viewer}


Відображення назви одиниці активів лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення активів лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view
  Звірити відображення поля unit.name усіх предметів для користувача ${viewer}


Відображення коду одиниці активів лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення активів лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view_unit_code
  Звірити відображення поля unit.code усіх предметів для користувача ${viewer}


Відображення кількості активів лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення активів лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view
  Звірити відображення поля quantity усіх предметів для користувача ${viewer}


Відображення початку періоду контракту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення активів лоту
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      tender_view_contractPeriod
  Звірити відображення поля contractPeriod.startDate усіх предметів для усіх користувачів


Відображення кінця періоду контракту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення активів лоту
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      tender_view_contractPeriod
  Звірити відображення поля contractPeriod.endDate усіх предметів для усіх користувачів


Відображення гарантійного внеску
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      tender_view
  Звірити відображення поля guarantee.amount тендера для усіх користувачів


Можливість перевірити тривалість періоду редагування лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Відображення основних даних лоту
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      check_rectification_period
  ${rectificationPeriod_endDate}=  Отримати дані із тендера  ${tender_owner}  ${TENDER['TENDER_UAID']}  rectificationPeriod.endDate
  ${tenderPeriod_endDate}=  Отримати дані із тендера  ${tender_owner}  ${TENDER['TENDER_UAID']}  tenderPeriod.endDate
  Перевірити, чи тривалість між ${rectificationPeriod_endDate} і ${tenderPeriod_endDate} становить не менше 5 днів

##############################################################################################
#             Редагування лоту
##############################################################################################

Можливість змінити дані про організатора лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати лот
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_auction_procuringEntity_name
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_procuringEntity_name}=  create_fake_sentence
  Set To Dictionary  ${USERS.users['${tender_owner}']}  new_procuringEntity_name=${new_procuringEntity_name}
  Можливість змінити поле procuringEntity.name тендера на ${new_procuringEntity_name}


Відображення змінених даних про організатора лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      modify_auction_procuringEntity_name
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Run Keyword And Ignore Error  Remove From Dictionary  ${USERS.users['${viewer}'].tender_data.data.procuringEntity}  name
  Звірити відображення поля procuringEntity.name тендера із ${USERS.users['${tender_owner}'].new_procuringEntity_name} для користувача ${viewer}


Можливість змінити номер лоту замовника
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати лот
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_auction_lotIdentifier
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_lotIdentifier}=  create_fake_dgfID
  Set To Dictionary  ${USERS.users['${tender_owner}']}  new_lotIdentifier=${new_lotIdentifier}
  Можливість змінити поле lotIdentifier тендера на ${new_lotIdentifier}


Відображення зміненого номера лоту замовника
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      modify_auction_lotIdentifier
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Run Keyword And Ignore Error  Remove From Dictionary  ${USERS.users['${viewer}'].tender_data.data}  lotIdentifier
  Звірити відображення поля lotIdentifier тендера із ${USERS.users['${tender_owner}'].new_lotIdentifier} для користувача ${viewer}


Можливість змінити дані про організатора лоту ДЗК
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати лот
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_auction_lotHolder
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_lotHolder_name}=  create_fake_sentence
  Set To Dictionary  ${USERS.users['${tender_owner}']}  new_lotHolder_name=${new_lotHolder_name}
  Можливість змінити поле lotHolder.name тендера на ${new_lotHolder_name}


Відображення змінених даних про організатора лоту ДЗК
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      modify_auction_lotHolder
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Run Keyword And Ignore Error  Remove From Dictionary  ${USERS.users['${viewer}'].tender_data.data.lotHolder}  name
  Звірити відображення поля lotHolder.name тендера із ${USERS.users['${tender_owner}'].new_lotHolder_name} для користувача ${viewer}


Можливість змінити назву лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати лот
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_auction_title
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_title}=  create_fake_title  ua
  Set To Dictionary  ${USERS.users['${tender_owner}']}  new_title=${new_title}
  Можливість змінити поле title тендера на ${new_title}


Відображення зміненої назви лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      modify_auction_title
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Run Keyword And Ignore Error  Remove From Dictionary  ${USERS.users['${viewer}'].tender_data.data}  title
  Звірити відображення поля title тендера із ${USERS.users['${tender_owner}'].new_title} для користувача ${viewer}


Можливість змінити назву лоту російською мовою
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати лот
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_auction_title_ru
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_title}=  create_fake_title  ru
  Set To Dictionary  ${USERS.users['${tender_owner}']}  new_title=${new_title}
  Можливість змінити поле title_ru тендера на ${new_title}


Відображення зміненої назви лоту російською мовою
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      modify_auction_title_ru
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Run Keyword And Ignore Error  Remove From Dictionary  ${USERS.users['${viewer}'].tender_data.data}  title_ru
  Звірити відображення поля title_ru тендера із ${USERS.users['${tender_owner}'].new_title} для користувача ${viewer}


Можливість змінити назву лоту англійською мовою
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати лот
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_auction_title_en
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_title}=  create_fake_title  en
  Set To Dictionary  ${USERS.users['${tender_owner}']}  new_title=${new_title}
  Можливість змінити поле title_en тендера на ${new_title}


Відображення зміненої назви лоту англійською мовою
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      modify_auction_title_en
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Run Keyword And Ignore Error  Remove From Dictionary  ${USERS.users['${viewer}'].tender_data.data}  title_en
  Звірити відображення поля title_en тендера із ${USERS.users['${tender_owner}'].new_title} для користувача ${viewer}


Можливість змінити опис лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати лот
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_auction_description
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_description}=  create_fake_description  ua
  Set To Dictionary  ${USERS.users['${tender_owner}']}  new_description=${new_description}
  Можливість змінити поле description тендера на ${new_description}


Відображення зміненого опису лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      modify_auction_description
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Run Keyword And Ignore Error  Remove From Dictionary  ${USERS.users['${viewer}'].tender_data.data}  description
  Звірити відображення поля description тендера із ${USERS.users['${tender_owner}'].new_description} для користувача ${viewer}


Можливість змінити опис лоту російською мовою
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати лот
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_auction_description_ru
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_description}=  create_fake_description  ru
  Set To Dictionary  ${USERS.users['${tender_owner}']}  new_description_ru=${new_description}
  Можливість змінити поле description_ru тендера на ${new_description}


Відображення зміненого опису лоту російською мовою
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      modify_auction_description_ru
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Run Keyword And Ignore Error  Remove From Dictionary  ${USERS.users['${viewer}'].tender_data.data}  description_ru
  Звірити відображення поля description_ru тендера із ${USERS.users['${tender_owner}'].new_description_ru} для користувача ${viewer}


Можливість змінити опис лоту англійською мовою
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати лот
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_auction_description_en
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_description}=  create_fake_description  en
  Set To Dictionary  ${USERS.users['${tender_owner}']}  new_description_en=${new_description}
  Можливість змінити поле description_en тендера на ${new_description}


Відображення зміненого опису лоту англійською мовою
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      modify_auction_description_en
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Run Keyword And Ignore Error  Remove From Dictionary  ${USERS.users['${viewer}'].tender_data.data}  description_en
  Звірити відображення поля description_en тендера із ${USERS.users['${tender_owner}'].new_description_en} для користувача ${viewer}


Можливість змінити поле "Лоти виставляються"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Відображення основних даних лоту
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_tenderAttempts
  ${new_attempt}=  create_fake_tenderAttempts  ${USERS.users['${viewer}'].tender_data.data.tenderAttempts}
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Set To Dictionary  ${USERS.users['${tender_owner}']}  new_attempt=${new_attempt}
  Можливість змінити поле tenderAttempts тендера на ${new_attempt}


Відображення зміненого опису поля "Лоти виставляються"
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      modify_tenderAttempts
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Run Keyword And Ignore Error  Remove From Dictionary  ${USERS.users['${viewer}'].tender_data.data}  tenderAttempts
  Звірити відображення поля tenderAttempts тендера із ${USERS.users['${tender_owner}'].new_attempt} для користувача ${viewer}


Можливість змінити номер лоту ФГВ
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Відображення основних даних лоту
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_dgfID
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_dgfID}=  create_fake_dgfID
  Set To Dictionary  ${USERS.users['${tender_owner}']}  new_dgfID=${new_dgfID}
  Можливість змінити поле dgfID тендера на ${new_dgfID}


Відображення зміненого номер лоту ФГВ
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      modify_dgfID
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Run Keyword And Ignore Error  Remove From Dictionary  ${USERS.users['${viewer}'].tender_data.data}  dgfID
  Звірити відображення поля dgfID тендера із ${USERS.users['${tender_owner}'].new_dgfID} для користувача ${viewer}


Можливість змінити ПДВ в бюджеті лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати лот
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_auction_value_tax
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Run As  ${tender_owner}  Редагувати ПДВ  ${TENDER['TENDER_UAID']}


Відображення зміненого ПДВ в бюджеті лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      modify_auction_value_tax
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Run Keyword And Ignore Error  Remove From Dictionary  ${USERS.users['${viewer}'].tender_data.data.value}  valueAddedTaxIncluded
  ${tax_value}=  Convert to Boolean  True
  Звірити відображення поля value.valueAddedTaxIncluded тендера із ${tax_value} для користувача ${viewer}


Можливість змінити початкову вартість лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати лот
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_auction_value
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_amount}=  create_fake_value  ${USERS.users['${tender_owner}'].tender_data.data.value.amount}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  new_amount=${new_amount}
  Можливість змінити поле value.amount тендера на ${new_amount}


Відображення зміненої початкової вартості лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      modify_auction_value
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Run Keyword And Ignore Error  Remove From Dictionary  ${USERS.users['${viewer}'].tender_data.data.value}  amount
  Звірити відображення поля value.amount тендера із ${USERS.users['${tender_owner}'].new_amount} для користувача ${viewer}


Можливість змінити мінімальний крок лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати лот
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_auction_step
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_minimal_step}=  create_fake_minimal_step  ${USERS.users['${tender_owner}'].new_amount}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  new_minimal_step=${new_minimal_step}
  Можливість змінити поле minimalStep.amount тендера на ${new_minimal_step}


Відображення зміненого мінімального кроку лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      modify_auction_step
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Run Keyword And Ignore Error  Remove From Dictionary  ${USERS.users['${viewer}'].tender_data.data.minimalStep}  amount
  Звірити відображення поля minimalStep.amount тендера із ${USERS.users['${tender_owner}'].new_minimal_step} для користувача ${viewer}


Відображення зміненого ПДВ в сумі мінімального кроку лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      modify_auction_value_tax
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Run Keyword And Ignore Error  Remove From Dictionary  ${USERS.users['${viewer}'].tender_data.data.minimalStep}  valueAddedTaxIncluded
  ${tax_value}=  Convert to Boolean  True
  Звірити відображення поля minimalStep.valueAddedTaxIncluded тендера із ${tax_value} для користувача ${viewer}


Можливість змінити гарантування лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати лот
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_auction_guarantee
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_guarantee_amount}=  create_fake_guarantee  ${USERS.users['${tender_owner}'].tender_data.data.guarantee.amount}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  new_guarantee_value=${new_guarantee_amount}
  Можливість змінити поле guarantee.amount тендера на ${new_guarantee_amount}


Відображення зміненого гарантування лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      modify_auction_guarantee
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Run Keyword And Ignore Error  Remove From Dictionary  ${USERS.users['${viewer}'].tender_data.data.guarantee}  amount
  Звірити відображення поля guarantee.amount тендера із ${USERS.users['${tender_owner}'].new_guarantee_value} для користувача ${viewer}


Можливість змінити розмір реєстраційного внеску
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати лот
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_auction_registrationFee
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_guarantee_amount}=  create_fake_guarantee  ${USERS.users['${tender_owner}'].tender_data.data.registrationFee.amount}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  new_guarantee_value=${new_guarantee_amount}
  Можливість змінити поле guarantee.amount тендера на ${new_guarantee_amount}


Відображення зміненого розміру реєстраційного внеску
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      modify_auction_registrationFee
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Run Keyword And Ignore Error  Remove From Dictionary  ${USERS.users['${viewer}'].tender_data.data.registrationFee}  amount
  Звірити відображення поля guarantee.amount тендера із ${USERS.users['${tender_owner}'].new_guarantee_value} для користувача ${viewer}


Можливість змінити опис банківських реквізитів
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати лот
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_auction_bankAccount
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_bankAccount_description}=  create_fake_description  ua
  Set To Dictionary  ${USERS.users['${tender_owner}']}  new_bankAccount_description=${new_bankAccount_description}
  Можливість змінити поле bankAccount.description тендера на ${new_bankAccount_description}


Відображення зміненого опису банківських реквізитів
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      modify_auction_bankAccount
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Run Keyword And Ignore Error  Remove From Dictionary  ${USERS.users['${viewer}'].tender_data.data.bankAccount}  description
  Звірити відображення поля bankAccount.description тендера із ${USERS.users['${tender_owner}'].new_bankAccount_description} для користувача ${viewer}


Можливість змінити найменування банку
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати лот
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_auction_bankAccount
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_bankAccount_bankName}=  create_fake_bankName  ${USERS.users['${viewer}'].tender_data.data.bankAccount.bankName}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  new_bankAccount_bankName=${new_bankAccount_bankName}
  Можливість змінити поле bankAccount.bankName тендера на ${new_bankAccount_bankName}


Відображення зміненого найменування банку
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      modify_auction_bankAccount
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Run Keyword And Ignore Error  Remove From Dictionary  ${USERS.users['${viewer}'].tender_data.data.bankAccount}  bankName
  Звірити відображення поля bankAccount.bankName тендера із ${USERS.users['${tender_owner}'].new_bankAccount_bankName} для користувача ${viewer}


Можливість змінити основну інформацію про рахунок
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати лот
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_auction_bankAccount
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_bankAccount_accountIdentification}=  create_fake_description  ua
  Set To Dictionary  ${USERS.users['${tender_owner}']}  new_bankAccount_accountIdentification=${new_bankAccount_accountIdentification}
  Можливість змінити поле bankAccount.accountIdentification[0].description тендера на ${new_bankAccount_accountIdentification}


Відображення зміненої основної інформацію про рахунок
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      modify_auction_bankAccount
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Run Keyword And Ignore Error  Remove From Dictionary  ${USERS.users['${viewer}'].tender_data.data.bankAccount.accountIdentification[0]}  description
  Звірити відображення поля bankAccount.accountIdentification[0].description тендера із ${USERS.users['${tender_owner}'].new_bankAccount_accountIdentification} для користувача ${viewer}


Можливість змінити вартість підготовки лоту до торгів
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати лот
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_auction_budgetSpent
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_budgetSpent_amount}=  create_fake_value  ${USERS.users['${tender_owner}'].tender_data.data.value.amount}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  new_budgetSpent_amount=${new_budgetSpent_amount}
  Можливість змінити поле budgetSpent.amount тендера на ${new_budgetSpent_amount}


Відображення зміненої вартості підготовки лоту до торгів
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      modify_auction_budgetSpent
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Run Keyword And Ignore Error  Remove From Dictionary  ${USERS.users['${viewer}'].tender_data.data.budgetSpent}  amount
  Звірити відображення поля budgetSpent.amount тендера із ${USERS.users['${tender_owner}'].new_budgetSpent_amount} для користувача ${viewer}


Можливість змінити умови оренди
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати лот
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_auction_contractTerms
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_contractTerms_leaseTerms_leaseDuration}=  create_fake_month  ${USERS.users['${viewer}'].tender_data.data.contractTerms.leaseTerms.leaseDuration}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  new_contractTerms_leaseTerms_leaseDuration=${new_contractTerms_leaseTerms_leaseDuration}
  Можливість змінити поле contractTerms.leaseTerms.leaseDuration тендера на ${new_contractTerms_leaseTerms_leaseDuration}


Відображення змінених умов оренди
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      modify_auction_contractTerms
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Run Keyword And Ignore Error  Remove From Dictionary  ${USERS.users['${viewer}'].tender_data.data.contractTerms.leaseTerms}  leaseDuration
  Звірити відображення поля contractTerms.leaseTerms.leaseDuration тендера із ${USERS.users['${tender_owner}'].new_contractTerms_leaseTerms_leaseDuration} для користувача ${viewer}


Можливість внести зміни до кількості одиниць виміру активу об’єкта МП
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати об'єкт МП
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_asset
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${quantity}=  create_fake_items_quantity
  Set To Dictionary  ${USERS.users['${tender_owner}']}  quantity=${quantity}
  Можливість змінити поле quantity предмета 0 на ${quantity}


Відображення зміненої кількості одиниць виміру активу об’єкта МП
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних об'єкта МП
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      modify_asset
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Run Keyword And Ignore Error  Remove From Dictionary  ${USERS.users['${viewer}'].tender_data.data['items'][0]}  quantity
  Звірити відображення поля quantity зміненого предмета 0 із ${USERS.users['${tender_owner}'].quantity} для користувача ${viewer}


Можливість внести зміни до ідентифікатора класифікації активу об’єкта МП
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати об'єкт МП
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_classification_id
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_id}=  create_fake_scheme_id_geb
  Set To Dictionary  ${USERS.users['${tender_owner}']}  new_id=${new_id}
  Можливість змінити поле classification.id предмета 0 на ${new_id}


Відображення зміненого ідентифікатора класифікації активу об’єкта МП
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних об'єкта МП
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      modify_classification_id
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  Run Keyword And Ignore Error  Remove From Dictionary  ${USERS.users['${viewer}'].tender_data.data['items'][0].classification}  id
  Звірити відображення поля classification.id зміненого предмета 0 із ${USERS.users['${tender_owner}'].new_id} для користувача ${viewer}


Можливість внести зміни до опису активу об’єкта МП
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати об'єкт МП
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_asset_description
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_description}=  create_fake_item_description
  Set To Dictionary  ${USERS.users['${tender_owner}']}  new_description=${new_description}
  Можливість змінити поле description предмета 0 на ${new_description}


Відображення зміненого опису активу об’єкта МП
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних об'єкта МП
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      modify_asset_description
  Run Keyword And Ignore Error  Remove From Dictionary  ${USERS.users['${viewer}'].tender_data.data['items'][0]}  description
  Звірити відображення поля items[0].description тендера із ${USERS.users['${tender_owner}'].new_description} для користувача ${viewer}


Можливість додати актив лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування лота
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_item
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість додати предмет закупівлі в тендер


Можливість видалити актив лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування лота
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      delete_item
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість видалити предмет закупівлі з тендера

##############################################################################################
#             Document
##############################################################################################

Можливість додати документацію до лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Додання документації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_tender_doc
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість додати документацію до тендера


Можливість завантажити ілюстрацію лоту аукціону
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Додання документації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_tender_illustration_test
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість завантажити документ до тендера з типом illustration


Можливість завантажити кваліфікаційні вимоги до лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Додання документації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_tender_evaluationCriteria
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість завантажити документ до тендера з типом evaluationCriteria


Можливість завантажити типовий договір до лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Додання документації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_tender_contractProforma
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість завантажити документ до тендера з типом contractProforma


Можливість завантажити документ з описом причин редагування
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Додання документації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_tender_clarifications
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість завантажити документ до тендера з типом clarifications


Можливість завантажити договір про нерозголошення до лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Додання документації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_tender_nda
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість завантажити документ до тендера з типом x_nda


Можливість завантажити паспорт торгів до лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Додання документації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_tender_notice
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість завантажити документ до тендера з типом tenderNotice


Можливість завантажити презентацію до лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Додання документації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_tender_presentation
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість завантажити документ до тендера з типом x_presentation


Можливість завантажити публічний паспорт активу до лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Додання документації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_tender_tech_specifications
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість завантажити документ до тендера з типом technicalSpecifications


Можливість завантажити документ про кількість
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Додання документації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_tender_billOfQuantity
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість завантажити документ до тендера з типом billOfQuantity


Можливість завантажити документ про виявлені конфлікти інтересів
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Додання документації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_tender_conflictOfInterest
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість завантажити документ до тендера з типом conflictOfInterest


Можливість завантажити звіт про оцінку
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Додання документації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_tender_evaluationReports
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість завантажити документ до тендера з типом evaluationReports


Можливість завантажити критерії прийнятності
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Додання документації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_tender_eligibilityCriteria
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість завантажити документ до тендера з типом eligibilityCriteria


Можливість завантажити ліцензію
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Додання документації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_tender_x_financialLicense
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість завантажити документ до тендера з типом x_financialLicense


Можливість завантажити документ з віртуальним номером даних
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Додання документації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_tender_x_virtualDataRoom
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість завантажити документ до тендера з типом x_virtualDataRoom


Можливість завантажити договір про нерозголошення
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Додання документації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_tender_x_nda
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість завантажити документ до тендера з типом x_nda


Можливість завантажити кваліфікаційні документи
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Додання документації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_tender_x_qualificationDocuments
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість завантажити документ до тендера з типом x_qualificationDocuments


Можливість завантажити документ про подробиці скасування
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Додання документації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_tender_cancellationDetails
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість завантажити документ до тендера з типом cancellationDetails


Можливість завантажити документ з умовами ознайомлення з майном/активом у кімнаті даних
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Додання документації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_tender_asset_familiarization
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість додати офлайн документ


Відображення заголовку документації до лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення документації
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      add_tender_doc
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля title документа ${USERS.users['${tender_owner}']['tender_document']['doc_id']} із ${USERS.users['${tender_owner}'].tender_document.doc_name} для користувача ${viewer}


Відображення вмісту документації до лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення документації
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      add_tender_doc_content
  Звірити відображення вмісту документа ${USERS.users['${tender_owner}'].tender_document.doc_id} із ${USERS.users['${tender_owner}'].tender_document.doc_content} для користувача ${viewer}

##############################################################################################
#             QUESTIONS
##############################################################################################

Можливість задати запитання на лот
  [Tags]   ${USERS.users['${provider}'].broker}: Задання запитання
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      ask_question_to_tender
  [Teardown]  Оновити LMD і дочекатись синхронізації  ${provider}
  Можливість задати запитання на тендер користувачем ${provider}


Відображення заголовку анонімного запитання на лот без відповіді
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення запитання
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      ask_question_to_tender
  Звірити відображення поля title запитання на тендер для усіх користувачів


Відображення опису анонімного запитання на лот без відповіді
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення запитання
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      ask_question_to_tender
  Звірити відображення поля description запитання на тендер для усіх користувачів


Можливість відповісти на запитання на лот
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Відповідь на запитання
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      answer_question_to_tender
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LMD і дочекатись синхронізації  ${tender_owner}
  Можливість відповісти на запитання на тендер


Відображення відповіді на запитання на лот
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення відповіді на запитання
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      answer_question_to_tender
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля answer запитання на тендер для користувача ${viewer}


Можливість задати запитання на всі предмети
  [Tags]   ${USERS.users['${provider}'].broker}: Задання запитання
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      ask_question_to_item
  [Teardown]  Оновити LMD і дочекатись синхронізації  ${provider}
  :FOR  ${item_index}  IN RANGE  ${NUMBER_OF_ITEMS}
  \  Можливість задати запитання на ${item_index} предмет користувачем ${provider}


Відображення заголовку анонімного запитання на всі предмети без відповіді
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення запитання
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      ask_question_to_item
  :FOR  ${item_index}  IN RANGE  ${NUMBER_OF_ITEMS}
  \  Звірити відображення поля title запитання на ${item_index} предмет для усіх користувачів


Відображення опису анонімного запитання на всі предмети без відповіді
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення запитання
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      ask_question_to_item
  :FOR  ${item_index}  IN RANGE  ${NUMBER_OF_ITEMS}
  \  Звірити відображення поля description запитання на ${item_index} предмет для усіх користувачів


Можливість відповісти на запитання на всі предмети
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Відповідь на запитання
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      answer_question_to_item
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LMD і дочекатись синхронізації  ${tender_owner}
  :FOR  ${item_index}  IN RANGE  ${NUMBER_OF_ITEMS}
  \  Можливість відповісти на запитання на ${item_index} предмет


Відображення відповіді на запитання на всі предмети
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення відповіді на запитання
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      answer_question_to_item
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  :FOR  ${item_index}  IN RANGE  ${NUMBER_OF_ITEMS}
  \  Звірити відображення поля answer запитання на ${item_index} предмет для користувача ${viewer}


Можливість внести зміни у лот після запитання
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування лота
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_tender_after_questions
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_description}=  create_fake_sentence
  Можливість змінити поле description тендера на ${new_description}
  Remove From Dictionary  ${USERS.users['${tender_owner}'].tender_data.data}  description


Можливість додати актив лоту після запитання
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування лота
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_item
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість додати предмет закупівлі в тендер


Відображення опису нової номенклатури
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури лота
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      add_item
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля description у новоствореному предметі для усіх користувачів

##############################################################################################
#             BIDDING
##############################################################################################

Неможливість подати пропозицію першим учасником без кваліфікації
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      make_bid_by_provider_without_qualification
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Неможливість подати цінову попрозицію без кваліфікації користувачем ${provider}


Можливість подати пропозицію першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      make_bid_by_provider
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати цінову пропозицію користувачем ${provider}


Можливість зменшити пропозицію до невалідної для кваліфікації першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      bid_lower_by_provider
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість зменшити пропозицію до невалідної користувачем ${provider}


Можливість збільшити пропозицію на 10% першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      modify_bid_by_provider
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість збільшити пропозицію до 110 відсотків користувачем ${provider}


Можливість завантажити документ в пропозицію першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      add_doc_to_bid_by_provider
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість завантажити документ в пропозицію користувачем ${provider}


Можливість змінити документацію цінової пропозиції першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      modify_doc_to_bid_by_provider
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість змінити документацію цінової пропозиції користувачем ${provider}


Можливість додати ілюстрацію до лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Додання документації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_tender_illustration
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість додати ілюстрацію до тендера


Можливість підтвердити цінову пропозицію після завантаження ілюстрації до лоту першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      confirm_first_bid
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість підтвердити цінову пропозицію учасником ${provider}


Можливість подати пропозицію другим учасником
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      make_bid_by_provider1
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати цінову пропозицію користувачем ${provider1}


Можливість зменшити пропозицію до невалідної для кваліфікації другим учасником
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      modify_bid_by_provider1
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість зменшити пропозицію до невалідної користувачем ${provider1}


Можливість подати пропозицію третім учасником
  [Tags]   ${USERS.users['${provider2}'].broker}: Подання пропозиції
  ...      provider2
  ...      ${USERS.users['${provider2}'].broker}
  ...      make_bid_by_provider2
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати цінову пропозицію користувачем ${provider2}


Можливість зменшити пропозицію до невалідної для кваліфікації третім учасником
  [Tags]   ${USERS.users['${provider2}'].broker}: Подання пропозиції
  ...      provider2
  ...      ${USERS.users['${provider2}'].broker}
  ...      modify_bid_by_provider2
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість зменшити пропозицію до невалідної користувачем ${provider2}


Можливість змінити назву лоту українською мовою після подачі пропозиції
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати лот
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_auction_title_after_bidding
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_title}=  create_fake_title  ua
  Set To Dictionary  ${USERS.users['${tender_owner}']}  new_title=${new_title}
  Можливість змінити поле title тендера на ${new_title}


Відображення зміненої назви лоту українською мовою після подачі пропозиції
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      modify_auction_title_after_bidding
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Run Keyword And Ignore Error  Remove From Dictionary  ${USERS.users['${viewer}'].tender_data.data}  title
  Звірити відображення поля title тендера із ${USERS.users['${tender_owner}'].new_title} для користувача ${viewer}


Можливість підтвердити цінову пропозицію після зміни умов лоту першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      confirm_first_bid
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість підтвердити цінову пропозицію учасником ${provider}


Можливість підтвердити цінову пропозицію після зміни умов лоту другим учасником
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      confirm_second_bid
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість підтвердити цінову пропозицію учасником ${provider1}


Можливість підтвердити цінову пропозицію після зміни умов лоту третім учасником
  [Tags]   ${USERS.users['${provider2}'].broker}: Подання пропозиції
  ...      provider2
  ...      ${USERS.users['${provider2}'].broker}
  ...      confirm_third_bid
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість підтвердити цінову пропозицію учасником ${provider2}


Відображення дати внесення останніх змін
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      tender_view_invalidationDate
  Отримати дані із поля rectificationPeriod.invalidationDate тендера для усіх користувачів

##############################################################################################

Можливість скасувати пропозицію першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      cancel_bid_by_provider
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість скасувати цінову пропозицію користувачем ${provider}


Можливість скасувати пропозицію другим учасником
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      cancel_bid_by_provider1
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість скасувати цінову пропозицію користувачем ${provider1}


Неможливість побачити цінові пропозиції учасників під час прийому пропозицій
  [Tags]   ${USERS.users['${viewer}'].broker}: Подання пропозиції
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      bid_view_in_tendering_period
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Require Failure  ${viewer}  Отримати інформацію із тендера  ${TENDER['TENDER_UAID']}  bids

##############################################################################################

Неможливість змінити опис лоту після завершення періоду редагування лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати лот
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_auction_description
  [Setup]  Дочекатись дати закінчення періоду редагування лоту  ${tender_owner}  ${TENDER['TENDER_UAID']}
  ${new_description}=  create_fake_description  ua
  Перевірити неможливість зміни поля description тендера на значення ${new_description} для користувача ${tender_owner}


Неможливість змінити опис лоту російською мовою після завершення періоду редагування лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати лот
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_auction_description
  [Setup]  Дочекатись дати закінчення періоду редагування лоту  ${tender_owner}  ${TENDER['TENDER_UAID']}
  ${new_description}=  create_fake_description  ru
  Перевірити неможливість зміни поля description_ru тендера на значення ${new_description} для користувача ${tender_owner}


Неможливість змінити опис лоту англійською мовою після завершення періоду редагування лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати лот
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_auction_description
  [Setup]  Дочекатись дати початку прийому пропозицій  ${tender_owner}  ${TENDER['TENDER_UAID']}
  ${new_description}=  create_fake_description  en
  Перевірити неможливість зміни поля description_en тендера на значення ${new_description} для користувача ${tender_owner}


Неможливість змінити дані про організатора лоту після завершення періоду редагування лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати лот
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_auction_procuringEntity
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  ${new_procuringEntity_name}=  create_fake_sentence
  Перевірити неможливість зміни поля procuringEntity.name тендера на значення ${new_procuringEntity_name} для користувача ${tender_owner}


Неможливість змінити назву лоту українською мовою після завершення періоду редагування лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати лот
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_auction_title
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  ${new_title}=  create_fake_title  ua
  Перевірити неможливість зміни поля title тендера на значення ${new_title} для користувача ${tender_owner}


Неможливість змінити назву лоту російською мовою після завершення періоду редагування лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати лот
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_auction_title
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  ${new_title}=  create_fake_title  ru
  Перевірити неможливість зміни поля title_ru тендера на значення ${new_title} для користувача ${tender_owner}


Неможливість змінити назву лоту англійською мовою після завершення періоду редагування лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати лот
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_auction_title
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  ${new_title}=  create_fake_title  en
  Перевірити неможливість зміни поля title_en тендера на значення ${new_title} для користувача ${tender_owner}


Неможливість змінити початок періоду подання пропозицій лоту після завершення періоду редагування лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати лот
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_auction_periods
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  ${new_value}=  Get Current Date
  Перевірити неможливість зміни поля tenderPeriod.startDate тендера на значення ${new_value} для користувача ${tender_owner}


Неможливість змінити кінець періоду уточнення лоту після завершення періоду редагування лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати лот
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_auction_enquiryPeriod
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  ${new_value}=  Set Variable  ${USERS.users['${tender_owner}'].tender_data.data.auctionPeriod.shouldStartAfter}
  Перевірити неможливість зміни поля enquiryPeriod.endDate тендера на значення ${new_value} для користувача ${tender_owner}


Неможливість змінити поле "Лоти виставляються" після завершення періоду редагування лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Відображення основних даних лоту
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_tenderAttempts
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  ${new_attempt}=  create_fake_tenderAttempts  ${USERS.users['${viewer}'].tender_data.data.tenderAttempts}
  Перевірити неможливість зміни поля tenderAttempts тендера на значення ${new_attempt} для користувача ${tender_owner}


Неможливість змінити номер лоту ФГВ після завершення періоду редагування лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Відображення основних даних лоту
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_dgfID
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  ${new_dgfID}=  create_fake_dgfID
  Перевірити неможливість зміни поля dgfID тендера на значення ${new_dgfID} для користувача ${tender_owner}


Неможливість змінити початкову вартість лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Відображення основних даних лоту
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_tenderAttempts
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  ${new_amount}=  create_fake_value  ${USERS.users['${tender_owner}'].tender_data.data.value.amount}
  Перевірити неможливість зміни поля value.amount тендера на значення ${new_amount} для користувача ${tender_owner}


Неможливість змінити ПДВ в бюджеті лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Відображення основних даних лоту
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_tenderAttempts
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  Require Failure  ${tender_owner}  Редагувати ПДВ  ${TENDER['TENDER_UAID']}


Неможливість змінити мінімальний крок лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати лот
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_auction_step
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  ${new_minimal_step}=  create_fake_minimal_step  ${USERS.users['${tender_owner}'].new_amount}
  Перевірити неможливість зміни поля minimalStep.amount тендера на значення ${new_minimal_step} для користувача ${tender_owner}


Неможливість змінити гарантування лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати лот
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_auction_guarantee
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  ${new_guarantee_amount}=  create_fake_guarantee  ${USERS.users['${tender_owner}'].new_amount}
  Перевірити неможливість зміни поля guarantee.amount тендера на значення ${new_guarantee_amount} для користувача ${tender_owner}


Неможливість додати актив лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування лота
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_item
  Неможливість додати предмет закупівлі в тендер


Неможливість видалити актив лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування лота
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      delete_item
  Неможливість видалити предмет закупівлі з тендера


Неможливість додати документацію до лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування лота
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_tender_doc_after_bidding
  Неможливість додати документацію до лоту


Неможливість редагувати документ
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування лота
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      edit_document
  Неможливість редагувати документ  ${tender_owner}  ${TENDER['TENDER_UAID']}

##############################################################################################
#             PRE-QUALIFICATION
##############################################################################################

Можливість завантажити аукціонний квиток в пропозицію першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      add_eligibilityDocuments_to_bid_by_provider
  [Setup]  Дочекатись дати закінчення прийому пропозицій  ${tender_owner}  ${TENDER['TENDER_UAID']}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість завантажити документ з типом eligibilityDocuments в пропозицію користувачем ${provider}


Можливість кваліфікувати пропозицію першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      make_bid_qualify_by_provider
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість кваліфікувати цінову пропозицію 1 користувачем ${provider}


Можливість завантажити аукціонний квиток в пропозицію другим учасником
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      add_eligibilityDocuments_to_bid_by_provider1
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість завантажити документ з типом eligibilityDocuments в пропозицію користувачем ${provider1}


Можливість кваліфікувати пропозицію другим учасником
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      make_bid_qualify_by_provider1
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість кваліфікувати цінову пропозицію 2 користувачем ${provider1}

##############################################################################################
#             AFTER BIDDING
##############################################################################################

Неможливість завантажити документ першим учасником після закінчення прийому пропозицій
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider1}'].broker}
  ...      add_bid_doc_after_tendering_period_by_provider
  [Setup]  Дочекатись дати закінчення прийому пропозицій  ${viewer}  ${TENDER['TENDER_UAID']}
  Run Keyword And Expect Error  *  Можливість завантажити документ в пропозицію користувачем ${provider}


Неможливість подати пропозицію після закінчення подачі пропозицій першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      make_bid_after_tendering_period
  [Setup]  Дочекатись дати закінчення прийому пропозицій  ${viewer}  ${TENDER['TENDER_UAID']}
  Run Keyword And Expect Error  *  Можливість подати цінову пропозицію користувачем ${provider}


Неможливість змінити існуючу документацію пропозиції першим учасником після закінчення прийому пропозицій
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider1}'].broker}
  ...      modify_bid_doc_after_tendering_period_by_provider
  Run Keyword And Expect Error  *  Можливість змінити документацію цінової пропозиції користувачем ${provider}


Неможливість задати запитання на лот після закінчення періоду подання пропозицій
  [Tags]   ${USERS.users['${provider}'].broker}: Задання запитання
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      ask_question_to_tender_after_tendering_period
  [Setup]  Дочекатись дати закінчення прийому пропозицій  ${provider}  ${TENDER['TENDER_UAID']}
  Run Keyword And Expect Error  *  Можливість задати запитання на тендер користувачем ${provider}


Неможливість задати запитання на перший предмет після закінчення періоду подання пропозицій
  [Tags]   ${USERS.users['${provider}'].broker}: Задання запитання
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      ask_question_to_item_after_tendering_period
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  Run Keyword And Expect Error  *  Можливість задати запитання на 0 предмет користувачем ${provider}


Неможливість збільшити цінову пропозицію на 5% другим учасником після закінчення прийому пропозицій
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      modify_bid_after_tendering_period_by_provider1
  [Setup]  Дочекатись дати закінчення прийому пропозицій  ${provider1}  ${TENDER['TENDER_UAID']}
  Require Failure  ${provider1}  Можливість збільшити пропозицію до 105 відсотків користувачем ${provider1}


Неможливість скасувати пропозицію другим учасником після закінчення прийому пропозицій
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      cancel_bid_after_tendering_period_by_provider1
  Run Keyword And Expect Error  *  Можливість скасувати цінову пропозицію користувачем ${provider1}


Можливість вичитати посилання на аукціон для глядача
  [Tags]   ${USERS.users['${viewer}'].broker}: Процес аукціону
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      auction_url
  [Setup]  Дочекатись дати початку періоду аукціону  ${viewer}  ${TENDER['TENDER_UAID']}
  Можливість вичитати посилання на аукціон для глядача


Можливість вичитати посилання на аукціон для першого учасника
  [Tags]   ${USERS.users['${provider}'].broker}: Процес аукціону
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      auction_url
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  Можливість вичитати посилання на аукціон для учасника ${provider}


Можливість вичитати посилання на аукціон для другого учасника
  [Tags]   ${USERS.users['${provider1}'].broker}: Процес аукціону
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      auction_url_provider1
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider1}
  Можливість вичитати посилання на аукціон для учасника ${provider1}


Можливість вичитати посилання на аукціон для третього учасника
  [Tags]   ${USERS.users['${provider2}'].broker}: Процес аукціону
  ...      provider2
  ...      ${USERS.users['${provider2}'].broker}
  ...      auction_url_provider2
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider2}
  Можливість вичитати посилання на аукціон для учасника ${provider2}


Відображення неуспішного статусу лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Подання пропозиції
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      absence_bid
  [Setup]  Дочекатись дати закінчення прийому пропозицій  ${viewer}  ${TENDER['TENDER_UAID']}
  Звірити cтатус неуспішного тендера  ${viewer}  ${TENDER['TENDER_UAID']}