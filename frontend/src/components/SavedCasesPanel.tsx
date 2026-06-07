import { savedCaseDownloadUrl } from '../services/api';
import type { SavedCaseDetail, SavedCaseSummary } from '../types';

type Props = {
  cases: SavedCaseSummary[];
  detail: SavedCaseDetail | null;
  loading: boolean;
  message: string | null;
  onView: (caseId: string) => void;
  onAnalyze: (caseId: string) => void;
  onDelete: (caseId: string) => void;
  onRefresh: () => void;
};

export function SavedCasesPanel({ cases, detail, loading, message, onView, onAnalyze, onDelete, onRefresh }: Props) {
  return (
    <section className="panel side-panel">
      <div className="history-header">
        <div className="section-heading">
          <h2>Casos salvos em CLP</h2>
          <p>Arquivos permanentes gerados pelo formulario. Pasta: runtime/exports/react-generated/.</p>
        </div>
        <button type="button" className="ghost-button compact" onClick={onRefresh}>Atualizar</button>
      </div>
      {message && <p className="save-message">{message}</p>}
      {loading && <p className="muted">Carregando casos salvos...</p>}
      {!loading && cases.length === 0 && <p className="muted">Nenhum caso salvo em CLP.</p>}
      <div className="case-list">
        {cases.map((item) => (
          <article key={item.id} className="case-card">
            <strong>{item.display_name}</strong>
            <span>{new Date(item.created_at).toLocaleString()}</span>
            <p>Arquivo: {item.filename}</p>
            <p>Origem: {item.source}</p>
            <p>Suspeitas reforcadas: {item.reinforced_suspicions.length ? item.reinforced_suspicions.join(', ') : 'nenhuma'}</p>
            <p>Alertas: {item.alerts.length ? item.alerts.join(', ') : 'nenhum'}</p>
            <div className="button-row">
              <button type="button" className="secondary-button compact" onClick={() => onView(item.id)}>Visualizar</button>
              <button type="button" className="compact" onClick={() => onAnalyze(item.id)}>Executar novamente</button>
              <a className="button-link compact" href={savedCaseDownloadUrl(item.id)}>Baixar CLP</a>
              <button type="button" className="danger-button compact" onClick={() => onDelete(item.id)}>Excluir</button>
            </div>
          </article>
        ))}
      </div>
      {detail && (
        <details className="technical-details" open>
          <summary>Detalhes do caso salvo</summary>
          <p><strong>Arquivo:</strong> {detail.filename}</p>
          <p><strong>Paciente:</strong> {detail.display_name}</p>
          <pre className="clp-preview">{detail.content}</pre>
        </details>
      )}
    </section>
  );
}
