---
description: Gera a descrição de um Pull Request (resumo + plano de teste) a partir do diff entre a branch atual e a branch base.
---

Gere a descrição de um Pull Request a partir das mudanças da branch atual.

## Passo a passo

1. Descubra a branch base (normalmente `main` ou `master`) e a branch atual com
   `git branch --show-current`.
2. Rode `git log <base>..HEAD --oneline` para ver todos os commits que entrarão
   no PR, e `git diff <base>...HEAD` para ver o conteúdo real das mudanças.
3. Escreva a descrição neste formato:

```
## Summary
<2-4 bullets explicando o que mudou e por quê, com base nos commits e no diff>

## Test plan
<checklist markdown do que precisa ser testado/validado antes de aprovar>
```

4. Mostre o resultado pronto para copiar e colar no GitHub. Não crie o PR
   automaticamente — apenas gere o texto, a menos que o usuário peça
   explicitamente para abrir o PR.
