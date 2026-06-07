import { useEffect, useRef, useState } from 'react';
import { Header } from './components/Header';
import { DemoCasesPanel } from './components/DemoCasesPanel';
import { PatientForm } from './components/PatientForm';
import { ResultsPanel } from './components/ResultsPanel';
import { SavedCasesPanel } from './components/SavedCasesPanel';
import { analyzePatient, analyzeSavedCase, deleteSavedCase, getDemoCases, getHealth, getSavedCase, listSavedCases, saveCase } from './services/api';
import type { AnalyzeResponse, DemoCase, HealthResponse, PatientInput, SavedCaseDetail, SavedCaseSummary, SessionHistoryItem } from './types';

const emptyPatient: PatientInput = {
  name: '',
  temperature: 36.8,
  joint_pain: 0,
  symptoms: [],
  history: [],
  exposure: null,
  phase: null,
};

function App() {
  const [patient, setPatient] = useState<PatientInput>(emptyPatient);
  const [result, setResult] = useState<AnalyzeResponse | null>(null);
  const [health, setHealth] = useState<HealthResponse | null>(null);
  const [checking, setChecking] = useState(true);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [simulated, setSimulated] = useState(false);
  const [history, setHistory] = useState<SessionHistoryItem[]>([]);
  const [activeHistoryId, setActiveHistoryId] = useState<string | null>(null);
  const [demoCases, setDemoCases] = useState<DemoCase[]>([]);
  const [savedCases, setSavedCases] = useState<SavedCaseSummary[]>([]);
  const [savedDetail, setSavedDetail] = useState<SavedCaseDetail | null>(null);
  const [savedLoading, setSavedLoading] = useState(false);
  const [saveMessage, setSaveMessage] = useState<string | null>(null);
  const [saving, setSaving] = useState(false);
  const nameInputRef = useRef<HTMLInputElement>(null);

  useEffect(() => {
    getHealth()
      .then(setHealth)
      .catch(() => setHealth({ status: 'unavailable', clips: { available: false, executable: null } }))
      .finally(() => setChecking(false));
    getDemoCases().then(setDemoCases).catch(() => setDemoCases([]));
    refreshSavedCases();
  }, []);

  useEffect(() => {
    if (!saveMessage) return;
    const timeout = window.setTimeout(() => setSaveMessage(null), 4500);
    return () => window.clearTimeout(timeout);
  }, [saveMessage]);

  function addHistory(analysis: AnalyzeResponse, source: string) {
    const item: SessionHistoryItem = {
      id: analysis.request_id,
      analyzed_at: new Date().toISOString(),
      result: analysis,
      source,
    };
    setHistory((current) => [item, ...current.filter((entry) => entry.id !== item.id)].slice(0, 10));
    setActiveHistoryId(item.id);
  }

  async function submit(source = 'Formulario', input = patient) {
    setLoading(true);
    setError(null);
    try {
      const analysis = await analyzePatient(input);
      setResult(analysis);
      addHistory(analysis, source);
    } catch (caught) {
      setError(caught instanceof Error ? caught.message : 'Erro inesperado ao analisar paciente');
    } finally {
      setLoading(false);
    }
  }

  async function refreshSavedCases(clearMessage = true) {
    if (clearMessage) {
      setSaveMessage(null);
    }
    setSavedLoading(true);
    try {
      setSavedCases(await listSavedCases());
    } catch {
      setSaveMessage('Nao foi possivel carregar casos salvos.');
    } finally {
      setSavedLoading(false);
    }
  }

  async function saveCurrentCase() {
    if (!result) return;
    setSaving(true);
    setSaveMessage(null);
    try {
      const saved = await saveCase(result);
      setSaveMessage(`Caso salvo em CLP. Arquivo: ${saved.filename}`);
      await refreshSavedCases(false);
    } catch (caught) {
      setSaveMessage(caught instanceof Error ? caught.message : 'Erro ao salvar caso em CLP');
    } finally {
      setSaving(false);
    }
  }

  async function viewSavedCase(caseId: string) {
    setSavedDetail(await getSavedCase(caseId));
  }

  async function rerunSavedCase(caseId: string) {
    setLoading(true);
    setError(null);
    try {
      const analysis = await analyzeSavedCase(caseId);
      setResult(analysis);
      addHistory(analysis, 'Caso CLP salvo');
    } catch (caught) {
      setError(caught instanceof Error ? caught.message : 'Erro ao reexecutar caso salvo');
    } finally {
      setLoading(false);
    }
  }

  async function removeSavedCase(caseId: string) {
    if (!window.confirm('Excluir permanentemente este arquivo CLP?')) return;
    await deleteSavedCase(caseId);
    setSavedDetail(null);
    await refreshSavedCases();
  }

  function loadDemoCase(demo: DemoCase) {
    setPatient({
      name: demo.name,
      temperature: demo.temperature,
      joint_pain: demo.joint_pain,
      symptoms: demo.symptoms,
      history: demo.history,
      exposure: demo.exposure,
      phase: demo.phase,
    });
    setResult(null);
    setError(null);
  }

  function simulateTemperature() {
    const value = Number((35 + Math.random() * 6.5).toFixed(1));
    setPatient({ ...patient, temperature: value });
    setSimulated(true);
  }

  function updatePatient(next: PatientInput) {
    setPatient(next);
    setSimulated(false);
  }

  function clearForm() {
    setPatient(emptyPatient);
    setSimulated(false);
  }

  function startNewAnalysis() {
    clearForm();
    setResult(null);
    setError(null);
    setActiveHistoryId(null);
    window.setTimeout(() => nameInputRef.current?.focus(), 0);
  }

  return (
    <main className="app-shell">
      <Header health={health} checking={checking} />
      <div className="dashboard-grid">
        <PatientForm
          nameInputRef={nameInputRef}
          value={patient}
          simulated={simulated}
          disabled={loading || checking || !health?.clips.available}
          loading={loading}
          onChange={updatePatient}
          onSubmit={() => submit()}
          onClear={clearForm}
          onSimulateTemperature={simulateTemperature}
        />
        <ResultsPanel
          result={result}
          loading={loading}
          error={error}
          draft={patient}
          history={history}
          activeHistoryId={activeHistoryId}
          onRetry={() => submit()}
          onNewAnalysis={startNewAnalysis}
          onSaveCase={saveCurrentCase}
          savingCase={saving}
          saveMessage={saveMessage}
          onViewHistory={(item) => {
            setResult(item.result);
            setError(null);
            setActiveHistoryId(item.id);
          }}
          onClearHistory={() => {
            setHistory([]);
            setActiveHistoryId(null);
          }}
        />
      </div>
      <div className="secondary-grid">
        <DemoCasesPanel cases={demoCases} onLoad={loadDemoCase} onAnalyze={(demo) => submit('facts_demo.clp', demo)} />
        <SavedCasesPanel
          cases={savedCases}
          detail={savedDetail}
          loading={savedLoading}
          message={saveMessage}
          onView={viewSavedCase}
          onAnalyze={rerunSavedCase}
          onDelete={removeSavedCase}
          onRefresh={refreshSavedCases}
        />
      </div>
    </main>
  );
}

export default App;
