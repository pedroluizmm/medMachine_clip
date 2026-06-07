import type { AnalyzeResponse, DemoCase, HealthResponse, PatientInput, SavedCaseDetail, SavedCaseSummary } from '../types';

const API_BASE = import.meta.env.VITE_API_URL ?? 'http://127.0.0.1:8000';

export async function getHealth(): Promise<HealthResponse> {
  const response = await fetch(`${API_BASE}/api/health`);
  if (!response.ok) {
    throw new Error('API indisponivel');
  }
  return response.json();
}

export async function analyzePatient(payload: PatientInput): Promise<AnalyzeResponse> {
  const response = await fetch(`${API_BASE}/api/analyze`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(payload),
  });
  if (!response.ok) {
    const detail = await response.json().catch(() => null);
    throw new Error(detail?.detail ?? 'Erro ao analisar paciente');
  }
  return response.json();
}

export async function getDemoCases(): Promise<DemoCase[]> {
  const response = await fetch(`${API_BASE}/api/demo-cases`);
  if (!response.ok) throw new Error('Erro ao carregar casos de demonstracao');
  return response.json();
}

export async function listSavedCases(): Promise<SavedCaseSummary[]> {
  const response = await fetch(`${API_BASE}/api/saved-cases`);
  if (!response.ok) throw new Error('Erro ao carregar casos salvos');
  return response.json();
}

export async function saveCase(result: AnalyzeResponse): Promise<SavedCaseSummary> {
  const response = await fetch(`${API_BASE}/api/saved-cases`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      request_id: result.request_id,
      patient: {
        name: result.patient.name,
        temperature: result.patient.temperature,
        joint_pain: result.patient.joint_pain,
        symptoms: result.patient.symptoms,
        history: result.patient.history,
        exposure: result.patient.exposure,
        phase: result.patient.phase,
      },
      analysis_summary: {
        reinforced_suspicions: result.reinforced_suspicions,
        alerts: result.alerts.map((alert) => alert.type),
      },
    }),
  });
  if (!response.ok) throw new Error('Erro ao salvar caso em CLP');
  return response.json();
}

export async function getSavedCase(caseId: string): Promise<SavedCaseDetail> {
  const response = await fetch(`${API_BASE}/api/saved-cases/${caseId}`);
  if (!response.ok) throw new Error('Erro ao visualizar caso salvo');
  return response.json();
}

export async function analyzeSavedCase(caseId: string): Promise<AnalyzeResponse> {
  const response = await fetch(`${API_BASE}/api/saved-cases/${caseId}/analyze`, { method: 'POST' });
  if (!response.ok) throw new Error('Erro ao reexecutar caso salvo');
  return response.json();
}

export async function deleteSavedCase(caseId: string): Promise<void> {
  const response = await fetch(`${API_BASE}/api/saved-cases/${caseId}`, { method: 'DELETE' });
  if (!response.ok) throw new Error('Erro ao excluir caso salvo');
}

export function savedCaseDownloadUrl(caseId: string): string {
  return `${API_BASE}/api/saved-cases/${caseId}/download`;
}
