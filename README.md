# Sistema Especialista de Triagem de Arboviroses em CLIPS

Projeto academico de sistema especialista classico para triagem explicavel de suspeitas relacionadas a dengue, chikungunya, zika e febre do Oropouche.

Este sistema nao realiza diagnostico medico real, nao recomenda conduta clinica e nao substitui avaliacao profissional. Ele demonstra fatos, regras de producao, memoria de trabalho, agenda, encadeamento para frente, fatos derivados e rastreamento de regras disparadas.

## Por que CLIPS

CLIPS foi escolhido por ser uma ferramenta classica para sistemas especialistas baseados em regras. Ele permite representar conhecimento como fatos e regras, disparar regras pela agenda e derivar novos fatos por encadeamento para frente.

## Arquitetura

Fluxo conceitual:

```text
Dados brutos do paciente
-> categorizacao da intensidade
-> suspeita clinica
-> vinculo epidemiologico
-> suspeita reforcada
-> alerta de triagem
```

Os fatos iniciais ficam em `clips/facts_demo.clp`. As regras derivam intensidades, suspeitas clinicas, vinculos epidemiologicos, suspeitas reforcadas e alertas. A memoria de trabalho contem tanto fatos iniciais quanto fatos derivados.

A categorizacao de temperatura e dor articular usa discretizacao por limiares, tambem chamada de categorizacao linguistica de intensidade. Esta versao nao implementa logica fuzzy real.

## Estrutura

```text
.
|-- README.md
|-- clips
|   |-- templates.clp
|   |-- facts_demo.clp
|   |-- rules_classification.clp
|   |-- rules_epidemiology.clp
|   |-- rules_suspicion.clp
|   |-- rules_risk.clp
|   |-- output.clp
|   |-- main.clp
|   |-- main_cli.clp
|   |-- debug.clp
|   |-- debug_cli.clp
|   |-- tests_cli.clp
|   `-- tests
|-- docs
|   |-- arquitetura.md
|   `-- regras.md
|-- scripts
|   |-- run_demo.bat
|   |-- run_demo.ps1
|   |-- run_demo.sh
|   |-- run_debug.bat
|   |-- run_debug.ps1
|   |-- run_tests.bat
|   `-- run_tests.ps1
`-- expected
    `-- saida_demo.txt
