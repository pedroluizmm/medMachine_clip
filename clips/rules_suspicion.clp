(defrule suspeita-clinica-dengue
    (or
        (intensidade-temperatura (paciente ?paciente) (nivel moderada))
        (intensidade-temperatura (paciente ?paciente) (nivel alta))
    )
    (sintoma (paciente ?paciente) (nome dor-no-corpo))
    (sintoma (paciente ?paciente) (nome dor-retrorbital))
    (not (suspeita-clinica (paciente ?paciente) (doenca dengue)))
    =>
    (assert (suspeita-clinica (paciente ?paciente) (doenca dengue)))
)

(defrule suspeita-clinica-chikungunya
    (or
        (intensidade-temperatura (paciente ?paciente) (nivel moderada))
        (intensidade-temperatura (paciente ?paciente) (nivel alta))
    )
    (intensidade-dor-articular (paciente ?paciente) (nivel extrema))
    (sintoma (paciente ?paciente) (nome dor-articular-incapacitante))
    (not (suspeita-clinica (paciente ?paciente) (doenca chikungunya)))
    =>
    (assert (suspeita-clinica (paciente ?paciente) (doenca chikungunya)))
)

(defrule suspeita-clinica-zika
    (or
        (intensidade-temperatura (paciente ?paciente) (nivel baixa))
        (intensidade-temperatura (paciente ?paciente) (nivel moderada))
    )
    (sintoma (paciente ?paciente) (nome exantema-com-coceira))
    (sintoma (paciente ?paciente) (nome conjuntivite))
    (not (suspeita-clinica (paciente ?paciente) (doenca zika)))
    =>
    (assert (suspeita-clinica (paciente ?paciente) (doenca zika)))
)

(defrule suspeita-clinica-oropouche
    (or
        (intensidade-temperatura (paciente ?paciente) (nivel moderada))
        (intensidade-temperatura (paciente ?paciente) (nivel alta))
    )
    (sintoma (paciente ?paciente) (nome cefaleia-intensa))
    (sintoma (paciente ?paciente) (nome fotofobia))
    (not (suspeita-clinica (paciente ?paciente) (doenca oropouche)))
    =>
    (assert (suspeita-clinica (paciente ?paciente) (doenca oropouche)))
)

(defrule gerar-suspeita-reforcada
    (suspeita-clinica (paciente ?paciente) (doenca ?doenca))
    (vinculo-epidemiologico (paciente ?paciente) (doenca ?doenca))
    (not (suspeita-reforcada (paciente ?paciente) (doenca ?doenca)))
    =>
    (assert (suspeita-reforcada (paciente ?paciente) (doenca ?doenca)))
)
