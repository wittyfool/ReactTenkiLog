import React from 'react';
import { render, screen, act } from '@testing-library/react';
import App, { getTelegramClass, getXslForUrl, dateJST } from './App';

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

test('list shows date+time for the first item of each day, time-only for subsequent same-day items', () => {
  const ref = React.createRef();
  render(<App ref={ref} />);

  // Three items: two on 2/28 (JST), one on 2/27 (JST)
  const items = [
    {
      id: 'item1',
      updated: '2026-02-28T00.30.00Z', // 2/28 09:30 JST
      title: '電文A',
      author: { name: '東京管区' },
      link: { $: { href: 'https://example.com/data/20260228_0_VPFD50_1.xml' } },
    },
    {
      id: 'item2',
      updated: '2026-02-28T01.00.00Z', // 2/28 10:00 JST (same date)
      title: '電文B',
      author: { name: '東京管区' },
      link: { $: { href: 'https://example.com/data/20260228_0_VPFD50_2.xml' } },
    },
    {
      id: 'item3',
      updated: '2026-02-27T00.30.00Z', // 2/27 09:30 JST (different date)
      title: '電文C',
      author: { name: '東京管区' },
      link: { $: { href: 'https://example.com/data/20260227_0_VPFD50_3.xml' } },
    },
  ];

  act(() => {
    ref.current.setState({ items });
  });

  const datetimeSpans = document.querySelectorAll('.datetime');
  // First item of 2/28: shows date+time
  expect(datetimeSpans[0].textContent.trim()).toBe('2/28 09:30');
  // Second item of 2/28: shows time only (no date)
  expect(datetimeSpans[1].textContent.trim()).toBe('10:00');
  // First item of 2/27: shows date+time (new date)
  expect(datetimeSpans[2].textContent.trim()).toBe('2/27 09:30');
});
