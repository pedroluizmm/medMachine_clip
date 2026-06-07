import type { AnalyzeResponse } from '../types';

export function TechnicalDetails({ result }: { result: AnalyzeResponse }) {
  return (
    <details className="technical-details">
      <summary>Como o CLIPS chegou ao resultado?</summary>
      <div className="technical-grid">
        <div>
          <strong>Motor</strong>
          <p>{result.engine.name}</p>
        </div>
        <div>
          <strong>Execucao</strong>
          <p>{result.engine.execution}</p>
        </div>
        <div>
          <strong>Estrategia</strong>
          <p>{result.engine.strategy}</p>
        </div>
        <div>
          <strong>Identificador tecnico</strong>
          <p>{result.patient.id}</p>
        </div>
      </div>
      <ul className="rule-list">
        {result.inference_steps.map((step) => (
          <li key={`${step.stage}-${step.rule}-${step.detail}`}>
            <code>{step.rule}</code>
            <span>{step.stage}</span>
            <p>{step.detail}</p>
          </li>
        ))}
      </ul>
    </details>
  );
}
