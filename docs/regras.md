# Regras

## classificar-temperatura-baixa

Premissas: paciente com temperatura menor que 38.0 e sem intensidade de temperatura derivada.

Conclusao: `intensidade-temperatura` nivel `baixa`.

Exemplo: Lucia, com 37.6.

## classificar-temperatura-moderada

Premissas: paciente com temperatura entre 38.0 e 39.0, inclusive, e sem intensidade de temperatura derivada.

Conclusao: `intensidade-temperatura` nivel `moderada`.

Exemplo: Maria e Ana.

## classificar-temperatura-alta

Premissas: paciente com temperatura maior que 39.0 e sem intensidade de temperatura derivada.

Conclusao: `intensidade-temperatura` nivel `alta`.

Exemplo: Joao.

## classificar-dor-articular-leve

Premissas: dor articular de 0 a 3 e sem intensidade de dor derivada.

Conclusao: `intensidade-dor-articular` nivel `leve`.

Exemplo: Joao e Lucia.

## classificar-dor-articular-moderada

Premissas: dor articular de 4 a 7 e sem intensidade de dor derivada.

Conclusao: `intensidade-dor-articular` nivel `moderada`.

Exemplo: Maria.

## classificar-dor-articular-extrema

Premissas: dor articular de 8 a 10 e sem intensidade de dor derivada.

Conclusao: `intensidade-dor-articular` nivel `extrema`.

Exemplo: Ana.

## vinculo-oropouche-maruim

Premissas: exposicao a vetor `maruim`.

Conclusao: vinculo epidemiologico com `oropouche`.

Exemplo: Joao.

## vinculo-dengue-area-endemica

Premissas: viagem para `area-endemica-dengue`.

Conclusao: vinculo epidemiologico com `dengue`.

Exemplo: Maria.

## vinculo-chikungunya-surto-local

Premissas: surto local de `chikungunya`.

Conclusao: vinculo epidemiologico com `chikungunya`.

Exemplo: Ana.

## vinculo-dengue-aedes, vinculo-chikungunya-aedes, vinculo-zika-aedes

Premissas: exposicao ao vetor `aedes`.

Conclusao: vinculos epidemiologicos com dengue, chikungunya e zika.

Exemplo: Lucia.

## suspeita-clinica-dengue

Premissas: temperatura moderada ou alta, sintoma `dor-no-corpo` e sintoma `dor-retrorbital`.

Conclusao: suspeita clinica de `dengue`.

Exemplo: Maria.

## suspeita-clinica-chikungunya

Premissas: temperatura moderada ou alta, dor articular extrema e sintoma `dor-articular-incapacitante`.

Conclusao: suspeita clinica de `chikungunya`.

Exemplo: Ana.

## suspeita-clinica-zika

Premissas: temperatura baixa ou moderada, sintoma `exantema-com-coceira` e sintoma `conjuntivite`.

Conclusao: suspeita clinica de `zika`.

Exemplo: Lucia.

## suspeita-clinica-oropouche

Premissas: temperatura moderada ou alta, sintoma `cefaleia-intensa` e sintoma `fotofobia`.

Conclusao: suspeita clinica de `oropouche`.

Exemplo: Joao.

## gerar-suspeita-reforcada

Premissas: suspeita clinica de uma doenca e vinculo epidemiologico com a mesma doenca.

Conclusao: suspeita reforcada para a doenca.

Exemplo: todos os quatro pacientes demonstrativos.

## alerta-sinal-alarme-dengue

Premissas: suspeita reforcada de dengue, fase critica e dor abdominal.

Conclusao: alerta `sinal-alarme-dengue` nivel `vermelho`.

Exemplo: Maria.

## alerta-evolucao-articular-prolongada

Premissas: suspeita reforcada de chikungunya, fase subaguda e dor articular extrema.

Conclusao: alerta `evolucao-articular-prolongada` nivel `amarelo`.

Exemplo: Ana.

## alerta-acompanhamento-obstetrico

Premissas: suspeita reforcada de zika e historico de gestacao.

Conclusao: alerta `acompanhamento-obstetrico` nivel `roxo`.

Exemplo: Lucia.

## alerta-acompanhamento-recidiva-oropouche

Premissas: suspeita reforcada de Oropouche e fase de recidiva.

Conclusao: alerta `acompanhamento-recidiva-oropouche` nivel `laranja`.

Exemplo: Joao.
