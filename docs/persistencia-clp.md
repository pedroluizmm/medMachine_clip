# Persistencia controlada em CLP

Fluxo:

```text
React
-> FastAPI
-> validacao
-> arquivo CLP permanente
-> runtime/exports/react-generated/
```

Os casos fixos da demonstracao permanecem em `clips/facts_demo.clp`. Esse arquivo nao e alterado pelo front-end porque representa a base demonstrativa versionavel do projeto.

Os arquivos exportados pelo React sao criados apenas quando o usuario clica em `Salvar caso em CLP`. Eles armazenam somente fatos iniciais e metadados em comentarios. Intensidades, vinculos, suspeitas, alertas e explicacoes nao sao persistidos como fatos.

Ao reexecutar um caso salvo, o FastAPI chama novamente o CLIPS com os templates e regras reais. As conclusoes sao recalculadas pelo motor de inferencia.
