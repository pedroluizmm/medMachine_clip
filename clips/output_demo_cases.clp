(load "clips/templates.clp")
(load "clips/facts_demo.clp")

(reset)

(printout t "@@DEMO_CASES_START" crlf)

(do-for-all-facts ((?p paciente)) TRUE
    (printout t "PATIENT|" ?p:nome "|" ?p:temperatura "|" ?p:dor-articular crlf))

(do-for-all-facts ((?s sintoma)) TRUE
    (printout t "SYMPTOM|" ?s:paciente "|" ?s:nome crlf))

(do-for-all-facts ((?h historico)) TRUE
    (printout t "HISTORY|" ?h:paciente "|" ?h:condicao crlf))

(do-for-all-facts ((?e exposicao)) TRUE
    (printout t "EXPOSURE|" ?e:paciente "|" ?e:tipo "|" ?e:valor crlf))

(do-for-all-facts ((?f fase)) TRUE
    (printout t "PHASE|" ?f:paciente "|" ?f:nome crlf))

(printout t "@@DEMO_CASES_END" crlf)
(exit)
