# Spec Workflow Files Plugin for Claude Code

A Claude Code plugin providing file-based spec workflow for systematic feature development.

## Installation

### Method 1: Install from GitHub (Recommended)

```bash
# In Claude Code
/plugin marketplace add https://github.com/chenmudu/spec-workflow-files
/plugin install spec-workflow-files@spec-workflow-marketplace
```

### Method 2: Install from Local Clone

```bash
# Clone the repository
git clone https://github.com/chenmudu/spec-workflow-files.git
cd spec-workflow-files

# In Claude Code (from parent directory)
/plugin marketplace add ./spec-workflow-files
/plugin install spec-workflow-files@spec-workflow-marketplace
```

### Installation Scopes

```bash
# User scope (default) - available in all projects
/plugin install spec-workflow-files@spec-workflow-marketplace

# Project scope - shared with team via git
/plugin install spec-workflow-files@spec-workflow-marketplace --scope project

# Local scope - project-specific, gitignored
/plugin install spec-workflow-files@spec-workflow-marketplace --scope local
```

## What Gets Installed

Once installed, the plugin provides:

- **Skill**: `spec-workflow-files` - Automatically activated when you use `/spec-workflow`
- **Hooks**: Automatic workflow enforcement
- **Scripts**: Helper scripts for status checking and task completion
- **Templates**: Ready-to-use document templates

## Usage

### Initialize Workflow

```bash
/spec-workflow
```

This creates `.specs/` directory in your project with:
- `requirements.md` - Requirements document template
- `design.md` - Design document template
- `tasks.md` - Task breakdown template
- `.workflow-confirmations.json` - Phase status tracker

### Workflow Phases

#### Phase 1: Requirements

```bash
# 1. Edit requirements
# Claude will help you fill in .specs/requirements.md

# 2. Confirm when ready
jq '.requirements = "confirmed"' .specs/.workflow-confirmations.json > tmp.json && mv tmp.json .specs/.workflow-confirmations.json
```

#### Phase 2: Design

```bash
# 1. Edit design (after requirements confirmed)
# Claude will help you fill in .specs/design.md

# 2. Confirm when ready
jq '.design = "confirmed"' .specs/.workflow-confirmations.json > tmp.json && mv tmp.json .specs/.workflow-confirmations.json
```

#### Phase 3: Tasks

```bash
# 1. Edit tasks (after design confirmed)
# Claude will help you fill in .specs/tasks.md

# 2. Confirm when ready
jq '.tasks = "confirmed"' .specs/.workflow-confirmations.json > tmp.json && mv tmp.json .specs/.workflow-confirmations.json
```

### Track Implementation

```bash
# Mark task as complete
${CLAUDE_PLUGIN_ROOT}/scripts/complete-task.sh 1

# Check workflow status
${CLAUDE_PLUGIN_ROOT}/scripts/check-status.sh
```

## Examples

### Example 1: Start a New Feature

```
User: "I want to add user authentication to my app"

Claude: "Let me initialize the spec workflow for this feature."
[Creates .specs/ directory with templates]

Claude: "I'll start by writing the requirements. Let me edit .specs/requirements.md..."
[Fills in requirements with user stories and EARS format]

Claude: "Requirements are ready. Please review .specs/requirements.md and let me know if you'd like any changes."

User: "Looks good, proceed to design"

Claude: "Great! Let me mark requirements as confirmed and move to design phase."
[Updates .workflow-confirmations.json]
[Fills in design.md with architecture, APIs, data models]
```

### Example 2: Check Status

```
User: "What's the status of my spec?"

Claude: [Runs check-status.sh]

Output:
📊 Spec Workflow Status
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📝 Requirements:
   Status: ✅ Confirmed

🎨 Design:
   Status: 🟡 Draft
   Action: Review and mark as confirmed

✅ Tasks:
   Status: ⚪ Not Started
   ⚠️  Blocked: Design must be confirmed first

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📈 Overall Progress: 1/3 phases confirmed
```

### Example 3: Complete Tasks

```
User: "I finished implementing task 1"

Claude: [Runs complete-task.sh 1]

Output:
✅ Task 1 marked as complete

📋 Next task:
- [ ] 2. **Implement registration endpoint**
    - Goal: Handle user registration
```

## Hooks Behavior

### Session Start

When Claude Code starts:
```
[spec-workflow] Ready. Use /spec-workflow to initialize spec workflow in your project.
```

