---
name: spec-workflow-files
version: "1.0.0"
description: File-based spec workflow for systematic feature development. Creates requirements.md, design.md, and tasks.md in .specs/ directory with hooks for workflow enforcement. Use when starting new features or projects that need structured planning.
user-invocable: true
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Glob
  - Grep
hooks:
  SessionStart:
    - hooks:
        - type: command
          command: "echo '[spec-workflow] Ready. Use /spec-workflow to initialize spec workflow in your project.'"

  PreToolUse:
    # Warn if editing design.md before requirements are confirmed
    - matcher: "Write|Edit"
      hooks:
        - type: command
          command: |
            if [[ "$TOOL_INPUT" == *"design.md"* ]] && [[ -f .specs/.workflow-confirmations.json ]]; then
              jq -e '.requirements == "confirmed"' .specs/.workflow-confirmations.json >/dev/null 2>&1 || \
                echo "[spec-workflow] ⚠️  Requirements not confirmed yet. Consider confirming requirements before starting design."
            fi

    # Warn if editing tasks.md before design is confirmed
    - matcher: "Write|Edit"
      hooks:
        - type: command
          command: |
            if [[ "$TOOL_INPUT" == *"tasks.md"* ]] && [[ -f .specs/.workflow-confirmations.json ]]; then
              jq -e '.design == "confirmed"' .specs/.workflow-confirmations.json >/dev/null 2>&1 || \
                echo "[spec-workflow] ⚠️  Design not confirmed yet. Consider confirming design before creating tasks."
            fi

  PostToolUse:
    # Remind to confirm after editing requirements
    - matcher: "Write|Edit"
      hooks:
        - type: command
          command: |
            if [[ "$TOOL_INPUT" == *"requirements.md"* ]]; then
              echo "[spec-workflow] ✅ Requirements updated. Review and mark as confirmed when ready."
            fi

    # Remind to confirm after editing design
    - matcher: "Write|Edit"
      hooks:
        - type: command
          command: |
            if [[ "$TOOL_INPUT" == *"design.md"* ]]; then
              echo "[spec-workflow] ✅ Design updated. Review and mark as confirmed when ready."
            fi

    # Remind to confirm after editing tasks
    - matcher: "Write|Edit"
      hooks:
        - type: command
          command: |
            if [[ "$TOOL_INPUT" == *"tasks.md"* ]]; then
              echo "[spec-workflow] ✅ Tasks updated. Review and mark as confirmed when ready to start implementation."
            fi

  Stop:
    # Check workflow status and suggest planning-with-files integration
    - hooks:
        - type: command
          command: |
            # Show workflow status
            ${CLAUDE_PLUGIN_ROOT}/scripts/check-status.sh 2>/dev/null || true

            # Check if all phases are confirmed
            if [[ -f .specs/.workflow-confirmations.json ]]; then
              if jq -e '.requirements == "confirmed" and .design == "confirmed" and .tasks == "confirmed"' .specs/.workflow-confirmations.json >/dev/null 2>&1; then
                # Check if planning-with-files is not yet initialized
                if [[ ! -f task_plan.md ]] && [[ ! -f findings.md ]] && [[ ! -f progress.md ]]; then
                  echo ""
                  echo "💡 [spec-workflow] All phases confirmed! Consider using planning-with-files for execution:"
                  echo "   • task_plan.md - Track implementation progress"
                  echo "   • findings.md - Record discoveries and decisions"
                  echo "   • progress.md - Log session activities"
                  echo ""
                  echo "   Your .specs/ files provide the perfect planning foundation!"
                fi
              fi
            fi
---

# Spec Workflow Files

File-based workflow for systematic feature development using the three-phase spec process: **Requirements → Design → Tasks**.

## Core Philosophy

**Problem:** AI coding often jumps straight to implementation without proper planning, leading to:
- Unclear requirements
- Poor architectural decisions
- Missing edge cases
- Difficult maintenance

**Solution:** Enforce a structured workflow with persistent files and hooks:
1. **Requirements Phase** - Define WHAT to build
2. **Design Phase** - Define HOW to build it
3. **Tasks Phase** - Break down into actionable steps

## Quick Start

### Initialize Workflow

```bash
/spec-workflow
```

This creates `.specs/` directory with:
- `requirements.md` - Requirements document (EARS format)
- `design.md` - Technical design document
- `tasks.md` - Implementation task breakdown
- `.workflow-confirmations.json` - Phase status tracking

### Workflow Phases

#### Phase 1: Requirements

