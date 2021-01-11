echo off 
color 4F
mode 110,30

title  Automatizacao da aplicacao das GPOs do OneDrive
cls 
echo                    ====================================================================
echo                    *****************************ATENCAO!!!*****************************
echo                    ====================================================================
echo.
echo                    Esse script ira realizar a automacao do processo de uso do OneDrive com 
echo                    GPOs em computadores do dominio. Antes de prosseguir, verifique se esse 
echo                    script esta na area de trabalho. 
echo 
echo.
echo                    Deseja continuar?
echo. 
echo                    [1]Sim
echo                    [2]Nao
echo.

set /p opcao=Digite o numero correspondente a opcao escolhida:
if %opcao% equ 1 goto 1
if %opcao% equ 2 goto 2

:1
echo.
echo Voce ja tem o OneDrive instalado?
echo [3]Sim
echo [4]Nao

echo.
set /p situacao=Digite o numero correspondente a opcao escolhida:
if %situacao% equ 3 goto 3
if %situacao% equ 4 goto 4

:3
echo.
echo ******************************ATENCAO!***************************
echo *****A informacao solicitada abaixo sera excluida depois que***** 
echo *****todas as etapas do processo forem concluidas com sucesso****
echo *****************************************************************
echo. 

set /p id=Informe a ID de locatario:
>C:\Users\idDeLocatario.txt echo %id%

goto gpos

REM GPOs de computador

set /p id=<C:\Users\idDeLocatario.txt

REM GPO 1 - Exigir que os usuários confirmem grandes operações de exclusão
reg add HKLM\SOFTWARE\Policies\Microsoft\OneDrive /v ForcedLocalMassDeleteDetection /t REG_DWORD /d 00000001

REM GPO 2 - Mover silenciosamente pastas conhecidas do windows para o Onedrive
reg add HKLM\SOFTWARE\Policies\Microsoft\OneDrive /v KFMSilentOptIn /d %id%

REM GPO 3 - Impedir que o aplicativo de sincronização gere tráfego de rede até que os usuários entrem
reg add HKLM\SOFTWARE\Policies\Microsoft\OneDrive /v PreventNetworkTrafficPreUserSignIn /t REG_DWORD /d 00000001

REM GPO 4 - Usar Arquivos do OneDrive Sob Demanda
reg add HKLM\SOFTWARE\Policies\Microsoft\OneDrive /v FilesOnDemandEnabled /t REG_DWORD /d 00000001

REM GPO 5 - Impedir que os usuários movam as pastas conhecidas do Windows para o OneDrive
reg add HKLM\SOFTWARE\Policies\Microsoft\OneDrive /v KFMBlockOptIn /t REG_DWORD /d 00000001

REM GPO 6 - Definir o tamanho máximo do OneDrive de um usuário que pode ser baixado automaticamente
reg add HKLM\SOFTWARE\Policies\Microsoft\OneDrive /v DiskSpaceCheckThresholdMB /t REG_MULTI_SZ /d %id%\0005000

REM GPO 7 - Impedir que os usuários sincronizem bibliotecas e pastas compartilhadas de outras organizações
reg add HKLM\SOFTWARE\Policies\Microsoft\OneDrive /v BlockExternalSync /t REG_DWORD /d 1

REM GPO 8 - Permitir a sincronização de contas do OneDrive somente para organizações específicas 
reg add HKLM\SOFTWARE\Policies\Microsoft\OneDrive /v AllowTenantList /d %id%

REM GPOs de usuário

REM GPO 1 - Limitar a velocidade de download do cliente de sincronização a uma taxa fixa
reg add HKCU\SOFTWARE\Policies\Microsoft\OneDrive /v DownloadBandwidthLimit /t REG_DWORD /d 00000080

REM GPO 2 - Desabilitar o tutorial que aparece no final da configuração do OneDrive
reg add HKCU\SOFTWARE\Policies\Microsoft\OneDrive /v DisableTutorial /t REG_DWORD /d 00000001

REM GPO 3 - Permitir que os usuários escolham como lidar com conflitos de sincronização de arquivos do Office
reg add HKCU\SOFTWARE\Policies\Microsoft\OneDrive /v EnableHoldTheFile /t REG_DWORD /d 00000001

REM GPO 4 - Impedir que os usuários alterem o local da pasta do OneDrive
reg add HKCU\Software\Policies\Microsoft\OneDrive /v DisableCustomRoot /t REG_MULTI_SZ /d %id%\00000001

REM GPO 5 - Impedir os usuários de sincronizar contas pessoais do OneDrive
reg add HKCU\SOFTWARE\Policies\Microsoft\OneDrive /v DisablePersonalSync /t REG_DWORD /d 00000001

REM GPO 6 - Definir o local padrão para a pasta do OneDrive 
reg add HKCU\SOFTWARE\Policies\Microsoft\OneDrive /v DefaultRootDir /t REG_MULTI_SZ /d %id%\%userprofile%

del C:\Users\IdDeLocatario.txt


:gpos
setlocal EnableDelayedExpansion
set /a cont=0
for /f "delims= skip=48" %%a in (%userprofile%\desktop\automacao_GPOS_Onedrive.bat) do (
echo %%a>> gposOnedrive.bat
set /a cont=!cont!+1
if "!cont!"=="32" goto mover_gpos
)

:mover_gpos
move %userprofile%\desktop\gposOnedrive.bat C:\Windows\SYSVOL\sysvol\%userdnsdomain%\scripts

echo.
echo Processo concluido com sucesso! 
echo.
echo O seguinte script de logon foi criado: gposOnedrive.bat
echo Agora basta adiciona-lo ao perfil dos usuarios do dominio. 
echo. 
goto fim

:4
echo.
echo Aguarde enquanto a instalacao esta sendo feita e somente depois informe o que for socilitado. 
powershell.exe -command "& { (New-Object Net.WebClient).DownloadFile('https://go.microsoft.com/fwlink/p/?LinkID=844652&clcid=0x416&culture=pt-br&country=BR','%userprofile%\downloads\OneDriveSetup.exe') }"
powershell.exe -command Start-Process -FilePath "%userprofile%\Downloads\OneDriveSetup.exe" -ArgumentList "/s"

goto 3

:2
start exit

:fim
echo Aperte qualquer tecla para encerrar...
pause >  nul

