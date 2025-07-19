# Homepage Configuration & Customization Guide

## Overview
This document describes the configuration setup for the Homepage service in this repository and provides a short guide for managing bookmarks, widgets, and customizations.

---

## Configuration Structure

- **All configuration files are located in:** `homelab/docker/homepage/`
- **Main configuration files:**
  - `docker-compose.yml`: Service definition for Homepage.
  - `config/`: Directory containing all Homepage configuration files.
    - `bookmarks.yaml`: List of bookmarks displayed on the homepage.
    - `services.yaml`: Service cards and their settings.
    - `settings.yaml`: General settings for Homepage.
    - `widgets.yaml`: Widget configuration.
    - `custom.css`, `custom.js`: Custom styles and scripts.
    - `icons/`: Custom icons for services/widgets.
- **Sensitive or environment-specific files** (if any, such as API keys or secrets) should be stored in a `.env` file (not present in the repository; excluded from version control for security).

---

## How to Add or Update Bookmarks

1. **Edit `bookmarks.yaml`:**
   - Add new entries or update existing ones using the YAML structure.
   - Example:
     ```yaml
     - name: My Project
       url: https://myproject.example.com
       icon: project
     ```
2. **Save the file.**
3. **Restart the Homepage container** if running via Docker Compose:
   ```sh
   docker-compose restart
   ```

---

## How to Add or Update Widgets

1. **Edit `widgets.yaml`:**
   - Add or modify widget entries as needed.
2. **Save the file and restart the container** to apply changes.

---

## Customizing Appearance

- **Edit `custom.css`** for custom styles.
- **Edit `custom.js`** for custom scripts.
- **Add icons** to the `icons/` directory for use in bookmarks or widgets.

---

## Security Note
- If you use API keys, secrets, or other sensitive data, store them in a `.env` file and reference them in your configuration if supported. Do **not** commit `.env` or other sensitive files to the repository.

---

## References
- [Homepage Documentation](https://gethomepage.dev/latest/) 