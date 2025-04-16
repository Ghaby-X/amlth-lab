import config
from mailjet_rest import Client

api_key = config.api_key
api_secret = config.api_secret

mailjet = Client(auth=(api_key, api_secret), version='v3.1')

def send_alert(subject, message):
    data = {
    'Messages': [
                {
                    "From": {
                        "Email": f"{config.SENDER_EMAIL}",
                        "Name": "24/7 SysMon"
                    },
                    "To": [
                        {
                            "Email": f"{config.RECIPIENT_EMAIL}",
                            "Name": "Admin"
                        }
                    ],
                    "Subject": f"{subject}",
                    "HTMLPart": f"<h3>{message}</h3>"
                }
            ]
    }

    try: 
        result = mailjet.send.create(data=data) 
        print(f"Email sent: {result.status_code}") 
    except Exception as e: 
        print(f"Failed to send email: {str(e)}")
    
    
    return result