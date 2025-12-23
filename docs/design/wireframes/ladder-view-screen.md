# Ladder View Screen Wireframe

**Screen ID:** WF-002  
**Screen Name:** Ladder View (Home Screen)  
**Version:** 1.3  
**Status:** Approved  
**Last Updated:** December 20, 2025

**Design Reference:** This wireframe follows the Elite Tennis Ladder Design System. For complete specifications, see:
- Design System: [`docs/design/DESIGN_SYSTEM.md`](../DESIGN_SYSTEM.md)
- UI Mockups: [`docs/design/UI_MOCKUPS.md`](../UI_MOCKUPS.md)

---

## Overview

The Ladder View is the primary screen of the Elite Tennis Ladder application. It displays current rankings, player standings, and provides quick access to core features like challenging other players. This is the default screen users see after login.

---

## Screen Layout

```
┌─────────────────────────────────┐
│ ☰  Ladder View          🔔(3)  │ ← Header, 56px height
├─────────────────────────────────┤
│                                 │
│  ┌──────────  You  ──────────┐  │ ← Current user position card
│  │  📊 Your Ranking: #8      │  │   Sticky, always visible
│  │  ⬆️ Up 2 spots this week  │  │   Background: #E3F2FD
│  └───────────────────────────┘  │   56px height
│                                 │
│  🔍 Search players...      ⚙️   │ ← Search bar, 44px height
│                                 │
│  Division: All ▼   Active only  │ ← Filters, 40px height
│                                 │
├─────────────────────────────────┤
│  👑 Top Players                 │ ← Section header
│                                 │
│  ┌───────────────────────────┐  │
│  │ #1  👤 Mike Thompson      │  │ ← Player card (rank 1-3)
│  │     15-3  83% Win  ⭐⭐⭐  │  │   Highlighted style
│  │     [CHALLENGE] ───────── →│  │   72px height
│  └───────────────────────────┘  │
│                                 │
│  ┌───────────────────────────┐  │
│  │ #2  👤 Sarah Mitchell     │  │
│  │     12-4  75% Win  ⭐⭐    │  │
│  │     [CHALLENGE] ───────── →│  │
│  └───────────────────────────┘  │
│                                 │
│  ┌───────────────────────────┐  │
│  │ #3  👤 John Davis         │  │
│  │     11-5  69% Win  ⭐⭐    │  │
│  │     [CHALLENGE] ───────── →│  │
│  └───────────────────────────┘  │
│                                 │
├─────────────────────────────────┤
│  ─── Players Near You ───       │ ← Section divider
│                                 │
│  ┌───────────────────────────┐  │
│  │ #6  👤 Emma Wilson        │  │ ← Standard player card
│  │     9-6   60% Win         │  │   56px height
│  │     [CHALLENGE] ───────── →│  │
│  └───────────────────────────┘  │
│                                 │
│  ┌───────────────────────────┐  │
│  │ #7  👤 David Lee          │  │
│  │     8-5   62% Win         │  │
│  │     [CHALLENGE] ───────── →│  │
│  └───────────────────────────┘  │
│                                 │
│  ┌───────────────────────────┐  │ ← Current user (you)
│  │ #8  👤 YOU ⭐             │  │   Different background
│  │     7-4   64% Win         │  │   #FFF9C4 (light yellow)
│  │     [VIEW PROFILE] ──────→│  │
│  └───────────────────────────┘  │
│                                 │
│  ┌───────────────────────────┐  │ ← Players you can challenge
│  │ #9  👤 Lisa Rodriguez     │  │   Show if within range
│  │     7-6   54% Win    ⬇️   │  │   (default: ±3 spots)
│  │     [CHALLENGE] ───────── →│  │
│  └───────────────────────────┘  │
│                                 │
│  ┌───────────────────────────┐  │
│  │ #10 👤 Tom Anderson       │  │
│  │     6-7   46% Win    ⬇️   │  │
│  │     [CHALLENGE] ───────── →│  │
│  └───────────────────────────┘  │
│                                 │
│     ⋯ (scroll for more) ⋯      │ ← Infinite scroll indicator
│                                 │
├─────────────────────────────────┤
│  [+] Challenge              FAB │ ← Floating Action Button
│                                 │   56px × 56px
├─────────────────────────────────┤
│  🏆  💪  📊  👤  ⋯             │ ← Bottom Navigation Bar
│ Ladder Challenge Stats Profile │   56px height
└─────────────────────────────────┘
```

