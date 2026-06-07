# Arquitetura

O sistema usa CLIPS como motor de inferencia baseado em regras de producao. A inferencia principal e por encadeamento para frente: fatos existentes ativam regras, regras disparam pela agenda e novos fatos sao inseridos na memoria de trabalho.

## Fluxo

```text
entrada
-> intensidade
-> suspeita clinica
-> vinculo epidemiologico
-> suspeita reforcada
-> alerta
```

## Componentes

Base de fatos: `clips/facts_demo.clp` contem pacientes, sintomas, historico, exposicoes e fases. Esses fatos representam dados brutos e concretos.

Base de regras: os arquivos `rules_*.clp` separam classificacao, epidemiologia, suspeitas e risco.

Memoria de trabalho: contem os fatos iniciais carregados no `reset` e os fatos derivados por `assert`.

Agenda: organiza as ativacoes de regras quando suas premissas sao satisfeitas.

Motor de inferencia: executa `(run)` e dispara as regras ativadas.

Fatos derivados: `intensidade-temperatura`, `intensidade-dor-articular`, `vinculo-epidemiologico`, `suspeita-clinica`, `suspeita-reforcada` e `alerta`.

## Cadeia de inferencia

1. Os dados brutos do paciente sao carregados.
2. Regras de classificacao discretizam temperatura e dor articular por limiares.
3. Regras clinicas combinam intensidades e sintomas especificos para criar suspeitas clinicas.
4. Regras epidemiologicas derivam vinculos a partir de exposicoes.
5. Uma regra generica combina suspeita clinica e vinculo da mesma doenca para criar suspeita reforcada.
6. Regras de risco criam alertas de triagem quando ha suspeita reforcada e condicoes adicionais.

O sistema nao cria suspeita reforcada apenas por vinculo epidemiologico.
