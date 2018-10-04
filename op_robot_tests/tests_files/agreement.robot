*** Settings ***
Resource        base_keywords.robot
Suite Setup     Test Suite Setup
Suite Teardown  Test Suite Teardown

*** Variables ***
@{USED_ROLES}   tender_owner  viewer

*** Test Cases ***
Можливість знайти закупівлю по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук тендера
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      find_tender
  ...      critical
  Завантажити дані про тендер
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \   Run As  ${username}  Пошук тендера по ідентифікатору  ${TENDER['TENDER_UAID']}


Відображення ідентифікатора угоди
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних тендера
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      tender_view
  ...      critical
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \   Отримати дані із поля agreements[0].agreementID тендера для користувача ${username}
  ${AGREEMENT_UAID}=  Get Variable Value  ${USERS.users['${tender_owner}'].tender_data.data.agreements[0].agreementID}
  Set Suite Variable  ${AGREEMENT_UAID}


Можливість знайти угоду по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук угоди
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      find_agreement
  ...      critical
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \   Run As  ${username}  Пошук угоди по ідентифікатору  ${AGREEMENT_UAID}


Відображення ідентифікатора контракту в угоді
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних угоди
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      agreement_view
  ...      critical
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \   Отримати дані із угоди  ${username}  ${AGREEMENT_UAID}  contracts[0].id


Відображення ідентифікатора предмету в угоді
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних угоди
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      agreement_view
  ...      critical
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \   Отримати дані із угоди  ${username}  ${AGREEMENT_UAID}  items[0].id


Можливість отримати доступ до угоди
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Отримання прав доступу до угоди
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      find_agreement
  ...      critical
  Run As  ${tender_owner}  Отримати доступ до угоди  ${AGREEMENT_UAID}


Можливість завантажити документацію в угоду
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Завантаження документації в угоду
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_agreement_doc
  ...      non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість завантажити документ для рамкової угоди користувачем ${tender_owner}


Можливість внести зміну до угоди taxRate
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Внесення зміни
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      submit_change
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${change_data}=  Підготувати дані про зміну до угоди  ${tender_owner}  taxRate
  Run As  ${tender_owner}  Внести зміну в угоду  ${AGREEMENT_UAID}  ${change_data}


Відображення типу зміни taxRate
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення зміни
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      change_view
  ...      non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити поле угоди із значенням
  ...      ${viewer}
  ...      ${AGREEMENT_UAID}
  ...      ${USERS.users['${tender_owner}'].change_data.data.rationaleType}
  ...      changes[0].rationaleType


Відображення обгрунтування зміни taxRate
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення зміни
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      change_view
  ...      non-critical
  Звірити поле угоди із значенням
  ...      ${viewer}
  ...      ${AGREEMENT_UAID}
  ...      ${USERS.users['${tender_owner}'].change_data.data.rationale}
  ...      changes[0].rationale


Можливість оновити властивості угоди для внесених змін taxRate
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Внесення зміни
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modification
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${change_data}=  Підготувати дані для оновлення властивості угоди  ${tender_owner}  addend  ${0.9}
  Run As  ${tender_owner}  Оновити властивості угоди  ${AGREEMENT_UAID}  ${change_data}


Відображення ідентифікатора предмету у властивостях taxRate
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення зміни
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      modification_view
  ...      non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити поле угоди із значенням
  ...      ${viewer}
  ...      ${AGREEMENT_UAID}
  ...      ${USERS.users['${tender_owner}'].modification_data.data.modifications[0]['itemId']}
  ...      changes[0].modifications[0].itemId


Відображення addend у властивостях taxRate
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення зміни
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      modification_view
  ...      non-critical
  Звірити поле угоди із значенням
  ...      ${viewer}
  ...      ${AGREEMENT_UAID}
  ...      ${USERS.users['${tender_owner}'].modification_data.data.modifications[0]['addend']}
  ...      changes[0].modifications[0].addend


Можливість завантажити документацію в зміну
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Завантаження документації в угоду
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      add_agreement_doc
  ...      non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість завантажити документ для зміни у рамковій угоді користувачем ${tender_owner}


Можливість застосувати зміну договору taxRate
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Внесення зміни
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      apply_change
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${dateSigned}=  create_fake_date
  Run As  ${tender_owner}  Застосувати зміну для угоди  ${AGREEMENT_UAID}  ${dateSigned}  active


