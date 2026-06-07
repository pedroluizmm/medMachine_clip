(deftemplate explicacao
    (slot paciente)
    (slot etapa)
    (slot regra)
    (slot titulo)
    (slot detalhe)
)

(defrule explicar-temperatura-baixa
    (intensidade-temperatura (paciente ?paciente) (nivel baixa))
    (not (explicacao (paciente ?paciente) (etapa classificacao-temperatura)))
    =>
    (assert (explicacao
        (paciente ?paciente)
        (etapa classificacao-temperatura)
        (regra classificar-temperatura-baixa)
        (titulo "Temperatura categorizada")
        (detalhe "O CLIPS classificou a temperatura como baixa.")))
)

(defrule explicar-temperatura-moderada
    (intensidade-temperatura (paciente ?paciente) (nivel moderada))
    (not (explicacao (paciente ?paciente) (etapa classificacao-temperatura)))
    =>
    (assert (explicacao
        (paciente ?paciente)
        (etapa classificacao-temperatura)
        (regra classificar-temperatura-moderada)
        (titulo "Temperatura categorizada")
        (detalhe "O CLIPS classificou a temperatura como moderada.")))
)

(defrule explicar-temperatura-alta
    (intensidade-temperatura (paciente ?paciente) (nivel alta))
    (not (explicacao (paciente ?paciente) (etapa classificacao-temperatura)))
    =>
    (assert (explicacao
        (paciente ?paciente)
        (etapa classificacao-temperatura)
        (regra classificar-temperatura-alta)
        (titulo "Temperatura categorizada")
        (detalhe "O CLIPS classificou a temperatura como alta.")))
)

(defrule explicar-dor-leve
    (intensidade-dor-articular (paciente ?paciente) (nivel leve))
    (not (explicacao (paciente ?paciente) (etapa classificacao-dor)))
    =>
    (assert (explicacao
        (paciente ?paciente)
        (etapa classificacao-dor)
        (regra classificar-dor-articular-leve)
        (titulo "Dor articular categorizada")
        (detalhe "O CLIPS classificou a dor articular como leve.")))
)

(defrule explicar-dor-moderada
    (intensidade-dor-articular (paciente ?paciente) (nivel moderada))
    (not (explicacao (paciente ?paciente) (etapa classificacao-dor)))
    =>
    (assert (explicacao
        (paciente ?paciente)
        (etapa classificacao-dor)
        (regra classificar-dor-articular-moderada)
        (titulo "Dor articular categorizada")
        (detalhe "O CLIPS classificou a dor articular como moderada.")))
)

(defrule explicar-dor-extrema
    (intensidade-dor-articular (paciente ?paciente) (nivel extrema))
    (not (explicacao (paciente ?paciente) (etapa classificacao-dor)))
    =>
    (assert (explicacao
        (paciente ?paciente)
        (etapa classificacao-dor)
        (regra classificar-dor-articular-extrema)
        (titulo "Dor articular categorizada")
        (detalhe "O CLIPS classificou a dor articular como extrema.")))
)

(defrule explicar-vinculo
    (vinculo-epidemiologico (paciente ?paciente) (doenca ?doenca))
    (not (explicacao (paciente ?paciente) (etapa vinculo-epidemiologico) (regra ?doenca)))
    =>
    (assert (explicacao
        (paciente ?paciente)
        (etapa vinculo-epidemiologico)
        (regra ?doenca)
        (titulo "Vinculo epidemiologico derivado")
        (detalhe (str-cat "O CLIPS derivou vinculo epidemiologico com " ?doenca "."))))
)

(defrule explicar-suspeita-clinica
    (suspeita-clinica (paciente ?paciente) (doenca ?doenca))
    (not (explicacao (paciente ?paciente) (etapa suspeita-clinica) (regra ?doenca)))
    =>
    (assert (explicacao
        (paciente ?paciente)
        (etapa suspeita-clinica)
        (regra ?doenca)
        (titulo "Suspeita clinica derivada")
        (detalhe (str-cat "O CLIPS derivou suspeita clinica de " ?doenca "."))))
)

(defrule explicar-suspeita-reforcada
    (suspeita-reforcada (paciente ?paciente) (doenca ?doenca))
    (not (explicacao (paciente ?paciente) (etapa suspeita-reforcada) (regra ?doenca)))
    =>
    (assert (explicacao
        (paciente ?paciente)
        (etapa suspeita-reforcada)
        (regra gerar-suspeita-reforcada)
        (titulo "Suspeita reforcada derivada")
        (detalhe (str-cat "O CLIPS combinou suspeita clinica e vinculo epidemiologico para " ?doenca "."))))
)

(defrule explicar-alerta
    (alerta (paciente ?paciente) (tipo ?tipo) (nivel ?nivel) (justificativa ?justificativa))
    (not (explicacao (paciente ?paciente) (etapa alerta) (regra ?tipo)))
    =>
    (assert (explicacao
        (paciente ?paciente)
        (etapa alerta)
        (regra ?tipo)
        (titulo "Alerta de triagem derivado")
        (detalhe ?justificativa)))
)
