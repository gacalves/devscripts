@echo off
del reports\duplications.xml

@REM Procura o arquivo da solução
for /f "delims=" %%F in ('dir ..\..\*.sln /b /o-n') do set solutionFile=%%F
echo Arquivo de solucao encontrado %solutionFile%

echo Executando a analise estatica
dupFinder ..\..\%solutionFile% --output=reports\duplications.xml --show-stats --debug --show-text

echo Gerando relatorio
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& '%~dp0apply-template.ps1'"

echo Finalizada a geracao do relatorio de codigo duplicado.