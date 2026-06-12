#!/bin/bash

# KatChat Phase 1 Verification Script
# Run this to verify all Phase 1 components are in place

echo "🔍 KatChat Phase 1 Verification"
echo "================================"
echo ""

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Track results
TOTAL=0
PASSED=0
FAILED=0

# Helper function for checks
check_file() {
    local file=$1
    local name=$2
    ((TOTAL++))
    
    if [ -f "$file" ]; then
        echo -e "${GREEN}✅${NC} $name"
        ((PASSED++))
    else
        echo -e "${RED}❌${NC} $name (missing: $file)"
        ((FAILED++))
    fi
}

check_content() {
    local file=$1
    local content=$2
    local name=$3
    ((TOTAL++))
    
    if grep -q "$content" "$file" 2>/dev/null; then
        echo -e "${GREEN}✅${NC} $name"
        ((PASSED++))
    else
        echo -e "${RED}❌${NC} $name (not found in $file)"
        ((FAILED++))
    fi
}

# ===== CHECK FILES =====
echo "📁 Checking Files..."
echo ""

check_file "frontend/public/js/fixes.js" "fixes.js created"
check_file "frontend/public/js/error-handler.js" "error-handler.js created (frontend)"
check_file "frontend/public/js/bindings.js" "bindings.js created"
check_file "frontend/public/js/validation.js" "validation.js created"
check_file "backend/error-handler.js" "error-handler.js updated (backend)"

check_file "DEBUGGING_GUIDE.md" "DEBUGGING_GUIDE.md created"
check_file "PHASE1_COMPLETE.md" "PHASE1_COMPLETE.md created"
check_file "DEVELOPER_QUICK_REF.md" "DEVELOPER_QUICK_REF.md created"
check_file "IMPLEMENTATION_SUMMARY.md" "IMPLEMENTATION_SUMMARY.md created"

echo ""
echo "🔧 Checking Content..."
echo ""

# Check fixes.js
check_content "frontend/public/js/fixes.js" "window.__katchat_fixes_loaded__" "fixes.js initialized properly"
check_content "frontend/public/js/fixes.js" "window.showMentionDropdown" "fixes.js includes global functions"
check_content "frontend/public/js/fixes.js" "window.sendGlobal" "fixes.js includes sendGlobal"

# Check error-handler.js (frontend)
check_content "frontend/public/js/error-handler.js" "window.__errorLog__" "error-handler.js maintains error log"
check_content "frontend/public/js/error-handler.js" "getErrorLog" "error-handler.js exports getErrorLog"
check_content "frontend/public/js/error-handler.js" "exportErrorLog" "error-handler.js exports exportErrorLog"

# Check bindings.js
check_content "frontend/public/js/bindings.js" "validateCriticalFunctions" "bindings.js includes validation"
check_content "frontend/public/js/bindings.js" "runValidation" "bindings.js includes runValidation"

# Check validation.js
check_content "frontend/public/js/validation.js" "window.esc" "validation.js includes XSS prevention"
check_content "frontend/public/js/validation.js" "validateEmail" "validation.js includes email validation"
check_content "frontend/public/js/validation.js" "validatePassword" "validation.js includes password validation"

# Check auth.js updates
check_content "frontend/public/js/auth.js" "validateLoginForm" "auth.js uses new validation"
check_content "frontend/public/js/auth.js" "clearValidationErrors" "auth.js clears validation errors"

# Check server.js updates
check_content "backend/server.js" "errorHandler" "server.js imports error handler"
check_content "backend/server.js" "requestLogger" "server.js uses request logger"
check_content "backend/server.js" "checkRateLimit" "server.js uses rate limiting"
check_content "backend/server.js" "/health" "server.js has health endpoint"

# Check HTML script order
check_content "frontend/public/index.html" 'src="js/fixes.js"' "index.html includes fixes.js"
check_content "frontend/public/index.html" 'src="js/error-handler.js"' "index.html includes error-handler.js"
check_content "frontend/public/index.html" 'src="js/bindings.js"' "index.html includes bindings.js"
check_content "frontend/public/index.html" 'src="js/validation.js"' "index.html includes validation.js"

echo ""
echo "================================"
echo "Results: ${GREEN}$PASSED passed${NC}, ${RED}$FAILED failed${NC}, $TOTAL total"
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✅ All Phase 1 components verified!${NC}"
    echo ""
    echo "🚀 Ready to test:"
    echo "   1. Start backend: npm start"
    echo "   2. Open browser: http://localhost:5000"
    echo "   3. Open console: F12"
    echo "   4. Run: runValidation()"
    exit 0
else
    echo -e "${RED}❌ Some components are missing or incorrect${NC}"
    echo ""
    echo "⚠️  Please check the failures above"
    exit 1
fi
