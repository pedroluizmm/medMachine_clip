import type { DemoCase } from '../types';

type Props = {
  cases: DemoCase[];
  onLoad: (demo: DemoCase) => void;
  onAnalyze: (demo: DemoCase) => void;
};

export function DemoCasesPanel({ cases, onLoad, onAnalyze }: Props) {
  return (
    <section className="panel side-panel">
      <div className="section-heading">
        <h2>Casos de demonstracao</h2>
        <p>Casos fixos do projeto. Origem: clips/facts_demo.clp.</p>
      </div>
      <div className="case-list">
        {cases.map((demo) => (
          <article key={demo.id} className="case-card">
            <strong>{demo.name}</strong>
            <span>{demo.temperature.toFixed(1)} °C · dor {demo.joint_pain}/10</span>
            <p>Sintomas: {demo.symptoms.length ? demo.symptoms.join(', ') : 'nenhum'}</p>
            <p>Exposicao: {demo.exposure ? `${demo.exposure.type}: ${demo.exposure.value}` : 'nao informada'}</p>
            <p>Fase: {demo.phase ?? 'nao informada'}</p>
            <small>Origem: {demo.source}</small>
            <div className="button-row">
              <button type="button" className="secondary-button compact" onClick={() => onLoad(demo)}>Carregar no formulario</button>
              <button type="button" className="compact" onClick={() => onAnalyze(demo)}>Executar analise</button>
            </div>
          </article>
        ))}
      </div>
    </section>
  );
}
