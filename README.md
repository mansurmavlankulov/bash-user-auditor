# Linux User Auditor

A dependency-free Bash script for auditing local user accounts on a Linux host. It surfaces the account-related information a security reviewer looks at first — real login users, who holds sudo access, and whether any account has an empty password — and writes the findings to a timestamped report file.

Built as a fast, readable first-pass audit tool for **authorized** system hardening and security assessments.

---

## Features

- **Pure Bash** — no external dependencies, runs on any standard Linux system
- **Root-privilege check** — refuses to run without the privileges it needs (reading `/etc/shadow`), with a clear message
- **Normal user enumeration** — lists real login accounts (UID ≥ 1000), separating them from system accounts
- **Sudo access audit** — reports every member of the `sudo` group
- **Empty-password detection** — flags any account with a blank password field in `/etc/shadow` (a critical misconfiguration)
- **Timestamped report** — prints results to the screen and saves them to `audit_report.txt`, tagged with hostname and generation time

---

## Requirements

- A Linux system with Bash
- Root privileges (needed to read `/etc/shadow`)

---

## Usage

Run with root privileges:

```bash
sudo bash user_auditor.sh
```

Sample output:

```
==========================================
  LINUX USER AUDIT REPORT
  Generated: 2026-07-05 14:32:10
  Hostname: kali
==========================================

[*] Normal users (UID >= 1000):
----------------------------------------
  Username: mansur               UID: 1000

[*] Users with sudo access:
----------------------------------------
  Username: mansur               [sudo group]

[*] Users with empty passwords (RISK!):
----------------------------------------
  [+] No empty-password users found. System is secure.

[+] Report saved: audit_report.txt
```

---

## What it checks and why

| Check | Why it matters |
|-------|----------------|
| Normal users (UID ≥ 1000) | Identifies real human/login accounts vs. system accounts, a baseline for any account review |
| Sudo group members | Excessive sudo access is a common privilege-escalation risk; this shows exactly who can escalate |
| Empty passwords | An account with no password is a critical, immediately exploitable misconfiguration |

All findings are written to `audit_report.txt` so they can be attached to an assessment report or tracked over time.

---

## Roadmap

Planned improvements as the project evolves:

- Detect accounts with UID 0 other than `root` (hidden superusers)
- Flag users with expired or never-expiring passwords (`chage` / `/etc/shadow` aging fields)
- Audit world-writable files and SUID/SGID binaries
- Optional JSON/CSV output for reporting pipelines
- Command-line flags to run individual checks

---

## ⚠️ Legal & Ethical Notice

This script is intended **only** for use on systems you own or have **explicit, written authorization** to audit. Reading `/etc/shadow` and enumerating accounts on a system you do not control may violate computer-misuse laws.

You are solely responsible for how you use this tool. Run it on your own lab, on machines you control, or within the defined scope of an authorized engagement — nowhere else.

---

## Author

Built by **Mansur Mavlankulov** — cybersecurity student focused on offensive security and red teaming, working toward OSCP.

- GitHub: [@mansurmavlankulov](https://github.com/mansurmavlankulov)
