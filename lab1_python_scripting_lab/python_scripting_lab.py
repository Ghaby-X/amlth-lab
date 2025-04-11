import os
import requests
import shutil
from datetime import datetime


# cleaning and creation of directory
download_folder = 'gabriel_anyaele'
if os.path.exists(download_folder):
    try:
        shutil.rmtree(download_folder)
        print(f"Directory '{download_folder}' has been removed successfully.")
    except Exception as e:
        print(f"Error: {e}")

if not os.path.exists(download_folder):
    os.makedirs(download_folder)
    print(f'Directory: {download_folder} created.')


# download resource
local_file_path = os.path.join(download_folder, "gabriel_anyaele.txt")
url = "https://raw.githubusercontent.com/sdg000/pydevops_intro_lab/main/change_me.txt"
response = requests.get(url)

if response.status_code == 200:
    print(f"File successfully downloaded. ")

    with open(local_file_path, 'wb') as file:
        file.write(response.content)
        print('File saved successfully')
else:
    print(f'Failed to download file. Status code: {response.status_code}')


# overwrite file content
user_input = input("Describe what you have learned so far in a sentence: ")
now = datetime.now()
current_time = now.strftime("%Y-%m-%d %H:%M:%S")

with open(local_file_path, "w") as file:
    file.write(user_input + "\n")
    file.write(f"Last modified on: {current_time}")
print("File successfully modified.")


# display the updated file content
with open(local_file_path, "r") as file:
    print("\nYou Entered: ", end=' ')
    print(file.read())