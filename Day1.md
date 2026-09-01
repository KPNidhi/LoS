# Day-1: User and System Investigation, User Creation & Group Management

**Date:** 01.09.2026

---

## Part A — User and System Investigation

### 1. Determine the current username

```bash
whoami
```

### 2. Display UID, primary GID, and supplementary groups

```bash
id
```

### 3. Display all users currently logged in

```bash
who
```

### 4. Determine what activities logged-in users are performing

```bash
w
```

### 5. Examine `/etc/passwd` for the current account

```bash
grep "^$(whoami):" /etc/passwd
```

### 6. Count user-account entries in `/etc/passwd`

```bash
wc -l /etc/passwd
```

### 7. Display only username and UID fields

```bash
cut -d: -f1,3 /etc/passwd
```

### 8. Find all accounts with UID 0

```bash
awk -F: '$3 == 0 {print $1}' /etc/passwd
```

### 9. Compare `/etc/passwd` and `/etc/shadow`

```bash
cat /etc/passwd
```

```bash
sudo cat /etc/shadow
```

---

# Part B — Creating and Verifying Users

### 1. Create Alice, Bob, and Charlie with home directories

```bash
sudo useradd -m alice
sudo useradd -m bob
sudo useradd -m charlie
```

### 2. Verify all three users were added to `/etc/passwd`

```bash
grep -E '^(alice|bob|charlie):' /etc/passwd
```

### 3. Determine the UID of each user

```bash
id alice
id bob
id charlie
```

### 4. Determine Alice's home directory and default shell

```bash
grep '^alice:' /etc/passwd
```

### 5. Inspect `/home` and verify home directories

```bash
ls -l /home
```

### 6. Set passwords for all three users

```bash
sudo passwd alice
sudo passwd bob
sudo passwd charlie
```

### 7. Switch to Alice using a login shell

```bash
su - alice
```

### 8. Verify the account switch

```bash
whoami
pwd
```

### 9. Return to the original account

```bash
exit
```

---

# Part C — Group Management and Access Control

### 1. Create the `security` and `developers` groups

```bash
sudo groupadd security
sudo groupadd developers
```

### 2. Add Alice and Charlie to `security`

```bash
sudo usermod -aG security alice
sudo usermod -aG security charlie
```

### 3. Add Bob to `developers`

```bash
sudo usermod -aG developers bob
```

### 4. Verify group membership of all three users

```bash
id alice
id bob
id charlie
```

### 5. Display `security` and `developers` entries from `/etc/group`

```bash
grep -E '^(security|developers):' /etc/group
```

### 6. Add Bob to `security` without removing `developers`

```bash
sudo usermod -aG security bob
```

### 7. Verify Bob belongs to both groups

```bash
id bob
```

or:

```bash
groups bob
```

### 8. Verify both group entries again

```bash
grep -E '^(security|developers):' /etc/group
```

---

## Important Option

### `-aG` in `usermod`

```bash
sudo usermod -aG groupname username
```

* `-G` → specify supplementary groups
* `-a` → **append** the group without removing existing memberships

Always use `-aG` when adding a user to an additional group.
