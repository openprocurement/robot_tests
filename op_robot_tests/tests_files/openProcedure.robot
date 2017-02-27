*** Settings ***
Resource        base_keywords.robot
Resource        aboveThreshold_keywords.robot
Suite Setup     Test Suite Setup
Suite Teardown  Test Suite Teardown


*** Variables ***
${MODE}             openeu
@{USED_ROLES}       tender_owner  provider  provider1  provider2  viewer
${DIALOGUE_TYPE}    EU

${NUMBER_OF_ITEMS}  ${1}
${TENDER_MEAT}      ${True}
${LOT_MEAT}         ${True}
${ITEM_MEAT}        ${True}


*** Test Cases ***
Можливість оголосити лот
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Оголошення лоту
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_tender  level1
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість оголосити тендер


Можливість знайти лот по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук лоту
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      find_tender  level1
  Можливість знайти тендер по ідентифікатору для усіх користувачів

##############################################################################################
#             Відображення основних даних лоту
##############################################################################################

Відображення заголовку лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view  level1
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля title тендера для користувача ${viewer}


Відображення номера лоту ФГВ
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view  level1
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля dgfID тендера для користувача ${viewer}


Відображення дати рішення про затвердження умов продажу
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view_decisionDate
  Звірити відображення поля dgfDecisionDate тендера для користувача ${viewer}


Відображення номера рішення про затвердження умов продажу
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view_decisionID
  Звірити відображення поля dgfDecisionID тендера для користувача ${viewer}


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
  ...      tender_view  level1
  Звірити відображення поля description тендера для користувача ${viewer}


Відображення початкової вартості лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view  level1
  Звірити відображення поля value.amount тендера для усіх користувачів


Відображення валюти лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view  level2
  Звірити відображення поля value.currency тендера для користувача ${viewer}


Відображення ПДВ в бюджеті лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view  level2
  Звірити відображення поля value.valueAddedTaxIncluded тендера для користувача ${viewer}


Відображення ідентифікатора лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view  level2
  Звірити відображення поля auctionID тендера із ${TENDER['TENDER_UAID']} для користувача ${viewer}


Відображення імені організатора лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view  level2
  Звірити відображення поля procuringEntity.name тендера для користувача ${viewer}


Відображення початку періоду уточнення лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view_enquiryPeriod
  Отримати дані із поля enquiryPeriod.startDate тендера для усіх користувачів


Відображення закінчення періоду уточнення лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view_enquiryPeriod  level2
  Отримати дані із поля enquiryPeriod.endDate тендера для усіх користувачів


Відображення початку періоду прийому пропозицій лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view_tenderPeriod_startDate  level2
  Отримати дані із поля tenderPeriod.startDate тендера для усіх користувачів


Відображення закінчення періоду прийому пропозицій лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view_tenderPeriod  level2
  Отримати дані із поля tenderPeriod.endDate тендера для усіх користувачів


Відображення мінімального кроку лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer tender_owner provider provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      tender_view  level2
  Звірити відображення поля minimalStep.amount тендера для усіх користувачів


Відображення фінансового критерію лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view_criteria  level2
  Отримати дані із поля eligibilityCriteria тендера для усіх користувачів


Відображення типу оголошеного лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view  level2
  Звірити відображення поля procurementMethodType тендера для усіх користувачів


##############################################################################################
#             Відображення основних даних предмету
##############################################################################################

Відображення опису активів лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення активів лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view  level2
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля description усіх предметів для усіх користувачів


Відображення схеми класифікації активів лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення активів лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view  level1
  Звірити відображення поля classification.scheme усіх предметів для користувача ${viewer}


Відображення ідентифікатора класифікації активів лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення активів лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view  level2
  Звірити відображення поля classification.id усіх предметів для користувача ${viewer}


