import json
import datetime
import random
import string

class IAMUtilities:
    @staticmethod
    def generate_complex_password(length=16):
        """
        Generate a complex password meeting enterprise security standards
        """
        characters = string.ascii_letters + string.digits + string.punctuation
        password = ''.join(random.choice(characters) for i in range(length))
        
        # Ensure password complexity
        while not (any(c.isupper() for c in password) and 
                   any(c.islower() for c in password) and 
                   any(c.isdigit() for c in password) and 
                   any(c in string.punctuation for c in password)):
            password = ''.join(random.choice(characters) for i in range(length))
        
        return password

    @staticmethod
    def audit_access_permissions(users):
        """
        Audit user access permissions and generate report
        """
        audit_report = {
            'audit_date': datetime.datetime.now().isoformat(),
            'total_users': len(users),
            'access_levels': {},
            'suspicious_activities': []
        }

        for user in users:
            # Count access levels
            access_level = user.get('access_level', 'undefined')
            audit_report['access_levels'][access_level] = \
                audit_report['access_levels'].get(access_level, 0) + 1

            # Simulate suspicious activity detection
            if user.get('last_login_days', 0) > 90:
                audit_report['suspicious_activities'].append({
                    'username': user['username'],
                    'reason': 'Inactive account'
                })

        return audit_report

    @staticmethod
    def export_report(report, filename='iam_audit_report.json'):
        """
        Export audit report to JSON
        """
        with open(filename, 'w') as f:
            json.dump(report, f, indent=4)
        print(f"Report exported to {filename}")

# Example usage
if __name__ == "__main__":
    # Sample users data
    users = [
        {'username': 'john.doe', 'access_level': 'admin', 'last_login_days': 120},
        {'username': 'jane.smith', 'access_level': 'user', 'last_login_days': 30},
        {'username': 'mike.johnson', 'access_level': 'contractor', 'last_login_days': 60}
    ]

    # Generate a complex password
    new_password = IAMUtilities.generate_complex_password()
    print(f"Generated Password: {new_password}")

    # Run access audit
    audit_report = IAMUtilities.audit_access_permissions(users)
    IAMUtilities.export_report(audit_report)
