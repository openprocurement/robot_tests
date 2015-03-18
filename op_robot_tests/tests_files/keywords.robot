*** Variables ***
${tender_dump_id}    0

*** Keywords ***
TestCaseSetup
    Завантажуємо дані про корисувачів і площадки
    Підготовка початкових даних

Завантажуємо дані про корисувачів і площадки
  # Init Brokers
  ${file_path}=  Get Variable Value  ${BROKERS_FILE}  brokers.yaml
  ${BROKERS}=  load_initial_data_from  ${file_path}
  Set Global Variable  ${BROKERS}
  ${brokers_list}=    Get Dictionary Items    ${BROKERS}
  :FOR  ${Broker_Name}  ${Broker_Data}   IN  @{brokers_list}
  \  Завантажуємо бібліотеку з реалізацією ${Broker_Data.keywords_file} площадки
  # Init Users
  ${file_path}=  Get Variable Value  ${USERS_FILE}  users.yaml
  ${USERS}=  load_initial_data_from  ${file_path}
  Set Global Variable  ${USERS}
  ${users_list}=    Get Dictionary Items    ${USERS.users}
  :FOR  ${username}  ${user_data}   IN  @{users_list}
  \  Викликати для учасника   ${username}  Підготувати клієнт для користувача

Підготовка початкових даних
  @{QUESTIONS} =  Create list
  ${question}=  test question data
  Append to list   ${QUESTIONS}   ${question}
  Set Global Variable  ${QUESTIONS}
  @{ANSWERS} =  Create list
  ${answer}=  test_question_answer_data
  Append to list   ${ANSWERS}   ${answer}
  Set Global Variable  ${ANSWERS}
  ${INITIAL_TENDER_DATA}=  prepare_test_tender_data
  Set Global Variable  ${INITIAL_TENDER_DATA}

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