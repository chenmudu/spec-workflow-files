#!/bin/bash
# init-spec.sh - Initialize spec workflow in current project

set -e

SPEC_DIR=".specs"
TEMPLATE_DIR="${CLAUDE_PLUGIN_ROOT}/templates"

echo "🚀 Initializing Spec Workflow..."

# Check if already initialized
if [[ -d "$SPEC_DIR" ]]; then
  echo "⚠️  .specs/ directory already exists."
  read -p "Overwrite existing files? (y/N): " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Initialization cancelled."
    exit 0
  fi
fi

# Create .specs directory
mkdir -p "$SPEC_DIR"
echo "✅ Created .specs/ directory"

# Copy templates
if [[ -f "$TEMPLATE_DIR/requirements.md" ]]; then
  cp "$TEMPLATE_DIR/requirements.md" "$SPEC_DIR/requirements.md"
  echo "✅ Created requirements.md"
else
  echo "❌ Template not found: $TEMPLATE_DIR/requirements.md"
  exit 1
fi

if [[ -f "$TEMPLATE_DIR/design.md" ]]; then
  cp "$TEMPLATE_DIR/design.md" "$SPEC_DIR/design.md"
  echo "✅ Created design.md"
else
  echo "❌ Template not found: $TEMPLATE_DIR/design.md"
  exit 1
fi

if [[ -f "$TEMPLATE_DIR/tasks.md" ]]; then
  cp "$TEMPLATE_DIR/tasks.md" "$SPEC_DIR/tasks.md"
  echo "✅ Created tasks.md"
else
  echo "❌ Template not found: $TEMPLATE_DIR/tasks.md"
  exit 1
fi

if [[ -f "$TEMPLATE_DIR/.workflow-confirmations.json" ]]; then
  cp "$TEMPLATE_DIR/.workflow-confirmations.json" "$SPEC_DIR/.workflow-confirmations.json"
  echo "✅ Created .workflow-confirmations.json"
else
  echo "❌ Template not found: $TEMPLATE_DIR/.workflow-confirmations.json"
  exit 1
fi

echo ""
echo "✨ Spec Workflow initialized successfully!"
echo ""
echo "📋 Next steps:"
echo "  1. Edit .specs/requirements.md - Define what to build"
echo "  2. Mark requirements as confirmed when ready"
echo "  3. Edit .specs/design.md - Define how to build it"
echo "  4. Mark design as confirmed when ready"
echo "  5. Edit .specs/tasks.md - Break down into tasks"
echo "  6. Mark tasks as confirmed and start implementation"
echo ""
echo "📁 Files created in .specs/:"
echo "  - requirements.md"
echo "  - design.md"
echo "  - tasks.md"
echo "  - .workflow-confirmations.json"
