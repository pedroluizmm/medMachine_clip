const groups = [
  { title: 'Marcadores gerais', items: [['dor-no-corpo', 'Dor no corpo']] },
  { title: 'Marcadores articulares', items: [['dor-articular-incapacitante', 'Dor articular incapacitante']] },
  { title: 'Marcadores cutaneos/oculares', items: [['exantema-com-coceira', 'Exantema com coceira'], ['conjuntivite', 'Conjuntivite']] },
  { title: 'Marcadores complementares', items: [['dor-retrorbital', 'Dor retrorbital'], ['cefaleia-intensa', 'Cefaleia intensa'], ['fotofobia', 'Fotofobia'], ['dor-abdominal', 'Dor abdominal']] },
];

type Props = {
  selected: string[];
  onChange: (selected: string[]) => void;
};

export function SymptomsSelector({ selected, onChange }: Props) {
  function toggle(value: string) {
    onChange(selected.includes(value) ? selected.filter((item) => item !== value) : [...selected, value]);
  }

  return (
    <section className="field-group">
      <div className="symptom-grid">
        {groups.map((group) => (
          <div key={group.title} className="option-group">
            <strong>{group.title}</strong>
            {group.items.map(([value, label]) => (
              <label key={value} className="checkbox-row large-touch">
                <input type="checkbox" checked={selected.includes(value)} onChange={() => toggle(value)} />
                <span>{label}</span>
              </label>
            ))}
          </div>
        ))}
      </div>
    </section>
  );
}
