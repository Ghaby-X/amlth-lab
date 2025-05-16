# Bash Scripts for file management

This project is a collection of reusable Bash scripts for common file and system operations such as file renaming, backup, sorting, disk analysis, encryption, and synchronization.

## Project Files

- `bulk_file_renamer.sh` – Rename multiple files with a pattern.
- `file_backup.sh` – Create backups of files or directories.
- `file_sorter.sh` – Sort files by type into subfolders.
- `space_analyzer` – Analyze disk space usage.
- `duplicate_file_finder.sh` – Find duplicate files by content.
- `file_encrypt.sh` – Encrypt and decrypt files using OpenSSL.
- `file_sync.sh` – Synchronize two directories.

---

## Script Descriptions & Usage

### 1.  `bulk_file_renamer.sh`

Renames files in bulk using a prefix, suffix, or pattern.

**Usage:**
```bash
./bulk_file_renamer.sh [OPTIONS]
```

Options
- ```p``` append a prefix
- ```s``` append a suffix
- ```d``` specify a directory
- ```ctr``` include a counter and dateflag
- ```r``` regex find
- ```f``` regex replace



### 2. `duplicate_file_finder.sh`

find all duplicate files and perform (move | delete) action on them

**Usage:**
```bash
./duplicate_file_finder.sh
```


### 3. `file_backup.sh`

makes partial or full backup of a directory

**Usage:**
```bash
./file_backup.sh [OPTIONS]
```

Options
- ```s``` include source directory
- ```d``` include destination directory
- ```m``` specify mode of backup ( full | partial)
- ```i``` include additional file
- ```e``` exclude specific file
- ```l``` specify logfile


### 4. `file_encrypt.sh`

Encrypt and decrypt a file

**Usage:**
```bash
./file_encrypt.sh [OPTIONS]
```

Options
- ```e``` specify mode as encrypt
- ```d``` specify mode as decrypt
- ```i``` takes in an input file
- ```o``` takes in an output file



### 5. `file_sorter.sh`

organize files according to their extensions into the Images, Audio, Videos, Documents, Archives directory

**Usage:**
```bash
./file_sorter.sh <directory>
```


### 6. `file_sync.sh`

synchronizes two directories

**Usage:**
```bash
./file_sync.sh <directory1> <directory2>
```


### 7. `space_analyzer.sh`

display the size of files within a directory

**Usage:**
```bash
./space_analyzer.sh [OPTIONS]
```

Options
- ```p``` include directory
- ```m``` filter by min size
- ```d``` specify max tree depth of display
- ```t``` show only top N largest entries

## Run locally
1. Clone this repository and change directory to  file_management_bash_scripting
  ```
  git clone https://github.com/Ghaby-X/amlth-lab.git && cd file_management_bash_scripting
  ```

2. Modify permissions of files
  ```
  chmod +x *.sh
  ```

3. Run desired script
