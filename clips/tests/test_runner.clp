(clear)

(batch* "clips/templates.clp")
(batch* "clips/tests/facts_boundaries.clp")
(batch* "clips/tests/facts_negative.clp")
(batch* "clips/rules_classification.clp")
(batch* "clips/rules_epidemiology.clp")
(batch* "clips/rules_suspicion.clp")
(batch* "clips/rules_risk.clp")
(batch* "clips/tests/assertions.clp")
(batch* "clips/tests/test_boundaries.clp")
(batch* "clips/tests/test_negative.clp")
(batch* "clips/tests/test_duplicates.clp")

(reset)
(run)

(executar-testes-limites)
(executar-testes-negativos)
(executar-testes-duplicacao)

(resumo-testes)
