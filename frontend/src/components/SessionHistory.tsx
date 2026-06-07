import type { SessionHistoryItem } from '../types';

type Props = {
  items: SessionHistoryItem[];
  activeId: string | null;
  onView: (item: SessionHistoryItem) => void;
  onClear: () => void;
};

function strongestAlert(item: SessionHistoryItem) {
  return item.result.alerts[0]?.level ?? 'sem alerta';
}

export function SessionHistory({ items, activeId, onView, onClear }: Props) {
  return (
    <section className="session-history">
      <div className="history-header">
        <div>
          <h3>Analises desta sessao</h3>
          <p>Historico temporario em memoria. Some ao recarregar a pagina.</p>
        </div>
        <button type="button" className="ghost-button" onClick={onClear} disabled={items.length === 0}>
          Limpar historico da sessao
        </button>
      </div>
      {items.length === 0 ? (
        <p className="muted">Nenhuma analise armazenada nesta sessao.</p>
      ) : (
        <div className="history-list">
          {items.map((item) => (
            <article key={item.id} className={`history-item ${activeId === item.id ? 'active' : ''}`}>
              <div>
                <strong>{item.result.patient.name}</strong>
                <span>{new Date(item.analyzed_at).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}</span>
              </div>
              <p>Origem: {item.source}</p>
              <p>
                Suspeitas reforcadas:{' '}
                {item.result.reinforced_suspicions.length ? item.result.reinforced_suspicions.join(', ') : 'nenhuma'}
              </p>
              <p>Alerta: {strongestAlert(item)} ({item.result.alerts.length})</p>
              <button type="button" className="secondary-button compact" onClick={() => onView(item)}>
                Visualizar
              </button>
            </article>
          ))}
        </div>
      )}
    </section>
  );
}
