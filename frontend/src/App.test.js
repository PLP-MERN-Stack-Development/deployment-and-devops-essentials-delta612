import { render, screen } from '@testing-library/react';
import App from './App';

describe('App Component', () => {
  test('renders welcome message', () => {
    render(<App />);
    const heading = screen.getByText(/welcome to mern/i);
    expect(heading).toBeInTheDocument();
  });

  test('renders description text', () => {
    render(<App />);
    const description = screen.getByText(/this is your mern stack application/i);
    expect(description).toBeInTheDocument();
  });
});
