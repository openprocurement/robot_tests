*** Setting ***
Library  Selenium2Screenshots

*** Keywords ***
Підготувати клієнт для користувача
  [Arguments]  ${username}
  [Documentation]  Відкрити брaвзер, створити обєкт api wrapper, тощо
  Open Browser   ${BROKERS['${USERS.users['${username}'].broker}'].url}   ${USERS.users['${username}'].browser}   ${username}
  Set Window Position   @{USERS.users['${username}'].position}
  Set Window Size       @{USERS.users['${username}'].size}
  Log Variables

Створити тендер
  [Arguments]  @{ARGUMENTS}
  Log Variables


Звірити інформацію про тендер
  [Arguments]  ${username}
  Go to    ${BROKERS['${USERS.users['${username}'].broker}'].url}/#/tenderDetailes/${TENDER_DATA.data.id}
  Wait Until Page Contains    ${TENDER_DATA.data.tenderID}   10
  ${last_note_id}=  Add pointy note   css=h3.panel-title   Verify information about the tender   position=bottom
  :FOR  ${field}  IN  @{important_fields}
  \   Page Should Contain  ${TENDER_DATA.data.${field}}
  \   Remove element   ${last_note_id}
  \   ${last_note_id}=   Add pointy note   css=h3.panel-title   checked information about field "${field}"   width=200   color=green  position=bottom
  \   sleep  1