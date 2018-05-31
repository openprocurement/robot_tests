*** Settings ***
Resource        base_keywords.robot
Suite Setup     Test Suite Setup
Suite Teardown  Test Suite Teardown


*** Variables ***

${MODE}              lots
${RESOURCE}          lots
@{USED_ROLES}        tender_owner  viewer
${NUMBER_OF_ITEMS}   ${1}


*** Test Cases ***
Можливість створити лот
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Реєстрація лоту
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_lot
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Завантажити дані про тендер
  Можливість оголосити тендер


Можливість додати умови проведення аукціону
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Реєстрація лоту
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      create_lot
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість додати умови проведення аукціону


Можливість дочекатись статусу 'Інформаційне повідомлення опубліковано'
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Відображення основних даних лоту
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      lot_status
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  Звірити статус опублікованого лоту  ${tender_owner}  ${TENDER['TENDER_UAID']}


Можливість знайти лот по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук лоту
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      find_lot
  Можливість знайти тендер по ідентифікатору для усіх користувачів

##############################################################################################
#             Відображення основних даних лоту
##############################################################################################

Відображення ідентифікатора лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      lot_view
  Звірити відображення поля lotID тендера із ${TENDER['TENDER_UAID']} для усіх користувачів


Відображення дати створення лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      lot_view
  Отримати дані із дати date тендера для усіх користувачів


Відображення дати завершення періоду редагування об'єкта МП
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      lot_view
  Отримати дані із дати rectificationPeriod.endDate тендера для усіх користувачів


Відображення ідентифікатору об'єкта, який прив'язаний до лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      lot_view
  Отримати дані із поля assets[0] лоту для усіх користувачів


Відображення заголовку лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      lot_view
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Отримати дані із поля title тендера для усіх користувачів


Відображення опису лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      lot_view
  Отримати дані із поля description тендера для усіх користувачів


Відображення назви організації балансоутримувача лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      lot_view
  Отримати дані із поля lotHolder.name тендера для усіх користувачів


Відображення схеми ідентифікації організації балансоутримувача лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      lot_view
  Отримати дані із поля lotHolder.identifier.scheme тендера для усіх користувачів


Відображення ідентифікатора організації балансоутримувача лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      lot_view
  Отримати дані із поля lotHolder.identifier.id тендера для усіх користувачів


Відображення схеми ідентифікації організації розпорядника лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      lot_view
  Отримати дані із поля lotCustodian.identifier.scheme тендера для усіх користувачів


Відображення ідентифікатора організації розпорядника лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      lot_view
  Отримати дані із поля lotCustodian.identifier.id тендера для усіх користувачів


Відображення юридичної назви організації розпорядника лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      lot_view
  Отримати дані із поля lotCustodian.identifier.legalName тендера для усіх користувачів


Відображення імені контактної особи організації розпорядника лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      lot_view
  Отримати дані із поля lotCustodian.contactPoint.name тендера для усіх користувачів


Відображення контактного номера організації розпорядника лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      lot_view
  Отримати дані із поля lotCustodian.contactPoint.telephone тендера для усіх користувачів


Відображення адреси електронної пошти організації розпорядника лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      lot_view
  Отримати дані із поля lotCustodian.contactPoint.email тендера для усіх користувачів


Відображення дати прийняття рішення про затвердження умов продажу лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      lot_view
  Звірити відображення дати decisions[0].decisionDate тендера для усіх користувачів


Відображення номера рішення про затвердження умов продажу лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      lot_view
  Отримати дані із поля decisions[0].decisionID тендера для усіх користувачів


Відображення найменування рішення про приватизацію об'єкта МП
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      lot_view
  Отримати дані із поля decisions[1].title тендера для усіх користувачів


Відображення дати прийняття рішення про приватизацію об'єкта МП
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      lot_view
  Отримати дані із дати decisions[1].decisionDate тендера для усіх користувачів


Відображення номера рішення про приватизацію об'єкта МП
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      lot_view
  Отримати дані із поля decisions[1].decisionID тендера для усіх користувачів

# #############################################################################################
#             Відображення основних даних активу лоту
# #############################################################################################

Відображення опису активу лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення активів лоту
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      lot_view
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Отримати дані із поля description предмета для усіх користувачів


Відображення схеми класифікації активу лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення активів лоту
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      lot_view
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Отримати дані із поля classification.scheme предмета для усіх користувачів


