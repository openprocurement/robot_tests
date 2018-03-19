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
  ${server_time}=  request  ${API_HOST_URL}  HEAD
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
  ${status}=  Run  git status
  ${diff}=    Run  git diff
  ${reflog}=  Run  git reflog
  Log  ${commit}
  Log  ${repo}
  Log  ${branch}
  Log  ${status}
  Log  ${diff}
  Log  ${reflog}


Завантажуємо дані про користувачів і майданчики
  Log  ${BROKER}
  Log  ${ROLE}
  # Suite variable; should be present in every test suite
  # in `*** Variables ***` section
  Log Many  @{USED_ROLES}

  # Load brokers data
  ${file_path}=  Get Variable Value  ${BROKERS_FILE}  brokers.yaml
  ${BROKERS_PARAMS}=  Get Variable Value  ${BROKERS_PARAMS}
  ${BROKERS}=  load_data_from  ${file_path}  mode=brokers  external_params_name=BROKERS_PARAMS
  Log  ${BROKERS}
  Set Suite Variable  ${BROKERS}
  # List of currently used brokers
  ${used_brokers}=  Create List

  # Load users data
  ${file_path}=  Get Variable Value  ${USERS_FILE}  users.yaml
  ${USERS_PARAMS}=  Get Variable Value  ${USERS_PARAMS}
  ${USERS}=  load_data_from  ${file_path}  users.yaml  external_params_name=USERS_PARAMS
  Log  ${USERS.users}
  Set Suite Variable  ${USERS}
  # List of currently used users
  ${used_users}=  Create List

  # Handle `-v role:something`
  Run Keyword Unless  '${ROLE}' in @{USED_ROLES}
  ...      Log
  ...      Role ${ROLE} is not used in this test suite.
  ...      WARN
  Set Suite Variable With Default Value
  ...      ${ROLE}
  ...      ${BROKERS['${BROKER}'].roles.${ROLE}}

  # Set default value for each role if it is not set yet;
  # fill `used_users`;
  # fill `used_brokers`.
  #
  # Don't even ask how this works!
  :FOR  ${tmp_role}  IN  @{USED_ROLES}
  \  Set Suite Variable With Default Value
  \  ...      ${tmp_role}
  \  ...      ${BROKERS['Quinta'].roles.${tmp_role}}
  \  Append To List  ${used_users}  ${${tmp_role}}
  \  Append To List  ${used_brokers}  ${USERS.users.${${tmp_role}}.broker}
  # Since `@{USED_ROLES}` is already a suite variable,
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
  ...      api_version=${API_VERSION}
  ...      tender_uaid=${TENDER['TENDER_UAID']}
  ...      last_modification_date=${TENDER['LAST_MODIFICATION_DATE']}
  ...      mode=${MODE}
  Run Keyword And Ignore Error  Set To Dictionary  ${artifact}
  ...          tender_owner=${USERS.users['${tender_owner}'].broker}
  ...          access_token=${USERS.users['${tender_owner}'].access_token}
  ...          tender_id=${USERS.users['${tender_owner}'].tender_data.data.id}
  Run Keyword And Ignore Error  Set To Dictionary  ${artifact}  tender_owner_access_token=${USERS.users['${tender_owner}'].access_token}
  Run Keyword And Ignore Error  Set To Dictionary  ${artifact}  provider_access_token=${USERS.users['${provider}'].access_token}
  Run Keyword And Ignore Error  Set To Dictionary  ${artifact}  provider1_access_token=${USERS.users['${provider1}'].access_token}
  Run Keyword And Ignore Error  Set To Dictionary  ${artifact}  provider_bid_id=${USERS.users['${provider}'].bid_id}
  Run Keyword And Ignore Error  Set To Dictionary  ${artifact}  provider1_bid_id=${USERS.users['${provider1}'].bid_id}
  Run Keyword And Ignore Error  Set To Dictionary  ${artifact}
  ...      tender_file_properties=${USERS.users['${tender_owner}'].tender_document.file_properties}
  ...      lot_file_properties=${USERS.users['${tender_owner}'].lots_documents[0].file_properties}
  ${status}  ${lots_ids}=  Run Keyword And Ignore Error  Отримати ідентифікатори об’єктів  ${viewer}  lots
  Run Keyword If  '${status}'=='PASS'
  ...      Set To Dictionary   ${artifact}   lots=${lots_ids}
  Log   ${artifact}
  log_object_data  ${artifact}  file_name=artifact  update=${True}  artifact=${True}


