# Cloud ownership

Este repositório centraliza infraestrutura de Cloud e execução de releases para todas as soluções registradas.

- Landing Optimizer usa Terraform nativo em `solutions/landing-optimizer/terraform/{v1,project}`. Leia `solutions/landing-optimizer/README.md` para componentes, cinco secrets, permissões, states e operações. Não crie outro cadastro YAML ou outro state para os mesmos recursos.
- Fundocentenario mantém seus roots e states descritos em `docs/reconciliation.md`. O engine YAML genérico atende somente soluções que declaram `solution.yaml`.
- Antes de um apply administrativo, atualize os inputs de release a partir do state e revise o plano completo. Releases de aplicação usam o workflow central e só podem alterar o serviço selecionado e, para a API, o job de migração.
- Preserve endereços dos recursos e backends ao reorganizar código. Um recurso só pode pertencer a um state. Não recrie recursos nem use `ignore_changes` para esconder drift.
- Payloads de segredos ficam no Secret Manager. Terraform gerencia containers, acesso e referências de versões. Nunca coloque payloads no Git, tfvars, builds ou state.
- Repositórios de aplicação executam seus testes e chamam o workflow central. `landing-optimizer-infra` mantém desenvolvimento local e comandos de compatibilidade, sem ownership de Cloud. A desativação dos triggers antigos de marketing/demo só deve ser aplicada após a publicação e validação do substituto.
- Não faça commits ou pushes. Não atribua alterações ao agent nem acrescente coautoria.
- Pergunte sobre decisões arquiteturais cuja finalidade esteja incerta. Não aplique exclusões, substituições ou alterações de dados/acesso sem autorização específica.
