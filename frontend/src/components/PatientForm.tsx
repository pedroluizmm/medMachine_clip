import type { RefObject } from 'react';
import type { PatientInput } from '../types';
import { ExposureSelector } from './ExposureSelector';
import { FormSection } from './FormSection';
import { PainControl } from './PainControl';
import { SymptomsSelector } from './SymptomsSelector';
import { TemperatureControl } from './TemperatureControl';

type Props = {
  nameInputRef: RefObject<HTMLInputElement | null>;
  value: PatientInput;
  simulated: boolean;
  disabled: boolean;
  loading: boolean;
  onChange: (value: PatientInput) => void;
  onSubmit: () => void;
  onClear: () => void;
  onSimulateTemperature: () => void;
};

export function PatientForm({
  nameInputRef,
  value,
  simulated,
  disabled,
  loading,
  onChange,
  onSubmit,
  onClear,
  onSimulateTemperature,
}: Props) {
  const canSubmit = value.name.trim().length > 0 && !disabled;

  return (
    <form
      className="panel form-panel"
      onSubmit={(event) => {
        event.preventDefault();
        onSubmit();
      }}
    >
      <h2>Dados do paciente</h2>

      <FormSection title="1. Identificacao" description="Use um nome de exibicao para esta analise academica.">
        <label className="field-group" htmlFor="patient-name">
          <span>Nome</span>
          <input
            ref={nameInputRef}
            id="patient-name"
            type="text"
            maxLength={80}
            value={value.name}
            onChange={(event) => onChange({ ...value, name: event.target.value })}
            placeholder="Ex.: Carlos Silva"
          />
        </label>
      </FormSection>

      <FormSection title="2. Sinais mensuraveis">
        <TemperatureControl
          value={value.temperature}
          simulated={simulated}
          onSimulate={onSimulateTemperature}
          onChange={(temperature) => onChange({ ...value, temperature })}
        />
        <PainControl value={value.joint_pain} onChange={(joint_pain) => onChange({ ...value, joint_pain })} />
      </FormSection>

      <FormSection title="3. Sintomas" description="Selecione apenas sinais observados. O CLIPS faz a inferencia.">
        <SymptomsSelector selected={value.symptoms} onChange={(symptoms) => onChange({ ...value, symptoms })} />
      </FormSection>

      <FormSection title="4. Contexto epidemiologico">
        <ExposureSelector value={value.exposure} onChange={(exposure) => onChange({ ...value, exposure })} />
      </FormSection>

      <FormSection title="5. Condicoes e fase">
        <section className="field-group">
          <div className="field-title">
            <span>Historico</span>
          </div>
          <label className="checkbox-row large-touch">
            <input
              type="checkbox"
              checked={value.history.includes('gestante')}
              onChange={(event) => onChange({ ...value, history: event.target.checked ? ['gestante'] : [] })}
            />
            <span>Gestante</span>
          </label>
        </section>
        <section className="field-group">
          <label className="field-title" htmlFor="phase">
            <span>Fase</span>
          </label>
          <select id="phase" value={value.phase ?? ''} onChange={(event) => onChange({ ...value, phase: event.target.value || null })}>
            <option value="">Nao informada</option>
            <option value="aguda">Aguda</option>
            <option value="critica">Critica</option>
            <option value="subaguda">Subaguda</option>
            <option value="recidiva">Recidiva</option>
          </select>
        </section>
      </FormSection>

      <div className="button-row actions-row">
        <button type="submit" disabled={!canSubmit}>
          {loading ? 'Analisando com CLIPS...' : 'Analisar paciente'}
        </button>
        <button type="button" className="secondary-button" onClick={onClear}>
          Limpar formulario
        </button>
      </div>
    </form>
  );
}