Відображення активів лоту з різних CAV груп
   [Tags]   ${USERS.users['${viewer}'].broker}: Відображення активів лоту
   ...      viewer
   ...      ${USERS.users['${viewer}'].broker}
   ...      tender_view_cav_groups  level1
  Звірити належність усіх предметів до різних груп для користувача ${viewer}


Відображення опису класифікації активів лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення активів лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view  level2
  Звірити відображення поля classification.description усіх предметів для користувача ${viewer}


Відображення назви одиниці активів лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення активів лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view  level2
  Звірити відображення поля unit.name усіх предметів для користувача ${viewer}


Відображення коду одиниці активів лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення активів лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view_unit_code  level3
  Звірити відображення поля unit.code усіх предметів для користувача ${viewer}


Відображення кількості активів лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення активів лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_view  level2
  Звірити відображення поля quantity усіх предметів для користувача ${viewer}

##############################################################################################
#             Редагування лоту
##############################################################################################

Неможливість змінити початкову вартість лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати лот
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_auction_value  level2
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  ${new_amount}=  create_fake_amount
  Перевірити неможливість зміни поля value.amount тендера на значення ${new_amount} для користувача ${tender_owner}


Неможливість змінити мінімальний крок лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати лот
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_auction_step  level2
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  ${new_amount}=  create_fake_minimal_step  ${USERS.users['${tender_owner}'].tender_data.data.value.amount}
  Перевірити неможливість зміни поля minimalStep.amount тендера на значення ${new_amount} для користувача ${tender_owner}


Неможливість змінити назву лоту українською мовою
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати лот
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_auction_title_ua  level2
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  ${new_title}=  create_fake_sentence
  Перевірити неможливість зміни поля title тендера на значення ${new_title} для користувача ${tender_owner}


Неможливість змінити назву лоту російською мовою
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати лот
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_auction_title  level3
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  ${new_title}=  create_fake_sentence
  Перевірити неможливість зміни поля title_ru тендера на значення ${new_title} для користувача ${tender_owner}


Неможливість змінити назву лоту англійською мовою
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати лот
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_auction_title  level3
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  ${new_title}=  create_fake_sentence
  Перевірити неможливість зміни поля title_en тендера на значення ${new_title} для користувача ${tender_owner}


Неможливість змінити опис лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати лот
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_auction_description  level2
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  ${new_description}=  create_fake_sentence
  Перевірити неможливість зміни поля description тендера на значення ${new_description} для користувача ${tender_owner}


Неможливість змінити дані про організатора лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати лот
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_auction_procuringEntity  level2
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  ${new_procuringEntity_name}=  create_fake_sentence
  Перевірити неможливість зміни поля procuringEntity.name тендера на значення ${new_procuringEntity_name} для користувача ${tender_owner}


Неможливість змінити початок періоду подання пропозицій лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати лот
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_auction_periods  level2
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  ${new_value}=  Get Current Date
  Перевірити неможливість зміни поля tenderPeriod.startDate тендера на значення ${new_value} для користувача ${tender_owner}


Неможливість змінити кінець періоду уточнення лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати лот
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_auction_enquiryPeriod  level2
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  ${new_value}=  Set Variable  ${USERS.users['${tender_owner}'].tender_data.data.auctionPeriod.shouldStartAfter}
  Перевірити неможливість зміни поля enquiryPeriod.endDate тендера на значення ${new_value} для користувача ${tender_owner}


Неможливість змінити значення фінансового критерію лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати лот
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_auction_criteria_ua  level2
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  ${new_title}=  create_fake_sentence
  Перевірити неможливість зміни поля eligibilityCriteria тендера на значення ${new_title} для користувача ${tender_owner}


Неможливість змінити значення фінансового критерію лоту російською мовою
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати лот
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_auction_criteria  level3
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  ${new_title}=  create_fake_sentence
  Перевірити неможливість зміни поля eligibilityCriteria_ru тендера на значення ${new_title} для користувача ${tender_owner}


