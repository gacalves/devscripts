#Instalar mkcert
brew install mkcert

#instalar o certificado do root CA
mkcert -install

# gerar as chaves publicas e privadas para o domíno 0.0.0.0 (localhost no Mac OS). Pode ser qualquer nome de domínio
mkcert 0.0.0.0

#Exportar as chaves publicas e privadas nu unico arquivo. site.pfx será lido pela aplicação web com a senha 123456
openssl pkcs12 -export -out site.pfx -inkey 0.0.0.0-key.pem -in 0.0.0.0.pem -passout pass:123456
cp 0.0.0.0-key.pem localhost.key
cp 0.0.0.0.pem localhost.crt

#copiar para a raiz da suaaplicação web. 'path/da/aplicacao/web' é caminho do código fonte na sua máquina.
cp site.pfx path/da/aplicacao/web/site.pfx

#Este passo a passo foi feito com base em uma aplicação .net core.