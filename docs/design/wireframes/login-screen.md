# Login Screen Wireframe

**Screen ID:** WF-001  
**Screen Name:** Login & Authentication  
**Version:** 1.3  
**Status:** Approved  
**Last Updated:** December 20, 2025

**Design Reference:** This wireframe follows the Elite Tennis Ladder Design System. For complete specifications, see:
- Design System: [`docs/design/DESIGN_SYSTEM.md`](../DESIGN_SYSTEM.md)
- UI Mockups: [`docs/design/UI_MOCKUPS.md`](../UI_MOCKUPS.md)

---

## Overview

The Login Screen is the entry point for returning users to access the Elite Tennis Ladder application. It provides a simple, secure authentication interface optimized for mobile devices.

---

## Screen Layout

```
┌─────────────────────────────────┐
│         Status Bar              │ ← System status bar
├─────────────────────────────────┤
│                                 │
│          [App Logo]             │ ← 120px × 120px logo
│                                 │
│      Elite Tennis Ladder        │ ← H1, 28px, Bold
│                                 │
│    Welcome back! Please login   │ ← Body, 16px, Regular
│                                 │
├─────────────────────────────────┤
│                                 │
│  ┌───────────────────────────┐  │
│  │ 📧 Email                  │  │ ← Email input, 44px height
│  │ your.email@example.com    │  │
│  └───────────────────────────┘  │
│                                 │
│  ┌───────────────────────────┐  │
│  │ 🔒 Password              │  │ ← Password input, 44px height
│  │ ••••••••••••         👁️  │  │   with visibility toggle
│  └───────────────────────────┘  │
│                                 │
│  ┌─┐ Remember me on this device│ ← Checkbox, 24px × 24px
│  └─┘                           │
│                                 │
│  ┌───────────────────────────┐  │
│  │      LOGIN                │  │ ← Primary button, 48px height
│  └───────────────────────────┘  │
│                                 │
│         Forgot Password?        │ ← Link, 16px
│                                 │
├─────────────────────────────────┤
│                                 │
│      ─────  OR  ─────          │ ← Divider
│                                 │
│  ┌───────────────────────────┐  │
│  │  🍎  Continue with Apple  │  │ ← Secondary button, 48px
│  └───────────────────────────┘  │
│                                 │
│  ┌───────────────────────────┐  │
│  │  🔵  Continue with Google │  │ ← Secondary button, 48px
│  └───────────────────────────┘  │
│                                 │
├─────────────────────────────────┤
│                                 │
│      Don't have an account?     │ ← Body small, 14px
│            Sign Up              │ ← Link, 16px, Bold
│                                 │
└─────────────────────────────────┘
```

**Viewport:** 375px × 812px (iPhone 12/13 standard)

---

## Component Specifications

### 1. App Logo & Branding

**Element:** App Logo  
**Size:** 120px × 120px  
**Position:** Centered, 48px from top  
**Asset:** SVG for scalability  
**Alt Text:** "Elite Tennis Ladder logo"

**Element:** App Title  
**Text:** "Elite Tennis Ladder"  
**Typography:** H1, 28px, Bold, #212121  
**Position:** Below logo, 16px spacing

**Element:** Welcome Message  
**Text:** "Welcome back! Please login"  
**Typography:** Body, 16px, Regular, #757575  
**Position:** Below title, 8px spacing

---

### 2. Email Input Field

**Label:** "Email"  
**Placeholder:** "your.email@example.com"  
**Type:** Email input  
**Size:** Full width (minus 32px padding), 44px height  
**Validation:**
- Required field
- Valid email format
- Trim whitespace
- Case-insensitive

**States:**
- **Default:** Border #BDBDBD, 1px
- **Focus:** Border #2E7D32 (Tennis Green Primary), 2px
- **Error:** Border #F44336, 2px, error message below
- **Success:** Border #4CAF50, 2px

**Error Messages:**
- "Email is required"
- "Please enter a valid email address"

