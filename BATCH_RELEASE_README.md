# DTK 批量发版工作流

## 概述

这个工作流允许您一键为所有 DTK 组件进行批量发版。它会自动处理以下任务：

1. 更新所有组件的版本号
2. 触发自动标签创建工作流
3. 触发构建分发工作流
4. 生成发版摘要

## 支持的组件

工作流会自动处理以下 DTK 组件：

- dtkcommon
- dtkcore
- dtkgui
- dtkwidget
- dtkdeclarative
- qt5integration
- qt5platform-plugins

## 使用方法

### 1. 手动触发

1. 在 GitHub 仓库页面，点击 "Actions" 标签
2. 在左侧工作流列表中找到 "Batch Release All DTK Components"
3. 点击 "Run workflow"
4. 填写以下参数：
   - **Release version**: 发版版本号（例如：5.7.10）
   - **Release notes**: 发版说明（可选，默认为 "Batch release all DTK components"）
5. 点击 "Run workflow" 开始执行

### 2. 工作流执行过程

工作流会按以下顺序执行：

1. **update-versions**: 为每个组件更新 `debian/changelog` 中的版本号
2. **auto-tag-***: 为每个组件调用自动标签创建工作流
3. **build-distribution-***: 为每个组件调用构建分发工作流
4. **create-summary**: 生成发版摘要报告

### 3. 工作流任务详情

#### 版本更新任务
- `update-versions`: 使用矩阵策略并行更新所有组件的版本号
- 每个组件都会更新其 `debian/changelog` 文件
- 自动提交并推送版本更新

#### 自动标签任务
- `auto-tag-dtkcommon`: 为 dtkcommon 组件创建标签
- `auto-tag-dtkcore`: 为 dtkcore 组件创建标签
- `auto-tag-dtkgui`: 为 dtkgui 组件创建标签
- `auto-tag-dtkwidget`: 为 dtkwidget 组件创建标签
- `auto-tag-dtkdeclarative`: 为 dtkdeclarative 组件创建标签
- `auto-tag-qt5integration`: 为 qt5integration 组件创建标签
- `auto-tag-qt5platform-plugins`: 为 qt5platform-plugins 组件创建标签

#### 构建分发任务
- `build-distribution-dtkcommon`: 为 dtkcommon 组件构建分发
- `build-distribution-dtkcore`: 为 dtkcore 组件构建分发
- `build-distribution-dtkgui`: 为 dtkgui 组件构建分发
- `build-distribution-dtkwidget`: 为 dtkwidget 组件构建分发
- `build-distribution-dtkdeclarative`: 为 dtkdeclarative 组件构建分发
- `build-distribution-qt5integration`: 为 qt5integration 组件构建分发
- `build-distribution-qt5platform-plugins`: 为 qt5platform-plugins 组件构建分发

## 注意事项

### 权限要求

确保工作流有足够的权限来：

- 推送到各个子模块仓库
- 调用其他工作流
- 访问必要的 secrets

### 版本管理

- 工作流会自动更新每个组件的 `debian/changelog` 文件
- 版本号格式应遵循语义化版本规范
- 建议在发版前确保所有组件都已通过测试

### 错误处理

- 如果某个组件的工作流失败，其他组件仍会继续执行
- 工作流摘要会显示所有组件的处理状态
- 建议在发版前检查各个组件的状态

### 工作目录设置

每个组件的工作流任务都设置了正确的工作目录：

```yaml
defaults:
  run:
    working-directory: component-name
```

这确保每个工作流都在正确的子模块目录中执行。

## 配置

### 环境变量

工作流使用以下环境变量：

- `RELEASE_VERSION`: 发版版本号
- `RELEASE_NOTES`: 发版说明

### Secrets

工作流需要以下 secrets：

- `GITHUB_TOKEN`: GitHub 访问令牌
- `BUILD_GPG_PRIVATE_KEY`: 构建 GPG 私钥
- `BUILD_SSH_PRIVATE_KEY`: 构建 SSH 私钥
- `APP_ID`: GitHub App ID
- `APP_PRIVATE_KEY`: GitHub App 私钥
- `TRANSIFEX_API_TOKEN`: Transifex API 令牌

## 故障排除

### 常见问题

1. **权限错误**
   - 确保工作流有足够的权限访问所有子模块
   - 检查 GitHub token 是否有效

2. **版本冲突**
   - 确保版本号格式正确
   - 检查是否与现有版本冲突

3. **工作流调用失败**
   - 检查目标工作流是否存在
   - 确保目标工作流支持被调用

4. **工作目录问题**
   - 确保子模块已正确初始化
   - 检查工作目录设置是否正确

### 日志查看

- 在 GitHub Actions 页面查看详细执行日志
- 每个组件的处理状态都会在摘要中显示
- 失败的任务会显示具体的错误信息

## 最佳实践

1. **发版前准备**
   - 确保所有组件都已通过测试
   - 检查是否有未合并的 PR
   - 验证版本号格式

2. **发版后检查**
   - 验证所有组件的标签是否创建成功
   - 检查构建分发是否正常
   - 确认发版摘要信息正确

3. **版本管理**
   - 使用语义化版本号
   - 在发版说明中详细描述变更
   - 保持版本号的一致性

4. **监控执行**
   - 定期检查工作流执行状态
   - 关注失败的任务并及时处理
   - 保持工作流的稳定性

## 联系支持

如果遇到问题，请：

1. 检查 GitHub Actions 日志
2. 查看工作流摘要报告
3. 联系 DTK 维护团队