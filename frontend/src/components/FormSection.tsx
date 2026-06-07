import type { ReactNode } from 'react';

type Props = {
  title: string;
  description?: string;
  children: ReactNode;
};

export function FormSection({ title, description, children }: Props) {
  return (
    <section className="form-section">
      <div className="section-heading">
        <h3>{title}</h3>
        {description && <p>{description}</p>}
      </div>
      {children}
    </section>
  );
}
