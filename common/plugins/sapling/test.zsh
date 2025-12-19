#!/usr/bin/env zsh

# Test script for Sapling plugin
# This tests the logic without actually rendering the p10k segment

source ~/.oh-my-zsh/custom/plugins/sapling/sapling.plugin.zsh

echo "=== Testing Sapling Plugin ==="
echo ""

# Test 1: Check if we're in a repo
echo "Test 1: Checking if in Sapling repo..."
if in_sapling_repo; then
  echo "✓ In a Sapling repository"
else
  echo "✗ Not in a Sapling repository"
  exit 1
fi
echo ""

# Test 2: Get repo info
echo "Test 2: Getting repository information..."
REPO_ROOT=$(sl root 2>/dev/null)
echo "Repository root: $REPO_ROOT"
echo ""

# Test 3: Get current bookmark/commit
echo "Test 3: Current bookmark/commit..."
BOOKMARK=$(sl log -r . -T '{activebookmark}' 2>/dev/null)
if [[ -z "$BOOKMARK" ]]; then
  COMMIT=$(sl log -r . -T '{shortest(node, 7)}' 2>/dev/null)
  echo "No bookmark, commit: $COMMIT"
else
  echo "Bookmark: $BOOKMARK"
fi
echo ""

# Test 4: Check for changes
echo "Test 4: Checking for uncommitted changes..."
if sl status -q 2>/dev/null; then
  echo "✓ Repository is clean"
else
  echo "✗ Repository has uncommitted changes"
fi
echo ""

# Test 5: Check commit phase
echo "Test 5: Checking commit phase..."
PHASE=$(sl log -r . -T '{phase}' 2>/dev/null)
echo "Commit phase: $PHASE"
if [[ "$PHASE" == "public" ]]; then
  echo "Icon would be: ◆ (public)"
else
  echo "Icon would be: ⎇ (draft)"
fi
echo ""

# Test 6: Check for operations
echo "Test 6: Checking for ongoing operations..."
if [[ -d "$REPO_ROOT/.sl/merge" ]]; then
  echo "⚠ Currently merging"
elif [[ -d "$REPO_ROOT/.sl/rebase" ]]; then
  echo "⚠ Currently rebasing"
else
  echo "✓ No ongoing operations"
fi
echo ""

# Test 7: Test aliases
echo "Test 7: Testing defined aliases..."
alias | grep "^sl" | while read line; do
  echo "  $line"
done
echo ""

# Test 8: Detailed status
echo "Test 8: Detailed status function..."
echo "---"
sapling_status_detailed
echo "---"
echo ""

echo "=== All tests completed ==="
