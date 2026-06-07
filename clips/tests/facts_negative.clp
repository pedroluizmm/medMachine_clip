(deffacts casos-negativos
    (paciente (nome NegA) (temperatura 38.5) (dor-articular 2))
    (sintoma (paciente NegA) (nome dor-no-corpo))
    (sintoma (paciente NegA) (nome dor-retrorbital))

    (paciente (nome NegB) (temperatura 36.8) (dor-articular 1))
    (exposicao (paciente NegB) (tipo vetor) (valor aedes))

    (paciente (nome NegC) (temperatura 37.0) (dor-articular 1))
    (sintoma (paciente NegC) (nome dor-abdominal))
    (fase (paciente NegC) (nome critica))
)
