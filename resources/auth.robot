*** Settings *** 
Documentation  O objetivo deste arquivo é armazenar todos os recursos para os testes
Library   RequestsLibrary
Library   String
Library   Collections
Library   JSONLibrary
Library   FakerLibrary    locale=pt_BR

Resource    ../resources/token_resources.robot
Resource    ../resources/academy_resources.robot

*** Variables ***
${URL}        https://qualitys-hunters.qacoders-academy.com.br/api-docs/
${mailadmin}   sysadmin@qacoders.com  
${passadmin}   1234@Test
*** Test Cases ***
Login com sucesso
  [Documentation]  Validar autenticação com sucesso
  ${headers}=    Create Dictionary   Content-Type=application/json 
  ${body}=    Create Dictionary    mail=${mailadmin}    password=${passadmin}  disable_warnings=1

  Create Session    auth_session  ${URL} 

  ${response}=    POST On Session     auth_session  /   json=${body}    headers=${headers}
  Log    ${response}

