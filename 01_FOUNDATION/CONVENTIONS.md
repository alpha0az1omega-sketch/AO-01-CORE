# PROJECT CONVENTIONS - ALPHA0AZ1OMEGA

## 1. Language Policy
- **Code, Comments & Documentation**: English (Universal standard for AI, developers, and open-source collaboration).
- **Variable Naming**: camelCase for variables, PascalCase for classes.
- **File Naming**: kebab-case (e.g., generate-sceau.sh).
- **AI & Human Interaction**: Any communication intended for the public repository must be in English.

## 2. Time & Date
- All timestamps must be in UTC and ISO 8601 format (YYYY-MM-DDTHH:MM:SSZ).

## 3. Security & Signatures
- Every Git commit must be cryptographically signed using the GPG key of the human signer.
- No secrets (keys, passwords, tokens) are allowed on the disk. Secrets must remain volatile.

## 4. Commit Messages
- Use Conventional Commits format:
  - feat: for new features
  - fix: for bug fixes
  - docs: for documentation
  - chore: for maintenance
