# README Sync Workflow

This workflow automatically syncs the README.md file from this repository to the [wip-tests-2](https://github.com/talitahalboth/wip-tests-2) repository.

## How it works

The workflow (`sync-readme.yml`) is triggered:
- Manually via the GitHub Actions UI (workflow_dispatch)
- Automatically when README.md is pushed to the main branch

When triggered, it:
1. Checks out this repository (wip-tests)
2. Checks out the target repository (wip-tests-2)
3. Copies the README.md file from wip-tests to wip-tests-2
4. Creates a pull request in wip-tests-2 with the updated README.md

## Setup Required

To use this workflow, you need to create a GitHub Personal Access Token (PAT) with the following permissions:
- `repo` (full control of private repositories)
- `workflow` (if the target repository has workflows)

### Steps to set up:

1. Create a Personal Access Token:
   - Go to GitHub Settings → Developer settings → Personal access tokens → Tokens (classic)
   - Click "Generate new token (classic)"
   - Give it a descriptive name (e.g., "wip-tests sync workflow")
   - Select the `repo` scope
   - Generate the token and copy it

2. Add the token as a repository secret:
   - Go to this repository's Settings → Secrets and variables → Actions
   - Click "New repository secret"
   - Name: `TARGET_REPO_PAT`
   - Value: Paste the token you created
   - Click "Add secret"

3. The workflow is now ready to use!

## Manual Trigger

To manually trigger the workflow:
1. Go to the Actions tab in this repository
2. Select "Sync README to wip-tests-2" workflow
3. Click "Run workflow"
4. Select the branch and click "Run workflow"

The workflow will create a PR in wip-tests-2 with the current README.md content.
