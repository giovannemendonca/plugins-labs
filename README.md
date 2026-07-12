# plugins-labs

Meus plugins do Claude Code — skills organizadas, versionadas e instaláveis via
marketplace neste repositório.

## Instalar

No Claude Code:

```
/plugin marketplace add giovannemendonca/plugins-labs
/plugin install mendonca-solucoes@giovanne-plugins
```

## Estrutura

```
.claude-plugin/marketplace.json   # índice dos plugins deste repositório
plugins/
  mendonca-solucoes/
    .claude-plugin/plugin.json    # manifesto do plugin
    skills/
      commit-message/SKILL.md     # skill: gera mensagens de commit
      code-review/SKILL.md        # skill: revisa o diff em busca de bugs
    commands/
      pr-description.md           # comando: /pr-description
    hooks/
      hooks.json                  # registro do hook PreToolUse
      pre-commit-reminder.sh      # script: lembrete antes de git commit
    agents/
      qa-tester.md                # agent: testa endpoints via curl
```

## Plugins

- **mendonca-solucoes** — skills, comandos, hooks e agents de desenvolvimento do
  dia a dia:
  - `commit-message` (skill): gera mensagens de commit no padrão Conventional
    Commits a partir do `git diff` atual.
  - `code-review` (skill): revisa o `git diff` atual em busca de bugs e
    problemas de corretude (não é revisão de estilo).
  - `/pr-description` (command): gera a descrição de um PR (summary + test
    plan) a partir do diff entre a branch atual e a base.
  - `pre-commit-reminder` (hook, PreToolUse/Bash): mostra um lembrete
    (testes? diff revisado? mensagem no padrão?) antes de qualquer comando
    `git commit`, sem bloquear a execução.
  - `qa-tester` (agent): testa endpoints de uma API rodando localmente via
    curl, sem acesso a Edit/Write — só observa e reporta, nunca corrige.

## Criar um novo plugin

1. Criar `plugins/<nome>/.claude-plugin/plugin.json` com `name`, `description`,
   `version`.
2. Adicionar skills em `plugins/<nome>/skills/<skill>/SKILL.md`.
3. Registrar o plugin em `.claude-plugin/marketplace.json`.
4. Commitar e dar push.