Неможливість змінити значення фінансового критерію лоту англійською мовою
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати лот
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_auction_criteria  level3
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  ${new_title}=  create_fake_sentence
  Перевірити неможливість зміни поля eligibilityCriteria_en тендера на значення ${new_title} для користувача ${tender_owner}


Неможливість змінити гарантування лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати лот
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_auction_guarantee  level2
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  ${new_amount}=  create_fake_guarantee  ${USERS.users['${tender_owner}'].tender_data.data.value.amount}
  ${new_value}=  Create Dictionary
  Set To Dictionary  ${new_value}
  ...                amount=${new_amount}
  ...                currency=UAH
  Перевірити неможливість зміни поля guarantee тендера на значення ${new_value} для користувача ${tender_owner}


Неможливість змінити дату рішення про затвердження умов продажу
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Відображення основних даних лоту
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_decisionDate
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  ${new_date}=  create_fake_dgfDecisionDate
  Перевірити неможливість зміни поля dgfDecisionDate тендера на значення ${new_date} для користувача ${tender_owner}


Неможливість змінити номер рішення про затвердження умов продажу
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Відображення основних даних лоту
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_decisionID
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  ${new_id}=  create_fake_dgfDecisionID
  Перевірити неможливість зміни поля dgfDecisionID тендера на значення ${new_id} для користувача ${tender_owner}


Неможливість змінити поле "Лоти виставляються"
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Відображення основних даних лоту
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_tenderAttempts
  ${new_attempt}=  create_fake_tenderAttempts
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  Перевірити неможливість зміни поля tenderAttempts тендера на значення ${new_attempt} для користувача ${tender_owner}


Можливість додати документацію до лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Додання документації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_tender_doc  level2
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість додати документацію до тендера


Можливість додати ілюстрацію до лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Додання документації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_tender_illustration  level2
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість додати ілюстрацію до тендера


Можливість додати Virtual Data Room до лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Додання документації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_tender_vdr  level2
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість додати Virtual Data Room до тендера


Можливість додати посилання на публічний паспорт активу до лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Додання документації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_tender_public_asset_certificate  level2
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість додати публічний паспорт активу до тендера


Можливість завантажити договір про нерозголошення до лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Додання документації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_tender_nda  level2
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість завантажити документ до тендера з типом x_nda


Можливість завантажити паспорт торгів до лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Додання документації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_tender_notice  level2
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість завантажити документ до тендера з типом tenderNotice


Можливість завантажити презентацію до лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Додання документації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_tender_presentation  level2
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість завантажити документ до тендера з типом x_presentation


Можливість завантажити публічний паспорт активу до лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Додання документації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_tender_tech_specifications  level2
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість завантажити документ до тендера з типом technicalSpecifications


Можливість завантажити документ з умовами ознайомлення з майном/активом у кімнаті даних
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Додання документації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_tender_asset_familiarization  level2
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість додати офлайн документ


Відображення документа з реквізитами
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення документації
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      add_tender_doc  level2
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити значення поля серед усіх документів тендера  ${viewer}  ${TENDER['TENDER_UAID']}  documentType  x_dgfPlatformLegalDetails


Відображення заголовку документації до лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення документації
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      add_tender_doc  level2
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля title документа ${USERS.users['${tender_owner}']['tender_document']['doc_id']} із ${USERS.users['${tender_owner}'].tender_document.doc_name} для користувача ${viewer}


Відображення вмісту документації до лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення документації
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      add_tender_doc_content  level2
  Звірити відображення вмісту документа ${USERS.users['${tender_owner}'].tender_document.doc_id} із ${USERS.users['${tender_owner}'].tender_document.doc_content} для користувача ${viewer}


Неможливість додати актив лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування лота
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_item  level3
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Неможливість додати предмет закупівлі в тендер


Відображення опису нової номенклатури
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення номенклатури лота
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      add_item_view  level2
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення поля description у новоствореному предметі для усіх користувачів