**Accessibility:**
- Label: "Email address"
- Type: "email"
- Autocomplete: "email"
- Keyboard: Email keyboard (mobile)

---

### 3. Password Input Field

**Label:** "Password"  
**Placeholder:** "Enter your password"  
**Type:** Password input (masked)  
**Size:** Full width (minus 32px padding), 44px height

**Features:**
- Show/hide password toggle (eye icon)
- Secure text entry
- No autocomplete for security

**Validation:**
- Required field
- Minimum length check on submit

**States:**
- **Default:** Border #BDBDBD, 1px
- **Focus:** Border #2E7D32 (Tennis Green Primary), 2px
- **Error:** Border #F44336, 2px, error message below

**Error Messages:**
- "Password is required"
- "Invalid email or password" (generic for security)

**Toggle Button:**
- Icon: 24px × 24px
- Position: Right side of input, 12px padding
- Tap target: 48px × 48px
- States: Show password (👁️) / Hide password (👁️‍🗨️)

**Accessibility:**
- Label: "Password"
- Type: "password"
- Toggle button label: "Show password" / "Hide password"

---

### 4. Remember Me Checkbox

**Label:** "Remember me on this device"  
**Element:** Checkbox + Label  
**Size:** Checkbox 24px × 24px, tap target 48px × 48px  
**Position:** Left-aligned, 24px below password field

**States:**
- **Unchecked:** Border #BDBDBD, 2px
- **Checked:** Background #2E7D32 (Tennis Green Primary), white checkmark
- **Focus:** Border #2E7D32 (Tennis Green Primary), 2px outline

**Behavior:**
- Default: Unchecked
- Persists login session for 30 days if checked
- Stores secure token (not password)

**Accessibility:**
- Label: "Remember me on this device"
- Role: "checkbox"
- Keyboard: Space to toggle

---

### 5. Login Button (Primary CTA)

**Label:** "LOGIN"  
**Type:** Primary button  
**Size:** Full width (minus 32px padding), 48px height  
**Position:** 24px below checkbox

**States:**
- **Default:**
  - Background: #2E7D32 (Tennis Green Primary)
  - Text: White, 16px, SemiBold
  - Border radius: 8px
- **Hover/Focus:** Background: #1B5E20 (Tennis Green Primary Dark)
- **Active/Pressed:**
  - Background: #1B5E20 (Tennis Green Primary Dark)
  - Scale: 0.98
  - Duration: 100ms
- **Loading:**
  - Background: #2E7D32 (Tennis Green Primary)
  - Text: "Logging in..."
  - Spinner animation
  - Disabled state
- **Disabled:**
  - Background: #BDBDBD
  - Text: #757575
  - Not interactive

**Behavior:**
1. Validate inputs on tap
2. Show loading state
3. Attempt authentication
4. On success: Navigate to Ladder View
5. On failure: Show error message

**Error Display:**
- Position: Above button
- Text: "Invalid email or password. Please try again."
- Color: #F44336
- Icon: ⚠️
- Dismiss: Auto after 5 seconds or on retry

**Accessibility:**
- Label: "Login button"
- Role: "button"
- States announced: "Loading", "Error"

---

### 6. Forgot Password Link

**Label:** "Forgot Password?"  
**Type:** Text link  
**Size:** 16px, Regular  
**Color:** #2E7D32 (Tennis Green Primary)  
**Position:** Centered, 16px below login button

**Behavior:**
- Tap: Navigate to password reset screen
- Sends password reset email
- Shows confirmation message

**States:**
- **Default:** #2E7D32 (Tennis Green Primary)
- **Active:** #1B5E20 (Tennis Green Primary Dark), underline

**Accessibility:**
- Label: "Forgot password? Tap to reset"
- Role: "link"

---

### 7. Social Login Buttons (Future Phase)

**Divider:** "OR" with horizontal lines  
**Position:** 32px below forgot password link

