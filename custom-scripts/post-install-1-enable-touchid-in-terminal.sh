#!/bin/sh
set -e

#Insert TouchId as first auth method if not already present
grep -qF 'pam_tid.so' /etc/pam.d/sudo || {
    echo "Enable TouchId for sudo commands" ;
    sudo sed -i -e '1s;^;auth       sufficient     pam_tid.so # This enables TouchId in console\n;' /etc/pam.d/sudo ;
}