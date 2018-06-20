*** Settings ***
Resource        base_keywords.robot
Suite Setup     Test Suite Setup
Suite Teardown  Test Suite Teardown


*** Variables ***

${MODE}              assets
${RESOURCE}          assets
@{USED_ROLES}        tender_owner  viewer

*** Test Cases ***
Можливість створити об'єкт МП
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Реєстрація об'єкта МП
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_asset
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість оголосити тендер


Можливість знайти об'єкт МП по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук об'єкта МП
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      find_asset
  Можливість знайти тендер по ідентифікатору для усіх користувачів

##############################################################################################
#             Відображення основних даних об'єкта МП
##############################################################################################

Відображення ідентифікатора об'єкта МП
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних об'єкта МП
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      asset_view
  Звірити відображення поля assetID тендера із ${TENDER['TENDER_UAID']} для усіх користувачів


Відображення дати створення об'єкта МП
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних об'єкта МП
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      asset_view
  Отримати дані із дати date тендера для усіх користувачів


Відображення дати завершення періоду редагування об'єкта МП
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних об'єкта МП
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      asset_view
  Отримати дані із дати rectificationPeriod.endDate тендера для усіх користувачів


Відображення статусу 'Опубліковано. Очікування інформаційного повідомлення'
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних об'єкта МП
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      asset_view
  Звірити відображення поля status тендера із pending для усіх користувачів


Відображення заголовку об'єкта МП
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних об'єкта МП
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      asset_view
  Звірити відображення поля title тендера для усіх користувачів


Відображення опису об'єкта МП
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних об'єкта МП
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      asset_view
  Звірити відображення поля description тендера для усіх користувачів


Відображення найменування рішення про приватизацію об'єкта МП
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних об'єкта МП
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      asset_view
  Звірити відображення поля decisions[0].title тендера для усіх користувачів


Відображення дати прийняття рішення про приватизацію об'єкта МП
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних об'єкта МП
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      asset_view
  Звірити відображення дати decisions[0].decisionDate тендера для усіх користувачів


Відображення номера рішення про включення до переліку об'єкта МП
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних об'єкта МП
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      asset_view
  Звірити відображення поля decisions[0].decisionID тендера для усіх користувачів


Відображення назви організації балансоутримувача об'єкта МП
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних об'єкта МП
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      asset_view
  Звірити відображення поля assetHolder.name тендера для усіх користувачів


Відображення схеми ідентифікації організації балансоутримувача об'єкта МП
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних об'єкта МП
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      asset_view
  Звірити відображення поля assetHolder.identifier.scheme тендера для усіх користувачів


Відображення ідентифікатора організації балансоутримувача об'єкта МП
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних об'єкта МП
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      asset_view
  Звірити відображення поля assetHolder.identifier.id тендера для усіх користувачів


Відображення схеми ідентифікації організації розпорядника об'єкта МП
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних об'єкта МП
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      asset_view
  Звірити відображення поля assetCustodian.identifier.scheme тендера для усіх користувачів


Відображення ідентифікатора організації розпорядника об'єкта МП
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних об'єкта МП
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      asset_view
  Звірити відображення поля assetCustodian.identifier.id тендера для усіх користувачів


Відображення юридичної назви організації розпорядника об'єкта МП
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних об'єкта МП
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      asset_view
  Звірити відображення поля assetCustodian.identifier.legalName тендера для усіх користувачів


Відображення імені контактної особи організації розпорядника об'єкта МП
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних об'єкта МП
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      asset_view
  Звірити відображення поля assetCustodian.contactPoint.name тендера для усіх користувачів


Відображення контактного номера організації розпорядника об'єкта МП
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних об'єкта МП
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      asset_view
  Звірити відображення поля assetCustodian.contactPoint.telephone тендера для усіх користувачів


Відображення адреси електронної пошти організації розпорядника об'єкта МП
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних об'єкта МП
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      asset_view
  Звірити відображення поля assetCustodian.contactPoint.email тендера для усіх користувачів


Відображення типу документа про інформацію по оприлюдненню інформаційного повідомлення
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних об'єкта МП
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      asset_view
  Звірити відображення поля documents[0].documentType тендера із informationDetails для усіх користувачів

