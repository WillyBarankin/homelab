# 🔧 Git History Maintenance

## Overview
This is my approach to keeping git history clean for this homelab project while still showing how the infrastructure evolved over time. It's a practical strategy that keeps the repository organized and tells the story of how things were built.

## Branch Structure
- **`main`** - Clean, production-ready history (squashed commits)
- **`clean-development-timeline`** - Development progression showing how features were built
- **`backup-before-squash`** - Complete history backup (local safety net)

## Development Workflow

### Adding New Features
```bash
# Start from main branch
git checkout main
git pull origin main

# Create feature branch
git checkout -b feature/new-feature

# Make changes and commit with clear messages
git add .
git commit -m "feat: add new authentication system"
git commit -m "docs: update deployment guide for new auth"
git commit -m "fix: resolve SSL certificate issue"

# Push feature branch
git push origin feature/new-feature
```

### Timeline Management
I update the timeline when I complete meaningful work:
- **New services** (Kubernetes deployments, Docker services)
- **Security enhancements** (authentication, encryption)
- **Documentation milestones** (complete guides, architecture docs)
- **Performance improvements** (significant optimizations)

```bash
# 1. Complete feature development on main
git checkout main
git merge feature/new-feature
git push origin main

# 2. Update development timeline
git checkout clean-development-timeline
git pull origin clean-development-timeline

# 3. Cherry-pick meaningful commits
git cherry-pick <commit-hash-of-meaningful-change>

# 4. Push updated timeline
git push origin clean-development-timeline
```

### Commit Selection Criteria

#### ✅ Include in Timeline:
- **Feature implementations** - New services, infrastructure components
- **Security enhancements** - Authentication, encryption, access controls
- **Architecture changes** - Kubernetes deployments, Docker services
- **Documentation milestones** - Complete guides, architecture docs
- **Performance improvements** - Significant optimizations
- **Infrastructure updates** - Monitoring, logging, CI/CD

#### ❌ Exclude from Timeline:
- **Minor bug fixes** - Small issues, typos
- **README updates** - Repetitive documentation changes
- **Code formatting** - Linting, style changes
- **Dependency updates** - Package version bumps
- **Merge commits** - Git housekeeping
- **Temporary changes** - Debug commits, experiments

### Maintenance Script
Here's a simple script I use to maintain the development timeline:

```bash
#!/bin/bash

# Development Timeline Maintenance Script
# This script helps maintain the clean-development-timeline branch

set -e

echo "Development Timeline Maintenance"
echo "================================"

# Check if we're on main
if [[ $(git branch --show-current) != "main" ]]; then
    echo "❌ Error: Must be on main branch"
    echo "Please run: git checkout main"
    exit 1
fi

# Ensure we're up to date
echo "📥 Updating main branch..."
git pull origin main

# Get recent commits
echo ""
echo "📋 Recent commits on main:"
echo "------------------------"
git log --oneline -10

echo ""
echo "🔍 Which commits should be added to the development timeline?"
echo "Enter commit hashes to cherry-pick (space-separated, or 'all' for last 5):"
read -r commit_input

# Process commit selection
if [[ "$commit_input" == "all" ]]; then
    # Get last 5 commits
    commits=($(git log --oneline -5 --format="%H"))
    echo "✅ Selected last 5 commits"
else
    # Parse space-separated commit hashes
    commits=($commit_input)
    echo "✅ Selected ${#commits[@]} commits"
fi

# Validate commits exist
for commit in "${commits[@]}"; do
    if ! git rev-parse --verify "$commit" >/dev/null 2>&1; then
        echo "❌ Error: Commit $commit does not exist"
        exit 1
    fi
done

# Switch to timeline branch
echo ""
echo "🔄 Switching to clean-development-timeline branch..."
git checkout clean-development-timeline
git pull origin clean-development-timeline

# Cherry-pick selected commits
echo ""
echo "🍒 Cherry-picking commits..."
for commit in "${commits[@]}"; do
    commit_msg=$(git log --format="%s" -n 1 "$commit")
    echo "  📝 $commit_msg"
    
    if git cherry-pick "$commit"; then
        echo "  ✅ Successfully cherry-picked"
    else
        echo "  ❌ Failed to cherry-pick $commit"
        echo "  🔄 Aborting cherry-pick..."
        git cherry-pick --abort
        echo "  💡 You may need to resolve conflicts manually"
        exit 1
    fi
done

# Show updated timeline
echo ""
echo "📊 Updated development timeline:"
echo "-------------------------------"
git log --oneline -5

# Push updates
echo ""
echo "🚀 Pushing updates to remote..."
git push origin clean-development-timeline

echo ""
echo "✅ Timeline updated successfully!"
echo ""
echo "📈 Current timeline stats:"
echo "  - Total commits: $(git rev-list --count HEAD)"
echo "  - Latest commit: $(git log --oneline -1)"
echo ""
echo "🔗 View timeline: https://github.com/WillyBarankin/homelab/tree/clean-development-timeline"
```

## Quality Control

### Before Updating Timeline:
1. **Review commit messages** - Ensure they're clear and descriptive
2. **Check commit size** - Avoid huge commits, prefer logical chunks
3. **Verify functionality** - Ensure each commit represents working code
4. **Test timeline branch** - Make sure everything still works

### Timeline Guidelines:
- **Keep it manageable** - 20-25 commits maximum
- **Maintain chronological order** - Shows development progression
- **Self-contained commits** - Each should be functional on its own
- **Clear commit messages** - Use conventional commit format

## Regular Maintenance

### Monthly Review:
```bash
# Review timeline branch
git checkout clean-development-timeline
git log --oneline

# Consider if any commits should be squashed
# Remove outdated or irrelevant commits
```

### Quarterly Cleanup:
- **Check timeline length** - Should stay under 25 commits
- **Review commit quality** - Remove low-quality commits
- **Update this guide** - Keep documentation current
- **Archive old features** - Consider squashing old features

## Backup and Recovery

### If Timeline Gets Messed Up:
```bash
# Restore from backup
git checkout backup-before-squash
git checkout -b clean-development-timeline-new

# Recreate timeline with meaningful commits
# (Use the same process as initial creation)
```

## Best Practices

### Commit Messages
Use conventional commit format:
```
type: description

feat: add new authentication system
fix: resolve SSL certificate issue
docs: update deployment guide
refactor: improve Kubernetes deployment
```

### Branch Naming
- **Feature branches**: `feature/description`
- **Bug fixes**: `fix/description`
- **Documentation**: `docs/description`
- **Infrastructure**: `infra/description`

### Maintenance Schedule
- **Weekly**: Review recent commits for timeline inclusion
- **Monthly**: Clean up timeline branch
- **Quarterly**: Major timeline assessment

## Why This Approach?

This strategy helps me keep the homelab repository organized while showing how the infrastructure evolved. It's a practical way to:

- **Keep main branch clean** and easy to follow
- **Show development progression** for anyone interested in the project
- **Preserve complete history** in case you need to look back
- **Make maintenance simple** and sustainable

The key is **selective inclusion** - I only add commits that truly represent meaningful progress in building the homelab infrastructure. 