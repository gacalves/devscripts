#Mude o valor desta variavel se desejar alterar seu deritório base de certificados
#Cada vez que este script for executado sera gerado um novo diretorio com numeros sequenciais (1,2,3...)
#contendo os certificados gerados
$workingDirectory = 'C:\certs'

#Senha utilizada para exportar o pfx gerado
$exportPasswd = '123456'

#Logs Coloridos
function Red { process { Write-Host $_ -ForegroundColor Red } }
function Green { process { Write-Host $_ -ForegroundColor Green } }

#Valida se um determinaod comando exist
Function Test-CommandExists {
     Param ($command)    
     try { if(Get-Command $command){ RETURN $true } }
     Catch { Write-Host “$command nao existe” | Red; RETURN $false }
}

#Instala do Chocolatey se necessario
Function Install-Choco{
     $chocolateyInstalled = powershell choco -v
     if(-not($chocolateyInstalled)){
          Write-Output "### Chocolatey nao instalado, installando" | Green
   
          Set-ExecutionPolicy Bypass -Scope Process -Force
          [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072

          Write-Output "### Instalando chocolatey..." | Green
          iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
          Write-Output "### Chocolatey instalado com sucesso." | Green
     }
     else{
          Write-Output "### Chocolatey Versao $chocolateyInstalled ja esta instalada, será usada esta versao para instalar o mkcert!" | Green
     }
     
}

#Valida que esta sendo executado como administrador
Function Ensure-Administrator{
     $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
     $isAdministrator = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
     if (-not $isAdministrator )
     {
          Write-Output "### Execute este script como administrador!" | Red
          Write-Output "### fim" | Green
          exit
     }
}

#Instala o opessl se necessario
Function Install-OpenSSL{
     if(Test-CommandExists openssl){
          Write-Output "### OpenSSL ja instalado!" | Green

     }else{
          Write-Output "### OpenSSL nao instalado, instalando OpenSSL.Light..." | Green
          choco upgrade OpenSSL.Light -y
          '$env:path = "$env:path;C:\Program Files\OpenSSL\bin"' | Out-File $profile -Append
          Write-Output "### OpenSSL.Light instalado com sucesso!" | Green
     }
}

#Cria o profile do powershel se nao existir e insere o openssl.cnf no path
Function Configure-PowerShell-Profile{
     if (-not (Test-Path $profile) ) {
          Write-Output "### PowerShell profile nao definido, criando..." | Green
          New-Item -Path $profile -ItemType File -Force
          Write-Output "### PowerShell profile definido com sucesso!" | Green
     }

     Invoke-WebRequest 'http://web.mit.edu/crypto/openssl.cnf' -OutFile .\openssl.cnf
     '$env:OPENSSL_CONF = "$workingDirectory\openssl.cnf"' | Out-File $profile -Append
}

#Cria o diretório dos novos certificado 
Function Create-Certs-Dir{
     $newCertsDir  = (Get-ChildItem -Path $workingDirectory -Directory -Recurse -Force).Count + 1
     New-Item -ItemType Directory -Path $newCertsDir | Out-Null
     Set-Location $newCertsDir
     Write-Output "### O novos certificados serao gerados em:" | Green
     Write-Output $workingDirectory\$newCertsDir | Green
     #RETURN $workingDirectory\$newCertsDir
}

#Gera os certificados para localhost
Function Gen-Localhost-Certs{
     Write-Output "### Gerando certificado para localhost..." | Green
     mkcert localhost 127.0.0.1 ::1 0.0.0.0
     Write-Output "### Certificado localhost gerado!" | Green

     $privateKey = (Get-ChildItem | Where-Object { $_.Name -match '.+(key.pem)$' } ).Name
     $publicKey = (Get-ChildItem | Where-Object { $_.Name -match '.+(.pem)(?<!key.pem)$' } ).Name

     openssl pkcs12 -export -out site.pfx -inkey $privateKey -in $publicKey -passout pass:$exportPasswd
     Copy-Item $privateKey -Destination "localhost.key"
     Copy-Item $publicKey -Destination "localhost.crt"

     Write-Output "#### As chaves publica e privada estao em $pwd\site.pfx com a senha $exportPasswd" | Red
     Write-Output "#### A chave privada esta em $pwd\localhost.key" | Red
     Write-Output "#### A chave publica esta em $pwd\localhost.crt" | Red
}

#Instala o mkcert e importa o certificada da root CA
Function Install-Mkcert{
     Write-Output "###Instalando mkcert..." | Green
     choco upgrade mkcert -y
     Write-Output "### mkcert instalado!" | Green

     Write-Output "### Instalando certificado do Root CA..." | Green
     mkcert -install
     Write-Output "### Certificado do Root CA instalado!" | Green
}

#Inicia a execucao
Ensure-Administrator

Write-Output "### Diretorio base de certificados $workingDirectory" | Red

#Cria o diretorio base se ele nao existir
if(-not (Test-Path -Path $workingDirectory)){
     New-Item -ItemType Directory -Path $workingDirectory
}

#Valida se os pre-requisitos estao instalados/configurados
Set-Location $workingDirectory
Install-Choco
Install-OpenSSL
Configure-PowerShell-Profile
Install-Mkcert

#cria os certificados
Create-Certs-Dir
Gen-Localhost-Certs

Write-Output "### fim" | Green