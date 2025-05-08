# IAM User Setup Script

This Bash script automates the creation of Linux user accounts, group assignments, and email notifications from a CSV input file. It is ideal for onboarding users in bulk for system administration tasks.

## Features

- Reads user information from a CSV file
- Creates new user accounts
- Assigns users to groups (creates the group if it doesn't exist)
- Sets a temporary password
- Enforces password change at first login
- Restricts home directory permissions
- Sends email notifications to users

## Prerequisites

- Linux system with `bash`, `mail`, and root privileges
- CSV input file with the following headers (no spaces)

    Nb: Headers are necessary in the csv files as the first line is skipped

- A working mail service configured on your machine (e.g., `mailutils`) [optional]

## Local Usage
- To use, first clone the repository and navigate to "bash_scripting_lab" using;
```bash
git clone https://github.com/Ghaby-X/amlth-lab.git && cd amlth-lab/bash_scripting_lab
```

- Add execution permission to iam_setup.sh script and run with elevated privileges
```bash
chmod +x iam_setup.sh
sudo ./iam_setup.sh path/to/users.csv
```

- Your sample csv file should look like this;
```bash
username,fullname,group,email
jdoe,John Doe,developers,jdoe@example.com
asmith,Alice Smith,admins,asmith@example.com
```