Завантажити дані про тендер
  ${file_path}=  Get Variable Value  ${ARTIFACT_FILE}  artifact.yaml
  ${ARTIFACT}=  load_data_from  ${file_path}
  Run Keyword And Ignore Error  Set To Dictionary  ${USERS.users['${tender_owner}']}  access_token=${ARTIFACT.access_token}
  ${TENDER}=  Create Dictionary
  ...      TENDER_UAID=${ARTIFACT.tender_uaid}
  ...      LAST_MODIFICATION_DATE=${ARTIFACT.last_modification_date}
  ...      LOT_ID=${Empty}
  ${lot_index}=  Get Variable Value  ${lot_index}  0
  Run Keyword And Ignore Error  Set To Dictionary  ${TENDER}  LOT_ID=${ARTIFACT.lots[${lot_index}]}
  ${MODE}=  Get Variable Value  ${MODE}  ${ARTIFACT.mode}
  Run Keyword And Ignore Error  Set To Dictionary  ${USERS.users['${tender_owner}']}  access_token=${ARTIFACT.tender_owner_access_token}
  Run Keyword And Ignore Error  Set To Dictionary  ${USERS.users['${viewer}']}  tender_file_properties=${ARTIFACT.tender_file_properties}
  Run Keyword And Ignore Error  Set To Dictionary  ${USERS.users['${viewer}']}  lot_file_properties=${ARTIFACT.lot_file_properties}
  Run Keyword And Ignore Error  Set To Dictionary  ${USERS.users['${provider}']}  access_token=${ARTIFACT.provider_access_token}
  Run Keyword And Ignore Error  Set To Dictionary  ${USERS.users['${provider1}']}  access_token=${ARTIFACT.provider1_access_token}
  Run Keyword And Ignore Error  Set To Dictionary  ${USERS.users['${provider}']}  bid_id=${ARTIFACT.provider_bid_id}
  Run Keyword And Ignore Error  Set To Dictionary  ${USERS.users['${provider1}']}  bid_id=${ARTIFACT.provider1_bid_id}
  Set Suite Variable  ${MODE}
  Set Suite Variable  ${lot_index}
  Set Suite Variable  ${TENDER}
  log_object_data  ${ARTIFACT}  file_name=artifact  update=${True}  artifact=${True}


Підготувати дані для створення тендера
  [Arguments]  ${tender_parameters}
  ${period_intervals}=  compute_intrs  ${BROKERS}  ${used_brokers}
  ${submissionMethodDetails}=  Get Variable Value  ${submissionMethodDetails}
  ${accelerator}=  Get Variable Value  ${accelerator}
  ${funders}=  Get Variable Value  ${FUNDERS}
  ${tender_data}=  prepare_test_tender_data  ${period_intervals}  ${tender_parameters}  ${submissionMethodDetails}  ${accelerator}  ${funders}
  ${TENDER}=  Create Dictionary
  Set Global Variable  ${TENDER}
  Log  ${tender_data}
  [return]  ${tender_data}


Підготувати дані для створення плану
  [Arguments]  ${tender_parameters}
  ${data}=  test_tender_data_planning  ${tender_parameters}
  ${tender_data}=  Create Dictionary  data=${data}
  ${TENDER}=  Create Dictionary
  Set Global Variable  ${TENDER}
  Log  ${tender_data}
  [return]  ${tender_data}


Підготувати дані для створення предмету закупівлі
  [Arguments]  ${cpv}
  ${index}=  Set variable if  ${moz_integration}  3  4
  ${item}=  test_item_data  ${cpv[:${index}]}
  [Return]  ${item}


Підготувати дані для створення предмету закупівлі плану
  [Arguments]  ${cpv}
  ${item}=  test_item_data  ${cpv[0:4]}
  Remove From Dictionary  ${item}  deliveryAddress
  Remove From Dictionary  ${item}  deliveryLocation
  Remove From Dictionary  ${item}  deliveryDate.startDate
  [Return]  ${item}


Підготувати дані для створення лоту
  [Arguments]  ${max_lot_value_amount}
  ${lot}=  test_lot_data  ${max_lot_value_amount}
  ${reply}=  Create Dictionary  data=${lot}
  [Return]  ${reply}

Підготувати дані для створення нецінового показника
  ${reply}=  test_feature_data
  [Return]  ${reply}

Підготувати дані для подання вимоги
  ${claim}=  test_claim_data
  [Return]  ${claim}


Підготувати дані для подання скарги
  [Arguments]  ${lot}=${False}
  ${complaint}=  test_complaint_data  ${lot}
  [Return]  ${complaint}


Підготувати дані для відповіді на скаргу
  ${reply}=  test_complaint_reply_data
  [Return]  ${reply}


Підготувати дані для запитання
  ${question}=  test_question_data
  [Return]  ${question}


Підготувати дані для відповіді на запитання
  ${answer}=  test_question_answer_data
  [Return]  ${answer}


Підготувати дані для подання пропозиції
  [Arguments]
  ${bid}=  generate_test_bid_data  ${USERS.users['${tender_owner}'].initial_data.data}
  [Return]  ${bid}


Підготувати дані для подання пропозиції для другого етапу
  [Arguments]  ${index}=0
  ${bid}=  generate_test_bid_data_second_stage  ${USERS.users['${tender_owner}'].tender_data.data}  ${index}
  [Return]  ${bid}


Підготувати дані про постачальника
  [Arguments]  ${username}  ${lotIndex}=${-1}
  ${lotIndex}=  Convert To Integer  ${lotIndex}
  ${supplier_data}=  test_supplier_data
  Run Keyword If  ${lotIndex} > -1  Set To Dictionary  ${supplier_data.data}  lotID=${USERS.users['${tender_owner}'].initial_data.data['lots'][${lotIndex}]['id']}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  supplier_data=${supplier_data}
  Log  ${supplier_data}
  [Return]  ${supplier_data}


