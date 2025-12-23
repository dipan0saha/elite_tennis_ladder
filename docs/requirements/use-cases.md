# Use Cases Document

**Project:** Elite Tennis Ladder  
**Version:** 1.0  
**Date:** December 2025  
**Status:** Draft  
**Document Owner:** Product Team

---

## Table of Contents

1. [Introduction](#1-introduction)
2. [Core Use Cases](#2-core-use-cases)
3. [Administrative Use Cases](#3-administrative-use-cases)
4. [Advanced Use Cases](#4-advanced-use-cases)

---

## 1. Introduction

### 1.1 Purpose

This document describes key use cases for the Elite Tennis Ladder platform. Each use case details actors, preconditions, main flow, alternate flows, and postconditions to ensure comprehensive coverage of system functionality.

### 1.2 Use Case Template

Each use case follows this structure:
- **Use Case ID:** Unique identifier
- **Name:** Brief descriptive name
- **Actor(s):** Who performs the use case
- **Priority:** Must Have / Should Have / Could Have
- **Preconditions:** System state before execution
- **Main Success Scenario:** Primary happy path
- **Alternative Flows:** Variations and edge cases
- **Exception Flows:** Error conditions
- **Postconditions:** System state after execution
- **Business Rules:** Constraints and policies

---

## 2. Core Use Cases

### UC-001: Player Registration

**Actor:** New Player  
**Priority:** Must Have  
**Related Requirements:** FR-2.1

#### Preconditions
- User has email address
- User is not already registered
- Registration is open (or admin approval enabled)

#### Main Success Scenario
1. User navigates to registration page
2. System displays registration form
3. User enters email, password, name, and phone (optional)
4. User accepts terms of service
5. User submits registration form
6. System validates input (email format, password strength)
7. System creates user account with "Unverified" status
8. System sends verification email with link
9. System displays confirmation message: "Check your email to verify"
10. User clicks verification link in email
11. System verifies email and updates account status to "Active"
12. System redirects user to login page
13. System sends welcome email

#### Alternative Flows

**A1: User already has account**
- At step 6, system detects existing email
- System displays: "This email is already registered. Try logging in?"
- System provides link to login page
- Use case ends

**A2: Admin approval required**
- At step 8, system creates account with "Pending Approval" status
- System notifies admin of new registration
- Admin reviews and approves registration (see UC-021)
- System sends approval notification to user
- Continue with step 11

**A3: Email verification link expired**
- At step 10, system detects expired link (>24 hours)
- System displays: "Link expired. Request new verification email?"
- User requests new email
- System sends new verification email
- Continue with step 10

#### Exception Flows

**E1: Invalid email format**
- At step 6, system detects invalid email
- System displays inline error: "Please enter valid email address"
- User corrects email
- Continue with step 5

**E2: Weak password**
- At step 6, system detects password doesn't meet requirements
- System displays: "Password must be at least 8 characters with uppercase, number, and special character"
- User creates stronger password
- Continue with step 5

**E3: Email delivery failure**
- At step 8, email service returns error
- System logs error and retries (3 attempts)
- If all attempts fail, system displays: "Email delivery failed. Please try again or contact support"
- Use case ends

#### Postconditions
- **Success:** New user account created and verified
- **Failure:** No account created, user can retry

#### Business Rules
- BR-001: Email must be unique across all users
- BR-002: Password must be minimum 8 characters with 1 uppercase, 1 number, 1 special character
- BR-003: Verification email expires after 24 hours
- BR-004: User must verify email before accessing most features

---

### UC-002: Send Challenge

**Actor:** Player (Challenger)  
**Priority:** Must Have  
**Related Requirements:** FR-3.1

#### Preconditions
- User is logged in
- User is ranked player (not unranked)
- User has fewer than 2 pending challenges
- Target player is within challenge range (default: 3 spots up)

#### Main Success Scenario
1. User navigates to ladder standings
2. System displays current rankings with eligible challenge targets highlighted
3. User selects opponent to challenge
4. System displays opponent profile with challenge button
5. User clicks "Send Challenge" button
6. System displays challenge dialog with optional message field
7. User optionally enters message (max 200 characters)
8. User clicks "Confirm Challenge"
9. System validates challenge eligibility
10. System creates challenge with status "Pending"
11. System sends push notification to challenged player
12. System sends email notification to challenged player
13. System displays confirmation: "Challenge sent to [Player Name]"
14. System updates user's pending challenges count
15. System records challenge in activity feed

#### Alternative Flows

**A1: Add message to challenge**
- At step 7, user enters friendly message
- System validates message length (<= 200 characters)
- System includes message in notifications
- Continue with step 8

**A2: Challenge recently declined by same player**
- At step 9, system detects challenge to same player within 14 days
- System displays: "You challenged [Player] recently. Please wait X more days to challenge again."
- Use case ends

**A3: Maximum pending challenges reached**
- At step 9, system detects user has 2 pending challenges
- System displays: "You have maximum pending challenges (2). Wait for response or cancel existing challenge."
- System provides option to view/cancel pending challenges
- Use case ends

#### Exception Flows

**E1: Target player deactivated**
- At step 9, system detects target player is inactive
- System displays: "[Player Name] is currently inactive. Please choose another opponent."
- System returns to step 2
- Use case continues

**E2: Notification delivery failure**
- At step 11 or 12, notification service fails
- System logs error and queues for retry
- System still displays confirmation to user (notification will be retried)
- Use case continues

**E3: Challenge constraint changed**
- At step 9, system detects target now outside range (rankings changed)
- System displays: "Rankings changed. [Player Name] is no longer within challenge range."
- System returns to step 2
- Use case continues

#### Postconditions
- **Success:** Challenge created with "Pending" status, notifications sent
- **Failure:** No challenge created, user can retry with different opponent

#### Business Rules
- BR-010: Players can challenge up to configured spots above (default: 3)
- BR-011: Players can have maximum 2 pending challenges at once
- BR-012: Cannot re-challenge same player within 14 days of decline
- BR-013: Challenge automatically expires after 7 days if no response
- BR-014: Cannot challenge players in different divisions

---

### UC-003: Respond to Challenge

**Actor:** Player (Challenged Player)  
**Priority:** Must Have  
**Related Requirements:** FR-3.2

#### Preconditions
- User is logged in
- User has received challenge (status: "Pending")
- Challenge has not expired (< 7 days)

#### Main Success Scenario - Accept Challenge
1. User receives push notification: "[Player Name] challenged you!"
2. User opens app (or clicks notification)
3. System displays challenge details (challenger, date, optional message)
4. User reviews challenge
5. User clicks "Accept Challenge"
6. System displays confirmation dialog
7. User confirms acceptance
8. System updates challenge status to "Accepted"
9. System sends notification to challenger
10. System displays success message: "Challenge accepted! Coordinate match time with [Player]."
11. System provides option to message opponent
12. System records acceptance in activity feed

#### Alternative Flows - Decline Challenge

**A1: Decline with reason**
1. At step 5, user clicks "Decline Challenge"
2. System displays decline dialog with optional reason field
3. User optionally enters reason (max 200 characters)
4. User clicks "Confirm Decline"
5. System updates challenge status to "Declined"
6. System sends notification to challenger with reason (if provided)
7. System displays: "Challenge declined. [Player] can challenge someone else."
8. Use case ends

**A2: Decline without reason**
1. At step 3 (in A1), user skips reason
2. System confirms decline without reason
3. Continue with step 5 (in A1)

**A3: Auto-decline (7 days passed)**
1. System daily cron job checks challenge ages
2. System identifies challenge older than 7 days with no response
3. System automatically updates challenge status to "Expired"
4. System sends notification to both players
5. System displays on next login: "Challenge from [Player] expired."
6. Use case ends

#### Exception Flows

**E1: Challenge already responded to**
- At step 5, system detects challenge no longer "Pending"
- System displays: "This challenge was already responded to."
- System refreshes challenge list
- Use case ends

**E2: Challenger cancelled challenge**
- At step 5, system detects challenge was cancelled by challenger
- System displays: "[Player] cancelled this challenge."
- System removes challenge from list
- Use case ends

#### Postconditions
- **Success (Accept):** Challenge status "Accepted", both players notified, ready to coordinate match
- **Success (Decline):** Challenge status "Declined", challenger notified
- **Failure:** Challenge remains "Pending", user can retry response

#### Business Rules
- BR-020: Challenge must be accepted or declined within 7 days
- BR-021: Auto-decline occurs exactly 7 days after challenge creation
- BR-022: Reminders sent at day 3 and day 6 of pending challenge
- BR-023: Declined challenges prevent re-challenge for 14 days

---

### UC-004: Report Match Score

**Actor:** Match Winner  
**Priority:** Must Have  
**Related Requirements:** FR-5.1

#### Preconditions
- User is logged in
- User participated in accepted challenge
- Match has been completed
- Score has not yet been reported

#### Main Success Scenario
1. User navigates to "My Matches" or "Report Score"
2. System displays list of accepted challenges ready for score report
3. User selects match to report
4. System displays score entry form
5. User selects match format (Best of 3, Pro Set, Match Tiebreak)
6. User enters score for Set 1 (games won by each player)
7. User enters score for Set 2
8. If needed, user enters score for Set 3 or match tiebreak
9. System validates score format (legal tennis scores)
10. User reviews entered score
11. User clicks "Submit Score"
12. System creates score report with status "Pending Verification"
13. System sends verification request to opponent (loser)
14. System displays confirmation: "Score submitted. Waiting for [Opponent] to verify."
15. System records score report in match history

#### Alternative Flows

**A1: Match with tiebreak**
- At step 6, user enters set score with tiebreak (e.g., 7-6)
- System prompts for tiebreak score
- User enters tiebreak points (e.g., 7-5)
- System validates tiebreak score
- Continue with step 7

**A2: Pro set format**
- At step 5, user selects "Pro Set" format
- User enters single set score (first to 8 games)
- System validates pro set score
- Skip steps 7-8
- Continue with step 9

**A3: Match tiebreak (third set alternative)**
- At step 5, user selects "Match Tiebreak" format
- User enters scores for Set 1 and Set 2
- At step 8, user enters match tiebreak score (first to 10 points)
- Continue with step 9

#### Exception Flows

**E1: Invalid score format**
- At step 9, system detects invalid score (e.g., 6-5 set, 8-7 tiebreak)
- System displays error: "Invalid score. Sets must be won by 2 games (6-4, 7-5) or by tiebreak (7-6)."
- System highlights error field
- User corrects score
- Continue with step 9

**E2: Winner selected incorrectly**
- At step 9, system detects reported winner lost based on scores
- System displays: "Score shows [Opponent] won. Please verify winner and score."
- User corrects winner or score
- Continue with step 9

**E3: Verification notification failure**
- At step 13, notification service fails
- System logs error and queues retry
- System proceeds with confirmation (step 14)
- System retries notification delivery
- Use case continues

#### Postconditions
- **Success:** Score reported with "Pending Verification" status, opponent notified
- **Failure:** No score recorded, user can retry submission

#### Business Rules
- BR-030: Only match winner can initially report score
- BR-031: Scores must follow standard tennis scoring rules
- BR-032: Set scores must be 6-4 or better, 7-5, or 7-6 (tiebreak)
- BR-033: Tiebreak at 6-6 in each set
- BR-034: Match tiebreak first to 10 points (if used as third set)
- BR-035: Winner should report score within 24 hours (not enforced)

---

### UC-005: Verify Match Score

**Actor:** Match Loser  
**Priority:** Must Have  
**Related Requirements:** FR-5.2

#### Preconditions
- User is logged in
- Opponent has reported match score
- Score status is "Pending Verification"
- Less than 48 hours have passed since score report

#### Main Success Scenario - Confirm Score
1. User receives notification: "[Opponent] reported score. Please verify."
2. User opens app
3. System displays score verification request
4. User reviews reported score
5. User clicks "Confirm Score"
6. System displays confirmation dialog
7. User confirms
8. System updates score status to "Verified"
9. System triggers ranking update algorithm (see UC-006)
10. System sends confirmation notification to both players
11. System displays: "Score confirmed. Rankings updated!"
12. System records match in both players' history

#### Alternative Flows - Dispute Score

**A1: Dispute with alternate score**
1. At step 5, user clicks "Dispute Score"
2. System displays dispute form with score entry
3. User enters what they believe is correct score
4. User optionally enters explanation (max 500 characters)
5. User submits dispute
6. System updates score status to "Disputed"
7. System notifies admin of dispute
8. System sends notification to opponent about dispute
9. System displays: "Dispute submitted. Admin will review and make final decision."
10. Admin reviews and resolves (see UC-023)
11. Use case ends

**A2: Auto-verify (48 hours elapsed)**
1. System daily cron job checks pending verifications
2. System identifies score older than 48 hours with no response
3. System automatically updates score status to "Verified"
4. System triggers ranking update algorithm
5. System sends notification to both players
6. System displays on next login: "Score auto-verified. Rankings updated."
7. Use case ends

#### Exception Flows

**E1: Score already verified or disputed**
- At step 5, system detects score no longer "Pending"
- System displays: "This score was already verified/disputed."
- System refreshes verification list
- Use case ends

**E2: Opponent cancelled score report**
- At step 5, system detects score report was retracted
- System displays: "[Opponent] withdrew the score report."
- System removes verification request
- Use case ends

#### Postconditions
- **Success (Confirm):** Score verified, rankings updated, match recorded in history
- **Success (Dispute):** Score disputed, admin notified, awaiting resolution
- **Failure:** Score remains "Pending Verification", user can retry verification

#### Business Rules
- BR-040: Loser has 48 hours to verify or dispute score
- BR-041: Auto-verification occurs at 48 hours if no response
- BR-042: Disputed scores require admin resolution
- BR-043: Verified scores immediately trigger ranking updates
- BR-044: Auto-verified scores also trigger ranking updates

---

### UC-006: Update Rankings

**Actor:** System (Automated)  
**Priority:** Must Have  
**Related Requirements:** FR-4.1

#### Preconditions
- Match score has been verified
- Both players are ranked (not unranked)
- Players are in same division

#### Main Success Scenario - Lower-Ranked Player Wins
1. System receives score verification event
2. System retrieves both players' current rankings
3. System determines winner and loser from score
4. System checks if winner ranked lower than loser
5. Winner ranked lower confirmed
6. System implements swap algorithm:
   - Winner takes loser's position
   - Loser drops one position
   - All players between them shift down one position
7. System updates all affected player rankings in database
8. System records ranking changes with timestamp
9. System sends real-time update to all online users
10. System sends notification to all affected players
11. System logs ranking change in activity feed
12. System updates player statistics (wins, losses, ranking history)

#### Alternative Flows

**A1: Higher-Ranked Player Wins (Defense)**
1. At step 5, system determines winner ranked higher
2. System maintains all rankings unchanged
3. System records match in history as "defense"
4. System updates player statistics (wins, losses)
5. System sends notifications to both players: "Rankings unchanged"
6. Use case ends

**A2: Players at same ranking (edge case)**
1. At step 5, system detects players have same ranking
2. System maintains rankings or applies tie-break rule (most recent win ranks higher)
3. System updates tie-break status
4. System sends notifications
5. Use case ends

#### Exception Flows

**E1: Database transaction failure**
- At step 7, database update fails
- System rolls back transaction
- System logs error
- System retries update (3 attempts with exponential backoff)
- If all retries fail, system notifies admin
- Manual resolution required

**E2: Real-time update failure**
- At step 9, WebSocket broadcast fails
- System logs error
- System continues (users will see update on next page refresh)
- Use case continues

#### Postconditions
- **Success:** Rankings updated accurately, all affected players notified
- **Failure:** Rankings unchanged, error logged for manual resolution

#### Business Rules
- BR-050: Winner takes loser's position when ranked lower
- BR-051: All players between them shift down by one position
- BR-052: Higher-ranked winner maintains rankings (defense)
- BR-053: Ranking updates are atomic (all or nothing)
- BR-054: Ranking history is maintained for all changes
- BR-055: Real-time updates propagate within 5 seconds

---

## 3. Administrative Use Cases

### UC-021: Approve New Player

**Actor:** Admin  
**Priority:** Must Have  
**Related Requirements:** FR-6.2

#### Preconditions
- Admin is logged in with admin privileges
- New player registration requires approval
- Player has registered and status is "Pending Approval"

#### Main Success Scenario
1. System notifies admin of new registration
2. Admin navigates to "Pending Registrations" page
3. System displays list of pending players with details
4. Admin selects player to review
5. System displays player profile (name, email, phone, self-reported skill level)
6. Admin reviews player information
7. Admin clicks "Approve"
8. System displays initial placement options:
   - Unranked (requires 3 qualifying matches)
   - Bottom of ladder
   - Specific position (admin enters)
9. Admin selects "Unranked"
10. System updates player status to "Active (Unranked)"
11. System sends approval email to player
12. System displays confirmation: "[Player] approved as unranked."

#### Alternative Flows

**A1: Place at specific position**
- At step 9, admin selects "Specific Position"
- System prompts for position number
- Admin enters position (e.g., 15)
- System validates position is within range
- System shifts all players at or below that position down by one
- System updates all rankings
- Continue with step 11

**A2: Reject registration**
- At step 7, admin clicks "Reject"
- System displays rejection dialog with reason field
- Admin enters rejection reason (required)
- Admin confirms rejection
- System updates player status to "Rejected"
- System sends rejection email to player with reason
- System removes player from pending list
- Use case ends

**A3: Request more information**
- At step 7, admin clicks "Request Info"
- System displays message dialog
- Admin enters questions/requests
- System sends email to player requesting information
- Player status remains "Pending Approval"
- Use case ends (await player response)

#### Exception Flows

**E1: Player withdrew registration**
- At step 5, system detects player deleted account
- System displays: "Player is no longer registered."
- System removes from pending list
- Use case ends

#### Postconditions
- **Success (Approve):** Player activated and placed in ladder
- **Success (Reject):** Player rejected and removed from system
- **Failure:** Player remains pending, admin can retry

#### Business Rules
- BR-060: Admin approval required if configured in ladder settings
- BR-061: Rejected players can re-register after 30 days
- BR-062: Approved players must be assigned initial status (ranked or unranked)
- BR-063: Specific position placement shifts all lower-ranked players down

---

### UC-022: Configure Ladder Settings

**Actor:** Admin  
**Priority:** Must Have  
**Related Requirements:** FR-6.1

#### Preconditions
- Admin is logged in with admin privileges
- Ladder exists

#### Main Success Scenario
1. Admin navigates to "Ladder Settings"
2. System displays current configuration
3. Admin reviews settings
4. Admin clicks "Edit Settings"
5. System displays editable configuration form with sections:
   - Challenge Rules
   - Scoring Rules
   - Inactivity Rules
   - Division Settings
   - Notification Settings
6. Admin modifies challenge constraints (spots up: 3 → 4)
7. Admin modifies inactivity period (60 days → 90 days)
8. Admin reviews all changes
9. Admin clicks "Save Changes"
10. System validates all settings
11. System displays confirmation dialog showing changes
12. Admin confirms changes
13. System updates ladder configuration
14. System logs configuration change with timestamp and admin name
15. System notifies all players of rule changes (if significant)
16. System displays: "Settings updated successfully."

#### Alternative Flows

**A1: Cancel changes**
- At step 9, admin clicks "Cancel"
- System discards all changes
- System returns to view-only settings
- Use case ends

**A2: Reset to defaults**
- At any point, admin clicks "Reset to Defaults"
- System displays warning dialog
- Admin confirms reset
- System restores default configuration
- Continue with step 10

#### Exception Flows

**E1: Invalid setting values**
- At step 10, system detects invalid values (e.g., spots up = 0)
- System displays errors: "Spots up must be between 1 and 10"
- System highlights error fields
- Admin corrects values
- Continue with step 9

**E2: Conflicting settings**
- At step 10, system detects conflicting rules
- System displays warning: "Inactivity period should be longer than challenge expiration"
- Admin acknowledges warning and continues or revises
- Continue based on admin decision

#### Postconditions
- **Success:** Configuration updated, changes logged, players notified if needed
- **Failure:** Configuration unchanged, admin can retry

#### Business Rules
- BR-070: Challenge spots up must be 1-10
- BR-071: Challenge spots down must be 1-10
- BR-072: Inactivity period must be 30-365 days
- BR-073: Score verification period must be 12-72 hours
- BR-074: Configuration changes are logged for audit trail
- BR-075: Significant changes trigger player notifications

---

### UC-023: Resolve Score Dispute

**Actor:** Admin  
**Priority:** Must Have  
**Related Requirements:** FR-5.3

#### Preconditions
- Admin is logged in with admin privileges
- Match score has been disputed by loser
- Dispute status is "Under Review"

#### Main Success Scenario
1. System notifies admin of score dispute
2. Admin navigates to "Disputed Matches"
3. System displays list of matches awaiting resolution
4. Admin selects disputed match
5. System displays dispute details:
   - Winner's reported score
   - Loser's disputed score
   - Loser's explanation
   - Match date and players
6. Admin reviews both scores and explanation
7. Admin optionally contacts players for clarification
8. Admin determines correct score
9. Admin selects correct score (or enters different score)
10. Admin enters resolution note (required, max 500 characters)
11. Admin clicks "Resolve Dispute"
12. System displays confirmation dialog
13. Admin confirms resolution
14. System updates match score to admin's decision
15. System updates dispute status to "Resolved"
16. System triggers ranking update based on final score
17. System sends notification to both players with admin's decision and note
18. System logs resolution in audit trail
19. System displays: "Dispute resolved."

#### Alternative Flows

**A1: Void match (no ranking change)**
- At step 9, admin selects "Void Match"
- Admin enters reason for voiding (required)
- Admin confirms void
- System updates match status to "Voided"
- System does not update rankings
- System notifies both players that match was voided with reason
- Use case ends

**A2: Request additional information**
- At step 7, admin sends message to both players
- System facilitates communication
- Players provide additional context
- Admin continues review
- Continue with step 8

#### Exception Flows

**E1: Players resolve dispute themselves**
- At step 4, system detects players reached agreement
- Dispute status changed to "Resolved - Players Agreed"
- System displays: "Players resolved this dispute themselves."
- Admin can view resolution
- Use case ends

#### Postconditions
- **Success:** Dispute resolved, correct score recorded, rankings updated
- **Failure:** Dispute remains unresolved, admin can retry

#### Business Rules
- BR-080: Admin has final authority on all score disputes
- BR-081: Admin must provide resolution note
- BR-082: Resolution decision is final and cannot be re-disputed
- BR-083: Voided matches do not affect rankings
- BR-084: All dispute resolutions are logged for transparency

---

## 4. Advanced Use Cases

### UC-031: View Player Statistics

**Actor:** Player  
**Priority:** Should Have  
**Related Requirements:** FR-8.1

#### Preconditions
- User is logged in
- User has played at least 1 match

#### Main Success Scenario
1. User navigates to "My Stats" page
2. System retrieves user's match history and ranking data
3. System calculates statistics
4. System displays statistics page with:
   - Total matches played
   - Win/loss record and win percentage
   - Current ranking and highest ranking achieved
   - Ranking history graph (last 3 months)
   - Current streak (winning or losing)
   - Win rate vs. higher/lower ranked opponents
   - Most common opponents
   - Recent match history
5. User views statistics
6. User optionally adjusts time range filter (last month, 3 months, year, all time)
7. System recalculates and updates display

#### Alternative Flows

**A1: Compare with another player**
- At step 5, user clicks "Compare with Player"
- System displays player selection dialog
- User selects opponent
- System displays side-by-side comparison
- User views comparison
- Use case continues

**A2: View ranking history details**
- At step 5, user clicks on graph point
- System displays matches and ranking changes for that date
- User views details
- Use case continues

#### Exception Flows

**E1: No match history**
- At step 2, system detects user has no matches
- System displays: "No matches played yet. Challenge someone to get started!"
- System provides link to ladder standings
- Use case ends

#### Postconditions
- **Success:** Statistics displayed, user gains insights into performance
- **Failure:** Error displayed, user can retry

#### Business Rules
- BR-090: Statistics calculated based on verified matches only
- BR-091: Ranking history retained for lifetime of account
- BR-092: Win percentage calculated as wins / (wins + losses)

---

### UC-032: Manage Season

**Actor:** Admin  
**Priority:** Should Have  
**Related Requirements:** FR-6.3

#### Preconditions
- Admin is logged in with admin privileges
- Current season is active or admin wants to start new season

#### Main Success Scenario - End Season and Start New
1. Admin navigates to "Season Management"
2. System displays current season details and options
3. Admin clicks "End Current Season"
4. System displays end season dialog with options:
   - End date (defaults to today)
   - Reset method: Full Reset / Seeded Reset / Carry Forward
   - Generate end-of-season report
5. Admin selects "Seeded Reset" and confirms end date
6. Admin checks "Generate Report"
7. Admin clicks "End Season"
8. System displays confirmation dialog
9. Admin confirms
10. System freezes current rankings with timestamp
11. System generates end-of-season report (PDF)
12. System creates new season
13. System seeds players based on previous season rankings
14. System sends notification to all players about season change
15. System displays: "Season ended. New season started with seeded rankings."

#### Alternative Flows

**A1: Full reset (all players unranked)**
- At step 5, admin selects "Full Reset"
- System sets all players to unranked status
- System requires new ranking process
- Continue with step 7

**A2: Carry forward rankings**
- At step 5, admin selects "Carry Forward"
- System maintains exact same rankings for new season
- Continue with step 7

**A3: Schedule future season end**
- At step 5, admin selects future end date
- System schedules season end job
- System sends reminders to players about upcoming season end
- System automatically ends season on scheduled date
- Use case ends

#### Exception Flows

**E1: Active matches exist**
- At step 9, system detects pending matches
- System displays: "X matches are still active. End season anyway?"
- If admin confirms, system voids active matches
- If admin cancels, use case ends
- Continue based on admin decision

#### Postconditions
- **Success:** Season ended, new season started with chosen reset method
- **Failure:** Season unchanged, admin can retry

#### Business Rules
- BR-100: Only one active season at a time
- BR-101: Historical season data retained indefinitely
- BR-102: End-of-season reports include: final rankings, total matches, top players
- BR-103: Players must acknowledge season change on next login

---

### UC-033: Set Player Availability

**Actor:** Player  
**Priority:** Could Have  
**Related Requirements:** FR-9.1 (related to social features)

#### Preconditions
- User is logged in
- User is active player

#### Main Success Scenario
1. User navigates to "My Profile"
2. System displays profile with availability section
3. User clicks "Set Availability"
4. System displays availability calendar
5. User selects days/times they are available to play
6. User optionally sets recurring availability (e.g., "Every Tuesday 6-8pm")
7. User optionally sets blocked dates (vacation, injury)
8. User sets status: Available / Limited Availability / Unavailable
9. User clicks "Save Availability"
10. System updates user's availability status
11. System makes availability visible to other players when considering challenges
12. System displays confirmation: "Availability updated."

#### Alternative Flows

**A1: Set vacation mode**
- At step 8, user selects "Unavailable" with vacation dates
- System grants temporary inactivity exemption
- System displays vacation status on profile
- Other players see "On vacation until [date]"
- Continue with step 9

**A2: Report injury**
- At step 8, user selects "Injured" status
- System prompts for expected return date
- System grants inactivity exemption
- System displays injury status on profile
- Continue with step 9

#### Exception Flows

**E1: Date conflicts**
- At step 6, system detects overlapping availability settings
- System highlights conflicts
- User resolves conflicts
- Continue with step 9

#### Postconditions
- **Success:** Availability updated and visible to other players
- **Failure:** Availability unchanged, user can retry

#### Business Rules
- BR-110: Availability is optional but recommended
- BR-111: Unavailable players cannot be challenged
- BR-112: Vacation exemptions last maximum 90 days
- BR-113: Injury exemptions require admin approval for >30 days

---

## Use Case Relationships

### Use Case Diagram

```
┌────────────────────────────────────────────────────────────┐
│                    Elite Tennis Ladder                      │
└────────────────────────────────────────────────────────────┘

                    ┌─────────────┐
                    │   Player    │
                    └──────┬──────┘
                           │
           ┌───────────────┼───────────────┐
           │               │               │
           ▼               ▼               ▼
    ┌────────────┐  ┌────────────┐  ┌────────────┐
    │  Register  │  │   Send     │  │   Report   │
    │            │  │ Challenge  │  │   Score    │
    └────────────┘  └────────────┘  └────────────┘
                           │
                           │ includes
                           ▼
                    ┌────────────┐
                    │  Respond   │
                    │ Challenge  │
                    └────────────┘
                           │
                           │ triggers
                           ▼
                    ┌────────────┐
                    │   Update   │
                    │  Rankings  │
                    └────────────┘


                    ┌─────────────┐
                    │    Admin    │
                    └──────┬──────┘
                           │
           ┌───────────────┼───────────────┐
           │               │               │
           ▼               ▼               ▼
    ┌────────────┐  ┌────────────┐  ┌────────────┐
    │  Approve   │  │ Configure  │  │  Resolve   │
    │   Player   │  │  Ladder    │  │  Dispute   │
    └────────────┘  └────────────┘  └────────────┘
                                           │
                                   ┌───────┴────────┐
                                   │                │
                                   ▼                ▼
                            ┌────────────┐   ┌──────────┐
                            │   Void     │   │  Update  │
                            │   Match    │   │ Rankings │
                            └────────────┘   └──────────┘
```

---

## Document Approval

### Review and Sign-Off

| Role | Name | Signature | Date |
|------|------|-----------|------|
| Product Owner | _____________ | _____________ | _____ |
| Lead Developer | _____________ | _____________ | _____ |
| QA Lead | _____________ | _____________ | _____ |
| UX Designer | _____________ | _____________ | _____ |

---

**Document Version:** 1.0  
**Last Updated:** December 2025  
**Next Review:** January 2026
