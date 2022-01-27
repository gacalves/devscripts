sudo snap install storage-explorer
snap connect storage-explorer:password-manager-service :password-manager-service

#Se houver falha ao iniciar (iniciando pelo terminal) com o erro:
# 'The configured user limit (128) on the number of inotify instances has been reached, or the per-process limit on the number of open file descriptors has been reached.'
# Execute o comando abaixo, isto vai afetar todas as aplicações dotnet que utilizan reloadOnChanges em arquivos de configuração.
echo fs.inotify.max_user_instances=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p