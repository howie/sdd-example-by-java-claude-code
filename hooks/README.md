# Git Hooks

This directory contains Git hooks that can be installed in your local repository.

## Pre-push Hook

The `pre-push` hook runs tests and linting checks before allowing a push to the remote repository.

### Installation

To install the pre-push hook, run:

```bash
cp hooks/pre-push .git/hooks/pre-push && chmod +x .git/hooks/pre-push
```

### What it does

The pre-push hook will:
1. Run all tests using `./gradlew test`
2. Run Checkstyle linting using `./gradlew checkstyleMain checkstyleTest`

If either check fails, the push will be aborted.

### Bypassing the hook

If you need to push without running the checks (not recommended), you can use:

```bash
git push --no-verify
```

## Automatic Installation

You can also add the installation command to your project setup documentation to ensure all developers install the hook.
