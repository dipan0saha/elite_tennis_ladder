# Elite Tennis Ladder - High-Fidelity Mockups

**Version:** 1.0  
**Last Updated:** December 2025  
**Status:** Approved for Development

---

## Table of Contents

1. [Overview](#1-overview)
2. [Home / Ladder Screen](#2-home--ladder-screen)
3. [Leaderboard / Rankings Screen](#3-leaderboard--rankings-screen)
4. [Player Profile Screen](#4-player-profile-screen)
5. [Match Reporting Screen](#5-match-reporting-screen)
6. [Challenge Player Screen](#6-challenge-player-screen)
7. [Match History Screen](#7-match-history-screen)
8. [Settings Screen](#8-settings-screen)
9. [Navigation Flow](#9-navigation-flow)

---

## 1. Overview

### 1.1 Purpose

This document provides high-fidelity mockup specifications for all key screens in the Elite Tennis Ladder application. Each mockup includes detailed layout specifications, component usage, and interaction patterns.

### 1.2 Design Approach

- **Mobile-First:** All screens designed for mobile (375x812 iPhone) first
- **Dark Mode:** All screens include both light and dark mode specifications
- **Ad-Free:** Clean interface with no advertisements or promotional content
- **Accessible:** WCAG 2.1 Level AA compliant designs

### 1.3 Design Tools

- Design System: See `/docs/design/DESIGN_SYSTEM.md`
- Colors: Tennis Green primary, Court Blue secondary
- Typography: Roboto font family
- Icons: Material Design Icons

---

## 2. Home / Ladder Screen

### 2.1 Screen Purpose

Primary landing screen showing the user's current ladder standing, recent activity, and quick actions.

### 2.2 Layout Specifications

**App Bar**
- Height: 56px
- Background: Primary color (#2E7D32) in light mode, #1E1E1E in dark mode
- Title: "Elite Tennis Ladder" (Title Large, White)
- Actions: 
  - Search icon (24x24px, white)
  - Notifications icon with badge (24x24px, white)
  - Menu icon (24x24px, white)

**Current Standing Card**
- Position: Top of screen, below app bar
- Margin: 16px all sides
- Padding: 24px
- Background: White (light), #1E1E1E (dark)
- Border radius: 12px
- Elevation: 2dp
- Content:
  - "Your Ranking" label (Label Large, Text Secondary)
  - Rank number: Large display (Display Medium, Primary Color)
  - Rank change indicator: +/- with arrow icon
  - Total players: Body Small, Text Secondary
  - "View Full Ladder" link button (Label Large, Primary Color)

**Quick Actions Section**
- Margin: 16px horizontal, 8px vertical
- Layout: Horizontal scroll (if needed), 2 columns on mobile
- Cards:
  - Challenge Player (Primary button style card)
  - Report Match (Secondary button style card)
  - My Matches (Outlined card)
  - View Rankings (Outlined card)

**Recent Activity Feed**
- Section Title: "Recent Activity" (Title Large, 16px margin)
- List items:
  - Match result cards
  - Challenge notifications
  - Ranking change notifications
- Each item:
  - Height: Auto (min 72px)
  - Padding: 16px
  - Leading icon: 40x40px circle avatar or icon
  - Title: Title Medium
  - Subtitle: Body Medium, Text Secondary
  - Timestamp: Body Small, Text Secondary
  - Trailing icon: Arrow right (if clickable)
  - Divider: 1px border bottom

**Bottom Navigation**
- Height: 56px
- Background: Surface color
- Items: Home (active), Rankings, Matches, Profile
- Active indicator: Primary color fill icon + label
- Inactive: Text secondary color

### 2.3 Interactions

- **Pull to refresh:** Refresh recent activity
- **Tap ranking card:** Navigate to full ladder view
- **Tap quick action:** Navigate to respective screen
- **Tap activity item:** Navigate to detail view
- **Scroll:** Vertical scroll for activity feed

### 2.4 Dark Mode Variations

**App Bar**
- Background: #1E1E1E
- Title: White
- Icons: White

**Standing Card**
- Background: #1E1E1E
- Border: 1px solid #3A3A3A
- Text: White (#E0E0E0)

**Activity Feed**
- Background: #121212
- Cards: #1E1E1E
- Dividers: #3A3A3A

---

## 3. Leaderboard / Rankings Screen

### 3.1 Screen Purpose

Display the complete ladder rankings with player standings, stats, and filtering options.

### 3.2 Layout Specifications

**App Bar**
- Height: 56px
- Background: Surface color (White/dark)
- Back button: Left side
- Title: "Rankings" (Title Large)
- Actions:
  - Search icon
  - Filter icon

**Search & Filter Bar** (When activated)
- Height: 56px
- Background: Surface color
- Search field: Full width with rounded corners
- Placeholder: "Search players..."
- Close icon: Right side

**Filter Chips** (If filters applied)
- Height: 32px
- Horizontal scroll
- Chips: Small rounded rectangles
- Example: "Division A", "Active", "Top 10"

**Rankings List**
- Header (Sticky):
  - Background: Background Secondary
  - Height: 40px
  - Columns: Rank | Player | Record | Actions
  - Typography: Label Medium, Text Secondary

**Ranking Item**
- Height: 72px
- Padding: 16px
- Layout:
  - Rank number (40x40 circle, Primary color background, white text)
  - Player info:
    - Name (Title Medium)
    - Rating/Skill level (Body Small, Text Secondary)
  - Record: W-L (Body Medium)
  - Challenge button (if within range)
- Current user highlighted: Light primary background
- Rank change indicator: Green/red arrow with number

**Podium View** (Top 3)
- Special design for top 3 players
- Visual distinction with medals/icons
- Larger avatars
- Trophy icons (Gold, Silver, Bronze)

**Floating Action Button** (Optional)
- Position: Bottom right, 16px margin
- Size: 56x56px
- Icon: Trophy or challenge icon
- Action: Quick challenge

### 3.3 Interactions

- **Pull to refresh:** Update rankings
- **Tap player:** View player profile
- **Tap challenge:** Open challenge dialog
- **Tap search:** Expand search bar
- **Tap filter:** Open filter bottom sheet
- **Scroll:** Infinite scroll or pagination

### 3.4 Empty State

- Icon: Trophy (large, 120x120px, gray)
- Title: "No Rankings Yet"
- Message: "Be the first to join the ladder!"
- Action button: "Join Ladder"

---

## 4. Player Profile Screen

### 4.1 Screen Purpose

Display detailed information about a player including stats, match history, and actions.

### 4.2 Layout Specifications

**App Bar**
- Height: 56px
- Background: Transparent initially, then surface color on scroll
- Back button: Left side
- Actions:
  - Share icon
  - More menu (3 dots)

**Profile Header**
- Height: Auto (approx 300px)
- Background: Primary color gradient
- Content:
  - Avatar: 120x120px circle, centered
  - Name: Headline Medium, White, centered
  - Rank & Rating: Title Small, White, centered
  - Stats row (horizontal):
    - Matches played
    - Win rate
    - Current streak
  - Action buttons:
    - Challenge (Primary button)
    - Message (Secondary button)

**Tabs Section**
- Height: 48px
- Background: Surface color
- Tabs: Overview | Stats | Matches | Challenges
- Active indicator: Primary color underline (2px)
- Tab label: Label Large

**Overview Tab Content**
- About section:
  - Title: "About" (Title Medium)
  - Bio text (Body Medium)
  - Playing style, availability, etc.
- Recent Matches (last 5):
  - Title: "Recent Matches"
  - Match cards (compact version)

**Stats Tab Content**
- Stats cards (2 column grid):
  - Total Matches
  - Win/Loss Record
  - Win Rate %
  - Current Streak
  - Longest Streak
  - Head-to-head records
- Charts/graphs (if data available):
  - Performance over time
  - Win rate by opponent level

**Matches Tab Content**
- Full match history list
- Filterable by date, opponent, result
- Match cards with details

**Challenges Tab Content**
- Pending challenges
- Challenge history
- Challenge statistics

### 4.3 Interactions

- **Tap challenge button:** Open challenge dialog
- **Tap stats:** View detailed stats
- **Tap match:** View match details
- **Swipe tabs:** Navigate between tabs
- **Pull to refresh:** Update profile data

### 4.4 Self Profile Variations

- Edit button instead of challenge button
- Additional settings icon
- Privacy controls
- Edit profile information

---

## 5. Match Reporting Screen

### 5.1 Screen Purpose

Allow players to report match results quickly and accurately.

### 5.2 Layout Specifications

**App Bar**
- Height: 56px
- Background: Surface color
- Back button: Left side
- Title: "Report Match" (Title Large)
- Actions: None

**Progress Indicator**
- Step indicator (1 of 3, 2 of 3, 3 of 3)
- Primary color for active/completed steps

**Step 1: Select Opponent**
- Title: "Who did you play?" (Headline Small)
- Search field:
  - Height: 56px
  - Placeholder: "Search for player"
  - Leading icon: Search
- Recent opponents list:
  - Title: "Recent Opponents"
  - List items with avatars
- Or: "Can't find player?" link

**Step 2: Enter Score**
- Title: "What was the score?" (Headline Small)
- Match format selector:
  - Best of 3 sets
  - Best of 5 sets
  - Single set
  - Pro set
- Score input:
  - Set 1: [6] - [4]
  - Set 2: [3] - [6]
  - Set 3: [6] - [2]
  - Number pickers or input fields
- Winner indicator: Checkmark on winning player's side

**Step 3: Add Details** (Optional)
- Title: "Add match details" (optional)
- Date & time picker
- Location (dropdown or text input)
- Notes/comments (text area, 200 char limit)
- Photos (optional, up to 3)

**Bottom Actions**
- Back button (Text button, left)
- Next/Submit button (Primary button, right)
- Cancel button (top right in app bar)

### 5.3 Interactions

- **Tap next:** Advance to next step with validation
- **Tap back:** Return to previous step
- **Tap submit:** Submit match for approval/confirmation
- **Form validation:** Real-time validation with error messages
- **Success confirmation:** Snackbar or dialog confirming submission

### 5.4 Confirmation Dialog

- Title: "Confirm Match Result"
- Content:
  - Player names
  - Score
  - Date
  - "This will be submitted for opponent confirmation"
- Actions:
  - Cancel (Text button)
  - Confirm (Primary button)

---

## 6. Challenge Player Screen

### 6.1 Screen Purpose

Create and send a challenge to another player within acceptable range.

### 6.2 Layout Specifications

**App Bar**
- Height: 56px
- Background: Surface color
- Back button: Left side
- Title: "Challenge Player" (Title Large)

**Player Selection** (If not pre-selected)
- Similar to match reporting opponent selection
- Filter: Only show challengeable players (within rank range)
- Indication: "Rank 5-15 can challenge you"

**Challenge Details Form**
- Selected player card:
  - Avatar, name, rank
  - "Can't challenge?" info icon (explains rules)

- Proposed dates section:
  - Title: "Propose match dates"
  - Date picker (multiple selection)
  - Time picker
  - Add another date option (up to 3 dates)

- Location section:
  - Title: "Preferred location"
  - Dropdown or text input
  - Current location suggestion

- Message section:
  - Title: "Message (optional)"
  - Text area: 200 char limit
  - Placeholder: "Hi, would you like to play on..."

- Match format:
  - Radio buttons
  - Options: Best of 3, Best of 5, Single set

**Challenge Rules Card** (Collapsible)
- Title: "Challenge Rules"
- Icon: Info icon
- Content:
  - Challenge window: 7 days
  - Must be within 3 ranks
  - Winner moves up, loser moves down
  - Etc.

**Bottom Actions**
- Cancel button (Text button)
- Send Challenge (Primary button)

### 6.3 Interactions

- **Tap date:** Open date picker
- **Tap send:** Validate and send challenge
- **Confirmation:** Success snackbar
- **Errors:** Inline validation messages

### 6.4 Success State

- Redirect to challenges list
- Snackbar: "Challenge sent to [Player Name]"
- Option to: View challenge, Send another challenge

---

## 7. Match History Screen

### 7.1 Screen Purpose

View complete match history with filtering and search capabilities.

### 7.2 Layout Specifications

**App Bar**
- Title: "My Matches"
- Search icon
- Filter icon

**Filter Chips**
- All | Won | Lost | Pending | Disputed
- Horizontal scroll
- Active chip: Primary color

**Match Cards**
- Height: Auto (min 120px)
- Padding: 16px
- Border radius: 12px
- Margin: 8px horizontal, 4px vertical

**Match Card Content**
- Date: Body Small, Text Secondary (top right)
- Players:
  - Winner name (Bold)
  - Loser name (Regular)
- Score:
  - Large, prominent display
  - Winning scores in primary color
- Match details:
  - Location (if available)
  - Duration
  - Match type
- Status badge (if pending/disputed):
  - Color-coded chip
  - Pending approval, Disputed, etc.
- Actions:
  - View details button
  - More menu (3 dots)

**Empty State**
- Icon: Tennis ball (large)
- Title: "No Matches Yet"
- Message: "Start playing to see your match history"
- Action: "Find a Match"

### 7.3 Interactions

- **Tap card:** View match details
- **Tap filter:** Filter matches
- **Pull to refresh:** Reload matches
- **Infinite scroll:** Load more matches

---

## 8. Settings Screen

### 8.1 Screen Purpose

Configure app settings, preferences, and account management.

### 8.2 Layout Specifications

**App Bar**
- Title: "Settings"
- Back button

**Settings Sections**

**Appearance**
- Dark mode toggle:
  - Title: "Dark Mode"
  - Subtitle: "System default"
  - Switch
  - Options: System, Light, Dark
- Theme color (optional):
  - Color picker for accent color

**Notifications**
- Push notifications toggle
- Email notifications toggle
- Notification preferences:
  - Match challenges
  - Match results
  - Ranking changes
  - Announcements

**Profile**
- Edit profile (navigates to edit screen)
- Privacy settings
- Account settings

**Ladder Preferences**
- Default challenge window
- Auto-accept challenges
- Challenge notifications

**About**
- App version
- Terms of service
- Privacy policy
- Help & support
- Rate app
- Send feedback

**Account Actions**
- Logout (red text)
- Delete account (bottom, red)

### 8.3 Interactions

- **Tap setting:** Open detail or toggle
- **Toggle switches:** Immediate effect with feedback
- **Tap navigation items:** Navigate to sub-screens

### 8.4 Dark Mode Selector

- Bottom sheet with options:
  - System default (radio button)
  - Light (radio button)
  - Dark (radio button)
- Preview of each mode
- Apply button

---

## 9. Navigation Flow

### 9.1 Information Architecture

```
Bottom Navigation:
├── Home
│   ├── View Full Ladder → Rankings Screen
│   ├── Challenge Player → Challenge Screen
│   ├── Report Match → Match Reporting Screen
│   └── Activity Item → Match Details
├── Rankings
│   ├── Player Profile → Profile Screen
│   └── Challenge → Challenge Screen
├── Matches
│   ├── Match Details
│   └── Report Match → Match Reporting Screen
└── Profile
    ├── Edit Profile
    ├── Settings → Settings Screen
    └── Match History → Match History Screen

Drawer (Tablet/Desktop):
├── Home
├── My Profile
├── My Matches
├── Rankings
├── Challenges
├── Settings
└── Help & Support
```

### 9.2 Navigation Patterns

**Mobile Navigation**
- Bottom navigation bar for primary screens
- Back button for hierarchical navigation
- Drawer for secondary navigation (optional)

**Tablet Navigation**
- Side navigation drawer (always visible)
- Master-detail layouts where appropriate
- Bottom navigation hidden

**Desktop Navigation**
- Side navigation drawer (permanent)
- Top app bar with breadcrumbs
- Multi-column layouts

### 9.3 Transition Animations

- **Forward navigation:** Slide in from right (300ms)
- **Back navigation:** Slide out to right (300ms)
- **Tab switch:** Fade transition (200ms)
- **Bottom sheet:** Slide up from bottom (250ms)
- **Dialog:** Fade in with scale (200ms)

---

## 10. Responsive Design

### 10.1 Mobile Optimizations (< 600px)

- Single column layouts
- Bottom navigation
- Full-width cards
- Touch-optimized controls (44x44pt minimum)
- Simplified navigation
- Stacked forms

### 10.2 Tablet Optimizations (600px - 1023px)

- Two-column layouts where appropriate
- Side drawer available
- Larger touch targets
- More content visible
- Horizontal lists/carousels

### 10.3 Desktop Optimizations (1024px+)

- Multi-column layouts
- Permanent side navigation
- Hover states active
- Larger data tables
- More dense information
- Multi-panel views (master-detail)

---

## 11. Ad-Free Experience

### 11.1 Philosophy

The Elite Tennis Ladder is committed to providing an ad-free experience to focus users on what matters: playing tennis and tracking their progress.

### 11.2 No-Ad Design Principles

- **Clean Interface:** No banner ads, interstitials, or pop-ups
- **Focused Content:** All screen real estate dedicated to functionality
- **No Tracking:** No third-party advertising trackers
- **Premium Feel:** Professional, distraction-free experience
- **Performance:** Faster loading without ad scripts

### 11.3 Monetization Alternatives (If Needed)

- **Freemium Model:** Basic features free, premium features paid
- **Club Subscriptions:** Clubs pay for premium features
- **One-time Purchase:** Lifetime access with single purchase
- **Sponsorships:** Non-intrusive club/tournament sponsorships

### 11.4 Ad-Free Benefits

- Better user experience
- Faster performance
- Lower data usage
- Higher user satisfaction
- Professional appearance
- Focus on core functionality

---

## 12. Accessibility Features

### 12.1 Visual Accessibility

- **High Contrast Mode:** Enhanced contrast for better visibility
- **Large Text Support:** Scale up to 200% without breaking layout
- **Color Blindness:** Don't rely on color alone for information
- **Focus Indicators:** Clear visual focus for keyboard navigation

### 12.2 Motor Accessibility

- **Large Touch Targets:** Minimum 44x44pt
- **Gesture Alternatives:** Button alternatives for swipe gestures
- **No Time Limits:** No timed actions that can't be disabled
- **Easy Selection:** Large, easy-to-tap controls

### 12.3 Cognitive Accessibility

- **Clear Labels:** Descriptive, easy to understand
- **Consistent Navigation:** Same patterns throughout app
- **Error Prevention:** Confirmation for destructive actions
- **Help Available:** Context-sensitive help and tooltips

---

## 13. Design Review Checklist

### 13.1 Completeness

- [ ] All key screens designed
- [ ] Light and dark modes specified
- [ ] Responsive layouts defined
- [ ] All user flows documented
- [ ] Edge cases considered
- [ ] Error states designed
- [ ] Empty states designed
- [ ] Loading states designed

### 13.2 Consistency

- [ ] Design system followed
- [ ] Colors consistent
- [ ] Typography consistent
- [ ] Spacing consistent
- [ ] Component usage consistent
- [ ] Iconography consistent
- [ ] Navigation patterns consistent

### 13.3 Accessibility

- [ ] Contrast ratios checked (4.5:1 minimum)
- [ ] Touch targets meet 44x44pt minimum
- [ ] Focus indicators designed
- [ ] Screen reader labels considered
- [ ] Keyboard navigation supported
- [ ] Text scales properly

### 13.4 Performance

- [ ] Images optimized
- [ ] Minimal animations
- [ ] Fast loading considered
- [ ] Progressive enhancement
- [ ] Graceful degradation

### 13.5 Usability

- [ ] Clear information hierarchy
- [ ] Intuitive navigation
- [ ] Easy to learn
- [ ] Error messages helpful
- [ ] Success feedback clear
- [ ] Mobile-friendly

### 13.6 Ad-Free

- [ ] No ad placements
- [ ] No promotional content
- [ ] Clean, focused design
- [ ] All space used for features
- [ ] Professional appearance

---

## Document Approval

**Design Lead:** _____________  
**Product Owner:** _____________  
**Development Lead:** _____________  
**Stakeholder Sign-off:** _____________

**Approved Date:** December 2025  
**Ready for Development:** Yes ✓

---

**Version History**

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | Dec 2025 | Design Team | Initial high-fidelity mockups |

---

## Next Steps

1. **Development:** Implement screens based on these mockups
2. **User Testing:** Validate designs with real users
3. **Iterate:** Refine based on feedback
4. **Document:** Keep mockups updated with changes
5. **Handoff:** Provide design assets to development team
