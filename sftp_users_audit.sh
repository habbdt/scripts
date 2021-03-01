#!/bin/bash

###################READ_ME##############
# simple bash script to check
# (1) sftp users exists or not
# (2) login activities if users exists
# further validation required
###################END##################

SFTP_GROUP="$(egrep 'Match Group' /etc/ssh/sshd_config | awk '{print $NF}')"
SFTP_USERS="$(egrep $SFTP_GROUP /etc/group | cut -d ":" -f4 | tr ',' '\n')"
DATE_TODAY="$(date '+%Y-%m-%d')"

echo "$HOSTNAME"
echo "USERNAME, STATE, LOGIN_ACTIVITY,AUDIT_DATE"

function sftp_user() {
    for usr in $SFTP_USERS ; do
      USER_CHK_PASSWD="$(egrep -i $usr /etc/passwd)"
      if [ -z "$USER_CHK_PASSWD" ]
      then
        echo "$usr,NON-EXISTENT,$DATE_TODAY"
      else
        USER_LOGIN="$(egrep -E  "Accepted password for $usr" /var/log/secure* \
                     | cut -d ":" -f2  | sort -M | head -n1)"
        if [ -z "$USER_LOGIN" ]
        then
          echo "$usr, EXISTS, NO_LOGIN_30_DAYS,$DATE_TODAY"
        else
          echo "$usr, EXISTS, $USER_LOGIN,$DATE_TODAY"
        fi
      fi
    done
}

# run

sftp_user