**Viewport:** 375px × 812px (iPhone 12/13 standard)

---

## Component Specifications

### 1. Header Bar

**Height:** 56px  
**Background:** White (#FFFFFF)  
**Shadow:** 0px 2px 4px rgba(0,0,0,0.1)  
**Position:** Fixed at top

**Elements:**

**Hamburger Menu (Left):**
- Icon: ☰ (menu icon)
- Size: 24px × 24px
- Tap Target: 48px × 48px
- Action: Opens side navigation drawer
- Items: Settings, Help, About, Logout

**Title (Center):**
- Text: "Ladder View"
- Typography: H2, 20px, SemiBold, #212121
- Truncate if needed

**Notification Badge (Right):**
- Icon: 🔔 (bell icon), 24px × 24px
- Badge: Red circle with count, 18px diameter
- Tap Target: 48px × 48px
- Action: Opens notification center
- Shows unread count (e.g., "3")

**Accessibility:**
- Menu button: "Open navigation menu"
- Notifications: "3 unread notifications. Tap to view."

---

### 2. Current User Position Card (Sticky)

**Position:** Sticky below header  
**Height:** 56px  
**Background:** Light blue (#E3F2FD)  
**Border:** 1px solid #2E7D32 (Tennis Green Primary)  
**Border Radius:** 8px  
**Padding:** 12px  
**Margin:** 16px (sides)

**Content:**

**Left Section:**
- Icon: 📊 (trophy/ranking icon)
- Text Line 1: "Your Ranking: #8"
  - Typography: Body, 16px, SemiBold, #212121
- Text Line 2: "⬆️ Up 2 spots this week"
  - Typography: Caption, 12px, Regular, #4CAF50 (success green)
  - Conditional: "⬇️ Down X spots" (red), "→ No change" (gray)

**Right Section:**
- Chevron icon: → (indicates tappable)
- Action: Navigate to profile/statistics

**Behavior:**
- Tap card: Navigate to user profile
- Always visible while scrolling
- Updates in real-time on ranking change
- Celebratory animation when ranking improves

**Accessibility:**
- Label: "Your current ranking is 8. Up 2 spots this week. Tap to view your profile."

---

### 3. Search and Filter Bar

**Search Input:**
- Height: 44px
- Width: Full width (minus 64px for filter icon)
- Placeholder: "🔍 Search players..."
- Background: #F5F5F5
- Border Radius: 22px (pill shape)
- Padding: 12px 16px

**Behavior:**
- Tap: Expand to full width, show cancel button
- Type: Filter list in real-time
- Search: Name, ranking, division
- Cancel: Return to normal state, clear search

**Filter Button (Settings Icon):**
- Icon: ⚙️, 24px × 24px
- Tap Target: 48px × 48px
- Position: Right of search bar
- Action: Open filter bottom sheet

**Filter Chips (Below Search):**
- Division filter: "Division: All ▼"
- Status filter: "Active only" (toggle)
- Height: 32px each
- Background: #E0E0E0 (inactive), #2E7D32 (Tennis Green Primary - active)
- Border Radius: 16px

**Filter Options (Bottom Sheet):**
- Division: All, A, B, C, etc.
- Status: All, Active, Inactive, On vacation
- Gender: All, Male, Female, Mixed
- Availability: All, Available now, This week
- Sort by: Ranking, Name, Win %, Recent activity

**Accessibility:**
- Search: "Search players by name or ranking"
- Filter button: "Open filter options"
- Active filters: "Filtering by: Active players only"

---

### 4. Section Headers

**Typography:** Body, 14px, SemiBold, #757575  
**Background:** #FAFAFA  
**Height:** 32px  
**Padding:** 8px 16px  
**Text Transform:** Uppercase

**Examples:**
- "👑 TOP PLAYERS"
- "─── PLAYERS NEAR YOU ───"
- "⬇️ LOWER RANKS"

**Purpose:**
- Visually separate sections
- Provide context
- Break up long lists

---

### 5. Player Cards

#### 5.1 Top Player Card (Ranks 1-3)

**Height:** 72px  
**Background:** White  
**Border:** 1px solid #E0E0E0  
**Border Radius:** 8px  
**Shadow:** 0px 1px 3px rgba(0,0,0,0.1)  
**Margin:** 8px (horizontal), 4px (vertical)  
**Padding:** 12px

**Layout:**

```
┌─────────────────────────────────┐
│ #1  [Avatar]  Mike Thompson     │ ← Header line
│  👤  40×40     15-3  83% Win    │ ← Stats line
│               ⭐⭐⭐             │ ← Rating stars
│     [CHALLENGE] ──────────────→│ ← Action button
└─────────────────────────────────┘
```

**Elements:**

**Rank Badge:**
- Size: 32px × 32px
- Background: #FFD700 (gold) for #1, #C0C0C0 (silver) for #2, #CD7F32 (bronze) for #3
- Text: "#1", "#2", "#3"
- Typography: 16px, Bold, White
- Shape: Circle
- Position: Left side

**Avatar:**
- Size: 40px × 40px
- Shape: Circle
- Border: 2px solid #2E7D32 (Tennis Green Primary)
- Placeholder: Initials if no photo
- Position: Next to rank

**Name:**
- Typography: Body, 16px, SemiBold, #212121
- Position: Right of avatar, top line
- Truncate with ellipsis if too long (max 18 chars)

**Stats Line:**
- Record: "15-3" (wins-losses)
- Win Percentage: "83% Win"
- Typography: Caption, 12px, Regular, #757575
- Position: Below name

**Rating Stars:**
- Display: ⭐⭐⭐ (1-5 stars based on performance)
- Size: 16px each
- Color: #FFA726 (gold)

**Challenge Button:**
- Label: "CHALLENGE"
- Size: 100px × 32px
- Background: #2E7D32 (Tennis Green Primary)
- Text: White, 12px, SemiBold
- Border Radius: 16px
- Position: Right side, centered vertically

**Chevron Icon:**
- Icon: →
- Size: 16px × 16px
- Color: #757575
- Action: View full profile

**Accessibility:**
- Label: "Mike Thompson, rank 1, 15 wins, 3 losses, 83% win rate, 5 stars. Challenge button."

---

#### 5.2 Standard Player Card

**Height:** 56px  
**Background:** White  
**Border:** 1px solid #E0E0E0  
**Border Radius:** 8px  
**Padding:** 8px 12px

**Layout:**

```
┌─────────────────────────────────┐
│ #8  [Avt] Name          [BTN]→ │
│  👤 32×32  9-6  60% Win        │
└─────────────────────────────────┘
```

**Differences from Top Player Card:**
- Smaller avatar: 32px × 32px
- No rating stars
- Simpler layout (single line for stats)
- Rank shown as "#8" (no special badge)

**Challenge Eligibility Indicator:**
- If can challenge: Green border on left (4px)
- If cannot challenge: Gray appearance, disabled button
- If already challenged: Show "Pending" badge

---

#### 5.3 Current User Card (Your Position)

**Same as standard card, but:**
- Background: #FFF9C4 (light yellow)
- Border: 2px solid #FFA726 (orange)
- Text: "YOU ⭐" instead of name
- Button: "VIEW PROFILE" instead of "CHALLENGE"
- Always visible (scrolls to on page load)

**Accessibility:**
- Label: "This is your position. You are ranked 8. 7 wins, 4 losses. Tap to view your profile."

---

### 6. Floating Action Button (FAB)

**Position:** Bottom right, 16px from bottom nav, 16px from right  
**Size:** 56px × 56px  
**Background:** #4CAF50 (success green)  
**Icon:** + (plus sign), white, 24px  
**Shadow:** 0px 4px 12px rgba(0,0,0,0.3)  
**Shape:** Circle

**Behavior:**
- Tap: Open challenge creation screen
- Scroll: Hide when scrolling down, show when scrolling up
- Animation: Scale on press, bounce on appear

**States:**
- **Default:** Green background, white icon
- **Active:** Darker green (#388E3C)
- **Disabled:** Gray (#BDBDBD), if no eligible opponents

**Accessibility:**
- Label: "Create new challenge"
- Role: "button"
- Hint: "Opens challenge creation screen"

---

### 7. Bottom Navigation Bar

**Height:** 56px  
**Background:** White (#FFFFFF)  
**Border Top:** 1px solid #E0E0E0  
**Shadow:** 0px -2px 4px rgba(0,0,0,0.1)  
**Position:** Fixed at bottom

**Navigation Items:**

| Icon | Label | Screen | Active State |
|------|-------|--------|--------------|
| 🏆 | Ladder | Ladder View | Blue icon + label |
| 💪 | Challenges | Challenge Management | Gray |
| 📊 | Stats | Statistics | Gray |
| 👤 | Profile | User Profile | Gray |
| ⋯ | More | Menu | Gray |

**Item Specifications:**
- Icon size: 24px × 24px
- Label: 10px, Regular
- Tap target: Full width divided by 5 items
- Active color: #2E7D32 (Tennis Green Primary)
- Inactive color: #757575 (gray)
- Animation: Icon scale + color fade on tap

**Accessibility:**
- Each item: "Ladder tab, 1 of 5, selected" / "Challenges tab, 2 of 5"
- Role: "tab"
- Keyboard: Arrow keys to navigate

---

## Interaction Behaviors

### Pull-to-Refresh
- Pull down from top (below sticky card)
- Show loading spinner
- Fetch latest rankings
- Animate rank changes
- Haptic feedback on refresh complete

### Infinite Scroll
- Load next 20 players when user scrolls to bottom
- Show loading indicator
- Smooth append to list
- No jump in scroll position

### Swipe Actions on Cards
- Swipe right: Quick challenge (if eligible)
- Swipe left: View profile
- Visual feedback: Card slides, action icon revealed
- Haptic feedback on action trigger

### Ranking Change Animation
- When ranking updates in real-time:
  - Highlight affected cards (yellow flash)
  - Animate position changes (slide up/down)
  - Update sticky user card
  - Show toast: "Your ranking changed to #6!"
  - Duration: 500ms

### Card Press States
- **Short press:** View profile
- **Long press:** Show quick actions menu
  - Challenge
  - View full profile
  - View match history
  - Message (future feature)

---

## User Flows

### Flow 1: View Rankings (Default Flow)

```
1. User logs in → Ladder View loads
2. Scroll to user's position (animated)
3. Sticky card shows current rank
4. User scrolls to explore rankings
5. User returns to top with tap on header/tab
```

**Performance Target:** Initial load < 1 second

---

### Flow 2: Quick Challenge from Ladder

```
1. User views eligible opponent card
2. User taps "CHALLENGE" button
3. Challenge confirmation modal appears
4. User confirms → Challenge sent
5. Card updates to show "Pending"
6. Toast notification: "Challenge sent to Mike Thompson"
7. Returns to ladder view
```

**Performance Target:** Complete flow in < 10 seconds

---

### Flow 3: Search for Specific Player

```
1. User taps search bar → Keyboard appears
2. User types player name
3. List filters in real-time
4. User taps player card → View profile
5. User taps back → Returns to filtered list
6. User taps Cancel → Returns to full list
```

**Performance Target:** Search results < 200ms

---

### Flow 4: Filter by Division

```
1. User taps filter icon (⚙️)
2. Bottom sheet appears with filter options
3. User selects "Division B"
4. Sheet closes (slide down animation)
5. List updates to show only Division B players
6. Filter chip shows "Division: B"
7. User can tap chip to remove filter
```

---

### Flow 5: Respond to Ranking Change

```
1. User receives push notification: "Your ranking changed!"
2. User taps notification
3. App opens to Ladder View
4. Animated scroll to user's new position
5. Rank change indicator shows (⬆️ Up 2 spots)
6. Confetti animation (if significant improvement)
7. User sees new neighboring players
```

---

## Responsive Behavior

### Small Mobile (320px - 374px)
- Reduce padding: 8px sides
- Avatar: 28px (top cards), 24px (standard)
- Font sizes: -1px adjustment
- Hide win percentage, show only record
- Stack info vertically if needed

### Standard Mobile (375px - 413px)
- As specified above
- Optimal layout

### Large Mobile (414px+)
- Increase padding: 20px sides
- Larger avatars: 44px (top), 36px (standard)
- More generous spacing

### Tablet (768px+)
- Two-column layout (ladder + player detail)
- Max width: 600px for list, 400px for detail
- Side-by-side navigation
- Floating panels

### Landscape
- Shorter card heights
- Horizontal scroll for player details
- Maintain bottom nav visibility
- Adjust FAB position

---

## Accessibility Features

### Screen Reader Support

**Page Announcement:**
"Ladder View. Showing 40 players. You are ranked 8, up 2 spots this week."

**Card Announcements:**
- "Mike Thompson, rank 1, 15 wins, 3 losses, 83% win rate. Challenge button."
- "Your position. You are ranked 8. 7 wins, 4 losses, 64% win rate. View profile button."

**Action Announcements:**
- "Challenge sent successfully"
- "Loading more players"
- "Rankings refreshed"

### Keyboard Navigation
- Tab through all interactive elements
- Enter/Space to activate buttons
- Arrow keys to navigate list
- Escape to close modals/sheets

### Visual Indicators
- High contrast mode support
- Focus indicators (2px blue outline)
- No color-only information
- Icons with labels

### Haptic Feedback
- Challenge button tap
- Pull-to-refresh trigger
- Swipe action trigger
- Ranking change update

---

## Empty States

### No Players in Ladder
```
┌─────────────────────────────────┐
│           🎾                    │
│    No players in the ladder    │
│         yet!                    │
│                                 │
│  Be the first to join and      │
│  start climbing the ranks.     │
│                                 │
│     [INVITE PLAYERS]            │
└─────────────────────────────────┘
```

### No Search Results
```
┌─────────────────────────────────┐
│           🔍                    │
│    No players found             │
│                                 │
│  Try adjusting your search      │
│  or filters.                    │
│                                 │
│     [CLEAR SEARCH]              │
└─────────────────────────────────┘
```

### No Eligible Opponents
```
┌─────────────────────────────────┐
│           ⚠️                    │
│  No eligible opponents          │
│  to challenge right now         │
│                                 │
│  You can challenge players      │
│  within 3 ranks of your         │
│  position.                      │
│                                 │
│  Check back later or wait       │
│  for pending challenges.        │
└─────────────────────────────────┘
```

---

## Loading States

### Initial Load
- Show skeleton screens (gray placeholders)
- Animate shimmer effect
- Load user position first
- Then load top players
- Finally load full list

### Pull-to-Refresh
- Show spinner at top
- Rotate 360° while loading
- Animate new data appearing
- Haptic feedback when complete

### Infinite Scroll Load
- Show spinner at bottom
- "Loading more players..."
- Smooth append without jump

---

## Error States

### Network Error
```
┌─────────────────────────────────┐
│           📡                    │
│    Unable to load rankings      │
│                                 │
│  Please check your internet     │
│  connection and try again.      │
│                                 │
│     [RETRY]                     │
└─────────────────────────────────┘
```

### Server Error
```
┌─────────────────────────────────┐
│           ⚠️                    │
│    Something went wrong         │
│                                 │
│  We're working to fix the       │
│  issue. Please try again later. │
│                                 │
│     [RETRY]    [GO BACK]        │
└─────────────────────────────────┘
```

---

## Performance Targets

| Metric | Target | Notes |
|--------|--------|-------|
| Initial Load | < 1.5 seconds | First 20 players |
| Scroll to User | < 500ms | Animated scroll |
| Search Filter | < 200ms | Real-time filter |
| Pull-to-Refresh | < 2 seconds | Full refresh |
| Card Animation | 60 fps | Smooth transitions |
| Infinite Scroll | < 1 second | Load next batch |

---

## Development Notes

### Technical Implementation
- Virtual scrolling for long lists (performance)
- Lazy load avatars (progressive enhancement)
- Cache rankings locally (offline support)
- WebSocket for real-time updates
- Optimistic UI updates

### API Endpoints
- `GET /ladder/rankings` - Get all rankings
- `GET /ladder/rankings?division=B` - Filter by division
- `GET /ladder/player/:id` - Get player details
- `POST /challenges/create` - Create challenge
- `WS /ladder/updates` - Real-time ranking updates

### Analytics Events
- `ladder_view_load`
- `player_card_tap`
- `challenge_button_tap`
- `search_used`
- `filter_applied`
- `pull_to_refresh`

---

## Testing Checklist

### Functional Testing
- [ ] Rankings display correctly
- [ ] User position highlighted
- [ ] Search filters work
- [ ] Challenge button enabled/disabled correctly
- [ ] Pull-to-refresh updates data
- [ ] Infinite scroll loads more
- [ ] Filters apply correctly

### UI Testing
- [ ] Sticky user card stays visible
- [ ] Cards have proper touch targets (44×44px)
- [ ] Animations smooth (60fps)
- [ ] Empty states display
- [ ] Loading states display
- [ ] Error states display and recover

### Accessibility Testing
- [ ] Screen reader announces correctly
- [ ] Keyboard navigation works
- [ ] Focus indicators visible
- [ ] High contrast mode works
- [ ] Touch targets adequate

### Performance Testing
- [ ] Initial load < 1.5 seconds
- [ ] Smooth scrolling with 100+ players
- [ ] Search responds instantly
- [ ] No memory leaks on long usage

---

**Wireframe Version:** 1.3  
**Status:** ✅ Approved  
**Ready for:** High-Fidelity Design  
**Last Review:** December 20, 2025
