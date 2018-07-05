*** Settings ***
Resource        base_keywords.robot
Suite Setup     Test Suite Setup
Suite Teardown  Test Suite Teardown

*** Variables ***
@{USED_ROLES}   tender_owner  viewer  provider  provider1
${NUMBER_OF_AWARDS}  ${2}
${MODE}  auctions

*** Test Cases ***
##############################################################################################
#             FIND TENDER
##############################################################################################

Можливість знайти процедуру по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук лоту
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      find_tender
  Завантажити дані про тендер
  Можливість знайти тендер по ідентифікатору для усіх користувачів


Можливість звірити статус процедури в період кваліфікації
  [Tags]   ${USERS.users['${viewer}'].broker}: Процес кваліфікації
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      awarding
  [Setup]  Дочекатись початку кваліфікації  ${viewer}  ${TENDER['TENDER_UAID']}
  Звірити кількість сформованих авардів лоту із ${NUMBER_OF_AWARDS} для користувача ${viewer}
  Звірити статус тендера  ${viewer}  ${TENDER['TENDER_UAID']}  active.qualification

##############################################################################################
#             AWARDING
##############################################################################################

Відображення статусу 'очікується підтвердження' для єдиного кандидата
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення статусу аварду
  ...     viewer  tender_owner  provider  provider1
  ...     ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...     ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...     award_admission_status
  [Setup]  Оновити LAST_MODIFICATION_DATE
  Звірити відображення поля awards[0].status тендера із pending.admission для усіх користувачів


Відображення статусу неуспішного лоту через відсутність завантаженого протоколу підтвердження
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення статусу аукціону
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      wait_for_verificationEndDate
  Звірити cтатус неуспішного тендера  ${viewer}  ${TENDER['TENDER_UAID']}


Можливість завантажити протокол підтвердження проведення кваліфікації
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...     tender_owner
  ...     ${USERS.users['${tender_owner}'].broker}
  ...     add_admission_protocol
  [Teardown]  Оновити LMD і дочекатись синхронізації  ${tender_owner}
  Можливість завантажити протокол погодження в авард 0 користувачем ${tender_owner}


Можливість активувати процес кваліфікації єдиного учасника
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...     tender_owner
  ...     ${USERS.users['${tender_owner}'].broker}
  ...     confirm_admission
  [Teardown]  Оновити LMD і дочекатись синхронізації  ${tender_owner}
  Run As  ${tender_owner}  Активувати кваліфікацію учасника  ${TENDER['TENDER_UAID']}


Можливість завантажити протокол дискваліфікації єдиного кандидата
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...     tender_owner
  ...     ${USERS.users['${tender_owner}'].broker}
  ...     disqualified_award
  [Teardown]  Оновити LMD і дочекатись синхронізації  ${tender_owner}
  Можливість завантажити протокол дискваліфікації в авард 0 користувачем ${tender_owner}


Можливість дискваліфікувати єдиного кандидата
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...     tender_owner
  ...     ${USERS.users['${tender_owner}'].broker}
  ...     disqualified_award
  [Teardown]  Оновити LMD і дочекатись синхронізації  ${tender_owner}
  ${description}=  create_fake_sentence
  Run As  ${tender_owner}  Дискваліфікувати постачальника  ${TENDER['TENDER_UAID']}  0  ${description}


Відображення статусу 'очікується протокол' для першого кандидата
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення статусу аварду
  ...     viewer  tender_owner  provider  provider1
  ...     ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...     ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...     first_award_pending_status
  [Setup]  Оновити LAST_MODIFICATION_DATE
  Звірити відображення поля awards[0].status тендера із pending для усіх користувачів


Відображення статусу 'очікується кінець кваліфікації' для другого кандидата
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення статусу аварду
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     second_award_waiting_status
  [Setup]  Оновити LMD і дочекатись синхронізації  ${viewer}
  Звірити відображення поля awards[1].status тендера із pending.waiting для користувача ${viewer}