Відображення ідентифікатора класифікації активу лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення активів лоту
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      lot_view
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Отримати дані із поля classification.id предмета для усіх користувачів


Відображення назви одиниці виміру активу лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення активів лоту
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      lot_view
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Отримати дані із поля unit.name предмета для усіх користувачів


Відображення кількості одиниць виміру активу лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення активів лоту
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      lot_view
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Отримати дані із поля quantity предмета для усіх користувачів


Відображення інформації про державну реєстрацію активу лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення активів лоту
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      lot_view
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Отримати дані із поля registrationDetails.status предмета для усіх користувачів

##############################################################################################
#             Відображення основних даних аукціону
##############################################################################################

Відображення типу усіх аукціонів
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення умов проведення аукціону
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      lot_view
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Отримати дані із поля procurementMethodType усіх аукціонів для усіх користувачів


Відображення статусу усіх аукціонів
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення умов проведення аукціону
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      lot_view
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Отримати дані із поля status усіх аукціонів для усіх користувачів


Відображення кількості виставлень лоту для усіх аукціонів
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення умов проведення аукціону
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      lot_view
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Отримати дані із поля tenderAttempts усіх аукціонів для усіх користувачів


Відображення початкової вартості усіх аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення умов проведення аукціону
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      lot_view
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Отримати дані із поля value.amount усіх аукціонів для усіх користувачів


Відображення кроку усіх аукціонів
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення умов проведення аукціону
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      lot_view
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Отримати дані із поля minimalStep.amount усіх аукціонів для усіх користувачів


Відображення розміру гарантійного внеску усіх аукціонів
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення умов проведення аукціону
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      lot_view
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Отримати дані із поля guarantee.amount усіх аукціонів для усіх користувачів


Відображення розміру реєстраційного внеску усіх аукціонів
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення умов проведення аукціону
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      lot_view
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Отримати дані із поля registrationFee.amount усіх аукціонів для усіх користувачів


Відображення періоду на подачу пропозицій в 2 та 3 процедурі циклу
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення умов проведення аукціону
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      lot_view
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  :FOR  ${index}  IN  1  2
  \  Отримати дані із поля auctions[${index}].tenderingDuration тендера для усіх користувачів


Відображення дати початку першого аукціону циклу
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення умов проведення аукціону
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      lot_view
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Отримати дані із дати auctions[0].auctionPeriod.startDate тендера для усіх користувачів

##############################################################################################
#             Завантаження документації до лоту
##############################################################################################

Можливість додати ілюстрацію до лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Додання документації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_illustration
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість додати ілюстрацію до лоту


Можливість завантажити паспорт торгів до лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Додання документації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_notice
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість завантажити документ до тендера з типом notice


Можливість завантажити презентацію до лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Додання документації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_presentation
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість завантажити документ до тендера з типом x_presentation


Можливість завантажити публічний паспорт активу лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Додання документації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_tech_specifications
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість завантажити документ до тендера з типом technicalSpecifications


Відображення вмісту документації лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення документації
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      add_doc_content
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення вмісту документа ${USERS.users['${tender_owner}'].tender_document.doc_id} із ${USERS.users['${tender_owner}'].tender_document.doc_content} для користувача ${viewer}

##############################################################################################
#             Завантаження документації до аукціону
##############################################################################################

Можливість завантажити паспорт торгів до умов проведення аукціону
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Додання документації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_notice
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість завантажити документ з типом notice до 0 аукціону


Можливість завантажити презентацію до умов проведення аукціону
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Додання документації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_presentation
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість завантажити документ з типом x_presentation до 0 аукціону


Можливість завантажити публічний паспорт до умов проведення аукціону
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Додання документації
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_tech_specifications
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість завантажити документ з типом technicalSpecifications до 0 аукціону


Відображення вмісту документації до умов проведення аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення документації
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      add_doc_content
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити відображення вмісту документа ${USERS.users['${tender_owner}'].auction_document.doc_id} із ${USERS.users['${tender_owner}'].auction_document.doc_content} для користувача ${viewer}

##############################################################################################
#             Редагування лоту
##############################################################################################