Відображення статусу active зміни taxRate
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення зміни
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      change_view
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити поле угоди із значенням
  ...      ${viewer}
  ...      ${AGREEMENT_UAID}
  ...      active
  ...      changes[0].status


Можливість внести зміну до угоди itemPriceVariation
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Внесення зміни
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      submit_change
  ...      critical
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${change_data}=  Підготувати дані про зміну до угоди  ${tender_owner}  itemPriceVariation
  Run As  ${tender_owner}  Внести зміну в угоду  ${AGREEMENT_UAID}  ${change_data}


Відображення типу зміни itemPriceVariation
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення зміни
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      change_view
  ...      non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити поле угоди із значенням
  ...      ${viewer}
  ...      ${AGREEMENT_UAID}
  ...      ${USERS.users['${tender_owner}'].change_data.data.rationaleType}
  ...      changes[1].rationaleType


Відображення обгрунтування зміни itemPriceVariation
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення зміни
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      change_view
  ...      non-critical
  Звірити поле угоди із значенням
  ...      ${viewer}
  ...      ${AGREEMENT_UAID}
  ...      ${USERS.users['${tender_owner}'].change_data.data.rationale}
  ...      changes[1].rationale


Можливість оновити властивості угоди для внесених змін itemPriceVariation
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Внесення зміни
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modification
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${change_data}=  Підготувати дані для оновлення властивості угоди  ${tender_owner}  factor  ${1.1}
  Run As  ${tender_owner}  Оновити властивості угоди  ${AGREEMENT_UAID}  ${change_data}


Відображення ідентифікатора предмету у властивостях itemPriceVariation
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення зміни
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      modification_view
  ...      non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити поле угоди із значенням
  ...      ${viewer}
  ...      ${AGREEMENT_UAID}
  ...      ${USERS.users['${tender_owner}'].modification_data.data.modifications[0]['itemId']}
  ...      changes[1].modifications[0].itemId


Відображення factor у властивостях itemPriceVariation
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення зміни
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      modification_view
  ...      non-critical
  Звірити поле угоди із значенням
  ...      ${viewer}
  ...      ${AGREEMENT_UAID}
  ...      ${USERS.users['${tender_owner}'].modification_data.data.modifications[0]['factor']}
  ...      changes[1].modifications[0].factor


Можливість скасувати зміну договору itemPriceVariation
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Внесення зміни
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      apply_change
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${dateSigned}=  create_fake_date
  Run As  ${tender_owner}  Застосувати зміну для угоди  ${AGREEMENT_UAID}  ${dateSigned}  cancelled


Відображення статусу cancelled зміни itemPriceVariation
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення зміни
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      change_view
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити поле угоди із значенням
  ...      ${viewer}
  ...      ${AGREEMENT_UAID}
  ...      cancelled
  ...      changes[1].status


Можливість внести зміну до угоди thirdParty
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Внесення зміни
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      submit_change
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${change_data}=  Підготувати дані про зміну до угоди  ${tender_owner}  thirdParty
  Run As  ${tender_owner}  Внести зміну в угоду  ${AGREEMENT_UAID}  ${change_data}


Відображення типу зміни thirdParty
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення зміни
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      change_view
  ...      non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити поле угоди із значенням
  ...      ${viewer}
  ...      ${AGREEMENT_UAID}
  ...      ${USERS.users['${tender_owner}'].change_data.data.rationaleType}
  ...      changes[2].rationaleType


Відображення обгрунтування зміни thirdParty
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення зміни
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      change_view
  ...      non-critical
  Звірити поле угоди із значенням
  ...      ${viewer}
  ...      ${AGREEMENT_UAID}
  ...      ${USERS.users['${tender_owner}'].change_data.data.rationale}
  ...      changes[2].rationale


Можливість оновити властивості угоди для внесених змін thirdParty
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Внесення зміни
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modification
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Log  ${USERS.users['${tender_owner}'].agreement_data}
  ${change_data}=  Підготувати дані для оновлення властивості угоди  ${tender_owner}  factor  ${0.97}
  Run As  ${tender_owner}  Оновити властивості угоди  ${AGREEMENT_UAID}  ${change_data}


Відображення ідентифікатора предмету у властивостях thirdParty
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення зміни
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      modification_view
  ...      non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити поле угоди із значенням
  ...      ${viewer}
  ...      ${AGREEMENT_UAID}
  ...      ${USERS.users['${tender_owner}'].modification_data.data.modifications[0]['itemId']}
  ...      changes[2].modifications[0].itemId