# #############################################################################################
#             Відображення основних даних активу об’єкта МП
# #############################################################################################

Відображення опису активу об’єкта МП
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення активів об’єкта МП
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      asset_view
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля description усіх предметів для усіх користувачів


Відображення схеми класифікації активів об’єкта МП
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення активів об’єкта МП
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      asset_view
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля classification.scheme усіх предметів для усіх користувачів


Відображення ідентифікатора класифікації активів об’єкта МП
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення активів об’єкта МП
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      asset_view
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля classification.id усіх предметів для усіх користувачів


Відображення назви одиниці виміру активу об’єкта МП
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення активів об’єкта МП
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      asset_view
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля unit.name усіх предметів для усіх користувачів


Відображення кількості одиниць виміру активу об’єкта МП
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення активів об’єкта МП
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      asset_view
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля quantity усіх предметів для усіх користувачів


Відображення інформації про державну реєстрацію активу об’єкта МП
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення активів об’єкта МП
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      asset_view
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля registrationDetails.status усіх предметів для усіх користувачів

# #############################################################################################
#             Завантаження документації до об'єкта МП
# #############################################################################################

Можливість додати ілюстрацію до об'єкта МП
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Додання документації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_illustration
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість додати ілюстрацію до об’єкта МП


Можливість завантажити паспорт торгів до об'єкта МП
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Додання документації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_notice
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість завантажити документ до тендера з типом notice


Можливість завантажити презентацію до об'єкта МП
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Додання документації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_presentation
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість завантажити документ до тендера з типом x_presentation


Можливість завантажити публічний паспорт активу об'єкта МП
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Додання документації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_tech_specifications
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість завантажити документ до тендера з типом technicalSpecifications


Відображення вмісту документації до об'єкта МП
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення документації
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      add_doc_content
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення вмісту документа ${USERS.users['${tender_owner}'].tender_document.doc_id} із ${USERS.users['${tender_owner}'].tender_document.doc_content} для користувача ${viewer}

# #############################################################################################
#             Редагування об'єкта МП
# #############################################################################################

Можливість відредагувати заголовок об'єкта МП
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати об'єкт МП
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_asset
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_title}=  create_fake_title  ua
  Set To Dictionary  ${USERS.users['${tender_owner}']}  new_title=${new_title}
  Run As  ${tender_owner}  Внести зміни в об'єкт МП  ${TENDER['TENDER_UAID']}  title  ${new_title}


Відображення зміненого заголовку об'єкта МП
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних об'єкта МП
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      modify_asset
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \  Run Keyword And Ignore Error  Remove From Dictionary  ${USERS.users['${username}'].tender_data.data}  title
  Звірити відображення поля title тендера із ${USERS.users['${tender_owner}'].new_title} для усіх користувачів


Можливість відредагувати опис об'єкта МП
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати об'єкт МП
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_asset
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_description}=  create_fake_description  ua
  Set To Dictionary  ${USERS.users['${tender_owner}']}  new_description=${new_description}
  Run As  ${tender_owner}  Внести зміни в об'єкт МП  ${TENDER['TENDER_UAID']}  description  ${new_description}


Відображення зміненого опису об'єкта МП
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних об'єкта МП
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      modify_asset
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \  Run Keyword And Ignore Error  Remove From Dictionary  ${USERS.users['${username}'].tender_data.data}  description
  Звірити відображення поля description тендера із ${USERS.users['${tender_owner}'].new_description} для усіх користувачів


Можливість внести зміни в найменування рішення про приватизацію об'єкта МП
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати об'єкт МП
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_decisions
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_title}=  create_fake_sentence
  Set To Dictionary  ${USERS.users['${tender_owner}']}  new_title=${new_title}
  Run As  ${tender_owner}  Внести зміни в об'єкт МП  ${TENDER['TENDER_UAID']}  decisions[0].title  ${new_title}


Відображення зміненого найменування рішення про приватизацію об'єкта МП
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних об'єкта МП
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      modify_decisions
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \  Run Keyword And Ignore Error  Remove From Dictionary  ${USERS.users['${username}'].tender_data.data.decisions[0]}  title
  Звірити відображення поля decisions[0].title тендера із ${USERS.users['${tender_owner}'].new_title} для усіх користувачів