Підготувати дані про скасування
  ${cancellation_reason}=  create_fake_sentence
  ${cancellation_reason}=  field_with_id  c  ${cancellation_reason}
  ${cancellation_id}=  get_id_from_string  ${cancellation_reason}
  ${file_path}  ${file_name}  ${file_content}=  create_fake_doc
  ${doc_id}=  get_id_from_string  ${file_name}
  ${document}=  Create Dictionary
  ...      doc_path=${file_path}
  ...      doc_name=${file_name}
  ...      doc_content=${file_content}
  ...      doc_id=${doc_id}
  ${new_description}=  create_fake_sentence
  ${cancellation_data}=  Create Dictionary
  ...      cancellation_reason=${cancellation_reason}
  ...      cancellation_id=${cancellation_id}
  ...      document=${document}
  ...      description=${new_description}
  ${cancellation_data}=  munchify  ${cancellation_data}
  [Return]  ${cancellation_data}


Підготувати дані про зміну до договору
  [Arguments]  ${username}
  ${change_data}=  test_change_data
  Set To Dictionary  ${USERS.users['${username}']}  change_data=${change_data}
  Log  ${change_data}
  [Return]  ${change_data}


Адаптувати дані для оголошення тендера
  [Arguments]  ${tender_data}
  # munchify is used to make deep copy of ${tender_data}
  ${adapted_data}=  munchify  ${tender_data}
  :FOR  ${username}  IN  @{USED_ROLES}
  # munchify is used to make deep copy of ${adapted_data}
  \  ${adapted_data_copy}=  munchify  ${adapted_data}
  \  ${status}  ${adapted_data_from_broker}=  Run keyword and ignore error  Run As  ${${username}}  Підготувати дані для оголошення тендера  ${adapted_data_copy}  ${username}
  \  Log  ${adapted_data_from_broker}
  # Need this in case ``${${username}}`` doesn't have `Підготувати дані для оголошення
  # тендера користувачем` keyword, so after `Run keyword and ignore error` call
  # ``${adapted_data_from_broker}`` will be ``${None}``. Else - nothing changes.
  \  ${adapted_data_from_broker}=  Set variable if  '${status}' == 'FAIL'  ${adapted_data}  ${adapted_data_from_broker}
  \  Log differences between dicts  ${adapted_data.data}  ${adapted_data_from_broker.data}  ${username} has changed initial data!
  # Update (or not, if nothing changed) ``${adapted_data}``.
  \  ${adapted_data}=  munchify  ${adapted_data_from_broker}
  \  Log  ${adapted_data}
  Log  ${adapted_data}
  Log  ${tender_data}
  [Return]  ${adapted_data}


Log differences between dicts
  [Arguments]  ${left}  ${right}  ${begin}  ${end}=${Empty}
  ${diff_status}  ${diff_message}=  Run Keyword And Ignore Error  Dictionaries Should Be Equal  ${left}  ${right}
  Run keyword if  '${diff_status}' == 'FAIL'  Log  \n${begin}\n${diff_message}\n${end}  WARN
  [Return]  ${diff_status}


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
  Run Keyword If  ${time_diff} > 0  Run Keywords
  ...      Оновити сторінку  ${username}
  ...      AND
  ...      Set To Dictionary  ${USERS.users['${username}']}  LAST_REFRESH_DATE=${LAST_REFRESH_DATE}


Оновити сторінку
  [Arguments]  ${username}
  Run Keyword If  '${RESOURCE}' == 'plans'  Run As  ${username}  Оновити сторінку з планом  ${TENDER['TENDER_UAID']}
  ...      ELSE  Run As  ${username}  Оновити сторінку з тендером  ${TENDER['TENDER_UAID']}


Звірити поле тендера
  [Arguments]  ${username}  ${tender_uaid}  ${tender_data}  ${field}
  ${left}=  get_from_object  ${tender_data.data}  ${field}
  Звірити поле тендера із значенням  ${username}  ${tender_uaid}  ${left}  ${field}


Звірити поле плану
  [Arguments]  ${username}  ${tender_uaid}  ${tender_data}  ${field}
  ${left}=  get_from_object  ${tender_data.data}  ${field}
  Звірити поле плану із значенням  ${username}  ${tender_uaid}  ${left}  ${field}


Звірити поле плану із значенням
  [Arguments]  ${username}  ${tender_uaid}  ${left}  ${field}  ${object_id}=${Empty}
  ${right}=  Отримати дані із плану  ${username}  ${tender_uaid}  ${field}  ${object_id}
  Порівняти об'єкти  ${left}  ${right}


Звірити поле тендера із значенням
  [Arguments]  ${username}  ${tender_uaid}  ${left}  ${field}  ${object_id}=${Empty}
  ${right}=  Отримати дані із тендера  ${username}  ${tender_uaid}  ${field}  ${object_id}
  Порівняти об'єкти  ${left}  ${right}


Звірити поле договору
  [Arguments]  ${username}  ${contract_uaid}  ${cotract_data}  ${field}
  ${left}=  get_from_object  ${contract_data.data}  ${field}
  Звірити поле договору із значенням  ${username}  ${contract_uaid}  ${left}  ${field}


