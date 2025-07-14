# Authelia Configuration & User Management Guide

## Overview
This document describes the configuration setup for Authelia in this repository and provides a short guide for managing users and passwords.

---

## Configuration Structure

- **All configuration files are located in:** `homelab/docker/authelia/`
- **Sensitive and environment-specific values** are stored in `.env` (not present in the repository; excluded from version control for security, as it contains secrets and credentials).
- **Main configuration template:** `configuration.yml` (uses `${VAR}` placeholders)
- **Generated config for Authelia:** `configuration.generated.yml` (created from the template and `.env`)
- **User database:** `users_database.yml` (not present in the repository; excluded from version control because it contains user credentials and password hashes).
- **Config generation script:** `generate_configuration.sh`

---

## How Configuration Generation Works

1. **Edit `.env`** to set all secrets, domains, and environment-specific values.
2. **Run the config generation script:**
   ```sh
   ./generate_configuration.sh
   ```
   This will create `configuration.generated.yml` with all variables replaced by their values from `.env`.
3. **Start Authelia with Docker Compose:**
   ```sh
   docker-compose up -d
   ```
   Make sure your `docker-compose.yml` mounts `configuration.generated.yml` as the config file for Authelia.

---

## User Management

### User Database File
- Users are defined in `users_database.yml`.
- This file contains user credentials, password hashes, and group assignments.

### Creating a New User / Changing Passwords

1. **Generate a password hash** using Authelia's built-in tool:
   ```sh
   docker run --rm authelia/authelia:latest authelia hash-password 'yourpassword'
   ```
   - Replace `'yourpassword'` with the desired password.
   - Copy the resulting hash.

2. **Edit `users_database.yml`** and add or update a user entry:
   ```yaml
   users:
     yourusername:
       password: <paste-the-hash-here>
       displayname: "Your Name"
       email: your@email.com
       groups:
         - admins
         - users
   ```
   - To change a password, simply update the `password` field with a new hash.

3. **Save the file.**

4. **Restart Authelia** (if running):
   ```sh
   docker-compose restart authelia
   ```

---

## Tips
- **Never store plain-text passwords** in `users_database.yml`—always use password hashes.
- **Keep `.env` and `users_database.yml` secure** and out of version control. 
- **To add groups or change user permissions,** edit the `groups` list for each user.

---

## References
- [Authelia Documentation](https://www.authelia.com/docs/)
- [Password Hashing Guide](https://www.authelia.com/docs/configuration/authentication/passwords/) 