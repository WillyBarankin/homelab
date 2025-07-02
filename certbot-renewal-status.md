# Certbot Automatic Renewal Status

## Systemd Timer and Service

- **Timer:** `certbot.timer` is enabled and scheduled to run twice daily (at midnight and noon) with a randomized delay up to 12 hours.
- **Service:** `certbot.service` runs `/usr/bin/certbot -q renew` to attempt renewal of all certificates.

## Renewal Configuration

- **Domain:** `willybar.ru-0001`
- **Renewal Config File:** `/etc/letsencrypt/renewal/willybar.ru-0001.conf`
- **Authenticator:** `certbot-regru:dns` (REG.RU DNS plugin)
- **Automation:** Fully automated DNS-01 challenge, provided API credentials are set up correctly.

## Recent Renewal Logs

- On **June 17**, renewal failed due to a challenge error:
  > Failed to renew certificate willybar.ru-0001 with error: Some challenges have failed.
- After June 17, all subsequent Certbot runs completed successfully (no renewal needed or no errors reported).

## Dry-Run Test

- Running `certbot renew --dry-run` simulates the renewal process:
  - The plugin `certbot-regru:dns` is used.
  - The process waits for DNS propagation.
  - No errors reported in the dry-run output, indicating the setup is correct if DNS/API credentials are valid.

### DNS Propagation Fix

- **Issue:** Wildcard certificate renewal was failing due to insufficient DNS propagation wait time (120 seconds).
- **Solution:** Increased DNS propagation wait time to 300 seconds using `--certbot-regru:dns-propagation-seconds 300`.
- **Result:** Both certificates now renew successfully:
  ```
  Congratulations, all simulated renewals succeeded: 
    /etc/letsencrypt/live/willybar.ru-0001/fullchain.pem (success)
    /etc/letsencrypt/live/willybar.ru/fullchain.pem (success)
  ```

## Summary Table

| Component         | Status/Setting                        | Comment                                 |
|-------------------|---------------------------------------|-----------------------------------------|
| certbot.timer     | Twice daily, randomized delay         | ✅ Correctly set up                     |
| certbot.service   | Runs `certbot -q renew`               | ✅ Standard, correct                    |
| Renewal config    | `authenticator = certbot-regru:dns`   | ✅ Automated DNS challenge (REG.RU)     |
| Manual needed?    | ❌ No, if plugin is configured         | Fully automated if API creds are set    |

## Recommendations

- Ensure REG.RU API credentials are valid and accessible to Certbot.
- Periodically check renewal logs for errors.
- If you change DNS providers or plugins, update the renewal config accordingly.
- **For DNS propagation issues:** Use `--certbot-regru:dns-propagation-seconds 300` (or higher) if your DNS provider is slow to propagate changes.

---

_Last updated: July 2, 2024_ 