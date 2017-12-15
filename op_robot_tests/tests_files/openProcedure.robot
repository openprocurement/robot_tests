*** Settings ***
Resource        base_keywords.robot
Resource        aboveThreshold_keywords.robot
Suite Setup     Test Suite Setup
Suite Teardown  Test Suite Teardown


*** Variables ***
${MODE}             esco
@{USED_ROLES}       tender_owner  provider  provider1  provider2  viewer
${DIALOGUE_TYPE}    EU

${NUMBER_OF_ITEMS}  ${1}
${NUMBER_OF_LOTS}   ${1}
${TENDER_MEAT}      ${True}
${LOT_MEAT}         ${True}
${ITEM_MEAT}        ${True}


*** Test Cases ***
Possibility to announce a lot
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Tender announcement
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_tender  level1
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість оголосити тендер


Possibility to find a procurement by identificator
  [Tags]   ${USERS.users['${viewer}'].broker}: Tender search
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      find_tender  level1
  ...      critical
  Можливість знайти тендер по ідентифікатору для усіх користувачів

##############################################################################################
#             Відображення основних даних тендера
##############################################################################################

Displaying of tender name
  [Tags]   ${USERS.users['${viewer}'].broker}: Displaying of tender main data
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view  level1
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля title тендера для користувача ${viewer}


Displaying of tender description
  [Tags]   ${USERS.users['${viewer}'].broker}: Displaying of tender main data
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view  level2
  ...      non-critical
  Звірити відображення поля description тендера для користувача ${viewer}


Displaying of minimal step percentage value of a tender
  [Tags]   ${USERS.users['${viewer}'].broker}: Displaying of tender main data
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view  level2
  ...      critical
  Отримати дані із поля minimalStepPercentage тендера для усіх користувачів


Displaying of NBU discount rate
  [Tags]   ${USERS.users['${viewer}'].broker}: Displaying of tender main data
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view  level2
  ...      critical
  Звірити відображення поля NBUdiscountRate тендера для користувача ${viewer}


Displaying of the procurement funding kind
  [Tags]   ${USERS.users['${viewer}'].broker}: Displaying of tender main data
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view  level2
  ...      critical
  Звірити відображення поля fundingKind тендера для користувача ${viewer}


Displaying of yearly payments percentage range of a tender
  [Tags]   ${USERS.users['${viewer}'].broker}: Displaying of tender main data
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view  level2
  ...      critical
  Отримати дані із поля yearlyPaymentsPercentageRange тендера для усіх користувачів


Displaying of tender identificator
  [Tags]   ${USERS.users['${viewer}'].broker}: Displaying of tender main data
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view  level2
  ...      critical
  Звірити відображення поля tenderID тендера із ${TENDER['TENDER_UAID']} для користувача ${viewer}


Displaying of procurement entity name
  [Tags]   ${USERS.users['${viewer}'].broker}: Displaying of tender main data
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view  level2
  ...      critical
  Звірити відображення поля procuringEntity.name тендера для користувача ${viewer}


Displaying of enquiry period start date
  [Tags]   ${USERS.users['${viewer}'].broker}: Displaying of tender main data
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view
  ...      non-critical
  Run Keyword IF  'esco' in '${MODE}'
  ...      Отримати дані із поля enquiryPeriod.startDate тендера для усіх користувачів
  ...      ELSE
  ...      Звірити відображення дати enquiryPeriod.startDate тендера для усіх користувачів


Displaying of enquiry period end date
  [Tags]   ${USERS.users['${viewer}'].broker}: Displaying of tender main data
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view  level2
  ...      critical
  Run Keyword IF  'esco' in '${MODE}'
  ...      Отримати дані із поля enquiryPeriod.endDate тендера для усіх користувачів
  ...      ELSE
  ...      Звірити відображення дати enquiryPeriod.endDate тендера для усіх користувачів


Displaying of tendering period start date
  [Tags]   ${USERS.users['${viewer}'].broker}: Displaying of tender main data
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view  level2
  ...      non-critical
  Звірити відображення дати tenderPeriod.startDate тендера для усіх користувачів


Displaying of tendering period end date
  [Tags]   ${USERS.users['${viewer}'].broker}: Displaying of tender main data
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view  level2
  ...      critical
  Звірити відображення дати tenderPeriod.endDate тендера для усіх користувачів


Displaying of the created tender type
  [Tags]   ${USERS.users['${viewer}'].broker}: Displaying of tender main data
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      open_tender_view  level2
  ...      non-critical
  Звірити відображення поля procurementMethodType тендера для усіх користувачів


Displaying of complaint period end date
  [Tags]   ${USERS.users['${viewer}'].broker}: Displaying of tender main data
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      open_tender_view
  Отримати дані із поля complaintPeriod.endDate тендера для усіх користувачів

##############################################################################################
#             Відображення основних даних предмету
##############################################################################################

Displaying of tender item description
  [Tags]   ${USERS.users['${viewer}'].broker}: Displaying of tender items
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view  level2
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля description усіх предметів для усіх користувачів


Displaying of delivery location of a tender item
  [Tags]   ${USERS.users['${viewer}'].broker}: Displaying of tender items
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view
  ...      non-critical
  Звірити відображення координат усіх предметів для користувача ${viewer}


Displaying of delivery locality of a tender item
  [Tags]   ${USERS.users['${viewer}'].broker}: Displaying of tender items
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view  level2
  ...      non-critical
  Звірити відображення поля deliveryAddress.countryName усіх предметів для користувача ${viewer}


Displaying of a delivery postal code of a tender item
  [Tags]   ${USERS.users['${viewer}'].broker}: Displaying of tender items
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view
  ...      non-critical
  Звірити відображення поля deliveryAddress.postalCode усіх предметів для користувача ${viewer}


Displaying of a delivery region of a tender item
  [Tags]   ${USERS.users['${viewer}'].broker}: Displaying of tender items
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view  level2
  ...      non-critical
  Звірити відображення поля deliveryAddress.region усіх предметів для користувача ${viewer}


Displaying of delivery locality address of a tender item
  [Tags]   ${USERS.users['${viewer}'].broker}: Displaying of tender items
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view
  ...      non-critical
  Звірити відображення поля deliveryAddress.locality усіх предметів для користувача ${viewer}


Displaying of a delivery street of a tender item
  [Tags]   ${USERS.users['${viewer}'].broker}: Displaying of tender items
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view
  ...      non-critical
  Звірити відображення поля deliveryAddress.streetAddress усіх предметів для користувача ${viewer}


Displaying of the main/additional classification of a tender item
  [Tags]   ${USERS.users['${viewer}'].broker}: Displaying of tender items
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view
  Звірити відображення поля classification.scheme усіх предметів для користувача ${viewer}
  Run Keyword If  "${USERS.users['${tender_owner}'].initial_data.data['items'][0]['classification']['description']}" == "Не визначено"
  ...      Звірити відображення поля additionalClassifications[0].scheme усіх предметів для користувача ${viewer}


Displaying of an identificator of the main/additional classification of a tender item
  [Tags]   ${USERS.users['${viewer}'].broker}: Displaying of tender items
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view
  Звірити відображення поля classification.id усіх предметів для користувача ${viewer}
  Run Keyword If  "${USERS.users['${tender_owner}'].initial_data.data['items'][0]['classification']['description']}" == "Не визначено"
  ...      Звірити відображення поля additionalClassifications[0].id усіх предметів для користувача ${viewer}


