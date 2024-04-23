*** Settings ***
Documentation  O Objetivo deste arquivo é armazenar todos os recursos para os testes
Library    RequestsLibrary
Library    Collections
Library    JSONLibrary
Library    String
Library    FakerLibrary    locale=pt_BR

 
*** Variables ***
 
${URL}              https://qualitys-hunters.qacoders-academy.com.br
${mailadmin}        sysadmin@qacoders.com  
${passadmin}        1234@Test
# ${FULLNAME}         Bennie Dog
${PASS_USER}        1234@Test
   
*** Keywords ***
Criar sessão
    ${headers}  Create Dictionary  accept=application/json  Content-Type=application/json
    Create Session    alias=qualitys-hunters   url=${URL}   headers=${headers}    disable_warnings=1

Entrar com usuário sysadmin
    ${body}    Create Dictionary    mail=${mailadmin}    password=${passadmin}
    Log  ${body}
    ${resposta}    POST On Session    alias=qualitys-hunters    url=${URL}/api/login/    json=${body} 
    Log  ${resposta.json()}
    Set Test Variable    ${TOKEN}    ${resposta.json()["token"]}
 
Validar o token e gravar em headers de autorização
    ${headers}   Create Dictionary    Authorization=Bearer ${TOKEN}
    ${resposta}  GET On Session       alias=qualitys-hunters    url=${URL}/api/validateToken  headers=${headers}
    Log  Resposta da Solicitação: ${resposta.content}
    Log  ${TOKEN}
 
Criar um fullName randômico
  ${fullName_faker}    FakerLibrary.Name
  ${fullName_faker}=    Remove String            ${fullName_faker}   .  -  [à, è, ì, ò, ù,á, é, í, ó, ú, ý,â, ê, î, ô, û,ã, ñ, õ,ä, ë, ï, ö, ü, ÿ, ç]
  Set Test Variable    ${NOME_USER}              ${fullName_faker}
  Log                  ${NOME_USER}
Criar um email randômico
  ${email_faker}=    Convert to Lower Case          ${NOME_USER} 
  ${email_faker}=    Remove String                  ${email_faker}   .  -  [à, è, ì, ò, ù,á, é, í, ó, ú, ý,â, ê, î, ô, û,ã, ñ, õ,ä, ë, ï, ö, ü, ÿ, ç]
  ${email_faker}=    Remove String                  ${email_faker}   ${SPACE}
  Set Test Variable   ${EMAIL_USER}                 ${email_faker}@qacoders.com.br
  Log     ${EMAIL_USER}
Criar um CPF randômico
  ${number_random}    Generate Random String    length=11   chars=[NUMBERS]
  Set Test Variable     ${CPF_USER}            ${number_random} 
  Log                   ${CPF_USER}
Cadastrar um novo usuário
  ${headers}   Create Dictionary    Authorization=${TOKEN}  
  ${body}      Create Dictionary    fullName=${NOME_USER}   mail=${EMAIL_USER}    password=${PASS_USER}    accessProfile=ADMIN    cpf=${CPF_USER}    confirmPassword=${PASS_USER} 
  Log    ${body} 
  Criar sessão
  ${resposta}    POST On Session    alias=qualitys-hunters    url=${URL}/api/user/    expected_status=201    json=${body}    headers=${headers}
  Log                                     ${resposta.json()}
  Set Test Variable                       ${resposta}    
  Set Test Variable    ${ID_USUARIO}      ${resposta.json()}[user][_id]
  Set Test Variable    ${RESPOSTA}        ${resposta.json()}
  Log                                     ${ID_USUARIO}
  Log                                     ${RESPOSTA}  
Conferir se os dados foram cadastrados corretamente
  Log   ${RESPOSTA}
  Dictionary Should Contain Key          ${RESPOSTA}    user            _id            
  Dictionary Should Contain Item         ${RESPOSTA}    msg             Olá ${NOME_USER}, cadastro realizado com sucesso.

Consultar os dados do usuários
  ${headers}   Create Dictionary    Authorization=${TOKEN}
  Criar sessão
  ${resposta_consulta}    GET On Session    alias=qualitys-hunters    url=${URL}/api/user/${ID_USUARIO}     expected_status=200     headers=${headers}
  Set Test Variable    ${RESPOSTA_CONSULTA}    ${resposta_consulta.json()}
  Log    ${RESPOSTA_CONSULTA}
  Dictionary Should Contain Item    ${RESPOSTA_CONSULTA}    fullName              ${NOME_USER}
  Dictionary Should Contain Item    ${RESPOSTA_CONSULTA}    mail                  ${EMAIL_USER}   
  Dictionary Should Contain Item    ${RESPOSTA_CONSULTA}    accessProfile         ADMIN
  Dictionary Should Contain Item    ${RESPOSTA_CONSULTA}    cpf                   ${CPF_USER}
  # Dictionary Should Contain Item    ${RESPOSTA_CONSULTA}    password            ${pass_cript} 
  # Dictionary Should Contain Item    ${RESPOSTA_CONSULTA}    confirmPassword     ${pass_cript}
  
  
Alterar status de true para false
  ${headers}   Create Dictionary    Authorization=${TOKEN}
  ${alterar_status}    PUT On Session    alias=qualitys-hunters    url=${URL}/api/user/status/${ID_USUARIO}    expected_status=200    data={"status": "true"}  headers=${headers}
  Set Test Variable    ${RESPOSTA_CONSULTA_APOS_STATUS}    ${alterar_status.json()}

Excluir e Verificar Usuário
  ${headers}   Create Dictionary    Authorization=${TOKEN}
  ${deletar_usuario}    DELETE On Session    alias=qualitys-hunters    url=${URL}/api/user/${ID_USUARIO}    expected_status=200     headers=${headers}
  Set Test Variable    ${RESPOSTA_CONSULTA_APOS_EXCLUSAO}    ${deletar_usuario.json()}


*** Test Cases ***
TC0-Login ADMIN
  [Tags]    admin
  Criar sessão
  Entrar com usuário sysadmin
  Validar o token e gravar em headers de autorização

TC1-Criar um novo usuário_POST
  [Tags]    register_user
  Criar sessão
  Entrar com usuário sysadmin
  Criar um fullName randômico
  Criar um email randômico
  Criar um CPF randômico
  Cadastrar um novo usuário
  Conferir se os dados foram cadastrados corretamente

TC2 - Consultar se os dados do usuário foram cadastrados corretamente_GET
  [Tags]    consultar_user
  Criar sessão
  Entrar com usuário sysadmin
  Criar um fullName randômico
  Criar um email randômico
  Criar um CPF randômico
  Cadastrar um novo usuário
  Consultar os dados do usuários


TC3 - Atualizar dados do usuário_PUT
  [Tags]    alterar_user
  Criar sessão
  Entrar com usuário sysadmin
  Criar um fullName randômico
  Criar um email randômico
  Criar um CPF randômico
  Cadastrar um novo usuário
  Alterar status de true para false

TC4 - Excluir dados do usuário_DELETE
  [Tags]    deletar_user
  Criar sessão
  Entrar com usuário sysadmin
  Criar um fullName randômico
  Criar um email randômico
  Criar um CPF randômico
  Cadastrar um novo usuário
  Excluir e Verificar Usuário