1. **Edit** `.specs/requirements.md`
   - Define user stories
   - Write acceptance criteria using EARS format
   - Identify constraints and dependencies

2. **Confirm** when ready:
   ```bash
   # Update status manually or via script
   jq '.requirements = "confirmed"' .specs/.workflow-confirmations.json > tmp.json && mv tmp.json .specs/.workflow-confirmations.json
   ```

#### Phase 2: Design

1. **Edit** `.specs/design.md`
   - Define architecture
   - Specify data models
   - Plan API endpoints
   - Document technical decisions

2. **Confirm** when ready:
   ```bash
   jq '.design = "confirmed"' .specs/.workflow-confirmations.json > tmp.json && mv tmp.json .specs/.workflow-confirmations.json
   ```

#### Phase 3: Tasks

1. **Edit** `.specs/tasks.md`
   - Break design into concrete tasks
   - Define dependencies
   - Estimate effort

2. **Confirm** when ready:
   ```bash
   jq '.tasks = "confirmed"' .specs/.workflow-confirmations.json > tmp.json && mv tmp.json .specs/.workflow-confirmations.json
   ```

3. **Track progress** as you implement:
   ```bash
   ${CLAUDE_PLUGIN_ROOT}/scripts/complete-task.sh 1
   ${CLAUDE_PLUGIN_ROOT}/scripts/complete-task.sh 2
   ```

## File Structure

```
your-project/
├── .specs/                          # Spec workflow directory
│   ├── requirements.md              # Phase 1: What to build
│   ├── design.md                    # Phase 2: How to build
│   ├── tasks.md                     # Phase 3: Task breakdown
│   └── .workflow-confirmations.json # Phase status
├── src/                             # Your code
└── ...
```

## EARS Format (Requirements)

**Easy Approach to Requirements Syntax** - Clear, testable requirements:

```markdown
WHEN [trigger event] THEN system SHALL [required response]
IF [precondition] THEN system SHALL [required response]
WHEN [event] AND [condition] THEN system SHALL [response]
```

**Example:**
```markdown
WHEN user submits valid login credentials THEN system SHALL authenticate user
IF user is not authenticated THEN system SHALL redirect to login page
WHEN user clicks logout AND session is active THEN system SHALL end session
```

## Hooks Behavior

### PreToolUse Hooks

**Before editing design.md:**
- ⚠️ Warns if requirements not confirmed
- Encourages proper phase sequencing

**Before editing tasks.md:**
- ⚠️ Warns if design not confirmed
- Prevents premature task breakdown

### PostToolUse Hooks

**After editing any spec file:**
- ✅ Reminds to review and confirm
- Guides next steps

### Stop Hook

**Before Claude stops:**
- 📊 Shows workflow status
- Displays progress summary
- Highlights next actions

## Commands & Scripts

### Check Status

```bash
${CLAUDE_PLUGIN_ROOT}/scripts/check-status.sh
```

Shows:
- Current phase status
- Blocked phases
- Next actions
- Task completion progress

### Complete Task

```bash
${CLAUDE_PLUGIN_ROOT}/scripts/complete-task.sh <task_number>
```

- Marks task as complete (- [ ] → - [x])
- Shows next incomplete task
- Displays progress summary

### Re-initialize

```bash
${CLAUDE_PLUGIN_ROOT}/scripts/init-spec.sh
```

- Prompts before overwriting
- Resets all files to templates

## When to Use

**✅ Use for:**
- New feature development
- Complex system changes
- Projects requiring documentation
- Team collaboration
- AI-assisted development

**❌ Skip for:**
- Simple bug fixes
- Trivial changes
- Experimental prototypes
- Time-critical hotfixes

## Integration with Planning-with-Files (Optional)

This plugin works great standalone, but can be combined with planning-with-files for complete workflow coverage.

### How They Work Together

**Spec Workflow Files** (Planning phase):
- ✅ Structured planning: requirements → design → tasks
- ✅ Enforces proper sequencing with hooks
- ✅ Files in `.specs/` directory (clean separation)

**Planning-with-Files** (Execution phase):
- ✅ Execution tracking: task_plan → findings → progress
- ✅ Context management across sessions
- ✅ Files in project root

### Combined Workflow

```
1. Planning Phase (Spec Workflow)
   ├── requirements.md  → Define WHAT to build
   ├── design.md        → Define HOW to build
   └── tasks.md         → Break down into tasks

2. Execution Phase (Planning-with-Files)
   ├── task_plan.md     → Track current work
   ├── findings.md      → Record discoveries
   └── progress.md      → Log session history
```

