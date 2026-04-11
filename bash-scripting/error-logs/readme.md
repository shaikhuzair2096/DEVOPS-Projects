# Log Monitoring & Alerting Script

## Overview

This project is a lightweight, production-oriented shell script designed to monitor application/system logs and alert on error patterns. It scans log files within a specified directory, identifies recent error entries, and triggers an email notification when issues are detected.

The script is intentionally simple but structured to reflect real-world DevOps practices: validation, automation, and alerting.

---

## Problem Statement

In many environments, logs grow rapidly and critical errors can go unnoticed without monitoring. This script provides a minimal, extensible solution to:

* Detect errors in recent logs
* Automate checks using cron
* Notify stakeholders when issues arise

---

## Features

* Recursive scan of `.log` files
* Time-based filtering (last 2 days)
* Case-insensitive error detection
* Error count and sample extraction
* Email-based alerting
* Works both interactively and via cron

---

## Script Behavior

1. Accepts a directory path (argument or user input)
2. Validates directory existence
3. Searches `.log` files modified in the last 2 days
4. Extracts lines containing `"ERROR"`
5. Counts total matches
6. Sends an email alert if errors are found

---

## Usage

### Interactive Mode

```bash
./script.sh
```

### Non-Interactive Mode

```bash
./script.sh /var/log
```

---

## Cron Integration

Example: run every 30 minutes

```bash
*/30 * * * * /path/to/script.sh /var/log >> /var/log/monitor.log 2>&1
```

Notes:

* Always use absolute paths in cron
* Output is redirected for audit/debugging

---

## Dependencies

* `find`
* `grep`
* `mail` (or compatible mail utility)

Install (Debian/Ubuntu):

```bash
sudo apt install mailutils
```

---

## Email Configuration

This script relies on a configured SMTP setup (e.g., via `ssmtp` or system mail relay). In production environments, email delivery is typically handled via:

* Internal SMTP relay
* External providers (e.g., SendGrid, SES)

---

## Example Output

Script output:

```
scanning logs for last 2 days
Errors found: 5
```

Email content:

```
Found 5 errors

Sample:
app.log: ERROR database timeout
worker.log: ERROR connection refused
```

---

## Design Notes

* Uses `find` instead of `ls` for reliability in scripting
* Avoids interactive input when arguments are provided (cron-safe)
* Suppresses permission errors to reduce noise
* Limits email content to a sample to prevent overload

---

## Limitations

* No state tracking (may send duplicate alerts)
* Relies on basic pattern matching ("ERROR")
* Email setup depends on system configuration

---

## Possible Enhancements

* Add threshold-based alerting
* Implement state file to avoid duplicate notifications
* Integrate with Slack/Webhooks instead of email
* Add structured logging (JSON parsing with `jq`)
* Containerize for portability

---

## Summary

This script demonstrates a practical approach to log monitoring using standard Unix tools. It is intentionally minimal but structured in a way that mirrors patterns used in production systems: validation, automation, and alerting.

---
