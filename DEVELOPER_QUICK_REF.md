# KatChat Developer Quick Reference

## 🚀 Quick Start

```bash
# Install dependencies
npm install

# Set up environment
cp .env.example .env
# Edit .env with your Supabase URL, JWT_SECRET, etc.

# Start development
npm run dev

# Production
NODE_ENV=production npm start
```

## 📦 Project Structure

```
katchat2_work/
├── frontend/
│   └── public/
│       ├── index.html          # Main HTML file
│       ├── css/
│       │   ├── style.css       # Main stylesheet
│       │   ├── animations.css  # Keyframe animations
│       │   └── mobile.css      # Responsive design
│       └── js/
│           ├── fixes.js        # ⭐ Safety layer
│           ├── error-handler.js # ⭐ Error tracking
│           ├── bindings.js     # ⭐ Function validation
│           ├── validation.js   # ⭐ Input validation
│           ├── api.js          # API client
│           ├── state.js        # Global state
│           ├── socket-client.js # Socket.IO
│           ├── auth.js         # Auth flows
│           ├── chat.js         # Private chat
│           ├── global.js       # Global chat
│           ├── friends.js      # Friend system
│           ├── announcements.js # Posts/comments
│           ├── sage.js         # AI assistant
│           ├── admin.js        # Admin panel
│           ├── settings.js     # User settings
│           ├── ui.js           # UI utilities
│           ├── app.js          # App init
│           └── swipe.js        # Swipe gestures
├── backend/
│   ├── server.js               # Main server
│   ├── error-handler.js        # ⭐ Error middleware
│   ├── supabase.js             # DB client
│   ├── middleware/
│   │   └── auth.js             # Auth middleware
│   ├── routes/
│   │   ├── auth.js             # /api/auth
│   │   ├── users.js            # /api/users
│   │   ├── messages.js         # /api/messages
│   │   ├── announcements.js    # /api/announcements
│   │   ├── roles.js            # /api/roles
│   │   └── ai.js               # /api/ai
│   └── socket/
│       └── index.js            # Socket.IO handlers
├── DEBUGGING_GUIDE.md          # ⭐ Debugging reference
├── PHASE1_COMPLETE.md          # ⭐ Phase 1 summary
└── package.json
```

## 🔧 Key Functions by Module

### fixes.js (Foundation)
```javascript
logError(ctx, err)           // Log error with context
safeAsync(fn, ctx)           // Wrap async function
safeDom(id, fallback)        // Get DOM element safely
sendGlobal()                 // Send message to global chat
sendPrivate()                // Send private message
```

### error-handler.js (Tracking)
```javascript
getErrorLog()                // Get all errors
exportErrorLog()             // Download errors as JSON
trackPerf(label, fn)         // Monitor performance
trackPerfAsync(label, fn)    // Monitor async perf
```

### bindings.js (Validation)
```javascript
validateCriticalFunctions()  // Check 70+ functions
validateDomIds()             // Check 100+ DOM elements
runValidation()              // Complete validation
safeCall(fnName, ...args)    // Safe function call
```

### validation.js (Sanitization)
```javascript
esc(text)                    // HTML escape (XSS prevention)
validateEmail(email)         // Email validation
validatePassword(password)   // Password strength
validateUsername(username)   // Username format
validateMessage(content)     // Message length/format
sanitizeInput(value, opts)   // Format & escape input
```

## 📋 Common Tasks

### Adding a New Feature

1. **Create function with error handling:**
```javascript
async function myNewFeature(data) {
  try {
    // Validate input
    const validation = validateEmail(data.email);
    if (!validation.valid) {
      showToast(validation.error, 'error');
      return;
    }

    // Call API
    const result = await api.myEndpoint(data);
    
    // Update UI
    showToast('Success!', 'success');
    return result;
  } catch (err) {
    logError('myNewFeature', err);
    showToast('Failed to complete action', 'error');
  }
}
```

2. **Add onclick handler:**
```html
<button onclick="myNewFeature({email: 'user@example.com'})">
  Click me
</button>
```

3. **Verify in console:**
```javascript
isFunctionAccessible('myNewFeature')  // Should be true
```

