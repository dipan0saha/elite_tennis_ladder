# Profile Screen Wireframe

**Screen ID:** WF-004  
**Screen Name:** User Profile  
**Version:** 1.3  
**Status:** Approved  
**Last Updated:** December 20, 2025

**Design Reference:** This wireframe follows the Elite Tennis Ladder Design System. For complete specifications, see:
- Design System: [`docs/design/DESIGN_SYSTEM.md`](../DESIGN_SYSTEM.md)
- UI Mockups: [`docs/design/UI_MOCKUPS.md`](../UI_MOCKUPS.md)

---

## Overview

The Profile Screen displays comprehensive user information, statistics, match history, and settings. It serves as the central hub for users to view their performance, manage their account, and track their progress on the ladder.

---

## Screen Layout

```
┌─────────────────────────────────┐
│ ←  Profile              ⚙️ ⋮   │ ← Header, 56px height
├─────────────────────────────────┤
│        [Profile Photo]          │ ← Profile header section
│         120×120px               │   Background gradient
│                                 │   or team colors
│      John Smith                 │   H2, 24px, Bold
│      Rank #8 of 40              │   Body, 14px, Regular
│      ⬆️ Up 2 this week          │   Caption, 12px, Green
│                                 │
│  [✏️ Edit Profile]              │ ← Edit button, 36px height
│                                 │
├─────────────────────────────────┤
│                                 │
│  ┌──────┬──────┬──────┬──────┐ │ ← Stats cards row
│  │  7   │  4   │ 64%  │  3   │ │   4 columns
│  │ WINS │LOSSES│WIN % │STREAK│ │   Each 80px wide
│  └──────┴──────┴──────┴──────┘ │   56px height
│                                 │
├─────────────────────────────────┤
│  About | Stats | History | ⚙️  │ ← Tab navigation
│  ━━━━━━                         │   48px height
├─────────────────────────────────┤
│                                 │
│  📧 Email                       │ ← About tab content
│     john.smith@email.com        │   (default selected)
│                                 │
│  📱 Phone                       │
│     (555) 123-4567              │
│                                 │
│  📍 Club                        │
│     Riverside Tennis Club       │
│                                 │
│  🏷️ Division                    │
│     Division A                  │
│                                 │
│  📅 Member Since                │
│     January 2025                │
│                                 │
│  ℹ️ Bio                         │
│     Competitive player who      │
│     loves the game. Looking     │
│     to improve and have fun!    │
│                                 │
│  🎯 Playing Style               │
│     Aggressive baseline         │
│                                 │
│  📊 NTRP Rating                 │
│     4.0                         │
│                                 │
├─────────────────────────────────┤
│                                 │
│  🏆  Achievements                │ ← Badges section
│                                 │
│  [🥇][⚡][🎯][🔥][💪]          │ ← Badge icons
│                                 │
└─────────────────────────────────┘
│  🏆  💪  📊  👤  ⋮             │ ← Bottom nav
│ Ladder Challenge Stats Profile │
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
- Action: Return to previous screen
- Only shows if navigated from another screen

**Title (Center):**
- Text: "Profile"
- Typography: H2, 20px, SemiBold, #212121

**Settings Button (Right 1):**
- Icon: ⚙️ (gear icon), 24px × 24px
- Tap Target: 48px × 48px
- Action: Navigate to settings screen

**More Menu (Right 2):**
- Icon: ⋮ (vertical ellipsis)
- Size: 24px × 24px
- Tap Target: 48px × 48px
- Action: Show dropdown menu
  - Share Profile
  - Report Issue
  - Help & Support
  - Logout

**Accessibility:**
- Settings: "Open settings"
- Menu: "More options. Share profile, report issue, help, logout."

---

### 2. Profile Header Section

**Height:** 280px  
**Background:** Linear gradient (#2E7D32 to #1B5E20) or custom  
**Padding:** 24px

**Profile Photo:**
- Size: 120px × 120px
- Shape: Circle
- Border: 4px solid white
- Shadow: 0px 4px 8px rgba(0,0,0,0.2)
- Position: Centered horizontally, 32px from top
- Placeholder: Initials with color background if no photo

**Photo Actions:**
- Tap: View full-size photo / Upload new photo
- Badge: Small camera icon overlay (bottom right)

**Name:**
- Text: "John Smith"
- Typography: H2, 24px, Bold, White
- Position: Below photo, 16px spacing
- Alignment: Centered

**Rank Display:**
- Text: "Rank #8 of 40"
- Typography: Body, 14px, Regular, White (80% opacity)
- Position: Below name, 4px spacing
- Alignment: Centered

**Rank Change Indicator:**
- Text: "⬆️ Up 2 this week"
- Typography: Caption, 12px, SemiBold
- Colors:
  - Green (#4CAF50): Rank improved
  - Red (#F44336): Rank decreased
  - Gray (#9E9E9E): No change
- Position: Below rank, 4px spacing
- Alignment: Centered

**Edit Profile Button:**
- Label: "✏️ Edit Profile"
- Size: 140px × 36px
- Background: White (80% opacity)
- Text: #2E7D32 (Tennis Green Primary), 14px, SemiBold
- Border Radius: 18px
- Position: Below rank change, 16px spacing
- Alignment: Centered

**Accessibility:**
- Photo: "Profile photo of John Smith. Tap to change."
- Name: "John Smith"
- Rank: "Current rank 8 of 40 players"
- Change: "Ranking up 2 spots this week"
- Edit button: "Edit profile information"

---

### 3. Quick Stats Row

**Height:** 72px  
**Background:** White  
**Border:** Top/Bottom 1px solid #E0E0E0  
**Layout:** 4 equal columns

**Stat Card Structure:**
```
┌──────────┐
│    7     │ ← Value (H2, 24px, Bold)
│   WINS   │ ← Label (Caption, 10px)
└──────────┘
```

**Stats Displayed:**

**1. Wins:**
- Value: "7"
- Label: "WINS"
- Color: #4CAF50 (success green)

**2. Losses:**
- Value: "4"
- Label: "LOSSES"
- Color: #F44336 (red)

**3. Win Percentage:**
- Value: "64%"
- Label: "WIN %"
- Color: #1976D2 (Court Blue Secondary)

**4. Current Streak:**
- Value: "3" or "W3" / "L2"
- Label: "STREAK"
- Color: Green (win) / Red (loss)

**Dividers:**
- Vertical lines between stats
- 1px, #E0E0E0
- 40% height

**Interaction:**
- Tap any stat: Navigate to detailed statistics
- Haptic feedback on tap

**Accessibility:**
- Each stat: "7 wins", "4 losses", "64% win percentage", "3 game winning streak"
- Grouped: "Your statistics: 7 wins, 4 losses, 64% win rate, 3 game winning streak"

---

### 4. Tab Navigation

**Height:** 48px  
**Background:** White  
**Border Bottom:** 1px solid #E0E0E0

**Tabs:**
1. About (default)
2. Stats
3. History
4. Settings (⚙️)

**Tab Style:**

**Unselected:**
- Text: #757575 (gray)
- Typography: Body, 14px, SemiBold
- No underline

**Selected:**
- Text: #2E7D32 (Tennis Green Primary)
- Typography: Body, 14px, Bold
- Underline: 2px solid #2E7D32 (Tennis Green Primary)
- Animation: Slide from previous tab

**Layout:**
- Equal width distribution
- Centered text
- Tap target: Full tab width × 48px height

**Behavior:**
- Tap: Switch to tab, smooth transition
- Swipe left/right: Navigate between tabs
- Content below tabs updates accordingly

**Accessibility:**
- Each tab: "About tab, 1 of 4" / "Stats tab, 2 of 4, selected"
- Role: "tablist" with "tab" items
- Keyboard: Arrow keys to navigate

---

### 5. About Tab Content

**Padding:** 16px  
**Background:** White

**Information Sections:**

#### Contact Information

**Email:**
- Icon: 📧, 20px, left
- Label: "Email"
- Value: "john.smith@email.com"
- Action: Tap to email
- Typography: Body, 14px

**Phone:**
- Icon: 📱, 20px, left
- Label: "Phone"
- Value: "(555) 123-4567"
- Action: Tap to call
- Typography: Body, 14px
- Privacy: Can be hidden in settings

**Layout:**
```
┌─────────────────────────────────┐
│ 📧 Email                        │ ← Label (Caption, 12px, Gray)
│    john.smith@email.com         │ ← Value (Body, 14px, Black)
│                                 │   Spacing: 8px between
│ 📱 Phone                        │
│    (555) 123-4567               │
└─────────────────────────────────┘
```

#### Club Information

**Club:**
- Icon: 📍
- Label: "Club"
- Value: "Riverside Tennis Club"

**Division:**
- Icon: 🏷️
- Label: "Division"
- Value: "Division A"
- Badge: Colored indicator

**Member Since:**
- Icon: 📅
- Label: "Member Since"
- Value: "January 2025"

#### Bio Section

**Bio:**
- Icon: ℹ️
- Label: "Bio"
- Value: Multi-line text (max 500 characters)
- Typography: Body, 14px, Regular, #212121
- Style: Slightly indented, line height 1.5

**Playing Style:**
- Icon: 🎯
- Label: "Playing Style"
- Value: "Aggressive baseline"
- Options: Serve and volley, All-court, Defensive baseline, etc.

**NTRP Rating:**
- Icon: 📊
- Label: "NTRP Rating"
- Value: "4.0"
- Info: Link to "What is NTRP?"

#### Achievements Section

**Header:** "🏆 Achievements"  
**Layout:** Badge grid (5 columns)

**Badge Examples:**
- 🥇 First Win
- ⚡ 5-Win Streak
- 🎯 Challenge Accepted (accepted 10 challenges)
- 🔥 Hot Streak (won 5 in a row)
- 💪 Underdog Victory (beat higher rank by 3+)
- 🌟 Top 10
- 👑 #1 Rank
- 🏆 Season Champion

**Badge Display:**
- Size: 56px × 56px each
- Grid: 5 per row, wrap
- Spacing: 8px between
- Unlocked: Full color
- Locked: Grayscale, 50% opacity

**Interaction:**
- Tap badge: Show details modal
  - Badge name
  - Description
  - Date earned (if unlocked)
  - Progress (if in progress)

**Accessibility:**
- Each badge: "First Win badge. Earned on January 15, 2025."
- Locked: "Challenge Accepted badge. Not yet earned. Accept 10 challenges to unlock."

---

### 6. Stats Tab Content

**Padding:** 16px  
**Background:** #FAFAFA

**Sections:**

#### Performance Overview

**Ranking Chart:**
- Type: Line graph
- X-axis: Time (last 3 months)
- Y-axis: Rank position
- Height: 200px
- Inverted: Lower is better
- Data points: Daily/Weekly
- Interactive: Tap point for details

**Filters:**
- Time range: 1M, 3M, 6M, 1Y, All
- Chart type: Line, Bar

#### Win/Loss Breakdown

**Overall Record:**
- Wins: 7 (64%)
- Losses: 4 (36%)
- Visual: Donut chart or bar

**By Opponent Ranking:**
- vs. Higher Ranked: 4-2 (67%)
- vs. Lower Ranked: 3-2 (60%)

**Recent Form:**
- Last 5 matches: W-L-W-W-W
- Last 10 matches: 7-3

#### Match Statistics

**Average Match Duration:** 1h 23m  
**Most Common Score:** 6-4, 6-3  
**Sets Won/Lost:** 15-10  
**Games Won/Lost:** 94-78  

#### Performance Trends

**Best Day:** Saturday (5-1)  
**Most Active Month:** January (6 matches)  
**Longest Win Streak:** 3 games  
**Longest Losing Streak:** 2 games  

#### Head-to-Head Records

**Most Played Opponent:**
- Mike Thompson
- Record: 2-1
- Action: Tap to view all matches

**Best Record Against:**
- Lisa Rodriguez (3-0)

**Worst Record Against:**
- Sarah Mitchell (1-2)

**Accessibility:**
- Graph: "Ranking history chart. Your rank changed from 10 to 8 over the last month."
- Stats: Announced as "7 wins out of 11 matches, 64% win rate"

---

### 7. History Tab Content

**Padding:** 16px  
**Background:** White

**Filters:**
- Time: All, This Month, Last Month, This Year
- Result: All, Wins, Losses
- Opponent: All, Search by name

**Match History List:**

**Match Card (Expanded):**
```
┌─────────────────────────────────┐
│ ✅ Won vs. Mike Thompson        │ ← Result + Opponent
│    Rank #5 → #8                 │ ← Rank change
│                                 │
│    6-4, 7-5                     │ ← Score
│    January 15, 2025             │ ← Date
│    1h 32m                       │ ← Duration
│                                 │
│    [VIEW DETAILS] ─────────────→│ ← Action
└─────────────────────────────────┘
```

**Result Indicators:**
- Win: ✅ Green checkmark
- Loss: ❌ Red X
- Rank change: ⬆️ #8 → #6 (green) or ⬇️ #8 → #10 (red)

**Sorting:**
- Default: Most recent first
- Options: Date, Opponent, Result

**Load More:**
- Show 10 matches initially
- "Load More" button at bottom
- Or infinite scroll

**Empty State:**
```
┌─────────────────────────────────┐
│           🎾                    │
│    No matches yet               │
│                                 │
│  Your match history will appear │
│  here after you play your first │
│  match.                         │
│                                 │
│     [CHALLENGE A PLAYER]        │
└─────────────────────────────────┘
```

**Accessibility:**
- Each match: "Match 1. Won against Mike Thompson. Score 6-4, 7-5. January 15, 2025. Ranking moved from 8 to 6. Tap to view details."

---

### 8. Settings Tab Content (Alternative: Separate Screen)

**Note:** Settings could be a separate screen accessed via header button. If in-tab:

**Sections:**

#### Account Settings
- Edit Profile
- Change Password
- Email Preferences
- Push Notification Settings

#### Privacy Settings
- Profile Visibility
- Show Phone Number
- Show Match History
- Show Statistics

#### Preferences
- Preferred Match Times
- Availability Status
- Language
- Timezone

#### App Settings
- Dark Mode
- Haptic Feedback
- Sound Effects

#### Support
- Help & FAQ
- Contact Support
- Report a Bug
- Terms of Service
- Privacy Policy

#### Account Actions
- Logout
- Delete Account

**Style:**
- List items: 56px height
- Icon on left (24px)
- Label on right
- Chevron → for navigation
- Toggle switches where applicable

---

## Interaction Behaviors

### Tab Switching
- **Tap:** Instant switch with smooth content transition
- **Swipe:** Gesture navigation between tabs
- **Animation:** 300ms ease-in-out

### Pull-to-Refresh
- Available on all tabs
- Updates profile data
- Refreshes statistics
- Reloads match history

### Photo Upload
- Tap profile photo
- Options:
  - Take Photo (camera)
  - Choose from Library
  - Remove Photo
- Crop/resize interface
- Upload with progress indicator

### Edit Profile Flow
```
1. Tap "Edit Profile" button
2. Navigate to edit screen
3. Inline editing for all fields
4. Save button (always visible)
5. Validation on save
6. Return to profile with updated data
```

### Share Profile
- Generate shareable link
- QR code for in-person sharing
- Share via:
  - Message
  - Email
  - Social media

---

## Responsive Behavior

### Small Mobile (320px - 374px)
- Profile photo: 100px
- Stats: Stack 2×2 instead of 1×4
- Font sizes: Reduce by 1-2px
- Padding: 12px

### Standard Mobile (375px - 413px)
- As specified (optimal)

### Large Mobile (414px+)
- Profile photo: 140px
- Stats: 1×4 with more spacing
- Larger padding: 20px

### Tablet (768px+)
- Two-column layout
- Profile header: Left column (fixed)
- Content: Right column (scrollable)
- Tabs: Vertical navigation

### Landscape
- Horizontal layout
- Profile header: Smaller, left side
- Content: Right side, full height

---

## Accessibility Features

### Screen Reader Support

**Page Announcement:**
"Profile screen. John Smith, rank 8 of 40 players."

**Section Announcements:**
- "About section. Contact information and bio."
- "Statistics section. Performance charts and win rate."
- "Match history. 11 total matches."

**Interactive Element Announcements:**
- "Edit profile button"
- "Wins: 7. Tap for detailed statistics."
- "Achievement: First Win badge. Earned on January 15."

### Keyboard Navigation
- Tab through all sections
- Enter/Space to activate
- Arrow keys for tab navigation
- Escape to close modals

### Visual Accessibility
- High contrast mode support
- Text remains readable at 200% zoom
- Color is not the only indicator
- Focus indicators always visible

### Dynamic Type Support
- Respects system font size settings
- Layout adjusts for larger text
- Critical info remains visible

---

## Loading States

### Initial Load
- Skeleton screen for profile header
- Placeholder for stats
- Loading spinner for graph/history
- Progressive enhancement

### Tab Switch
- Instant for cached data
- Spinner for new data load
- Smooth transition

### Photo Upload
- Progress bar during upload
- Preview while processing
- Success confirmation

---

## Error States

### Profile Load Error
```
┌─────────────────────────────────┐
│           ⚠️                    │
│    Unable to load profile       │
│                                 │
│  Please check your connection   │
│  and try again.                 │
│                                 │
│     [RETRY]    [GO BACK]        │
└─────────────────────────────────┘
```

### Photo Upload Error
```
Toast: "Failed to upload photo. Please try again."
```

### Stats Load Error
```
Gray placeholder: "Unable to load statistics. Tap to retry."
```

---

## Performance Targets

| Metric | Target | Notes |
|--------|--------|-------|
| Initial Load | < 1 second | Profile header + basic info |
| Tab Switch | < 300ms | Cached data |
| Graph Render | < 500ms | Statistics chart |
| Photo Upload | < 5 seconds | 5MB max file |
| Scroll FPS | 60 fps | Smooth scrolling |

---

## Development Notes

### Technical Implementation
- Cache profile data locally
- Lazy load tabs (load on switch)
- Optimize images (WebP, compress)
- Use chart library (e.g., Chart.js, D3)
- Implement virtual scrolling for long history

### API Endpoints
- `GET /profile/:userId` - Get profile data
- `PUT /profile/:userId` - Update profile
- `POST /profile/photo` - Upload photo
- `GET /profile/stats` - Get statistics
- `GET /profile/history` - Get match history
- `GET /profile/achievements` - Get badges

### Analytics Events
- `profile_view`
- `profile_edit`
- `photo_upload`
- `tab_switch`
- `achievement_view`
- `match_history_view`
- `stats_view`

---

## Testing Checklist

### Functional Testing
- [ ] Profile data loads correctly
- [ ] Tabs switch properly
- [ ] Edit profile works
- [ ] Photo upload works
- [ ] Stats display accurately
- [ ] Match history loads
- [ ] Achievements display

### UI Testing
- [ ] Layout responsive
- [ ] Touch targets adequate (44×44px)
- [ ] Animations smooth (60fps)
- [ ] Images load and display
- [ ] Charts render correctly
- [ ] Loading states show
- [ ] Error states handle gracefully

### Accessibility Testing
- [ ] Screen reader navigation works
- [ ] Keyboard navigation works
- [ ] Focus indicators visible
- [ ] Color contrast meets WCAG AA
- [ ] Dynamic type supported
- [ ] All images have alt text

### Performance Testing
- [ ] Load time < 1 second
- [ ] Tab switches instant
- [ ] Smooth scrolling
- [ ] No memory leaks
- [ ] Works on slow networks

---

**Wireframe Version:** 1.3  
**Status:** ✅ Approved  
**Ready for:** High-Fidelity Design  
**Last Review:** December 20, 2025
