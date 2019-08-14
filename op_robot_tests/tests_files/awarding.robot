*** Settings ***
Resource        base_keywords.robot
Suite Setup     Test Suite Setup
Suite Teardown  Test Suite Teardown

*** Variables ***
@{USED_ROLES}   tender_owner  viewer  provider  provider1
${NUMBER_OF_AWARDS}  ${1}


*** Test Cases ***
##############################################################################################
#             FIND TENDER
##############################################################################################

Можливість знайти лот по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук лоту
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      find_tender
  Завантажити дані про тендер
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \   ${resp}=  Run As  ${username}  Пошук тендера по ідентифікатору   ${TENDER['TENDER_UAID']}


Можливість звірити кількість сформованих авардів лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Процес кваліфікації
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      number_of_awards
  [Setup]  Дочекатись закінчення періоду аукціону  ${viewer}  ${TENDER['TENDER_UAID']}
  Звірити кількість сформованих авардів лоту із ${NUMBER_OF_AWARDS} для користувача ${viewer}


Відображення статусу тендера в період кваліфікації
  [Tags]   ${USERS.users['${viewer}'].broker}: Процес кваліфікації
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      awarding
  Звірити статус тендера  ${viewer}  ${TENDER['TENDER_UAID']}  active.qualification

##############################################################################################
#             AWARDING
##############################################################################################

Відображення статусу 'очікується протокол' для першого кандидата
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення статусу аварду
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     first_award_verification_status
  [Setup]  Оновити LMD і дочекатись синхронізації  ${viewer}
  Звірити відображення поля awards[0].status тендера із pending.verification для користувача ${viewer}


Відображення статусу 'очікується кінець кваліфікації' для другого кандидата
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення статусу аварду
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     second_award_waiting_status
  [Setup]  Оновити LMD і дочекатись синхронізації  ${viewer}
  Звірити відображення поля awards[1].status тендера із pending.waiting для користувача ${viewer}


Неможливість змінити статус на 'очікується підписання договору' для першого кандидата
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Подання пропозиції
  ...     tender_owner
  ...     ${USERS.users['${tender_owner}'].broker}
  ...     change_first_award_payment_status
  Require Failure  ${tender_owner}  Підтвердити наявність протоколу аукціону  ${TENDER['TENDER_UAID']}  0


Можливість завантажити протокол аукціону в авард для першого кандидата
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...     tender_owner
  ...     ${USERS.users['${tender_owner}'].broker}
  ...     add_protocol_to_first_award
  [Teardown]  Оновити LMD і дочекатись синхронізації  ${tender_owner}
  Можливість завантажити протокол аукціону в авард 0 користувачем ${tender_owner}


Можливість підтвердити наявність протоколу аукціону для першого кандидата
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...     tender_owner
  ...     ${USERS.users['${tender_owner}'].broker}
  ...     approve_first_award_protocol
  [Teardown]  Оновити LMD і дочекатись синхронізації  ${tender_owner}
  Run As  ${tender_owner}  Підтвердити наявність протоколу аукціону  ${TENDER['TENDER_UAID']}  0


Відображення статусу 'очікується підписання договору' для першого кандидата
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення статусу аварду
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     first_award_payment_status
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Run Keyword And Ignore Error  Remove From Dictionary  ${USERS.users['${viewer}'].tender_data.data.awards[0]}  status
  Звірити відображення поля awards[0].status тендера із pending.payment для користувача ${viewer}


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


Можливість підтвердити оплату першого кандидата
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...     tender_owner
  ...     ${USERS.users['${tender_owner}'].broker}
  ...     confirm_first_award
  [Teardown]  Оновити LMD і дочекатись синхронізації  ${tender_owner}
  Run As  ${tender_owner}  Підтвердити постачальника  ${TENDER['TENDER_UAID']}  0


Відображення статусу 'оплачено, очікується підписання договору' для першого кандидата
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення статусу аварду
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     first_award_active_status
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Run Keyword And Ignore Error  Remove From Dictionary  ${USERS.users['${viewer}'].tender_data.data.awards[0]}  status
  Звірити відображення поля awards[0].status тендера із active для користувача ${viewer}


