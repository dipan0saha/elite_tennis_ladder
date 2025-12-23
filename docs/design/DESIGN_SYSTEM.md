# Elite Tennis Ladder Design System

**Version:** 1.0  
**Last Updated:** December 2025  
**Status:** Approved for Development

---

## Table of Contents

1. [Introduction](#1-introduction)
2. [Design Principles](#2-design-principles)
3. [Color System](#3-color-system)
4. [Typography](#4-typography)
5. [Spacing & Layout](#5-spacing--layout)
6. [Components](#6-components)
7. [Iconography](#7-iconography)
8. [Navigation Patterns](#8-navigation-patterns)
9. [Dark Mode](#9-dark-mode)

---

## 1. Introduction

### 1.1 Purpose

The Elite Tennis Ladder Design System provides a comprehensive set of design guidelines, components, and patterns to ensure a consistent, accessible, and high-quality user experience across all platforms.

### 1.2 Goals

- **Consistency:** Unified visual language across all screens
- **Accessibility:** WCAG 2.1 Level AA compliant
- **Mobile-First:** Optimized for mobile devices with responsive design
- **Dark Mode:** Full support for light and dark themes
- **Ad-Free:** Clean, distraction-free experience
- **Performance:** Lightweight and optimized for fast loading

---

## 2. Design Principles

### 2.1 Mobile-First

Design for mobile devices first, then scale up to larger screens. Touch targets should be minimum 44x44pt.

### 2.2 Clean & Simple

Prioritize clarity over complexity. Use white space effectively. Avoid clutter and unnecessary elements.

### 2.3 Accessible

Design for all users regardless of ability. High contrast ratios, clear typography, keyboard navigation support.

### 2.4 Fast & Responsive

Optimize for performance. Instant feedback for user actions. Minimize loading states.

### 2.5 Ad-Free Experience

No advertisements, pop-ups, or intrusive promotions. Focus on core functionality.

---

## 3. Color System

### 3.1 Primary Colors

**Tennis Green (Brand Primary)**
- `#1B5E20` - Primary Dark
- `#2E7D32` - Primary
- `#4CAF50` - Primary Light
- `#81C784` - Primary Lighter

**Purpose:** Brand identity, primary actions, navigation highlights

### 3.2 Secondary Colors

**Court Blue**
- `#0D47A1` - Secondary Dark
- `#1976D2` - Secondary
- `#42A5F5` - Secondary Light
- `#90CAF9` - Secondary Lighter

**Purpose:** Secondary actions, links, accents

### 3.3 Neutral Colors

**Light Mode**
- `#FFFFFF` - Background Primary
- `#F5F5F5` - Background Secondary
- `#E0E0E0` - Border Light
- `#BDBDBD` - Border
- `#757575` - Text Secondary
- `#424242` - Text Primary
- `#212121` - Text Dark

**Dark Mode**
- `#121212` - Background Primary
- `#1E1E1E` - Background Secondary
- `#2C2C2C` - Background Tertiary
- `#3A3A3A` - Border
- `#B0B0B0` - Text Secondary
- `#E0E0E0` - Text Primary
- `#FFFFFF` - Text Light

### 3.4 Semantic Colors

**Success**
- `#2E7D32` - Success Dark
- `#4CAF50` - Success
- `#81C784` - Success Light

**Warning**
- `#F57C00` - Warning Dark
- `#FF9800` - Warning
- `#FFB74D` - Warning Light

**Error**
- `#C62828` - Error Dark
- `#F44336` - Error
- `#E57373` - Error Light

**Info**
- `#1976D2` - Info Dark
- `#2196F3` - Info
- `#64B5F6` - Info Light

### 3.5 Color Usage Guidelines

- **Contrast Ratio:** Minimum 4.5:1 for normal text, 3:1 for large text
- **Primary Color:** Use sparingly for important actions and brand elements
- **Semantic Colors:** Use consistently for success/error/warning states
- **Neutral Colors:** Use for backgrounds, borders, and body text

---

## 4. Typography

### 4.1 Font Family

**Primary Font:** Roboto (Google Font)
- Available in: Light (300), Regular (400), Medium (500), Bold (700)
- System fallback: -apple-system, BlinkMacSystemFont, "Segoe UI", Arial, sans-serif

**Purpose:** Highly readable, widely available, optimized for screens

### 4.2 Type Scale

**Display Styles**
```
Display Large: 57px / 64px line height / Bold (700) / -0.25px letter spacing
Display Medium: 45px / 52px line height / Bold (700) / 0px letter spacing
Display Small: 36px / 44px line height / Bold (700) / 0px letter spacing
```

**Headline Styles**
```
Headline Large: 32px / 40px line height / Bold (700) / 0px letter spacing
Headline Medium: 28px / 36px line height / Bold (700) / 0px letter spacing
Headline Small: 24px / 32px line height / Bold (700) / 0px letter spacing
```

**Title Styles**
```
Title Large: 22px / 28px line height / Medium (500) / 0px letter spacing
Title Medium: 16px / 24px line height / Medium (500) / 0.15px letter spacing
Title Small: 14px / 20px line height / Medium (500) / 0.1px letter spacing
```

**Body Styles**
```
Body Large: 16px / 24px line height / Regular (400) / 0.5px letter spacing
Body Medium: 14px / 20px line height / Regular (400) / 0.25px letter spacing
Body Small: 12px / 16px line height / Regular (400) / 0.4px letter spacing
```

**Label Styles**
```
Label Large: 14px / 20px line height / Medium (500) / 0.1px letter spacing
Label Medium: 12px / 16px line height / Medium (500) / 0.5px letter spacing
Label Small: 11px / 16px line height / Medium (500) / 0.5px letter spacing
```

### 4.3 Typography Usage

- **Headlines:** Page titles, section headers
- **Titles:** Card titles, list item titles
- **Body:** Main content, descriptions, paragraphs
- **Labels:** Form labels, button text, navigation items
- **Minimum Mobile Size:** 16px for body text (prevents zoom on input focus)

---

## 5. Spacing & Layout

### 5.1 Spacing Scale (8px Base)

```
xs: 4px   (0.5 * base)
sm: 8px   (1 * base)
md: 16px  (2 * base)
lg: 24px  (3 * base)
xl: 32px  (4 * base)
2xl: 48px (6 * base)
3xl: 64px (8 * base)
```

### 5.2 Layout Grid

**Mobile (320px - 599px)**
- Columns: 4
- Margin: 16px
- Gutter: 16px

**Tablet (600px - 1023px)**
- Columns: 8
- Margin: 24px
- Gutter: 24px

**Desktop (1024px+)**
- Columns: 12
- Margin: 32px
- Gutter: 32px
- Max width: 1440px

### 5.3 Breakpoints

```
Mobile: 0px - 599px
Tablet: 600px - 1023px
Desktop: 1024px - 1439px
Desktop Large: 1440px+
```

### 5.4 Component Spacing

- **Padding:** Use md (16px) for cards, lg (24px) for containers
- **Margin:** Use md (16px) between components, lg (24px) between sections
- **Gap:** Use sm (8px) for tight groups, md (16px) for regular spacing

---

## 6. Components

### 6.1 Buttons

**Primary Button**
- Background: Primary color (#2E7D32)
- Text: White (#FFFFFF)
- Height: 48px (mobile), 40px (desktop)
- Padding: 16px horizontal
- Border radius: 8px
- Font: Label Large, Medium (500)
- Touch target: Minimum 44x44pt
- Hover: Darken 10%
- Active: Darken 15%
- Disabled: Opacity 38%

**Secondary Button**
- Background: Transparent
- Border: 1px solid Primary color
- Text: Primary color
- Other specs: Same as Primary Button

**Text Button**
- Background: Transparent
- Border: None
- Text: Primary color
- Height: 40px
- Padding: 12px horizontal

### 6.2 Cards

**Standard Card**
- Background: Surface color (White in light, #1E1E1E in dark)
- Border radius: 12px
- Padding: 16px
- Elevation: 2dp (light shadow)
- Border: None

**Elevated Card**
- Same as Standard Card
- Elevation: 4dp (medium shadow)

**Outlined Card**
- Same as Standard Card
- Elevation: 0dp
- Border: 1px solid border color

### 6.3 Input Fields

**Text Input**
- Height: 56px
- Padding: 16px horizontal, 16px top, 8px bottom
- Border radius: 4px (top corners only for filled style)
- Border: 1px bottom border
- Font: Body Large
- Label: Floating label (Label Small when floating)
- Error state: Red border and error text below
- Focus: 2px primary color border

**Search Input**
- Height: 48px
- Full rounded corners (24px border radius)
- Prefix icon: Search icon
- Placeholder text

### 6.4 Lists

**List Item**
- Height: Minimum 56px
- Padding: 16px horizontal
- Leading icon: Optional, 24x24px
- Trailing icon: Optional, 24x24px
- Title: Title Medium
- Subtitle: Body Medium, secondary text color
- Divider: 1px border bottom

**Interactive List Item**
- Add ripple effect on tap
- Hover: Background opacity 8%
- Active: Background opacity 12%

### 6.5 Navigation

**Bottom Navigation Bar**
- Height: 56px (mobile), hidden on desktop
- Items: 4-5 maximum
- Icon: 24x24px
- Label: Label Medium
- Active color: Primary
- Inactive color: Text Secondary
- Ripple on tap

**App Bar**
- Height: 56px (mobile), 64px (desktop)
- Padding: 16px horizontal
- Background: Primary color or Surface color
- Title: Title Large
- Actions: Icon buttons, 48x48px touch target
- Elevation: 0dp (flat) or 4dp

**Drawer**
- Width: 280px (mobile), 360px (tablet+)
- Background: Surface color
- Header: 160px height, optional background image
- List items: Same as standard list
- Dividers between sections

### 6.6 Dialogs

**Alert Dialog**
- Max width: 280px (mobile), 560px (desktop)
- Border radius: 12px
- Padding: 24px
- Title: Headline Small
- Content: Body Medium
- Actions: Text buttons, right aligned

**Full Screen Dialog (Mobile)**
- Full screen overlay
- App bar with close button
- Content area
- Action button (FAB or in app bar)

### 6.7 Snackbars & Toasts

**Snackbar**
- Width: Full width - 16px margin (mobile), max 560px (desktop)
- Height: Minimum 48px
- Border radius: 4px
- Background: #323232 (dark) with opacity
- Text: White
- Action: Text button in primary color
- Position: Bottom of screen
- Duration: 4-7 seconds

---

## 7. Iconography

### 7.1 Icon System

**Source:** Material Design Icons
- Size: 24x24dp (standard), 18x18dp (small), 48x48dp (large)
- Style: Filled or Outlined (consistent throughout app)
- Color: Inherit from parent or specified color
- Touch target: Minimum 48x48dp for interactive icons

### 7.2 Common Icons

```
Home: home
Profile: person
Rankings: leaderboard
Matches: sports_tennis
Challenge: emoji_events
Settings: settings
Menu: menu
Back: arrow_back
Search: search
Filter: filter_list
Add: add
Edit: edit
Delete: delete
Success: check_circle
Error: error
Warning: warning
Info: info
```

### 7.3 Icon Usage

- **Navigation:** Use outlined icons, filled when active
- **Actions:** Use filled icons for primary actions
- **Status:** Use filled icons with semantic colors
- **Decorative:** Use sparingly, maintain consistency

---

## 8. Navigation Patterns

### 8.1 Primary Navigation (Mobile)

**Bottom Navigation Bar**
- Home / Ladder
- Rankings / Leaderboard
- Matches
- Profile

**Purpose:** Quick access to main sections

### 8.2 Secondary Navigation

**App Bar Actions**
- Search
- Filter
- Notifications
- Menu (hamburger)

### 8.3 Tertiary Navigation

**Drawer Menu (Desktop & Tablet)**
- Profile
- My Matches
- Challenges
- Rankings
- Settings
- Help & Support
- Logout

### 8.4 Navigation Hierarchy

```
Level 1: Bottom Navigation (mobile) / Side Navigation (desktop)
Level 2: App Bar with title and actions
Level 3: Tabs (if needed for sub-sections)
Level 4: In-page navigation (anchors, scrollspy)
```

### 8.5 Navigation States

- **Active:** Primary color, filled icon, bold label
- **Inactive:** Text secondary color, outlined icon, regular label
- **Disabled:** Opacity 38%, no interaction

---

## 9. Dark Mode

### 9.1 Dark Mode Philosophy

- **Reduce eye strain:** Lower contrast, darker backgrounds
- **OLED optimization:** True black (#000000) for OLED screens
- **Elevation through lightness:** Lighter surfaces appear elevated
- **Preserve color meaning:** Semantic colors remain recognizable

### 9.2 Dark Mode Colors

**Surface Colors**
```
Background: #121212
Surface: #1E1E1E
Surface Variant: #2C2C2C
Elevated Surface (+1dp): #1F1F1F
Elevated Surface (+2dp): #232323
Elevated Surface (+4dp): #272727
```

**Text Colors**
```
High Emphasis: #FFFFFF (87% opacity)
Medium Emphasis: #FFFFFF (60% opacity)
Disabled: #FFFFFF (38% opacity)
```

**Primary Colors (Adjusted for Dark Mode)**
```
Primary: #81C784 (lighter shade for better contrast)
Secondary: #90CAF9 (lighter shade for better contrast)
```

### 9.3 Dark Mode Implementation

- **System Preference:** Detect and respect system dark mode setting
- **Manual Toggle:** Allow users to override system preference
- **Persistence:** Remember user's choice in local storage
- **Smooth Transition:** Animate color changes when switching themes

### 9.4 Dark Mode Best Practices

- **Test contrast ratios:** Ensure 4.5:1 minimum for text
- **Adjust shadows:** Use lighter shadows or elevation colors
- **Reduce bright colors:** Desaturate or darken bright accent colors
- **Test with OLED:** Verify true black works well on OLED displays

---

## 10. Accessibility

### 10.1 Color Accessibility

- **Contrast Ratios:** 4.5:1 for normal text, 3:1 for large text
- **Don't rely on color alone:** Use icons, labels, patterns
- **Colorblind-friendly:** Test with colorblind simulators

### 10.2 Interactive Elements

- **Touch Targets:** Minimum 44x44pt
- **Keyboard Navigation:** All interactive elements focusable
- **Focus Indicators:** Visible focus rings (2px primary color)
- **Screen Readers:** Proper ARIA labels and semantic HTML

### 10.3 Typography Accessibility

- **Minimum Size:** 16px for body text on mobile
- **Line Height:** 1.5 for body text
- **Text Scaling:** Support up to 200% text scaling
- **Readable Font:** Use Roboto for clarity

---

## Document Approval

**Design Lead:** _____________  
**Engineering Lead:** _____________  
**Product Owner:** _____________  

**Approved Date:** December 2025  
**Next Review:** January 2026

---

**Version History**

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | Dec 2025 | Design Team | Initial design system documentation |
