*** Settings ***
Library  plan_client_helper.py


*** Keywords ***
Отримати internal id по UAid
  [Arguments]  ${username}  ${plan_uaid}
  Log  ${username}
  Log  ${plan_uaid}
  Log Many  ${ID_MAP}
  ${status}=  Run Keyword And Return Status  Dictionary Should Contain Key  ${ID_MAP}  ${plan_uaid}
  Run Keyword And Return If  ${status}  Get From Dictionary  ${ID_MAP}  ${plan_uaid}
  ${plans}=  get_plans  ${USERS.users['${username}'].plan_client}
  Log Many  @{plans}
  :FOR  ${plan}  IN  @{plans}
  \  Set To Dictionary  ${ID_MAP}  ${plan.planID}  ${plan.id}
  Log Many  ${ID_MAP}
  Dictionary Should Contain Key  ${ID_MAP}  ${plan_uaid}
  Run Keyword And Return  Get From Dictionary  ${ID_MAP}  ${plan_uaid}


Підготувати клієнта для користувача
  [Arguments]  ${username}
  [Documentation]  Відкрити браузер, створити об’єкт api wrapper, тощо
  Log  ${api_host_url}
  Log  ${api_version}
  ${api_wrapper}=  prepare_plan_api_wrapper  ${USERS.users['${username}'].api_key}  ${api_host_url}  ${api_version}
  Set To Dictionary  ${USERS.users['${username}']}  plan_client  ${api_wrapper}
  Set To Dictionary  ${USERS.users['${username}']}  access_token  ${EMPTY}
  ${ID_MAP}=  Create Dictionary
  Set Suite Variable  ${ID_MAP}
  Log Variables

Отримати план
  [Arguments]  ${username}  ${internalid}
  Log  ${username}
  Log  ${internalid}
  ${plan}=  Call Method  ${USERS.users['${username}'].plan_client}  get_plan  ${internalid}
  ${plan}=  set_access_key  ${plan}  ${USERS.users['${username}'].access_token}
  Set To Dictionary  ${USERS.users['${username}']}  plan_data  ${plan}
  Log  ${plan}
  [Return]  ${plan}

Створити план
  [Arguments]  ${username}  ${plan_data}
  ${plan}=  Call Method  ${USERS.users['${username}'].plan_client}  create_plan  ${plan_data}
  Log object data  ${plan}  created_plan
  ${access_token}=  Get Variable Value  ${plan.access.token}
  Set To Dictionary  ${USERS.users['${username}']}   access_token   ${access_token}
  Set To Dictionary  ${USERS.users['${username}']}   plan_data   ${plan}
  Log   ${access_token}
  Log   ${plan.data.id}
  Log   ${USERS.users['${username}'].plan_data}
  [return]  ${plan.data.planID}

Пошук плану по ідентифікатору
  [Arguments]  ${username}  ${plan_uaid}
  ${internalid}=  plan_client.Отримати internal id по UAid  ${username}  ${plan_uaid}
  ${plan}=  plan_client.Отримати план  ${username}  ${internalid}
  [return]   ${plan}

