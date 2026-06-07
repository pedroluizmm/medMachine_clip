(defrule classificar-temperatura-baixa
    (paciente (nome ?paciente) (temperatura ?temperatura&:(< ?temperatura 38.0)))
    (not (intensidade-temperatura (paciente ?paciente)))
    =>
    (assert (intensidade-temperatura (paciente ?paciente) (nivel baixa)))
)

(defrule classificar-temperatura-moderada
    (paciente (nome ?paciente) (temperatura ?temperatura&:(and (>= ?temperatura 38.0) (<= ?temperatura 39.0))))
    (not (intensidade-temperatura (paciente ?paciente)))
    =>
    (assert (intensidade-temperatura (paciente ?paciente) (nivel moderada)))
)

(defrule classificar-temperatura-alta
    (paciente (nome ?paciente) (temperatura ?temperatura&:(> ?temperatura 39.0)))
    (not (intensidade-temperatura (paciente ?paciente)))
    =>
    (assert (intensidade-temperatura (paciente ?paciente) (nivel alta)))
)

(defrule classificar-dor-articular-leve
    (paciente (nome ?paciente) (dor-articular ?dor&:(and (>= ?dor 0) (<= ?dor 3))))
    (not (intensidade-dor-articular (paciente ?paciente)))
    =>
    (assert (intensidade-dor-articular (paciente ?paciente) (nivel leve)))
)

(defrule classificar-dor-articular-moderada
    (paciente (nome ?paciente) (dor-articular ?dor&:(and (>= ?dor 4) (<= ?dor 7))))
    (not (intensidade-dor-articular (paciente ?paciente)))
    =>
    (assert (intensidade-dor-articular (paciente ?paciente) (nivel moderada)))
)

(defrule classificar-dor-articular-extrema
    (paciente (nome ?paciente) (dor-articular ?dor&:(and (>= ?dor 8) (<= ?dor 10))))
    (not (intensidade-dor-articular (paciente ?paciente)))
    =>
    (assert (intensidade-dor-articular (paciente ?paciente) (nivel extrema)))
)
