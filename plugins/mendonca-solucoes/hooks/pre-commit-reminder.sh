#!/bin/bash
# Lê o JSON do hook via stdin e extrai o comando Bash que está prestes a rodar.
command=$(jq -r '.tool_input.command // empty')

if echo "$command" | grep -q "git commit"; then
  cat <<'EOF'
{"systemMessage": "Lembrete antes do commit: rodou os testes? revisou o diff (git diff --staged)? a mensagem segue o padrão do repositório?"}
EOF
fi
