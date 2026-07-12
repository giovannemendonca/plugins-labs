# plugins-labs

Meus plugins do Claude Code — skills organizadas, versionadas e instaláveis via
marketplace neste repositório.

## Instalar

No Claude Code:

```
/plugin marketplace add giovannemendonca/plugins-labs
/plugin install commit-helper@giovanne-plugins
```

## Estrutura

```
.claude-plugin/marketplace.json   # índice dos plugins deste repositório
plugins/
  commit-helper/
    .claude-plugin/plugin.json    # manifesto do plugin
    skills/
      commit-message/SKILL.md     # skill: gera mensagens de commit
```

## Plugins

- **commit-helper** — gera mensagens de commit no padrão Conventional Commits a
  partir do `git diff` atual.

## Criar um novo plugin

1. Criar `plugins/<nome>/.claude-plugin/plugin.json` com `name`, `description`,
   `version`.
2. Adicionar skills em `plugins/<nome>/skills/<skill>/SKILL.md`.
3. Registrar o plugin em `.claude-plugin/marketplace.json`.
4. Commitar e dar push.
