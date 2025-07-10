# DTK 组件一键发版工作流

本仓库提供了三个工作流来实现dtk组件的一键发版功能：

## 工作流说明

### 1. Batch Release All DTK Components (`batch-release-all-components.yml`)

这个工作流会直接为所有dtk组件创建发版分支和Pull Request。

**功能特点：**
- 自动检测所有子模块组件
- 检查每个组件是否有变更需要发版
- 自动计算新版本号（patch/minor/major）
- 创建发版分支和Pull Request
- 支持dry run模式进行测试

**使用方法：**
1. 在GitHub仓库页面，进入 "Actions" 标签页
2. 选择 "Batch Release All DTK Components" 工作流
3. 点击 "Run workflow" 按钮
4. 配置参数：
   - **Release type**: 选择发版类型（patch/minor/major）
   - **Dry run**: 是否仅测试模式（推荐先开启）
   - **Components**: 指定要发版的组件（留空表示所有组件）

### 2. Trigger Component Releases (`trigger-component-releases.yml`)

这个工作流会触发各个组件仓库的自动发版工作流。

**功能特点：**
- 检测需要发版的组件
- 触发各组件仓库的 `auto-tag` 工作流
- 利用现有的自动发版机制
- 支持dry run模式

**使用方法：**
1. 在GitHub仓库页面，进入 "Actions" 标签页
2. 选择 "Trigger Component Releases" 工作流
3. 点击 "Run workflow" 按钮
4. 配置参数：
   - **Components**: 指定要发版的组件（留空表示所有组件）
   - **Dry run**: 是否仅测试模式（推荐先开启）

### 3. Simple Trigger Component Releases (`simple-trigger-releases.yml`)

这是一个简化版本的工作流，通过临时修改 `debian/changelog` 来触发各组件仓库的 `auto-tag` 工作流。

**功能特点：**
- 更简单的实现方式
- 直接修改changelog触发现有工作流
- 自动恢复原始changelog
- 支持dry run模式

**使用方法：**
1. 在GitHub仓库页面，进入 "Actions" 标签页
2. 选择 "Simple Trigger Component Releases" 工作流
3. 点击 "Run workflow" 按钮
4. 配置参数：
   - **Components**: 指定要发版的组件（留空表示所有组件）
   - **Dry run**: 是否仅测试模式（推荐先开启）

## 组件列表

当前dtk仓库包含以下组件：

- `dtkcommon` - DTK通用组件
- `dtkcore` - DTK核心组件
- `dtkgui` - DTK GUI组件
- `dtkwidget` - DTK Widget组件
- `dtkdeclarative` - DTK声明式组件
- `qt5integration` - Qt5集成组件
- `qt5platform-plugins` - Qt5平台插件组件

## 发版流程

### 自动检测机制

工作流会自动检测以下条件：
1. 组件是否存在 `debian/changelog` 文件
2. 自上次tag以来是否有代码变更
3. 当前版本号格式是否正确

### 版本号计算

根据选择的发版类型自动计算新版本号：
- **patch**: 增加补丁版本号 (1.2.3 → 1.2.4)
- **minor**: 增加次版本号 (1.2.3 → 1.3.0)
- **major**: 增加主版本号 (1.2.3 → 2.0.0)

### 发版步骤

1. **检测阶段**: 检查所有组件的变更状态
2. **准备阶段**: 计算新版本号，准备发版分支
3. **执行阶段**: 创建发版分支，更新changelog，创建Pull Request
4. **总结阶段**: 生成发版报告

## 使用建议

### 首次使用
1. 建议先使用 **dry run** 模式测试工作流
2. 检查生成的报告，确认发版计划正确
3. 确认无误后再执行实际发版

### 日常使用
1. 使用 "Simple Trigger Component Releases" 工作流触发自动发版（推荐）
2. 或使用 "Trigger Component Releases" 工作流
3. 利用各组件现有的 `auto-tag` 工作流机制
4. 减少手动干预，提高发版效率

### 批量发版
1. 使用 "Batch Release All DTK Components" 工作流
2. 适合需要统一发版多个组件的场景
3. 可以精确控制发版类型和范围

## 注意事项

1. **权限要求**: 需要 `CI_ROBOT_PAT` 权限来操作各组件仓库
2. **版本兼容性**: 确保各组件版本之间的兼容性
3. **测试验证**: 发版前建议进行充分的测试
4. **回滚机制**: 如发现问题，可以关闭或回滚Pull Request

## 故障排除

### 常见问题

1. **权限错误**: 检查 `CI_ROBOT_PAT` 权限是否配置正确
2. **版本解析错误**: 检查 `debian/changelog` 格式是否正确
3. **网络问题**: 检查GitHub Actions的网络连接

### 日志查看

工作流执行过程中会生成详细的日志，包括：
- 组件检测结果
- 版本号计算过程
- 发版操作状态
- 错误信息（如有）

## 相关链接

- [DTK 项目主页](https://github.com/linuxdeepin/dtk)
- [GitHub Actions 文档](https://docs.github.com/en/actions)
- [Deepin 开发指南](https://github.com/linuxdeepin/developer-center)