Відображення factor у властивостях thirdParty
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення зміни
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      modification_view
  ...      non-critical
  Звірити поле угоди із значенням
  ...      ${viewer}
  ...      ${AGREEMENT_UAID}
  ...      ${USERS.users['${tender_owner}'].modification_data.data.modifications[0]['factor']}
  ...      changes[2].modifications[0].factor


Можливість застосувати зміну договору thirdParty
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Внесення зміни
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      apply_change
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${dateSigned}=  create_fake_date
  Run As  ${tender_owner}  Застосувати зміну для угоди  ${AGREEMENT_UAID}  ${dateSigned}  active


Відображення статусу active зміни thirdParty
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення зміни
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      change_view
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити поле угоди із значенням
  ...      ${viewer}
  ...      ${AGREEMENT_UAID}
  ...      active
  ...      changes[2].status


Можливість внести зміну до угоди partyWithdrawal
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Внесення зміни
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      submit_change
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${change_data}=  Підготувати дані про зміну до угоди  ${tender_owner}  partyWithdrawal
  Run As  ${tender_owner}  Внести зміну в угоду  ${AGREEMENT_UAID}  ${change_data}


Відображення типу зміни partyWithdrawal
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення зміни
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      change_view
  ...      non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити поле угоди із значенням
  ...      ${viewer}
  ...      ${AGREEMENT_UAID}
  ...      ${USERS.users['${tender_owner}'].change_data.data.rationaleType}
  ...      changes[3].rationaleType


Відображення обгрунтування зміни partyWithdrawal
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення зміни
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      change_view
  ...      non-critical
  Звірити поле угоди із значенням
  ...      ${viewer}
  ...      ${AGREEMENT_UAID}
  ...      ${USERS.users['${tender_owner}'].change_data.data.rationale}
  ...      changes[3].rationale


Можливість оновити властивості угоди для внесених змін partyWithdrawal
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Внесення зміни
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      modification
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${change_data}=  Підготувати дані для оновлення властивості угоди
  ...      ${tender_owner}
  ...      contractId
  ...      ${USERS.users['${tender_owner}'].agreement_data.data['contracts'][0]['id']}
  Run As  ${tender_owner}  Оновити властивості угоди  ${AGREEMENT_UAID}  ${change_data}


Відображення ідентифікатора предмету у властивостях partyWithdrawal
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення зміни
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      modification_view
  ...      non-critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити поле угоди із значенням
  ...      ${viewer}
  ...      ${AGREEMENT_UAID}
  ...      ${USERS.users['${tender_owner}'].modification_data.data.modifications[0]['itemId']}
  ...      changes[3].modifications[0].itemId


Відображення contractId у властивостях partyWithdrawal
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення зміни
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      modification_view
  ...      non-critical
  Звірити поле угоди із значенням
  ...      ${viewer}
  ...      ${AGREEMENT_UAID}
  ...      ${USERS.users['${tender_owner}'].modification_data.data.modifications[0]['contractId']}
  ...      changes[3].modifications[0].contractId


Можливість скасувати зміну договору partyWithdrawal
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Внесення зміни
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      apply_change
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${dateSigned}=  create_fake_date
  Run As  ${tender_owner}  Застосувати зміну для угоди  ${AGREEMENT_UAID}  ${dateSigned}  cancelled


Відображення статусу cancelled зміни partyWithdrawal
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення зміни
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      change_view
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Звірити поле угоди із значенням
  ...      ${viewer}
  ...      ${AGREEMENT_UAID}
  ...      cancelled
  ...      changes[3].status


Можливість завершити угоду
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Завершення угоди
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      agreement_termination
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Run As  ${tender_owner}  Завершити угоду  ${AGREEMENT_UAID}


Звірити статус завершеної угоди
  [Tags]   ${USERS.users['${viewer}'].broker}: Завершення угоди
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      agreement_termination
  ...      critical
  [Setup]  Дочекатись синхронізації з майданчиком  ${viewer}
  Remove From Dictionary  ${USERS.users['${viewer}'].agreement_data.data}  status
  Звірити поле угоди із значенням
  ...      ${viewer}
  ...      ${AGREEMENT_UAID}
  ...      terminated
  ...      status
