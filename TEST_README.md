# Firewall Manual Disable Test

This test validates the functionality for manually disabling the firewall from settings.

## Overview

The test suite verifies that:
1. Firewall can be disabled via environment variable (`COPILOT_AGENT_FIREWALL_ENABLED=false`)
2. Firewall can be disabled via settings configuration file
3. Firewall status can be checked and confirmed as disabled
4. Manual disable settings persist across checks

## Test Files

- `test_firewall_manual_disable.py` - Main test script
- `example_firewall_settings.json` - Example configuration showing firewall disable settings

## Running the Test

### Locally
```bash
# Run with environment variable (simulates workflow environment)
COPILOT_AGENT_FIREWALL_ENABLED=false python3 test_firewall_manual_disable.py

# Run without environment variable (tests settings file approach)
python3 test_firewall_manual_disable.py
```

### In GitHub Workflow

The test is automatically executed as part of the `copilot-setup-steps` workflow when:
- The workflow is manually triggered
- Changes are pushed to the workflow file
- Pull requests are opened that modify the workflow

## Test Results

The test will output:
- ✅ PASS for successful test cases
- ❌ FAIL for failed test cases
- Summary of total tests passed/failed
- Overall success/failure status

## Settings Configuration

The firewall can be manually disabled through a settings file with the following structure:

```json
{
  "firewall": {
    "enabled": false,
    "manually_disabled": true,
    "disabled_by": "user_settings",
    "disabled_timestamp": "2024-01-01T00:00:00Z"
  },
  "security": {
    "allow_manual_firewall_disable": true
  }
}
```

## Integration

This test integrates with the existing Copilot setup workflow and validates that firewall disable functionality works as expected in the containerized environment.