Displaying of desciption of the main/additional classification of a tender item
  [Tags]   ${USERS.users['${viewer}'].broker}: Displaying of tender items
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view
  Звірити відображення поля classification.description усіх предметів для користувача ${viewer}
  Run Keyword If  "${USERS.users['${tender_owner}'].initial_data.data['items'][0]['classification']['description']}" == "Не визначено"
  ...      Звірити відображення поля additionalClassifications[0].description усіх предметів для користувача ${viewer}


Displaying of a unit name of a tender item
  [Tags]   ${USERS.users['${viewer}'].broker}: Displaying of tender items
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view  level2
  ...      non-critical
  Звірити відображення поля unit.name усіх предметів для користувача ${viewer}


Displaying of a unit code of a tender item
  [Tags]   ${USERS.users['${viewer}'].broker}: Displaying of tender items
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view
  ...      non-critical
  Звірити відображення поля unit.code усіх предметів для користувача ${viewer}

##############################################################################################
#             Відображення основних даних лоту
##############################################################################################

Displaying of lot name
  [Tags]   ${USERS.users['${viewer}'].broker}: Displaying of tender lots
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      lot_view  level1
  ...      critical
  Звірити відображення поля title усіх лотів для усіх користувачів


Displaying of lot description
  [Tags]   ${USERS.users['${viewer}'].broker}: Displaying of tender lots
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      lot_view  level2
  ...      critical
  Звірити відображення поля description усіх лотів для користувача ${viewer}


Displaying of minimal step percentage value of a lot
  [Tags]   ${USERS.users['${viewer}'].broker}: Displaying of tender lots
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      lot_view  level2
  ...      critical
  Звірити відображення поля minimalStepPercentage усіх лотів для користувача ${viewer}


Displaying of the lot funding kind
  [Tags]   ${USERS.users['${viewer}'].broker}: Displaying of tender lots
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      lot_view  level2
  ...      critical
  Звірити відображення поля fundingKind усіх лотів для користувача ${viewer}


Displaying of yearly payments percentage range of a lot
  [Tags]   ${USERS.users['${viewer}'].broker}: Displaying of tender lots
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      lot_view  level2
  ...      critical
  Звірити відображення поля yearlyPaymentsPercentageRange усіх лотів для користувача ${viewer}

##############################################################################################
#             Відображення основних даних предмету
##############################################################################################

Displaying of tender non-price criteria name
  [Tags]   ${USERS.users['${viewer}'].broker}: Displaying of non-price criteria
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      meat_view  level2
  ...      critical
  Звірити відображення поля title усіх нецінових показників для усіх користувачів


Displaying of non-price criteria description
  [Tags]   ${USERS.users['${viewer}'].broker}: Displaying of non-price criteria
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      meat_view  level2
  ...      critical
  Звірити відображення поля description усіх нецінових показників для користувача ${viewer}


Displaying of non-price criteria relation
  [Tags]   ${USERS.users['${viewer}'].broker}: Displaying of non-price criteria
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      meat_view  level2
  ...      non-critical
  Звірити відображення поля featureOf усіх нецінових показників для користувача ${viewer}

##############################################################################################
#             Редагування тендера
##############################################################################################

Possibility to change tendering period end date by one day
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Possibility to edit a tender
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      extend_tendering_period  level3
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${endDate}=  add_minutes_to_date  ${USERS.users['${tender_owner}'].tender_data.data.tenderPeriod.endDate}  1
  Можливість змінити поле tenderPeriod.endDate тендера на ${endDate}
  Remove From Dictionary  ${USERS.users['${tender_owner}'].tender_data.data.tenderPeriod}  endDate


Displaying the changes of tendering period end date
  [Tags]   ${USERS.users['${viewer}'].broker}: Displaying of main tender data
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      extend_tendering_period  level2
  ...      non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення дати tenderPeriod.endDate тендера для усіх користувачів


Possibility to add documentation to a tender
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Documents addition
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_tender_doc  level3
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість додати документацію до тендера


Possibility to add documentation to all lots
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Documents addition
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_lot_doc  level3
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість додати документацію до всіх лотів


Displaying of tender documentation title
  [Tags]   ${USERS.users['${viewer}'].broker}: Documents displaying
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      add_tender_doc  level2
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля title документа ${USERS.users['${tender_owner}']['tender_document']['doc_id']} із ${USERS.users['${tender_owner}'].tender_document.doc_name} для користувача ${viewer}


Можливість отримати інформацію про документацію до тендера
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Відображення документації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      get_file_properties
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  Отримати інформацію про документ тендера ${USERS.users['${tender_owner}'].tender_document.doc_id} ${tender_owner}


Можливість отримати інформацію про документацію до лотів
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Відображення документації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      get_file_properties
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  Отримати інформацію про документ лотів ${USERS.users['${tender_owner}'].lots_documents[0].doc_id} ${tender_owner}


Можливість перевірити інформацію про документацію до тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення документації
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      compare_file_properties
  Завантажити дані про тендер
  Звірити інформацію про документацію ${USERS.users['${viewer}'].tender_file_properties} ${viewer}


Можливість перевірити інформацію про документацію до лотів
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення документації
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      compare_file_properties
  Завантажити дані про тендер
  Звірити інформацію про документацію ${USERS.users['${viewer}'].lot_file_properties} ${viewer}


Displaying of lots documentation title
  [Tags]   ${USERS.users['${viewer}'].broker}: Documents displaying
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      add_lot_doc  level2
  ...      critical
  Звірити відображення заголовку документації до всіх лотів для користувача ${viewer}


Displaying of tender documentation content
  [Tags]   ${USERS.users['${viewer}'].broker}: Documents displaying
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      add_tender_doc  level2
  ...      critical
  Звірити відображення вмісту документа ${USERS.users['${tender_owner}'].tender_document.doc_id} із ${USERS.users['${tender_owner}'].tender_document.doc_content} для користувача ${viewer}


Displaying of lots documentation content
  [Tags]   ${USERS.users['${viewer}'].broker}: Documents displaying
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      add_lot_doc  level2
  ...      critical
  Звірити відображення вмісту документації до всіх лотів для користувача ${viewer}


Можливість створення лоту із прив’язаним предметом закупівлі
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_lot  level3
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість створення лоту із прив’язаним предметом закупівлі


Відображення опису номенклатури у новому лоті
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      add_lot  level2
  ...      non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля description у новоствореному предметі для усіх користувачів


Відображення заголовку нового лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення лоту тендера
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      add_lot  level2
  ...      non-critical
  Звірити відображення поля title у новоствореному лоті для усіх користувачів


Possibility to add an item to a procurement
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Tender editing
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_item  level3
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Run Keyword IF  ${NUMBER_OF_LOTS} == 0
  ...      Можливість додати предмет закупівлі в тендер
  ...      ELSE
  ...      Можливість додати предмет закупівлі в -1 лот


Displaying of new items description
  [Tags]   ${USERS.users['${viewer}'].broker}: Displaying of tender items
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      add_item  level2
  ...      non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля description у новоствореному предметі для усіх користувачів


