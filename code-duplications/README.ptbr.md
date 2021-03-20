## Pré requisitos

Antes de executar o script de geração de relatório de código duplicado, tenha instalado:

- [ReSharper Command line tools](https://www.jetbrains.com/resharper/download/#section=commandline). Não se esqueça de adicionar ao PATH do sistema operacional.
- O _PowerShell_ (se já não tiver);
- O _dotnet SDK_ na última versão estável.

## Como usar

- Crie uma pasta chamada _scripts_ (ou qualquer outro nome que faça sentido para você), na raiz do seu projeto;
- Copie esta pasta (_code-duplications_) para dentro da pasta scripts;
- Abra o prompt de comando do Windows e acesse a pasta _code-duplications_ copiada;
- execute o comando: ` gen-duplications-report.bat` ;

  _Este comando executará uma análise estática no código, depois gerará um relatório no formato HTML._

- Entre na pasta _reports_ e abra o _duplications-report.html_ no seu navegador.

## Créditos

Obrigado [_Jonathan Counihan_](https://counihan.co.za/blog/Static-Code-Analysis-with-Jetbrains-DupFinder/) por compartilhar o script que aplica o template nos resultados.
