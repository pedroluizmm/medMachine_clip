export type Exposure = {
  type: 'vetor' | 'viagem' | 'surto-local';
  value: string;
};

export type PatientInput = {
  name: string;
  temperature: number;
  joint_pain: number;
  symptoms: string[];
  history: string[];
  exposure: Exposure | null;
  phase: string | null;
};

export type DemoCase = PatientInput & {
  id: string;
  source: string;
};

export type AlertResult = {
  type: string;
  level: string;
  justification: string;
};

export type InferenceStep = {
  stage: string;
  rule: string;
  title: string;
  detail: string;
};

export type AnalyzeResponse = {
  request_id: string;
  patient: PatientInput & { id: string };
  intensities: {
    temperature: string | null;
    joint_pain: string | null;
  };
  clinical_suspicions: string[];
  epidemiological_links: string[];
  reinforced_suspicions: string[];
  alerts: AlertResult[];
  inference_steps: InferenceStep[];
  engine: {
    name: string;
    execution: string;
    strategy: string;
  };
};

export type HealthResponse = {
  status: string;
  clips: {
    available: boolean;
    executable: string | null;
  };
};

export type SessionHistoryItem = {
  id: string;
  analyzed_at: string;
  result: AnalyzeResponse;
  source: string;
};

export type SavedCaseSummary = {
  id: string;
  display_name: string;
  created_at: string;
  filename: string;
  source: string;
  reinforced_suspicions: string[];
  alerts: string[];
  download_url?: string;
};

export type SavedCaseDetail = SavedCaseSummary & {
  patient: PatientInput & { id: string };
  content: string;
};