Possibility to delete an item
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Tender editing
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      delete_item  level3
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Run Keyword IF  ${NUMBER_OF_LOTS} == 0
  ...      Можливість видалити предмет закупівлі з тендера
  ...      ELSE
  ...      Можливість видалити предмет закупівлі з -1 лоту


Можливість видалення лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування тендера
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      delete_lot
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість видалення -1 лоту


Possibility to add tender non-price criteria
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Add tender non-price criteria
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_tender_meat  level3
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість додати неціновий показник на тендер


Displaying of a title of a tender non-price criteria
  [Tags]   ${USERS.users['${viewer}'].broker}: Displaying of non-price criteria
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      add_tender_meat  level2
  ...      non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля title у новоствореному неціновому показнику для усіх користувачів


Displaying of a discription of a tender non-price criteria
  [Tags]   ${USERS.users['${viewer}'].broker}: Displaying of non-price criteria
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      add_tender_meat
  ...      non-critical
  Звірити відображення поля description у новоствореному неціновому показнику для користувача ${viewer}


Displaying of a tender non-price criteria relation
  [Tags]   ${USERS.users['${viewer}'].broker}: Displaying of non-price criteria
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      add_tender_meat
  ...      non-critical
  Звірити відображення поля featureOf у новоствореному неціновому показнику для користувача ${viewer}


Possibility to delete a tender non-price criteria
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Delete non-price criteria
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      delete_tender_meat  level3
  ...      critical
  Можливість видалити -1 неціновий показник


Possibility to add the first lot non-price criteria
  [Tags]   ${USERS.users['${tender_owner}'].broker}:  Add a lot non-price criteria
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_lot_meat  level3
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість додати неціновий показник на 0 лот


Displaying of a title of a lot non-price criteria
  [Tags]   ${USERS.users['${viewer}'].broker}: Displaying of non-price criteria
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      add_lot_meat  level2
  ...      non-critical
  Звірити відображення поля title у новоствореному неціновому показнику для усіх користувачів


Displaying of a discription of a lot non-price criteria
  [Tags]   ${USERS.users['${viewer}'].broker}: Displaying of non-price criteria
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      add_lot_meat
  ...      non-critical
  Звірити відображення поля description у новоствореному неціновому показнику для користувача ${viewer}


Displaying of a lot non-price criteria relation
  [Tags]   ${USERS.users['${viewer}'].broker}: Displaying of non-price criteria
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      add_lot_meat
  ...      non-critical
  Звірити відображення поля featureOf у новоствореному неціновому показнику для користувача ${viewer}


Possibility to delete a lot non-price criteria
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Delete non-price criteria
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      delete_lot_meat  level3
  ...      critical
  Можливість видалити -1 неціновий показник


Possibility to add the first item non-price criteria
  [Tags]   ${USERS.users['${tender_owner}'].broker}:  Add a lot non-price criteria
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_item_meat  level3
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість додати неціновий показник на 0 предмет


Displaying of a title of an item non-price criteria
  [Tags]   ${USERS.users['${viewer}'].broker}: Displaying of non-price criteria
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      add_item_meat  level2
  ...      non-critical
  Звірити відображення поля title у новоствореному неціновому показнику для усіх користувачів


Displaying of a discription of an item non-price criteria
  [Tags]   ${USERS.users['${viewer}'].broker}: Displaying of non-price criteria
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      add_item_meat
  ...      non-critical
  Звірити відображення поля description у новоствореному неціновому показнику для користувача ${viewer}


Displaying of an item non-price criteria relation
  [Tags]   ${USERS.users['${viewer}'].broker}: Displaying of non-price criteria
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      add_item_meat
  ...      non-critical
  Звірити відображення поля featureOf у новоствореному неціновому показнику для користувача ${viewer}


Possibility to delete an item non-price criteria
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Delete non-price criteria
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      delete_item_meat  level3
  ...      critical
  Можливість видалити -1 неціновий показник

##############################################################################################
#             QUESTIONS
##############################################################################################

Possibility to ask a question about tender
  [Tags]   ${USERS.users['${provider}'].broker}: Asking questions
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      ask_question_to_tender
  ...      critical
  [Setup]  Дочекатись дати початку періоду уточнень  ${provider}  ${TENDER['TENDER_UAID']}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість задати запитання на тендер користувачем ${provider}


Displaying of a title of an anonymous tender question without answers
  [Tags]   ${USERS.users['${viewer}'].broker}: Question displaying
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      ask_question_to_tender
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля title запитання на тендер для усіх користувачів


Displaying of description of an anonymous tender question without answers
  [Tags]   ${USERS.users['${viewer}'].broker}: Question displaying
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      ask_question_to_tender
  ...      non-critical
  Звірити відображення поля description запитання на тендер для користувача ${viewer}


Possibility to answer a tender question
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Answers to questions
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      answer_question_to_tender
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість відповісти на запитання на тендер


Displaying of an answer to a tender question
  [Tags]   ${USERS.users['${viewer}'].broker}: Displaying of answers to questions
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      answer_question_to_tender
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля answer запитання на тендер для користувача ${viewer}


Possibility to ask a question about all items
  [Tags]   ${USERS.users['${provider}'].broker}: Asking questions
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      ask_question_to_item
  ...      critical
  [Setup]  Дочекатись дати початку періоду уточнень  ${provider}  ${TENDER['TENDER_UAID']}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  :FOR  ${item_index}  IN RANGE  ${NUMBER_OF_ITEMS}
  \  Можливість задати запитання на ${item_index} предмет користувачем ${provider}


Displaying of a title of an anonymous question about items without answers
  [Tags]   ${USERS.users['${viewer}'].broker}: Question displaying
  ...      viewer tender_owner provider provider1
  ...      ${USERS.users['${viewer}'].broker}
  ...      ask_question_to_item
  ...      non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  :FOR  ${item_index}  IN RANGE  ${NUMBER_OF_ITEMS}
  \  Звірити відображення поля title запитання на ${item_index} предмет для усіх користувачів


Displaying of description of an anonymous question about items without answers
  [Tags]   ${USERS.users['${viewer}'].broker}: Question displaying
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      ask_question_to_item
  ...      critical
  :FOR  ${item_index}  IN RANGE  ${NUMBER_OF_ITEMS}
  \  Звірити відображення поля description запитання на ${item_index} предмет для користувача ${viewer}


Possibility to answer all questions about all items
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Answers to questions
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      answer_question_to_item
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  :FOR  ${item_index}  IN RANGE  ${NUMBER_OF_ITEMS}
  \  Можливість відповісти на запитання на ${item_index} предмет


Displaying of answers to all questions about all items
  [Tags]   ${USERS.users['${viewer}'].broker}: Displaying of answers to questions
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      answer_question_to_item
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  :FOR  ${item_index}  IN RANGE  ${NUMBER_OF_ITEMS}
  \  Звірити відображення поля answer запитання на ${item_index} предмет для користувача ${viewer}


Possibility to ask a question about all lots
  [Tags]   ${USERS.users['${provider}'].broker}: Asking questions
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      ask_question_to_lot
  ...      critical
  [Setup]  Дочекатись дати початку періоду уточнень  ${provider}  ${TENDER['TENDER_UAID']}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  :FOR  ${lot_index}  IN RANGE  ${NUMBER_OF_LOTS}
  \  Можливість задати запитання на ${lot_index} лот користувачем ${provider}