Звірити поле договору із значенням
  [Arguments]  ${username}  ${contract_uaid}  ${left}  ${field}
  ${right}=  Отримати дані із договору  ${username}  ${contract_uaid}  ${field}
  Порівняти об'єкти  ${left}  ${right}


Звірити поле зміни до договору
  [Arguments]  ${username}  ${contract_uaid}  ${change_data}  ${field}
  ${left}=  get_from_object  ${change_data.data}  ${field}
  Звірити поле зміни до договору із значенням  ${username}  ${contract_uaid}  ${left}  ${field}


Звірити поле зміни до договору із значенням
  [Arguments]  ${username}  ${contract_uaid}  ${left}  ${field}
  ${field}=  Evaluate  "{}{}".format('changes[0].', '${field}')
  ${right}=  Отримати дані із договору  ${username}  ${contract_uaid}  ${field}
  Порівняти об'єкти  ${left}  ${right}


Звірити поле донора
  [Arguments]  ${username}  ${tender_uaid}  ${tender_data}  ${field}  ${funders_index}
  ${left}=  get_from_object  ${tender_data.data.funders[${funders_index}]}  ${field}
  Log  ${left}
  Звірити поле донора із значенням  ${username}  ${tender_uaid}  ${left}  ${field}  ${funders_index}


Звірити поле донора із значенням
  [Arguments]  ${username}  ${tender_uaid}  ${left}  ${field}  ${funders_index}  ${object_id}=${Empty}
  ${right}=  Отримати дані із тендера  ${username}  ${tender_uaid}  funders[${funders_index}].${field}  ${object_id}
  Порівняти об'єкти  ${left}  ${right}


Звірити відображення типу запланованого тендера для ${username}
  ${type}=  Отримати дані із плану  ${username}  ${TENDER['TENDER_UAID']}  tender.procurementMethodType
  Звірити відображення поля tender.procurementMethodType плану для користувача ${username}
  Run Keyword If  '${type}' == ''  Run As  ${username}  Перевірити наявність повідомлення  "без застосування електронної системи"


Порівняти об'єкти
  [Arguments]  ${left}  ${right}
  Log  ${left}
  Log  ${right}
  Should Not Be Equal  ${left}  ${None}
  Should Not Be Equal  ${right}  ${None}
  Should Be Equal  ${left}  ${right}  msg=Objects are not equal


Звірити дату тендера
  [Arguments]  ${username}  ${tender_uaid}  ${tender_data}  ${field}  ${accuracy}=60  ${absolute_delta}=${False}
  ${left}=  get_from_object  ${tender_data.data}  ${field}
  Звірити дату тендера із значенням  ${username}  ${tender_uaid}  ${left}  ${field}  accuracy=${accuracy}  absolute_delta=${absolute_delta}


Звірити дату тендера із значенням
  [Arguments]  ${username}  ${tender_uaid}  ${left}  ${field}  ${object_id}=${Empty}  ${accuracy}=60  ${absolute_delta}=${False}
  ${right}=  Отримати дані із тендера  ${username}  ${tender_uaid}  ${field}  ${object_id}
  Порівняти дати  ${left}  ${right}  accuracy=${accuracy}  absolute_delta=${absolute_delta}


Порівняти дати
  [Documentation]
  ...      Compare dates with specified ``accuracy`` (in seconds).
  ...      Default is `60`.
  ...
  ...      The keyword will fail if the difference between
  ...      ``left`` and ``right`` dates is more than ``accuracy``,
  ...      otherwise it will pass.
  [Arguments]  ${left}  ${right}  ${accuracy}=90  ${absolute_delta}=${False}
  Log  ${left}
  Log  ${right}
  Should Not Be Equal  ${left}  ${None}
  Should Not Be Equal  ${right}  ${None}
  ${status}=  compare_date  ${left}  ${right}  accuracy=${accuracy}  absolute_delta=${absolute_delta}
  Should Be True  ${status}  msg=Dates differ: ${left} != ${right}


Звірити координати доставки тендера
  [Arguments]  ${username}  ${tender_uaid}  ${tender_data}  ${item_id}
  ${item_index}=  get_object_index_by_id  ${tender_data.data['items']}  ${item_id}
  ${left_lat}=  get_from_object  ${tender_data.data}  items[${item_index}].deliveryLocation.latitude
  ${left_lon}=  get_from_object  ${tender_data.data}  items[${item_index}].deliveryLocation.longitude
  ${right_lat}=  Отримати дані із тендера  ${username}  ${tender_uaid}  deliveryLocation.latitude  ${item_id}
  ${right_lat}=  Convert To Number  ${right_lat}
  ${right_lon}=  Отримати дані із тендера  ${username}  ${tender_uaid}  deliveryLocation.longitude  ${item_id}
  ${right_lon}=  Convert To Number  ${right_lon}
  Порівняти координати  ${left_lat}  ${left_lon}  ${right_lat}  ${right_lon}


