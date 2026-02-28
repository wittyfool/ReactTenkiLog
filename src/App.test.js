import { render, screen } from '@testing-library/react';
import App, { getTelegramClass } from './App';

test('renders app title', () => {
  render(<App />);
  const titleElement = screen.getByText(/天気ログ/i);
  expect(titleElement).toBeInTheDocument();
});

test('getTelegramClass returns correct class for known prefixes', () => {
  expect(getTelegramClass('https://example.com/data/20210101_0_VPFD50_100000.xml')).toBe('telegram-weather');
  expect(getTelegramClass('https://example.com/data/20210101_0_VWSE55_100000.xml')).toBe('telegram-warning');
  expect(getTelegramClass('https://example.com/data/20210101_0_VXSE51_100000.xml')).toBe('telegram-earthquake');
  expect(getTelegramClass('https://example.com/data/20210101_0_VFVO50_100000.xml')).toBe('telegram-volcano');
  expect(getTelegramClass('https://example.com/data/20210101_0_VMCJ50_100000.xml')).toBe('telegram-ocean');
  expect(getTelegramClass('https://example.com/data/20210101_0_VAAA00_100000.xml')).toBe('telegram-aviation');
});

test('getTelegramClass returns telegram-other for unknown or missing type', () => {
  expect(getTelegramClass('https://example.com/data/20210101_0_ZZXX99_100000.xml')).toBe('telegram-other');
  expect(getTelegramClass('https://example.com/data/no_type_here.xml')).toBe('telegram-other');
});
