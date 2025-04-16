from dotenv import load_dotenv
import os

load_dotenv()

api_key = f"{os.environ['MJ_APIKEY_PUBLIC']}"
api_secret = f"{os.environ['MJ_APIKEY_PRIVATE']}"

SENDER_EMAIL=os.environ['SENDER_EMAIL']
RECIPIENT_EMAIL=os.environ['RECIPIENT_EMAIL']