# wip-tests

A test repository for demonstrating GitHub workflow automation, specifically for syncing README files across repositories.

## Purpose

This repository contains a GitHub Actions workflow that automatically syncs the README.md file to the [wip-tests-2](https://github.com/talitahalboth/wip-tests-2) repository. This is useful for:

- Keeping documentation synchronized across related repositories
- Testing GitHub Actions workflows
- Demonstrating automated PR creation

## Features

- **Automatic README Sync**: Automatically creates a PR in the target repository when README.md is updated
- **Manual Trigger**: Can be manually triggered via GitHub Actions UI
- **Automated PR Creation**: Uses the peter-evans/create-pull-request action for seamless integration

## Workflow Information

The sync workflow is triggered:
- Automatically when README.md is pushed to the main branch
- Manually via the GitHub Actions UI (workflow_dispatch)

For detailed setup instructions and workflow documentation, see [.github/workflows/README-sync.md](.github/workflows/README-sync.md).

## Contributing

This is a test repository. Feel free to explore the workflows and use them as a reference for your own projects.