Неможливість підтвердити першого кандидата без завантаженого протоколу
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...     tender_owner
  ...     ${USERS.users['${tender_owner}'].broker}
  ...     confirm_award
  Require Failure  ${tender_owner}  Підтвердити постачальника  ${TENDER['TENDER_UAID']}  0


Можливість завантажити протокол аукціону в авард для першого кандидата
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...     tender_owner
  ...     ${USERS.users['${tender_owner}'].broker}
  ...     add_protocol_to_first_award
  [Teardown]  Оновити LMD і дочекатись синхронізації  ${tender_owner}
  Можливість завантажити протокол аукціону в авард 0 користувачем ${tender_owner}


Можливість підтвердити першого кандидата
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...     tender_owner
  ...     ${USERS.users['${tender_owner}'].broker}
  ...     confirm_first_award
  [Teardown]  Оновити LMD і дочекатись синхронізації  ${tender_owner}
  Run As  ${tender_owner}  Підтвердити постачальника  ${TENDER['TENDER_UAID']}  0


Відображення статусу 'очікується завантаження контракту' для першого кандидата
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення статусу аварду
  ...     viewer  tender_owner  provider  provider1
  ...     ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...     ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...     first_award_active_status
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}  ${provider}  ${provider1}
  \  Run Keyword And Ignore Error  Remove From Dictionary  ${USERS.users['${username}'].tender_data.data.awards[0]}  status
  Звірити відображення поля awards[0].status тендера із active для усіх користувачів


Можливість скасувати рішення кваліфікації другим кандидатом
  [Tags]  ${USERS.users['${provider1}'].broker}: Процес кваліфікації
  ...     provider1
  ...     ${USERS.users['${provider1}'].broker}
  ...     cancel_second_award
  [Teardown]  Оновити LMD і дочекатись синхронізації  ${provider1}
  Run As  ${provider1}  Скасування рішення кваліфікаційної комісії  ${TENDER['TENDER_UAID']}  1


Відображення статусу 'cancelled' для другого кандидата
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення статусу аварду
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     second_award_cancelled_status
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Run Keyword And Ignore Error  Remove From Dictionary  ${USERS.users['${viewer}'].tender_data.data.awards[1]}  status
  Звірити відображення поля awards[1].status тендера із cancelled для користувача ${viewer}


Можливість завантажити протокол дискваліфікації першого кандидата
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...     tender_owner
  ...     ${USERS.users['${tender_owner}'].broker}
  ...     disqualified_first_award
  [Teardown]  Оновити LMD і дочекатись синхронізації  ${tender_owner}
  Можливість завантажити протокол дискваліфікації в авард 0 користувачем ${tender_owner}


Можливість дискваліфікувати першого кандидата
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...     tender_owner
  ...     ${USERS.users['${tender_owner}'].broker}
  ...     disqualified_first_award
  [Teardown]  Оновити LMD і дочекатись синхронізації  ${tender_owner}
  ${description}=  create_fake_sentence
  Run As  ${tender_owner}  Дискваліфікувати постачальника  ${TENDER['TENDER_UAID']}  0  ${description}


Відображення статусу 'unsuccessful' для першого кандидата
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення статусу аварду
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     first_award_status_unsuccessful
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Run Keyword And Ignore Error  Remove From Dictionary  ${USERS.users['${viewer}'].tender_data.data.awards[0]}  status
  Звірити відображення поля awards[0].status тендера із unsuccessful для користувача ${viewer}


Можливість завантажити протокол скасування контракту
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...     tender_owner
  ...     ${USERS.users['${tender_owner}'].broker}
  ...     cancel_contract
  [Teardown]  Оновити LMD і дочекатись синхронізації  ${tender_owner}
  Можливість завантажити протокол скасування в контракт -1 користувачем ${tender_owner}


