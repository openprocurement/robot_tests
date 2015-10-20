*** Settings ***
Library  Selenium2Screenshots
Library  String
Library  DateTime


*** Keywords ***
Підготувати клієнт для користувача
  [Arguments]  ${username}
  [Documentation]  Відкрити брaвзер, створити обєкт api wrapper, тощо
  Open Browser   ${BROKERS['${USERS.users['${username}'].broker}'].url}   ${USERS.users['${username}'].browser}   alias=${username}
  Set Window Position   @{USERS.users['${username}'].position}
  Set Window Size       @{USERS.users['${username}'].size}
  Log Variables

Пошук тендера по ідентифікатору
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tenderId
  ...      ${ARGUMENTS[2]} ==  id
  Switch browser   ${ARGUMENTS[0]}
  ${current_location}=   Get Location
  Run keyword if   '${BROKERS['${USERS.users['${username}'].broker}'].url}/#/tenderDetailes/${ARGUMENTS[2]}'=='${current_location}'  Reload Page
  Go to   ${BROKERS['${USERS.users['${username}'].broker}'].url}
  Wait Until Page Contains   Офіційний майданчик державних закупівель України   10
  sleep  1
  Input Text   id=j_idt18:datalist:j_idt67  ${ARGUMENTS[1]}
  sleep  2
  ${last_note_id}=  Add pointy note   jquery=a[href^="#/tenderDetailes"]   Found tender with tenderID "${ARGUMENTS[1]}"   width=200  position=bottom
  sleep  1
  Remove element   ${last_note_id}
  Click Link    jquery=a[href^="#/tenderDetailes"]
  Wait Until Page Contains    ${ARGUMENTS[1]}   10
  sleep  1
  Capture Page Screenshot