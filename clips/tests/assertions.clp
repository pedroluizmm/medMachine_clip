(defglobal
    ?*testes-executados* = 0
    ?*testes-aprovados* = 0
    ?*testes-reprovados* = 0
)

(deffunction registrar-sucesso (?mensagem)
    (bind ?*testes-executados* (+ ?*testes-executados* 1))
    (bind ?*testes-aprovados* (+ ?*testes-aprovados* 1))
    (printout t "[PASSOU] " ?mensagem crlf)
)

(deffunction registrar-falha (?mensagem)
    (bind ?*testes-executados* (+ ?*testes-executados* 1))
    (bind ?*testes-reprovados* (+ ?*testes-reprovados* 1))
    (printout t "[FALHOU] " ?mensagem crlf)
)

(deffunction assert-true (?condicao ?mensagem)
    (if ?condicao
        then (registrar-sucesso ?mensagem)
        else (registrar-falha ?mensagem))
)

(deffunction assert-equals (?esperado ?obtido ?mensagem)
    (if (eq ?esperado ?obtido)
        then (registrar-sucesso ?mensagem)
        else
            (registrar-falha
                (str-cat ?mensagem " | esperado: " ?esperado " | obtido: " ?obtido)))
)

(deffunction contar-temperatura (?paciente)
    (bind ?total 0)
    (do-for-all-facts ((?f intensidade-temperatura)) (eq ?f:paciente ?paciente)
        (bind ?total (+ ?total 1)))
    (return ?total)
)

(deffunction obter-temperatura (?paciente)
    (bind ?nivel nenhum)
    (do-for-all-facts ((?f intensidade-temperatura)) (eq ?f:paciente ?paciente)
        (bind ?nivel ?f:nivel))
    (return ?nivel)
)

(deffunction contar-dor-articular (?paciente)
    (bind ?total 0)
    (do-for-all-facts ((?f intensidade-dor-articular)) (eq ?f:paciente ?paciente)
        (bind ?total (+ ?total 1)))
    (return ?total)
)

(deffunction obter-dor-articular (?paciente)
    (bind ?nivel nenhum)
    (do-for-all-facts ((?f intensidade-dor-articular)) (eq ?f:paciente ?paciente)
        (bind ?nivel ?f:nivel))
    (return ?nivel)
)

(deffunction contar-vinculo (?paciente ?doenca)
    (bind ?total 0)
    (do-for-all-facts ((?f vinculo-epidemiologico))
        (and (eq ?f:paciente ?paciente) (eq ?f:doenca ?doenca))
        (bind ?total (+ ?total 1)))
    (return ?total)
)

(deffunction contar-suspeita-clinica (?paciente ?doenca)
    (bind ?total 0)
    (do-for-all-facts ((?f suspeita-clinica))
        (and (eq ?f:paciente ?paciente) (eq ?f:doenca ?doenca))
        (bind ?total (+ ?total 1)))
    (return ?total)
)

(deffunction contar-suspeita-reforcada (?paciente ?doenca)
    (bind ?total 0)
    (do-for-all-facts ((?f suspeita-reforcada))
        (and (eq ?f:paciente ?paciente) (eq ?f:doenca ?doenca))
        (bind ?total (+ ?total 1)))
    (return ?total)
)

(deffunction contar-alerta (?paciente ?tipo)
    (bind ?total 0)
    (do-for-all-facts ((?f alerta))
        (and (eq ?f:paciente ?paciente) (eq ?f:tipo ?tipo))
        (bind ?total (+ ?total 1)))
    (return ?total)
)

(deffunction resumo-testes ()
    (printout t crlf "TESTES EXECUTADOS: " ?*testes-executados* crlf)
    (printout t "TESTES APROVADOS: " ?*testes-aprovados* crlf)
    (printout t "TESTES REPROVADOS: " ?*testes-reprovados* crlf)
    (if (> ?*testes-reprovados* 0)
        then (printout t "RESULTADO: FALHOU" crlf)
        else (printout t "RESULTADO: PASSOU" crlf))
)
