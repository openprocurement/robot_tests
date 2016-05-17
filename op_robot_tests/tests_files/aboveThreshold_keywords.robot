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


Можливість продовжити період подання пропозиції на 7 днів
  ${endDate}=  add_minutes_to_date  ${USERS.users['${tender_owner}'].tender_data.data.tenderPeriod.endDate}  7
  Можливість змінити поле tenderPeriod.endDate тендера на ${endDate}

##############################################################################################
#             BIDDING
##############################################################################################

Відображення зміни статусу пропозицій на ${status} для учасника ${username}
  Дочекатись синхронізації з майданчиком  ${username}
  Run As  ${username}  Пошук тендера по ідентифікатору  ${TENDER['TENDER_UAID']}
  ${bid_status}=  Run As  ${username}  Отримати інформацію із пропозиції  ${TENDER['TENDER_UAID']}  status
  Should Be Equal  ${bid_status}  ${status}


Можливість оновити статус цінової пропозиції учасником ${username}
  ${status}=  Run Keyword IF  '${mode}'=='openeu'  Set Variable  pending
  ...                     ELSE IF  '${mode}'=='openua'  Set Variable  active
  ${activestatusresp}=  Run As  ${username}  Змінити цінову пропозицію  ${TENDER['TENDER_UAID']}  status  ${status}
  Set To Dictionary  ${USERS.users['${username}'].bidresponses}  activestatusresp=${activestatusresp}
  log  ${activestatusresp}

##############################################################################################
#             OPENEU  Bid documentation
##############################################################################################

Можливість змінити документацію цінової пропозиції з публічної на приватну учасником ${username}
  ${confidentialityRationale}=  create_fake_sentence
  ${privat_doc}=  create_data_dict  data.confidentialityRationale  ${confidentialityRationale}
  Set To Dictionary  ${privat_doc.data}  confidentiality=buyerOnly
  ${docid}=  Get Variable Value  ${USERS.users['${username}'].bidresponses['bid_doc_upload']['upload_response'].data.id}
  ${bid_doc_modified}=  Run As  ${username}  Змінити документацію в ставці  ${privat_doc}  ${docid}
  Set To Dictionary  ${USERS.users['${username}'].bidresponses}  bid_doc_modified=${bid_doc_modified}


Можливість завантажити ${doc_type} документ до пропозиції учасником ${username}
  ${filepath}=  create_fake_doc
  ${bid_doc_upload}=  Run As  ${username}  Завантажити документ в ставку  ${filepath}  ${TENDER['TENDER_UAID']}  ${doc_type}
  Set To Dictionary  ${USERS.users['${username}'].bidresponses}  bid_doc_upload=${bid_doc_upload}

##############################################################################################
#             OPENEU  Pre-Qualification
##############################################################################################

Можливість завантажити документ у кваліфікацію ${bid_index} пропозиції
  ${filepath}=  create_fake_doc
  Run As  ${tender_owner}  Завантажити документ у кваліфікацію  ${filepath}  ${TENDER['TENDER_UAID']}  ${bid_index}


Можливість відхилити ${bid_index} пропозиції кваліфікації
  Run As  ${tender_owner}  Відхилити кваліфікацію  ${TENDER['TENDER_UAID']}  ${bid_index}


Можливість скасувати рішення кваліфікації для ${bid_index} пропопозиції
  Run As  ${tender_owner}  Скасувати кваліфікацію  ${TENDER['TENDER_UAID']}  ${bid_index}


Можливість підтвердити ${bid_index} пропозицію кваліфікації
  Run As  ${tender_owner}  Підтвердити кваліфікацію  ${TENDER['TENDER_UAID']}  ${bid_index}


Можливість затвердити остаточне рішення кваліфікації
  Run As  ${tender_owner}  Затвердити остаточне рішення кваліфікації  ${TENDER['TENDER_UAID']}
