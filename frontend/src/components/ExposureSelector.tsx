import type { Exposure } from '../types';

const options: Array<{ key: string; label: string; exposure: Exposure | null }> = [
  { key: '', label: 'Nenhuma exposicao informada', exposure: null },
  { key: 'vetor:aedes', label: 'Exposicao ao Aedes', exposure: { type: 'vetor', value: 'aedes' } },
  { key: 'vetor:maruim', label: 'Exposicao ao maruim', exposure: { type: 'vetor', value: 'maruim' } },
  { key: 'viagem:area-endemica-dengue', label: 'Viagem para area endemica de dengue', exposure: { type: 'viagem', value: 'area-endemica-dengue' } },
  { key: 'surto-local:chikungunya', label: 'Surto local de chikungunya', exposure: { type: 'surto-local', value: 'chikungunya' } },
];

type Props = {
  value: Exposure | null;
  onChange: (value: Exposure | null) => void;
};

export function ExposureSelector({ value, onChange }: Props) {
  const key = value ? `${value.type}:${value.value}` : '';
  return (
    <section className="field-group">
      <label className="field-title" htmlFor="exposure">
        <span>Exposicao epidemiologica</span>
      </label>
      <select
        id="exposure"
        value={key}
        onChange={(event) => onChange(options.find((item) => item.key === event.target.value)?.exposure ?? null)}
      >
        {options.map((option) => (
          <option key={option.key} value={option.key}>
            {option.label}
          </option>
        ))}
      </select>
    </section>
  );
}
