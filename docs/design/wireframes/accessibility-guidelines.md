# Accessibility Guidelines

**Project:** Elite Tennis Ladder  
**Version:** 1.0  
**Date:** December 2025  
**Status:** Approved  
**Standard:** WCAG 2.1 Level AA Compliance

---

## Table of Contents

1. [Introduction](#1-introduction)
2. [Touch & Interaction](#2-touch--interaction)
3. [Visual Accessibility](#3-visual-accessibility)
4. [Screen Reader Support](#4-screen-reader-support)
5. [Keyboard Navigation](#5-keyboard-navigation)
6. [Cognitive Accessibility](#6-cognitive-accessibility)
7. [Testing Checklist](#7-testing-checklist)

---

## 1. Introduction

### 1.1 Purpose

This document provides comprehensive accessibility guidelines for the Elite Tennis Ladder mobile application to ensure all users, regardless of ability, can effectively use the platform.

### 1.2 Compliance Target

**WCAG 2.1 Level AA** - All wireframes and implementations must meet or exceed this standard.

### 1.3 User Considerations

Our application serves users with varying abilities:
- **Visual impairments** (low vision, color blindness, blindness)
- **Motor impairments** (limited dexterity, tremors)
- **Cognitive differences** (learning disabilities, attention disorders)
- **Auditory impairments** (hearing loss)
- **Age-related limitations** (older adults 50+)

---

## 2. Touch & Interaction

### 2.1 Minimum Touch Target Sizes

**All interactive elements must meet minimum size requirements:**

| Element Type | Minimum Size | Recommended | Spacing |
|--------------|--------------|-------------|---------|
| Primary Button | 44px × 44px | 48px × 48px | 8px |
| Secondary Button | 40px × 40px | 44px × 44px | 8px |
| Icon Button | 44px × 44px | 48px × 48px | 8px |
| Text Link | 44px height | 48px height | 8px vertical |
| Input Field | 44px height | 48px height | 16px vertical |
| Checkbox/Radio | 24px × 24px | 28px × 28px | 8px (48px tap target) |
| Toggle Switch | 32px × 52px | 36px × 58px | 8px |
| List Item | 56px height | 64px height | 0px |

**Rationale:**
- iOS: 44pt minimum (Apple HIG)
- Android: 48dp minimum (Material Design)
- We use 44px as absolute minimum, 48px as standard

### 2.2 Touch Target Spacing

**Minimum spacing between interactive elements: 8px**

```
❌ Incorrect:
[Button A][Button B]

✅ Correct:
[Button A]  8px  [Button B]
```

**Exception:** Segmented controls and button groups where visual grouping is important. In these cases, use visual separators.

### 2.3 Gesture Support

**Supported Gestures:**
- ✅ Single tap (primary action)
- ✅ Long press (secondary menu)
- ✅ Swipe (navigation, dismiss)
- ✅ Scroll (content navigation)
- ✅ Pinch/zoom (images, charts - optional)

**Avoided Gestures:**
- ❌ Multi-finger gestures (complex for users with motor impairments)
- ❌ Pressure-sensitive gestures (not universally supported)
- ❌ Shake gestures (accessibility issues)

**Alternative Input:**
- All gesture actions must have button/link alternatives
- Example: Swipe to delete → Also provide delete button

### 2.4 Haptic Feedback

**Use Cases:**
- ✅ Success actions (challenge sent, match won)
- ✅ Error states (form validation failure)
- ✅ Important notifications
- ✅ Interactive feedback (button press, selection)

**Implementation:**
- iOS: UIImpactFeedbackGenerator
- Android: HapticFeedbackConstants
- User control: Allow disabling in settings

---

## 3. Visual Accessibility

### 3.1 Color Contrast Ratios

**WCAG 2.1 Level AA Requirements:**

| Element Type | Minimum Ratio | Target Ratio |
|--------------|---------------|--------------|
| Normal Text (< 18px) | 4.5:1 | 7:1 (AAA) |
| Large Text (≥ 18px) | 3:1 | 4.5:1 |
| UI Components | 3:1 | 4.5:1 |
| Graphics | 3:1 | 4.5:1 |

**Color Palette Contrast Ratios:**

```
Primary Text (#212121) on White (#FFFFFF):
→ 16.1:1 ✅ AAA

Secondary Text (#757575) on White (#FFFFFF):
→ 7.3:1 ✅ AA (exceeds)

Primary Button (#1E88E5) with White Text:
→ 4.8:1 ✅ AA

Error Text (#F44336) on White (#FFFFFF):
→ 4.9:1 ✅ AA

Success Text (#43A047) on White (#FFFFFF):
→ 5.1:1 ✅ AA
```

**Testing Tools:**
- WebAIM Contrast Checker
- Stark (Figma plugin)
- Color Contrast Analyzer (desktop app)

### 3.2 Color Usage Guidelines

**Never use color alone to convey information:**

❌ **Incorrect:**
```
Ranking up: Text in green
Ranking down: Text in red
```

✅ **Correct:**
```
Ranking up: ⬆️ Green text "Up 2 spots"
Ranking down: ⬇️ Red text "Down 2 spots"
```

**Color-Blind Friendly Palette:**
- Red-Green color blindness (most common): Use blue/orange instead
- Use patterns, icons, and text labels in addition to color
- Test designs with color blindness simulators

### 3.3 Text Sizing & Scaling

**Base Font Sizes:**
- Minimum body text: 16px
- Minimum caption text: 12px
- Minimum button text: 14px

**Dynamic Type Support:**
- iOS: Support Dynamic Type (UIFontTextStyle)
- Android: Support user font size preferences
- Test at 200% text size
- Ensure layout doesn't break at larger sizes

**Line Height:**
- Body text: 1.5 (24px for 16px text)
- Headings: 1.2-1.3
- Captions: 1.4

**Line Length:**
- Optimal: 50-75 characters per line
- Maximum: 80 characters per line
- Use padding to control line length on large screens

### 3.4 Visual Hierarchy

**Information Priority:**

1. **Primary Information** (most prominent)
   - Largest text (24-28px)
   - High contrast (16:1+)
   - Top of viewport or highlighted area

2. **Secondary Information** (supporting)
   - Medium text (16-20px)
   - Good contrast (7:1+)
   - Below primary, clear relationship

3. **Tertiary Information** (supplementary)
   - Smaller text (12-14px)
   - Adequate contrast (4.5:1+)
   - Clearly delineated sections

**Example: Player Card**
```
Primary: Player Name (16px, Bold)
Secondary: Rank & Record (14px, Regular)
Tertiary: Last Active (12px, Light)
```

### 3.5 Focus Indicators

**All interactive elements must have visible focus indicators:**

**Specifications:**
- Outline: 2px solid #1E88E5 (blue)
- Offset: 2px from element
- Border radius: Match element or 4px
- Always visible (never remove with CSS)

**States:**
```css
/* Default focus indicator */
:focus {
  outline: 2px solid #1E88E5;
  outline-offset: 2px;
}

/* High contrast mode */
@media (prefers-contrast: high) {
  :focus {
    outline: 3px solid currentColor;
    outline-offset: 3px;
  }
}
```

### 3.6 Animation & Motion

**Respect user preferences:**

```css
/* Reduce motion for users who prefer it */
@media (prefers-reduced-motion: reduce) {
  * {
    animation-duration: 0.01ms !important;
    transition-duration: 0.01ms !important;
  }
}
```

**Guidelines:**
- Keep animations under 300ms
- Avoid flashing content (no more than 3 flashes per second)
- Provide pause/stop controls for auto-playing content
- Never require animations for functionality

---

## 4. Screen Reader Support

### 4.1 Screen Reader Compatibility

**Supported Screen Readers:**
- iOS: VoiceOver
- Android: TalkBack
- Web: JAWS, NVDA, VoiceOver (Mac)

### 4.2 Semantic HTML & ARIA

**Use semantic HTML elements:**

✅ **Correct:**
```html
<button>Send Challenge</button>
<nav>...</nav>
<main>...</main>
<header>...</header>
```

❌ **Incorrect:**
```html
<div onClick="...">Send Challenge</div>
<div class="nav">...</div>
```

**ARIA Labels:**

```html
<!-- Button with icon only -->
<button aria-label="Search players">
  <SearchIcon />
</button>

<!-- Status indicator -->
<div role="status" aria-live="polite">
  Challenge sent successfully
</div>

<!-- Navigation -->
<nav aria-label="Main navigation">
  <a href="/ladder" aria-current="page">Ladder</a>
</nav>

<!-- Form input -->
<label for="email">Email Address</label>
<input 
  id="email" 
  type="email" 
  aria-required="true"
  aria-describedby="email-hint"
/>
<span id="email-hint">We'll never share your email.</span>
```

### 4.3 Screen Reader Announcements

**Page Load:**
```
"Ladder View. Showing 40 players. You are ranked 8, up 2 spots this week."
```

**Interactive Elements:**
```
"Mike Thompson, rank 1, 15 wins, 3 losses, 83% win rate. Challenge button."
```

**Actions:**
```
"Challenge sent to Sarah Mitchell. Button."
```

**Dynamic Content:**
```
"Your ranking changed to 6. Alert."
```

### 4.4 Live Regions

**Use ARIA live regions for dynamic updates:**

```html
<!-- Polite (don't interrupt) -->
<div role="status" aria-live="polite" aria-atomic="true">
  Challenge accepted by Mike Thompson
</div>

<!-- Assertive (interrupt) -->
<div role="alert" aria-live="assertive">
  Match result disputed. Admin review required.
</div>
```

**Guidelines:**
- Use `polite` for most updates
- Use `assertive` only for critical information
- Keep announcements concise (< 100 characters)
- Avoid excessive announcements (causes fatigue)

### 4.5 Hidden Content

**Properly hide decorative or duplicate content:**

```html
<!-- Hide from screen readers -->
<span aria-hidden="true">★★★★★</span>

<!-- Visually hidden but read by screen readers -->
<span class="sr-only">5 star rating</span>

<!-- Hide decorative images -->
<img src="decoration.png" alt="" aria-hidden="true" />
```

```css
/* Screen reader only class */
.sr-only {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
  border-width: 0;
}
```

---

## 5. Keyboard Navigation

### 5.1 Tab Order

**Logical tab order following reading order:**

1. Header navigation
2. Main content (top to bottom, left to right)
3. Footer/bottom navigation

**Implementation:**
```html
<!-- Use tabindex appropriately -->
<button tabindex="0">Accessible</button>  <!-- Natural order -->
<div tabindex="-1">Not in tab order</div> <!-- Programmatic focus only -->

<!-- Never use positive tabindex -->
❌ <button tabindex="1">Bad practice</button>
```

### 5.2 Keyboard Shortcuts

**Standard Keys:**
- **Tab:** Next focusable element
- **Shift + Tab:** Previous focusable element
- **Enter/Space:** Activate button/link
- **Escape:** Close modal/cancel action
- **Arrow Keys:** Navigate within components

**Custom Shortcuts:**
- **/ (slash):** Focus search
- **? (question mark):** Show keyboard shortcuts help
- **1-5:** Navigate tabs (optional)

**Guidelines:**
- Document all keyboard shortcuts
- Provide shortcuts help modal
- Don't override standard browser shortcuts
- Allow customization if possible

### 5.3 Focus Management

**Modal Dialogs:**
```javascript
// Trap focus within modal
const modal = document.querySelector('.modal');
const focusableElements = modal.querySelectorAll(
  'button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])'
);

const firstElement = focusableElements[0];
const lastElement = focusableElements[focusableElements.length - 1];

// Focus first element when modal opens
firstElement.focus();

// Trap focus
modal.addEventListener('keydown', (e) => {
  if (e.key === 'Tab') {
    if (e.shiftKey && document.activeElement === firstElement) {
      e.preventDefault();
      lastElement.focus();
    } else if (!e.shiftKey && document.activeElement === lastElement) {
      e.preventDefault();
      firstElement.focus();
    }
  }
});
```

**Skip Links:**
```html
<a href="#main-content" class="skip-link">
  Skip to main content
</a>
```

---

## 6. Cognitive Accessibility

### 6.1 Clear Communication

**Use plain language:**

✅ **Good:**
```
"Challenge Mike Thompson to a match"
"You're ranked 8 out of 40 players"
```

❌ **Bad:**
```
"Initiate a competitive engagement with Mike Thompson"
"Your ordinal position is 8 within a cohort of 40"
```

**Guidelines:**
- Short sentences (< 20 words)
- Active voice
- Common words
- Consistent terminology
- Avoid jargon

### 6.2 Error Prevention & Recovery

**Input Validation:**
- Validate on blur, not on every keystroke
- Show clear error messages
- Explain how to fix errors
- Highlight error fields

**Example:**
```
❌ "Invalid input"

✅ "Please enter a valid email address. 
    Example: john@email.com"
```

**Confirmation Dialogs:**
- Ask before destructive actions
- Provide undo options
- Clear action buttons

```
┌──────────────────────────────┐
│  Delete Match Result?        │
│                              │
│  This action cannot be       │
│  undone.                     │
│                              │
│  [Cancel]  [Delete]          │
└──────────────────────────────┘
```

### 6.3 Consistent Navigation

**Maintain consistency:**
- Same navigation on every screen
- Predictable interactions
- Consistent button placement
- Standard icons and labels

**Bottom Navigation:**
```
Always:
🏆 Ladder | 💪 Challenges | 📊 Stats | 👤 Profile
```

### 6.4 Progressive Disclosure

**Show information gradually:**

✅ **Good:** Expandable sections
```
Player Details ▼
├─ Basic Info (shown)
└─ [Show Statistics] (collapsed)
```

❌ **Bad:** Everything at once
```
Player Details
├─ Basic Info
├─ Statistics
├─ Match History
├─ Achievements
└─ ... (overwhelming)
```

### 6.5 Time Limits

**Avoid time limits where possible:**
- No session timeouts during active use
- At least 20 seconds for timed responses
- Provide warnings before timeout (with extension option)
- Allow users to adjust time limits

**Example:**
```
"Your session will expire in 2 minutes. 
 [Extend Session] [Logout]"
```

---

## 7. Testing Checklist

### 7.1 Manual Testing

**VoiceOver (iOS) Testing:**
- [ ] Turn on VoiceOver (triple-click home/side button)
- [ ] Navigate entire app with swipe gestures
- [ ] Test all interactive elements activate with double-tap
- [ ] Verify announcements are clear and concise
- [ ] Check that all images have alt text
- [ ] Ensure no inaccessible content

**TalkBack (Android) Testing:**
- [ ] Enable TalkBack in settings
- [ ] Navigate with swipe right/left
- [ ] Test double-tap activation
- [ ] Verify announcements
- [ ] Check reading order is logical
- [ ] Test with external keyboard

**Keyboard Navigation Testing:**
- [ ] Disconnect mouse
- [ ] Navigate entire app with Tab key
- [ ] Verify all interactive elements reachable
- [ ] Check focus indicators always visible
- [ ] Test Enter/Space activates buttons
- [ ] Verify Escape closes modals

**Touch Target Testing:**
- [ ] Measure all interactive elements (must be ≥ 44×44px)
- [ ] Verify spacing between elements (≥ 8px)
- [ ] Test on actual devices (not just simulator)
- [ ] Try with assistive touch features enabled

### 7.2 Automated Testing

**Tools:**
- **Lighthouse:** Chrome DevTools accessibility audit
- **axe DevTools:** Browser extension for accessibility testing
- **Pa11y:** Command-line accessibility testing
- **WAVE:** Web accessibility evaluation tool

**CI/CD Integration:**
```bash
# Run accessibility tests in CI
npm run test:a11y

# Fail build if critical issues found
lighthouse --only-categories=accessibility --min-score=90
```

### 7.3 Color Contrast Testing

**Tools:**
- WebAIM Contrast Checker
- Stark (Figma plugin)
- Chrome DevTools (Coverage tool)

**Process:**
1. Test all text against backgrounds
2. Test UI components and graphics
3. Verify at different zoom levels (up to 200%)
4. Check in high contrast mode

### 7.4 Screen Reader Testing

**Checklist:**
- [ ] All images have appropriate alt text
- [ ] All form inputs have associated labels
- [ ] All buttons have descriptive labels
- [ ] Page title is descriptive
- [ ] Headings are properly structured (h1 → h2 → h3)
- [ ] Links have descriptive text (not "click here")
- [ ] Tables have proper headers
- [ ] Lists use proper markup
- [ ] Dynamic content announces changes
- [ ] Focus management works correctly in modals

### 7.5 Real User Testing

**Include users with disabilities:**
- Blind/low vision users with screen readers
- Users with motor impairments
- Older adults (50+)
- Users with cognitive differences

**Testing Protocol:**
1. Define key tasks
2. Observe without interrupting
3. Note pain points and barriers
4. Gather feedback
5. Iterate based on findings

---

## Summary

**Key Principles:**

1. **Perceivable:** Information presented in ways all users can perceive
2. **Operable:** All functionality available via keyboard and touch
3. **Understandable:** Clear interface and content
4. **Robust:** Works with assistive technologies

**Quick Checklist:**
- ✅ Touch targets ≥ 44×44px
- ✅ Color contrast ≥ 4.5:1 (text), ≥ 3:1 (UI)
- ✅ All interactive elements keyboard accessible
- ✅ Screen reader compatible
- ✅ Clear focus indicators
- ✅ Descriptive labels and alt text
- ✅ Error prevention and recovery
- ✅ Consistent navigation
- ✅ Plain language
- ✅ Tested with real users

---

**Document Version:** 1.0  
**Last Updated:** December 2025  
**Status:** ✅ Approved  
**Next Review:** Quarterly (March 2026)