Можливість відредагувати заголовок лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати лот
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_lot
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_title}=  create_fake_title  ua
  Set To Dictionary  ${USERS.users['${tender_owner}']}  new_title=${new_title}
  Run As  ${tender_owner}  Внести зміни в лот  ${TENDER['TENDER_UAID']}  title  ${new_title}


Відображення зміненого заголовку лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      modify_lot
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \  Run Keyword And Ignore Error  Remove From Dictionary  ${USERS.users['${username}'].tender_data.data}  title
  Звірити відображення поля title тендера із ${USERS.users['${tender_owner}'].new_title} для усіх користувачів


Можливість відредагувати опис лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати лот
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_lot
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_description}=  create_fake_description  ua
  Set To Dictionary  ${USERS.users['${tender_owner}']}  new_description=${new_description}
  Run As  ${tender_owner}  Внести зміни в лот  ${TENDER['TENDER_UAID']}  description  ${new_description}


Відображення зміненого опису лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      modify_lot
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \  Run Keyword And Ignore Error  Remove From Dictionary  ${USERS.users['${username}'].tender_data.data}  description
  Звірити відображення поля description тендера із ${USERS.users['${tender_owner}'].new_description} для усіх користувачів


Можливість внести зміни до дати прийняття рішення про затвердження умов продажу лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати лот
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_decisions
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_date}=  create_fake_decisionDate
  Set To Dictionary  ${USERS.users['${tender_owner}']}  new_date=${new_date}
  Run As  ${tender_owner}  Внести зміни в лот  ${TENDER['TENDER_UAID']}  decisions[0].decisionDate  ${new_date}


Відображення зміненої дати прийняття рішення про затвердження умов продажу лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      modify_decisions
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \  Run Keyword And Ignore Error  Remove From Dictionary  ${USERS.users['${username}'].tender_data.data.decisions[0]}  decisionDate
  Звірити відображення дати decisions[0].decisionDate тендера із ${USERS.users['${tender_owner}'].new_date} для усіх користувачів


Можливість внести зміни до номера рішення про затвердження умов продажу лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати лот
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_decisions
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_ID}=  create_fake_decisionID
  Set To Dictionary  ${USERS.users['${tender_owner}']}  new_ID=${new_ID}
  Run As  ${tender_owner}  Внести зміни в лот  ${TENDER['TENDER_UAID']}  decisions[0].decisionID  ${new_ID}


Відображення зміненого номера рішення про затвердження умов продажу лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      modify_decisions
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \  Run Keyword And Ignore Error  Remove From Dictionary  ${USERS.users['${username}'].tender_data.data.decisions[0]}  decisionID
  Звірити відображення поля decisions[0].decisionID тендера із ${USERS.users['${tender_owner}'].new_ID} для усіх користувачів


Неможливість внести зміни до дати прийняття рішення про приватизацію активу
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати лот
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_decisions
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_date}=  create_fake_decisionDate
  Require Failure  ${tender_owner}  Внести зміни в лот  ${TENDER['TENDER_UAID']}  decisions[1].decisionDate  ${new_date}


Неможливість внести зміни до номера рішення про приватизацію активу
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати лот
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_decisions
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_ID}=  create_fake_decisionID
  Require Failure  ${tender_owner}  Внести зміни в лот  ${TENDER['TENDER_UAID']}  decisions[1].decisionID  ${new_ID}


Можливість змінити ім'я контактної особи організації розпорядника лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати лот
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_lotCustodian
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_name}=  create_fake_sentence
  Set To Dictionary  ${USERS.users['${tender_owner}']}  new_name=${new_name}
  Run As  ${tender_owner}  Внести зміни в лот  ${TENDER['TENDER_UAID']}  lotCustodian.contactPoint.name  ${new_name}


Відображення зміненого імені контактної особи організації розпорядника лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      modify_lotCustodian
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \  Run Keyword And Ignore Error  Remove From Dictionary  ${USERS.users['${username}'].tender_data.data.lotCustodian.contactPoint}  name
  Звірити відображення поля lotCustodian.contactPoint.name тендера із ${USERS.users['${tender_owner}'].new_name} для усіх користувачів


Можливість внести зміни до кількості одиниць виміру активу об’єкта МП
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати акти лоту
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_lot
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${quantity}=  create_fake_items_quantity
  Set To Dictionary  ${USERS.users['${tender_owner}']}  quantity=${quantity}
  Можливість змінити поле quantity предмета на ${quantity}


