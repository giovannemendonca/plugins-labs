# Guia: o que colocar em um plugin, e quando

Um plugin pode conter até quatro tipos de conteúdo — skills, commands, hooks e
agents — mais duas peças auxiliares (MCP servers e CLAUDE.md). Cada um resolve
um problema diferente. Este guia é sobre **como decidir qual usar**, não sobre
sintaxe (a sintaxe de cada um está nos exemplos dentro de
[`plugins/mendonca-solucoes`](plugins/mendonca-solucoes)).

## A pergunta central: quem decide usar, e com que acesso?

Antes de qualquer coisa, toda decisão entre skill/command/hook/agent se resume
a duas perguntas:

1. **Quem aciona isso — o Claude sozinho, ou eu explicitamente?**
2. **Isso deve rodar com o meu contexto/acesso completo, ou isolado e restrito?**

|                | Quem aciona          | Contexto                          | Ferramentas |
|----------------|-----------------------|------------------------------------|-------------|
| **Skill**      | Claude, automaticamente | compartilha a conversa atual      | todas as suas |
| **Command**    | Você, digitando `/nome` | injeta um prompt na conversa atual | todas as suas |
| **Hook**       | o harness, em um evento fixo | não é conversa — é um script     | só o que o script fizer |
| **Agent**      | Claude ou você, explicitamente | conversa isolada, própria      | as que você listar em `tools:` |

## Skill — use quando quer automação implícita

**Crie uma skill quando:** você quer que o comportamento aconteça mesmo que
você não lembre de pedir do jeito "certo" — só descrevendo o que quer, em
qualquer variação de frase.

**Exemplos do plugin `mendonca-solucoes`:**
- `commit-message` — "gera o commit", "que mensagem eu uso", "commita isso pra
  mim" → todas disparam a mesma skill.
- `code-review` — "revisa isso", "tem bug aqui?", "confere antes de commitar".

**Trade-off:** como o Claude decide sozinho quando usar, a qualidade da
`description` no frontmatter é crítica — se ela for vaga, a skill não
dispara quando deveria (undertriggering) ou dispara demais (overtriggering).
Não existe controle manual fino sobre "agora sim, agora não" — é o Claude
julgando o contexto.

**Não crie uma skill quando:** a ação é rara, ou você quer controle total de
quando ela roda. Nesses casos, um command é mais previsível.

## Command — use quando quer controle manual e previsível

**Crie um command quando:** você mesmo decide o momento de disparar, sempre
do mesmo jeito, sem ambiguidade — e não quer depender do Claude "adivinhar"
a intenção.

**Exemplo do plugin:** `/pr-description` — só existe quando você digita
`/pr-description`. Nunca dispara sozinho no meio de uma conversa sobre
outra coisa.

**Trade-off:** você precisa lembrar do comando (ou digitar `/` para ver a
lista). Não há gatilho automático por linguagem natural.

**Não crie um command quando:** a ação deveria acontecer mesmo que você
esqueça de pedir explicitamente — aí é skill.

## Hook — use quando quer automação obrigatória em um evento do sistema

**Crie um hook quando:** algo deve acontecer **sempre**, em resposta a um
evento técnico específico (antes/depois de uma tool rodar, início/fim de
sessão) — independente de qualquer decisão do modelo sobre "vale a pena
fazer isso agora".

**Exemplo do plugin:** `pre-commit-reminder` — dispara em **todo** `git
commit` executado pelo Claude, sem exceção, porque está amarrado ao evento
`PreToolUse` no matcher `Bash`, não a uma interpretação de linguagem.

**Trade-off:** hooks não têm "juízo de valor" — rodam sempre que o evento e o
matcher batem, então precisam ser filtrados via lógica no próprio script (foi
por isso que o `pre-commit-reminder.sh` faz `grep "git commit"`, para não
disparar em todo `git status`). Hooks também são a única peça que roda
**fora** de uma conversa — não veem o histórico, só recebem um JSON pontual
via stdin.

**Não crie um hook quando:** você quer que o Claude *julgue* se deve agir —
hooks não julgam, só executam. Se precisa de julgamento, é skill ou agent.

## Agent — use quando quer isolamento de contexto ou restrição de acesso

**Crie um agent quando pelo menos uma dessas for verdade:**
- a tarefa gera muito ruído intermediário que você não quer poluindo sua
  conversa principal (ex: 26 requisições de teste, como o `qa-tester` fez)
- você quer **restringir fisicamente** o que a tarefa pode fazer (ex:
  `qa-tester` não tem `Edit`/`Write` — não corrige, só observa e relata)
- a tarefa se beneficia de rodar sem o viés do que já foi discutido na
  conversa principal (uma segunda opinião "limpa")

**Exemplo do plugin:** `qa-tester` — roda isolado, testa a API via `curl`,
devolve só o relatório final. Mesmo que quisesse "consertar" um bug que
achou, não tem a ferramenta `Edit` disponível para isso.

**Trade-off:** um agent não tem acesso ao que foi dito na conversa principal
até aquele ponto — você precisa dar contexto suficiente no prompt de
invocação, ou na própria definição do agent. Também é mais lento/caro que
uma skill simples, porque monta uma sessão própria do zero.

**Não crie um agent quando:** a tarefa é rápida e se beneficia do contexto
que você já tem acumulado na conversa — nesse caso, skill é mais direto.

## MCP server embutido — use quando o plugin depende de um serviço externo

Diferente dos quatro anteriores, isso não é "automação" — é **conectividade**.
Um plugin pode empacotar a configuração de um servidor MCP (banco de dados,
API interna, ferramenta de monitoramento) para que instalar o plugin já
configure o acesso àquele serviço, sem passo manual de `claude mcp add`.

**Crie isso quando:** as skills/commands/agents do seu plugin dependem de um
serviço externo específico, e você quer que a conexão venha junto na
instalação — por exemplo, se o `qa-tester` precisasse consultar um painel de
monitoramento em vez de só testar via `curl`.

**Não crie isso quando:** tudo que o plugin faz já é alcançável com
ferramentas padrão (`Bash`, `Read`, etc.) — é o caso do `mendonca-solucoes`
hoje, por isso ele não tem um.

## CLAUDE.md embutido — use para contexto de domínio, não automação

Um plugin pode incluir instruções que se somam ao `CLAUDE.md` do projeto onde
for instalado — convenções, regras de negócio, contexto que você quer que
qualquer projeto usando o plugin já "saiba".

**Crie isso quando:** o conhecimento é sobre *como pensar* sobre um domínio
(ex: "este time sempre versiona em Conventional Commits em português"), não
sobre uma ação específica a executar — isso já vira instrução ambiente, sem
precisar de um gatilho.

**Não crie isso quando:** o que você quer é uma ação — nesse caso é skill,
command, hook ou agent, não texto de contexto.

## Resumo rápido (fluxograma mental)

1. É conectividade com um serviço externo? → **MCP server**
2. É conhecimento/contexto de fundo, sem ação? → **CLAUDE.md**
3. Deve rodar sempre, amarrado a um evento técnico, sem julgamento? → **Hook**
4. Precisa de isolamento de contexto ou restrição de ferramentas? → **Agent**
5. Você quer disparar manualmente, sempre do mesmo jeito? → **Command**
6. Deve acontecer automaticamente, a partir de qualquer frase que bata com a
   intenção? → **Skill**