Порівняти координати
  [Documentation]
  ...      Compare coordinates with specified ``accuracy`` (in km).
  ...      Default is `0.1`.
  ...
  ...      The keyword will fail if the difference between
  ...      ``left`` and ``right`` is more than ``accuracy``,
  ...      otherwise it will pass.
  [Arguments]  ${left_lat}  ${left_lon}  ${right_lat}  ${right_lon}  ${accuracy}=0.1
  Should Not Be Equal  ${left_lat}  ${None}
  Should Not Be Equal  ${left_lon}  ${None}
  Should Not Be Equal  ${right_lat}  ${None}
  Should Not Be Equal  ${right_lon}  ${None}
  ${status}=  compare_coordinates  ${left_lat}  ${left_lon}  ${right_lat}  ${right_lon}  ${accuracy}
  Should Be True  ${status}  msg=Coordinates differ: (${left_lat}, ${left_lon}) != (${right_lat}, ${right_lon})


Звірити поля предметів закупівлі багатопредметного тендера
  [Arguments]  ${username}  ${tender_data}  ${field}
  @{items}=  get_from_object  ${tender_data.data}  items
  ${len_of_items}=  Get Length  ${items}
  :FOR  ${index}  IN RANGE  ${len_of_items}
  \  Звірити поле тендера  ${viewer}  ${tender_data}  items[${index}].${field}


Звірити дату предметів закупівлі багатопредметного тендера
  [Arguments]  ${username}  ${tender_data}  ${field}  ${accuracy}=60  ${absolute_delta}=${False}
  @{items}=  get_from_object  ${tender_data.data}  items
  :FOR  ${index}  ${_}  IN ENUMERATE  @{items}
  \  Звірити дату тендера  ${viewer}  ${TENDER['TENDER_UAID']}  ${tender_data}  items[${index}].${field}  accuracy=${accuracy}  absolute_delta=${absolute_delta}


Звірити координати доставки предметів закупівлі багатопредметного тендера
  [Arguments]  ${username}  ${tender_data}
  @{items}=  get_from_object  ${tender_data.data}  items
  :FOR  ${index}  ${_}  IN ENUMERATE  @{items}
  \  Звірити координати тендера  ${viewer}  ${tender_data}  items[${index}]


Отримати дані із тендера
  [Arguments]  ${username}  ${tender_uaid}  ${field_name}  ${object_id}=${Empty}
  ${field}=  Run Keyword If  '${object_id}'  Отримати шлях до поля об’єкта  ${username}  ${field_name}  ${object_id}
  ...             ELSE  Set Variable  ${field_name}
  ${status}  ${field_value}=  Run keyword and ignore error
  ...      get_from_object
  ...      ${USERS.users['${username}'].tender_data.data}
  ...      ${field}
  # If field in cache, return its value
  Run Keyword if  '${status}' == 'PASS'  Return from keyword   ${field_value}
  # Else call broker to find field
  ${field_value}=  Run Keyword IF  '${object_id}'  Отримати дані із об’єкта тендера  ${username}  ${tender_uaid}  ${object_id}  ${field_name}
  ...                          ELSE  Run As  ${username}  Отримати інформацію із тендера  ${tender_uaid}  ${field}
  # And caching its value before return
  Set_To_Object  ${USERS.users['${username}'].tender_data.data}  ${field}  ${field_value}
  ${data}=  munch_dict  arg=${USERS.users['${username}'].tender_data.data}
  Set To Dictionary  ${USERS.users['${username}'].tender_data}  data=${data}
  Log  ${USERS.users['${username}'].tender_data.data}
  [return]  ${field_value}


Отримати дані із плану
  [Arguments]  ${username}  ${tender_uaid}  ${field_name}  ${object_id}=${Empty}
  ${field}=  Run Keyword If  '${object_id}'  Отримати шлях до поля об’єкта  ${username}  ${field_name}  ${object_id}
  ...             ELSE  Set Variable  ${field_name}
  ${status}  ${field_value}=  Run keyword and ignore error
  ...      get_from_object
  ...      ${USERS.users['${username}'].tender_data.data}
  ...      ${field}
  # If field in cache, return its value
  Run Keyword if  '${status}' == 'PASS'  Return from keyword   ${field_value}
  # Else call broker to find field
  ${field_value}=  Run As  ${username}  Отримати інформацію із плану  ${tender_uaid}  ${field}
  # And caching its value before return
  Set_To_Object  ${USERS.users['${username}'].tender_data.data}  ${field}  ${field_value}
  ${data}=  munch_dict  arg=${USERS.users['${username}'].tender_data.data}
  Set To Dictionary  ${USERS.users['${username}'].tender_data}  data=${data}
  Log  ${USERS.users['${username}'].tender_data.data}
  [return]  ${field_value}


Отримати дані із договору
  [Arguments]  ${username}  ${contract_uaid}  ${field}
  ${status}  ${field_value}=  Run keyword and ignore error
  ...      get_from_object
  ...      ${USERS.users['${username}'].contract_data.data}
  ...      ${field}
  # If field in cache, return its value
  Run Keyword if  '${status}' == 'PASS'  Return from keyword  ${field_value}
  # Else call broker to find field
  ${field_value}=  Run As  ${username}  Отримати інформацію із договору  ${contract_uaid}  ${field}
  # And caching its value before return
  Set_To_Object  ${USERS.users['${username}'].contract_data.data}  ${field}  ${field_value}
  ${data}=  munch_dict  arg=${USERS.users['${username}'].contract_data.data}
  Set To Dictionary  ${USERS.users['${username}'].contract_data}  data=${data}
  Log  ${USERS.users['${username}'].contract_data.data}
  [return]  ${field_value}


