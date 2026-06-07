(deffunction doenca-label (?doenca)
    (if (eq ?doenca dengue) then (return "DENGUE"))
    (if (eq ?doenca chikungunya) then (return "CHIKUNGUNYA"))
    (if (eq ?doenca zika) then (return "ZIKA"))
    (if (eq ?doenca oropouche) then (return "OROPOUCHE"))
    (return ?doenca)
)

(deffunction alerta-mensagem (?tipo)
    (if (eq ?tipo acompanhamento-recidiva-oropouche) then
        (return "Acompanhamento de recidiva de Oropouche."))
    (if (eq ?tipo sinal-alarme-dengue) then
        (return "Sinal de alarme de dengue: dor abdominal na fase critica."))
    (if (eq ?tipo evolucao-articular-prolongada) then
        (return "Risco de evolucao articular prolongada."))
    (if (eq ?tipo acompanhamento-obstetrico) then
        (return "Recomendacao de acompanhamento obstetrico."))
    (return ?tipo)
)

(deffunction nivel-label (?nivel)
    (if (eq ?nivel laranja) then (return "LARANJA"))
    (if (eq ?nivel vermelho) then (return "VERMELHO"))
    (if (eq ?nivel amarelo) then (return "AMARELO"))
    (if (eq ?nivel roxo) then (return "ROXO"))
    (return ?nivel)
)

(deffunction imprimir-resultados ()
    (printout t crlf "=== SISTEMA ESPECIALISTA DE TRIAGEM DE ARBOVIROSES ===" crlf crlf)
    (printout t "Uso academico: triagem baseada em regras, sem diagnostico medico real." crlf crlf)

    (printout t "INTENSIDADES CATEGORIZADAS" crlf crlf)
    (do-for-all-facts ((?t intensidade-temperatura)) TRUE
        (printout t ?t:paciente " -> temperatura " ?t:nivel crlf))
    (do-for-all-facts ((?d intensidade-dor-articular)) TRUE
        (printout t ?d:paciente " -> dor articular " ?d:nivel crlf))

    (printout t crlf "SUSPEITAS CLINICAS" crlf crlf)
    (do-for-all-facts ((?s suspeita-clinica)) TRUE
        (printout t ?s:paciente " -> " (doenca-label ?s:doenca) crlf))

    (printout t crlf "VINCULOS EPIDEMIOLOGICOS" crlf crlf)
    (do-for-all-facts ((?v vinculo-epidemiologico)) TRUE
        (printout t ?v:paciente " -> " (doenca-label ?v:doenca) crlf))

    (printout t crlf "SUSPEITAS REFORCADAS" crlf crlf)
    (do-for-all-facts ((?r suspeita-reforcada)) TRUE
        (printout t ?r:paciente " -> " (doenca-label ?r:doenca) crlf))

    (printout t crlf "ALERTAS DE TRIAGEM" crlf crlf)
    (do-for-all-facts ((?a alerta)) TRUE
        (printout t "[" (nivel-label ?a:nivel) "] " ?a:paciente crlf)
        (printout t (alerta-mensagem ?a:tipo) crlf)
        (printout t "Justificativa: " ?a:justificativa crlf crlf))
)
