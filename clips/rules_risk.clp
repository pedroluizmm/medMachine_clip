(defrule alerta-sinal-alarme-dengue
    (suspeita-reforcada (paciente ?paciente) (doenca dengue))
    (fase (paciente ?paciente) (nome critica))
    (sintoma (paciente ?paciente) (nome dor-abdominal))
    (not (alerta (paciente ?paciente) (tipo sinal-alarme-dengue)))
    =>
    (assert
        (alerta
            (paciente ?paciente)
            (tipo sinal-alarme-dengue)
            (nivel vermelho)
            (justificativa "Dor abdominal durante fase critica em caso com suspeita reforcada de dengue.")
        )
    )
)

(defrule alerta-evolucao-articular-prolongada
    (suspeita-reforcada (paciente ?paciente) (doenca chikungunya))
    (fase (paciente ?paciente) (nome subaguda))
    (intensidade-dor-articular (paciente ?paciente) (nivel extrema))
    (not (alerta (paciente ?paciente) (tipo evolucao-articular-prolongada)))
    =>
    (assert
        (alerta
            (paciente ?paciente)
            (tipo evolucao-articular-prolongada)
            (nivel amarelo)
            (justificativa "Dor articular extrema em fase subaguda com suspeita reforcada de chikungunya.")
        )
    )
)

(defrule alerta-acompanhamento-obstetrico
    (suspeita-reforcada (paciente ?paciente) (doenca zika))
    (historico (paciente ?paciente) (condicao gestante))
    (not (alerta (paciente ?paciente) (tipo acompanhamento-obstetrico)))
    =>
    (assert
        (alerta
            (paciente ?paciente)
            (tipo acompanhamento-obstetrico)
            (nivel roxo)
            (justificativa "Gestacao em caso com suspeita reforcada de zika.")
        )
    )
)

(defrule alerta-acompanhamento-recidiva-oropouche
    (suspeita-reforcada (paciente ?paciente) (doenca oropouche))
    (fase (paciente ?paciente) (nome recidiva))
    (not (alerta (paciente ?paciente) (tipo acompanhamento-recidiva-oropouche)))
    =>
    (assert
        (alerta
            (paciente ?paciente)
            (tipo acompanhamento-recidiva-oropouche)
            (nivel laranja)
            (justificativa "Recidiva em caso com suspeita reforcada de Oropouche.")
        )
    )
)
