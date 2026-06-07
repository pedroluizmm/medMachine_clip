type Props = {
  value: number;
  onChange: (value: number) => void;
  simulated: boolean;
  onSimulate: () => void;
};

export function TemperatureControl({ value, onChange, simulated, onSimulate }: Props) {
  const percent = Math.max(0, Math.min(100, ((value - 35) / (41.5 - 35)) * 100));
  const color = value > 39 ? '#dc2626' : value >= 38 ? '#b45309' : '#0891b2';

  return (
    <section className="field-group temperature-control">
      <div className="field-title metric-title">
        <span>Temperatura</span>
        <strong>{value.toFixed(1)} °C</strong>
      </div>
      <div className="temperature-row">
        <div className="thermometer-card" aria-label={`Temperatura atual ${value.toFixed(1)} graus Celsius`}>
          <span className="thermo-mark max">41.5</span>
          <div className="thermometer">
            <div className="thermometer-fill" style={{ height: `${percent}%`, backgroundColor: color }} />
          </div>
          <span className="thermo-mark min">35.0</span>
        </div>
        <div className="control-stack">
          <label>
            <span className="control-label">Ajuste pelo slider</span>
            <input
              type="range"
              min="35"
              max="41.5"
              step="0.1"
              value={value}
              onChange={(event) => onChange(Number(event.target.value))}
            />
          </label>
          <label>
            <span className="control-label">Valor em graus Celsius</span>
            <input
              type="number"
              min="35"
              max="41.5"
              step="0.1"
              value={value}
              onChange={(event) => onChange(Number(event.target.value))}
            />
          </label>
          <button type="button" className="secondary-button" onClick={onSimulate}>
            Gerar temperatura simulada
          </button>
          {simulated && <small className="simulation-note">Valor simulado. A inferencia so ocorre ao analisar.</small>}
        </div>
      </div>
    </section>
  );
}
