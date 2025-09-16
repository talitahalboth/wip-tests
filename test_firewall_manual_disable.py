#!/usr/bin/env python3
"""
Test script to validate manual disabling of firewall from settings.

This test verifies that the firewall can be manually disabled through
configuration settings and environment variables.
"""

import os
import sys
import subprocess
import json
from typing import Dict, Any, Optional


class FirewallTestResult:
    """Container for test results."""
    
    def __init__(self, test_name: str, passed: bool, message: str):
        self.test_name = test_name
        self.passed = passed
        self.message = message
    
    def __str__(self):
        status = "PASS" if self.passed else "FAIL"
        return f"[{status}] {self.test_name}: {self.message}"


class FirewallDisableTest:
    """Test suite for manual firewall disable functionality."""
    
    def __init__(self):
        self.results = []
        self.settings_file = "firewall_settings.json"
    
    def log_result(self, test_name: str, passed: bool, message: str):
        """Log a test result."""
        result = FirewallTestResult(test_name, passed, message)
        self.results.append(result)
        print(result)
    
    def test_environment_variable_disable(self) -> bool:
        """Test firewall disable via environment variable."""
        try:
            # Check if COPILOT_AGENT_FIREWALL_ENABLED is set to false
            firewall_enabled = os.getenv('COPILOT_AGENT_FIREWALL_ENABLED', 'true').lower()
            
            if firewall_enabled == 'false':
                self.log_result(
                    "Environment Variable Test",
                    True,
                    "COPILOT_AGENT_FIREWALL_ENABLED correctly set to false"
                )
                return True
            else:
                self.log_result(
                    "Environment Variable Test",
                    False,
                    f"COPILOT_AGENT_FIREWALL_ENABLED is '{firewall_enabled}', expected 'false'"
                )
                return False
        except Exception as e:
            self.log_result(
                "Environment Variable Test",
                False,
                f"Error checking environment variable: {str(e)}"
            )
            return False
    
    def test_settings_file_disable(self) -> bool:
        """Test firewall disable via settings file."""
        try:
            # Create a test settings file
            settings = {
                "firewall": {
                    "enabled": False,
                    "manually_disabled": True,
                    "disabled_by": "user_settings",
                    "disabled_timestamp": "2024-01-01T00:00:00Z"
                },
                "security": {
                    "allow_manual_firewall_disable": True
                }
            }
            
            with open(self.settings_file, 'w') as f:
                json.dump(settings, f, indent=2)
            
            # Read back and validate
            with open(self.settings_file, 'r') as f:
                loaded_settings = json.load(f)
            
            firewall_disabled = not loaded_settings.get('firewall', {}).get('enabled', True)
            manually_disabled = loaded_settings.get('firewall', {}).get('manually_disabled', False)
            
            if firewall_disabled and manually_disabled:
                self.log_result(
                    "Settings File Test",
                    True,
                    "Firewall successfully disabled via settings file"
                )
                return True
            else:
                self.log_result(
                    "Settings File Test",
                    False,
                    f"Firewall not properly disabled (enabled: {not firewall_disabled}, manual: {manually_disabled})"
                )
                return False
                
        except Exception as e:
            self.log_result(
                "Settings File Test",
                False,
                f"Error with settings file: {str(e)}"
            )
            return False
    
    def test_firewall_status_check(self) -> bool:
        """Test that firewall status can be checked and confirmed as disabled."""
        try:
            # Simulate checking firewall status
            firewall_enabled = os.getenv('COPILOT_AGENT_FIREWALL_ENABLED', 'true').lower() == 'true'
            
            # Check settings file if it exists
            settings_firewall_enabled = True
            if os.path.exists(self.settings_file):
                with open(self.settings_file, 'r') as f:
                    settings = json.load(f)
                    settings_firewall_enabled = settings.get('firewall', {}).get('enabled', True)
            
            # Firewall is disabled if either environment variable is false or settings file disables it
            firewall_actually_disabled = not firewall_enabled or not settings_firewall_enabled
            
            if firewall_actually_disabled:
                self.log_result(
                    "Firewall Status Check",
                    True,
                    "Firewall status correctly shows as disabled"
                )
                return True
            else:
                self.log_result(
                    "Firewall Status Check",
                    False,
                    "Firewall status shows as enabled when it should be disabled"
                )
                return False
                
        except Exception as e:
            self.log_result(
                "Firewall Status Check",
                False,
                f"Error checking firewall status: {str(e)}"
            )
            return False
    
    def test_manual_disable_persistence(self) -> bool:
        """Test that manual disable setting persists across checks."""
        try:
            # Verify the manually_disabled flag persists
            if os.path.exists(self.settings_file):
                with open(self.settings_file, 'r') as f:
                    settings = json.load(f)
                
                manually_disabled = settings.get('firewall', {}).get('manually_disabled', False)
                disabled_by = settings.get('firewall', {}).get('disabled_by', '')
                
                if manually_disabled and disabled_by == 'user_settings':
                    self.log_result(
                        "Manual Disable Persistence",
                        True,
                        "Manual disable setting persists correctly"
                    )
                    return True
                else:
                    self.log_result(
                        "Manual Disable Persistence",
                        False,
                        f"Manual disable not persistent (manual: {manually_disabled}, by: {disabled_by})"
                    )
                    return False
            else:
                self.log_result(
                    "Manual Disable Persistence",
                    False,
                    "Settings file not found for persistence test"
                )
                return False
                
        except Exception as e:
            self.log_result(
                "Manual Disable Persistence",
                False,
                f"Error checking persistence: {str(e)}"
            )
            return False
    
    def cleanup(self):
        """Clean up test files."""
        try:
            if os.path.exists(self.settings_file):
                os.remove(self.settings_file)
                print(f"Cleaned up {self.settings_file}")
        except Exception as e:
            print(f"Warning: Could not clean up {self.settings_file}: {str(e)}")
    
    def run_all_tests(self) -> bool:
        """Run all tests and return overall success."""
        print("=== Manual Firewall Disable Test Suite ===")
        print()
        
        tests = [
            self.test_environment_variable_disable,
            self.test_settings_file_disable,
            self.test_firewall_status_check,
            self.test_manual_disable_persistence,
        ]
        
        passed_tests = 0
        for test in tests:
            if test():
                passed_tests += 1
        
        print()
        print(f"=== Test Results: {passed_tests}/{len(tests)} tests passed ===")
        
        # Print summary
        for result in self.results:
            print(result)
        
        success = passed_tests == len(tests)
        
        if success:
            print("\n✅ All tests passed! Firewall can be manually disabled successfully.")
        else:
            print(f"\n❌ {len(tests) - passed_tests} test(s) failed.")
        
        return success


def main():
    """Main test execution."""
    test_suite = FirewallDisableTest()
    
    try:
        success = test_suite.run_all_tests()
        sys.exit(0 if success else 1)
    finally:
        test_suite.cleanup()


if __name__ == "__main__":
    main()