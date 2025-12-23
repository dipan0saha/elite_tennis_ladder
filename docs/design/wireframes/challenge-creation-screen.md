# Challenge Creation Screen Wireframe

**Screen ID:** WF-003  
**Screen Name:** Challenge Creation  
**Version:** 1.3  
**Status:** Approved  
**Last Updated:** December 20, 2025

**Design Reference:** This wireframe follows the Elite Tennis Ladder Design System. For complete specifications, see:
- Design System: [`docs/design/DESIGN_SYSTEM.md`](../DESIGN_SYSTEM.md)
- UI Mockups: [`docs/design/UI_MOCKUPS.md`](../UI_MOCKUPS.md)

---

## Overview

The Challenge Creation screen allows users to select an opponent and send a match challenge. It provides a streamlined, mobile-optimized interface for initiating challenges with eligible players based on ladder rules.

---

## Screen Layout

```
┌─────────────────────────────────┐
│ ←  Challenge Player        ✕   │ ← Header, 56px height
├─────────────────────────────────┤
│                                 │
│  Who would you like to          │ ← Instruction text
│  challenge?                     │   Body, 16px
│                                 │
│  You can challenge players      │ ← Rule reminder
│  within 3 ranks above you.      │   Caption, 12px, italic
│                                 │
│  ┌───────────────────────────┐  │
│  │ 🔍 Search by name...      │  │ ← Search input, 44px
│  └───────────────────────────┘  │
│                                 │
│  Filter: Eligible Only ▼        │ ← Filter dropdown, 32px
│                                 │
├─────────────────────────────────┤
│  Eligible Opponents (5)         │ ← Section header
│                                 │
│  ┌───────────────────────────┐  │
│  │ #5  👤 Mike Thompson      │  │ ← Player card (selectable)
│  │  🥇  15-3  83% Win        │  │   68px height
│  │  Last active: 2 hours ago │  │   Background: White
│  │         [ SELECT ]         │  │   Border when selected
│  └───────────────────────────┘  │
│                                 │
│  ┌───────────────────────────┐  │
│  │ #6  👤 Sarah Mitchell  ✓  │  │ ← Selected player
│  │  🥈  12-4  75% Win        │  │   Background: #E3F2FD
│  │  Last active: 1 day ago   │  │   Border: #2E7D32 (Tennis Green Primary), 2px
│  │       [ SELECTED ]         │  │
│  └───────────────────────────┘  │
│                                 │
│  ┌───────────────────────────┐  │
│  │ #7  👤 John Davis         │  │
│  │  🥉  11-5  69% Win        │  │
│  │  Last active: 3 hours ago │  │
│  │         [ SELECT ]         │  │
│  └───────────────────────────┘  │
│                                 │
│     ⋯ (scroll for more) ⋯      │
│                                 │
├─────────────────────────────────┤
│  ─── Challenge Details ───      │ ← Collapsible section
│                                 │
│  Add a message (optional)       │ ← Label
│  ┌───────────────────────────┐  │
│  │ Let's have a great match! │  │ ← Text area, 88px height
│  │                           │  │   Max 200 characters
│  │ 25/200                    │  │   Character counter
│  └───────────────────────────┘  │
│                                 │
│  Quick Messages:                │ ← Message templates
│  [Looking forward to it!]       │   Chips, auto-fill
│  [Let's play this week]         │
│                                 │
│  ⏰ Propose match time (optional)│ ← Optional time picker
│  ┌───────────────────────────┐  │
│  │  This Weekend ▼           │  │ ← Dropdown, 44px
│  └───────────────────────────┘  │
│                                 │
├─────────────────────────────────┤
│                                 │
│  ┌───────────────────────────┐  │
│  │    SEND CHALLENGE         │  │ ← Primary CTA, 48px
│  └───────────────────────────┘  │   Enabled when player selected
│                                 │
│        Cancel                   │ ← Secondary action link
│                                 │
└─────────────────────────────────┘
```

**Viewport:** 375px × 812px (iPhone 12/13 standard)

---

## Component Specifications

### 1. Header Bar

