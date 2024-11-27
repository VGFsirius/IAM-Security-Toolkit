#!/bin/bash

# IAM Security Utility Scripts

# Function to check user account status
check_account_status() {
    local username=$1
    
    # Check if user exists
    if id "$username" &>/dev/null; then
        # Get account details
        echo "Account Details for $username:"
        echo "----------------------------"
        
        # Last login information
        last_login=$(lastlog -u "$username" | awk 'NR>1 {print $4, $5, $6, $7}')
        if [ -z "$last_login" ]; then
            echo "Last Login: Never logged in"
        else
            echo "Last Login: $last_login"
        fi
        
        # Account expiry
        chage -l "$username" | grep "Account expires"
        
        # Password status
        passwd -S "$username"
    else
        echo "User $username does not exist"
        return 1
    fi
}

# Function to audit sudo access
audit_sudo_access() {
    echo "Sudo Access Audit Report"
    echo "----------------------"
    
    # List users with sudo privileges
    echo "Users with sudo access:"
    getent group sudo | cut -d: -f4 | tr ',' '\n'
    
    # Detailed sudo log analysis
    echo -e "\nRecent sudo usage:"
    grep -E 'COMMAND|SUDO' /var/log/auth.log | tail -n 10
}

# Function to generate security report
generate_security_report() {
    local report_file="security_report_$(date +%Y%m%d).txt"
    
    echo "Generating Comprehensive Security Report: $report_file"
    
    {
        echo "Security Report Generated on $(date)"
        echo "====================================="
        
        echo -e "\n1. ACTIVE USER ACCOUNTS"
        awk -F: '($3 >= 1000) && ($3 != 65534) {print $1}' /etc/passwd | while read -r user; do
            echo "- $user"
        done
        
        echo -e "\n2. SUDO ACCESS AUDIT"
        getent group sudo | cut -d: -f4
        
        echo -e "\n3. RECENT LOGIN ACTIVITIES"
        last -a | head -n 10
        
        echo -e "\n4. FAILED LOGIN ATTEMPTS"
        lastb | head -n 10
        
    } > "$report_file"
    
    echo "Report generated at $report_file"
}

# Main script execution
case "$1" in
    "check-user")
        check_account_status "$2"
        ;;
    "sudo-audit")
        audit_sudo_access
        ;;
    "security-report")
        generate_security_report
        ;;
    *)
        echo "Usage: $0 {check-user USERNAME|sudo-audit|security-report}"
        exit 1
        ;;
esac