Неможливість видалити актив лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування лота
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      delete_item  level3
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Неможливість видалити предмет закупівлі з тендера


##############################################################################################
#             QUESTIONS
##############################################################################################

Можливість задати запитання на лот
  [Tags]   ${USERS.users['${provider}'].broker}: Задання запитання
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      ask_question_to_tender  level1
  [Teardown]  Оновити LMD і дочекатись синхронізації  ${provider}
  Можливість задати запитання на тендер користувачем ${provider}


Відображення заголовку анонімного запитання на лот без відповіді
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення запитання
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      ask_question_to_tender
  Звірити відображення поля title запитання на тендер для усіх користувачів


Відображення опису анонімного запитання на лот без відповіді
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення запитання
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
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
  ...      viewer tender_owner provider provider1
  ...      ${USERS.users['${viewer}'].broker}
  ...      ask_question_to_item
  :FOR  ${item_index}  IN RANGE  ${NUMBER_OF_ITEMS}
  \  Звірити відображення поля title запитання на ${item_index} предмет для усіх користувачів


Відображення опису анонімного запитання на всі предмети без відповіді
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення запитання
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
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

##############################################################################################
#             BIDDING
##############################################################################################

Неможливість подати пропозицію першим учасником без кваліфікації
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      make_bid_by_provider_without_qualification  level1
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Неможливість подати цінову попрозицію без кваліфікації користувачем ${provider}


Можливість подати пропозицію першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      make_bid_by_provider  level1
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати цінову пропозицію користувачем ${provider}


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


Можливість подати пропозицію другим учасником
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      make_bid_by_provider1  level1
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати цінову пропозицію користувачем ${provider1}


Можливість подати пропозицію третім учасником
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції
  ...      provider2
  ...      ${USERS.users['${provider1}'].broker}
  ...      make_bid_by_provider2  level1
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати цінову пропозицію користувачем ${provider2}

##############################################################################################
#             ABOVETRHESHOLD  BIDDING
##############################################################################################

Можливість змінити документацію цінової пропозиції з публічної на приватну
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      openeu_make_bid_doc_private_by_provider
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість змінити документацію цінової пропозиції з публічної на приватну учасником ${provider}


Можливість завантажити фінансовий документ до пропозиції першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      openeu_add_financial_bid_doc_by_provider
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість завантажити financial_documents документ до пропозиції учасником ${provider}


Можливість завантажити кваліфікаційний документ до пропозиції першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      openeu_add_qualification_bid_doc_by_provider
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість завантажити qualification_documents документ до пропозиції учасником ${provider}


Можливість завантажити документ для критеріїв прийнятності до пропозиції першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      openeu_add_eligibility_bid_doc_by_provider
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість завантажити eligibility_documents документ до пропозиції учасником ${provider}


Можливість редагувати однопредметний тендер більше ніж за 7 днів до завершення періоду подання пропозицій
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      open_modify_tender_in_tendering_period
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_description}=  create_fake_sentence
  Можливість змінити поле description тендера на ${new_description}
  Remove From Dictionary  ${USERS.users['${tender_owner}'].tender_data.data}  description


Відображення зміни статусу першої пропозиції після редагування інформації про тендер
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      open_confirm_first_bid
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  Відображення зміни статусу пропозицій на invalid для учасника ${provider}


Відображення зміни статусу другої пропозиції після редагування інформації про тендер
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      open_confirm_second_bid
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider1}
  Відображення зміни статусу пропозицій на invalid для учасника ${provider1}


Можливість підтвердити цінову пропозицію після зміни умов тендера першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      open_confirm_first_bid
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість підтвердити цінову пропозицію учасником ${provider}


Можливість підтвердити цінову пропозицію після зміни умов тендера другим учасником
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ...      open_confirm_second_bid
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість підтвердити цінову пропозицію учасником ${provider1}