Displaying of a title of an anonymous question about lots without answers
  [Tags]   ${USERS.users['${viewer}'].broker}: Question displaying
  ...      viewer tender_owner provider provider1
  ...      ${USERS.users['${viewer}'].broker}
  ...      ask_question_to_lot
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  :FOR  ${lot_index}  IN RANGE  ${NUMBER_OF_LOTS}
  \  Звірити відображення поля title запитання на ${lot_index} лот для усіх користувачів


Displaying of desciption of an anonymous question about lots without answers
  [Tags]   ${USERS.users['${viewer}'].broker}: Question displaying
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      ask_question_to_lot
  ...      non-critical
  :FOR  ${lot_index}  IN RANGE  ${NUMBER_OF_LOTS}
  \  Звірити відображення поля description запитання на ${lot_index} лот для користувача ${viewer}


Possibility to answer questions about all lots
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Answers to questions
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      answer_question_to_lot
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  :FOR  ${lot_index}  IN RANGE  ${NUMBER_OF_LOTS}
  \  Можливість відповісти на запитання на ${lot_index} лот


Displaying of answers to questions about all lots
  [Tags]   ${USERS.users['${viewer}'].broker}: Displaying of answers to questions
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      answer_question_to_lot
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  :FOR  ${lot_index}  IN RANGE  ${NUMBER_OF_LOTS}
  \  Звірити відображення поля answer запитання на ${lot_index} лот для користувача ${viewer}


Possibility to introduce changes into a tender after a question
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Tender editing
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_tender_after_questions
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_description}=  create_fake_sentence
  Можливість змінити поле description тендера на ${new_description}
  Remove From Dictionary  ${USERS.users['${tender_owner}'].tender_data.data}  description


Possibility to introduce changes into a lot after question
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Tender editing
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_lot_after_questions
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_description}=  create_fake_sentence
  Можливість змінити поле description 0 лоту на ${new_description}
  Remove From Dictionary  ${USERS.users['${tender_owner}'].tender_data.data.lots[0]}  description

##############################################################################################
#             TENDER COMPLAINTS
##############################################################################################

Possibility to create a claim for procurement terms correction, add documentation to it and file it by user
  [Tags]  ${USERS.users['${provider}'].broker}: Complaint procedure
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  create_tender_claim
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість створити вимогу про виправлення умов закупівлі із документацією


Displaying of description of a claim for procurement terms correction
  [Tags]  ${USERS.users['${viewer}'].broker}: Complaint displaying
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  create_tender_claim
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля description вимоги із ${USERS.users['${provider}'].tender_claim_data.claim.data.description} для користувача ${viewer}


Displaying of an identificator of a claim for procurement terms correction
  [Tags]  ${USERS.users['${viewer}'].broker}: Complaint displaying
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  create_tender_claim
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля complaintID вимоги із ${USERS.users['${provider}'].tender_claim_data.complaintID} для користувача ${viewer}


Displaying of a title of a claim for procurement terms correction
  [Tags]  ${USERS.users['${viewer}'].broker}: Complaint displaying
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  create_tender_claim
  Звірити відображення поля title вимоги із ${USERS.users['${provider}'].tender_claim_data.claim.data.title} для користувача ${viewer}


Displaying of a document title of a claim for procurement terms correction
  [Tags]  ${USERS.users['${viewer}'].broker}: Complaint displaying
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  create_tender_claim
  Звірити відображення поля title документа ${USERS.users['${provider}'].tender_claim_data.doc_id} до скарги ${USERS.users['${provider}'].tender_claim_data.complaintID} з ${USERS.users['${provider}'].tender_claim_data.doc_name} для користувача ${viewer}


Displaying of document content of a claim for procurement terms correction
  [Tags]  ${USERS.users['${viewer}'].broker}: Complaint displaying
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  create_tender_claim
  Звірити відображення вмісту документа ${USERS['${provider}'].tender_claim_data.doc_id} до скарги ${USERS.users['${provider}'].tender_claim_data.complaintID} з ${USERS['${provider}'].tender_claim_data.doc_content} для користувача ${viewer}


Displaying of the status of a claim for procurement terms correction
  [Tags]  ${USERS.users['${viewer}'].broker}: Complaint displaying
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  create_tender_claim
  Звірити відображення поля status вимоги із claim для користувача ${viewer}


Possibility to answer a claim for procurement terms correction
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Complaint procedure
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  answer_tender_claim
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість відповісти resolved на вимогу про виправлення умов tender


Displaying of the 'answered' status of a claim for procurement terms correction
  [Tags]  ${USERS.users['${viewer}'].broker}: Complaint displaying
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  answer_tender_claim
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status вимоги із answered для користувача ${viewer}


Displaying of a solution kind of a claim for procurement terms correction
  [Tags]  ${USERS.users['${viewer}'].broker}: Complaint displaying
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  answer_tender_claim
  Звірити відображення поля resolutionType вимоги із ${USERS.users['${tender_owner}'].tender_claim_data.claim_answer.data.resolutionType} для користувача ${viewer}


Displaying of a solution of a claim for procurement terms correction
  [Tags]  ${USERS.users['${viewer}'].broker}: Complaint displaying
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  answer_tender_claim
  Звірити відображення поля resolution вимоги із ${USERS.users['${tender_owner}'].tender_claim_data.claim_answer.data.resolution} для користувача ${viewer}


Possibility to confirm the satisfaction of a claim for procurement terms correction
  [Tags]  ${USERS.users['${provider}'].broker}: Complaint procedure
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  resolve_tender_claim
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість підтвердити задоволення вимоги про виправлення умов закупівлі


Displaying of the 'resolved' status of a claim for procurement terms correction
  [Tags]  ${USERS.users['${viewer}'].broker}: Complaint displaying
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  resolve_tender_claim
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status вимоги із resolved для користувача ${viewer}


Displaying of satisfaction of a claim for procurement terms correction
  [Tags]  ${USERS.users['${viewer}'].broker}: Complaint displaying
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  resolve_tender_claim
  Звірити відображення поля satisfied вимоги із ${USERS.users['${provider}'].tender_claim_data.claim_answer_confirm.data.satisfied} для користувача ${viewer}


Можливість перетворити вимогу про виправлення умов закупівлі в скаргу
  [Tags]  ${USERS.users['${provider}'].broker}: Complaint procedure
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  escalate_tender_claim
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість перетворити вимогу про виправлення умов закупівлі в скаргу


Відображення статусу 'pending' після 'claim -> answered' вимоги про виправлення умов закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  escalate_tender_claim
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status вимоги із pending для користувача ${viewer}


Відображення незадоволення вимоги про виправлення умов закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  escalate_tender_claim
  Звірити відображення поля satisfied вимоги із ${USERS.users['${provider}'].tender_claim_data.escalation.data.satisfied} для користувача ${viewer}


Можливість скасувати вимогу/скаргу про виправлення умов закупівлі
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  cancel_tender_claim
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість скасувати вимогу про виправлення умов закупівлі


Відображення статусу 'cancelled' вимоги/скарги про виправлення умов закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  cancel_tender_claim
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status вимоги із cancelled для користувача ${viewer}


