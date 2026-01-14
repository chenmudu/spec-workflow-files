#!/bin/bash
# check-status.sh - Check current workflow status

set -e

SPEC_DIR=".specs"
STATUS_FILE="$SPEC_DIR/.workflow-confirmations.json"

# Check if initialized
if [[ ! -d "$SPEC_DIR" ]]; then
  echo "❌ Spec workflow not initialized."
  echo "Run: /spec-workflow to initialize"
  exit 0
fi

if [[ ! -f "$STATUS_FILE" ]]; then
  echo "❌ Status file not found: $STATUS_FILE"
  echo "Run: /spec-workflow to initialize"
  exit 0
fi

# Read status
REQ_STATUS=$(jq -r '.requirements // "not_started"' "$STATUS_FILE" 2>/dev/null || echo "not_started")
DESIGN_STATUS=$(jq -r '.design // "not_started"' "$STATUS_FILE" 2>/dev/null || echo "not_started")
TASKS_STATUS=$(jq -r '.tasks // "not_started"' "$STATUS_FILE" 2>/dev/null || echo "not_started")

echo "📊 Spec Workflow Status"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Requirements
echo "📝 Requirements:"
case "$REQ_STATUS" in
  "not_started")
    echo "   Status: ⚪ Not Started"
    echo "   Action: Edit .specs/requirements.md"
    ;;
  "draft")
    echo "   Status: 🟡 Draft"
    echo "   Action: Review and mark as confirmed"
    ;;
  "confirmed")
    echo "   Status: ✅ Confirmed"
    ;;
  *)
    echo "   Status: ❓ Unknown ($REQ_STATUS)"
    ;;
esac
echo ""

# Design
echo "🎨 Design:"
case "$DESIGN_STATUS" in
  "not_started")
    echo "   Status: ⚪ Not Started"
    if [[ "$REQ_STATUS" != "confirmed" ]]; then
      echo "   ⚠️  Blocked: Requirements must be confirmed first"
    else
      echo "   Action: Edit .specs/design.md"
    fi
    ;;
  "draft")
    echo "   Status: 🟡 Draft"
    echo "   Action: Review and mark as confirmed"
    ;;
  "confirmed")
    echo "   Status: ✅ Confirmed"
    ;;
  *)
    echo "   Status: ❓ Unknown ($DESIGN_STATUS)"
    ;;
esac
echo ""

# Tasks
echo "✅ Tasks:"
case "$TASKS_STATUS" in
  "not_started")
    echo "   Status: ⚪ Not Started"
    if [[ "$DESIGN_STATUS" != "confirmed" ]]; then
      echo "   ⚠️  Blocked: Design must be confirmed first"
    else
      echo "   Action: Edit .specs/tasks.md"
    fi
    ;;
  "draft")
    echo "   Status: 🟡 Draft"
    echo "   Action: Review and mark as confirmed"
    ;;
  "confirmed")
    echo "   Status: ✅ Confirmed"
    echo "   Action: Start implementation"
    # Count completed tasks
    if [[ -f "$SPEC_DIR/tasks.md" ]]; then
      TOTAL_TASKS=$(grep -c "^- \[.\] [0-9]" "$SPEC_DIR/tasks.md" 2>/dev/null || echo "0")
      COMPLETED_TASKS=$(grep -c "^- \[x\] [0-9]" "$SPEC_DIR/tasks.md" 2>/dev/null || echo "0")
      if [[ "$TOTAL_TASKS" -gt 0 ]]; then
        echo "   Progress: $COMPLETED_TASKS/$TOTAL_TASKS tasks completed"
      fi
    fi
    ;;
  *)
    echo "   Status: ❓ Unknown ($TASKS_STATUS)"
    ;;
esac
echo ""

# Overall progress
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
CONFIRMED_COUNT=0
[[ "$REQ_STATUS" == "confirmed" ]] && ((CONFIRMED_COUNT++))
[[ "$DESIGN_STATUS" == "confirmed" ]] && ((CONFIRMED_COUNT++))
[[ "$TASKS_STATUS" == "confirmed" ]] && ((CONFIRMED_COUNT++))

echo "📈 Overall Progress: $CONFIRMED_COUNT/3 phases confirmed"

if [[ "$CONFIRMED_COUNT" -eq 3 ]]; then
  echo "🎉 All phases confirmed! Ready for implementation."
fi