### File Structure

```
your-project/
├── .specs/              # Spec Workflow (planning)
│   ├── requirements.md  # WHAT to build
│   ├── design.md        # HOW to build
│   ├── tasks.md         # Task breakdown
│   └── .workflow-confirmations.json
├── task_plan.md         # Planning-with-Files (execution)
├── findings.md          # Research & decisions
├── progress.md          # Session log
└── src/                 # Your code
```

### When to Use Each

**Use Spec Workflow alone:**
- Need structured planning
- Team collaboration requires docs
- Don't need detailed execution tracking

**Use Planning-with-Files alone:**
- Requirements already clear
- Quick prototyping
- Need context management only

**Use both together (recommended for complex projects):**
- New feature development
- Complex system changes
- AI-assisted development
- Team collaboration

### Auto-Detection

After completing all spec phases, this plugin will suggest using planning-with-files if it detects it's not yet initialized. This is optional - you can track progress manually too.

## Best Practices

### 1. Complete Each Phase

Don't skip ahead. Each phase builds on the previous:
- Requirements inform design
- Design informs tasks
- Tasks guide implementation

### 2. Confirm Before Proceeding

Mark phases as confirmed only when:
- Content is complete
- Reviewed for quality
- Ready for next phase

### 3. Keep Files Updated

Update specs when:
- Requirements change
- Design evolves
- New insights emerge

### 4. Use EARS Format

Write testable requirements:
- Clear trigger conditions
- Specific system responses
- Measurable outcomes

### 5. Document Decisions

In design.md, record:
- Why you chose an approach
- What alternatives you considered
- Trade-offs you accepted

## Templates

All templates are in `${CLAUDE_PLUGIN_ROOT}/templates/`:

- **requirements.md** - EARS format, user stories, acceptance criteria
- **design.md** - Architecture, data models, API design, decisions
- **tasks.md** - Numbered tasks with goals, details, dependencies

## Troubleshooting

### "Requirements not confirmed" warning

**Cause:** Trying to edit design before confirming requirements

**Solution:**
1. Review requirements.md
2. Confirm: `jq '.requirements = "confirmed"' .specs/.workflow-confirmations.json > tmp.json && mv tmp.json .specs/.workflow-confirmations.json`

### "Design not confirmed" warning

**Cause:** Trying to edit tasks before confirming design

**Solution:**
1. Review design.md
2. Confirm: `jq '.design = "confirmed"' .specs/.workflow-confirmations.json > tmp.json && mv tmp.json .specs/.workflow-confirmations.json`

### Scripts not found

**Cause:** `CLAUDE_PLUGIN_ROOT` not set or scripts not executable

**Solution:**
```bash
chmod +x ${CLAUDE_PLUGIN_ROOT}/scripts/*.sh
```

## Git Integration

### Option A: Commit specs (Recommended for teams)

```gitignore
# Don't ignore .specs/
```

**Benefits:**
- Team shares specifications
- Documentation in version control
- Track spec evolution

### Option B: Local only (Personal projects)

```gitignore
# .gitignore
.specs/
```

**Benefits:**
- Personal workflow
- No team coordination needed

## Examples

### Example 1: User Authentication

**requirements.md:**
```markdown
## User Story
As a new user, I want to create an account, so that I can access the platform.

## Acceptance Criteria
1. WHEN user provides valid email and password THEN system SHALL create account
2. WHEN user provides existing email THEN system SHALL display error
3. WHEN account created THEN system SHALL send confirmation email
```

**design.md:**
```markdown
## Architecture
- Frontend: React form component
- Backend: Express.js API endpoint
- Database: PostgreSQL users table
- Email: SendGrid integration

## API Endpoint
POST /api/auth/register
- Validates input
- Checks email uniqueness
- Hashes password (bcrypt)
- Creates user record
- Sends confirmation email
```

**tasks.md:**
```markdown
- [ ] 1. **Create database migration**
    - Goal: Add users table
    - Details: id, email, password_hash, created_at

- [ ] 2. **Implement registration endpoint**
    - Goal: Handle user registration
    - Details: Validation, bcrypt, database insert

- [ ] 3. **Create registration form**
    - Goal: Frontend UI for registration
    - Details: React component with validation
```

## License

MIT - See LICENSE file

## Author

chenmudu - https://github.com/chenmudu

## Repository

https://github.com/chenmudu/spec-workflow-files
