REM 2020 - Script criado por Leandro Matos
REM SCRIPT PARA TROCA DE SENHA DE URA DE 350 SERVIDORES WINDOWS SERVER 2003
@Echo Off
SetLocal EnableDelayedExpansion


REM MENU PRINCIPAL COM INFORMAÇÕES AO USUÁRIO
:enterlogin
CLS
echo =========================================================================
Color 0A
echo DATA
Date /t 
echo.
echo HORARIO
Time /T
echo =========================================================================
echo.
Echo COMPUTADOR: %ComputerName%        USUARIO LOGADO: %UserName%
Echo(  
Echo IMPORTANTE: ESSE SCRIPT DEVE SER EXECUTADO APENAS NESTE SERVIDOR.
Echo. 
echo =========================================================================
Echo.        


REM VALIDAÇÕES SIMPLES PARA ACESSO AO SISTEMA. A RACF SERÁ GRAVADA NO LOG.
set /p login=1) DIGITE A SUA RACF PARA ACESSO AO MENU PRINCIPAL: 
cls
if /I "%login%" == "leandro" goto Menu
echo(
echo RACF INVALIDA, PRESSIONE UMA TECLA E INFORME A SUA RACF.
echo(
pause
goto enterlogin


REM APÓS A VALIDAÇÃO DO SISTEMA, A TELA DO MENU LISTARÁ AS INFORMAÇÕES QUE PODERÃO SER EXECUTADAS NO SISTEMA
:Menu
cls
echo ====================================================================
Color 0A
echo DATA
Date /t 
echo.
echo HORARIO
Time /T
echo ====================================================================
Echo(
Echo COMPUTADOR: %ComputerName%        USUARIO LOGADO: %UserName%        RACF: %login%
Echo(           
echo PREENCHA O ARQUIVO servers.txt PARA QUE A SENHA SEJA ALTERADA.
ECHO.
Echo  =====================================
Echo * 1. ALTERAR PARA A SENHA DE PROD     *
Echo * 2. ALTERAR PARA A SENHA DE TESTES   *
Echo * 3. INFO. SOBRE O HARDWARE/SISTEMA   *
Echo * 4. SAIR DO SISTEMA                  * 
Echo  =====================================


REM FAZ A VALIDAÇÃO PARA SOMENTE ACEITAR OS VALORES (1,2,3)
Echo(
"%__AppDir__%choice.exe" /C 1234 /N /M "ESCOLHA UMA DAS OPCOES:"
GoTo opcao%ErrorLevel% 2>NUL||GoTo opcao5
echo.


REM EXECUÇÃO DO PRIMEIRO SCRIPT E GERA ÇÃO DE UM LOG DE EXECUÇÃO PARA CONTROLE DAS SOLICITAÇÕES (SENHA DE PRODUÇÃO)
:opcao1
@echo off
cls
echo(
echo Executando...
for /F "usebackq tokens=1,2 delims==" %%i in (`wmic os get LocalDateTime /VALUE 2^>NUL`) do if '.%%i.'=='.LocalDateTime.' set data=%%j
set data=%data:~0,4%-%data:~4,2%-%data:~6,2%-%data:~8,2%-%data:~10,2%-%data:~12,6%
echo %data% - USUARIO QUE SOLICITOU A TROCA DE SENHA (PROD) - %login% >> alteracao_senha_prod\%data%.txt
echo. >> alteracao_senha_prod\%data%.txt
REM Rever a questão de senha bloqueada, o script abaixo do (psexec) faz o desbloqueio de todos os usuários dentro do servers.txt
REM psexec @servers.txt -u automacao -p l.matos@1993 net user "uragmk" /active:yes
pspasswd @servers.txt -u automacao -p l.matos@1993 uragmk Int3r4x4#2018#
echo Lista de servidores da solicitação: >> alteracao_senha_prod\%data%.txt
type servers.txt >> alteracao_senha_prod\%data%.txt
pause
cls
goto menu


REM EXECUÇÃO DO SEGUNDO SCRIPT E GERAÇÃO DE UM LOG DE EXECUÇÃO PARA CONTROLE DAS SOLICITAÇÕES (SENHA DE TESTES)
:opcao2
@echo off
cls
echo(
echo Executando...
for /F "usebackq tokens=1,2 delims==" %%i in (`wmic os get LocalDateTime /VALUE 2^>NUL`) do if '.%%i.'=='.LocalDateTime.' set data=%%j
set data=%data:~0,4%-%data:~4,2%-%data:~6,2%-%data:~8,2%-%data:~10,2%-%data:~12,6%
echo %data% - USUARIO QUE SOLICITOU A TROCA DE SENHA (TESTES) - %login% >> alteracao_senha_teste\%data%.txt
echo. >> alteracao_senha_teste\%data%.txt
REM Rever a questão de senha bloqueada, o script abaixo do (psexec) faz o desbloqueio de todos os usuários dentro do servers.txt
REM psexec @servers.txt -u automacao -p l.matos@1993 net user "uragmk" /active:yes
pspasswd @servers.txt -u automacao -p l.matos@1993 uragmk Ura#135Ura#135
echo Lista de servidores da solicitação: >> alteracao_senha_teste\%data%.txt
type servers.txt >> alteracao_senha_teste\%data%.txt
pause
cls
goto menu


REM INFORMAÇÕES BÁSICAS SOBRE O SO DAS URAS
:opcao3
@echo off
for /F "usebackq tokens=1,2 delims==" %%i in (`wmic os get LocalDateTime /VALUE 2^>NUL`) do if '.%%i.'=='.LocalDateTime.' set data=%%j
set datapsinfo=%data:~0,4%-%data:~4,2%-%data:~6,2%-%data:~8,2%-%data:~10,2%-%data:~12,6%
cls 
echo.AS INFORMACOES ESTAO SALVAS NO ARQUIVO psinfo_logs\%datapsinfo%
echo. >> psinfo_logs\%datapsinfo%.txt
echo %datapsinfo% - PsInfo returns information about a local or remote Windows system. >> psinfo_logs\%datapsinfo%.txt
echo( >> psinfo_logs\%datapsinfo%.txt
psinfo @servers.txt -u automacao -p l.matos@1993 -d >> psinfo_logs\%datapsinfo%.txt & type psinfo_logs\%datapsinfo%.txt
pause
cls
goto menu

REM SAIR DO SCRIPT
:opcao4
cls
exit