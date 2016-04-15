*** Settings ***
Library  op_robot_tests.tests_files.service_keywords
Library  String
Library  Collections
Library  Selenium2Library
Library  OperatingSystem
Library  DateTime
Library  DebugLibrary


Documentation
...  This resource file contains keywords that are used directly by
...  test suites or by brokers' keyword libraries (also known as drivers).


*** Keywords ***
Test Suite Setup
  Set Suite Variable  ${WARN_RUN_AS}  ${False}
  Set Selenium Implicit Wait  5 s
  Set Selenium Timeout  10 s
  Залогувати git-дані
  Порівняти системний і серверний час
  Завантажуємо дані про користувачів і майданчики


Test Suite Teardown
  Close all browsers
  Run Keyword And Ignore Error  Створити артефакт


Set Suite Variable With Default Value
  [Arguments]  ${suite_var}  ${def_value}
  ${tmp}=  Get Variable Value  ${${suite_var}}  ${def_value}
  Set Suite Variable  ${${suite_var}}  ${tmp}


Порівняти системний і серверний час
  ${server_time}=  request  ${api_host_url}  HEAD
  ${local_time}=  Get current TZdate
  Log  ${server_time.headers['date']}
  Log  ${local_time}
  ${status}=  compare_date  ${server_time.headers['date']}  ${local_time}  5
  Run keyword if  ${status} == ${False}
  ...      Log  Час на сервері відрізняється від локального більше ніж на 5 секунд  WARN


Залогувати git-дані
  ${commit}=  Run  git log --graph --pretty --abbrev-commit --date=relative -n 30
  ${repo}=    Run  git remote -v
  ${branch}=  Run  git branch -vva
  Log many  ${commit}  ${repo}  ${branch}


Завантажуємо дані про користувачів і майданчики
  Log  ${broker}
  Log  ${role}
  # Suite variable; should be present in every test suite
  # in `*** Variables ***` section
  Log Many  @{used_roles}

  # Load brokers data
  ${file_path}=  Get Variable Value  ${BROKERS_FILE}  brokers.yaml
  ${BROKERS}=  load_data_from  ${file_path}  mode=brokers
  Log  ${BROKERS}
  Set Suite Variable  ${BROKERS}
  # List of currently used brokers
  ${used_brokers}=  Create List

  # Load users data
  ${file_path}=  Get Variable Value  ${USERS_FILE}  users.yaml
  ${USERS}=  load_data_from  ${file_path}
  Log  ${USERS.users}
  Set Suite Variable  ${USERS}
  # List of currently used users
  ${used_users}=  Create List

  # Handle `-v role:something`
  Run Keyword Unless  '${role}' in @{used_roles}
  ...      Log
  ...      Role ${role} is not used in this test suite.
  ...      WARN
  Set Suite Variable With Default Value
  ...      ${role}
  ...      ${BROKERS['${broker}'].roles.${role}}

  # Set default value for each role if it is not set yet;
  # fill `used_users`;
  # fill `used_brokers`.
  #
  # Don't even ask how this works!
  :FOR  ${tmp_role}  IN  @{used_roles}
  \  Set Suite Variable With Default Value
  \  ...      ${tmp_role}
  \  ...      ${BROKERS['Quinta'].roles.${tmp_role}}
  \  Append To List  ${used_users}  ${${tmp_role}}
  \  Append To List  ${used_brokers}  ${USERS.users.${${tmp_role}}.broker}
  # Since `@{used_roles}` is already a suite variable,
  # let's make `@{used_brokers}` alike.
  ${used_brokers}=  Remove Duplicates  ${used_brokers}
  Set Suite Variable  ${used_brokers}
  # We need to create two lists since Robot Framework doesn't support
  # dicts in `:FOR` loops.
  Log Many  @{used_users}
  Log Many  @{used_brokers}

  # A list of all users in users file
  ${known_users}=  Get Dictionary Keys  ${USERS.users}

  # Check whether users file contains an entry for each
  # selected user before preparing any clients
  :FOR  ${username}  IN  @{used_users}
  \  List Should Contain Value
  \  ...      ${known_users}
  \  ...      ${username}
  \  ...      msg=User ${username} not found in users file!

  # Prepare a client for each user
  :FOR  ${username}  IN  @{used_users}
  \  ${munch_dict}=  munch_dict  data=${True}
  \  ${keywords_file}=  Get Broker Property  ${USERS.users.${username}.broker}  keywords_file
  \  Завантажуємо бібліотеку з реалізацією для майданчика ${keywords_file}
  \  Run As  ${username}  Підготувати клієнт для користувача
  \  ${LAST_REFRESH_DATE}=  Get Current TZdate
  \  Set To Dictionary  ${USERS}  ${username}=${USERS.users.${username}}
  \  Set To Dictionary  ${USERS.${username}}  tender_data=${munch_dict}
  \  Set To Dictionary  ${USERS.${username}}  LAST_REFRESH_DATE  ${LAST_REFRESH_DATE}

  # Drop all unused users
  Keep In Dictionary  ${USERS.users}  @{used_users}
  Log Many  @{USERS}


