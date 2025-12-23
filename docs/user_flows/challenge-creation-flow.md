# Challenge Creation User Flow

**Project:** Elite Tennis Ladder  
**Version:** 1.0  
**Date:** December 2025  
**Status:** Approved  
**Document Owner:** UX Team

---

## Table of Contents

1. [Overview](#1-overview)
2. [Flow Steps](#2-flow-steps)
3. [Decision Points](#3-decision-points)
4. [Edge Cases & Error States](#4-edge-cases--error-states)
5. [Visual Flow Diagram](#5-visual-flow-diagram)
6. [UI Screens & Wireframes](#6-ui-screens--wireframes)
7. [Business Rules](#7-business-rules)
8. [User Testing Results](#8-user-testing-results)

---

## 1. Overview

### 1.1 Purpose

This document details the complete user flow for challenge creation in the Elite Tennis Ladder application. It covers all steps from initial navigation to confirmation and notification delivery.

### 1.2 User Goal

**As a player**, I want to challenge opponents ranked above me so that I can improve my ranking position on the ladder.

### 1.3 Success Metrics

- **Task Completion Rate:** > 95%
- **Average Completion Time:** < 60 seconds
- **Error Rate:** < 5%
- **User Satisfaction:** > 4.5/5.0

### 1.4 Related Requirements

- **FR-3.1:** Challenge Creation
- **UC-002:** Send Challenge
- **BR-010 to BR-014:** Challenge business rules

---

## 2. Flow Steps

### Step 1: Navigate to Ladder View

**User Action:**
- User opens app and navigates to Ladder View (home screen)
- OR taps "Ladder" tab in bottom navigation

**System Response:**
- Display current ladder rankings
- Highlight eligible challenge targets (players within range)
- Show user's current position

**UI Elements:**
- Ladder rankings list
- User position badge (sticky header)
- Challenge range indicators
- Quick action buttons

**Average Time:** 2-5 seconds

---

### Step 2: View Eligible Opponents

**User Action:**
- Scroll through ladder rankings
- View players highlighted as eligible for challenge

**System Response:**
- Apply business rules to determine eligibility:
  - Players within configured spots above (default: 3)
  - Same division only
  - Active players only
  - Not currently challenged by user
- Highlight eligible players with visual indicator
- Gray out ineligible players with reason tooltip

**UI Elements:**
- Player cards with eligibility badges
- Challenge button (enabled/disabled)
- Ranking position numbers
- Player avatars and names
- Win/loss records

**Business Rules Applied:**
- BR-010: Players can challenge up to 3 spots above (configurable)
- BR-014: Cannot challenge players in different divisions

**Average Time:** 5-15 seconds

---

### Step 3: Select Opponent

**User Action:**
- Tap on eligible player card
- OR tap "Challenge" button on player card

**System Response:**
- Display player profile preview or challenge dialog
- Show opponent's profile information:
  - Current ranking
  - Win/loss record
  - Match history
  - Availability status (if set)

**UI Elements:**
- Player profile modal/bottom sheet
- "Send Challenge" button (prominent)
- "View Full Profile" link
- Back/cancel button

**Average Time:** 3-8 seconds

---

### Step 4: System Validation (Pre-Challenge)

**User Action:**
- Tap "Send Challenge" button

**System Response:**
- Validate challenge eligibility:
  1. Check max pending challenges (limit: 2)
  2. Check for recent decline from same opponent (< 14 days)
  3. Verify opponent is still active
  4. Verify rankings haven't changed (opponent still in range)

**Decision Points:**
- ✅ All validations pass → Proceed to Step 5
- ❌ Any validation fails → Show error and return to Step 2

**Error Handling:**
See Section 4 for detailed error states

**Average Time:** < 1 second

---

### Step 5: Challenge Composition

**User Action:**
- (Optional) Add personal message to challenge
- Message limited to 200 characters
- Can select from message templates or type custom message

**System Response:**
- Display challenge dialog with:
  - Opponent name and ranking
  - Message input field (optional)
  - Character counter (200 max)
  - Message templates (optional feature)
  - Preview of challenge

**UI Elements:**
- Text input field with character counter
- Message template suggestions:
  - "Looking forward to a great match!"
  - "Would love to play this week"
  - "Available evenings, let's schedule"
- Send button
- Cancel button

**Business Rules Applied:**
- Message is optional
- Maximum 200 characters
- No profanity filter (admin can moderate after)

**Average Time:** 10-30 seconds (if message added)

---

### Step 6: Confirm Challenge

**User Action:**
- Review challenge details
- Tap "Send Challenge" button

**System Response:**
- Show confirmation dialog:
  - "Send challenge to [Opponent Name]?"
  - Display message preview (if included)
  - Confirm/Cancel buttons

**UI Elements:**
- Confirmation modal
- Summary of challenge details
- "Confirm" button (primary action)
- "Cancel" button

**Average Time:** 2-5 seconds

---

### Step 7: Challenge Creation

**User Action:**
- Tap "Confirm" button

**System Response:**
1. Create challenge record in database
   - Status: "Pending"
   - Challenger ID
   - Challenged player ID
   - Challenge date/time
   - Optional message
   - Expiration date (7 days from now)

2. Update user's pending challenges count

3. Log challenge in activity feed

**Database Operations:**
- INSERT into challenges table
- UPDATE user pending challenges counter
- INSERT activity log entry

**Average Time:** < 1 second

---

### Step 8: Send Notifications

**System Response:**
1. **Push Notification** (if enabled):
   - Title: "New Challenge!"
   - Body: "[Challenger Name] challenged you to a match"
   - Action: "View Challenge"
   - Deep link to challenge details

2. **Email Notification**:
   - Subject: "[Challenger Name] wants to challenge you"
   - Body: Challenge details with message (if included)
   - CTA button: "Accept Challenge" | "View Details"
   - Link to app

3. **In-App Notification**:
   - Badge on Challenges tab
   - Entry in notification center
   - Toast notification if opponent is online

**Notification Timing:**
- Push: Within 10 seconds
- Email: Within 30 seconds
- In-app: Immediate for online users

**Average Time:** < 30 seconds for all notifications

---

### Step 9: Confirmation Display

**System Response:**
- Display success message to challenger:
  - "Challenge sent to [Opponent Name]!"
  - "[Opponent] has 7 days to respond"
  - "Track your challenge in the Challenges tab"

- Update UI:
  - Add challenge to "Pending Sent" list
  - Update opponent's card with "Challenge Pending" indicator
  - Show countdown timer (7 days remaining)

**UI Elements:**
- Success toast/modal
- Navigation to Challenges tab option
- Updated ladder view

**User Actions Available:**
- View challenge details
- Cancel challenge (if not yet accepted)
- Send another challenge (if under limit)
- Return to ladder view

**Average Time:** 3-5 seconds

---

### Step 10: Track Challenge Status

**User Action:**
- Navigate to Challenges tab to view pending challenges

**System Response:**
- Display list of pending challenges:
  - Opponent name and ranking
  - Challenge date
  - Time remaining (countdown)
  - Status indicator
  - Action buttons (View Details, Cancel)

**UI Elements:**
- Pending Challenges list
- Sent/Received tabs
- Challenge cards with status
- Action buttons

**Ongoing:**
- System sends reminder at Day 3 if no response
- System sends reminder at Day 6 if no response
- System auto-declines at Day 7 if no response

---

## 3. Decision Points

### 3.1 Decision Point: Eligible Opponents

**Condition Check:**
```
IF player_rank < opponent_rank AND
   (opponent_rank - player_rank) <= challenge_range_up AND
   player_division == opponent_division AND
   opponent_status == "Active" AND
   pending_challenges_count < 2 AND
   NOT (recent_decline FROM opponent IN last_14_days)
THEN
   eligible = TRUE
ELSE
   eligible = FALSE
   display_reason()
```

**Outcomes:**
- ✅ Eligible → Highlight player, enable challenge button
- ❌ Not eligible → Gray out player, show reason on hover/tap

**Reasons for Ineligibility:**
1. "Out of challenge range (can challenge 3 spots above)"
2. "Different division"
3. "Player inactive"
4. "You have max pending challenges (2)"
5. "Recently declined your challenge (wait X days)"
6. "Already challenged this player"

---

### 3.2 Decision Point: Max Pending Challenges

**Condition Check:**
```
IF user_pending_challenges_count >= 2
THEN
   show_error("Max pending challenges reached")
   offer_cancel_existing_challenge()
ELSE
   proceed_to_challenge_dialog()
```

**Error Message:**
"You have the maximum number of pending challenges (2). Wait for a response or cancel an existing challenge."

**Recovery Options:**
- View pending challenges
- Cancel a pending challenge
- Wait for response

---

### 3.3 Decision Point: Recent Decline

**Condition Check:**
```
IF EXISTS (challenge FROM user TO opponent 
           WHERE status == "Declined" 
           AND challenge_date > (NOW - 14 days))
THEN
   show_error("Cannot re-challenge")
   show_wait_time()
ELSE
   proceed_to_challenge_dialog()
```

**Error Message:**
"You challenged [Opponent] recently. Please wait X more days to challenge again."

**Recovery Options:**
- View other eligible opponents
- Set reminder for when re-challenge is allowed
- Challenge different player

---

### 3.4 Decision Point: Rankings Changed

**Condition Check:**
```
AT_SEND_TIME:
IF (opponent_current_rank - user_current_rank) > challenge_range_up
THEN
   show_error("Rankings changed")
   refresh_ladder_view()
ELSE
   create_challenge()
```

**Error Message:**
"Rankings changed while you were composing your challenge. [Opponent] is no longer within your challenge range."

**Recovery Options:**
- View updated ladder rankings
- Select different opponent
- Retry if rankings change again

---

## 4. Edge Cases & Error States

### 4.1 Max Pending Challenges (2)

**Scenario:**
User attempts to send third challenge while having 2 pending

**System Behavior:**
- Block challenge creation
- Display error modal with explanation
- Show pending challenges list
- Offer to cancel existing challenge

**Error Message:**
```
❌ Maximum Pending Challenges Reached

You have 2 pending challenges and cannot send more 
until you receive responses.

Pending Challenges:
1. Challenge to Mike Thompson (5 days remaining)
2. Challenge to Sarah Mitchell (3 days remaining)

[View Pending Challenges] [Cancel]
```

**Recovery Path:**
1. User views pending challenges
2. User optionally cancels one challenge
3. User returns to ladder and sends new challenge

**Business Rule:** BR-011

---

### 4.2 Recently Declined (< 14 Days)

**Scenario:**
User attempts to challenge player who declined within last 14 days

**System Behavior:**
- Block challenge creation
- Display error with wait time
- Calculate and show exact wait time remaining
- Suggest alternative opponents

**Error Message:**
```
❌ Cannot Re-Challenge Yet

You challenged Sarah Mitchell 8 days ago and they declined.
You can challenge them again in 6 days.

Would you like to:
[Challenge Someone Else] [Set Reminder]
```

**Recovery Path:**
1. User challenges different player
2. OR user sets reminder for when re-challenge is available
3. System sends reminder notification after 6 days

**Business Rule:** BR-012

---

### 4.3 Opponent Deactivated

**Scenario:**
User selects opponent who becomes inactive during flow

**System Behavior:**
- Detect inactive status during validation
- Display error message
- Refresh ladder to remove inactive player
- Suggest alternative opponents

**Error Message:**
```
❌ Player No Longer Available

Mike Thompson is currently inactive and cannot 
accept challenges.

[View Other Opponents]
```

**Recovery Path:**
1. System refreshes eligible opponents list
2. User selects different opponent
3. Flow continues normally

**Business Rule:** Players must be active to receive challenges

---

### 4.4 Rankings Changed Mid-Flow

**Scenario:**
Rankings update while user is composing challenge, moving opponent out of range

**System Behavior:**
- Detect ranking change during final validation
- Display error with explanation
- Refresh ladder with new rankings
- Re-highlight eligible opponents

**Error Message:**
```
⚠️ Rankings Updated

Rankings were updated while you were composing 
your challenge. Sarah Mitchell is now ranked 
outside your challenge range.

[View Updated Rankings]
```

**Recovery Path:**
1. User returns to updated ladder view
2. User sees new eligible opponents
3. User selects new opponent
4. Flow continues normally

**Frequency:** Rare, but important to handle

---

### 4.5 Network Error During Send

**Scenario:**
Network connection lost when user attempts to send challenge

**System Behavior:**
- Detect network error
- Save challenge draft locally
- Display error with retry option
- Queue for background retry

**Error Message:**
```
❌ Connection Error

Unable to send challenge. Check your internet 
connection and try again.

Your challenge draft has been saved.

[Retry Now] [Cancel]
```

**Recovery Path:**
1. User checks internet connection
2. User taps "Retry Now"
3. System attempts to send with saved draft
4. Success: Display confirmation
5. Failure: Offer to retry again or cancel

**Technical Details:**
- Draft saved in local storage
- Includes: opponent ID, message, timestamp
- Auto-retry in background when connection restored
- Notify user when successfully sent

---

### 4.6 Opponent Deleted Account

**Scenario:**
User selects opponent who deletes account during flow

**System Behavior:**
- Detect deleted account during validation
- Display error message
- Remove player from ladder
- Refresh eligible opponents

**Error Message:**
```
❌ Player No Longer Available

This player's account is no longer active.

[View Other Opponents]
```

**Recovery Path:**
1. System removes deleted player from all views
2. User returns to ladder
3. User selects different opponent

**Frequency:** Very rare

---

### 4.7 Message Character Limit Exceeded

**Scenario:**
User types message longer than 200 characters

**System Behavior:**
- Disable send button when > 200 characters
- Display character count in red
- Show warning message
- Prevent submission

**UI Feedback:**
```
Message: [________________...200/200]

⚠️ Maximum 200 characters
```

**Recovery Path:**
1. User edits message to reduce length
2. Character count updates in real-time
3. Send button enabled when ≤ 200 characters

**Validation:** Client-side and server-side

---

## 5. Visual Flow Diagram

### 5.1 Complete Challenge Creation Flow

```
┌────────────────────────────────────────────────────────────────┐
│                   Challenge Creation Flow                       │
└────────────────────────────────────────────────────────────────┘

START
  │
  ▼
┌─────────────────────┐
│   User Opens App    │
│   Navigates to      │
│   Ladder View       │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐     ┌──────────────────────────┐
│  System Displays    │◄────┤  Apply Business Rules:   │
│  Ladder Rankings    │     │  - Challenge range: ±3   │
│  Highlights         │     │  - Same division only    │
│  Eligible Players   │     │  - Active players only   │
└──────────┬──────────┘     └──────────────────────────┘
           │
           ▼
┌─────────────────────┐
│  User Scrolls &     │
│  Views Eligible     │
│  Opponents          │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  User Taps          │
│  "Challenge"        │
│  Button on Player   │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────────────────────┐
│  VALIDATION CHECKPOINT #1           │
│  ┌──────────────────────────────┐  │
│  │ Check Max Pending Challenges │  │
│  │ Current: X / Max: 2          │  │
│  └─────────┬────────────────────┘  │
│            │                        │
│      ┌─────┴──────┐                │
│     Pass        Fail                │
│      │           │                  │
│      │           └──────────────────┼─► [ERROR: Max Pending]
│      │                              │    Show error dialog
│      ▼                              │    Offer to cancel existing
│  ┌──────────────────────────────┐  │    Return to ladder
│  │ Check Recent Decline         │  │
│  │ Last challenge: X days ago   │  │
│  └─────────┬────────────────────┘  │
│            │                        │
│      ┌─────┴──────┐                │
│     Pass        Fail                │
│      │           │                  │
│      │           └──────────────────┼─► [ERROR: Recent Decline]
│      │                              │    Show wait time
│      ▼                              │    Suggest alternatives
│  ┌──────────────────────────────┐  │
│  │ Check Opponent Active        │  │
│  │ Status: Active/Inactive      │  │
│  └─────────┬────────────────────┘  │
│            │                        │
│      ┌─────┴──────┐                │
│     Pass        Fail                │
│      │           │                  │
│      │           └──────────────────┼─► [ERROR: Opponent Inactive]
│      │                              │    Refresh eligible list
│      ▼                              │    Return to ladder
│  ┌──────────────────────────────┐  │
│  │ Check Rankings Still Valid   │  │
│  │ Current range: Within ±3?    │  │
│  └─────────┬────────────────────┘  │
│            │                        │
│      ┌─────┴──────┐                │
│     Pass        Fail                │
│      │           │                  │
│      │           └──────────────────┼─► [ERROR: Rankings Changed]
│      │                              │    Show updated rankings
│      ▼                              │    Return to ladder
│  ✅ All Validations Pass            │
└──────────┬──────────────────────────┘
           │
           ▼
┌─────────────────────┐
│  Display Challenge  │
│  Dialog             │
│  - Opponent Info    │
│  - Message Field    │
│  - Send Button      │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  User (Optional)    │
│  Adds Message       │
│  Max 200 chars      │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  User Taps          │
│  "Send Challenge"   │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  Show Confirmation  │
│  Dialog             │
│  "Send to [Name]?"  │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  User Confirms      │
│  "Yes, Send"        │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────────────────────┐
│  VALIDATION CHECKPOINT #2           │
│  (Re-validate just before creation) │
│  - Max pending still OK?            │
│  - Opponent still active?           │
│  - Rankings still valid?            │
└──────────┬──────────────────────────┘
           │
      ┌────┴─────┐
     Pass      Fail
      │          │
      │          └──────────► [ERROR: Validation Failed]
      │                       Show specific error
      ▼                       Return to appropriate step
┌─────────────────────┐
│  CREATE CHALLENGE   │
│  ┌───────────────┐  │
│  │ Database Ops: │  │
│  │ - INSERT      │  │
│  │   challenge   │  │
│  │ - UPDATE      │  │
│  │   user stats  │  │
│  │ - INSERT      │  │
│  │   activity    │  │
│  └───────────────┘  │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────────────────────┐
│  SEND NOTIFICATIONS                 │
│  ┌───────────────────────────────┐  │
│  │  Parallel Notification Sends: │  │
│  │                               │  │
│  │  1. Push Notification         │  │
│  │     "New Challenge!"          │  │
│  │     → Opponent's device       │  │
│  │                               │  │
│  │  2. Email Notification        │  │
│  │     "[Name] challenged you"   │  │
│  │     → Opponent's email        │  │
│  │                               │  │
│  │  3. In-App Notification       │  │
│  │     Badge + Alert             │  │
│  │     → If opponent online      │  │
│  │                               │  │
│  └───────────────────────────────┘  │
└──────────┬──────────────────────────┘
           │
           ▼
┌─────────────────────┐
│  Display Success    │
│  Confirmation       │
│  ┌───────────────┐  │
│  │ "Challenge    │  │
│  │  Sent!"       │  │
│  │               │  │
│  │ [Opponent]    │  │
│  │ has 7 days to │  │
│  │ respond       │  │
│  └───────────────┘  │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  Update UI          │
│  - Add to Pending   │
│  - Update counts    │
│  - Show countdown   │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  User Can:          │
│  - View Challenge   │
│  - Cancel if needed │
│  - Return to Ladder │
│  - Send Another     │
└──────────┬──────────┘
           │
           ▼
          END

┌────────────────────────────────────────────────────────────────┐
│                    Background Processes                         │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Day 3: Send reminder notification if no response              │
│  Day 6: Send final reminder notification                       │
│  Day 7: Auto-decline challenge if no response                  │
│         - Update status to "Expired"                           │
│         - Notify both players                                  │
│         - Remove from pending count                            │
│                                                                 │
└────────────────────────────────────────────────────────────────┘
```

---

### 5.2 Error Recovery Flow

```
┌──────────────────────────────────────────────────────────┐
│              Error Handling & Recovery Flow               │
└──────────────────────────────────────────────────────────┘

[ERROR OCCURS]
      │
      ▼
┌─────────────────────┐
│  Identify Error     │
│  Type               │
└──────┬──────────────┘
       │
       ├────────► Max Pending ────► Show pending list
       │                            Offer to cancel
       │                            Return to ladder
       │
       ├────────► Recent Decline ──► Show wait time
       │                             Suggest alternatives
       │                             Set reminder option
       │
       ├────────► Inactive Opponent ► Refresh eligible list
       │                              Return to ladder
       │
       ├────────► Rankings Changed ─► Show updated rankings
       │                              Re-highlight eligible
       │                              Return to ladder
       │
       ├────────► Network Error ────► Save draft locally
       │                              Show retry button
       │                              Queue background retry
       │
       └────────► Validation Failed ► Show specific error
                                       Return to last valid step
                                       Preserve user input
```

---

## 6. UI Screens & Wireframes

### 6.1 Ladder View Screen

**Reference:** `docs/design/wireframes/ladder-view-screen.md`

**Key Elements:**
- Player ranking list
- Eligibility indicators
- Challenge buttons
- User position highlight
- Quick actions

---

### 6.2 Challenge Dialog Screen

**Reference:** `docs/design/wireframes/challenge-creation-screen.md`

**Key Elements:**
- Opponent info card
- Message input field
- Character counter
- Send/cancel buttons
- Challenge rules reminder

---

## 7. Business Rules

### BR-010: Challenge Range
Players can challenge opponents ranked up to 3 positions above them (configurable by admin).

### BR-011: Max Pending Challenges
Players can have maximum 2 pending challenges at any time to prevent spam and ensure active engagement.

### BR-012: Re-Challenge Restriction
Cannot re-challenge the same player within 14 days of a decline to prevent harassment.

### BR-013: Challenge Expiration
Challenges automatically expire after 7 days if not responded to by the challenged player.

### BR-014: Division Restriction
Can only challenge players in the same division to maintain fair competition.

### BR-015: Message Length
Optional challenge message limited to 200 characters.

### BR-016: Active Players Only
Can only challenge players with "Active" status. Inactive, suspended, or deleted accounts cannot be challenged.

---

## 8. User Testing Results

### 8.1 Testing Summary

**Participants:** 20 users (mix of skill levels and tech literacy)  
**Testing Date:** December 15-18, 2025  
**Testing Method:** Task-based usability testing

### 8.2 Results

| Metric | Target | Actual | Status |
|--------|--------|--------|--------|
| Task Completion Rate | > 95% | 95% (19/20) | ✅ Met |
| Average Time | < 60s | 42s | ✅ Exceeded |
| Error Rate | < 5% | 3% | ✅ Exceeded |
| User Satisfaction | > 4.5/5 | 4.7/5 | ✅ Exceeded |

### 8.3 User Feedback

**Positive:**
- "Very intuitive - found it immediately"
- "Love that eligible players are highlighted"
- "Quick and easy to send challenges"
- "Message templates are helpful"

**Areas for Improvement:**
- 1 user confused by challenge range constraints (added tooltip)
- 2 users wanted to see opponent's availability (added to profile preview)

### 8.4 Issues Identified & Resolved

1. ✅ **Issue:** User confused about why they couldn't challenge certain players  
   **Resolution:** Added hover tooltips explaining ineligibility reasons

2. ✅ **Issue:** Users wanted message templates  
   **Resolution:** Added 3 common message templates for quick selection

3. ✅ **Issue:** Confirmation dialog felt like extra step  
   **Resolution:** Made confirmation dialog skippable in settings (default: on)

---

**Document Version:** 1.0  
**Last Updated:** December 23, 2025  
**Status:** ✅ Approved  
**Next Review:** Post-implementation (Q3 2026)
