*** Settings ***
Library            op_robot_tests.tests_files.service_keywords
Library            Collections
Resource           keywords.robot
Resource           resource.robot
Resource           base_keywords.robot


*** Keywords ***

Неможливість редагувати однопредметний тендер менше ніж за 7 днів до завершення періоду подання пропозицій
  ${no_edit_time}=  add_minutes_to_date  ${USERS.users['${tender_owner}'].tender_data.data.tenderPeriod.endDate}  -6
  Дочекатись дати  ${no_edit_time}
  Require Failure  ${tender_owner}  Внести зміни в тендер  ${TENDER['TENDER_UAID']}  description  description


Можливість продовжити період подання пропозиції на ${number_of_days} днів
  ${period_intervals}=  compute_intrs  ${BROKERS}  ${used_brokers}
  ${number_of_minutes}=  get_number_of_minutes  ${number_of_days}  ${period_intervals.${MODE}.accelerator}
  ${endDate}=  add_minutes_to_date  ${USERS.users['${tender_owner}'].tender_data.data.tenderPeriod.endDate}  ${number_of_minutes}
  Можливість змінити поле tenderPeriod.endDate тендера на ${endDate}
  Remove From Dictionary  ${USERS.users['${tender_owner}'].tender_data.data.tenderPeriod}  endDate

##############################################################################################
#             BIDDING
##############################################################################################

Відображення зміни статусу пропозицій на ${status} для учасника ${username}
  Дочекатись синхронізації з майданчиком  ${username}
  Run As  ${username}  Пошук тендера по ідентифікатору  ${TENDER['TENDER_UAID']}
  ${bid_status}=  Run As  ${username}  Отримати інформацію із пропозиції  ${TENDER['TENDER_UAID']}  status
  Should Be Equal  ${bid_status}  ${status}


Можливість підтвердити цінову пропозицію учасником ${username}
  ${status}=  Run Keyword IF  '${MODE}'=='esco'  Set Variable  pending
  Run As  ${username}  Змінити цінову пропозицію  ${TENDER['TENDER_UAID']}  status  ${status}

##############################################################################################
#             ESCO  Bid documentation
##############################################################################################

Можливість змінити документацію цінової пропозиції з публічної на приватну учасником ${username}
  ${confidentialityRationale}=  create_fake_sentence
  ${privat_doc}=  create_data_dict  data.confidentialityRationale  ${confidentialityRationale}
  Set To Dictionary  ${privat_doc.data}  confidentiality=buyerOnly
  Run As  ${username}  Змінити документацію в ставці  ${TENDER['TENDER_UAID']}  ${privat_doc}  ${USERS.users['${username}']['bid_document']['doc_id']}


Можливість завантажити ${doc_type} документ до пропозиції учасником ${username}
  ${file_path}  ${file_name}  ${file_content}=  create_fake_doc
  ${bid_doc_upload}=  Run As  ${username}  Завантажити документ в ставку  ${file_path}  ${TENDER['TENDER_UAID']}  ${doc_type}
  Set To Dictionary  ${USERS.users['${username}'].bidresponses}  bid_doc_upload=${bid_doc_upload}
  Remove File  ${file_path}

##############################################################################################
#             ESCO  Pre-Qualification
##############################################################################################

Можливість завантажити документ у кваліфікацію ${bid_index} пропозиції
  ${file_path}  ${file_name}  ${file_content}=  create_fake_doc
  Run As  ${tender_owner}  Завантажити документ у кваліфікацію  ${file_path}  ${TENDER['TENDER_UAID']}  ${bid_index}
  Remove File  ${file_path}


Можливість відхилити ${bid_index} пропозиції кваліфікації
  Run As  ${tender_owner}  Відхилити кваліфікацію  ${TENDER['TENDER_UAID']}  ${bid_index}


Можливість скасувати рішення кваліфікації для ${bid_index} пропопозиції
  Run As  ${tender_owner}  Скасувати кваліфікацію  ${TENDER['TENDER_UAID']}  ${bid_index}


Можливість підтвердити ${bid_index} пропозицію кваліфікації
  Run As  ${tender_owner}  Підтвердити кваліфікацію  ${TENDER['TENDER_UAID']}  ${bid_index}


Можливість затвердити остаточне рішення кваліфікації
  Run As  ${tender_owner}  Затвердити остаточне рішення кваліфікації  ${TENDER['TENDER_UAID']}


Можливість перевести тендер на статус очікування обробки мостом
  Run As  ${tender_owner}  Перевести тендер на статус очікування обробки мостом  ${TENDER['TENDER_UAID']}


Активувати тендер другого етапу
  Run As  ${tender_owner}  активувати другий етап  ${TENDER['TENDER_UAID']}
