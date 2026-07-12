---
name: code-review
description: Revisa o git diff atual em busca de bugs e problemas de corretude — erros lógicos, edge cases não tratados, condições de corrida, comparações erradas, off-by-one, tratamento de erro ausente. Use sempre que o usuário pedir para "revisar o código", "revisar minhas mudanças", "dar uma olhada nesse diff", "achar bug antes de commitar", ou disser algo como "confere isso pra mim" / "tem algo errado aqui", mesmo sem citar "code review" explicitamente.
---

# Revisão de código focada em corretude

Revisa as mudanças reais do repositório em busca de bugs — não é uma revisão de
estilo, nomenclatura ou arquitetura. O objetivo é encontrar coisas que vão quebrar
em produção ou se comportar diferente do esperado.

## Passo a passo

1. Rode `git diff --staged` para ver o que está staged. Se estiver vazio, rode
   `git diff` para ver mudanças não staged e avise que a revisão é sobre essas.
2. Se o diff tocar em uma função ou arquivo cujo contexto não está claro só pelo
   diff (ex: uma função é chamada mas sua definição não aparece nas linhas
   alteradas), leia o arquivo completo antes de opinar — nunca conclua "isso é um
   bug" sem ver o código ao redor.
3. Para cada bloco de mudança, pergunte-se:
   - Essa lógica cobre os casos de borda (lista vazia, null/None, zero, string
     vazia, valores negativos)?
   - Alguma comparação, índice ou loop pode estourar limite (off-by-one)?
   - Há alguma condição de corrida se isso rodar de forma concorrente/assíncrona?
   - Erros de chamadas externas (rede, arquivo, banco) são tratados, ou vão
     estourar sem tratamento?
   - O tipo de dado assumido bate com o que realmente pode chegar ali?
4. Não aponte estilo, nomenclatura, formatação ou preferências subjetivas —
   isso não é o foco desta skill. Só aponte algo se puder descrever um cenário
   concreto de entrada/estado que causaria comportamento errado ou crash.
5. Reporte os achados ordenados do mais grave para o mais leve. Para cada um,
   inclua: arquivo e linha, o problema, e um cenário concreto que o dispara.
   Se não encontrar nada, diga isso claramente em vez de forçar um achado.
6. Não edite o código sozinho — só reporte. Se o usuário pedir para corrigir
   depois de ver os achados, aí sim aplique as mudanças.

## Formato do relatório

```
## Achado 1 — <arquivo>:<linha>
**Problema**: <descrição objetiva>
**Cenário**: <entrada ou estado que causa o problema>

## Achado 2 — ...
```

Se nada relevante for encontrado:
```
Não encontrei bugs de corretude nesse diff. Revisei: <lista breve do que foi olhado>.
```
