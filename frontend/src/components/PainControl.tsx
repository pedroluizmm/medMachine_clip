type Props = {
  value: number;
  onChange: (value: number) => void;
};

export function PainControl({ value, onChange }: Props) {
  return (
    <section className="field-group pain-control">
      <div className="field-title metric-title">
        <span>Dor articular</span>
        <strong>{value}/10</strong>
      </div>
      <input
        type="range"
        min="0"
        max="10"
        step="1"
        value={value}
        aria-label="Grau de dor articular de 0 a 10"
        onChange={(event) => onChange(Number(event.target.value))}
      />
      <div className="scale-labels">
        <span>0<br />nenhuma</span>
        <span>1 a 3<br />leve</span>
        <span>4 a 7<br />moderada</span>
        <span>8 a 10<br />intensa</span>
      </div>
    </section>
  );
}