Відображення причини скасування вимоги/скарги про виправлення умов закупівлі
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  cancel_tender_claim
  Звірити відображення поля cancellationReason вимоги із ${USERS.users['${provider}'].tender_claim_data.cancellation.data.cancellationReason} для користувача ${viewer}


Possibility to introduce changes into a tender after complaining about procurement terms
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Tender editing
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_tender_after_claim
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_description}=  create_fake_sentence
  Можливість змінити поле description тендера на ${new_description}
  Remove From Dictionary  ${USERS.users['${tender_owner}'].tender_data.data}  description

##############################################################################################
#             LOT COMPLAINTS
##############################################################################################

Possibility to create and file a claim for lot terms correction
  [Tags]  ${USERS.users['${provider}'].broker}: Complaint procedure
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  create_lot_claim
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість створити вимогу про виправлення умов 0 лоту із документацією


Displaying of description of a claim for lot terms correction
  [Tags]  ${USERS.users['${viewer}'].broker}: Complaint displaying
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  create_lot_claim
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля description вимоги про виправлення умов 0 лоту із ${USERS.users['${provider}'].lot_claim_data.claim.data.description} для користувача ${viewer}


Displaying of identificator of a claim for lot terms correction
  [Tags]  ${USERS.users['${viewer}'].broker}: Complaint displaying
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  create_lot_claim
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля complaintID вимоги про виправлення умов 0 лоту із ${USERS.users['${provider}'].lot_claim_data.complaintID} для користувача ${viewer}


Displaying of a title of a claim for lot terms correction
  [Tags]  ${USERS.users['${viewer}'].broker}: Complaint displaying
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  create_lot_claim
  Звірити відображення поля title вимоги про виправлення умов 0 лоту із ${USERS.users['${provider}'].lot_claim_data.claim.data.title} для користувача ${viewer}


Displaying of a document title of a claim for lot terms correction
  [Tags]  ${USERS.users['${viewer}'].broker}: Complaint displaying
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  create_lot_claim
  Звірити відображення поля title документа ${USERS.users['${provider}'].lot_claim_data.doc_id} до скарги ${USERS.users['${provider}'].lot_claim_data.complaintID} з ${USERS.users['${provider}'].lot_claim_data.doc_name} для користувача ${viewer}


Displaying of document content of a claim for lot terms correction
  [Tags]  ${USERS.users['${viewer}'].broker}: Complaint displaying
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  create_lot_claim
  Звірити відображення вмісту документа ${USERS['${provider}'].lot_claim_data.doc_id} до скарги ${USERS.users['${provider}'].lot_claim_data.complaintID} з ${USERS['${provider}'].lot_claim_data.doc_content} для користувача ${viewer}


Displaying of the status of a claim for lot terms correction
  [Tags]  ${USERS.users['${viewer}'].broker}: Complaint displaying
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  create_lot_claim
  Звірити відображення поля status вимоги про виправлення умов 0 лоту із claim для користувача ${viewer}


Possibility to answer a claim for lot terms correction
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Complaint procedure
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  answer_lot_claim
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість відповісти resolved на вимогу про виправлення умов lot


Displaying of the 'answered' status of a claim for lot terms correction
  [Tags]  ${USERS.users['${viewer}'].broker}: Complaint displaying
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  answer_lot_claim
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status вимоги про виправлення умов 0 лоту із answered для користувача ${viewer}


Displaying of a solution kind of a claim for lot terms correction
  [Tags]  ${USERS.users['${viewer}'].broker}: Complaint displaying
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  answer_lot_claim
  Звірити відображення поля resolutionType вимоги про виправлення умов 0 лоту із ${USERS.users['${tender_owner}'].lot_claim_data.claim_answer.data.resolutionType} для користувача ${viewer}


Displaying of a solution of a claim for lot terms correction
  [Tags]  ${USERS.users['${viewer}'].broker}: Complaint displaying
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  answer_lot_claim
  Звірити відображення поля resolution вимоги про виправлення умов 0 лоту із ${USERS.users['${tender_owner}'].lot_claim_data.claim_answer.data.resolution} для користувача ${viewer}


Possibility to confirm the satisfaction of a claim for lot terms correction
  [Tags]  ${USERS.users['${provider}'].broker}: Complaint procedure
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  resolve_lot_claim
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість підтвердити задоволення вимоги про виправлення умов лоту


Displaying of the 'resolved' status of a claim for lot terms correction
  [Tags]  ${USERS.users['${viewer}'].broker}: Complaint displaying
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  resolve_lot_claim
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status вимоги про виправлення умов 0 лоту із resolved для користувача ${viewer}


Displaying of the satisfaction of a claim for lot terms correction
  [Tags]  ${USERS.users['${viewer}'].broker}: Complaint displaying
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  resolve_lot_claim
  Звірити відображення поля satisfied вимоги про виправлення умов 0 лоту із ${USERS.users['${provider}'].lot_claim_data.claim_answer_confirm.data.satisfied} для користувача ${viewer}


Можливість перетворити вимогу про виправлення умов лоту в скаргу
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  escalate_lot_claim
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість перетворити вимогу про виправлення умов лоту в скаргу


Відображення статусу 'pending' після 'claim -> answered' вимоги про виправлення умов лоту
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  escalate_lot_claim
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status вимоги про виправлення умов 0 лоту із pending для користувача ${viewer}


Відображення незадоволення вимоги про виправлення умов лоту
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  escalate_lot_claim
  Звірити відображення поля satisfied вимоги про виправлення умов 0 лоту із ${USERS.users['${provider}'].lot_claim_data.escalation.data.satisfied} для користувача ${viewer}


Можливість скасувати вимогу/скаргу про виправлення умов лоту
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  cancel_lot_claim
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість скасувати вимогу про виправлення умов лоту


Відображення статусу 'cancelled' вимоги/скарги про виправлення умов лоту
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  cancel_lot_claim
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля status вимоги про виправлення умов 0 лоту із cancelled для користувача ${viewer}


Відображення причини скасування вимоги/скарги про виправлення умов лоту
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  cancel_lot_claim
  Звірити відображення поля cancellationReason вимоги про виправлення умов 0 лоту із ${USERS.users['${provider}'].lot_claim_data.cancellation.data.cancellationReason} для користувача ${viewer}


Possibility to introduce changes into a lot after complaining about procurement terms
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Tender editing
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_lot_after_claim
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_description}=  create_fake_sentence
  Можливість змінити поле description 0 лоту на ${new_description}
  Remove From Dictionary  ${USERS.users['${tender_owner}'].tender_data.data.lots[0]}  description

##############################################################################################
#             BIDDING
##############################################################################################

Неможливість подати пропозицію до початку періоду подачі пропозицій першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      make_bid_before_tendering_period
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  Run Keyword And Expect Error  *  Можливість подати цінову пропозицію користувачем ${provider}


Impossibility to make a bid with no lot relation
  [Tags]   ${USERS.users['${provider}'].broker}: Bid submission
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      make_bid_without_related_lot
  ...      non-critical
  [Setup]  Дочекатись дати початку прийому пропозицій  ${provider}  ${TENDER['TENDER_UAID']}
  Неможливість подати цінову пропозицію без прив’язки до лоту користувачем ${provider}