Get Broker Property
  [Arguments]  ${broker_name}  ${property}
  [Documentation]
  ...      This keyword returns a property of specified broker
  ...      if that property exists, otherwise, it returns a
  ...      default value.
  Run Keyword If  '${broker_name}'=='${None}'  Fail  \${broker_name} is NoneType
  Should Contain  ${BROKERS['${broker_name}']}  ${property}
  Return From Keyword  ${BROKERS['${broker_name}'].${property}}


Get Broker Property By Username
  [Documentation]
  ...      This keyword gets the corresponding broker name
  ...      for a specified username and then calls
  ...      "Get Broker Property"
  [Arguments]  ${username}  ${property}
  ${broker_name}=  Get Variable Value  ${USERS.users['${username}'].broker}
  Run Keyword And Return  Get Broker Property  ${broker_name}  ${property}


Створити артефакт
  ${artifact}=  Create Dictionary
  ...      api_version=${api_version}
  ...      tender_uaid=${TENDER['TENDER_UAID']}
  ...      last_modification_date=${TENDER['LAST_MODIFICATION_DATE']}
  ...      tender_owner=${USERS.users['${tender_owner}'].broker}
  ...      mode=${mode}
  Run Keyword If  '${USERS.users['${tender_owner}'].broker}' == 'Quinta'
  ...      Run Keyword And Ignore Error
  ...      Set To Dictionary  ${artifact}
  ...          access_token=${USERS.users['${tender_owner}'].access_token}
  ...          tender_id=${USERS.users['${tender_owner}'].tender_data.data.id}
  ${status}  ${lots_ids}=  Run Keyword And Ignore Error  Отримати ідентифікатори об’єктів  ${viewer}  lots
  Run Keyword If  ${status}'=='PASS'
  ...      Set To Dictionary   ${artifact}   lots=${lots_ids}
  Log   ${artifact}
  log_object_data  ${artifact}  artifact  update=${True}


Завантажити дані про тендер
  ${file_path}=  Get Variable Value  ${ARTIFACT_FILE}  artifact.yaml
  ${ARTIFACT}=  load_data_from  ${file_path}
  Run Keyword If  '${USERS.users['${tender_owner}'].broker}' == 'Quinta'
  ...      Set To Dictionary  ${USERS.users['${tender_owner}']}  access_token=${ARTIFACT.access_token}
  ${TENDER}=  Create Dictionary
  Set To Dictionary  ${TENDER}  TENDER_UAID=${ARTIFACT.tender_uaid}
  Set To Dictionary  ${TENDER}  LAST_MODIFICATION_DATE=${ARTIFACT.last_modification_date}
  Set Global Variable  ${TENDER}
  log_object_data  ${ARTIFACT}  artifact


Підготовка даних для створення тендера
  ${period_intervals}=  compute_intrs  ${BROKERS}  ${used_brokers}
  ${tender_data}=  prepare_test_tender_data  ${period_intervals}  ${mode}
  ${TENDER}=  Create Dictionary
  Set Global Variable  ${TENDER}
  Log  ${TENDER}
  Log  ${tender_data}
  [return]  ${tender_data}


Підготовка даних для створення предмету закупівлі
  ${item}=  test_item_data
  [Return]  ${item}


Підготовка даних для створення лоту
  ${lot}=  test_lot_data
  ${reply}=  Create Dictionary  data=${lot}
  [Return]  ${reply}


Підготовка даних для подання вимоги
  ${claim}=  test_claim_data
  [Return]  ${claim}


Підготовка даних для подання скарги
  [Arguments]  ${lot}=${False}
  ${complaint}=  test_complaint_data  ${lot}
  [Return]  ${complaint}


Підготовка даних для відповіді на скаргу
  ${reply}=  test_complaint_reply_data
  [Return]  ${reply}