Отримати шлях до поля об’єкта
  [Arguments]  ${username}  ${field_name}  ${object_id}
  ${object_type}=  get_object_type_by_id  ${object_id}
  ${objects}=  Get Variable Value  ${USERS.users['${username}'].tender_data.data['${object_type}']}  ${None}
  ${object_index}=  get_object_index_by_id  ${objects}  ${object_id}
  [return]  ${object_type}[${object_index}].${field_name}


Отримати дані із об’єкта тендера
  [Arguments]  ${username}  ${tender_uaid}  ${object_id}  ${field_name}
  ${object_type}=  get_object_type_by_id  ${object_id}
  ${status}  ${value}=  Run Keyword If  '${object_type}'=='questions'
  ...      Run Keyword And Ignore Error  Run As  ${username}  Отримати інформацію із запитання  ${tender_uaid}  ${object_id}  ${field_name}
  ...      ELSE IF  '${object_type}'=='lots'
  ...      Run Keyword And Ignore Error  Run As  ${username}  Отримати інформацію із лоту  ${tender_uaid}  ${object_id}  ${field_name}
  ...      ELSE IF  '${object_type}'=='items'
  ...      Run Keyword And Ignore Error  Run As  ${username}  Отримати інформацію із предмету  ${tender_uaid}  ${object_id}  ${field_name}
  ...      ELSE IF  '${object_type}'=='features'
  ...      Run Keyword And Ignore Error  Run As  ${username}  Отримати інформацію із нецінового показника  ${tender_uaid}  ${object_id}  ${field_name}
  ${field}=  Отримати шлях до поля об’єкта  ${username}  ${field_name}  ${object_id}
  ${field_value}=  Run Keyword IF  '${status}'=='PASS'  Set Variable  ${value}
  ...      ELSE  Run As  ${username}  Отримати інформацію із тендера  ${tender_uaid}  ${field}
  [return]  ${field_value}


Отримати ідентифікатори об’єктів
  [Arguments]  ${username}  ${objects_type}
  @{objects_ids}=  Create List
  @{objects}=  Get from object  ${USERS.users['${username}'].tender_data.data}  ${objects_type}
  :FOR  ${obj}  IN  @{objects}
  \   ${obj_id}=  get_id_from_object  ${obj}
  \   Append To List  ${objects_ids}  ${obj_id}
  [return]  ${objects_ids}


Звірити поле скарги із значенням
  [Arguments]  ${username}  ${tender_uaid}  ${given_value}  ${field_name}  ${complaintID}  ${award_index}=${None}
  ${received_value}=  Run as  ${username}  Отримати інформацію із скарги  ${tender_uaid}  ${complaintID}  ${field_name}  ${award_index}
  Порівняти об'єкти  ${given_value}  ${received_value}


Run As
  [Arguments]  ${username}  ${command}  @{arguments}
  [Documentation]
  ...      Run the given keyword (``command``) with given ``arguments``
  ...      using driver (keyword library) of user ``username``.
  Log  ${username}
  Log  ${command}
  Log Many  @{arguments}
  ${keywords_file}=  Get Broker Property By Username  ${username}  keywords_file
  Run Keyword And Return  ${keywords_file}.${command}  ${username}  @{arguments}


Require Failure
  [Arguments]  ${username}  ${command}  @{arguments}
  [Documentation]
  ...      Sometimes we need to make sure that the given keyword fails.
  ...
  ...      This keyword works just like `Run As`, but it passes only
  ...      if ``command`` with ``arguments`` fails and vice versa.
  Log  ${username}
  Log  ${command}
  Log Many  @{arguments}
  ${keywords_file}=  Get Broker Property By Username  ${username}  keywords_file
  ${status}  ${value}=  Run keyword and ignore keyword definitions  ${keywords_file}.${command}  ${username}  @{arguments}
  Run keyword if  '${status}' == 'PASS'  Fail  Користувач ${username} зміг виконати "${command}"
  [return]  ${value}


Можливість отримати посилання на аукціон для глядача
  ${timeout_on_wait}=  Get Broker Property By Username  ${viewer}  timeout_on_wait
  ${timeout_on_wait}=  Set Variable If
  ...                  ${timeout_on_wait} < ${120}
  ...                  ${120}
  ...                  ${timeout_on_wait}
  ${url}=  Wait Until Keyword Succeeds
  ...      ${timeout_on_wait}
  ...      15 s
  ...      Run As  ${viewer}  Отримати посилання на аукціон для глядача  ${TENDER['TENDER_UAID']}
  Should Be True  '${url}'
  Should Match Regexp  ${url}  ^https?:\/\/auction(?:-sandbox)?\.openprocurement\.org\/tenders\/([0-9A-Fa-f]{32})
  Log  URL аукціону для глядача: ${url}