Відображення зміненої кількості одиниць виміру активу об’єкта МП
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних активу лоту
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      modify_lot
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \  Run Keyword And Ignore Error  Remove From Dictionary  ${USERS.users['${username}'].tender_data.data['items'][0]}  quantity
  Звірити відображення зміненого поля quantity активу лоту із ${USERS.users['${tender_owner}'].quantity} для усіх користувачів


Можливість внести зміни до ідентифікатора класифікації активу лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати актив лоту
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_classification_id
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${scheme_id}=  Run As  ${tender_owner}  Отримати інформацію із лоту  ${TENDER['TENDER_UAID']}  items[0].classification.id
  ${new_id}=  create_fake_scheme_id  ${scheme_id}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  new_id=${new_id}
  Можливість змінити поле classification.id предмета на ${new_id}


Відображення зміненого ідентифікатора класифікації активу об’єкта МП
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних активу лоту
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      modify_classification_id
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \  Run Keyword And Ignore Error  Remove From Dictionary  ${USERS.users['${username}'].tender_data.data['items'][0].classification}  id
  Звірити відображення зміненого поля classification.id активу лоту із ${USERS.users['${tender_owner}'].new_id} для усіх користувачів


Можливість внести зміни до назви одиниці виміру активу об’єкта МП
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати актив лоту
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_unit_name
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_unit_name}=  cretate_fake_unit_name
  Set To Dictionary  ${USERS.users['${tender_owner}']}  new_unit_name=${new_unit_name}
  Можливість змінити поле unit.name предмета на ${new_unit_name}


Відображення зміненої назви одиниці виміру активу об’єкта МП
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних активу лоту
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      modify_unit_name
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \  Run Keyword And Ignore Error  Remove From Dictionary  ${USERS.users['${username}'].tender_data.data['items'][0].unit}  name
  Звірити відображення зміненого поля unit.name активу лоту із ${USERS.users['${tender_owner}'].new_unit_name} для усіх користувачів


Можливість внести зміни в інформацію про державну реєстрацію активу об’єкта МП
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість редагувати актив лоту
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_registrationDetails
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість змінити поле registrationDetails.status предмета на complete


Відображення зміненої інформації про державну реєстрацію активу об’єкта МП
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних активу лоту
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      modify_registrationDetails
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \  Run Keyword And Ignore Error  Remove From Dictionary  ${USERS.users['${username}'].tender_data.data['items'][0].registrationDetails}  status
  Звірити відображення зміненого поля registrationDetails.status активу лоту із complete для усіх користувачів


Можливість змінити початкову ціну аукціону
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування умов проведення аукціону
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_auction_value
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_amount}=  create_fake_value  ${USERS.users['${tender_owner}'].tender_data.data.auctions[0].value.amount}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  new_amount=${new_amount}
  Run As  ${tender_owner}  Внести зміни в умови проведення аукціону  ${TENDER['TENDER_UAID']}  value.amount  ${new_amount}  0


Відображення зміненої початкової ціни аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення умов проведення аукціону
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      modify_auction_value
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \  Run Keyword And Ignore Error  Remove From Dictionary  ${USERS.users['${username}'].tender_data.data.auctions[0].value}  amount
  Звірити відображення поля auctions[0].value.amount тендера із ${USERS.users['${tender_owner}'].new_amount} для усіх користувачів


Можливість змінити мінімальний крок аукціону
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування умов проведення аукціону
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_auction_step
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_minimal_step}=  create_fake_minimal_step  ${USERS.users['${tender_owner}'].new_amount}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  new_minimal_step=${new_minimal_step}
  Run As  ${tender_owner}  Внести зміни в умови проведення аукціону  ${TENDER['TENDER_UAID']}  minimalStep.amount  ${new_minimal_step}  0


Відображення зміненого мінімального кроку аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення умов проведення аукціону
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      modify_auction_step
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \  Run Keyword And Ignore Error  Remove From Dictionary  ${USERS.users['${username}'].tender_data.data.auctions[0].minimalStep}  amount
  Звірити відображення поля auctions[0].minimalStep.amount тендера із ${USERS.users['${tender_owner}'].new_minimal_step} для усіх користувачів