**Apple Sign In:**
- Label: "Continue with Apple"
- Icon: Apple logo, 20px
- Button: 48px height, secondary style
- Background: #000000
- Text: White

**Google Sign In:**
- Label: "Continue with Google"
- Icon: Google logo, 20px
- Button: 48px height, secondary style
- Background: #FFFFFF
- Text: #757575
- Border: 1px #BDBDBD

**Spacing:** 12px between buttons

**Accessibility:**
- Labels: "Sign in with Apple", "Sign in with Google"
- Alternative: Regular login always available

---

### 8. Sign Up Link

**Text:** "Don't have an account?"  
**Link:** "Sign Up"  
**Position:** Bottom of screen, 24px from bottom  
**Alignment:** Centered

**Typography:**
- Question: Body Small, 14px, #757575
- Link: 16px, SemiBold, #2E7D32 (Tennis Green Primary)

**Behavior:**
- Tap "Sign Up": Navigate to registration screen

**Accessibility:**
- Label: "Don't have an account? Sign up"
- Role: "link"

---

## Interaction Behaviors

### Auto-Focus
- Email field auto-focused on screen load
- Soft keyboard appears automatically (mobile)

### Tab Order
1. Email input
2. Password input
3. Remember me checkbox
4. Login button
5. Forgot password link
6. Apple sign in (if available)
7. Google sign in (if available)
8. Sign up link

### Keyboard Shortcuts (Web/Desktop)
- Enter: Submit login (if form valid)
- Tab: Navigate between fields
- Space: Toggle checkbox/activate button

### Form Validation
- **Client-side:**
  - Email format validation
  - Required field checks
  - Immediate feedback on blur
  
- **Server-side:**
  - Credential verification
  - Rate limiting (max 5 attempts per 15 min)
  - Security checks

### Loading States
1. User taps login button
2. Button shows "Logging in..." + spinner
3. Form fields disabled
4. 200-1000ms network request
5. Success: Navigate to home
6. Failure: Show error, re-enable form

---

## User Flows

### Flow 1: Successful Login
```
1. User opens app → Login screen displayed
2. User enters email → Auto-format, validation on blur
3. User enters password → Masked input
4. User taps "Login" → Validation passes
5. Loading state shown → API request
6. Success → Navigate to Ladder View (with animation)
7. Welcome message shown (toast)
```

**Estimated Time:** 10-20 seconds

---

### Flow 2: Failed Login
```
1. User enters credentials
2. User taps "Login"
3. API returns error
4. Error message displayed above button
5. Fields remain populated (except password)
6. User corrects and retries
```

**Retry Limit:** 5 attempts per 15 minutes  
**Lockout Message:** "Too many attempts. Please try again in 15 minutes."

---

### Flow 3: Forgot Password
```
1. User taps "Forgot Password?"
2. Navigate to reset password screen
3. User enters email
4. System sends reset link
5. Confirmation message shown
6. User checks email → Follows link → Resets password
7. Returns to login screen
```

---

### Flow 4: New User Registration
```
1. User taps "Sign Up"
2. Navigate to registration screen
3. User completes registration
4. Email verification sent
5. User verifies email
6. Auto-login → Navigate to onboarding
```

---

## Responsive Behavior

### Small Mobile (320px - 374px)
- Logo: 100px × 100px
- Buttons: Full width, 44px height (minimum)
- Font sizes: Reduce by 2px
- Padding: 16px sides

### Standard Mobile (375px - 413px)
- Logo: 120px × 120px
- Buttons: Full width, 48px height
- Font sizes: As specified
- Padding: 16px sides

### Large Mobile (414px+)
- Logo: 120px × 120px
- Buttons: Full width, 48px height
- Font sizes: As specified
- Padding: 24px sides

### Tablet (768px+)
- Max width: 400px centered
- Logo: 140px × 140px
- Buttons: Full width of container
- Additional side padding

### Landscape Orientation
- Logo: 80px × 80px (reduced)
- Reduce vertical spacing
- Scroll if needed
- Sticky header/footer

---