Можливість дискваліфікувати першого кандидата
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...     tender_owner
  ...     ${USERS.users['${tender_owner}'].broker}
  ...     disqualified_first_award
  [Teardown]  Оновити LMD і дочекатись синхронізації  ${tender_owner}
  ${description}=  create_fake_sentence
  Run As  ${tender_owner}  Дискваліфікувати постачальника  ${TENDER['TENDER_UAID']}  0  ${description}


Відображення статусу неуспішного лоту через відсутність завантаженого протоколу
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення статусу лоту
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      wait_for_verificationEndDate
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити cтатус неуспішного тендера  ${viewer}  ${TENDER['TENDER_UAID']}


Відображення статусу 'unsuccessful' для першого кандидата
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення статусу аварду
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     first_award_status_unsuccessful
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Run Keyword And Ignore Error  Remove From Dictionary  ${USERS.users['${viewer}'].tender_data.data.awards[0]}  status
  Звірити відображення поля awards[0].status тендера із unsuccessful для користувача ${viewer}


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


Відображення статусу 'очікується протокол' для другого кандидата
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     second_award_verification_status
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Run Keyword And Ignore Error  Remove From Dictionary  ${USERS.users['${viewer}'].tender_data.data.awards[1]}  status
  Звірити відображення поля awards[1].status тендера із pending.verification для користувача ${viewer}


Неможливість змінити статус на 'очікується підписання договору' для другого кандидата
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Подання пропозиції
  ...     tender_owner
  ...     ${USERS.users['${tender_owner}'].broker}
  ...     change_second_award_payment_status
  Require Failure  ${tender_owner}  Підтвердити наявність протоколу аукціону  ${TENDER['TENDER_UAID']}  1


Можливість завантажити протокол аукціону в авард для другого кандидата
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...     tender_owner
  ...     ${USERS.users['${tender_owner}'].broker}
  ...     add_protocol_to_second_award
  [Teardown]  Оновити LMD і дочекатись синхронізації  ${tender_owner}
  Можливість завантажити протокол аукціону в авард 1 користувачем ${tender_owner}


Можливість підтвердити наявність протоколу аукціону для другого кандидата
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...     tender_owner
  ...     ${USERS.users['${tender_owner}'].broker}
  ...     approve_second_award_protocol
  [Teardown]  Оновити LMD і дочекатись синхронізації  ${tender_owner}
  Run As  ${tender_owner}  Підтвердити наявність протоколу аукціону  ${TENDER['TENDER_UAID']}  1


Відображення статусу 'очікується підписання договору' для другого кандидата
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     change_second_award_payment_status
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Run Keyword And Ignore Error  Remove From Dictionary  ${USERS.users['${viewer}'].tender_data.data.awards[1]}  status
  Звірити відображення поля awards[1].status тендера із pending.payment для користувача ${viewer}


Можливість підтвердити оплату другого кандидата
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...     tender_owner
  ...     ${USERS.users['${tender_owner}'].broker}
  ...     confirm_second_award
  [Teardown]  Оновити LMD і дочекатись синхронізації  ${tender_owner}
  Run As  ${tender_owner}  Підтвердити постачальника  ${TENDER['TENDER_UAID']}  1


Відображення статусу 'оплачено, очікується підписання договору' для другого кандидата
  [Tags]  ${USERS.users['${viewer}'].broker}: Відображення оскарження
  ...     viewer
  ...     ${USERS.users['${viewer}'].broker}
  ...     second_award_active_status
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Run Keyword And Ignore Error  Remove From Dictionary  ${USERS.users['${viewer}'].tender_data.data.awards[1]}  status
  Звірити відображення поля awards[1].status тендера із active для користувача ${viewer}


Відображення статусу неуспішного лоту
  [Tags]   ${USERS.users['${viewer}'].broker}: Подання пропозиції
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      tender_status_unsuccessful
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити cтатус неуспішного тендера  ${viewer}  ${TENDER['TENDER_UAID']}