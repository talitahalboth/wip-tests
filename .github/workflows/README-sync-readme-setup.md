# Sync README Workflow Setup

This document describes how to set up GPG commit signing for the `sync-readme.yml` workflow.

## Required Secrets

The workflow requires the following secrets to be configured in the repository settings:

### 1. TARGET_REPO_PAT
- **Description**: Personal Access Token (PAT) with write access to the target repository
- **Required Permissions**: 
  - `repo` (Full control of private repositories)
  - `workflow` (if the target repository has workflows)

### 2. GPG_PRIVATE_KEY
- **Description**: Your GPG private key in ASCII-armored format
- **How to generate**:
  ```bash
  # Generate a new GPG key (if you don't have one)
  gpg --full-generate-key
  
  # Export the private key in ASCII-armored format
  gpg --armor --export-secret-keys YOUR_KEY_ID
  ```
- **Note**: Copy the entire output including the `-----BEGIN PGP PRIVATE KEY BLOCK-----` and `-----END PGP PRIVATE KEY BLOCK-----` lines

### 3. GPG_PASSPHRASE
- **Description**: The passphrase for your GPG private key
- **Note**: If your GPG key doesn't have a passphrase, you can omit this secret or set it to an empty string

## How to Add Secrets

1. Go to your repository settings
2. Navigate to `Settings` > `Secrets and variables` > `Actions`
3. Click `New repository secret`
4. Add each of the required secrets listed above

## GPG Key Setup

### Generate a New GPG Key

```bash
# Start GPG key generation
gpg --full-generate-key

# Follow the prompts:
# - Select key type: (1) RSA and RSA (default)
# - Key size: 4096
# - Key expiration: 0 (does not expire) or set a custom expiration
# - Enter your name and email (should match your GitHub account email)
# - Enter a passphrase (recommended for security)
```

### Export Your GPG Key

```bash
# List your GPG keys to get the key ID
gpg --list-secret-keys --keyid-format=long

# Export the private key (replace YOUR_KEY_ID with your actual key ID)
gpg --armor --export-secret-keys YOUR_KEY_ID

# Export the public key (to add to GitHub)
gpg --armor --export YOUR_KEY_ID
```

### Add GPG Key to GitHub

1. Go to GitHub Settings > SSH and GPG keys
2. Click `New GPG key`
3. Paste your public GPG key (output from `gpg --armor --export YOUR_KEY_ID`)
4. Click `Add GPG key`

## Verification

After setting up the secrets and running the workflow:
1. Check the workflow run logs to ensure the GPG key import step succeeds
2. Navigate to the PR created in the target repository
3. View the commit details - it should show a "Verified" badge if the signature is valid

## Troubleshooting

### GPG Key Import Fails
- Verify that `GPG_PRIVATE_KEY` includes the complete key block
- Check that the `GPG_PASSPHRASE` is correct
- Ensure the key hasn't expired

### Commit is Not Signed
- Verify that `commit-gpg-sign: true` is set in the `create-pull-request` action
- Check that the GPG key import step completed successfully
- Ensure the git user email matches the email in your GPG key

### "Unverified" Signature on GitHub
- Add your GPG public key to GitHub (see "Add GPG Key to GitHub" section)
- Ensure the email in your GPG key matches a verified email in your GitHub account
