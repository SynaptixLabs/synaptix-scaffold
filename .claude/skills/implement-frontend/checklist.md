# Frontend Implementation Checklist

## Pre-Implementation
- [ ] Read UI Kit (docs/ui/UI_KIT.md)
- [ ] Read assigned TODO with acceptance criteria
- [ ] Check existing components for reuse
- [ ] Identify design tokens needed

## Implementation
- [ ] TypeScript strict mode (no `any`)
- [ ] Tailwind classes (no inline styles where tokens exist)
- [ ] Responsive layout (percentage-based, not fixed-pixel)
- [ ] Accessibility: contrast ratio ≥4.5:1, keyboard nav, ARIA labels
- [ ] Empty states designed as first-class screens

## Testing
- [ ] Playwright E2E for new user flows
- [ ] Tested at viewports: 1024, 1280, 1920
- [ ] No TypeScript errors (`npx tsc --noEmit`)
- [ ] No regressions on existing E2E tests

## Post-Implementation
- [ ] Screenshots captured
- [ ] Commit with descriptive message
