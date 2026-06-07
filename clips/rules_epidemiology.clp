(defrule vinculo-oropouche-maruim
    (exposicao (paciente ?paciente) (tipo vetor) (valor maruim))
    (not (vinculo-epidemiologico (paciente ?paciente) (doenca oropouche)))
    =>
    (assert (vinculo-epidemiologico (paciente ?paciente) (doenca oropouche)))
)

(defrule vinculo-dengue-area-endemica
    (exposicao (paciente ?paciente) (tipo viagem) (valor area-endemica-dengue))
    (not (vinculo-epidemiologico (paciente ?paciente) (doenca dengue)))
    =>
    (assert (vinculo-epidemiologico (paciente ?paciente) (doenca dengue)))
)

(defrule vinculo-chikungunya-surto-local
    (exposicao (paciente ?paciente) (tipo surto-local) (valor chikungunya))
    (not (vinculo-epidemiologico (paciente ?paciente) (doenca chikungunya)))
    =>
    (assert (vinculo-epidemiologico (paciente ?paciente) (doenca chikungunya)))
)

(defrule vinculo-dengue-aedes
    (exposicao (paciente ?paciente) (tipo vetor) (valor aedes))
    (not (vinculo-epidemiologico (paciente ?paciente) (doenca dengue)))
    =>
    (assert (vinculo-epidemiologico (paciente ?paciente) (doenca dengue)))
)

(defrule vinculo-chikungunya-aedes
    (exposicao (paciente ?paciente) (tipo vetor) (valor aedes))
    (not (vinculo-epidemiologico (paciente ?paciente) (doenca chikungunya)))
    =>
    (assert (vinculo-epidemiologico (paciente ?paciente) (doenca chikungunya)))
)

(defrule vinculo-zika-aedes
    (exposicao (paciente ?paciente) (tipo vetor) (valor aedes))
    (not (vinculo-epidemiologico (paciente ?paciente) (doenca zika)))
    =>
    (assert (vinculo-epidemiologico (paciente ?paciente) (doenca zika)))
)
