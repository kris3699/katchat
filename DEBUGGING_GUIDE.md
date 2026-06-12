# KatChat Debugging & Production Guide

## 🔧 System Overview

KatChat now includes comprehensive error handling, logging, and debugging tools across both frontend and backend.

## ✅ Improvements Made

### Frontend Enhancements

1. **fixes.js** - Global function safety layer
   - Provides fallback implementations for critical functions
   - Initializes global state variables
   - Logs all undefined function calls

2. **error-handler.js** - Comprehensive error tracking
   - Centralized error logger with history
   - Wraps all critical async functions
   - Catches unhandled promise rejections
   - Performance monitoring for slow operations
   - Validation helpers for data integrity
   - Safe DOM manipulation utilities

3. **Updated index.html**
   - Loads scripts in correct order (fixes → error-handler → app)
   - Prevents duplicate initialization
   - Includes all 12+ feature modules

### Backend Enhancements

1. **error-handler.js middleware**
   - Centralized error handling
   - Request logging with performance metrics
   - Rate limiting protection
   - Safe Supabase query wrapper
   - Token verification with detailed error codes
   - Validation helpers for input sanitization
   - Error persistence to disk (daily logs)

2. **server.js updates**
   - Integrated error handler middleware
   - Request logging middleware
   - Rate limiting middleware (100 req/min)
   - Health check endpoint (`/health`)
   - Error logs endpoint (`/api/logs`)
   - Graceful shutdown handling
   - Error logger exported for route modules

## 🐛 Debugging

### Frontend Console Commands

```javascript
// Get all logged errors
getErrorLog()

// Export errors as JSON for bug reports
exportErrorLog()

// Get current application state
console.log(state)

// Get all socket events log
console.log(window.__socketLog__)

// Track performance of an operation
trackPerf('operation-name', () => myFunction())

// Track async operation performance
await trackPerfAsync('async-operation', () => myPromise())

// Validate user object
validateUser(state.user)

// Validate message structure
validateMessage(lastMessage)

// Get socket connection status
console.log(socket.connected)

// Check error logs
getErrorLog()
```

### Backend Error Logs

Error logs are stored in `backend/logs/` directory:
- Files named: `errors-YYYY-MM-DD.log`
- Each line is a JSON object
- Access via admin endpoint: `GET /api/logs?token=ADMIN_LOG_TOKEN`

### Key Error Codes

#### Frontend
- `RATE_LIMITED` - User exceeded request limit
- `AUTH_FAILED` - Authentication failed
- `NETWORK_ERROR` - Fetch/network issue
- `TIMEOUT` - Request timed out
- `VALIDATION_ERROR` - Input validation failed
- `NOT_FOUND` - Resource not found

#### Backend
- `INVALID_EMAIL` - Email format invalid
- `WEAK_PASSWORD` - Password too weak
- `INVALID_USERNAME` - Username format invalid
- `TOKEN_EXPIRED` - JWT token expired
- `INVALID_TOKEN` - JWT token invalid/malformed
- `DB_ERROR` - Database operation failed
- `NOT_FOUND` - Resource not found in database
- `UNAUTHORIZED` - User not authenticated
- `FORBIDDEN` - User lacks permissions

## 📊 Health Check

```bash
curl http://localhost:5000/health
```

Response:
```json
{
  "status": "ok",
  "timestamp": "2025-02-06T10:30:45.123Z"
}
```

## 🔐 Accessing Error Logs

Admin endpoint requires `ADMIN_LOG_TOKEN` environment variable:

```bash
# .env file
ADMIN_LOG_TOKEN=your-secret-token-here
```

```javascript
// Fetch logs via API
fetch('/api/logs?token=your-secret-token-here')
  .then(r => r.json())
  .then(logs => console.table(logs))
```

## 📈 Performance Monitoring

### Slow Operation Warnings

Operations taking >1 second on frontend or >2 seconds on backend will log warnings:

```
⚠️ Slow operation: loadMessages took 1234ms
```

### Request Timing

All requests logged with timing:
```
[INFO] POST /api/messages → 200 (145ms)
[WARN] GET /api/users → 500 (2341ms)
```

## 🛡️ Error Recovery

### Automatic Error Recovery

