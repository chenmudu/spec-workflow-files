#!/bin/bash
# complete-task.sh - Mark a task as complete and show next task

set -e

SPEC_DIR=".specs"
TASKS_FILE="$SPEC_DIR/tasks.md"

# Check arguments
if [[ -z "$1" ]]; then
  echo "Usage: complete-task.sh <task_number>"
  echo "Example: complete-task.sh 1"
  echo "Example: complete-task.sh 5"
  exit 1
fi

TASK_NUM="$1"

# Check if tasks file exists
if [[ ! -f "$TASKS_FILE" ]]; then
  echo "❌ Tasks file not found: $TASKS_FILE"
  echo "Run: /spec-workflow to initialize"
  exit 1
fi

# Find and mark task as complete
# Pattern: - [ ] 1. or - [ ] 1.1 or - [ ] 1.1.1
if grep -q "^- \[ \] ${TASK_NUM}\." "$TASKS_FILE"; then
  # Use sed to replace - [ ] with - [x] for the specific task
  sed -i "s/^- \[ \] ${TASK_NUM}\./- [x] ${TASK_NUM}./" "$TASKS_FILE"
  echo "✅ Task $TASK_NUM marked as complete"
else
  # Check if already completed
  if grep -q "^- \[x\] ${TASK_NUM}\." "$TASKS_FILE"; then
    echo "ℹ️  Task $TASK_NUM is already marked as complete"
  else
    echo "❌ Task $TASK_NUM not found in $TASKS_FILE"
    exit 1
  fi
fi

echo ""

# Show next incomplete task
NEXT_TASK=$(grep -m 1 "^- \[ \] [0-9]" "$TASKS_FILE" 2>/dev/null || true)

if [[ -n "$NEXT_TASK" ]]; then
  echo "📋 Next task:"
  echo "$NEXT_TASK"

  # Try to show the goal line (next line after task)
  TASK_LINE=$(grep -n "^- \[ \] [0-9]" "$TASKS_FILE" | head -1 | cut -d: -f1)
  if [[ -n "$TASK_LINE" ]]; then
    GOAL_LINE=$((TASK_LINE + 1))
    GOAL=$(sed -n "${GOAL_LINE}p" "$TASKS_FILE" | grep "Goal:" || true)
    if [[ -n "$GOAL" ]]; then
      echo "    $GOAL"
    fi
  fi
else
  echo "🎉 All tasks complete!"

  # Show summary
  TOTAL_TASKS=$(grep -c "^- \[.\] [0-9]" "$TASKS_FILE" 2>/dev/null || echo "0")
  COMPLETED_TASKS=$(grep -c "^- \[x\] [0-9]" "$TASKS_FILE" 2>/dev/null || echo "0")

  echo ""
  echo "📊 Summary:"
  echo "   Total tasks: $TOTAL_TASKS"
  echo "   Completed: $COMPLETED_TASKS"
  echo ""
  echo "✨ Great work! All implementation tasks are done."
fi
