# Functional Requirements Document

**Project:** Elite Tennis Ladder  
**Version:** 1.0  
**Date:** December 2025  
**Status:** Draft  
**Document Owner:** Product Team

---

## Table of Contents

1. [Introduction](#1-introduction)
2. [User Authentication & Profile Management](#2-user-authentication--profile-management)
3. [Challenge System](#3-challenge-system)
4. [Ranking & Scoring System](#4-ranking--scoring-system)
5. [Match Management](#5-match-management)
6. [Admin & Configuration](#6-admin--configuration)
7. [Notification System](#7-notification-system)
8. [Reporting & Analytics](#8-reporting--analytics)
9. [Social Features](#9-social-features)

---

## 1. Introduction

### 1.1 Purpose

This document specifies the functional requirements for the Elite Tennis Ladder platform. It describes what the system must do from a user perspective, covering all user workflows and interactions.

### 1.2 Scope

Elite Tennis Ladder is a mobile-first web application that enables tennis clubs to manage competitive ladders, allowing players to challenge each other, report match results, and track rankings automatically.

### 1.3 Definitions

- **Player**: A registered user who participates in ladder matches
- **Admin**: A user with administrative privileges to manage the ladder
- **Challenge**: A request from one player to another for a match
- **Ranking**: A player's position on the ladder
- **Division**: A skill-based grouping of players within a ladder

---

## 2. User Authentication & Profile Management

### FR-2.1: User Registration

**ID:** FR-2.1  
**Priority:** Must Have  
**User Story:** As a new player, I want to create an account so that I can join a tennis ladder.

**Requirements:**
- FR-2.1.1: System shall allow users to register with email and password
- FR-2.1.2: System shall validate email format and password strength (min 8 characters, 1 uppercase, 1 number)
- FR-2.1.3: System shall send email verification link upon registration
- FR-2.1.4: System shall prevent duplicate email registrations
- FR-2.1.5: System shall collect required profile information: name, email, phone (optional)

**Acceptance Criteria:**
- User can complete registration in less than 2 minutes
- Email verification link is received within 1 minute
- Duplicate email attempts show clear error message

---

### FR-2.2: User Login

**ID:** FR-2.2  
**Priority:** Must Have  
**User Story:** As a registered player, I want to log in securely so that I can access my ladder and matches.

**Requirements:**
- FR-2.2.1: System shall authenticate users with email/password
- FR-2.2.2: System shall provide "Remember Me" option for trusted devices
- FR-2.2.3: System shall implement session timeout after 30 days of inactivity
- FR-2.2.4: System shall provide "Forgot Password" functionality with email reset
- FR-2.2.5: System shall lock account after 5 failed login attempts for 15 minutes

**Acceptance Criteria:**
- Login completes in less than 3 seconds
- Password reset email arrives within 1 minute
- Clear error messages for invalid credentials

---

### FR-2.3: Player Profile Management

**ID:** FR-2.3  
**Priority:** Must Have  
**User Story:** As a player, I want to manage my profile so that other players can identify me and contact me.

**Requirements:**
- FR-2.3.1: System shall allow users to upload profile photo (max 5MB, JPG/PNG)
- FR-2.3.2: System shall allow users to update name, phone, and bio (max 500 characters)
- FR-2.3.3: System shall display player's ranking, win/loss record, and match history
- FR-2.3.4: System shall allow users to set notification preferences (email, push, SMS)
- FR-2.3.5: System shall allow users to set availability status (active, vacation, injured)

**Acceptance Criteria:**
- Profile updates save immediately with confirmation
- Profile photo displays within 5 seconds of upload
- Other players can view public profile information

---

### FR-2.4: Privacy Settings

**ID:** FR-2.4  
**Priority:** Should Have  
**User Story:** As a player, I want to control my privacy so that I can decide what information is visible to others.

**Requirements:**
- FR-2.4.1: System shall allow users to hide phone number from other players
- FR-2.4.2: System shall allow users to hide match history from non-ladder members
- FR-2.4.3: System shall allow users to opt-out of public leaderboards
- FR-2.4.4: System shall respect player's privacy choices in all displays

**Acceptance Criteria:**
- Privacy settings apply immediately
- Hidden information is not accessible via any public page

---

## 3. Challenge System

### FR-3.1: Challenge Creation

**ID:** FR-3.1  
**Priority:** Must Have  
**User Story:** As a player, I want to challenge players ranked above me so that I can improve my ranking.

**Requirements:**
- FR-3.1.1: System shall display list of players eligible for challenge based on position constraints
- FR-3.1.2: System shall prevent challenges outside configured position range (default: 3 spots up)
- FR-3.1.3: System shall limit players to maximum 2 pending challenges at once
- FR-3.1.4: System shall prevent re-challenging same player within 14 days of decline
- FR-3.1.5: System shall allow optional message with challenge (max 200 characters)
- FR-3.1.6: System shall send notification to challenged player immediately
- FR-3.1.7: System shall create challenge with status "Pending"

**Acceptance Criteria:**
- Challenge creation completes in less than 5 seconds
- Challenged player receives notification within 30 seconds
- System enforces all constraint rules with clear error messages

---

### FR-3.2: Challenge Response

**ID:** FR-3.2  
**Priority:** Must Have  
**User Story:** As a challenged player, I want to accept or decline challenges so that I can manage my match schedule.

**Requirements:**
- FR-3.2.1: System shall display all pending challenges to the challenged player
- FR-3.2.2: System shall allow player to accept challenge
- FR-3.2.3: System shall allow player to decline challenge with optional reason
- FR-3.2.4: System shall notify challenger immediately of accept/decline decision
- FR-3.2.5: System shall automatically decline challenge after 7 days if no response
- FR-3.2.6: System shall send reminder notifications at day 3 and day 6
- FR-3.2.7: System shall update challenge status to "Accepted", "Declined", or "Expired"

**Acceptance Criteria:**
- Challenge accept/decline completes in less than 3 seconds
- Challenger receives notification within 30 seconds
- Auto-decline occurs exactly 7 days after challenge creation

---

### FR-3.3: Challenge Tracking

**ID:** FR-3.3  
**Priority:** Must Have  
**User Story:** As a player, I want to view my challenge history so that I can track my matches.

**Requirements:**
- FR-3.3.1: System shall display all challenges (sent and received) with status
- FR-3.3.2: System shall show challenge date, opponent, current status
- FR-3.3.3: System shall allow filtering by status (pending, accepted, declined, completed)
- FR-3.3.4: System shall show time remaining for pending challenges
- FR-3.3.5: System shall allow players to view opponent's profile from challenge

**Acceptance Criteria:**
- Challenge history loads in less than 2 seconds
- All statuses display accurately
- Filters work correctly and update display immediately

---

### FR-3.4: Challenge Cancellation

**ID:** FR-3.4  
**Priority:** Should Have  
**User Story:** As a challenger, I want to cancel my pending challenge so that I can withdraw if circumstances change.

**Requirements:**
- FR-3.4.1: System shall allow challenger to cancel pending challenges
- FR-3.4.2: System shall require cancellation reason (optional)
- FR-3.4.3: System shall notify challenged player of cancellation
- FR-3.4.4: System shall update challenge status to "Cancelled"
- FR-3.4.5: System shall not count cancelled challenges toward re-challenge restriction

**Acceptance Criteria:**
- Cancellation completes in less than 3 seconds
- Challenged player receives notification
- Cancelled challenges don't affect future challenge eligibility

---

## 4. Ranking & Scoring System

### FR-4.1: Ranking Algorithm

**ID:** FR-4.1  
**Priority:** Must Have  
**User Story:** As an admin, I want an automated ranking system so that ladder positions update automatically after matches.

**Requirements:**
- FR-4.1.1: System shall implement swap/leapfrog ranking algorithm
- FR-4.1.2: System shall move winner to loser's position when lower-ranked player wins
- FR-4.1.3: System shall shift all players between winner and loser down by one position
- FR-4.1.4: System shall maintain rankings unchanged when higher-ranked player wins
- FR-4.1.5: System shall update rankings immediately after score verification
- FR-4.1.6: System shall notify all affected players of ranking changes
- FR-4.1.7: System shall maintain ranking history with timestamps

**Acceptance Criteria:**
- Rankings update within 5 seconds of score verification
- Algorithm correctly handles all scenarios (upward challenge win, defense win)
- Ranking history is accurate and complete

---

### FR-4.2: Initial Player Ranking

**ID:** FR-4.2  
**Priority:** Must Have  
**User Story:** As an admin, I want to assign initial rankings to new players so that they can join the ladder.

**Requirements:**
- FR-4.2.1: System shall place new players in "Unranked" pool by default
- FR-4.2.2: System shall allow admin to place new players at specific position
- FR-4.2.3: System shall allow admin to place new players at bottom of ladder
- FR-4.2.4: System shall require minimum 3 qualifying matches for unranked players
- FR-4.2.5: System shall allow admin to review unranked player results and assign position

**Acceptance Criteria:**
- New player placement options are clear and functional
- Unranked players can participate in qualifying matches
- Admin can easily review and rank unranked players

---

### FR-4.3: Inactivity Management

**ID:** FR-4.3  
**Priority:** Must Have  
**User Story:** As an admin, I want inactive players to be managed automatically so that the ladder remains active and fair.

**Requirements:**
- FR-4.3.1: System shall track days since last match for each player
- FR-4.3.2: System shall send inactivity warning at 45 days (configurable)
- FR-4.3.3: System shall mark player inactive after 60 days without match (configurable)
- FR-4.3.4: System shall allow admin to choose inactivity action:
  - Move to bottom of ladder
  - Move to inactive pool (requires reactivation)
  - Remove from ladder
- FR-4.3.5: System shall allow admin to grant inactivity exemptions
- FR-4.3.6: System shall allow players to self-report temporary absence

**Acceptance Criteria:**
- Inactivity detection runs daily
- Warning notifications are sent on schedule
- Inactivity penalties apply correctly based on admin configuration

---

### FR-4.4: Division Management

**ID:** FR-4.4  
**Priority:** Should Have  
**User Story:** As an admin, I want to create skill-based divisions so that players compete at appropriate levels.

**Requirements:**
- FR-4.4.1: System shall allow admin to create multiple divisions (e.g., A, B, C)
- FR-4.4.2: System shall restrict challenges within same division only
- FR-4.4.3: System shall allow admin to move players between divisions
- FR-4.4.4: System shall track separate rankings for each division
- FR-4.4.5: System shall display division membership clearly on profiles and leaderboards

**Acceptance Criteria:**
- Multiple divisions can be created and configured
- Challenge restrictions work correctly across divisions
- Players can see their division and division rankings

---

## 5. Match Management

### FR-5.1: Score Reporting

**ID:** FR-5.1  
**Priority:** Must Have  
**User Story:** As a match winner, I want to report the score so that rankings can be updated.

**Requirements:**
- FR-5.1.1: System shall allow winner to report score for completed accepted challenges
- FR-5.1.2: System shall support standard tennis scoring (sets and games)
- FR-5.1.3: System shall validate score format (6-4, 7-5, 7-6, etc.)
- FR-5.1.4: System shall support best-of-3 sets, pro sets, and match tiebreak formats
- FR-5.1.5: System shall allow entering tiebreak scores for 7-6 sets
- FR-5.1.6: System shall send verification request to loser immediately
- FR-5.1.7: System shall update match status to "Pending Verification"

**Acceptance Criteria:**
- Score entry form is mobile-optimized and easy to use
- Score validation prevents invalid scores (e.g., 6-5 sets)
- Loser receives verification request within 30 seconds

---

### FR-5.2: Score Verification

**ID:** FR-5.2  
**Priority:** Must Have  
**User Story:** As a match loser, I want to verify the reported score so that results are accurate.

**Requirements:**
- FR-5.2.1: System shall notify loser of reported score
- FR-5.2.2: System shall allow loser to confirm score within 48 hours (configurable)
- FR-5.2.3: System shall allow loser to dispute score with alternate score
- FR-5.2.4: System shall automatically verify score after 48 hours if no response
- FR-5.2.5: System shall update match status to "Verified" upon confirmation
- FR-5.2.6: System shall trigger ranking update upon verification
- FR-5.2.7: System shall notify both players of verification

**Acceptance Criteria:**
- Verification completes in less than 3 seconds
- Auto-verification occurs exactly 48 hours after score report
- Rankings update immediately after verification

---

### FR-5.3: Score Disputes

**ID:** FR-5.3  
**Priority:** Must Have  
**User Story:** As an admin, I want to resolve score disputes so that accurate results are recorded.

**Requirements:**
- FR-5.3.1: System shall notify admin immediately of score disputes
- FR-5.3.2: System shall display both reported scores side-by-side
- FR-5.3.3: System shall allow admin to select correct score
- FR-5.3.4: System shall allow admin to void match (no ranking change)
- FR-5.3.5: System shall allow admin to contact both players via system
- FR-5.3.6: System shall update match status to "Disputed" during resolution
- FR-5.3.7: System shall record admin's final decision with note

**Acceptance Criteria:**
- Admin receives dispute notification within 30 seconds
- Admin interface clearly shows both scores and player claims
- Final decision applies correctly and updates rankings

---

### FR-5.4: Match History

**ID:** FR-5.4  
**Priority:** Must Have  
**User Story:** As a player, I want to view my match history so that I can track my progress.

**Requirements:**
- FR-5.4.1: System shall display all completed matches with scores
- FR-5.4.2: System shall show match date, opponent, result (win/loss), score
- FR-5.4.3: System shall allow filtering by opponent, date range, result
- FR-5.4.4: System shall display ranking change from each match
- FR-5.4.5: System shall show win/loss statistics (total, win percentage, streak)
- FR-5.4.6: System shall allow viewing opponent's profile from match history

**Acceptance Criteria:**
- Match history loads in less than 2 seconds
- All matches display correct information
- Statistics are calculated accurately

---

## 6. Admin & Configuration

### FR-6.1: Ladder Configuration

**ID:** FR-6.1  
**Priority:** Must Have  
**User Story:** As an admin, I want to configure ladder rules so that it matches our club's preferences.

**Requirements:**
- FR-6.1.1: System shall allow admin to set challenge constraints (spots up/down)
- FR-6.1.2: System shall allow admin to set challenge expiration period (3-14 days)
- FR-6.1.3: System shall allow admin to set score verification period (12-72 hours)
- FR-6.1.4: System shall allow admin to set inactivity threshold (30-90 days)
- FR-6.1.5: System shall allow admin to select inactivity penalty action
- FR-6.1.6: System shall allow admin to set match format (best of 3, pro set, etc.)
- FR-6.1.7: System shall allow admin to set maximum pending challenges per player

**Acceptance Criteria:**
- All configuration options are easily accessible
- Configuration changes apply immediately
- System validates configuration values (ranges, dependencies)

---

### FR-6.2: Player Management

**ID:** FR-6.2  
**Priority:** Must Have  
**User Story:** As an admin, I want to manage players so that I can control ladder membership.

**Requirements:**
- FR-6.2.1: System shall allow admin to approve/reject registration requests
- FR-6.2.2: System shall allow admin to manually add players
- FR-6.2.3: System shall allow admin to deactivate/remove players
- FR-6.2.4: System shall allow admin to manually adjust player rankings
- FR-6.2.5: System shall allow admin to grant inactivity exemptions
- FR-6.2.6: System shall allow admin to assign players to divisions
- FR-6.2.7: System shall log all admin actions with timestamp and reason

**Acceptance Criteria:**
- Admin can manage all player operations from dashboard
- Manual ranking adjustments are logged and visible
- Player removal preserves historical data

---

### FR-6.3: Season Management

**ID:** FR-6.3  
**Priority:** Should Have  
**User Story:** As an admin, I want to manage seasons so that I can run time-based competitions.

**Requirements:**
- FR-6.3.1: System shall allow admin to create seasons with start/end dates
- FR-6.3.2: System shall freeze rankings at season end
- FR-6.3.3: System shall allow admin to choose reset method:
  - Full reset (all unranked)
  - Seeded reset (previous rankings as seeds)
  - Carry forward (rankings continue)
- FR-6.3.4: System shall generate end-of-season reports
- FR-6.3.5: System shall allow viewing historical season data
- FR-6.3.6: System shall support ongoing (non-seasonal) ladders

**Acceptance Criteria:**
- Season creation and configuration is straightforward
- Season transitions work correctly with chosen reset method
- Historical season data is preserved and accessible

---

### FR-6.4: Reporting & Analytics

**ID:** FR-6.4  
**Priority:** Should Have  
**User Story:** As an admin, I want to view analytics so that I can understand ladder activity.

**Requirements:**
- FR-6.4.1: System shall display total players, active players, inactive players
- FR-6.4.2: System shall show total matches played (daily, weekly, monthly)
- FR-6.4.3: System shall display average matches per player
- FR-6.4.4: System shall show challenge acceptance rate
- FR-6.4.5: System shall display most active players
- FR-6.4.6: System shall show ranking volatility (most movement)
- FR-6.4.7: System shall allow exporting data to CSV

**Acceptance Criteria:**
- Analytics dashboard loads in less than 3 seconds
- All metrics are accurate and update daily
- CSV export includes all relevant data

---

## 7. Notification System

### FR-7.1: Email Notifications

**ID:** FR-7.1  
**Priority:** Must Have  
**User Story:** As a player, I want to receive email notifications so that I don't miss important updates.

**Requirements:**
- FR-7.1.1: System shall send email for new challenges received
- FR-7.1.2: System shall send email for challenge acceptance/decline
- FR-7.1.3: System shall send email for score verification requests
- FR-7.1.4: System shall send email for ranking updates
- FR-7.1.5: System shall send email for challenge expiration warnings
- FR-7.1.6: System shall send email for inactivity warnings
- FR-7.1.7: System shall include actionable links in all emails

**Acceptance Criteria:**
- Emails deliver within 1 minute of event
- Email content is clear and mobile-friendly
- Links in emails work correctly and lead to relevant pages

---

### FR-7.2: Push Notifications

**ID:** FR-7.2  
**Priority:** Should Have  
**User Story:** As a mobile user, I want push notifications so that I receive instant updates.

**Requirements:**
- FR-7.2.1: System shall support web push notifications
- FR-7.2.2: System shall send push notification for new challenges
- FR-7.2.3: System shall send push notification for challenge responses
- FR-7.2.4: System shall send push notification for score verification requests
- FR-7.2.5: System shall send push notification for ranking changes
- FR-7.2.6: System shall allow users to customize notification preferences
- FR-7.2.7: System shall respect user's push notification permissions

**Acceptance Criteria:**
- Push notifications deliver within 30 seconds
- Notification content is concise and actionable
- Users can control which notifications they receive

---

### FR-7.3: In-App Notifications

**ID:** FR-7.3  
**Priority:** Should Have  
**User Story:** As a player, I want an in-app notification center so that I can review all notifications in one place.

**Requirements:**
- FR-7.3.1: System shall maintain notification center with all notifications
- FR-7.3.2: System shall display unread notification count
- FR-7.3.3: System shall allow marking notifications as read
- FR-7.3.4: System shall allow clearing all notifications
- FR-7.3.5: System shall show notification timestamp
- FR-7.3.6: System shall link notifications to relevant pages
- FR-7.3.7: System shall retain notifications for 30 days

**Acceptance Criteria:**
- Notification center displays all notifications
- Unread count is accurate
- Notifications link correctly to related content

---

## 8. Reporting & Analytics

### FR-8.1: Player Statistics

**ID:** FR-8.1  
**Priority:** Should Have  
**User Story:** As a player, I want to view my statistics so that I can track my performance.

**Requirements:**
- FR-8.1.1: System shall display total matches played
- FR-8.1.2: System shall display win/loss record and win percentage
- FR-8.1.3: System shall display current ranking and highest ranking achieved
- FR-8.1.4: System shall show ranking history graph (last 3 months)
- FR-8.1.5: System shall display current winning/losing streak
- FR-8.1.6: System shall show win rate by opponent ranking (above/below)
- FR-8.1.7: System shall display most common opponents

**Acceptance Criteria:**
- Statistics page loads in less than 2 seconds
- All calculations are accurate
- Graphs are clear and mobile-friendly

---

### FR-8.2: Leaderboard

**ID:** FR-8.2  
**Priority:** Must Have  
**User Story:** As a player, I want to view the leaderboard so that I can see my standing relative to others.

**Requirements:**
- FR-8.2.1: System shall display current ladder rankings
- FR-8.2.2: System shall show player name, photo, ranking, record
- FR-8.2.3: System shall highlight current user's position
- FR-8.2.4: System shall show ranking change indicator (up/down/same)
- FR-8.2.5: System shall allow filtering by division
- FR-8.2.6: System shall update in real-time when rankings change
- FR-8.2.7: System shall allow viewing player profiles from leaderboard

**Acceptance Criteria:**
- Leaderboard loads in less than 2 seconds
- Rankings are always current and accurate
- Real-time updates appear without page refresh

---

## 9. Social Features

### FR-9.1: Activity Feed

**ID:** FR-9.1  
**Priority:** Could Have  
**User Story:** As a player, I want to see recent ladder activity so that I stay engaged with the community.

**Requirements:**
- FR-9.1.1: System shall display recent match results
- FR-9.1.2: System shall display new challenges created
- FR-9.1.3: System shall display ranking changes
- FR-9.1.4: System shall display new player joins
- FR-9.1.5: System shall allow filtering by activity type
- FR-9.1.6: System shall update feed in real-time
- FR-9.1.7: System shall show activity from last 7 days

**Acceptance Criteria:**
- Activity feed loads in less than 2 seconds
- Feed updates automatically with new activities
- Activities display clearly with relevant context

---

### FR-9.2: Player Interactions

**ID:** FR-9.2  
**Priority:** Could Have  
**User Story:** As a player, I want to interact with match results so that I can engage with the community.

**Requirements:**
- FR-9.2.1: System shall allow players to react to match results (like, respect)
- FR-9.2.2: System shall allow players to comment on match results (max 500 chars)
- FR-9.2.3: System shall display reaction counts on match results
- FR-9.2.4: System shall allow comment moderation by admin
- FR-9.2.5: System shall notify players of reactions/comments on their matches

**Acceptance Criteria:**
- Reactions and comments post immediately
- Notifications are sent for interactions
- Admin can remove inappropriate comments

---

## Document Approval

### Review and Sign-Off

| Role | Name | Signature | Date |
|------|------|-----------|------|
| Product Owner | _____________ | _____________ | _____ |
| Lead Developer | _____________ | _____________ | _____ |
| QA Lead | _____________ | _____________ | _____ |
| Stakeholder | _____________ | _____________ | _____ |

---

**Document Version:** 1.0  
**Last Updated:** December 2025  
**Next Review:** January 2026
