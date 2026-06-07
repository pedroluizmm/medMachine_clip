export function EmptyResults() {
  return (
    <div className="empty-state">
      <div className="empty-illustration" aria-hidden="true">
        <span />
        <span />
        <span />
      </div>
      <h2>Preencha os dados do paciente e execute uma analise.</h2>
      <p>O sistema exibira:</p>
      <ul>
        <li>intensidades categorizadas;</li>
        <li>vinculos epidemiologicos;</li>
        <li>suspeitas clinicas;</li>
        <li>suspeitas reforcadas;</li>
        <li>alertas de triagem;</li>
        <li>cadeia de inferencia.</li>
      </ul>
    </div>
  );
}
