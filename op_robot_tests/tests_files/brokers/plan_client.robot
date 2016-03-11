*** Settings ***
Library  plan_client_helper.py


*** Keywords ***
Підготувати клієнта для користувача
  [Arguments]  ${username}
  [Documentation]  Відкрити браузер, створити об’єкт api wrapper, тощо
  Log  ${api_host_url}
  Log  ${api_version}
  ${api_wrapper}=  prepare_plan_api_wrapper  ${USERS.users['${username}'].api_key}  ${api_host_url}  ${api_version}
  Set To Dictionary  ${USERS.users['${username}']}  plan  ${api_wrapper}
  Set To Dictionary  ${USERS.users['${username}']}  access_token  ${EMPTY}
  ${ID_MAP}=  Create Dictionary
  Set Suite Variable  ${ID_MAP}
  Log Variables

Створити план
  [Arguments]  ${username}  ${plan_data}
  ${plan}=  Call Method  ${USERS.users['${username}'].plan}  create_plan  ${plan_data}
  Log object data  ${plan}  created_plan
  ${access_token}=  Get Variable Value  ${plan.access.token}
  Set To Dictionary  ${USERS.users['${username}']}   access_token   ${access_token}
  Set To Dictionary  ${USERS.users['${username}']}   plan_data   ${plan}
  Log   ${access_token}
  Log   ${plan.data.id}
  Log   ${USERS.users['${username}'].plan_data}
  [return]  ${plan.data.planID}
