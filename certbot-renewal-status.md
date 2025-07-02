# Certbot Automatic Renewal Status

## Systemd Timer and Service

- **Timer:** `certbot.timer` is enabled and scheduled to run twice daily (at midnight and noon) with a randomized delay up to 12 hours.
- **Service:** `certbot.service` runs `/usr/bin/certbot -q renew` to attempt renewal of all certificates.

## Renewal Configuration

- **Domain:** `example.com-0001`
- **Renewal Config File:** `/etc/letsencrypt/renewal/example.com-0001.conf`
- **Authenticator:** `certbot-regru:dns` (REG.RU DNS plugin)
- **Automation:** Fully automated DNS-01 challenge, provided API credentials are set up correctly.

## Recent Renewal Logs

- On **June 17**, renewal failed due to a challenge error:
  > Failed to renew certificate example.com-0001 with error: Some challenges have failed.
  > DNS problem: NXDOMAIN looking up TXT for _acme-challenge.example.com

- After increasing DNS propagation wait time to 300 seconds, both certificates renewed successfully:
  > Congratulations, all simulated renewals succeeded:
  > /etc/letsencrypt/live/example.com-0001/fullchain.pem (success)
  > /etc/letsencrypt/live/example.com/fullchain.pem (success)

## DNS Propagation Fix

- **Issue:** Wildcard certificate renewal was failing due to insufficient DNS propagation wait time (120 seconds).
- **Solution:** Increased DNS propagation wait time to 300 seconds using `--certbot-regru:dns-propagation-seconds 300`.
- **Result:** Both certificates now renew successfully.

## Recommendations

- Ensure REG.RU API credentials are valid and accessible to Certbot.
- Periodically check renewal logs for errors.
- If you change DNS providers or plugins, update the renewal config accordingly.
- **For DNS propagation issues:** Use `--certbot-regru:dns-propagation-seconds 300` (or higher) if your DNS provider is slow to propagate changes.