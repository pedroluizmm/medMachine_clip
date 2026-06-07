import type { AlertResult } from '../types';

export function AlertCard({ alert }: { alert: AlertResult }) {
  return (
    <article className={`alert-card ${alert.level}`}>
      <div className="alert-heading">
        <strong>Nivel {alert.level}</strong>
        <span>{alert.type}</span>
      </div>
      <p>{alert.justification}</p>
      <small>Resultado academico gerado pelo CLIPS.</small>
    </article>
  );
}
