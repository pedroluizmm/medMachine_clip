(deffunction executar-testes-negativos ()
    (assert-equals 1 (contar-suspeita-clinica NegA dengue) "Caso A gera suspeita clinica de dengue")
    (assert-equals 0 (contar-suspeita-reforcada NegA dengue) "Caso A nao gera suspeita reforcada de dengue")
    (assert-equals 0 (contar-alerta NegA sinal-alarme-dengue) "Caso A nao gera alerta de dengue")

    (assert-equals 1 (contar-vinculo NegB dengue) "Caso B gera vinculo epidemiologico para dengue")
    (assert-equals 0 (contar-suspeita-clinica NegB dengue) "Caso B nao gera suspeita clinica de dengue")
    (assert-equals 0 (contar-suspeita-reforcada NegB dengue) "Caso B nao gera suspeita reforcada de dengue")
    (assert-equals 0 (contar-alerta NegB sinal-alarme-dengue) "Caso B nao gera alerta de dengue")

    (assert-equals 0 (contar-alerta NegC sinal-alarme-dengue) "Caso C nao gera alerta sinal-alarme-dengue sem suspeita reforcada")
)
