*** Setting ***
Resource  resource.robot
Library  op_robot_tests.tests_files.service_keywords
Library  String
LIbrary  Collections
LIbrary  Selenium2Library
Library  DateTime
Library  Selenium2Screenshots
Library  DebugLibrary
Library  op_robot_tests.tests_files.brokers.openprocurement_client_helper
*** Variables ***
${tender_dump_id}    0
${LOAD_BROKERS}    ['Quinta', 'E-tender']
${LOAD_USERS}      ['E-tender Viewer', 'Tender Viewer', 'Tender User', 'Tender Owner']

*** Keywords ***
TestCaseSetup
    Завантажуємо дані про корисувачів і площадки  ${LOAD_BROKERS}  ${LOAD_USERS}
    Підготовка початкових даних

Завантажуємо дані про корисувачів і площадки
  [Arguments]  ${active_brokers}  ${active_users}
  # Init Brokers
  log  ${active_brokers}
  log  ${active_users}

  ${file_path}=  Get Variable Value  ${BROKERS_FILE}  brokers.yaml
  ${BROKERS}=  load_initial_data_from  ${file_path}
  log  ${BROKERS}
  Set Global Variable  ${BROKERS}
  ${brokers_list}=    Get Dictionary Items    ${BROKERS}
  log  ${brokers_list}
  
  :FOR  ${Broker_Name}  ${Broker_Data}   IN  @{brokers_list}
  \  log  ${Broker_Name} 
  \  log  ${active_brokers}
  \  ${status}=  Run Keyword And Return Status   List Should Contain Value  ${active_brokers}   ${Broker_Name} 
  \  Run Keyword If   '${status}' == 'True'  Завантажуємо бібліотеку з реалізацією ${Broker_Data.keywords_file} площадки
  
  # Init Users
  ${file_path}=  Get Variable Value  ${USERS_FILE}  users.yaml
  ${USERS}=  load_initial_data_from  ${file_path}
  Set Global Variable  ${USERS}
  ${users_list}=    Get Dictionary Items    ${USERS.users}
  :FOR  ${username}  ${user_data}   IN  @{users_list}
  \  log  ${active_users} 
  \  log  ${username}
  \  ${status}=  Run Keyword And Return Status   List Should Contain Value  ${active_users}   ${username} 
  \  Run Keyword If   '${status}' == 'True'   Викликати для учасника   ${username}  Підготувати клієнт для користувача

Підготовка початкових даних
  @{QUESTIONS} =  Create list
  ${question}=  test question data
  Append to list   ${QUESTIONS}   ${question}
  Set Global Variable  ${QUESTIONS}
  @{ANSWERS} =  Create list
  ${answer}=  test_question_answer_data
  Append to list   ${ANSWERS}   ${answer}
  Set Global Variable  ${ANSWERS}
  
  @{COMPLAINTS} =  Create list
  ${complaint}=  test_complaint_data
  Append to list   ${COMPLAINTS}   ${complaint}
  Set Global Variable  ${COMPLAINTS}
  @{REPLIES} =  Create list
  ${reply}=  test_complaint_reply_data
  Append to list   ${REPLIES}   ${reply}
  Set Global Variable  ${REPLIES}
  
  ${INITIAL_TENDER_DATA}=  prepare_test_tender_data
  Set Global Variable  ${INITIAL_TENDER_DATA}
  Log  ${INITIAL_TENDER_DATA}
Завантажуємо бібліотеку з реалізацією ${keywords_file} площадки
  Import Resource  ${CURDIR}/brokers/${keywords_file}.robot


##################################################################################
Дочекатись синхронізації з майданчиком
  [Arguments]  ${username}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tenderId
  ...      ${ARGUMENTS[2]} ==  id

  ${now}=  Get Current Date
  ${delta}=  Subtract Date From Date  ${now}  ${LAST_MODIFICATION_DATE}
  ${wait_timout}=  Subtract Time From Time  ${BROKERS['${USERS.users['${username}'].broker}'].timout_on_wait}  ${delta}
  Run Keyword If   ${wait_timout}>0   Sleep  ${wait_timout}

отримати останні зміни в тендері
  ${TENDER_DATA}=   Викликати для учасника   ${USERS.tender_owner}   Пошук тендера по ідентифікатору   ${TENDER_DATA.data.tenderID}   ${TENDER_DATA.data.id}
  Set To Dictionary  ${TENDER_DATA}   access_token   ${access_token}
  Set Global Variable  ${TENDER_DATA}
  ${now}=  Get Current Date
  Log object data  ${TENDER_DATA}  tender_${tender_dump_id}
  ${tender_dump_id}=   Evaluate    ${tender_dump_id}+1
  Set Global Variable  ${tender_dump_id}

Звірити поле тендера
  [Arguments]  ${username}  ${field}
  ${field_response}=  Викликати для учасника    ${username}   отримати інформацію із тендера  ${field}
  ${field_value}=   Get_From_Object  ${TENDER_DATA.data}   ${field}
  Should Be Equal   ${field_value}   ${field_response}   Майданчик ${USERS.users['${username}'].broker}

Звірити дату  
  [Arguments]  ${username}  ${field}
  ${field_date}=  Викликати для учасника    ${username}   отримати інформацію із тендера  ${field}
  ${isodate}=   Get_From_Object  ${TENDER_DATA.data}   ${field}
  ${returned}=   compare_date    ${isodate}  ${field_date}
  Should Be True  '${returned}' == 'True'   
  
Звірити поля предметів закупівлі багатопредметного тендера ${field}
  Дочекатись синхронізації з майданчиком    ${viewer}
  @{items}=  Get_From_Object  ${TENDER_DATA.data}     items
  ${len_of_items}=   Get Length   ${items}
  :FOR   ${index}    IN RANGE   ${len_of_items}
    \    Log   ${index}
    \    Звірити поле тендера   ${viewer}  items[${index}].${field}

  
Викликати для учасника
  [Arguments]  ${username}  ${command}  @{arguments}
  ${status}  ${value}=  run_keyword_and_ignore_keyword_definations   ${BROKERS['${USERS.users['${username}'].broker}'].keywords_file}.${command}  ${username}  @{arguments}
  Run keyword if  '${status}' == 'FAIL'   Log   Учасник ${username} не зміг виконати "${command}"   WARN
  [return]   ${value}

  
Дочекатись дати
  [Arguments]  ${date}
  ${wait_timout}=  wait_to_date  ${date}
  Run Keyword If   ${wait_timout}>0   Sleep  ${wait_timout}

Дочекатись дати початоку прийому пропозицій
  Дочекатись дати  ${TENDER_DATA.data.tenderPeriod.startDate}
  
Дочекатись дати закінчення прийому пропозицій
  Дочекатись дати  ${TENDER_DATA.data.tenderPeriod.endDate}
  
Дочекатись дати початоку аукціону
  Дочекатись дати  ${TENDER_DATA.data.auctionPeriod.startDate}

Дочекатись дати закінчення аукціону
  Дочекатись дати  ${TENDER_DATA.data.auctionPeriod.endDate}  