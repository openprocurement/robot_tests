*** Settings ***
Resource        base_keywords.robot
Suite Setup     Test Suite Setup
Suite Teardown  Test Suite Teardown

*** Variables ***
@{USED_ROLES}   tender_owner  viewer  provider  provider1

${award_index}      ${0}


*** Test Cases ***
##############################################################################################
#             FIND TENDER
##############################################################################################

Можливість знайти лот по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук лоту
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      find_tender  level1
  Завантажити дані про тендер
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \   ${resp}=  Run As  ${username}  Пошук тендера по ідентифікатору   ${TENDER['TENDER_UAID']}


Можливість дочекатись дати початку кваліфікації
  [Tags]   ${USERS.users['${viewer}'].broker}: Процес кваліфікації
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      qualification  level1
  Дочекатись дати початку періоду кваліфікації  ${viewer}  ${TENDER['TENDER_UAID']}

##############################################################################################
#             QUALIFICATION
##############################################################################################

Можливість завантажити документ рішення кваліфікаційної комісії для підтвердження учасника
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  qualification_add_doc_to_first_award  level3
  ${file_path}  ${file_name}  ${file_content}=   create_fake_doc
  Run As  ${tender_owner}  Завантажити документ рішення кваліфікаційної комісії  ${file_path}  ${TENDER['TENDER_UAID']}  0
  Remove File  ${file_path}


Можливість завантажити протокол аукціону в пропозицію кандидата
  [Tags]   ${USERS.users['${provider}'].broker}: Процес кваліфікації
  ...  provider
  ...  ${USERS.users['${provider}'].broker}
  ...  qualification_add_auction_protocol_to_bid  level1
  [Teardown]  Оновити LMD і дочекатись синхронізації  ${provider}
  Можливість завантажити протокол аукціону в пропозицію 0 користувачем ${provider}


Можливість перевірити протокол аукціону кандидата
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  qualification_approve_doc_to_first_award  level2
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  Звірити значення поля серед усіх документів ставки  ${tender_owner}  ${TENDER['TENDER_UAID']}  documentType  auctionProtocol  0


Можливість підтвердити учасника
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  qualification_approve_first_award  level1
  [Teardown]  Оновити LMD і дочекатись синхронізації  ${tender_owner}
  Run As  ${tender_owner}  Підтвердити постачальника  ${TENDER['TENDER_UAID']}  0


Можливість скасувати рішення кваліфікації
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  qualification_cancel_first_award_qualification  level1
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Run As  ${tender_owner}  Скасування рішення кваліфікаційної комісії  ${TENDER['TENDER_UAID']}  0


Можливість дискваліфікувати учасника
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  qualification_cancel_first_award_qualification  level1
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  ${file_path}  ${file_name}  ${file_content}=  create_fake_doc
  ${description}=  create_fake_sentence
  Run As  ${tender_owner}  Завантажити документ рішення кваліфікаційної комісії  ${file_path}  ${TENDER['TENDER_UAID']}  0
  Run As  ${tender_owner}  Дискваліфікувати постачальника  ${TENDER['TENDER_UAID']}  1  ${description}
  Remove File  ${file_path}


Можливість завантажити документ рішення кваліфікаційної комісії для підтвердження нового учасника
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  qualification_add_doc_to_second_award  level3
  ${file_path}  ${file_name}  ${file_content}=  create_fake_doc
  Run As  ${tender_owner}  Завантажити документ рішення кваліфікаційної комісії  ${file_path}  ${TENDER['TENDER_UAID']}  1
  Remove File  ${file_path}


Можливість завантажити протокол аукціону в пропозицію нового кандидата
  [Tags]   ${USERS.users['${provider1}'].broker}: Процес кваліфікації
  ...  provider
  ...  ${USERS.users['${provider1}'].broker}
  ...  qualification_add_auction_protocol_to_second_bid  level1
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider1}
  [Teardown]  Оновити LMD і дочекатись синхронізації  ${provider1}
  Можливість завантажити протокол аукціону в пропозицію -1 користувачем ${provider1}


Можливість перевірити протокол аукціону нового кандидата
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  qualification_approve_doc_to_second_award  level2
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  Звірити значення поля серед усіх документів ставки  ${tender_owner}  ${TENDER['TENDER_UAID']}  documentType  auctionProtocol  -1


Можливість підтвердити нового учасника
  [Tags]  ${USERS.users['${tender_owner}'].broker}: Процес кваліфікації
  ...  tender_owner
  ...  ${USERS.users['${tender_owner}'].broker}
  ...  qualification_approve_second_award  level2
  [Teardown]  Оновити LMD і дочекатись синхронізації  ${tender_owner}
  Run As  ${tender_owner}  Підтвердити постачальника  ${TENDER['TENDER_UAID']}  -1