Підготовка даних для запитання
  ${question}=  test_question_data
  [Return]  ${question}


Підготовка даних для відповіді на запитання
  ${answer}=  test_question_answer_data
  [Return]  ${answer}


Підготувати дані для подання пропозиції
  ${supplier_data}=  test_bid_data  ${mode}
  [Return]  ${supplier_data}


Підготувати дані про постачальника
  [Arguments]  ${username}
  ${supplier_data}=  test_supplier_data
  Set To Dictionary  ${USERS.users['${username}']}  supplier_data=${supplier_data}
  Log  ${supplier_data}
  [Return]  ${supplier_data}


Підготувати дані про скасування
  [Arguments]  ${username}
  ${cancellation_reason}=  create_fake_sentence
  ${document}=  create_fake_doc
  ${new_description}=  create_fake_sentence
  ${cancellation_data}=  Create Dictionary  cancellation_reason=${cancellation_reason}  document=${document}  description=${new_description}
  Set To Dictionary  ${USERS.users['${username}']}  cancellation_data=${cancellation_data}
  [Return]  ${cancellation_data}


Адаптувати дані для оголошення тендера
  [Arguments]  ${username}  ${tender_data}
  # munchify is used to make deep copy of ${tender_data}
  ${tender_data_copy}=  munchify  ${tender_data}
  ${status}  ${adapted_data}=  Run Keyword And Ignore Error  Викликати для учасника  ${username}  Підготувати дані для оголошення тендера  ${tender_data_copy}
  ${adapted_data}=  Set variable if  '${status}' == 'FAIL'  ${tender_data_copy}  ${adapted_data}
  # munchify is used to make nice log output
  ${adapted_data}=  munchify  ${adapted_data}
  Log  ${tender_data}
  Log  ${adapted_data}
  ${status}=  Run keyword and return status  Dictionaries Should Be Equal  ${adapted_data.data}  ${tender_data.data}
  Run keyword if  ${status} == ${False}  Log  Initial tender data was changed  WARN
  [Return]  ${adapted_data}


Завантажуємо бібліотеку з реалізацією для майданчика ${keywords_file}
  [Documentation]
  ...      Load broker's driver (keyword library).
  ...
  ...      `Import Resource` is called twice:
  ...
  ...      1) It tries to read from  ``brokers/`` directory
  ...      (located next to ``keywords.robot``).
  ...      This is an old feature which will be removed in the future.
  ...
  ...      2) It looks for a given filename in ``sys.path``
  ...      (``PYTHONPATH`` environment variable).
  ...
  ...      This keyword will fail if ``keywords_file`` was found
  ...      in both locations.
  ${bundled_st}=  Run Keyword And Return Status  Import Resource  ${CURDIR}${/}brokers${/}${keywords_file}.robot
  ${external_st}=  Run Keyword And Return Status  Import Resource  ${keywords_file}.robot
  Run Keyword If  ${bundled_st} == ${external_st} == ${False}  Fail  Resource file ${keywords_file}.robot not found
  Run Keyword If  ${bundled_st} == ${external_st} == ${True}  Fail  Resource file ${keywords_file}.robot found in both brokers${/} and src${/}