Можливість внести зміни до дати прийняття рішення про приватизацію об'єкта МП
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати об'єкт МП
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_decisions
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_date}=  create_fake_decisionDate
  Set To Dictionary  ${USERS.users['${tender_owner}']}  new_date=${new_date}
  Run As  ${tender_owner}  Внести зміни в об'єкт МП  ${TENDER['TENDER_UAID']}  decisions[0].decisionDate  ${new_date}


Відображення зміненої дати прийняття рішення про приватизацію лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних об'єкта МП
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      modify_decisions
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \  Run Keyword And Ignore Error  Remove From Dictionary  ${USERS.users['${username}'].tender_data.data.decisions[0]}  decisionDate
  Звірити відображення дати decisions[0].decisionDate тендера із ${USERS.users['${tender_owner}'].new_date} для усіх користувачів


Можливість внести зміни до номера рішення про приватизацію об'єкта МП
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати об'єкт МП
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_decisions
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_ID}=  create_fake_decisionID
  Set To Dictionary  ${USERS.users['${tender_owner}']}  new_ID=${new_ID}
  Run As  ${tender_owner}  Внести зміни в об'єкт МП  ${TENDER['TENDER_UAID']}  decisions[0].decisionID  ${new_ID}


Відображення зміненого номера рішення про приватизацію об'єкта МП
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних об'єкта МП
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      modify_decisions
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \  Run Keyword And Ignore Error  Remove From Dictionary  ${USERS.users['${username}'].tender_data.data.decisions[0]}  decisionID
  Звірити відображення поля decisions[0].decisionID тендера із ${USERS.users['${tender_owner}'].new_ID} для усіх користувачів


Можливість змінити ім'я контактної особи організації розпорядника об'єкта МП
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати актив
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_assetCustodian
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_name}=  create_fake_sentence
  Set To Dictionary  ${USERS.users['${tender_owner}']}  new_name=${new_name}
  Run As  ${tender_owner}  Внести зміни в об'єкт МП  ${TENDER['TENDER_UAID']}  assetCustodian.contactPoint.name  ${new_name}


Відображення зміненого імені контактної особи організації розпорядника об'єкта МП
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних активу
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      modify_assetCustodian
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \  Run Keyword And Ignore Error  Remove From Dictionary  ${USERS.users['${username}'].tender_data.data.assetCustodian.contactPoint}  name
  Звірити відображення поля assetCustodian.contactPoint.name тендера із ${USERS.users['${tender_owner}'].new_name} для усіх користувачів


Можливість внести зміни до кількості одиниць виміру активу об’єкта МП
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати об'єкт МП
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_asset
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${quantity}=  create_fake_items_quantity
  Set To Dictionary  ${USERS.users['${tender_owner}']}  quantity=${quantity}
  Можливість змінити поле quantity предмета на ${quantity}


Відображення зміненої кількості одиниць виміру активу об’єкта МП
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних об'єкта МП
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      modify_asset
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \  Run Keyword And Ignore Error  Remove From Dictionary  ${USERS.users['${username}'].tender_data.data['items'][0]}  quantity
  Звірити відображення зміненого поля quantity предмета із ${USERS.users['${tender_owner}'].quantity} для усіх користувачів


Можливість внести зміни до ідентифікатора класифікації активу об’єкта МП
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати об'єкт МП
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_classification_id
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${scheme_id}=  Run As  ${tender_owner}  Отримати інформацію із об'єкта МП  ${TENDER['TENDER_UAID']}  items[0].classification.id
  ${new_id}=  create_fake_scheme_id  ${scheme_id}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  new_id=${new_id}
  Можливість змінити поле classification.id предмета на ${new_id}


Відображення зміненого ідентифікатора класифікації активу об’єкта МП
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних об'єкта МП
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      modify_classification_id
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \  Run Keyword And Ignore Error  Remove From Dictionary  ${USERS.users['${username}'].tender_data.data['items'][0].classification}  id
  Звірити відображення зміненого поля classification.id предмета із ${USERS.users['${tender_owner}'].new_id} для усіх користувачів


