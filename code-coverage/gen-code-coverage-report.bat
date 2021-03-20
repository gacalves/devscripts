echo off

echo Executando os testes
dotnet test ..\..\ -c Release /p:CollectCoverage=true --collect:"XPlat Code Coverage"

echo Gerando o relatorio
reportgenerator -reports:../../**/coverage.cobertura.xml -targetdir:reports -reporttypes:HtmlInline_AzurePipelines;Cobertura -assemblyfilters:+* -classfilters:+* -filefilters:+* -verbosity:Info

echo Finalizada a geracao do relatorio de cobertura de codigo por testes.