**Height:** 56px  
**Background:** White (#FFFFFF)  
**Border Bottom:** 1px solid #E0E0E0

**Elements:**

**Back Button (Left):**
- Icon: ← (left arrow)
- Size: 24px × 24px
- Tap Target: 48px × 48px
- Action: Return to previous screen (confirm if data entered)
- Label: "Back"

**Title (Center):**
- Text: "Challenge Player"
- Typography: H2, 20px, SemiBold, #212121

**Close Button (Right):**
- Icon: ✕ (close)
- Size: 24px × 24px
- Tap Target: 48px × 48px
- Action: Cancel and return (with confirmation)
- Label: "Cancel"

**Accessibility:**
- Back button: "Go back to previous screen"
- Close button: "Cancel challenge creation"

---

### 2. Instruction Section

**Padding:** 16px  
**Background:** #FAFAFA

**Primary Text:**
- Text: "Who would you like to challenge?"
- Typography: Body, 16px, SemiBold, #212121

**Rule Reminder:**
- Text: "You can challenge players within 3 ranks above you."
- Typography: Caption, 12px, Regular, #757575
- Style: Italic
- Icon: ℹ️ (info icon) on left

**Behavior:**
- Tap info icon: Show rules modal with full challenge rules
- Adjusts text based on user's position and ladder settings

**Variations based on user position:**
- Top 3: "You're in the top 3! You can only defend your position."
- Bottom half: "You can challenge players within 3 ranks above you."
- Unranked: "Complete 3 qualifying matches to get ranked."

---

### 3. Search Input

**Height:** 44px  
**Width:** Full width (minus 32px padding)  
**Background:** White  
**Border:** 1px solid #BDBDBD  
**Border Radius:** 22px (pill shape)  
**Padding:** 12px 16px

**Elements:**
- Icon: 🔍 (magnifying glass), 20px, left side
- Placeholder: "Search by name..."
- Clear button: ✕, right side (when text entered)

**Behavior:**
- Tap: Focus input, show keyboard
- Type: Filter eligible players in real-time
- Clear: Tap ✕ to clear text
- No results: Show "No players found" message

**Accessibility:**
- Label: "Search players by name"
- Type: "search"
- Autocomplete: "name"

---

### 4. Filter Dropdown

**Height:** 32px  
**Width:** 160px  
**Background:** #E0E0E0  
**Border Radius:** 16px  
**Padding:** 6px 12px

**Label:** "Filter: Eligible Only ▼"  
**Typography:** Caption, 12px, SemiBold

**Options:**
- All Players (shows ineligible grayed out)
- Eligible Only (default)
- Recently Active (active in last 7 days)
- Available Soon (marked as available)
- Division mates (same division)

**Behavior:**
- Tap: Show dropdown menu
- Select: Update list filter
- Badge: Show count "(5)" of filtered results

---

### 5. Player Selection Cards

#### 5.1 Eligible Player Card (Unselected)

**Height:** 68px  
**Background:** White  
**Border:** 1px solid #E0E0E0  
**Border Radius:** 8px  
**Padding:** 12px  
**Margin:** 8px (vertical)

**Layout:**

```
┌─────────────────────────────────┐
│ #5  [Avatar]  Mike Thompson     │ ← Top line
│  🥇  40×40    15-3  83% Win     │   Avatar + name + stats
│      Last active: 2 hours ago   │ ← Activity status
│           [ SELECT ]             │ ← Action button
└─────────────────────────────────┘
```

**Elements:**

**Rank Badge:**
- Text: "#5"
- Size: 24px × 24px
- Background: #E0E0E0
- Typography: 12px, Bold, #212121
- Position: Top left

**Avatar:**
- Size: 40px × 40px
- Shape: Circle
- Border: 1px solid #BDBDBD
- Position: Next to rank

**Name:**
- Typography: Body, 16px, SemiBold, #212121
- Position: Right of avatar
- Truncate if too long

**Badge/Icon:**
- 🥇 (medal/trophy for top 10)
- Size: 16px
- Position: After name

**Stats:**
- Record: "15-3"
- Win %: "83% Win"
- Typography: Caption, 12px, Regular, #757575
- Position: Below name

**Activity Status:**
- Text: "Last active: 2 hours ago"
- Typography: Caption, 11px, Regular, #757575
- Colors:
  - Green (#4CAF50): Active today
  - Orange (#FFA726): Active this week
  - Gray (#9E9E9E): Active longer ago

**Select Button:**
- Label: "SELECT"
- Size: 80px × 28px
- Background: White
- Border: 1px solid #2E7D32 (Tennis Green Primary)
- Text: #2E7D32 (Tennis Green Primary), 12px, SemiBold
- Border Radius: 14px
- Position: Bottom right

**Accessibility:**
- Label: "Mike Thompson, rank 5, 15 wins, 3 losses, 83% win rate. Last active 2 hours ago. Select button."

---

#### 5.2 Selected Player Card

**Same as unselected, but:**
- Background: #E3F2FD (light blue)
- Border: 2px solid #2E7D32 (Tennis Green Primary)
- Checkmark: ✓ icon in top right corner
- Button: "SELECTED" with solid blue background

**Animation:**
- Checkmark scales in (0.5s bounce)
- Border animates (color fade)
- Background color fades in

**Accessibility:**
- Label: "Sarah Mitchell, rank 6. Selected. Tap to deselect."

---

#### 5.3 Ineligible Player Card

**Display:** Only shown if "All Players" filter selected  
**Same as eligible card, but:**
- Opacity: 0.5
- Border: Dashed, 1px, #BDBDBD
- Button: "INELIGIBLE" (disabled)
- Tooltip: "Must be within 3 ranks above you"

**Accessibility:**
- Label: "Tom Anderson, rank 15. Not eligible to challenge. You can only challenge players within 3 ranks."

---

### 6. Challenge Details Section

**Collapsible Section:**
- Header: "─── Challenge Details ───"
- Initially: Expanded (if player selected)
- Tap header: Collapse/expand
- Animation: Smooth expand/collapse (300ms)

---

#### 6.1 Message Text Area

**Label:** "Add a message (optional)"  
**Height:** 88px (3 lines)  
**Max Length:** 200 characters  
**Background:** White  
**Border:** 1px solid #BDBDBD  
**Border Radius:** 8px  
**Padding:** 12px

**Placeholder:**
"Let's have a great match!"

**Character Counter:**
- Position: Bottom right of text area
- Text: "25/200"
- Typography: Caption, 11px, Regular
- Colors:
  - Gray (#757575): < 180 characters
  - Orange (#FFA726): 180-200 characters
  - Red (#F44336): 200 characters (limit)

**Behavior:**
- Auto-expand: Up to 5 lines
- Scroll: If exceeds 5 lines
- Emoji support: Yes
- Validation: No profanity, respectful

**Accessibility:**
- Label: "Optional challenge message. Maximum 200 characters."
- Live region: Announces character count

---

#### 6.2 Quick Message Templates

**Label:** "Quick Messages:"  
**Position:** Below text area

**Template Chips:**
- "Looking forward to it!"
- "Let's play this week"
- "Best of luck!"
- "Game on!"

**Chip Style:**
- Height: 28px
- Background: #E0E0E0
- Border Radius: 14px
- Typography: 12px, Regular, #212121
- Padding: 6px 12px
- Margin: 4px

**Behavior:**
- Tap chip: Fill text area with template
- Multiple taps: Replace previous
- Manual edit: Hide chips (after edit)

**Accessibility:**
- Each chip: "Quick message: Looking forward to it. Tap to use."

---

#### 6.3 Match Time Proposal (Optional)

**Label:** "⏰ Propose match time (optional)"  
**Height:** 44px  
**Type:** Dropdown select

**Options:**
- "Select a time" (placeholder)
- "This Weekend"
- "Next Week"
- "Within 2 Weeks"
- "Within a Month"
- "Custom Date/Time"

**Custom Date/Time:**
- Opens date picker modal
- Select date (calendar view)
- Select time (hour/minute)
- Timezone auto-detected

**Display:**
- Dropdown: "This Weekend ▼"
- Custom: "Sat, Jan 15, 2:00 PM"

**Behavior:**
- Optional field
- Can be edited after challenge sent
- Helps coordinate scheduling

**Accessibility:**
- Label: "Propose a match time. Optional."
- Dropdown role: "combobox"

---

### 7. Send Challenge Button (Primary CTA)

**Height:** 48px  
**Width:** Full width (minus 32px padding)  
**Position:** Bottom of screen, 24px from bottom nav

**States:**

**Enabled (Player Selected):**
- Background: #2E7D32 (Tennis Green Primary)
- Text: "SEND CHALLENGE", white, 16px, SemiBold
- Border Radius: 24px
- Shadow: 0px 2px 4px rgba(0,0,0,0.2)

**Disabled (No Player Selected):**
- Background: #BDBDBD (gray)
- Text: "SELECT A PLAYER", #757575, 16px, SemiBold
- No shadow
- Not interactive

**Loading:**
- Background: #2E7D32 (Tennis Green Primary)
- Text: "SENDING..."
- Spinner animation
- Disabled

**Behavior:**
1. Validate: Ensure player selected
2. Show loading state
3. Send challenge API call
4. On success:
   - Show success modal/toast
   - Navigate back to ladder view
   - Update opponent card to "Pending"
5. On failure:
   - Show error message
   - Re-enable button

**Success Message:**
"Challenge sent to Sarah Mitchell! You'll be notified when they respond."

**Accessibility:**
- Enabled: "Send challenge to Sarah Mitchell"
- Disabled: "Send challenge button. Disabled. Select a player first."
- Loading: "Sending challenge. Please wait."

---

### 8. Cancel Link

**Position:** Below send button, centered  
**Text:** "Cancel"  
**Typography:** Body, 14px, Regular, #757575  
**Tap Target:** 48px height

**Behavior:**
- Tap: Confirm if data entered
- Confirmation: "Discard challenge?"
  - "Discard" button
  - "Keep Editing" button
- Action: Return to previous screen

**Accessibility:**
- Label: "Cancel challenge creation"

---

## Interaction Behaviors

### Player Selection
- **Single tap card:** Select player (toggle selection)
- **Single tap button:** Select player
- **Long press card:** Show player profile preview
- **Swipe card:** Quick actions (view profile, view history)

### Auto-scroll on Selection
- When player selected, scroll to show challenge details
- Smooth animation (300ms ease-in-out)
- Ensure send button visible

### Real-time Validation
- Check eligibility as user searches
- Update eligible count dynamically
- Show/hide ineligible players based on filter

### Keyboard Behavior
- Search focuses keyboard
- Done/Return closes keyboard
- Message field supports return for new line

---

## User Flows

### Flow 1: Quick Challenge (Minimal Interaction)

```
1. User taps "Challenge" on ladder view
2. Challenge screen opens with eligible players
3. User taps first eligible player card
4. Card highlights, send button enables
5. User taps "SEND CHALLENGE"
6. Loading state shows (1-2 seconds)
7. Success toast appears
8. Returns to ladder view
9. Opponent card shows "Pending"
```

**Target Time:** 10-15 seconds  
**Tap Count:** 3 taps (minimize friction)

---

### Flow 2: Challenge with Message

```
1. User opens challenge screen
2. User searches for specific player
3. User selects player from filtered results
4. User taps message field
5. User types custom message
6. User taps "SEND CHALLENGE"
7. Success confirmation shown
8. Returns to ladder view
```

**Target Time:** 30-45 seconds

---

### Flow 3: Challenge with Time Proposal

```
1. User opens challenge screen
2. User selects opponent
3. Auto-scroll to details section
4. User taps time dropdown
5. User selects "This Weekend"
6. User optionally adds message
7. User taps "SEND CHALLENGE"
8. Confirmation shown with proposed time
9. Returns to ladder view
```

**Target Time:** 20-30 seconds

---

### Flow 4: Cancel Challenge Creation

```
1. User opens challenge screen
2. User selects player and adds message
3. User taps "Cancel" or back button
4. Confirmation modal: "Discard challenge?"
5. User taps "Discard"
6. Returns to previous screen
```

**Alternative:** User taps "Keep Editing" → Returns to form

---

## Responsive Behavior

### Small Mobile (320px - 374px)
- Reduce padding: 12px sides
- Smaller avatars: 36px
- Stack info more vertically
- Single column for chips

### Standard Mobile (375px - 413px)
- As specified (optimal)

### Large Mobile (414px+)
- Larger cards: 76px height
- More spacious layout
- Two columns for chips

### Tablet (768px+)
- Split view: List left, details right
- Wider text area
- Side panel for selected player details

### Landscape
- Horizontal split layout
- Fixed details panel (right)
- Scrollable player list (left)

---

## Accessibility Features

### Screen Reader Support

**Page Announcement:**
"Challenge Player screen. Select an opponent from the list of 5 eligible players."

**Card Announcements:**
"Mike Thompson, rank 5, 15 wins 3 losses, 83% win rate. Last active 2 hours ago. Select button."

**Action Announcements:**
- "Sarah Mitchell selected"
- "Challenge message entered"
- "Sending challenge"
- "Challenge sent successfully"

### Keyboard Navigation
- Tab through all interactive elements
- Enter/Space to select player
- Arrow keys to navigate list
- Escape to cancel

### Visual Indicators
- High contrast mode support
- Focus indicators (2px blue outline)
- Selected state clearly visible
- Status icons with text labels

### Haptic Feedback
- Player selection
- Button tap
- Success/error states

---

## Empty States

### No Eligible Opponents
```
┌─────────────────────────────────┐
│           ⚠️                    │
│    No eligible opponents        │
│                                 │
│  You currently have no players  │
│  within challenge range. Try:   │
│                                 │
│  • Waiting for pending          │
│    challenges to complete       │
│  • Playing qualifying matches   │
│  • Checking back later          │
│                                 │
│     [BACK TO LADDER]            │
└─────────────────────────────────┘
```

### Search No Results
```
┌─────────────────────────────────┐
│           🔍                    │
│    No players found             │
│                                 │
│  No players match your search   │
│  "Alex". Try a different name.  │
│                                 │
│     [CLEAR SEARCH]              │
└─────────────────────────────────┘
```

---

## Loading States

### Initial Load
- Skeleton screens for player cards
- Shimmer animation
- Load eligible players first
- Then load player details

### Sending Challenge
- Button shows loading spinner
- "SENDING..." text
- Disable all interactions
- Show progress (if slow network)

---

## Error States

### Challenge Send Failed
```
┌─────────────────────────────────┐
│           ⚠️                    │
│    Challenge Failed             │
│                                 │
│  Unable to send challenge to    │
│  Sarah Mitchell. Please try     │
│  again.                         │
│                                 │
│  Error: Network timeout         │
│                                 │
│     [RETRY]    [CANCEL]         │
└─────────────────────────────────┘
```

### Player No Longer Eligible
```
Toast notification:
"Sarah Mitchell is no longer eligible to challenge. 
Please select another player."
```

### Rate Limit Reached
```
┌─────────────────────────────────┐
│           ⏱️                    │
│    Challenge Limit Reached      │
│                                 │
│  You already have 2 pending     │
│  challenges. Wait for a         │
│  response before challenging    │
│  more players.                  │
│                                 │
│     [VIEW CHALLENGES]           │
└─────────────────────────────────┘
```

---

## Success States

### Challenge Sent Successfully

**Modal:**
```
┌─────────────────────────────────┐
│           ✅                    │
│    Challenge Sent!              │
│                                 │
│  Your challenge has been sent   │
│  to Sarah Mitchell.             │
│                                 │
│  You'll receive a notification  │
│  when they respond.             │
│                                 │
│     [VIEW CHALLENGES]           │
│     [CHALLENGE ANOTHER]         │
└─────────────────────────────────┘
```

**Toast (Alternative):**
"Challenge sent to Sarah Mitchell! ✓"

**Haptic:** Success vibration pattern

---

## Performance Targets

| Metric | Target | Notes |
|--------|--------|-------|
| Screen Load | < 1 second | Load eligible players |
| Search Filter | < 100ms | Real-time filter |
| Send Challenge | < 2 seconds | API response |
| Animation FPS | 60 fps | Smooth transitions |

---

## Development Notes

### Technical Implementation
- Cache eligible players list
- Validate eligibility client-side
- Optimistic UI updates
- Queue challenges if offline
- Retry failed requests automatically

### API Endpoints
- `GET /challenges/eligible-opponents` - Get eligible players
- `POST /challenges/create` - Send challenge
- `GET /players/:id` - Player details

### Analytics Events
- `challenge_screen_open`
- `player_selected`
- `message_added`
- `time_proposed`
- `challenge_sent`
- `challenge_cancelled`

---

## Testing Checklist

### Functional Testing
- [ ] Eligible players load correctly
- [ ] Search filters work
- [ ] Player selection works
- [ ] Message validation works
- [ ] Challenge sends successfully
- [ ] Error handling works
- [ ] Cancel confirmation works

### UI Testing
- [ ] Touch targets ≥ 44×44px
- [ ] Animations smooth (60fps)
- [ ] Loading states display
- [ ] Error states display
- [ ] Success feedback shown

### Accessibility Testing
- [ ] Screen reader navigation
- [ ] Keyboard navigation
- [ ] Focus indicators visible
- [ ] Color contrast meets WCAG AA
- [ ] Touch targets adequate

### Performance Testing
- [ ] Load time < 1 second
- [ ] Search responds instantly
- [ ] No lag on large player lists

---

**Wireframe Version:** 1.3  
**Status:** ✅ Approved  
**Ready for:** High-Fidelity Design  
**Last Review:** December 20, 2025
