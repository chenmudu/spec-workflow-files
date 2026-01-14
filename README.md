# Spec Workflow Files

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

File-based spec workflow for systematic feature development. Creates structured documentation in `.specs/` directory with hooks for workflow enforcement.

## 🎯 What is This?

A Claude Code plugin that enforces a three-phase workflow for feature development:

1. **Requirements** → Define WHAT to build (EARS format)
2. **Design** → Define HOW to build it (architecture, APIs, data models)
3. **Tasks** → Break down into actionable steps

**Problem it solves:** AI coding often jumps straight to implementation without proper planning, leading to unclear requirements, poor architecture, and maintenance nightmares.

**Solution:** Persistent files + hooks that guide you through proper planning phases.

## 🚀 Quick Start

### Installation

```bash
# In Claude Code
/plugin marketplace add https://github.com/chenmudu/spec-workflow-files
/plugin install spec-workflow-files@spec-workflow-marketplace
```

### Usage

```bash
# Initialize in your project
/spec-workflow

# This creates .specs/ directory with:
# - requirements.md
# - design.md
# - tasks.md
# - .workflow-confirmations.json
```

## 📁 File Structure

```
your-project/
├── .specs/                          # All spec files here (clean!)
│   ├── requirements.md              # Phase 1: What to build
│   ├── design.md                    # Phase 2: How to build
│   ├── tasks.md                     # Phase 3: Task breakdown
│   └── .workflow-confirmations.json # Phase status tracking
├── src/
└── ...
```

**Why `.specs/`?** Keeps your project root clean (unlike some other tools that pollute the root directory).

## 🔄 Workflow

### Phase 1: Requirements

1. Edit `.specs/requirements.md`
2. Write user stories and acceptance criteria (EARS format)
3. Mark as confirmed when ready

**EARS Format Example:**
```markdown
WHEN user submits valid login credentials THEN system SHALL authenticate user
IF user is not authenticated THEN system SHALL redirect to login page
```

### Phase 2: Design

1. Edit `.specs/design.md`
2. Define architecture, data models, APIs
3. Document technical decisions
4. Mark as confirmed when ready

### Phase 3: Tasks

1. Edit `.specs/tasks.md`
2. Break design into numbered tasks
3. Mark as confirmed and start implementation

### Track Progress

```bash
# Mark task as complete
${CLAUDE_PLUGIN_ROOT}/scripts/complete-task.sh 1

# Check status
${CLAUDE_PLUGIN_ROOT}/scripts/check-status.sh
```

## 🎣 Hooks

The plugin uses hooks to guide your workflow:

- **PreToolUse**: Warns if you skip phases (e.g., editing design before confirming requirements)
- **PostToolUse**: Reminds you to confirm after editing
- **Stop**: Shows workflow status before Claude stops

## 🤝 Integration with Planning-with-Files

**Perfect combo for complete project workflow:**

```
Planning Phase (Spec Workflow):
├── .specs/requirements.md    # What to build
├── .specs/design.md          # How to build
└── .specs/tasks.md           # Task breakdown

Execution Phase (Planning-with-Files):
├── task_plan.md              # Execution plan
├── findings.md               # Research & discoveries
└── progress.md               # Session log
```

**Workflow:**
1. Use **Spec Workflow** to plan (requirements → design → tasks)
2. Use **Planning-with-Files** to execute (track progress, errors, findings)

## 📊 Comparison

| Feature | Spec Workflow Files | Planning-with-Files | Kiro |
|---------|---------------------|---------------------|------|
| **Purpose** | Planning & Documentation | Execution Tracking | Methodology Guide |
| **Files** | 3 (in `.specs/`) | 3 (in root) | Documentation only |
| **Hooks** | ✅ Yes | ✅ Yes | ❌ No |
| **Phase Enforcement** | ✅ Yes | ❌ No | ❌ No |
| **EARS Format** | ✅ Yes | ❌ No | ✅ Yes |
| **Task Tracking** | ✅ Yes | ✅ Yes | ❌ No |
| **Clean Directory** | ✅ `.specs/` | ❌ Root pollution | N/A |

## 🎓 When to Use

**✅ Use for:**
- New feature development
- Complex system changes
- Projects requiring documentation
- Team collaboration
- Anything needing structured planning

**❌ Skip for:**
- Simple bug fixes
- Trivial changes
- Experimental prototypes
- Time-critical hotfixes

## 📖 Documentation

- [Plugin Documentation](PLUGIN.md) - Installation and usage details
- [SKILL.md](skills/spec-workflow-files/SKILL.md) - Complete skill reference
- [Templates](skills/spec-workflow-files/templates/) - Document templates

## 🛠️ Development

```bash
# Clone repository
git clone https://github.com/chenmudu/spec-workflow-files.git
cd spec-workflow-files

# Install locally
/plugin marketplace add ./
/plugin install spec-workflow-files@spec-workflow-marketplace
```

## 📝 Example

**requirements.md:**
```markdown
## User Story
As a user, I want to reset my password, so that I can regain access to my account.

## Acceptance Criteria
1. WHEN user clicks "Forgot Password" THEN system SHALL display email input form
2. WHEN user submits valid email THEN system SHALL send reset link
3. WHEN user clicks reset link THEN system SHALL display password reset form
```

**design.md:**
```markdown
## Architecture
- Frontend: React password reset flow
- Backend: Express.js endpoints (/forgot-password, /reset-password)
- Email: SendGrid for reset emails
- Security: JWT tokens with 1-hour expiration

## API Endpoints
POST /api/auth/forgot-password
POST /api/auth/reset-password/:token
```

**tasks.md:**
```markdown
- [ ] 1. **Create password reset table**
    - Goal: Store reset tokens
    - Details: token, user_id, expires_at

- [ ] 2. **Implement forgot-password endpoint**
    - Goal: Generate and send reset token
    - Details: Create token, send email, store in DB

- [ ] 3. **Implement reset-password endpoint**
    - Goal: Validate token and update password
    - Details: Check expiration, hash password, update user
```

## 🤔 Philosophy

**Inspired by:**
- **Manus** (planning-with-files) - File-based persistence
- **Kiro** - Spec-driven development methodology
- **EARS** - Easy Approach to Requirements Syntax

**Core principles:**
1. **Files over memory** - Persistent documentation beats volatile context
2. **Structure over chaos** - Enforced phases prevent premature implementation
3. **Clean over messy** - `.specs/` directory keeps project root clean
4. **Guidance over freedom** - Hooks nudge you toward best practices

## 📄 License

MIT License - see [LICENSE](LICENSE) file

## 👤 Author

**chenmudu**
- GitHub: [@chenmudu](https://github.com/chenmudu)
- Email: chenmudu@gmail.com

## 🙏 Acknowledgments

- [OthmanAdi/planning-with-files](https://github.com/OthmanAdi/planning-with-files) - Inspiration for file-based workflow
- [jasonkneen/kiro](https://github.com/jasonkneen/kiro) - Spec-driven methodology
- Meta's Manus - Original file-based planning concept

## 🐛 Issues & Contributions

Found a bug? Have a feature request?

- Open an issue: https://github.com/chenmudu/spec-workflow-files/issues
- Submit a PR: https://github.com/chenmudu/spec-workflow-files/pulls

## ⭐ Star History

If you find this useful, please star the repo!
