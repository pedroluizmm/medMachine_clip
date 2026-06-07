import type { ReactNode } from 'react';
import type { AnalyzeResponse, PatientInput, SessionHistoryItem } from '../types';
import { AlertCard } from './AlertCard';
import { EmptyResults } from './EmptyResults';
import { InferenceTimeline } from './InferenceTimeline';
import { SessionHistory } from './SessionHistory';
import { TechnicalDetails } from './TechnicalDetails';

type Props = {
  result: AnalyzeResponse | null;
  loading: boolean;
  error: string | null;
  draft: PatientInput;
  history: SessionHistoryItem[];
  activeHistoryId: string | null;
  onRetry: () => void;
  onNewAnalysis: () => void;
  onSaveCase: () => void;
  savingCase: boolean;
  saveMessage: string | null;
  onViewHistory: (item: SessionHistoryItem) => void;
  onClearHistory: () => void;
};

function Chip({ children }: { children: ReactNode }) {
  return <span className="chip">{children}</span>;
}

function ResultContent({
  result,
  draft,
  onNewAnalysis,
  onSaveCase,
  savingCase,
  saveMessage,
}: {
  result: AnalyzeResponse;
  draft: PatientInput;
  onNewAnalysis: () => void;
  onSaveCase: () => void;
  savingCase: boolean;
  saveMessage: string | null;
}) {
  return (
    <>
      <div className="results-toolbar">
        <div>
          <p className="eyebrow dark">Analise academica</p>
          <h2>Resultados</h2>
        </div>
        <button type="button" className="secondary-button" onClick={onNewAnalysis}>
          Analisar outro paciente
        </button>
        <button type="button" onClick={onSaveCase} disabled={savingCase}>
          {savingCase ? 'Salvando caso...' : 'Salvar caso em CLP'}
        </button>
      </div>
      {saveMessage && <p className="save-message">{saveMessage}</p>}

      <section className="result-card">
        <h3>Resumo do paciente</h3>
        <div className="summary-grid">
          <div>
            <span>Paciente</span>
            <strong>{result.patient.name}</strong>
          </div>
          <div>
            <span>Temperatura</span>
            <strong>{result.patient.temperature.toFixed(1)} °C</strong>
          </div>
          <div>
            <span>Dor articular</span>
            <strong>{result.patient.joint_pain}/10</strong>
          </div>
          <div>
            <span>Exposicao</span>
            <strong>{result.patient.exposure ? `${result.patient.exposure.type}: ${result.patient.exposure.value}` : 'Nao informada'}</strong>
          </div>
        </div>
      </section>

      <section className="result-card">
        <h3>Intensidades</h3>
        <div className="chip-row">
          <Chip>Temperatura: {result.intensities.temperature ?? 'sem categoria'}</Chip>
          <Chip>Dor articular: {result.intensities.joint_pain ?? 'sem categoria'}</Chip>
        </div>
      </section>

      <div className="result-card-grid">
        <section className="result-card">
          <h3>Vinculos epidemiologicos</h3>
          <div className="chip-row">
            {result.epidemiological_links.length ? result.epidemiological_links.map((item) => <Chip key={item}>{item}</Chip>) : <span>Nenhum vinculo epidemiologico derivado.</span>}
          </div>
        </section>
        <section className="result-card">
          <h3>Suspeitas clinicas</h3>
          <div className="chip-row">
            {result.clinical_suspicions.length ? result.clinical_suspicions.map((item) => <Chip key={item}>{item}</Chip>) : <span>Nenhuma suspeita clinica derivada.</span>}
          </div>
        </section>
        <section className="result-card">
          <h3>Suspeitas reforcadas</h3>
          <div className="chip-row">
            {result.reinforced_suspicions.length ? result.reinforced_suspicions.map((item) => <Chip key={item}>{item}</Chip>) : <span>Nenhuma suspeita reforcada derivada.</span>}
          </div>
        </section>
        <section className="result-card">
          <h3>Sintomas analisados</h3>
          <div className="chip-row">{draft.symptoms.length ? draft.symptoms.map((item) => <Chip key={item}>{item}</Chip>) : <span>Nenhum sintoma informado.</span>}</div>
        </section>
      </div>

      <section className="result-card">
        <h3>Alertas de triagem</h3>
        {result.alerts.length ? <div className="alert-grid">{result.alerts.map((alert) => <AlertCard key={alert.type} alert={alert} />)}</div> : <span>Nenhum alerta de triagem derivado.</span>}
      </section>

      <section className="result-card">
        <InferenceTimeline steps={result.inference_steps} />
      </section>
      <TechnicalDetails result={result} />
    </>
  );
}

export function ResultsPanel({
  result,
  loading,
  error,
  draft,
  history,
  activeHistoryId,
  onRetry,
  onNewAnalysis,
  onSaveCase,
  savingCase,
  saveMessage,
  onViewHistory,
  onClearHistory,
}: Props) {
  return (
    <section className="panel results-panel" aria-live="polite">
      {loading && <div className="loading-state">Analisando com CLIPS...</div>}
      {!loading && error && (
        <div className="error-state">
          <h2>Nao foi possivel concluir a analise</h2>
          <p>{error}</p>
          <button type="button" onClick={onRetry}>
            Tentar novamente
          </button>
        </div>
      )}
      {!loading && !error && !result && <EmptyResults />}
      {!loading && !error && result && (
        <ResultContent
          result={result}
          draft={draft}
          onNewAnalysis={onNewAnalysis}
          onSaveCase={onSaveCase}
          savingCase={savingCase}
          saveMessage={saveMessage}
        />
      )}
      <SessionHistory items={history} activeId={activeHistoryId} onView={onViewHistory} onClear={onClearHistory} />
    </section>
  );
}
