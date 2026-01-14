# Spec Workflow Files

[English](README.md) | 简体中文

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

基于文件的规范化工作流插件，用于系统化的功能开发。在 `.specs/` 目录中创建结构化文档，并通过 hooks 强制执行工作流。

## 🎯 这是什么？

一个 Claude Code 插件，强制执行三阶段功能开发工作流：

1. **需求阶段** → 定义要构建什么（EARS 格式）
2. **设计阶段** → 定义如何构建（架构、API、数据模型）
3. **任务阶段** → 分解为可执行步骤

**解决的问题：** AI 编码经常直接跳到实现，导致需求不清晰、架构糟糕和维护噩梦。

**解决方案：** 持久化文件 + hooks 引导你完成正确的规划阶段。

## 🚀 快速开始

### 安装

```bash
# 在 Claude Code 中执行
/plugin marketplace add chenmudu/spec-workflow-files
/plugin install spec-workflow-files@spec-workflow-files
```

### 使用

```bash
# 在项目中初始化
/spec-workflow

# 这会创建 .specs/ 目录，包含：
# - requirements.md
# - design.md
# - tasks.md
# - .workflow-confirmations.json
```

## 📁 文件结构

```
your-project/
├── .specs/                          # 规范文件专用目录
│   ├── requirements.md              # 阶段 1：要构建什么
│   ├── design.md                    # 阶段 2：如何构建
│   ├── tasks.md                     # 阶段 3：任务分解
│   └── .workflow-confirmations.json # 阶段状态跟踪
├── src/
└── ...
```

## 🔄 工作流

三个阶段，强制顺序执行：

**阶段 1：需求** → 使用 EARS 格式编辑 `.specs/requirements.md`
```markdown
WHEN 用户提交有效登录凭据 THEN 系统 SHALL 验证用户身份
```

**阶段 2：设计** → 编辑 `.specs/design.md`，定义架构和 API

**阶段 3：任务** → 编辑 `.specs/tasks.md`，编号实现任务

每个阶段完成后标记为已确认，再进入下一阶段。

## 🎣 Hooks

插件使用 hooks 引导你的工作流：

- **PreToolUse**：如果跳过阶段会发出警告（例如，在确认需求前编辑设计）
- **PostToolUse**：编辑后提醒你确认
- **Stop**：Claude 停止前显示工作流状态

## 🤝 与 Planning-with-Files 集成（可选）

可独立使用，也可与 [planning-with-files](https://github.com/OthmanAdi/planning-with-files) 结合：

- **Spec Workflow** → 规划阶段（requirements → design → tasks 在 `.specs/` 中）
- **Planning-with-Files** → 执行阶段（task_plan.md、findings.md、progress.md 在根目录）

完成所有阶段后，插件会建议使用 planning-with-files（如果检测到）。

## 📊 功能对比

| 功能 | Spec Workflow Files | Planning-with-Files |
|------|---------------------|---------------------|
| **用途** | 规划与文档 | 执行跟踪 |
| **文件** | 3 个（在 `.specs/` 中） | 3 个（在根目录） |
| **Hooks** | ✅ 是 | ✅ 是 |
| **阶段强制** | ✅ 是 | ❌ 否 |
| **EARS 格式** | ✅ 是 | ❌ 否 |
| **任务跟踪** | ✅ 是 | ✅ 是 |
| **目录整洁** | ✅ `.specs/` | ⚠️ 根目录文件 |
| **最适合** | 规划阶段 | 执行阶段 |

## 🎓 最佳实践

1. **完成每个阶段** - 不要跳过，每个阶段都建立在前一个之上
2. **使用 EARS 格式** - `WHEN [触发条件] THEN 系统 SHALL [响应]`
3. **记录决策** - 在 design.md 中记录为什么选择某种方法
4. **保持更新** - 需求或设计变化时更新规范
5. **结合 planning-with-files** - 复杂项目需要执行跟踪时使用

## 🎯 何时使用

**✅ 适用于：**
- 新功能开发
- 复杂系统变更
- 需要文档的项目
- 团队协作
- AI 辅助开发

**❌ 不适用于：**
- 简单 bug 修复
- 琐碎变更
- 实验性原型
- 时间紧迫的热修复

## 📖 文档

- [插件文档](PLUGIN.md) - 安装和使用
- [SKILL.md](skills/spec-workflow-files/SKILL.md) - 完整参考
- [模板](skills/spec-workflow-files/templates/) - 文档模板

## 📝 示例

查看 [PLUGIN.md](PLUGIN.md) 了解 requirements.md、design.md 和 tasks.md 的完整示例。

## 🤔 设计哲学

**核心原则：**
1. 文件优于内存 - 持久化文档胜过易失性上下文
2. 结构优于混乱 - 强制阶段防止过早实现
3. 引导优于自由 - Hooks 引导遵循最佳实践

**灵感来源：** Manus（planning-with-files）、Kiro（规范驱动开发）、EARS（需求语法）

## 📄 许可证

MIT License - 查看 [LICENSE](LICENSE) 文件

## 👤 作者

**chenmudu** - [@chenmudu](https://github.com/chenmudu)

## 🙏 致谢

- [OthmanAdi/planning-with-files](https://github.com/OthmanAdi/planning-with-files)
- [jasonkneen/kiro](https://github.com/jasonkneen/kiro)
- Meta's Manus

---

**问题与贡献：** https://github.com/chenmudu/spec-workflow-files/issues