Impossibility to make a bid without non-price criteria
  [Tags]   ${USERS.users['${provider}'].broker}: Bid submission
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      make_bid_without_parameters
  ...      non-critical
  [Setup]  Дочекатись дати початку прийому пропозицій  ${provider}  ${TENDER['TENDER_UAID']}
  Неможливість подати цінову пропозицію без нецінових показників користувачем ${provider}


Possibility to make a bid by the first provider
  [Tags]   ${USERS.users['${provider}'].broker}: Bid submission
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      make_bid_by_provider  level1
  ...      critical
  [Setup]  Дочекатись дати початку прийому пропозицій  ${provider}  ${TENDER['TENDER_UAID']}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати цінову пропозицію користувачем ${provider}


Possibility to reduce a bid by 5% by the first provider
  [Tags]   ${USERS.users['${provider}'].broker}: Bid submission
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      modify_bid_by_provider
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість зменшити пропозицію до 95 відсотків користувачем ${provider}


Possibility to upload a document to a bid by the first provider
  [Tags]   ${USERS.users['${provider}'].broker}: Bid submission
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      add_doc_to_bid_by_provider
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість завантажити документ в пропозицію користувачем ${provider}


Possibility to change documentation by the first provider
  [Tags]   ${USERS.users['${provider}'].broker}: Bid submission
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      add_doc_to_bid_by_provider
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість змінити документацію цінової пропозиції користувачем ${provider}


Possibility to make a bid by the second provider
  [Tags]   ${USERS.users['${provider1}'].broker}: Bid submission
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      make_bid_by_provider1  level1
  ...      critical
  [Setup]  Дочекатись дати початку прийому пропозицій  ${provider1}  ${TENDER['TENDER_UAID']}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати цінову пропозицію користувачем ${provider1}


Можливість зменшити пропозицію на 5% другим учасником
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      modify_bid_by_provider1
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість зменшити пропозицію до 95 відсотків користувачем ${provider1}


Можливість подати пропозицію третім учасником
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції
  ...      provider2
  ...      ${USERS.users['${provider1}'].broker}
  ...      make_bid_by_provider2  level1
  ...      non-critical
  [Setup]  Дочекатись дати початку прийому пропозицій  ${provider2}  ${TENDER['TENDER_UAID']}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати цінову пропозицію користувачем ${provider2}

##############################################################################################
#             ABOVETRHESHOLD  BIDDING
##############################################################################################

Possibility to change the public bid documentation into private
  [Tags]   ${USERS.users['${provider}'].broker}: Bid submission
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      esco_make_bid_doc_private_by_provider
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість змінити документацію цінової пропозиції з публічної на приватну учасником ${provider}


Possibility to upload a financial document to a bid by the first provider
  [Tags]   ${USERS.users['${provider}'].broker}: Bid submission
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      esco_add_financial_bid_doc_by_provider
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість завантажити financial_documents документ до пропозиції учасником ${provider}


Possibility to upload a qualification document to a bid by the first provider
  [Tags]   ${USERS.users['${provider}'].broker}: Bid submission
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      esco_add_qualification_bid_doc_by_provider
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість завантажити qualification_documents документ до пропозиції учасником ${provider}


Possibility to upload a document to eligibility criteria by the first provider
  [Tags]   ${USERS.users['${provider}'].broker}: Bid submission
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      esco_add_eligibility_bid_doc_by_provider
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість завантажити eligibility_documents документ до пропозиції учасником ${provider}


Неможливість задати запитання на тендер після завершення періоду уточнень
  [Tags]  ${USERS.users['${provider}'].broker}: Задання запитання
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      ask_question_after_enquiry_period
  [Setup]  Дочекатись дати закінчення періоду уточнень  ${provider}
  Run Keyword And Expect Error  *  Можливість задати запитання на тендер користувачем ${provider}


Неможливість подати вимогу про виправлення умов закупівлі після закінчення періоду подання скарг
  [Tags]  ${USERS.users['${provider}'].broker}: Процес оскарження
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      create_tender_complaint_after_complaint_period
  [Setup]  Дочекатись дати закінчення періоду подання скарг  ${provider}
  Run Keyword And Expect Error  *  Можливість створити вимогу про виправлення умов закупівлі із документацією


Неможливість відповісти на запитання до тендера після завершення періоду відповідей
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Відповідь на запитання
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      answer_question_after_clarifications_period
  [Setup]  Дочекатись дати закінчення періоду відповідей на запитання  ${tender_owner}
  Run Keyword And Expect Error  *  Можливість відповісти resolved на вимогу про виправлення умов tender


Неможливість редагувати однопредметний тендер менше ніж за 2 дні до завершення періоду подання пропозицій
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Можливість редагувати тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_tender_in_tendering_period
  ${new_description}=  create_fake_sentence
  Run Keyword And Expect Error  *  Можливість змінити поле description тендера на ${new_description}


Можливість відповісти на запитання до тендера після продовження періоду прийому пропозицій
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Відповідь на запитання
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      answer_question_after_clarifications_period
  ...      extend_enquiry_period
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість продовжити період подання пропозиції на 3 днів
  Можливість відповісти на запитання на тендер


Можливість редагувати тендер після продовження періоду прийому пропозицій
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Можливість редагувати тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_tender_in_tendering_period
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_description}=  create_fake_sentence
  Можливість змінити поле description тендера на ${new_description}
  Remove From Dictionary  ${USERS.users['${tender_owner}'].tender_data.data}  description


Possibility to edit a one-item tender in more than 7 days before the tendering period end date
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Possibility to edit a tender
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      open_modify_tender_in_tendering_period
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_description}=  create_fake_sentence
  Можливість змінити поле description тендера на ${new_description}
  Remove From Dictionary  ${USERS.users['${tender_owner}'].tender_data.data}  description


Displaying of the change of first bid status after tender data editing
  [Tags]   ${USERS.users['${provider}'].broker}: Bid submission
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      open_confirm_first_bid
  ...      non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  Відображення зміни статусу пропозицій на invalid для учасника ${provider}


Displaying of the change of second bid status after tender data editing
  [Tags]   ${USERS.users['${provider1}'].broker}: Bid submission
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      open_confirm_second_bid
  ...      non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider1}
  Відображення зміни статусу пропозицій на invalid для учасника ${provider1}


Possibility to confirm a bid after tender terms changes by the first provider
  [Tags]   ${USERS.users['${provider}'].broker}: Bid submission
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      open_confirm_first_bid
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість підтвердити цінову пропозицію учасником ${provider}


Possibility to confirm a bid after tender terms changes by the second provider
  [Tags]   ${USERS.users['${provider1}'].broker}: Bid submission
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      open_confirm_second_bid
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість підтвердити цінову пропозицію учасником ${provider1}


Можливість підтвердити цінову пропозицію після зміни умов третьому учаснику
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції
  ...      provider2
  ...      ${USERS.users['${provider1}'].broker}
  ...      open_confirm_third_bid
  ...      non-critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість підтвердити цінову пропозицію учасником ${provider2}

##############################################################################################

Можливість скасувати пропозицію
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      cancel_bid_by_provider
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість скасувати цінову пропозицію користувачем ${provider}


