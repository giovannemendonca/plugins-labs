---
name: commit-message
description: Gera mensagens de commit no padrão Conventional Commits a partir do git diff atual. Use sempre que o usuário pedir para "escrever um commit", "gerar mensagem de commit", "sugerir commit message", ou disser algo como "commita isso pra mim" / "que mensagem eu uso aqui", mesmo sem citar o termo "conventional commits" explicitamente.
---

# Gerador de mensagem de commit

Gera uma mensagem de commit clara e no padrão Conventional Commits, olhando para as
mudanças reais staged/unstaged no repositório — nunca invente o que mudou.

## Passo a passo

1. Rode `git diff --staged` para ver o que está staged. Se estiver vazio, rode
   `git diff` para ver mudanças não staged e avise o usuário que nada está staged
   ainda.
2. Rode `git log --oneline -10` para observar o estilo de mensagens já usado neste
   repositório (idioma, se usa emoji, se usa escopo). Siga o estilo existente em vez
   de impor um padrão genérico.
3. Analise o diff e identifique o tipo da mudança:
   - `feat`: nova funcionalidade
   - `fix`: correção de bug
   - `refactor`: mudança de estrutura sem alterar comportamento
   - `docs`: documentação
   - `test`: testes
   - `chore`: manutenção, configs, dependências
4. Escreva a mensagem no formato:
   ```
   <tipo>(<escopo opcional>): <resumo no imperativo, minúsculo, sem ponto final>

   <corpo opcional explicando o porquê, não o o quê>
   ```
5. Mostre a mensagem sugerida ao usuário. Não rode `git commit` sozinho — sempre
   pergunte antes de criar o commit de fato, a menos que o usuário já tenha pedido
   explicitamente para commitar.

## Exemplo

**Diff**: adiciona validação de e-mail em `signup_form.py`, com um novo teste.

**Saída**:
```
feat(signup): validar formato de e-mail no cadastro

Evita que usuários completem o cadastro com e-mails malformados,
que hoje só falham silenciosamente no envio de confirmação.
```