Можливість скасувати контракт
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...     tender_owner
  ...     ${USERS.users['${tender_owner}'].broker}
  ...     cancel_contract
  [Teardown]  Оновити LMD і дочекатись синхронізації  ${tender_owner}
  Run As  ${tender_owner}  Скасувати контракт  ${TENDER['TENDER_UAID']}  -1


Відображення статусу скасованої угоди
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення основних даних угоди
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...      contract_cancel_view
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Run As  ${viewer}  Оновити сторінку з тендером  ${TENDER['TENDER_UAID']}
  Звірити поле тендера із значенням  ${viewer}  ${TENDER['TENDER_UAID']}  cancelled  contracts[-1].status


Відображення статусу 'очікується протокол' для другого кандидата
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення статусу аварду
  ...     viewer  tender_owner  provider  provider1
  ...     ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...     ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...     second_award_pending_status
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}  ${provider}  ${provider1}
  \  Run Keyword And Ignore Error  Remove From Dictionary  ${USERS.users['${username}'].tender_data.data.awards[1]}  status
  Звірити відображення поля awards[1].status тендера із pending для усіх користувачів


Можливість завантажити протокол дискваліфікації другого кандидата
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...     tender_owner
  ...     ${USERS.users['${tender_owner}'].broker}
  ...     disqualified_second_award
  [Teardown]  Оновити LMD і дочекатись синхронізації  ${tender_owner}
  Можливість завантажити протокол дискваліфікації в авард 1 користувачем ${tender_owner}


Можливість дискваліфікувати другого кандидата
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...     tender_owner
  ...     ${USERS.users['${tender_owner}'].broker}
  ...     disqualified_second_award
  [Teardown]  Оновити LMD і дочекатись синхронізації  ${tender_owner}
  ${description}=  create_fake_sentence
  Run As  ${tender_owner}  Дискваліфікувати постачальника  ${TENDER['TENDER_UAID']}  1  ${description}


Відображення статусу 'unsuccessful' для другого кандидата
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення статусу аварду
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     second_award_status_unsuccessful
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Run Keyword And Ignore Error  Remove From Dictionary  ${USERS.users['${viewer}'].tender_data.data.awards[1]}  status
  Звірити відображення поля awards[1].status тендера із unsuccessful для користувача ${viewer}


Неможливість змінити статус на 'очікується підписання договору' для другого кандидата
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...     tender_owner
  ...     ${USERS.users['${tender_owner}'].broker}
  ...     confirm_award
  Require Failure  ${tender_owner}  Підтвердити постачальника  ${TENDER['TENDER_UAID']}  1


Можливість завантажити протокол аукціону в авард для другого кандидата
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...     tender_owner
  ...     ${USERS.users['${tender_owner}'].broker}
  ...     add_protocol_to_second_award
  [Teardown]  Оновити LMD і дочекатись синхронізації  ${tender_owner}
  Можливість завантажити протокол аукціону в авард 1 користувачем ${tender_owner}


Можливість підтвердити другого кандидата
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...     tender_owner
  ...     ${USERS.users['${tender_owner}'].broker}
  ...     confirm_second_award
  [Teardown]  Оновити LMD і дочекатись синхронізації  ${tender_owner}
  Run As  ${tender_owner}  Підтвердити постачальника  ${TENDER['TENDER_UAID']}  1


Відображення статусу 'очікується завантаження контракту' для другого кандидата
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення статусу аварду
  ...     viewer  tender_owner  provider  provider1
  ...     ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...     ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...     second_award_active_status
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}  ${provider}  ${provider1}
  \  Run Keyword And Ignore Error  Remove From Dictionary  ${USERS.users['${username}'].tender_data.data.awards[1]}  status
  Звірити відображення поля awards[1].status тендера із active для усіх користувачів


Відображення статусу неуспішного аукціону
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення статусу аукціону
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_status_unsuccessful
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити cтатус неуспішного тендера  ${viewer}  ${TENDER['TENDER_UAID']}