1. **Network Failures** - Wrapped with retry logic in socket-client
2. **Missing DOM Elements** - Safe DOM utilities provide fallbacks
3. **Invalid Tokens** - Auto-redirect to login on auth errors
4. **Rate Limits** - Queue requests and retry after cooldown
5. **Database Errors** - User-friendly error messages with retry

### Manual Recovery

```javascript
// Clear error log
window.__errorLog__ = []

// Reset socket connection
socket.disconnect()
socket.connect()

// Force re-authentication
doLogout()

// Clear local storage
localStorage.clear()
```

## 🔍 Common Issues & Solutions

### Issue: "Function not found" errors

**Cause**: Script load order problem
**Solution**: Check browser console for script order, verify all scripts in index.html defer attribute

```javascript
// Verify functions exist
console.log(typeof sendGlobal) // should be 'function'
console.log(typeof socket) // should be 'object'
console.log(typeof state) // should be 'object'
```

### Issue: Socket disconnects frequently

**Cause**: Network instability or server errors
**Solution**: Check console for socket errors, verify server health

```javascript
// Monitor socket events
socket.on('connect', () => console.log('🔌 Connected'))
socket.on('disconnect', (reason) => console.log('❌ Disconnected:', reason))
socket.on('connect_error', (err) => console.error('Connection error:', err))
```

### Issue: Messages not sending

**Cause**: Validation errors, auth failures, or socket issues
**Solution**: Check console for validation errors, verify authentication

```javascript
// Validate before sending
const msg = { content: 'test' }
validateMessage(msg) // returns { valid: true/false, error?: string }
```

### Issue: Avatar images not loading

**Cause**: CORS issues, invalid URLs, or missing files
**Solution**: Check browser Network tab, verify image URLs in profile_picture field

```javascript
// Test avatar loading
fetch(user.profile_picture).then(r => console.log('Avatar OK'))
```

### Issue: Slow performance

**Cause**: Too many re-renders, large message lists, or slow API
**Solution**: Monitor performance timing, check error log for slow operations

```javascript
// Find slow operations
getErrorLog().filter(e => e.message.includes('Slow'))
```

## 🚀 Deployment Checklist

- [ ] Set `NODE_ENV=production` in backend
- [ ] Set `ADMIN_LOG_TOKEN` in backend .env
- [ ] Enable HTTPS/TLS in production
- [ ] Set up log rotation for daily logs
- [ ] Monitor `/health` endpoint for uptime
- [ ] Configure CORS properly for production domain
- [ ] Set up error monitoring service (optional)
- [ ] Configure backup for Supabase database
- [ ] Test error scenarios thoroughly
- [ ] Monitor error logs regularly

## 📝 Logging Best Practices

### When Adding New Features

```javascript
// Wrap async operations
const result = await trackPerfAsync('myFeature', async () => {
  try {
    return await api.myEndpoint()
  } catch (err) {
    logError('myFeature', err)
    showToast('Failed to load feature', 'error')
  }
})

// Validate inputs
validateRequired(obj, ['id', 'name'], 'myFeature')

// Log important events
console.log('[myFeature] User action triggered', { userId: state.user.id })
```

### When Debugging Production Issues

1. Export error log: `exportErrorLog()`
2. Check performance: `getErrorLog().filter(e => e.message.includes('Slow'))`
3. Find user errors: `getErrorLog().filter(e => e.userId === userId)`
4. Export socket logs: `console.save(window.__socketLog__, 'socket-log.json')`

## 🔗 Additional Resources

- **Frontend Errors**: Browser DevTools → Console tab
- **Backend Errors**: `backend/logs/errors-*.log` files
- **Socket Logs**: Browser DevTools → Network tab (WS)
- **Performance**: Browser DevTools → Performance tab

## ⚠️ Important Notes

- **Never expose error.stack in production** (already handled)
- **Rate limiting prevents abuse** (100 req/min per IP)
- **Error logs grow over time** (max 200 in-memory, disk archived daily)
- **Socket events are not logged by default** (add logging to socket/index.js if needed)
- **Validation happens on both frontend and backend** (defense in depth)

## 🎯 Support

For debugging help:

1. Check browser console for errors
2. Export error log via `exportErrorLog()`
3. Check server health: `curl /health`
4. Access error logs: `/api/logs?token=ADMIN_LOG_TOKEN`
5. Check daily logs: `cat backend/logs/errors-YYYY-MM-DD.log | tail -20`
