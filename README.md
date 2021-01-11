# Automacao_GPOS_Onedrive
Arquivo em lote (.bat) para automatização de objetos de política de grupo (GPOs) do OneDrive. 

# Funcionamento 
É necessário que o script seja movido para a área de trabalho do Windows Server para funcionar corretamente. A execução desse arquivo .bat irá 
gerar ao final um script de logon chamado "gposOnedrive.bat" que deve ser adicionado ao perfil dos usuários do dominio em questão.

# GPOs 
As seguintes GPOs serão aplicadas com a execução desse script:

(GPOs de computador)
- Exigir que os usuários confirmem grandes operações de exclusão
- Mover silenciosamente pastas conhecidas do windows para o Onedrive
- Impedir que o aplicativo de sincronização gere tráfego de rede até que os usuários entrem
- Usar Arquivos do OneDrive Sob Demanda
- Impedir que os usuários movam as pastas conhecidas do Windows para o OneDrive
- Definir o tamanho máximo do OneDrive de um usuário que pode ser baixado automaticamente
- Impedir que os usuários sincronizem bibliotecas e pastas compartilhadas de outras organizações
- Permitir a sincronização de contas do OneDrive somente para organizações específicas 

(GPOs de usuário)
- Limitar a velocidade de download do cliente de sincronização a uma taxa fixa
- Desabilitar o tutorial que aparece no final da configuração do OneDrive
- Permitir que os usuários escolham como lidar com conflitos de sincronização de arquivos do Office
- Impedir que os usuários alterem o local da pasta do OneDrive
- Impedir os usuários de sincronizar contas pessoais do OneDrive
- Definir o local padrão para a pasta do OneDrive