Impossibility to view providers’ bids during tendering period
  [Tags]   ${USERS.users['${viewer}'].broker}: Bid submission
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      bid_view_in_tendering_period
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Require Failure  ${viewer}  Отримати інформацію із тендера  ${TENDER['TENDER_UAID']}  bids

##############################################################################################
#             AFTER BIDDING
##############################################################################################

Impossibility to upload a document by the first provider after tendering period end date
  [Tags]   ${USERS.users['${provider}'].broker}: Bid submission
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      add_bid_doc_after_tendering_period_by_provider
  ...      non-critical
  [Setup]  Дочекатись дати закінчення прийому пропозицій  ${provider}  ${TENDER['TENDER_UAID']}
  Run Keyword And Expect Error  *  Можливість завантажити документ в пропозицію користувачем ${provider}


Impossibility to change the existing bid documentation by the first provider after tendering period end date
  [Tags]   ${USERS.users['${provider1}'].broker}: Bid submission
  ...      provider
  ...      ${USERS.users['${provider1}'].broker}
  ...      modify_bid_doc_after_tendering_period_by_provider
  ...      non-critical
  Run Keyword And Expect Error  *  Можливість змінити документацію цінової пропозиції користувачем ${provider}


Impossibility to ask a question about tender after tendering period end date
  [Tags]   ${USERS.users['${provider}'].broker}: Asking questions
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      ask_question_to_tender_after_tendering_period
  ...      non-critical
  [Setup]  Дочекатись дати закінчення прийому пропозицій  ${provider}  ${TENDER['TENDER_UAID']}
  Run Keyword And Expect Error  *  Можливість задати запитання на тендер користувачем ${provider}


Impossibility to ask a question about the first item after enquiry period end date
  [Tags]   ${USERS.users['${provider}'].broker}: Asking questions
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      ask_question_to_item_after_tendering_period
  ...      non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  Run Keyword And Expect Error  *  Можливість задати запитання на 0 предмет користувачем ${provider}


Impossibility to ask a question about the first lot after enquiry period end date
  [Tags]   ${USERS.users['${provider}'].broker}: Asking questions
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      ask_question_to_lot_after_tendering_period
  ...      non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  Run Keyword And Expect Error  *  Можливість задати запитання на 0 лот користувачем ${provider}


Impossibility to reduce a bid by 5% by the second provider after tendering period end date
  [Tags]   ${USERS.users['${provider1}'].broker}: Bid submission
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      modify_bid_after_tendering_period_by_provider1
  ...      non-critical
  [Setup]  Дочекатись дати закінчення прийому пропозицій  ${provider1}  ${TENDER['TENDER_UAID']}
  Run Keyword And Expect Error  *  Можливість зменшити пропозицію до 95 відсотків користувачем ${provider1}


Impossibility to cancel a bid by the second provider after tendering period end date
  [Tags]   ${USERS.users['${provider1}'].broker}: Bid submission
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      cancel_bid_after_tendering_period_by_provider1
  ...      non-critical
  Run Keyword And Expect Error  *  Можливість скасувати цінову пропозицію користувачем ${provider1}


##############################################################################################
#             ESCO  Pre-Qualification
##############################################################################################

Impossibility to add a documenent to a tender during qualification
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Documents addition
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_add_doc_to_tender
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Run Keyword And Expect Error  *  Можливість додати документацію до тендера


Impossibility to add documentation to a lot during qualification
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Documents addition
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_add_doc_to_lot
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Run Keyword And Expect Error  *  Можливість додати документацію до 0 лоту


Displaying of the first bid status in qualification
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Qualification
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_view
  ...      non-critical
  [Setup]  Дочекатись дати початку періоду прекваліфікації  ${tender_owner}  ${TENDER['TENDER_UAID']}
  Звірити відображення поля qualifications[0].status тендера із pending для користувача ${tender_owner}


Displaying of the second bid status in qualification
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Qualification
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_view
  ...      non-critical
  [Setup]  Дочекатись дати початку періоду прекваліфікації  ${tender_owner}  ${TENDER['TENDER_UAID']}
  Звірити відображення поля qualifications[1].status тендера із pending для користувача ${tender_owner}


Possibility to upload a document to bid qualification of the first provider
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Qualification
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_add_doc_to_first_bid
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість завантажити документ у кваліфікацію 0 пропозиції


Можливість дочекатися перевірки учасників по ЄДРПОУ
  [Tags]   ${USERS.users['${viewer}'].broker}: Перевірка користувачів по ЄДРПОУ
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualifications_check_by_edrpou
  [Setup]  Дочекатись дати початку періоду прекваліфікації  ${tender_owner}  ${TENDER['TENDER_UAID']}
  Дочекатися перевірки прекваліфікацій  ${tender_owner}  ${TENDER['TENDER_UAID']}


Possibility to approve the first qualification bid
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Qualification
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_approve_first_bid  level1
  ...      critical
  [Setup]  Дочекатись дати початку періоду прекваліфікації  ${tender_owner}  ${TENDER['TENDER_UAID']}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість підтвердити 0 пропозицію кваліфікації


Possibility to upload a document to bid qualification of the second provider
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Qualification
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_add_doc_to_second_bid
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість завантажити документ у кваліфікацію 1 пропозиції


Possibility to reject the second bid qualification
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Qualification
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_reject_second_bid
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість відхилити 1 пропозиції кваліфікації


Possibility to cancel the qualification desicion for the second bid
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Qualification
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_cancel_second_bid_qualification
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість скасувати рішення кваліфікації для 1 пропопозиції


Possibility to approve the second qualification bid
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Qualification
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_approve_second_bid  level1
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість підтвердити -1 пропозицію кваліфікації


Possibility to approve the third qualification bid
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Qualification
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_approve_third_bid  level1
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість підтвердити -2 пропозицію кваліфікації


Possibility to approve the fourth qualification bid
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Qualification
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_approve_fourth_bid  level1
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість підтвердити -3 пропозицію кваліфікації


Possibility to approve the final qualification decision
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Qualification
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_approve_qualifications  level1
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість затвердити остаточне рішення кваліфікації


Displaying of the stand-still status before auction period start date
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Qualification
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_view
  ...      non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  Звірити статус тендера  ${tender_owner}  ${TENDER['TENDER_UAID']}  active.pre-qualification.stand-still


Displaying of the blocked stand-still end date before auction period start date
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Qualification
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_view
  ...      non-critical
  [Teardown]  Дочекатись дати закінчення періоду прекваліфікації  ${tender_owner}  ${TENDER['TENDER_UAID']}
  Отримати дані із поля qualificationPeriod.endDate тендера для усіх користувачів


Можливість дочекатися початку періоду очікування
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Процес очікування оскаржень
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      stage2_pending_status_view
  Отримати дані із поля qualificationPeriod.endDate тендера для усіх користувачів
  Дочекатись дати закінчення періоду прекваліфікації  ${tender_owner}  ${TENDER['TENDER_UAID']}
  Звірити статус тендера  ${tender_owner}  ${TENDER['TENDER_UAID']}  active.stage2.pending


Можливість перевести тендер в статус очікування обробки мостом
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Процес переведення статусу у active.stage2.waiting.
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      stage2_pending_status_view
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість перевести тендер на статус очікування обробки мостом
  Звірити статус тендера  ${tender_owner}  ${TENDER['TENDER_UAID']}  active.stage2.waiting