Можливість підтвердити цінову пропозицію після зміни умов третьому учаснику
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції
  ...      provider2
  ...      ${USERS.users['${provider1}'].broker}
  ...      open_confirm_third_bid
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


Неможливість побачити цінові пропозиції учасників під час прийому пропозицій
  [Tags]   ${USERS.users['${viewer}'].broker}: Подання пропозиції
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      bid_view_in_tendering_period
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Require Failure  ${viewer}  Отримати інформацію із тендера  ${TENDER['TENDER_UAID']}  bids

##############################################################################################
#             AFTER BIDDING
##############################################################################################

Відображення статусу лоту у випадку наявності лише однієї пропозиції
  [Tags]   ${USERS.users['${viewer}'].broker}: Подання пропозиції
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      absence_bid
  [Setup]  Дочекатись дати закінчення прийому пропозицій  ${viewer}  ${TENDER['TENDER_UAID']}
  Звірити cтатус неуспішного тендера  ${viewer}  ${TENDER['TENDER_UAID']}


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
  ...      auction_url
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider1}
  Можливість вичитати посилання на аукціон для учасника ${provider1}

##############################################################################################
#             OPENEU  Pre-Qualification
##############################################################################################

Неможливість додати документацію до тендера під час кваліфікації
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Додання документації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_add_doc_to_tender
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Run Keyword And Expect Error  *  Можливість додати документацію до тендера


Відображення статусу першої пропозиції кваліфікації
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Кваліфікація
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_view
  [Setup]  Дочекатись дати початку періоду прекваліфікації  ${tender_owner}  ${TENDER['TENDER_UAID']}
  Звірити відображення поля qualifications[0].status тендера із pending для користувача ${tender_owner}


Відображення статусу другої пропозиції кваліфікації
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Кваліфікація
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_view
  [Setup]  Дочекатись дати початку періоду прекваліфікації  ${tender_owner}  ${TENDER['TENDER_UAID']}
  Звірити відображення поля qualifications[1].status тендера із pending для користувача ${tender_owner}


Можливість завантажити документ у кваліфікацію пропозиції першого учасника
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Кваліфікація
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_add_doc_to_first_bid
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість завантажити документ у кваліфікацію 0 пропозиції


Можливість підтвердити першу пропозицію кваліфікації
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Кваліфікація
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_approve_first_bid  level1
  [Setup]  Дочекатись дати початку періоду прекваліфікації  ${tender_owner}  ${TENDER['TENDER_UAID']}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість підтвердити 0 пропозицію кваліфікації


Можливість завантажити документ у кваліфікацію пропозиції другого учасника
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Кваліфікація
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_add_doc_to_second_bid
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість завантажити документ у кваліфікацію 1 пропозиції


Можливість відхилити другу пропозицію кваліфікації
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Кваліфікація
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_reject_second_bid
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість відхилити 1 пропозиції кваліфікації


Можливість скасувати рішення кваліфікації для другої пропопозиції
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Кваліфікація
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_cancel_second_bid_qualification
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість скасувати рішення кваліфікації для 1 пропопозиції


Можливість підтвердити другу пропозицію кваліфікації
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Кваліфікація
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_approve_second_bid  level1
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість підтвердити -1 пропозицію кваліфікації


Можливість підтвердити третю пропозицію кваліфікації
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Кваліфікація
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_approve_third_bid  level1
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість підтвердити -2 пропозицію кваліфікації


Можливість затвердити остаточне рішення кваліфікації
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Кваліфікація
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_approve_qualifications  level1
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість затвердити остаточне рішення кваліфікації


Відображення статусу блокування перед початком аукціону
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Кваліфікація
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_view
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  Звірити статус тендера  ${tender_owner}  ${TENDER['TENDER_UAID']}  active.pre-qualification.stand-still


Відображення дати закінчення періоду блокування перед початком аукціону
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Кваліфікація
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      pre-qualification_view
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


Можливість перевести статус очікування обробки мостом
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