## Accessibility Features

### Screen Reader Support

**VoiceOver / TalkBack Announcements:**
- "Login screen. Enter your email and password to continue."
- "Email address, text field, required"
- "Password, secure text field, required"
- "Show password button"
- "Remember me checkbox, unchecked"
- "Login button"
- "Error: Invalid email or password"

### Keyboard Navigation
- Full keyboard support
- Clear focus indicators (2px blue outline)
- Enter to submit
- Escape to clear/cancel

### Visual Accessibility
- High contrast mode support
- 4.5:1 minimum contrast ratio
- No color-only indicators
- Icons with text labels

### Error Handling
- Inline validation messages
- Clear error associations
- Helpful error messages
- Multiple ways to recover

---

## Error States

### Email Errors
- "Email is required" (empty)
- "Please enter a valid email" (format)
- "No account found with this email" (after submit)

### Password Errors
- "Password is required" (empty)
- "Invalid email or password" (wrong credentials)
- "Your account has been locked. Please try again in 15 minutes." (too many attempts)

### Network Errors
- "Unable to connect. Please check your internet connection."
- "Server error. Please try again later."

### General Errors
- Clear, actionable messages
- Error icon (⚠️)
- Red text (#F44336)
- Dismiss options

---

## Security Considerations

### Data Protection
- Password never stored locally
- Encrypted transmission (HTTPS/TLS)
- Secure token storage
- Auto-logout after 30 days

### Brute Force Prevention
- Rate limiting (5 attempts / 15 min)
- Account lockout notification
- CAPTCHA after 3 failed attempts (optional)

### Session Management
- Secure session tokens
- Token expiration
- Remember me: 30 days
- Auto-refresh on app resume

---

## Performance Targets

| Metric | Target | Notes |
|--------|--------|-------|
| Initial Load | < 1 second | First paint |
| Login Response | < 2 seconds | API response time |
| Animation | 60 fps | Smooth transitions |
| Bundle Size | < 500 KB | Login screen assets |

---

## Design Assets Needed

- [ ] App logo (SVG, PNG @1x, @2x, @3x)
- [ ] Email icon
- [ ] Password icon
- [ ] Show/hide password icons
- [ ] Apple logo
- [ ] Google logo
- [ ] Loading spinner animation

---

## Development Notes

### Technical Implementation
- Use form validation library (e.g., Formik, React Hook Form)
- Implement biometric auth (Face ID, Touch ID) for returning users
- Cache user's last email (if remember me checked)
- Use secure storage for tokens (Keychain/Keystore)

### API Endpoints
- `POST /auth/login` - Login with credentials
- `POST /auth/forgot-password` - Request password reset
- `POST /auth/social-login` - Social authentication

### Analytics Events
- `login_screen_view`
- `login_button_tap`
- `login_success`
- `login_failure`
- `forgot_password_tap`
- `signup_link_tap`

---

## Testing Checklist

### Functional Testing
- [ ] Valid login succeeds
- [ ] Invalid email shows error
- [ ] Invalid password shows error
- [ ] Remember me persists session
- [ ] Forgot password navigates correctly
- [ ] Sign up navigates correctly
- [ ] Rate limiting works

### UI Testing
- [ ] All touch targets ≥ 44×44px
- [ ] Proper keyboard types show
- [ ] Password masking works
- [ ] Show/hide password toggle works
- [ ] Loading states display correctly
- [ ] Error messages appear properly

### Accessibility Testing
- [ ] Screen reader navigation works
- [ ] Keyboard navigation works
- [ ] Focus indicators visible
- [ ] Color contrast meets WCAG AA
- [ ] Labels associated with inputs

### Performance Testing
- [ ] Load time < 1 second
- [ ] Smooth animations (60fps)
- [ ] No jank on input
- [ ] Works on slow networks

---

**Wireframe Version:** 1.3  
**Status:** ✅ Approved  
**Ready for:** High-Fidelity Design  
**Last Review:** December 20, 2025