### Adding Validation

```javascript
// In validation.js, add:
window.validateMyField = function(value) {
  if (!value) {
    return { valid: false, error: 'Field required' };
  }
  if (value.length < 3) {
    return { valid: false, error: 'Too short' };
  }
  return { valid: true };
};

// Use in your feature:
const result = validateMyField(userInput);
if (!result.valid) {
  showToast(result.error, 'error');
  return;
}
```

### Debugging an Issue

```javascript
// 1. Check if function exists
isFunctionAccessible('functionName')

// 2. Get recent errors
getErrorLog().slice(-5)

// 3. Find errors for specific context
getErrorLog().filter(e => e.context === 'myFunction')

// 4. Performance check
getErrorLog().filter(e => e.message.includes('Slow'))

// 5. Export for analysis
exportErrorLog()
```

## 🛡️ Security Checklist

- [ ] User input passed through `validateX()` before use
- [ ] User text passed through `esc()` before display
- [ ] URLs passed through `sanitizeUrl()` before use
- [ ] Passwords validated with `validatePassword()`
- [ ] Emails validated with `validateEmail()`
- [ ] File uploads validated with `validateImageFile()`
- [ ] Forms validated before submission
- [ ] Error messages don't expose internals

## 📊 Error Handling Pattern

```javascript
// Good error handling:
async function myFunction() {
  try {
    // Validate inputs
    const check = validateInput(data);
    if (!check.valid) {
      showToast(check.error, 'error');
      return;
    }

    // Perform operation
    const result = await api.call(data);

    // Show success
    showToast('Success!', 'success');
    return result;
  } catch (err) {
    // Log with context
    logError('myFunction', err);
    // Show user-friendly error
    showToast('Operation failed', 'error');
  }
}
```

## 🔍 Testing Checklist

- [ ] Function exists: `isFunctionAccessible('myFunc')`
- [ ] DOM element exists: `document.getElementById('myId')`
- [ ] Socket connected: `socket.connected`
- [ ] User authenticated: `state.user?.id`
- [ ] Input validates: `validateX(input).valid`
- [ ] Error logs: `getErrorLog().length > 0`
- [ ] No console errors: Browser DevTools → Console
- [ ] Performance acceptable: `trackPerf()`

## 📱 Mobile Considerations

- Buttons must be 44px+ for touch targets
- Use safe-area-inset for notch handling
- Test swipe gestures on real device
- Check viewport: `<meta name="viewport" content="width=device-width, initial-scale=1">`
- Use `@media (max-width: 768px)` for mobile styles

## 🚢 Deployment Steps

1. **Environment Setup:**
```bash
# Create .env with:
NODE_ENV=production
JWT_SECRET=your-secret
SUPABASE_URL=your-url
SUPABASE_KEY=your-key
ADMIN_LOG_TOKEN=your-admin-token
```

2. **Build:**
```bash
npm run build  # If needed
```

3. **Start:**
```bash
npm start
```

4. **Verify:**
```bash
curl http://localhost:5000/health
```

5. **Monitor:**
```bash
tail -f backend/logs/errors-*.log
```

## 🎨 CSS Customization

### Color System
```css
--bg: #0a0a0a           /* Main background */
--txt: #e5e5e5          /* Main text */
--accent: #22c55e       /* Primary green */
--danger: #ef4444       /* Red for errors */
--cyan: #06b6d4         /* Cyan accent */
--border: #1a1a1a       /* Border color */
```

### Common Breakpoints
```css
@media (max-width: 768px) {
  /* Mobile styles */
}

@media (max-width: 480px) {
  /* Small mobile styles */
}
```

## 📞 Getting Help

1. **Check error log:** `getErrorLog()`
2. **Run validation:** `runValidation()`
3. **Check console:** DevTools F12 → Console tab
4. **Check backend:** `curl /health`
5. **Review code:** Look at similar feature implementation
6. **Check docs:** `DEBUGGING_GUIDE.md`

---

**Phase 1 Status:** ✅ COMPLETE - All error handling, validation, and debugging tools ready
