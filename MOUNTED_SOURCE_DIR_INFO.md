# MOUNTED_SOURCE_DIR Environment Variable Information

## Overview

The `MOUNTED_SOURCE_DIR` environment variable in this repository points to the cloned repository directory and is used in the GitHub Actions workflow setup.

## Current Value

```
MOUNTED_SOURCE_DIR=/__w/wip-tests/wip-tests
```

## Details

- **Purpose**: This variable is set in the GitHub Actions workflow (`.github/workflows/copilot-setup-steps.yml`) to indicate the location of the source code repository
- **Set by**: The workflow step "Set MOUNTED_SOURCE_DIR" which runs `echo "MOUNTED_SOURCE_DIR=$(pwd)" >> $GITHUB_ENV`
- **Location**: Points to the root of the cloned repository
- **Contents**: Contains the full repository including:
  - `.git/` directory (Git repository metadata)
  - `.github/` directory (GitHub Actions workflows)
  - `README.md` (Repository documentation)
  - Any other repository files

## Directory Information

- **Path**: `/__w/wip-tests/wip-tests`
- **Size**: ~272K
- **Files**: 37 files total
- **Directories**: 29 directories total
- **Permissions**: `drwxr-xr-x` (755) owned by runner:runner
- **Mount Point**: Part of `/dev/root` filesystem mounted at `/__w`

## Usage in Workflow

The variable is referenced in the workflow file at line 52:
```yaml
- name: Run basic validation
  run: |
    echo "=== Basic Validation ==="
    echo "Repository validation completed successfully"
    echo "Copilot setup steps executed"
    echo $MOUNTED_SOURCE_DIR
```

## Related Environment Variables

Only one mount-related environment variable is currently set:
- `MOUNTED_SOURCE_DIR=/__w/wip-tests/wip-tests`

## How to Check

To view the current value and details of `MOUNTED_SOURCE_DIR`, you can:

1. Run the provided script: `./show_mounted_source_dir.sh`
2. Check the environment variable directly: `echo $MOUNTED_SOURCE_DIR`
3. List the contents: `ls -la $MOUNTED_SOURCE_DIR`

## Context

This setup is part of a GitHub Copilot configuration where the workflow:
1. Runs in a container (`ghcr.io/actions/actions-runner:latest`)
2. Mounts volumes for workspace access
3. Checks out the repository code
4. Sets the `MOUNTED_SOURCE_DIR` to the current working directory
5. Uses this variable for subsequent operations