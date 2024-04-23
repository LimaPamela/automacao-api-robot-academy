*** Settings *** 
Library   RequestsLibrary
Library   String
Library   Collections
Library   JSONLibrary
Library   FakerLibrary    locale=pt_BR

*** Variables ***
${URL}         https://qualitys-hunters.qacoders-academy.com.br/api-docs/
${MAIL}        sysadmin@qacoders.com  
${PASSWORD}    1234@Test
${TOKEN} 
${ID_USUARIO}
${CPF_USER}   11122233344
${FULLNAME_RANDOM}  
${EMAIL}
${PASS_USER}   1234@Test
${CONFIRM_PASS}  1234@Test  

*** Keywords ***

*** Test Cases ***
Login com sucesso
  [Documentation]  Validar autenticação com sucesso
  ${headers}=    Create Dictionary    Content-Type=application/json   alias=qualitys-hunters
  ${body}=       Create Dictionary    mail=${MAIL}    password=${PASSWORD}  disable_warnings=1
  
  Create Session    auth_session  ${URL} 

  ${response}=    POST On Session     auth_session  /   json=${body}    headers=${headers}
  Log    ${response.json()}
  
  Should Be Equal As Integers    ${response.status_code}   200
  Should Not Be Empty            ${response.json()}[token]
  ${response}=   Set Test Variable  ${TOKEN}    ${response.json()}[token]
  
  ${response_email}=    Set Variable    ${response.json()}[user][mail]
  Should Be Equal As Strings   ${response_email}  ${MAIL}
 
     # ${palavra_randomica}  Generate Random String   length=8   chars=[LETTERS]
    # ${palavra_randomica}  Convert To Lower Case    ${palavra_randomica}
    # Set Test Variable     ${EMAIL_USER}            ${palavra_randomica}@qacoders.com.br  
    # Log                   ${EMAIL_USER}
Criar e Cadastrar Novo Usuário   
  ${palavra_randomica}=    Generate Random String    8    [LETTERS]
  ${EMAIL}=    Set Variable    ${palavra_randomica}@qacoders.com.br
  Log    ${EMAIL}
  ${response}=    Set Variable      
  ${ID_USUARIO}=    Set Variable    ${response.json()}[user][_id]
  Log    ${ID_USUARIO}

  ${nome_random}=    Generate Random String    8    [LETTERS]
  ${FULLNAME_RANDOM}=    Set Variable    ${nome_random}
  Log    ${FULLNAME_RANDOM}
  ${body}=    Create Dictionary    fullName=${FULLNAME_RANDOM}    mail=${EMAIL}    password=${PASS_USER}    accessProfile=ADMIN    cpf=${CPF_USER}    confirmPassword=${CONFIRM_PASS}
  Log    ${body}
  ${response}=    Post On Session    ${URL}/api/user/    json=${body}    expected_status=201
  Log    ${response}
  ${ID_USUARIO}=    Set Variable    ${response}[user][_id]
  ${RESPOSTA}=    Set Variable      ${response}
  Log    ${ID_USUARIO}
  Log    ${RESPOSTA}

Conferir se este novo usuário foi cadastrado corretamente
  ${RESPOSTA}=    Set Variable    ${RESPOSTA_CONSULTA} 
  Log  ${RESPOSTA} 
  Dictionary Should Contain Item      ${RESPOSTA}  message  Cadastro realizado com sucesso
  Dictionary Should Contain Key       ${RESPOSTA}  _id
  Log ${RESPOSTA.json()}[user][_id]

Consultar os dados do usuário
  ${response_consulta}  GET On Session   url=${URL}/api/user/${ID_USUARIO}   expected_status=200
  Set Test Variable     ${RESPOSTA_CONSULTA}                 ${response_consulta.json()}

  Log       ${RESPOSTA_CONSULTA}
  Dictionary Should Contain Item    ${RESPOSTA_CONSULTA}    fullName            ${FULLNAME_RANDOM}
  Dictionary Should Contain Item    ${RESPOSTA_CONSULTA}    mail                ${EMAIL}
  Dictionary Should Contain Item    ${RESPOSTA_CONSULTA}    password            ${PASS_USER} 
  Dictionary Should Contain Item    ${RESPOSTA_CONSULTA}    accessProfile       ADMIN
  Dictionary Should Contain Item    ${RESPOSTA_CONSULTA}    cpf                 ${CPF_USER}
  Dictionary Should Contain Item    ${RESPOSTA_CONSULTA}    confirmPassword     ${CONFIRM_PASS}
  Dictionary Should Contain Item    ${RESPOSTA_CONSULTA}    _id                 ${ID_USUARIO}

Alterar e Conferir Senha do Usuário
  ${response}=    Put On Session    ${URL}/user/password/${ID_USUARIO}    data={"password": "${PASS_USER}", "confirmPassword": "${CONFIRM_PASS}"}    expected_status=200
  Log    ${response.content}

  ${response}=    Get On Session    ${URL}/api/user/${ID_USUARIO}
  ${RESPOSTA}=    Set Variable    ${response.json()}
  Log    ${RESPOSTA}

  Dictionary Should Contain Item    ${RESPOSTA}    message    Senha atualizada com sucesso!
  Dictionary Should Contain Key    ${RESPOSTA}    _id
  Log    ${RESPOSTA["user"]["_id"]}
  
Excluir e Verificar Usuário
    ${excluir_usuario}=    Delete On Session    ${URL}/api/user/${ID_USUARIO}    expected_status=200
    ${ID_USUARIO}=    Set Test Variable    ${excluir_usuario.json()["user"]["_id"]}
    ${RESPOSTA_CONSULTA_APOS_EXCLUSAO}=    Set Test Variable    ${excluir_usuario.json()}

    ${response}=    Get On Session    ${URL}/api/user/${ID_USUARIO}
    Log    ${RESPOSTA_CONSULTA_APOS_EXCLUSAO}