Можливість внести зміни до назви одиниці виміру активу об’єкта МП
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати об'єкт МП
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_unit_name
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_unit_name}=  cretate_fake_unit_name
  Set To Dictionary  ${USERS.users['${tender_owner}']}  new_unit_name=${new_unit_name}
  Можливість змінити поле unit.name предмета на ${new_unit_name}


Відображення зміненої назви одиниці виміру активу об’єкта МП
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних об'єкта МП
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      modify_unit_name
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \  Run Keyword And Ignore Error  Remove From Dictionary  ${USERS.users['${username}'].tender_data.data['items'][0].unit}  name
  Звірити відображення зміненого поля unit.name предмета із ${USERS.users['${tender_owner}'].new_unit_name} для усіх користувачів


Можливість внести зміни в інформацію про державну реєстрацію активу об’єкта МП
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати об'єкт МП
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_registrationDetails
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість змінити поле registrationDetails.status предмета на registering


Відображення зміненої інформації про державну реєстрацію активу об’єкта МП
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних об'єкта МП
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      modify_registrationDetails
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \  Run Keyword And Ignore Error  Remove From Dictionary  ${USERS.users['${username}'].tender_data.data['items'][0].registrationDetails}  status
  Звірити відображення зміненого поля registrationDetails.status предмета із registering для усіх користувачів


Можливість внести зміни до опису активу об’єкта МП
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати об'єкт МП
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_asset_description
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_description}=  create_fake_item_description
  Set To Dictionary  ${USERS.users['${tender_owner}']}  new_description=${new_description}
  Можливість змінити поле description предмета на ${new_description}


Відображення зміненого опису активу об’єкта МП
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних об'єкта МП
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      modify_asset_description
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \  Run Keyword And Ignore Error  Remove From Dictionary  ${USERS.users['${username}'].tender_data.data['items'][0]}  description
  Звірити відображення поля items[0].description тендера із ${USERS.users['${tender_owner}'].new_description} для усіх користувачів


Можливість додати актив до об'єкта МП
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування активу
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_item
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Додати предмети закупівлі в тендер


Відображення опису новоствореного активу об'єкта МП
  [Tags]   ${USERS.users['${viewer}'].broker}: Редагування активу
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      add_item_view
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Звірити відображення поля description усіх новостворених предметів для користувача ${viewer}


Відображення дати внесення змін до об'єкта МП
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних об’єкта МП
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      asset_view
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Отримати дані із дати dateModified тендера для усіх користувачів


Неможливість вносити зміни глядачем
  [Tags]   ${USERS.users['${viewer}'].broker}: Можливість редагувати об’єкт МП
  ...      tender_owner
  ...      ${USERS.users['${viewer}'].broker}
  ...      modify_asset
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  ${new_title}=  create_fake_title  ua
  Require Failure  ${viewer}  Внести зміни в об'єкт МП  ${TENDER['TENDER_UAID']}  title  ${new_title}

# #############################################################################################
#             Видалення об'єкта МП
# ############################################################################################

Можливість завантажити документ про виключення об'єкта МП з переліку
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Видалення об'єкта МП
  ...     tender_owner
  ...     ${USERS.users['${tender_owner}'].broker}
  ...     delete_asset
  [Teardown]  Оновити LMD і дочекатись синхронізації  ${tender_owner}
  ${file_path}  ${file_title}  ${file_content}=  create_fake_doc
  Run As  ${tender_owner}  Завантажити документ для видалення об'єкта МП  ${TENDER['TENDER_UAID']}  ${file_path}
  Remove File  ${file_path}


Можливість виключити з переліку об'єкт МП
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Видалення об'єкта МП
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      delete_asset
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Run As  ${tender_owner}  Видалити об'єкт МП  ${TENDER['TENDER_UAID']}


Відображення статусу 'Виключено з переліку'
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення статусу видаленого об'єкта МП
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      delete_asset
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \  Run Keyword And Ignore Error  Remove From Dictionary  ${USERS.users['${username}'].tender_data.data}  status
  Звірити відображення поля status тендера із deleted для усіх користувачів
