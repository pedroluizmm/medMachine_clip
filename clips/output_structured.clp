(deffunction limpar-delimitador (?texto)
    (return ?texto)
)

(deffunction imprimir-resultado-estruturado ()
    (printout t "@@RESULT_START" crlf)

    (do-for-all-facts ((?t intensidade-temperatura)) TRUE
        (printout t "TEMPERATURE_INTENSITY|" ?t:paciente "|" ?t:nivel crlf))

    (do-for-all-facts ((?d intensidade-dor-articular)) TRUE
        (printout t "JOINT_PAIN_INTENSITY|" ?d:paciente "|" ?d:nivel crlf))

    (do-for-all-facts ((?s suspeita-clinica)) TRUE
        (printout t "CLINICAL_SUSPICION|" ?s:paciente "|" ?s:doenca crlf))

    (do-for-all-facts ((?v vinculo-epidemiologico)) TRUE
        (printout t "EPIDEMIOLOGICAL_LINK|" ?v:paciente "|" ?v:doenca crlf))

    (do-for-all-facts ((?r suspeita-reforcada)) TRUE
        (printout t "REINFORCED_SUSPICION|" ?r:paciente "|" ?r:doenca crlf))

    (do-for-all-facts ((?a alerta)) TRUE
        (printout t "ALERT|" ?a:paciente "|" ?a:tipo "|" ?a:nivel "|" (limpar-delimitador ?a:justificativa) crlf))

    (do-for-all-facts ((?e explicacao)) TRUE
        (printout t "EXPLANATION|" ?e:paciente "|" ?e:etapa "|" ?e:regra "|" (limpar-delimitador ?e:titulo) "|" (limpar-delimitador ?e:detalhe) crlf))

    (printout t "@@RESULT_END" crlf)
)