Можливість отримати посилання на аукціон для учасника ${username}
  ${timeout_on_wait}=  Get Broker Property By Username  ${username}  timeout_on_wait
  ${timeout_on_wait}=  Set Variable If
  ...                  ${timeout_on_wait} < ${120}
  ...                  ${120}
  ...                  ${timeout_on_wait}
  ${url}=  Wait Until Keyword Succeeds
  ...      ${timeout_on_wait}
  ...      15 s
  ...      Run As  ${username}  Отримати посилання на аукціон для учасника  ${TENDER['TENDER_UAID']}
  Should Be True  '${url}'
  Should Match Regexp  ${url}  ^https?:\/\/auction(?:-sandbox)?\.openprocurement\.org\/tenders\/([0-9A-Fa-f]{32})
  Log  URL аукціону для учасника: ${url}


Дочекатись дати
  [Arguments]  ${date}
  ${sleep}=  wait_to_date  ${date}
  Run Keyword If  ${sleep} > 0  Sleep  ${sleep}


Дочекатись дати початку періоду уточнень
  [Arguments]  ${username}  ${tender_uaid}
  # XXX: HACK: Same as below
  ${status}  ${date}=  Run Keyword And Ignore Error
  ...      Set Variable
  ...      ${USERS.users['${username}'].tender_data.data.enquiryPeriod.startDate}
  ${date}=  Set Variable If
  ...      '${status}' == 'FAIL'
  ...      ${USERS.users['${tender_owner}'].initial_data.data.enquiryPeriod.startDate}
  ...      ${date}
  Дочекатись дати  ${date}
  Оновити LAST_MODIFICATION_DATE
  Дочекатись синхронізації з майданчиком  ${username}
  ${next_status}=  Set variable if  'open' in '${MODE}'  active.tendering  active.enquiries
  Wait until keyword succeeds
  ...      5 min 15 sec
  ...      15 sec
  ...      Звірити статус тендера
  ...      ${username}
  ...      ${tender_uaid}
  ...      ${next_status}


Дочекатись дати закінчення періоду уточнень
  [Arguments]  ${username}  ${tender_uaid}
  Дочекатись дати  ${USERS.users['${username}'].tender_data.data.enquiryPeriod.endDate}
  Оновити LAST_MODIFICATION_DATE
  Дочекатись синхронізації з майданчиком  ${username}
  Wait until keyword succeeds
  ...      10 min 15 sec
  ...      15 sec
  ...      Звірити статус тендера
  ...      ${username}
  ...      ${tender_uaid}
  ...      active.tendering


Дочекатись дати закінчення періоду відповідей на запитання
  [Arguments]  ${username}
  Дочекатись дати  ${USERS.users['${username}'].tender_data.data.enquiryPeriod.clarificationsUntil}
  Оновити LAST_MODIFICATION_DATE
  Дочекатись синхронізації з майданчиком  ${username}


Звірити статус тендера
  [Arguments]  ${username}  ${tender_uaid}  ${left}
  ${right}=  Run as  ${username}  Отримати інформацію із тендера  ${tender_uaid}  status
  Порівняти об'єкти  ${left}  ${right}


Звірити статус вимоги/скарги
  [Arguments]  ${username}  ${tender_uaid}  ${complaintID}  ${left}  ${award_index}=${None}
  ${right}=  Run as  ${username}  Отримати інформацію із скарги  ${tender_uaid}  ${complaintID}  status  ${award_index}
  Порівняти об'єкти  ${left}  ${right}


Дочекатись дати початку прийому пропозицій
  [Arguments]  ${username}  ${tender_uaid}
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
  Оновити LAST_MODIFICATION_DATE
  Дочекатись синхронізації з майданчиком  ${username}
  Wait until keyword succeeds
  ...      30 min 15 sec
  ...      15 sec
  ...      Звірити статус тендера
  ...      ${username}
  ...      ${tender_uaid}
  ...      active.tendering


Дочекатись дати закінчення прийому пропозицій
  [Arguments]  ${username}  ${tender_uaid}
  # XXX: HACK: Same as above
  ${status}  ${date}=  Run Keyword And Ignore Error
  ...      Set Variable
  ...      ${USERS.users['${username}'].tender_data.data.tenderPeriod.endDate}
  ${date}=  Set Variable If
  ...      '${status}' == 'FAIL'
  ...      ${USERS.users['${tender_owner}'].initial_data.data.tenderPeriod.endDate}
  ...      ${date}
  Дочекатись дати  ${date}
  Оновити LAST_MODIFICATION_DATE
  Дочекатись синхронізації з майданчиком  ${username}
  Wait until keyword succeeds
  ...      40 min 15 sec
  ...      15 sec
  ...      Run Keyword And Expect Error  *
  ...      Звірити статус тендера
  ...      ${username}
  ...      ${tender_uaid}
  ...      active.tendering


Дочекатись дати початку періоду прекваліфікації
  [Arguments]  ${username}  ${tender_uaid}
  # XXX: HACK: Same as above
  ${status}  ${date}=  Run Keyword And Ignore Error
  ...      Set Variable
  ...      ${USERS.users['${username}'].tender_data.data.tenderPeriod.endDate}
  ${date}=  Set Variable If
  ...      '${status}' == 'FAIL'
  ...      ${USERS.users['${tender_owner}'].initial_data.data.tenderPeriod.endDate}
  ...      ${date}
  Дочекатись дати  ${date}
  Оновити LAST_MODIFICATION_DATE
  Дочекатись синхронізації з майданчиком  ${username}
  Wait until keyword succeeds
  ...      20 min 15 sec
  ...      15 sec
  ...      Звірити статус тендера
  ...      ${username}
  ...      ${tender_uaid}
  ...      active.pre-qualification