Дочекатись синхронізації з майданчиком
  [Arguments]  ${username}
  [Documentation]
  ...      Synchronise with ``username`` and update cache
  ...      First section
  ...      Get `timeout_on_wait` for ``username``
  ...      Add `timeout_on_wait` to `last_modification_date` in order to have
  ...      correct time of data modification in CDB(every broker has different
  ...      data synchronisation time with CDB).
  ...      Find diff between `last_mofidication_date_corrected`
  ...      and `now`. If that value is positive, sleep for `sleep` seconds,
  ...      else go to next section.
  ...      Thus, when this keyword is executed several times in a row,
  ...      it will wait for as long as really needed.
  ...
  ...      Example:
  ...
  ...      The procurement is modified.
  ...      In 5 seconds, this keyword is called for `viewer`.
  ...      Immediately, this keyword is called for `provider`.
  ...      Timeout for `viewer` is 60.
  ...      Timeout for `provider` is 300.
  ...      First call (for `viewer`) will trigger `Sleep 55`.
  ...      Second call (for `provider`) will trigger `Sleep 235`.
  ...      As a result, the delay will end in 300 seconds
  ...      since last modification date.
  ...
  ...      Another example (a variation of previous one):
  ...
  ...      Timeout for `viewer` is 120.
  ...      Timeout for `provider` is 30.
  ...      First call will trigger `Sleep 115`.
  ...      Second call will trigger `Sleep 0`,
  ...      since we have already slept for 120 seconds
  ...      and there is no need to sleep anymore.
  ...
  ...      Second section
  ...      Find how much time passed from ``username``'s `last_refresh_date`
  ...      to `last_modification_date_corrected`. If that value is positive, then
  ...      cahce for ``username`` is not up-to-date. So, it will be refreshed and
  ...      `last_refresh_date` will be updated.
  ...      Else do nothing.
  ${timeout_on_wait}=  Get Broker Property By Username  ${username}  timeout_on_wait
  ${last_modification_date_corrected}=  Add Time To Date
  ...      ${TENDER['LAST_MODIFICATION_DATE']}
  ...      ${timeout_on_wait} s
  ${now}=  Get Current TZdate
  ${sleep}=  Subtract Date From Date
  ...      ${last_modification_date_corrected}
  ...      ${now}
  Run Keyword If  ${sleep} > 0  Sleep  ${sleep}


  ${time_diff}=  Subtract Date From Date
  ...      ${last_modification_date_corrected}
  ...      ${USERS.users['${username}']['LAST_REFRESH_DATE']}
  ${LAST_REFRESH_DATE}=  Get Current TZdate
  Run Keyword If  ${time_diff} > 0  Run keywords
  ...      Викликати для учасника  ${username}  Оновити сторінку з тендером  ${TENDER['TENDER_UAID']}
  ...      AND
  ...      Set To Dictionary  ${USERS.users['${username}']}  LAST_REFRESH_DATE=${LAST_REFRESH_DATE}


Звірити поле тендера
  [Arguments]  ${username}  ${tender_data}  ${field}
  ${left}=  Get_From_Object  ${tender_data.data}  ${field}
  Звірити поле тендера із значенням  ${username}  ${left}  ${field}


Звірити поле тендера із значенням
  [Arguments]  ${username}  ${left}  ${field}  ${object_id}=${None}
  ${right}=  Отримати дані із тендера  ${username}  ${field}  ${object_id}
  Порівняти об'єкти  ${left}  ${right}


Порівняти об'єкти
  [Arguments]  ${left}  ${right}
  Log  ${left}
  Log  ${right}
  Should Not Be Equal  ${left}  ${None}
  Should Not Be Equal  ${right}  ${None}
  Should Be Equal  ${left}  ${right}  msg=Objects are not equal


Звірити дату тендера
  [Arguments]  ${username}  ${tender_data}  ${field}
  ${left}=  Get_From_Object  ${tender_data.data}  ${field}
  Звірити дату тендера із значенням  ${username}  ${left}  ${field}


Звірити дату тендера із значенням
  [Arguments]  ${username}  ${left}  ${field}  ${object_id}=${None}
  ${right}=  Отримати дані із тендера  ${username}  ${field}  ${object_id}
  Порівняти дати  ${left}  ${right}


Порівняти дати
  [Documentation]
  ...      Compare dates with specified ``accuracy`` (in seconds).
  ...      Default is `60`.
  ...
  ...      The keyword will fail if the difference between
  ...      ``left`` and ``right`` dates is more than ``accuracy``,
  ...      otherwise it will pass.
  [Arguments]  ${left}  ${right}  ${accuracy}=60
  Log  ${left}
  Log  ${right}
  Should Not Be Equal  ${left}  ${None}
  Should Not Be Equal  ${right}  ${None}
  ${status}=  compare_date  ${left}  ${right}  ${accuracy}
  Should Be True  ${status}  msg=Dates are not equal: ${left} != ${right}


Звірити поля предметів закупівлі багатопредметного тендера
  [Arguments]  ${username}  ${tender_data}  ${field}
  @{items}=  Get_From_Object  ${tender_data.data}  items
  ${len_of_items}=  Get Length  ${items}
  :FOR  ${index}  IN RANGE  ${len_of_items}
  \  Log  ${index}
  \  Звірити поле тендера  ${viewer}  ${tender_data}  items[${index}].${field}


Звірити дату предметів закупівлі багатопредметного тендера
  [Arguments]  ${username}  ${tender_data}  ${field}
  @{items}=  Get_From_Object  ${tender_data.data}  items
  ${len_of_items}=  Get Length  ${items}
  :FOR  ${index}  IN RANGE  ${len_of_items}
  \  Log  ${index}
  \  Звірити дату тендера  ${viewer}  ${tender_data}  items[${index}].${field}


