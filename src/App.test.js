import React from 'react';
import { render, screen, act } from '@testing-library/react';
import App, { getTelegramClass, getXslForUrl, dateJST, abbreviateOffice } from './App';

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

test('modal shows telegram URL as a link when telegramUrl is set', () => {
  const ref = React.createRef();
  render(<App ref={ref} />);
  const telegramUrl = 'https://www.data.jma.go.jp/developer/xml/data/20210101_0_VPFD50_100000.xml';
  act(() => {
    ref.current.setState({
      modalIsOpen: true,
      title: 'テスト電文',
      content: 'テスト内容',
      telegramClass: 'telegram-weather',
      telegramUrl,
    });
  });
  const link = screen.getByRole('link', { name: '20210101_0_VPFD50_100000.xml' });
  expect(link).toBeInTheDocument();
  expect(link).toHaveAttribute('href', telegramUrl);
});

test('getXslForUrl returns correct XSL for VPFW50 (府県週間天気予報)', () => {
  const url = 'https://www.data.jma.go.jp/developer/xml/data/20260228074022_0_VPFW50_030000.xml';
  expect(getXslForUrl(url)).toBe('190501_shukan.xsl');
});

test('getXslForUrl returns correct XSL for known telegram codes', () => {
  expect(getXslForUrl('https://example.com/data/20210101_0_VPFD50_100000.xml')).toBe('190501_yoho.xsl');
  expect(getXslForUrl('https://example.com/data/20210101_0_VPTI50_100000.xml')).toBe('190501_typhoon.xsl');
  expect(getXslForUrl('https://example.com/data/20210101_0_VZSA50_100000.xml')).toBe('190501_tenkizu.xsl');
});

test('getXslForUrl returns null for unknown telegram code', () => {
  expect(getXslForUrl('https://example.com/data/20210101_0_ZZXX99_100000.xml')).toBeNull();
  expect(getXslForUrl('https://example.com/no_code.xml')).toBeNull();
});

test('dateJST omits seconds from the time portion', () => {
  // 2026-02-28T00:30:45Z in GMT -> 2026-02-28T09:30:45 JST -> "2/28 09:30"
  const result = dateJST('2026-02-28T00.30.45Z');
  expect(result).toBe('2/28 09:30');
  expect(result).not.toMatch(/\d:\d{2}:\d{2}/);
});

test('dateJST omits leading zeros from month and day', () => {
  // 2026-01-05T00:05:00Z in GMT -> 2026-01-05T09:05:00 JST -> "1/5 09:05"
  const result = dateJST('2026-01-05T00.05.00Z');
  expect(result).toBe('1/5 09:05');
});

test('abbreviateOffice removes 地方気象台 from office name', () => {
  expect(abbreviateOffice('大阪地方気象台')).toBe('大阪');
  expect(abbreviateOffice('東京地方気象台')).toBe('東京');
  expect(abbreviateOffice('気象庁')).toBe('気象庁');
});
