# DTK 组件发版工作流使用指南

本文档介绍 DTK 仓库中新增的一键发版工作流的使用方法。

## 🚀 快速开始

要为所有 DTK 组件一键发版，请按以下步骤操作：

1. 进入 GitHub Actions 页面
2. 选择 "Release All DTK Components" 工作流
3. 点击 "Run workflow" 
4. 选择发版类型（patch/minor/major）
5. 点击 "Run workflow" 开始执行

## 工作流概述

我们为 DTK 仓库新增了三个主要的发版管理工作流：

### 1. 一键发版工作流 (`release-all-components.yml`)
**功能**：为所有或指定的 DTK 组件触发发版流程

**触发方式**：手动触发（workflow_dispatch）

**输入参数**：
- `release_type`: 发版类型（patch/minor/major）
- `dry_run`: 是否为测试模式（默认：false）
- `selected_components`: 指定组件（逗号分隔，为空则处理所有组件）

### 2. 子模块更新工作流 (`update-submodules.yml`)
**功能**：将子模块引用更新到各组件的最新标签

**触发方式**：手动触发（workflow_dispatch）

**输入参数**：
- `dry_run`: 是否为测试模式（默认：false）
- `selected_components`: 指定组件（逗号分隔，为空则处理所有组件）

### 3. 组件状态检查工作流 (`check-components-status.yml`)
**功能**：检查所有 DTK 组件的当前状态和版本信息

**触发方式**：
- 手动触发（workflow_dispatch）
- 定时执行（每周一上午9点UTC）

## 使用场景和步骤

### 场景1：完整发版流程

1. **检查当前状态**
   ```
   运行 "Check DTK Components Status" 工作流
   ```
   - 查看组件状态报告
   - 确认哪些组件需要发版

2. **执行一键发版**
   ```
   运行 "Release All DTK Components" 工作流
   参数设置：
   - release_type: patch/minor/major（根据需要选择）
   - dry_run: false（实际发版时）
   - selected_components: 留空（处理所有组件）或指定特定组件
   ```

3. **监控发版进度**
   - 查看工作流执行结果
   - 访问各组件仓库查看发版状态
   - 等待所有组件发版完成

4. **更新子模块引用**
   ```
   运行 "Update Submodules to Latest Tags" 工作流
   参数设置：
   - dry_run: false
   - selected_components: 留空（更新所有组件）
   ```

### 场景2：部分组件发版

1. **检查特定组件状态**
   ```
   运行 "Check DTK Components Status" 工作流
   ```

2. **为特定组件发版**
   ```
   运行 "Release All DTK Components" 工作流
   参数设置：
   - release_type: 根据需要选择
   - dry_run: false
   - selected_components: "dtkcore,dtkwidget"（示例：只发版这两个组件）
   ```

3. **更新对应的子模块**
   ```
   运行 "Update Submodules to Latest Tags" 工作流
   参数设置：
   - selected_components: "dtkcore,dtkwidget"（与发版的组件保持一致）
   ```

### 场景3：测试发版流程

在执行实际发版前，建议先进行测试：

```
运行 "Release All DTK Components" 工作流
参数设置：
- release_type: patch
- dry_run: true（测试模式）
- selected_components: 根据需要设置
```

## 管理的 DTK 组件

当前工作流管理以下 DTK 组件：

- `dtkcommon` - DTK 通用库
- `dtkcore` - DTK 核心库
- `dtkgui` - DTK GUI 库
- `dtkwidget` - DTK Widget 库
- `dtkdeclarative` - DTK Declarative 库
- `qt5integration` - Qt5 集成库
- `qt5platform-plugins` - Qt5 平台插件

## 工作流特性

### 智能发版触发
- 优先尝试触发组件的 `release` 工作流
- 回退到 `auto-tag` 工作流
- 最后使用 `repository_dispatch` 机制

### 并行处理
- 所有组件的发版操作并行执行
- 提高整体发版效率

### 错误处理
- 单个组件发版失败不影响其他组件
- 详细的错误报告和状态反馈

### 灵活配置
- 支持选择性发版（指定组件）
- 支持测试模式（dry run）
- 支持不同的发版类型

## 最佳实践

1. **发版前检查**
   - 始终先运行状态检查工作流
   - 确认各组件的当前版本和状态

2. **使用测试模式**
   - 重要发版前先使用 dry_run 模式测试
   - 验证工作流配置和参数

3. **监控发版进度**
   - 关注工作流执行结果
   - 及时查看各组件仓库的发版状态

4. **及时更新子模块**
   - 发版完成后及时更新子模块引用
   - 保持主仓库的组件版本最新

5. **定期状态检查**
   - 利用定时检查功能定期了解组件状态
   - 及时发现需要维护的组件

## 故障排除

### 工作流触发失败
- 检查目标组件仓库是否存在对应的工作流
- 确认 GitHub Token 权限是否足够
- 查看工作流日志中的详细错误信息

### 子模块更新失败
- 确认子模块已正确初始化
- 检查组件仓库是否有可用的标签
- 验证 Git 配置和权限

### 权限问题
- 确保工作流有足够权限访问组件仓库
- 检查 `secrets.GITHUB_TOKEN` 是否配置正确

## 工作流维护

### 添加新组件
要添加新的 DTK 组件到发版流程中：

1. 在 `.gitmodules` 中添加新的子模块
2. 更新工作流文件中的组件列表：
   - `release-all-components.yml` 中的 `ALL_COMPONENTS`
   - `update-submodules.yml` 中的 `ALL_COMPONENTS`
   - `check-components-status.yml` 中的 `COMPONENTS`

### 修改发版逻辑
根据组件仓库的实际工作流名称，可能需要调整 `release-all-components.yml` 中的工作流触发逻辑。

---

*本文档随 DTK 发版工作流的更新而更新。如有问题或建议，请提交 Issue。*