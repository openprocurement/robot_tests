*** Settings ***
Resource        base_keywords.robot
Suite Setup     Test Suite Setup
Suite Teardown  Test Suite Teardown


*** Variables ***
@{USED_ROLES}       tender_owner  provider  provider1  viewer
${MODE}  auctions

*** Test Cases ***
Можливість активувати процедуру
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Активація процедури
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      activate_tender
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Завантажити дані про тендер
  Run As  ${tender_owner}  Активувати процедуру  ${TENDER['TENDER_UAID']}


Можливість знайти процедуру по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук процедури
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      find_tender
  Можливість знайти тендер по ідентифікатору для усіх користувачів

# ##############################################################################################
# #             Відображення основних даних аукціону
# ##############################################################################################

Відображення ідентифікатора аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних процедури
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      tender_view
  Отримати дані із поля auctionID тендера для усіх користувачів


Відображення заголовку аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних процедури
  ...      viewer  tender_owner  provider
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      tender_view
  Отримати дані із поля title тендера для усіх користувачів


Відображення опису аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних процедури
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      tender_view
  Отримати дані із поля description тендера для усіх користувачів


Відображення мінімальної кількості учасників аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних процедури
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      tender_view
  Отримати дані із поля minNumberOfQualifiedBids тендера для усіх користувачів


Відображення поля "Лоти виставляються"
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних процедури
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      tender_view_tenderAttempts
  Отримати дані із поля tenderAttempts тендера для усіх користувачів


Відображення типу оголошеної процедури
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних процедури
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      tender_view
  Отримати дані із поля procurementMethodType тендера для усіх користувачів


Відображення типу аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних процедури
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      tender_view_auctionParameters
  Отримати дані із поля auctionParameters.type тендера для усіх користувачів


Відображення імені організатора аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних процедури
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      tender_view
  Отримати дані із поля procuringEntity.name тендера для усіх користувачів


Відображення початкової вартості аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних процедури
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      tender_view
  Отримати дані із поля value.amount тендера для усіх користувачів


Відображення мінімального кроку
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних процедури
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      tender_view
  Отримати дані із поля minimalStep.amount тендера для усіх користувачів


Відображення гарантійного внеску
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних процедури
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      tender_view
  Отримати дані із поля guarantee.amount тендера для усіх користувачів


Відображення розміру реєстраційного внеску
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних процедури
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      tender_view
  Отримати дані із поля registrationFee.amount тендера для усіх користувачів


Відображення закінчення періоду прийому пропозицій
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних процедури
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      tender_view_tenderPeriod
  Отримати дані із поля tenderPeriod.endDate лоту для усіх користувачів


Неможливість змінити дані про організатора aукціону
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Неможливість редагувати процедуру
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modify_auction_procuringEntity
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  ${new_procuringEntity_name}=  create_fake_sentence
  Перевірити неможливість зміни поля procuringEntity.name тендера на значення ${new_procuringEntity_name} для користувача ${tender_owner}

# ##############################################################################################
# #             Відображення основних даних активу
# ##############################################################################################

Відображення опису активу
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення активів лоту
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      tender_view
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Отримати дані із поля description предмета для усіх користувачів


Відображення схеми класифікації активу
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення активів лоту
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      tender_view_classification
  Отримати дані із поля classification.scheme предмета для усіх користувачів


Відображення ідентифікатора класифікації активу
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення активів лоту
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      tender_view_classification
  Отримати дані із поля classification.id предмета для усіх користувачів


Відображення назви одиниці активу
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення активів лоту
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      tender_view
  Отримати дані із поля unit.name предмета для усіх користувачів


Відображення кількості активів
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення активів лоту
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      tender_view
  Отримати дані із поля quantity предмета для усіх користувачів

# ##############################################################################################
# #             QUESTIONS
# ##############################################################################################

Можливість задати запитання до аукціону
  [Tags]   ${USERS.users['${provider}'].broker}: Задання запитання
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      ask_question_to_tender
  [Teardown]  Оновити LMD і дочекатись синхронізації  ${provider}
  Можливість задати запитання на тендер користувачем ${provider}


Відображення заголовку анонімного запитання до аукціону без відповіді
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення запитання
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      ask_question_to_tender
  Звірити відображення поля title запитання на тендер для усіх користувачів


Відображення опису анонімного запитання до аукціону без відповіді
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення запитання
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      ask_question_to_tender
  Звірити відображення поля description запитання на тендер для усіх користувачів


Можливість відповісти на запитання до аукціону
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Відповідь на запитання
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      answer_question_to_tender
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LMD і дочекатись синхронізації  ${tender_owner}
  Можливість відповісти на запитання на тендер


