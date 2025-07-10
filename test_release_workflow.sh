#!/bin/bash

# DTK Release Workflow Test Script
# 用于测试发版工作流的逻辑

set -e

echo "=== DTK Release Workflow Test ==="
echo ""

# 检查是否在dtk仓库中
if [[ ! -f ".gitmodules" ]]; then
    echo "Error: Not in dtk repository. Please run this script from the dtk root directory."
    exit 1
fi

# 获取所有子模块
echo "Getting submodules from .gitmodules..."
components=$(grep '^\[submodule' .gitmodules | sed 's/\[submodule "\(.*\)"\]/\1/' | tr '\n' ' ')
echo "Found components: $components"
echo ""

# 测试每个组件
for component in $components; do
    echo "=== Testing $component ==="
    
    if [[ ! -d "$component" ]]; then
        echo "  ❌ Component directory not found"
        continue
    fi
    
    cd "$component"
    
    # 检查debian/changelog
    if [[ ! -f "debian/changelog" ]]; then
        echo "  ❌ No debian/changelog found"
        cd ..
        continue
    fi
    
    # 获取当前版本
    current_version=$(head -n1 debian/changelog | grep -oE '\([^)]+\)' | sed 's/[()]//g')
    if [[ -z "$current_version" ]]; then
        echo "  ❌ Could not parse version from debian/changelog"
        cd ..
        continue
    fi
    echo "  ✅ Current version: $current_version"
    
    # 检查版本格式
    if [[ ! "$current_version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo "  ⚠️  Version format may not be standard (x.y.z): $current_version"
    else
        echo "  ✅ Version format is standard"
    fi
    
    # 检查变更
    last_tag=$(git describe --tags --abbrev=0 2>/dev/null || echo "")
    if [[ -n "$last_tag" ]]; then
        changes=$(git log --oneline "$last_tag"..HEAD -- . | wc -l)
        echo "  📊 Changes since last tag ($last_tag): $changes"
    else
        changes=$(git log --oneline -- . | wc -l)
        echo "  📊 Total changes (no tags found): $changes"
    fi
    
    if [[ $changes -gt 0 ]]; then
        echo "  ✅ Component needs release"
        
        # 计算新版本号
        if [[ "$current_version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
            patch_version=$(echo "$current_version" | awk -F. '{print $1 "." $2 "." $3+1}')
            minor_version=$(echo "$current_version" | awk -F. '{print $1 "." $2+1 ".0"}')
            major_version=$(echo "$current_version" | awk -F. '{print $1+1 ".0.0"}')
            
            echo "  📈 Version candidates:"
            echo "    Patch: $patch_version"
            echo "    Minor: $minor_version"
            echo "    Major: $major_version"
        fi
    else
        echo "  ⏭️  No changes detected, skip release"
    fi
    
    # 检查auto-tag工作流
    if [[ -f ".github/workflows/call-auto-tag.yml" ]]; then
        echo "  ✅ Auto-tag workflow found"
    else
        echo "  ❌ Auto-tag workflow not found"
    fi
    
    cd ..
    echo ""
done

echo "=== Test Summary ==="
echo "Components tested: $(echo $components | wc -w)"
echo ""

echo "Recommendations:"
echo "1. Use 'Simple Trigger Component Releases' workflow for daily releases"
echo "2. Use 'Batch Release All DTK Components' for major releases"
echo "3. Always test with dry_run=true first"
echo "4. Ensure CI_ROBOT_PAT has proper permissions"