Дочекатись дати початку очікування
  [Arguments]  ${username}  ${tender_uaid}
  # XXX: HACK: Same as above
  ${status}  ${date}=  Run Keyword And Ignore Error
  ...      Set Variable
  ...      ${USERS.users['${username}'].tender_data.data.tenderPeriod.endDate}
  ${date}=  Set Variable If
  ...      '${status}' == 'FAIL'
  ...      ${USERS.users['${tender_owner}'].initial_data.data.tenderPeriod.endDate}
  ...      ${date}
  Дочекатись дати  ${date}
  Оновити LAST_MODIFICATION_DATE
  Дочекатись синхронізації з майданчиком  ${username}
  Wait until keyword succeeds
  ...      5 min 15 sec
  ...      15 sec
  ...      Звірити статус тендера
  ...      ${username}
  ...      ${tender_uaid}
  ...      active.stage2.pending


Дочекатись дати закінчення періоду прекваліфікації
  [Arguments]  ${username}  ${tender_uaid}
  Дочекатись дати  ${USERS.users['${username}'].tender_data.data.qualificationPeriod.endDate}
  Оновити LAST_MODIFICATION_DATE
  Дочекатись синхронізації з майданчиком  ${username}
  Wait until keyword succeeds
  ...      5 min 15 sec
  ...      15 sec
  ...      Run Keyword And Expect Error  *
  ...      Звірити статус тендера
  ...      ${username}
  ...      ${tender_uaid}
  ...      active.pre-qualification.stand-still


Дочекатися створення нового етапу мостом
  [Arguments]  ${username}  ${tender_uaid}
  Оновити LAST_MODIFICATION_DATE
  Дочекатись синхронізації з майданчиком  ${username}
  Wait until keyword succeeds
  ...      10 min 15 sec
  ...      15 sec
  ...      Звірити статус тендера
  ...      ${username}
  ...      ${tender_uaid}
  ...      complete


Дочекатись дати початку періоду аукціону
  [Arguments]  ${username}  ${tender_uaid}
  Оновити LAST_MODIFICATION_DATE
  Дочекатись синхронізації з майданчиком  ${username}
  Wait until keyword succeeds
  ...      40 min 15 sec
  ...      15 sec
  ...      Звірити статус тендера
  ...      ${username}
  ...      ${tender_uaid}
  ...      active.auction
  Sleep  120  # Auction sync


Дочекатись дати початку періоду кваліфікації
  [Arguments]  ${username}  ${tender_uaid}
  Оновити LAST_MODIFICATION_DATE
  Дочекатись синхронізації з майданчиком  ${username}
  Wait until keyword succeeds
  ...      40 min 15 sec
  ...      15 sec
  ...      Звірити статус тендера
  ...      ${username}
  ...      ${tender_uaid}
  ...      active.qualification


Дочекатись дати закінчення періоду подання скарг
  [Arguments]  ${username}
  Дочекатись дати  ${USERS.users['${username}'].tender_data.data.complaintPeriod.endDate}
  Оновити LAST_MODIFICATION_DATE
  Дочекатись синхронізації з майданчиком  ${username}


Дочекатись зміни статусу вимоги
  [Arguments]  ${username}  ${status}  ${complaintID}  ${award_index}=${None}
  Дочекатись синхронізації з майданчиком  ${username}
  Wait until keyword succeeds
  ...      40 min 15 sec
  ...      15 sec
  ...      Звірити статус вимоги/скарги
  ...      ${provider}
  ...      ${TENDER['TENDER_UAID']}
  ...      ${complaintID}
  ...      ${status}
  ...      ${award_index}


Оновити LAST_MODIFICATION_DATE
  [Documentation]
  ...      Variable ``${TEST_STATUS}`` is only available in test case teardown.
  ...      When we call this keyword from elswere, we need to presume that
  ...      test status is ``PASS`` (since previous keywords passed and this
  ...      one was called).
  ${LAST_MODIFICATION_DATE}=  Get Current TZdate
  ${status}=  Get Variable Value  ${TEST_STATUS}  PASS
  Run Keyword If  '${status}' == 'PASS'  Set To Dictionary  ${TENDER}  LAST_MODIFICATION_DATE=${LAST_MODIFICATION_DATE}


Отримати останній індекс
  [Arguments]  ${object}  @{username}
  :FOR  ${role}  IN  @{username}
  \  ${status}  ${field_value}=  Run Keyword And Ignore Error
  ...      get_from_object
  ...      ${USERS.users['${role}'].tender_data.data}
  ...      ${object}
  \  Run Keyword If  '${status}' == 'PASS'  Exit For Loop
  ${len_of_object}=  Run Keyword If  '${status}' == 'PASS'  Get Length  ${USERS.users['${role}'].tender_data.data.${object}}
  ${index}=  Run Keyword If  '${status}' == 'PASS'  subtraction  ${len_of_object}  1
  [Return]  ${index}