Можливість змінити розмір гарантійного внеску аукціону
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування умов проведення аукціону
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_auction_guarantee
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_guarantee_amount}=  create_fake_guarantee  ${USERS.users['${tender_owner}'].new_amount}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  new_guarantee_value=${new_guarantee_amount}
  Run As  ${tender_owner}  Внести зміни в умови проведення аукціону  ${TENDER['TENDER_UAID']}  guarantee.amount  ${new_guarantee_amount}  0


Відображення зміненого розміру гарантійного внеску аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення умов проведення аукціону
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      modify_auction_guarantee
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \  Run Keyword And Ignore Error  Remove From Dictionary  ${USERS.users['${username}'].tender_data.data.auctions[0].guarantee}  amount
  Звірити відображення поля auctions[0].guarantee.amount тендера із ${USERS.users['${tender_owner}'].new_guarantee_value} для усіх користувачів


Можливість змінити розмір реєстраційного внеску аукціону
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування умов проведення аукціону
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_auction_registrationFee
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_guarantee_amount}=  create_fake_guarantee  ${USERS.users['${tender_owner}'].new_amount}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  new_guarantee_value=${new_guarantee_amount}
  Run As  ${tender_owner}  Внести зміни в умови проведення аукціону  ${TENDER['TENDER_UAID']}  registrationFee.amount  ${new_guarantee_amount}  0


Відображення зміненого розміру реєстраційного внеску аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення умов проведення аукціону
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      modify_auction_registrationFee
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \  Run Keyword And Ignore Error  Remove From Dictionary  ${USERS.users['${username}'].tender_data.data.auctions[0].registrationFee}  amount
  Звірити відображення поля auctions[0].registrationFee.amount тендера із ${USERS.users['${tender_owner}'].new_guarantee_value} для усіх користувачів


Можливість змінити дату початку першого аукціону циклу
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Редагування умов проведення аукціону
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_auction
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${new_date}=  create_fake_date
  Set To Dictionary  ${USERS.users['${tender_owner}']}  new_date=${new_date}
  Run As  ${tender_owner}  Внести зміни в умови проведення аукціону  ${TENDER['TENDER_UAID']}  auctionPeriod.startDate  ${new_date}  0


Відображення зміненої дати початку першого аукціону циклу
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення умов проведення аукціону
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      modify_auction
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \  Run Keyword And Ignore Error  Remove From Dictionary  ${USERS.users['${username}'].tender_data.data.auctions[0].auctionPeriod}  startDate
  Звірити відображення дати auctions[0].auctionPeriod.startDate тендера із ${USERS.users['${tender_owner}'].new_date} для усіх користувачів


Відображення дати внесення змін до лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних лоту
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      lot_view
  [Setup]  Оновити LAST_MODIFICATION_DATE
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \  Run Keyword And Ignore Error  Remove From Dictionary  ${USERS.users['${username}'].tender_data.data}  dateModified
  Отримати дані із дати dateModified тендера для усіх користувачів


Неможливість вносити зміни глядачем
  [Tags]   ${USERS.users['${viewer}'].broker}: Можливість редагувати лот
  ...      tender_owner
  ...      ${USERS.users['${viewer}'].broker}
  ...      modify_lot
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  ${new_title}=  create_fake_title  ua
  Require Failure  ${viewer}  Внести зміни в лот  ${TENDER['TENDER_UAID']}  title  ${new_title}

# #############################################################################################
#             Видалення лоту
# #############################################################################################

Можливість завантажити документ про видалення лоту
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Видалення лоту
  ...     tender_owner
  ...     ${USERS.users['${tender_owner}'].broker}
  ...     delete_lot
  [Teardown]  Оновити LMD і дочекатись синхронізації  ${tender_owner}
  ${file_path}  ${file_title}  ${file_content}=  create_fake_doc
  Run As  ${tender_owner}  Завантажити документ для видалення лоту  ${TENDER['TENDER_UAID']}  ${file_path}
  Remove File  ${file_path}


Можливість видалити лот
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Видалення лоту
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      delete_lot
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Run As  ${tender_owner}  Видалити лот  ${TENDER['TENDER_UAID']}


Відображення статусу видаленого лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення статусу видаленого лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      delete_lot
  Оновити LAST_MODIFICATION_DATE
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \  Run Keyword And Ignore Error  Remove From Dictionary  ${USERS.users['${username}'].tender_data.data}  status
  Звірити відображення поля status тендера із pending.deleted для користувача ${viewer}