```

## Como instalar o CLIPS

Instale o CLIPS pelo metodo adequado ao seu sistema operacional. Em algumas instalacoes, o executavel pode se chamar `clips`; em outras, pode haver um binario com nome diferente. Ajuste apenas o nome do comando se necessario, sem fixar caminhos pessoais no projeto.

## Como executar

Comando manual a partir da raiz do projeto:

```sh
clips -f2 clips/main.clp
```

No Windows:

```bat
scripts\run_demo.bat
```

No Linux/macOS:

```sh
sh scripts/run_demo.sh
```

## Execucao pelo terminal do VS Code

No PowerShell do VS Code, execute a partir de qualquer diretorio dentro do projeto:

```powershell
.\scripts\run_demo.ps1
.\scripts\run_debug.ps1
.\scripts\run_tests.ps1
```

Os scripts procuram o executavel nesta ordem:

1. variavel de ambiente `CLIPS_EXE`;
2. comando `CLIPSDOS.exe` disponivel no `PATH`;
3. caminho padrao `C:\Program Files\SSS\CLIPS 6.4.2\CLIPSDOS.exe`.

`clips/main.clp` e `clips/debug.clp` sao entradas interativas e nao encerram o interpretador. Use-as quando quiser continuar no prompt `CLIPS>`.

`clips/main_cli.clp` e `clips/debug_cli.clp` chamam as entradas interativas e executam `(exit)` ao final, devolvendo o terminal automaticamente para o prompt `PS>`.

Comandos PowerShell devem ser digitados somente no prompt `PS>`. Comandos CLIPS devem ser digitados somente no prompt `CLIPS>`.

Comando manual no Windows para execucao com encerramento automatico:

```powershell
& "C:\Program Files\SSS\CLIPS 6.4.2\CLIPSDOS.exe" -f2 "C:\AV3_IA\clips\main_cli.clp"
```

## Modo de depuracao

Para demonstrar fatos, regras, ativacoes, agenda e encadeamento para frente:

```sh
clips -f2 clips/debug.clp
```

Esse modo habilita:

```clips
(watch facts)
(watch rules)
(watch activations)
```

## Saida esperada

A referencia esta em `expected/saida_demo.txt`. A ordem pode variar conforme a agenda do CLIPS, mas devem existir quatro suspeitas reforcadas e quatro alertas:

```text
Joao -> Oropouche
Maria -> Dengue
Ana -> Chikungunya
Lucia -> Zika
```

## Limitacoes

Esta versao e didatica e usa regras simplificadas. Nao usa banco de dados, interface grafica, API externa, machine learning, bibliotecas externas de logica, Prolog, redes Bayesianas ou logica fuzzy completa. Uma versao futura poderia integrar um motor fuzzy real, desde que a etapa fosse modelada e documentada adequadamente.

## Interface web integrada

O projeto tambem possui uma primeira versao web para analisar um paciente informado pelo usuario sem editar arquivos `.clp`.

Arquitetura:

```text
React + TypeScript + Vite
-> JSON
-> FastAPI + Pydantic
-> arquivo temporario de fatos CLIPS
-> CLIPSDOS.exe via subprocesso
-> saida estruturada delimitada
-> JSON
-> dashboard web
```

O front nao contem as regras medicas. O back-end nao decide suspeitas, vinculos, intensidades ou alertas. O CLIPS continua responsavel pela inferencia por encadeamento para frente.

## Pre-requisitos web

Instale:

```text
Python 3
Node.js com npm
CLIPS 6.4.2
```

O CLIPS e localizado nesta ordem:

1. variavel de ambiente `CLIPS_EXE`;
2. `CLIPSDOS.exe` no `PATH`;
3. `C:\Program Files\SSS\CLIPS 6.4.2\CLIPSDOS.exe`.

## Configurar ambiente web

```powershell
.\scripts\setup_web.ps1
```

Esse script cria o ambiente virtual do back-end, instala `backend/requirements.txt` e executa `npm install` no front-end. Ele nao instala o CLIPS automaticamente.

## Configuracao local

O caminho do CLIPS fica em `.env.local`, na raiz do projeto. O `setup_web.ps1` cria esse arquivo automaticamente quando encontra a instalacao padrao:

```text
C:\Program Files\SSS\CLIPS 6.4.2\CLIPSDOS.exe
```

`.env.local` e especifico da maquina e nao deve ser enviado ao Git. O arquivo versionavel e `.env.example`.

Fluxo inicial:

```powershell
.\scripts\setup_web.ps1
.\scripts\run_web.ps1
```

Nas execucoes futuras, basta:

```powershell
.\scripts\run_web.ps1
```

Nao e necessario definir `CLIPS_EXE` manualmente em cada terminal.

## Executar API e front-end

Em terminais separados:

```powershell
.\scripts\run_api.ps1
.\scripts\run_front.ps1
```

Ou iniciar os dois para desenvolvimento:

```powershell
.\scripts\run_web.ps1
```

Enderecos:

```text
API:   http://127.0.0.1:8000
Front: http://127.0.0.1:5173
```

## Endpoints

```text
GET  /api/health
GET  /api/options
POST /api/analyze
```

`/api/analyze` recebe um paciente por requisicao, gera fatos temporarios em `runtime/tmp/<uuid>/`, executa o CLIPS e remove os arquivos temporarios ao finalizar.

## Saida estruturada

A integracao web usa `clips/output_structured.clp`, que imprime linhas entre:

```text
@@RESULT_START
@@RESULT_END
```

A demonstracao em terminal continua usando `clips/output.clp`.

## Testes web

Back-end:

```powershell
backend\.venv\Scripts\python.exe -m pytest backend
```

Front-end:

```powershell
cd frontend
npm run typecheck
npm run build
```

Os testes CLIPS existentes continuam sendo executados por:

```powershell
.\scripts\run_tests.ps1
```

## Solucao de problemas

Se `/api/health` indicar CLIPS indisponivel, defina:

```powershell
$env:CLIPS_EXE = "C:\Program Files\SSS\CLIPS 6.4.2\CLIPSDOS.exe"
```

Se a API nao iniciar, execute `.\scripts\setup_web.ps1`. Se o front nao iniciar, confirme que `frontend/node_modules/` existe. O sistema e academico, nao realiza diagnostico medico real e nao recomenda conduta clinica.
