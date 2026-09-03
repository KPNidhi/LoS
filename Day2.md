# Day-2: File Ownership and Access Control

**Topics:** `chown`, `chgrp`, Ownership + Permissions

---

# Part A — Ownership Investigation

### 1. Create the `ownership_lab` directory

```bash
mkdir ownership_lab
cd ownership_lab
```

### 2. Create the required files

```bash
touch incident_report.txt network.log credentials.txt
```

### 3. Display detailed information for the files

```bash
ls -l
```

### 4. Identify Owner, Group, and Permissions

```bash
ls -l incident_report.txt network.log credentials.txt
```

Format:

```text
-rw-r--r--  owner  group  filename
```

### 5. Determine the UID and GID of the current user

```bash
id
```

Or separately:

```bash
id -u
id -g
```

### 6. Compare current UID/GID with file ownership

```bash
id
ls -ln
```

`ls -n` displays the numeric UID and GID instead of usernames.

### 7. Check file permissions separately

```bash
stat incident_report.txt
```

---

# Part B — `chown`: Changing Ownership

> Use `sudo` for changing file ownership.

### 1. Change owner of `incident_report.txt` to Alice

```bash
sudo chown alice incident_report.txt
```

### 2. Change owner of `network.log` to Bob

```bash
sudo chown bob network.log
```

### 3. Change owner of `credentials.txt` to Charlie

```bash
sudo chown charlie credentials.txt
```

### 4. Verify ownership changes

```bash
ls -l
```

Or:

```bash
ls -l incident_report.txt network.log credentials.txt
```

### 5. Try changing ownership without `sudo`

```bash
chown bob incident_report.txt
```

Expected result for an ordinary user:

```text
Operation not permitted
```

### 6. Configure `incident_report.txt` with Alice as owner and `security` as group

```bash
sudo chown alice:security incident_report.txt
```

### 7. Verify owner and group

```bash
ls -l incident_report.txt
```

Expected format:

```text
-rw-r--r-- alice security incident_report.txt
```

---

# Part C — `chgrp`: Changing Group Ownership

### 1. Change group of `network.log` to `developers`

```bash
sudo chgrp developers network.log
```

### 2. Change group of `credentials.txt` to `security`

```bash
sudo chgrp security credentials.txt
```

### 3. Verify group ownership

```bash
ls -l network.log credentials.txt
```

### 4. Display Alice's group memberships

```bash
groups alice
```

### 5. Display Bob's group memberships

```bash
groups bob
```

### 6. Display Charlie's group memberships

```bash
groups charlie
```

### 7. Log in as Alice

```bash
su - alice
```

### 8. Create `alice_report.txt`

```bash
touch alice_report.txt
```

### 9. Check ownership and group

```bash
ls -l alice_report.txt
```

### 10. Attempt to change group to `security`

```bash
chgrp security alice_report.txt
```

### 11. Attempt to change group to `developers`

```bash
chgrp developers alice_report.txt
```

### 12. Check the final ownership

```bash
ls -l alice_report.txt
```

### 13. Return to the original account

```bash
exit
```

---

# Part D — Ownership + Permission Investigation

## 1. Configure `incident_report.txt`

Required:

```text
-rw-r----- alice security incident_report.txt
```

Command:

```bash
sudo chown alice:security incident_report.txt
sudo chmod 640 incident_report.txt
```

Verify:

```bash
ls -l incident_report.txt
```

Expected:

```text
-rw-r----- alice security incident_report.txt
```

---

## 2. Identify permissions for Alice, Charlie, and Bob

```bash
ls -l incident_report.txt
```

Permission breakdown:

```text
-rw-r-----
 ||| ||| |||
 ||| ||| +++ Others
 ||| +++----- Group
 +++--------- Owner
```

Therefore:

```text
Alice   → rw- → Read + Write
Security group → r-- → Read only
Others  → --- → No access
```

Since Charlie belongs to `security`:

```text
Charlie → Read only
```

If Bob belongs to neither `security` nor the owner:

```text
Bob → No file permissions
```

---

# 3. Test Charlie's ability to read

Switch to Charlie:

```bash
su - charlie
```

Try:

```bash
cat /path/to/ownership_lab/incident_report.txt
```

Expected:

```text
Read succeeds
```

---

# 4. Test Charlie's ability to modify

```bash
echo "Charlie test" >> /path/to/ownership_lab/incident_report.txt
```

Expected:

```text
Permission denied
```

Charlie has `r--`, not `rw-`.

---

# 5. Test Charlie's ability to delete

```bash
rm /path/to/ownership_lab/incident_report.txt
```

Expected:

```text
Permission denied
```

**Important:** deleting a file depends primarily on the **write + execute permissions of the containing directory**, not the file's own write permission.

---

# 6. Change permissions to `-rw-rw----`

Exit Charlie's session:

```bash
exit
```

Then run:

```bash
sudo chmod 660 incident_report.txt
```

Verify:

```bash
ls -l incident_report.txt
```

Expected:

```text
-rw-rw---- alice security incident_report.txt
```

---

# 7. Test Charlie's access again

Switch to Charlie:

```bash
su - charlie
```

### Read

```bash
cat /path/to/ownership_lab/incident_report.txt
```

### Modify

```bash
echo "Charlie test" >> /path/to/ownership_lab/incident_report.txt
```

Both should now succeed because Charlie belongs to `security`, and the group now has:

```text
rw-
```

### Delete

```bash
rm /path/to/ownership_lab/incident_report.txt
```

Whether this succeeds depends on the **permissions of ****`ownership_lab`**, not the `660` permission of the file itself.

---

# 8. Remove Bob from the `security` group

First return to your original account:

```bash
exit
```

Remove Bob:

```bash
sudo gpasswd -d bob security
```

Verify:

```bash
groups bob
```

---

# 9. Test Bob's access again

Switch to Bob:

```bash
su - bob
```

Try reading:

```bash
cat /path/to/ownership_lab/incident_report.txt
```

Try modifying:

```bash
echo "Bob test" >> /path/to/ownership_lab/incident_report.txt
```

Expected:

```text
Permission denied
```

Return to original account:

```bash
exit
```

---

# Useful Verification Commands

### Show ownership and permissions

```bash
ls -l
```

### Show numeric UID/GID

```bash
ls -ln
```

### Show detailed file metadata

```bash
stat incident_report.txt
```

### Show a user's groups

```bash
groups alice
groups bob
groups charlie
```

### Show group information

```bash
getent group security
getent group developers
```

### Check a user's complete identity and groups

```bash
id alice
id bob
id charlie
```

---


# Important Commands to Remember

```bash
# Change owner
sudo chown alice file

# Change owner + group
sudo chown alice:security file

# Change group
sudo chgrp security file

# Change permissions
sudo chmod 640 file
sudo chmod 660 file

# Check ownership/permissions
ls -l file

# Check numeric UID/GID
ls -ln file

# Check groups
groups username

# Check complete user information
id username

# Remove user from group
sudo gpasswd -d username groupname
```