Відображення відповіді на запитання до аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення відповіді на запитання
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      answer_question_to_tender
  Звірити відображення поля answer запитання на тендер для усіх користувачів


Можливість задати запитання до всіх активів
  [Tags]   ${USERS.users['${provider}'].broker}: Задання запитання
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      ask_question_to_item
  [Teardown]  Оновити LMD і дочекатись синхронізації  ${provider}
  :FOR  ${item_index}  IN RANGE  ${NUMBER_OF_ITEMS}
  \  Можливість задати запитання на ${item_index} предмет користувачем ${provider}


Відображення заголовку анонімного запитання до всіх активів
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення запитання
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      ask_question_to_item
  :FOR  ${item_index}  IN RANGE  ${NUMBER_OF_ITEMS}
  \  Звірити відображення поля title запитання на ${item_index} предмет для усіх користувачів


Відображення опису анонімного запитання до всіх активів
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення запитання
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      ask_question_to_item
  :FOR  ${item_index}  IN RANGE  ${NUMBER_OF_ITEMS}
  \  Звірити відображення поля description запитання на ${item_index} предмет для усіх користувачів


Можливість відповісти на запитання до всіх активів
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Відповідь на запитання
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      answer_question_to_item
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LMD і дочекатись синхронізації  ${tender_owner}
  :FOR  ${item_index}  IN RANGE  ${NUMBER_OF_ITEMS}
  \  Можливість відповісти на запитання на ${item_index} предмет


Відображення відповіді на запитання до всіх активів
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення відповіді на запитання
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      answer_question_to_item
  :FOR  ${item_index}  IN RANGE  ${NUMBER_OF_ITEMS}
  \  Звірити відображення поля answer запитання на ${item_index} предмет для усіх користувачів

# ##############################################################################################
# #             BIDDING
# ##############################################################################################

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
  ...      make_bid_by_provider1
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість подати цінову пропозицію користувачем ${provider1}


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

# ##############################################################################################
# #             AFTER BIDDING
# ##############################################################################################

Неможливість завантажити документ першим учасником після закінчення прийому пропозицій
  [Tags]   ${USERS.users['${provider1}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider1}'].broker}
  ...      add_bid_doc_after_tendering_period_by_provider
  [Setup]  Дочекатись дати закінчення прийому пропозицій  ${provider}  ${TENDER['TENDER_UAID']}
  Run Keyword And Expect Error  *  Можливість завантажити документ в пропозицію користувачем ${provider}


Неможливість подати пропозицію після закінчення подачі пропозицій першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Подання пропозиції
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      make_bid_after_tendering_period
  [Setup]  Дочекатись дати закінчення прийому пропозицій  ${provider}  ${TENDER['TENDER_UAID']}
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


Відображення неуспішного статусу процедури
  [Tags]   ${USERS.users['${viewer}'].broker}: Подання пропозиції
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      absence_bid
  [Setup]  Дочекатись дати закінчення прийому пропозицій  ${viewer}  ${TENDER['TENDER_UAID']}
  Звірити cтатус неуспішного тендера  ${viewer}  ${TENDER['TENDER_UAID']}

##############################################################################################
#             CANCELLATION
##############################################################################################

Можливість скасувати процедуру
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Скасування процедури
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  tender_cancellation
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість скасувати тендер


Відображення активного статусу скасування процедури
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення скасування процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_cancellation
  Звірити статус скасування тендера  ${viewer}  ${TENDER['TENDER_UAID']}


Відображення статусу скасованої процедури
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення статусу скасування процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_cancellation
  Звірити статус скасованого лоту  ${viewer}  ${TENDER['TENDER_UAID']}


Відображення причини скасування процедури
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення скасування процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_cancellation
  Звірити поле тендера із значенням  ${viewer}  ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${tender_owner}']['cancellation_data']['cancellation_reason']}
  ...      cancellations[0].reason


Відображення опису документа до скасування процедури
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення скасування процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_cancellation_description
  Звірити відображення поля description документа ${USERS.users['${tender_owner}']['cancellation_data']['document']['doc_id']} із ${USERS.users['${tender_owner}']['cancellation_data']['description']} для користувача ${viewer}


Відображення заголовку документа до скасування процедури
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення скасування процедури
  ...  viewer
  ...  ${USERS.users['${viewer}'].broker}
  ...  tender_cancellation_title
  Звірити відображення поля title документа ${USERS.users['${tender_owner}']['cancellation_data']['document']['doc_id']} із ${USERS.users['${tender_owner}']['cancellation_data']['document']['doc_name']} для користувача ${viewer}
