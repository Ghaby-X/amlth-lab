#!/bin/bash

LOG_FILE="iam_setup.log"
INPUT_FILE=$1
TEMPORARY_PASSWORD="Hello@World"
USER_EMAIL="gabriel.anyaele@amalitechtraining.org"

# =============== Functions ================
send_user_email() {
  local username="$1"
  local group="$2"
  local user_email="$3"

  local subject="Your new account on $(hostname)"
  local body="Hello $username,

  Your account has been successfully created and added to the group '$group'.

  You can now log in using your assigned credentials.
  Username: $username
  Password: $TEMPORARY_PASSWORD

  Please make sure to change your password after your first login.

  Best regards,
  Admin Team"

  echo "$body" | mail -s "$subject" "$user_email"
  log "Welcome email sent to '$username' at '$user_email'"
}

# log function to forward logs to log_file
log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}


# ================== checks ======================

# check if log file exists and create otherwise
if [[ ! -f "$LOG_FILE" ]]; then
  touch $LOG_FILE
  log "log file '$LOG_FILE' has been created!"
fi


# check for presence of input file
if [[ ! -f "$INPUT_FILE" ]]; then
  log "Input file '$INPUT_FILE' not found!"
  exit 1
fi

# ======== CSV parsing and user management logic =============

# read each line from input file
while IFS="," read -r username fullname group email
do

  # check if each entry have a length > 0
  if [[ -z $username || -z $fullname || -z $group ]] then
    log "Can not create user, an entry is missing"
    continue
  fi

  # Ensure group exists - if it does not, create new group
  if ! getent group "$group" > /dev/null; then
    groupadd "$group"
    log "Group '$group' created."
  fi


  if ! id "$username"; then
    # creates a user and adds to group
    useradd -m -c "$fullname" -g "$group" "$username"
    log "User '$username' created and added to group '$group'."

    # creates default password
    echo "$username:$TEMPORARY_PASSWORD" | chpasswd
    log "Temporary password set for user '$username'."

    # enforce password change upon initial login
    chage -d 0 "$username"
    log "Password change enforced for user '$username'."

    # Ensure user home directory is only accessible to user 
    chmod 700 "/home/$username"
    log "Permissions set on /home/$username."


  # check if the user has an email and notify him
  if [[ ! -z $email ]] then
    send_user_email $username $group $USER_EMAIL
    log "Email notification sent to $email"
  fi

  else
    log "User '$username' already exists."
  fi

done < <(tail -n +2 $INPUT_FILE) # reads from the input file (ignores headers)