Отримати дані із тендера
  [Arguments]  ${username}  ${field_name}  ${object_id}=${None}
  Log  ${username}
  Log  ${field_name}
  ${field}=  Run Keyword If  '${object_id}'=='${None}'  Set Variable  ${field_name}
  ...             ELSE  Отримати шлях до поля об’єкта  ${username}  ${field_name}  ${object_id}
  ${status}  ${field_value}=  Run keyword and ignore error
  ...      Get from object
  ...      ${USERS.users['${username}'].tender_data.data}
  ...      ${field}
  # If field in cache, return its value
  Run Keyword if  '${status}' == 'PASS'  Return from keyword   ${field_value}
  # Else call broker to find field
  ${field_value}=  Run Keyword IF  '${object_id}'=='${None}'  Run As  ${username}  Отримати інформацію із тендера  ${field}
  ...                          ELSE  Отримати дані із об’єкта тендера  ${username}  ${object_id}  ${field_name}
  # And caching its value before return
  Set_To_Object  ${USERS.users['${username}'].tender_data.data}  ${field}  ${field_value}
  [return]  ${field_value}


Отримати шлях до поля об’єкта
  [Arguments]  ${username}  ${field_name}  ${object_id}
  ${object_type}=  get_object_type_by_id  ${object_id}
  ${objects}=  Get Variable Value  ${USERS.users['${username}'].tender_data.data['${object_type}']}  ${empty}
  ${object_index}=  get_object_index_by_id  ${objects}  ${object_id}
  [return]  ${object_type}[${object_index}].${field_name}


Отримати дані із об’єкта тендера
  [Arguments]  ${username}  ${object_id}  ${field_name}
  ${object_type}=   get_object_type_by_id  ${object_id}
  ${status}  ${value}=  Run Keyword If  '${object_type}'=='question'
  ...                     Run Keyword And Ignore Error  Run As  ${username}  Отримати інформацію із запитання  ${object_id}  ${field_name}
  ...                   ELSE IF  '${object_type}'=='lots'
  ...                     Run Keyword And Ignore Error  Run As  ${username}  Отримати інформацію із лоту  ${object_id}  ${field_name}
  ${field}=  Отримати шлях до поля об’єкта  ${username}  ${field_name}  ${object_id}
  ${field_value}=  Run Keyword IF  '${status}'=='PASS'  Set Variable  ${value}
  ...                          ELSE  Run As  ${username}  Отримати інформацію із тендера  ${field}
  [return]  ${field_value}


Отримати ідентифікатори об’єктів
  [Arguments]  ${username}  ${objects_type}
  @{objects_ids}=  Create List
  @{objects}=  Get from object  ${USERS.users['${username}'].tender_data.data}  ${objects_type}
  :FOR  ${obj}  IN  @{objects}
  \   ${obj_id}=  get_id_from_object  ${obj}
  \   Append To List  ${objects_ids}  ${obj_id}
  [return]  ${objects_ids}


Викликати для учасника
  [Arguments]  ${username}  ${command}  @{arguments}
  Run keyword unless  '${WARN_RUN_AS}' == '${True}'
  ...      Run keywords
  ...
  ...      Set Suite Variable  ${WARN_RUN_AS}  ${True}
  ...
  ...      AND
  ...
  ...      Log  Keyword 'Викликати для учасника' is deprecated. Please use 'Run As' and 'Require Failure' instead.
  ...      WARN
  Run Keyword And Return  Run As  ${username}  ${command}  @{arguments}


Run As
  [Arguments]  ${username}  ${command}  @{arguments}
  [Documentation]
  ...      Run the given keyword (``command``) with given ``arguments``
  ...      using driver (keyword library) of user ``username``.
  Log  ${username}
  Log  ${command}
  Log Many  @{arguments}
  ${keywords_file}=  Get Broker Property By Username  ${username}  keywords_file
  ${status}  ${value}=  Run keyword and ignore keyword definitions  ${keywords_file}.${command}  ${username}  @{arguments}
  ${unexpected_args}=  Get Regexp Matches  '${value}'  expected [0-9] arguments, got [0-9]
  ${status}  ${value}=  Run Keyword If  "${unexpected_args}"=="[]"  Set Variable  ${status}  ${value}
  ...      ELSE  Run keyword and ignore keyword definitions  ${keywords_file}.${command}  ${username}  @{arguments[:-1]}
  Run Keyword If  '${status}' == 'FAIL'  Fail  ${value}
  [return]  ${value}


