import type { InferenceStep } from '../types';

const stages = [
  ['classificacao-temperatura', 'Temperatura categorizada'],
  ['classificacao-dor', 'Dor articular categorizada'],
  ['vinculo-epidemiologico', 'Vinculo epidemiologico'],
  ['suspeita-clinica', 'Suspeita clinica'],
  ['suspeita-reforcada', 'Suspeita reforcada'],
  ['alerta', 'Alerta de triagem'],
];

export function InferenceTimeline({ steps }: { steps: InferenceStep[] }) {
  return (
    <section className="timeline">
      <h3>Cadeia de inferencia</h3>
      <div className="timeline-list">
        <div className="timeline-item complete">
          <span className="timeline-number">1</span>
          <div>
            <strong>Dados recebidos</strong>
            <p>O back-end gerou fatos temporarios e executou o CLIPS.</p>
          </div>
        </div>
        {stages.map(([stage, label], index) => {
          const matches = steps.filter((step) => step.stage === stage);
          return (
            <div key={stage} className={`timeline-item ${matches.length ? 'complete' : 'empty-step'}`}>
              <span className="timeline-number">{index + 2}</span>
              <div>
                <strong>{label}</strong>
                {matches.length === 0 ? (
                  <p>Nenhuma conclusao produzida nesta etapa.</p>
                ) : (
                  matches.map((step) => (
                    <p key={`${step.stage}-${step.rule}-${step.detail}`}>
                      {step.title}: {step.detail}
                    </p>
                  ))
                )}
              </div>
            </div>
          );
        })}
      </div>
    </section>
  );
}
