import os
from dotenv import load_dotenv

load_dotenv()

PORT = os.getenv('PORT')

# MYSQL configurations
mysql_host = os.getenv('MYSQL_HOST')
mysql_user = os.getenv('MYSQL_USER')
mysql_password = os.getenv('MYSQL_PASSWORD')
mysql_database = os.getenv('MYSQL_DATABASE')