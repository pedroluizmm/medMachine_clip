;;; Templates da base de conhecimento.
;;; Identificadores em kebab-case e sem acentos.

(deftemplate paciente
    (slot nome)
    (slot temperatura (type NUMBER))
    (slot dor-articular (type INTEGER))
)

(deftemplate sintoma
    (slot paciente)
    (slot nome)
)

(deftemplate historico
    (slot paciente)
    (slot condicao)
)

(deftemplate exposicao
    (slot paciente)
    (slot tipo)
    (slot valor)
)

(deftemplate fase
    (slot paciente)
    (slot nome)
)

(deftemplate intensidade-temperatura
    (slot paciente)
    (slot nivel)
)

(deftemplate intensidade-dor-articular
    (slot paciente)
    (slot nivel)
)

(deftemplate vinculo-epidemiologico
    (slot paciente)
    (slot doenca)
)

(deftemplate suspeita-clinica
    (slot paciente)
    (slot doenca)
)

(deftemplate suspeita-reforcada
    (slot paciente)
    (slot doenca)
)

(deftemplate alerta
    (slot paciente)
    (slot tipo)
    (slot nivel)
    (slot justificativa)
)
