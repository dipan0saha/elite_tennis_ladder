# Manual Testing Guide - User Profile Feature

## Prerequisites

1. Flutter SDK installed and configured
2. Supabase project set up with credentials in `.env`
3. Database migrations applied (including `20250101001200_create_avatars_storage.sql`)
4. Test user account created in Supabase

## Setup

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Configure Environment
Ensure `.env` file contains:
```
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_anon_key
```

### 3. Apply Database Migrations
Run all migrations in the `supabase/migrations` folder, including:
- `20250101000100_create_profiles_table.sql` (existing)
- `20250101001200_create_avatars_storage.sql` (new)

### 4. Verify Storage Bucket
In Supabase Dashboard:
1. Go to Storage
2. Verify `avatars` bucket exists
3. Check it's set to Public
4. Verify RLS policies are applied

## Test Scenarios

### Test 1: Profile Screen Access
**Steps:**
1. Launch the app
2. Sign in with test credentials
3. Look for profile icon in AppBar (person icon)
4. Tap profile icon

**Expected Result:**
- Profile screen opens
- Loading indicator shows briefly
- Profile form displays with user data
- Avatar shows default person icon (if no avatar set)

**Pass Criteria:**
✅ Screen loads without errors
✅ Loading indicator appears and disappears
✅ Form fields populate with existing data

---

### Test 2: View Profile Information
**Steps:**
1. Navigate to profile screen
2. Observe all fields

**Expected Result:**
- Full Name: Populated or empty
- Username: Populated and disabled (grey)
- Email: Populated and disabled (grey)
- Phone: Populated or empty
- Bio: Populated or empty
- Skill Level: Shows current value or blank

**Pass Criteria:**
✅ All fields display correctly
✅ Username and email are read-only
✅ Other fields are editable

---

### Test 3: Edit Full Name
**Steps:**
1. Clear full name field
2. Try to save (click save button)
3. Observe validation error
4. Enter valid name
5. Save profile

**Expected Result:**
- Error shows when field is empty
- Success message shows after valid save
- Name persists after save

**Pass Criteria:**
✅ Validation works (required field)
✅ Save succeeds with valid input
✅ Success snackbar appears
✅ Data persists in database

---

### Test 4: Update Bio
**Steps:**
1. Clear bio field
2. Enter new bio text (< 500 characters)
3. Save profile
4. Navigate away and back to profile

**Expected Result:**
- Character counter shows (e.g., "125/500")
- Save succeeds
- Bio persists after navigation

**Pass Criteria:**
✅ Character counter works
✅ Bio saves successfully
✅ Bio displays after reload

---

### Test 5: Set Skill Level
**Steps:**
1. Tap skill level dropdown
2. Select "Beginner"
3. Save profile
4. Reload profile screen
5. Verify skill level persists

**Repeat for:**
- Intermediate
- Advanced
- Expert

**Expected Result:**
- Dropdown shows all 4 options
- Selection persists after save
- Displays correctly after reload

**Pass Criteria:**
✅ All skill levels available
✅ Selection saves correctly
✅ Displays with proper capitalization

---

### Test 6: Upload Avatar
**Steps:**
1. Tap on avatar (circular area)
2. Image picker opens
3. Select an image from gallery
4. Observe preview
5. Save profile
6. Wait for upload to complete
7. Verify avatar displays

**Expected Result:**
- Image picker opens on tap
- Selected image previews immediately
- Camera icon overlay remains visible
- Save button shows loading spinner
- Success message after upload
- Avatar displays from Supabase URL

**Pass Criteria:**
✅ Image picker works
✅ Preview shows immediately
✅ Upload succeeds
✅ Avatar displays correctly
✅ Image accessible via public URL

---

### Test 7: Replace Avatar
**Steps:**
1. With existing avatar, tap avatar area
2. Select different image
3. Save profile
4. Verify new avatar displays

**Expected Result:**
- New image replaces old one
- Old image overwritten in storage
- New avatar URL in database

**Pass Criteria:**
✅ Avatar updates successfully
✅ New image displays
✅ Storage shows updated file

---

### Test 8: Clear Optional Fields
**Steps:**
1. Set phone number and bio
2. Save profile
3. Clear phone number (delete all text)
4. Clear bio (delete all text)
5. Save profile
6. Reload profile screen

**Expected Result:**
- Empty fields save as NULL in database
- Fields remain empty after reload

**Pass Criteria:**
✅ Empty strings convert to NULL
✅ Fields can be cleared
✅ Cleared state persists

---

### Test 9: Phone Number Format
**Steps:**
1. Enter various phone formats:
   - "1234567890"
   - "+1 (123) 456-7890"
   - "+44 20 1234 5678"
2. Save each one

**Expected Result:**
- All formats accepted (no validation)
- Formats preserved as entered

**Pass Criteria:**
✅ No format restrictions
✅ Text saved as-is

---

### Test 10: Bio Character Limit
**Steps:**
1. Enter text longer than 500 characters
2. Observe counter turn red
3. Try to save

**Expected Result:**
- Counter shows "XXX/500" in red
- Can't type beyond 500 characters
- Form prevents excessive input

**Pass Criteria:**
✅ Counter shows character count
✅ Limited to 500 characters
✅ Visual feedback when at limit

---