Можливість дочекатися завершення роботи мосту
  [Tags]   ${USERS.users['${viewer}'].broker}: Процес очікування обробки мостом
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      wait_bridge_for_work
  Дочекатися створення нового етапу мостом  ${tender_owner}  ${TENDER['TENDER_UAID']}
  Звірити статус тендера  ${tender_owner}  ${TENDER['TENDER_UAID']}  complete


Можливість отримати тендер другого етапу
  [Tags]   ${USERS.user['${tender_owner}'].broker}: Отримати id нового тендеру
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      get_second_stage
  Отримати дані із поля stage2TenderID тендера для усіх користувачів
  ${tender_UAID_second_stage}=  Catenate  SEPARATOR=  ${TENDER['TENDER_UAID']}  .2
  Можливість знайти тендер по ідентифікатору ${tender_UAID_second_stage} та зберегти його в second_stage_data для користувача ${tender_owner}


Відображення заголовку тендера другого етапу
  [Tags]   ${USERS.user['${tender_owner}'].broker}: Відображення основних даних тендера другого етапу
  ...      viewer
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      compare_stages
  Звірити відображення поля title тендера із ${USERS.users['${tender_owner}'].second_stage_data.data.title} для користувача ${viewer}


Відображення мінімального кроку закупівлі другого етапу
  [Tags]   ${USERS.user['${tender_owner}'].broker}: Відображення основних даних тендера другого етапу
  ...      viewer
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      compare_stages
  Звірити відображення поля minimalStep тендера із ${USERS.users['${tender_owner}'].second_stage_data.data.minimalStep} для користувача ${viewer}


Відображення доступного бюджету закупівлі другого етапу
  [Tags]   ${USERS.user['${tender_owner}'].broker}: Відображення основних даних тендера другого етапу
  ...      viewer
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      compare_stages
  Звірити відображення поля value тендера із ${USERS.users['${tender_owner}'].second_stage_data.data.value} для користувача ${viewer}


Відображення опису закупівлі другого етапу
  [Tags]   ${USERS.user['${tender_owner}'].broker}: Відображення основних даних тендера другого етапу
  ...      viewer
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      compare_stages
  Звірити відображення поля description тендера із ${USERS.users['${tender_owner}'].second_stage_data.data.description} для користувача ${viewer}


Відображення імені замовника тендера для другого етапу
  [Tags]   ${USERS.user['${tender_owner}'].broker}: Відображення основних даних тендера другого етапу
  ...      viewer
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      compare_stages
  Звірити відображення поля procuringEntity.name тендера із ${USERS.users['${tender_owner}'].second_stage_data.data.procuringEntity.name} для користувача ${viewer}

###################################################################
#           Відображення посилання на аукціон
###################################################################

Можливість вичитати посилання на аукціон для глядача
  [Tags]   ${USERS.users['${viewer}'].broker}: Процес аукціону
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      auction_url
  ...      critical
  [Setup]  Дочекатись дати початку періоду аукціону  ${viewer}  ${TENDER['TENDER_UAID']}
  Можливість отримати посилання на аукціон для глядача


Можливість вичитати посилання на аукціон для першого учасника
  [Tags]   ${USERS.users['${provider}'].broker}: Процес аукціону
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      auction_url
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  Можливість отримати посилання на аукціон для учасника ${provider}


Можливість вичитати посилання на аукціон для другого учасника
  [Tags]   ${USERS.users['${provider1}'].broker}: Процес аукціону
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      auction_url
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider1}
  Можливість отримати посилання на аукціон для учасника ${provider1}


##############################################################################################
#             Відображення основних даних лоту для другого етапу
##############################################################################################

Відображення лоту тендера другого етапу
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення лоту тендера другого етапу
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      compare_stages
  Звірити відображення поля title усіх лотів другого етапу для усіх користувачів


Відображення опису лотів для тендера другого етапу
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення лоту тендера другого етапу
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      compare_stages
  Звірити відображення поля description усіх лотів другого етапу для користувача ${viewer}


Відображення бюджету лотів для тендера другого етапу
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення лоту тендера другого етапу
  ...      viewer tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      compare_stages
  Звірити відображення поля value.amount усіх лотів другого етапу для усіх користувачів


Відображення валюти лотів для тендера другого етапу
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення лоту тендера другого етапу
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      compare_stages
  Звірити відображення поля value.currency усіх лотів другого етапу для користувача ${viewer}


Відображення ПДВ в бюджеті лотів для тендера другого етапу
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення лоту тендера другого етапу
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      compare_stages
  Звірити відображення поля value.valueAddedTaxIncluded усіх лотів другого етапу для користувача ${viewer}


Відображення мінімального кроку лотів для тендера другого етапу
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення лоту тендера другого етапу
  ...      viewer tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      compare_stages
  Звірити відображення поля minimalStep.amount усіх лотів другого етапу для усіх користувачів


Відображення валюти мінімального кроку лотів для тендера другого етапу
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення лоту тендера другого етапу
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      compare_stages
  Звірити відображення поля minimalStep.currency усіх лотів другого етапу для користувача ${viewer}


Відображення ПДВ в мінімальному кроці лотів для тендера другого етапу
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення лоту тендера другого етапу
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      compare_stages
  Звірити відображення поля minimalStep.valueAddedTaxIncluded усіх лотів другого етапу для користувача ${viewer}

##############################################################################################
#             END
##############################################################################################

Можливість отримати доступ до тендера другого етапу
  [Tags]   ${USERS.user['${tender_owner}'].broker}: Отримати токен для другог етапу
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      save_tender_second_stage
  Отримати доступ до тендера другого етапу та зберегти його


Можливість активувати тендер другого етапу
  [Tags]   ${USERS.users['${viewer}'].broker}: Активувати тендер другого етапу
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      activate_second_stage
  Активувати тендер другого етапу


Можливість подати пропозицію першим учасником на другому етапі
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      make_bid_by_provider_second_stage
  [Setup]  Дочекатись дати початку прийому пропозицій  ${provider}  ${TENDER['TENDER_UAID']}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати цінову пропозицію на другий етап 1 користувачем ${provider}


Можливість подати пропозицію другим учасником на другому етапі
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції на другий етап
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      make_bid_by_provider1_second_stage
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати цінову пропозицію на другий етап 2 користувачем ${provider1}


Можливість підтвердити першу пропозицію кваліфікації на другому етапі
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Кваліфікація на другому етапі
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_approve_first_bid_second_stage
  [Setup]  Дочекатись дати початку періоду прекваліфікації  ${tender_owner}  ${TENDER['TENDER_UAID']}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість підтвердити 0 пропозицію кваліфікації


Можливість підтвердити другу пропозицію кваліфікації на другогму етапі
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Кваліфікація на другому етапі
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_approve_second_bid_second_stage
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість підтвердити -1 пропозицію кваліфікації


Можливість затвердити остаточне рішення кваліфікації на другому етапі
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Кваліфікація на другому етапі
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_approve_qualifications_second_stage
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість затвердити остаточне рішення кваліфікації

################################################################################

Перевірка завантаження документів до тендера через Document Service
  [Tags]   ${USERS.users['${viewer}'].broker}: Document Service
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      document_service
  Можливість перевірити завантаження документів через Document Service
