# Projeto de automação com Robot Framework - API

 *Projeto de treinee realizado no Academy, QaCoders.* 
 

## Install & Updates

É necessário fazer a instalação do Python e do Robot Framework com o pip, verificar as versões atualizadas, de todas as tecnologias utilizadas.

$ pip install robotframework
<br>
$ pip install --upgrade robotframework==5.0.1
<br>
$ pip install --upgrade robotframework-seleniumlibrary
<br>
$ pip install robotframework-requests
<br>
$ pip install --upgrade pip
<br>
$ python -m pip --version


## Extensão do VSCODE

* Robot Framework Language Server
* VSCODE Icons
* Theme Hyper

## Ambiente de teste

https://qualitys-hunters.qacoders-academy.com.br/api-docs/

## Run test terminal

* $ robot -d ./log arq.robot
   <br>
(Salva os logs diretamente na pasta log)
* robot -d ../log -i [tag_aqui] arquivo.robot
  <br>
(O comando com (-d) passa para dentro da pasta log, todos os logs, screenshots e reports)

## Documentação

* https://robotframework.org/
* https://robotframework.org/SeleniumLibrary/SeleniumLibrary.html
* https://marketsquare.github.io/robotframework-faker/