### Test 11: Navigation and State
**Steps:**
1. Make changes to profile (don't save)
2. Navigate back to home screen
3. Return to profile screen

**Expected Result:**
- Unsaved changes are lost
- Profile reloads from database

**Pass Criteria:**
✅ Changes don't persist without save
✅ Fresh data loaded on return

---

### Test 12: Error Handling
**Steps:**
1. Disconnect from internet
2. Try to save profile
3. Observe error message
4. Reconnect internet
5. Try again

**Expected Result:**
- Error snackbar shows with message
- Save button re-enables
- Retry succeeds when connected

**Pass Criteria:**
✅ Error message displays
✅ UI handles error gracefully
✅ Retry works after error

---

### Test 13: Loading States
**Steps:**
1. Observe initial load
2. Make changes and save
3. Observe save button

**Expected Result:**
- Circular progress during load
- Save button shows spinner during save
- Both are disabled during operation

**Pass Criteria:**
✅ Loading indicators display
✅ Buttons disabled during operations
✅ UI responsive after completion

---

### Test 14: Large Image Upload
**Steps:**
1. Select very large image (> 5MB)
2. Observe optimization
3. Save profile
4. Verify upload succeeds

**Expected Result:**
- Image resized to 1024x1024
- Quality reduced to 85%
- Upload completes successfully
- Reasonable file size

**Pass Criteria:**
✅ Large images handled
✅ Optimization works
✅ Upload successful

---

### Test 15: Security - Access Control
**Steps:**
1. Log in as User A
2. Note User A's profile data
3. Log out
4. Log in as User B
5. Access profile screen

**Expected Result:**
- User B sees own profile only
- User B cannot edit User A's profile
- RLS policies enforce access control

**Pass Criteria:**
✅ Users see own profiles only
✅ Cannot access other user data
✅ Updates affect own profile only

---

### Test 16: Storage URL Validation
**Steps:**
1. Upload avatar
2. Copy avatar URL from database
3. Paste URL in browser

**Expected Result:**
- Image loads in browser
- No authentication required
- Public access works

**Pass Criteria:**
✅ URLs are publicly accessible
✅ Images load without auth
✅ Correct image displays

---

### Test 17: AppBar Save Button
**Steps:**
1. Make changes to profile
2. Use AppBar save icon (top right)
3. Verify save works

**Expected Result:**
- Same behavior as bottom save button
- Changes persist

**Pass Criteria:**
✅ AppBar save button works
✅ Same functionality as bottom button

---

### Test 18: Form Validation
**Steps:**
1. Clear full name
2. Try to save
3. Observe error
4. Enter full name
5. Try to save with other empty fields

**Expected Result:**
- Error only for required fields
- Optional fields can be empty
- Save succeeds with valid required fields

**Pass Criteria:**
✅ Required field validation works
✅ Optional fields not required
✅ Clear error messages

---

### Test 19: Theme Support
**Steps:**
1. Test in light mode
2. Switch to dark mode (system settings)
3. Observe all UI elements

**Expected Result:**
- All elements visible in both modes
- Proper contrast
- Icons and text readable
- Colors follow theme

**Pass Criteria:**
✅ Light mode displays correctly
✅ Dark mode displays correctly
✅ Good contrast in both modes

---

### Test 20: Responsive Layout
**Steps:**
1. Test on different screen sizes:
   - Phone (small)
   - Phone (large)
   - Tablet
2. Rotate device (portrait/landscape)

**Expected Result:**
- Layout adjusts to screen size
- No overflow errors
- All elements accessible
- Scrolling works

**Pass Criteria:**
✅ Works on various screen sizes
✅ Portrait and landscape both work
✅ No layout issues

---

## Database Verification

After completing tests, verify in Supabase Dashboard:

### Profiles Table
```sql
SELECT * FROM profiles WHERE id = '<test_user_id>';
```

Check:
- ✅ full_name updated
- ✅ phone set/cleared correctly
- ✅ bio set/cleared correctly
- ✅ skill_level set correctly
- ✅ avatar_url points to storage
- ✅ updated_at timestamp changed

### Storage Bucket
1. Navigate to Storage > avatars
2. Check folder `<test_user_id>/`
3. Verify image file exists
4. Click to preview image
5. Copy public URL and test in browser

## Known Limitations

1. **No Image Cropping**: Users can't crop images before upload
2. **No Camera Support**: Only gallery picker implemented
3. **Single Avatar**: Only one avatar per user
4. **No Progress Bar**: Upload shows spinner but no percentage
5. **No Image Rotation**: EXIF orientation not handled

## Troubleshooting

### Issue: Profile doesn't load
**Solution:** Check Supabase connection and RLS policies

### Issue: Avatar upload fails
**Solution:** 
- Verify storage bucket exists
- Check RLS policies on storage.objects
- Ensure bucket is public

### Issue: Changes don't save
**Solution:**
- Check network connection
- Verify user is authenticated
- Check RLS policies on profiles table

### Issue: Image not displaying
**Solution:**
- Verify public URL is correct
- Check bucket is public
- Test URL in browser directly

## Success Criteria

All 20 test scenarios should pass for the feature to be considered complete and ready for production.

Mark: ✅ Pass | ❌ Fail | ⚠️ Partial

## Reporting Issues

When reporting issues, include:
1. Test scenario number
2. Expected vs actual result
3. Screenshots if applicable
4. Device/browser information
5. Error messages from console
