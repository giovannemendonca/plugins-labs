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
```

## Plugins

- **mendonca-solucoes** — skills e comandos de desenvolvimento do dia a dia:
  - `commit-message` (skill): gera mensagens de commit no padrão Conventional
    Commits a partir do `git diff` atual.
  - `code-review` (skill): revisa o `git diff` atual em busca de bugs e
    problemas de corretude (não é revisão de estilo).
  - `/pr-description` (command): gera a descrição de um PR (summary + test
    plan) a partir do diff entre a branch atual e a base.

## Criar um novo plugin

1. Criar `plugins/<nome>/.claude-plugin/plugin.json` com `name`, `description`,
   `version`.
2. Adicionar skills em `plugins/<nome>/skills/<skill>/SKILL.md`.
3. Registrar o plugin em `.claude-plugin/marketplace.json`.
4. Commitar e dar push.
