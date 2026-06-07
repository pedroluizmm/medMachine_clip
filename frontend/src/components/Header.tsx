import type { HealthResponse } from '../types';

type Props = {
  health: HealthResponse | null;
  checking: boolean;
};

export function Header({ health, checking }: Props) {
  const label = checking ? 'Verificando motor...' : health?.clips.available ? 'CLIPS disponivel' : 'CLIPS indisponivel';
  const statusClass = checking ? 'checking' : health?.clips.available ? 'ok' : 'bad';

  return (
    <header className="app-header">
      <div className="header-copy">
        <p className="eyebrow">Analise academica</p>
        <h1>Sistema Especialista de Triagem de Arboviroses</h1>
        <p>Demonstracao academica de inferencia simbolica com CLIPS.</p>
      </div>
      <aside className="status-block" aria-live="polite">
        <div className="status-line">
          <span className={`status-dot ${statusClass}`} />
          <strong>{label}</strong>
        </div>
        <small>Este sistema nao realiza diagnostico medico real.</small>
      </aside>
    </header>
  );
}
