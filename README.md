# Spec Workflow Files

English | [简体中文](README_CN.md)

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

### Requirements

- **jq** - Required for workflow status checking and hooks
  - Windows: Download from [jqlang.github.io/jq](https://jqlang.github.io/jq/download/)
  - macOS: `brew install jq`
  - Linux: `apt-get install jq` or `yum install jq`

### Installation

```bash
# In Claude Code
/plugin marketplace add chenmudu/spec-workflow-files
/plugin install spec-workflow-files@spec-workflow-files
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
├── .specs/                          # Spec files in dedicated directory
│   ├── requirements.md              # Phase 1: What to build
│   ├── design.md                    # Phase 2: How to build
│   ├── tasks.md                     # Phase 3: Task breakdown
│   └── .workflow-confirmations.json # Phase status tracking
├── src/
└── ...
```

## 🔄 Workflow

Three phases with enforced sequencing:

**Phase 1: Requirements** → Edit `.specs/requirements.md` with EARS format
```markdown
WHEN user submits valid login credentials THEN system SHALL authenticate user
```

**Phase 2: Design** → Edit `.specs/design.md` with architecture and APIs

**Phase 3: Tasks** → Edit `.specs/tasks.md` with numbered implementation tasks

Mark each phase as confirmed before proceeding to the next.

## 🎣 Hooks

The plugin uses hooks to guide your workflow:

- **PreToolUse**: Warns if you skip phases (e.g., editing design before confirming requirements)
- **PostToolUse**: Reminds you to confirm after editing
- **Stop**: Shows workflow status before Claude stops

## 🤝 Integration with Planning-with-Files (Optional)

Works standalone or combined with [planning-with-files](https://github.com/OthmanAdi/planning-with-files):

- **Spec Workflow** → Planning (requirements → design → tasks in `.specs/`)
- **Planning-with-Files** → Execution (task_plan.md, findings.md, progress.md in root)

After completing all phases, the plugin suggests using planning-with-files if detected.

## 📊 Feature Comparison

| Feature | Spec Workflow Files | Planning-with-Files | Kiro |
|---------|---------------------|---------------------|------|
| **Purpose** | Planning & Documentation | Execution Tracking | Methodology Guide |
| **Files** | 3 (in `.specs/`) | 3 (in root) | Documentation only |
| **Hooks** | ✅ Yes | ✅ Yes | ❌ No |
| **Phase Enforcement** | ✅ Yes | ❌ No | ❌ No |
| **EARS Format** | ✅ Yes | ❌ No | ✅ Yes (guide) |
| **Task Tracking** | ✅ Yes | ✅ Yes | ❌ No |
| **Clean Directory** | ✅ `.specs/` | ⚠️ Root files | N/A |
| **Best For** | Planning phase | Execution phase | Learning methodology |

## 🎓 Best Practices

1. **Complete each phase** - Don't skip ahead, each builds on the previous
2. **Use EARS format** - `WHEN [trigger] THEN system SHALL [response]`
3. **Document decisions** - Record why you chose an approach in design.md
4. **Keep specs updated** - Update when requirements or design evolves
5. **Combine with planning-with-files** - For complex projects needing execution tracking

## 🎯 When to Use

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

## 📖 Documentation

- [Plugin Documentation](PLUGIN.md) - Installation and usage
- [SKILL.md](skills/spec-workflow-files/SKILL.md) - Complete reference
- [Templates](skills/spec-workflow-files/templates/) - Document templates

## 📝 Example

See [PLUGIN.md](PLUGIN.md) for complete examples of requirements.md, design.md, and tasks.md.

## 🤔 Philosophy

**Core principles:**
1. Files over memory - Persistent documentation beats volatile context
2. Structure over chaos - Enforced phases prevent premature implementation
3. Guidance over freedom - Hooks nudge toward best practices

**Inspired by:** Manus (planning-with-files), Kiro (spec-driven development), EARS (requirements syntax)

## 📄 License

MIT License - see [LICENSE](LICENSE) file

## 👤 Author

**chenmudu** - [@chenmudu](https://github.com/chenmudu)

## 🙏 Acknowledgments

- [OthmanAdi/planning-with-files](https://github.com/OthmanAdi/planning-with-files)
- [jasonkneen/kiro](https://github.com/jasonkneen/kiro)
- Meta's Manus

---

**Issues & Contributions:** https://github.com/chenmudu/spec-workflow-files/issues
