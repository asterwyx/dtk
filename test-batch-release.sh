#!/bin/bash

# DTK 批量发版工作流测试脚本
# 用于验证工作流的基本功能和配置

set -e

echo "=== DTK 批量发版工作流测试 ==="
echo

# 检查工作流文件是否存在
echo "1. 检查工作流文件..."
if [ -f ".github/workflows/batch-release-all-components.yml" ]; then
    echo "✓ 工作流文件存在"
else
    echo "✗ 工作流文件不存在"
    exit 1
fi

# 检查YAML语法
echo
echo "2. 检查YAML语法..."
if python3 -c "import yaml; yaml.safe_load(open('.github/workflows/batch-release-all-components.yml'))" 2>/dev/null; then
    echo "✓ YAML语法正确"
else
    echo "✗ YAML语法错误"
    exit 1
fi

# 检查子模块配置
echo
echo "3. 检查子模块配置..."
if [ -f ".gitmodules" ]; then
    echo "✓ .gitmodules文件存在"
    echo "  包含的子模块："
    grep -E '^\[submodule' .gitmodules | sed 's/\[submodule "\(.*\)"\]/  - \1/'
else
    echo "✗ .gitmodules文件不存在"
    exit 1
fi

# 检查子模块目录
echo
echo "4. 检查子模块目录..."
expected_components=("dtkcommon" "dtkcore" "dtkgui" "dtkwidget" "dtkdeclarative" "qt5integration" "qt5platform-plugins")
for component in "${expected_components[@]}"; do
    if [ -d "$component" ]; then
        echo "✓ $component 目录存在"
    else
        echo "✗ $component 目录不存在"
    fi
done

# 检查debian/changelog文件
echo
echo "5. 检查debian/changelog文件..."
for component in "${expected_components[@]}"; do
    if [ -f "$component/debian/changelog" ]; then
        echo "✓ $component/debian/changelog 存在"
    else
        echo "✗ $component/debian/changelog 不存在"
    fi
done

# 检查工作流配置
echo
echo "6. 检查工作流配置..."
workflow_file=".github/workflows/batch-release-all-components.yml"

# 检查是否包含所有必要的组件
for component in "${expected_components[@]}"; do
    if grep -q "auto-tag-$component" "$workflow_file"; then
        echo "✓ auto-tag-$component 任务存在"
    else
        echo "✗ auto-tag-$component 任务不存在"
    fi
    
    if grep -q "build-distribution-$component" "$workflow_file"; then
        echo "✓ build-distribution-$component 任务存在"
    else
        echo "✗ build-distribution-$component 任务不存在"
    fi
done

# 检查工作流触发器
echo
echo "7. 检查工作流触发器..."
if grep -q "workflow_dispatch" "$workflow_file"; then
    echo "✓ workflow_dispatch 触发器配置正确"
else
    echo "✗ workflow_dispatch 触发器配置错误"
fi

# 检查输入参数
echo
echo "8. 检查输入参数..."
if grep -q "release_version" "$workflow_file"; then
    echo "✓ release_version 参数存在"
else
    echo "✗ release_version 参数不存在"
fi

if grep -q "release_notes" "$workflow_file"; then
    echo "✓ release_notes 参数存在"
else
    echo "✗ release_notes 参数不存在"
fi

echo
echo "=== 测试完成 ==="
echo
echo "如果所有检查都通过，工作流应该可以正常工作。"
echo "要使用工作流，请："
echo "1. 提交这些文件到仓库"
echo "2. 在GitHub Actions页面找到 'Batch Release All DTK Components'"
echo "3. 点击 'Run workflow' 并填写参数"
echo "4. 开始批量发版流程"