Require Failure
  [Arguments]  ${username}  ${command}  @{arguments}
  [Documentation]
  ...      Sometimes we need to make sure that the given keyword fails.
  ...
  ...      This keyword works just like `Run As`, but it passes only
  ...      if ``command`` with ``arguments`` fails and vice versa.
  Log  ${username}
  Log  ${command}
  Log Many  ${command}  @{arguments}
  ${keywords_file}=  Get Broker Property By Username  ${username}  keywords_file
  ${status}  ${value}=  Run keyword and ignore keyword definitions  ${keywords_file}.${command}  ${username}  @{arguments}
  Run keyword if  '${status}' == 'PASS'  Fail  Користувач ${username} зміг виконати "${command}"
  [return]  ${value}


Дочекатись дати
  [Arguments]  ${date}
  ${sleep}=  wait_to_date  ${date}
  Run Keyword If  ${sleep} > 0  Sleep  ${sleep}


Дочекатись дати початку періоду уточнень
  [Arguments]  ${username}
  Log  ${username}
  # XXX: HACK: Same as below
  ${status}  ${date}=  Run Keyword And Ignore Error
  ...      Set Variable
  ...      ${USERS.users['${username}'].tender_data.data.enquiryPeriod.startDate}
  ${date}=  Set Variable If
  ...      '${status}' == 'FAIL'
  ...      ${USERS.users['${tender_owner}'].initial_data.data.enquiryPeriod.startDate}
  ...      ${date}
  Дочекатись дати  ${date}


Дочекатись дати початку прийому пропозицій
  [Arguments]  ${username}
  Log  ${username}
  # This tries to get the date from current user's procurement data cache.
  # On failure, it reads from tender_owner's cached initial_data.
  # XXX: This is a dirty hack!
  # HACK: It was left here only for backward compatibiliy.
  # HACK: Before caching was implemented, this keyword used to look into
  # HACK: tender_owner's initial_data.
  # HACK: This should be cleaned up as soon as each broker implements reading
  # HACK: of the needed dates from tender's page.
  ${status}  ${date}=  Run Keyword And Ignore Error
  ...      Set Variable
  ...      ${USERS.users['${username}'].tender_data.data.tenderPeriod.startDate}
  # By default if condition is not satisfied, variable is set to None.
  # The third argument sets the variable to itself instead of None.
  ${date}=  Set Variable If
  ...      '${status}' == 'FAIL'
  ...      ${USERS.users['${tender_owner}'].initial_data.data.tenderPeriod.startDate}
  ...      ${date}
  Дочекатись дати  ${date}


Дочекатись дати закінчення прийому пропозицій
  [Arguments]  ${username}
  Log  ${username}
  # XXX: HACK: Same as above
  ${status}  ${date}=  Run Keyword And Ignore Error
  ...      Set Variable
  ...      ${USERS.users['${username}'].tender_data.data.tenderPeriod.endDate}
  ${date}=  Set Variable If
  ...      '${status}' == 'FAIL'
  ...      ${USERS.users['${tender_owner}'].initial_data.data.tenderPeriod.endDate}
  ...      ${date}
  Дочекатись дати  ${date}


Дочекатись дати початку аукціону
  [Arguments]  ${username}
  Log  ${username}
  # Can't use that dirty hack here since we don't know
  # the date of auction when creating the procurement :)
  Дочекатись дати  ${USERS.users['${username}'].tender_data.data.auctionPeriod.startDate}


Відкрити сторінку аукціону для глядача
  ${url}=  Run as  ${viewer}  Отримати посилання на аукціон для глядача  ${TENDER['TENDER_UAID']}
  Open browser  ${url}  ${USERS.users['${viewer}'].browser}


Дочекатись дати закінчення аукціону
  [Arguments]  ${username}
  Log  ${username}
  Дочекатись дати  ${USERS.users['${username}'].tender_data.data.auctionPeriod.endDate}


Дочекатись дати закінчення періоду подання скарг
  [Arguments]  ${username}
  log  ${username}
  Дочекатись дати  ${USERS.users['${username}'].tender_data.data.complaintPeriod.endDate}


Оновити LAST_MODIFICATION_DATE
  ${LAST_MODIFICATION_DATE}=  Get Current TZdate
  Run keyword if  '${TEST_STATUS}' == 'PASS'  Set To Dictionary  ${TENDER}  LAST_MODIFICATION_DATE=${LAST_MODIFICATION_DATE}