### Pre-Edit Warnings

**Editing design.md before requirements confirmed:**
```
[spec-workflow] ⚠️  Requirements not confirmed yet. Consider confirming requirements before starting design.
```

**Editing tasks.md before design confirmed:**
```
[spec-workflow] ⚠️  Design not confirmed yet. Consider confirming design before creating tasks.
```

### Post-Edit Reminders

**After editing requirements.md:**
```
[spec-workflow] ✅ Requirements updated. Review and mark as confirmed when ready.
```

**After editing design.md:**
```
[spec-workflow] ✅ Design updated. Review and mark as confirmed when ready.
```

**After editing tasks.md:**
```
[spec-workflow] ✅ Tasks updated. Review and mark as confirmed when ready to start implementation.
```

### Stop Hook

When Claude is about to stop, shows workflow status automatically.

## Verifying Installation

```bash
# List installed plugins
/plugin

# Check plugin status
/plugin info spec-workflow-files
```

## Updating

```bash
# Update to latest version
/plugin update spec-workflow-files@spec-workflow-marketplace
```

## Uninstalling

```bash
/plugin uninstall spec-workflow-files
```

## Plugin Contents

```
spec-workflow-files/
├── .claude-plugin/
│   ├── plugin.json          # Plugin manifest
│   └── marketplace.json     # Marketplace config
├── skills/
│   └── spec-workflow-files/
│       ├── SKILL.md         # Skill definition with hooks
│       ├── templates/       # Document templates
│       │   ├── requirements.md
│       │   ├── design.md
│       │   ├── tasks.md
│       │   └── .workflow-confirmations.json
│       └── scripts/         # Helper scripts
│           ├── init-spec.sh
│           ├── check-status.sh
│           └── complete-task.sh
├── README.md
├── PLUGIN.md
└── LICENSE
```

## Troubleshooting

### "Template not found" error

**Cause:** `CLAUDE_PLUGIN_ROOT` environment variable not set correctly

**Solution:** Reinstall the plugin:
```bash
/plugin uninstall spec-workflow-files
/plugin install spec-workflow-files@spec-workflow-marketplace
```

### Scripts not executable

**Cause:** Scripts don't have execute permissions

**Solution:**
```bash
chmod +x ~/.claude/plugins/*/spec-workflow-files/*/skills/spec-workflow-files/scripts/*.sh
```

### Hooks not triggering

**Cause:** Plugin not loaded or hooks disabled

**Solution:**
1. Check plugin is installed: `/plugin`
2. Check hooks are enabled in Claude Code settings
3. Restart Claude Code

### jq command not found

**Cause:** `jq` not installed on your system

**Solution:**
```bash
# macOS
brew install jq

# Ubuntu/Debian
sudo apt-get install jq

# Windows (Git Bash)
# Download from https://stedolan.github.io/jq/download/
```

## Git Integration

### Commit specs to version control (Recommended)

```gitignore
# Don't add .specs/ to .gitignore
# Let specs be committed
```

**Benefits:**
- Team shares specifications
- Documentation in version control
- Track spec evolution over time

### Keep specs local (Personal projects)

```gitignore
# .gitignore
.specs/
```

**Benefits:**
- Personal workflow
- No team coordination needed

## Integration with Other Tools

### With Planning-with-Files

**Recommended workflow:**

1. **Planning Phase** (Spec Workflow):
   ```
   .specs/requirements.md  → What to build
   .specs/design.md        → How to build
   .specs/tasks.md         → Task breakdown
   ```

2. **Execution Phase** (Planning-with-Files):
   ```
   task_plan.md   → Execution plan (based on tasks.md)
   findings.md    → Research & discoveries
   progress.md    → Session log & errors
   ```

### With Kiro

Kiro provides methodology documentation, Spec Workflow Files provides the implementation:

- **Kiro**: Read about spec-driven development principles
- **Spec Workflow Files**: Actually create and manage spec files

## Best Practices

1. **Complete each phase** before moving to the next
2. **Review and confirm** - Don't rush through phases
3. **Keep specs updated** - Update when requirements change
4. **Use EARS format** - Write testable requirements
5. **Document decisions** - Record why you chose an approach

## Support

- **Issues**: https://github.com/chenmudu/spec-workflow-files/issues
- **Discussions**: https://github.com/chenmudu/spec-workflow-files/discussions
- **Email**: chenmudu@gmail.com

## License

MIT - See [LICENSE](LICENSE)
