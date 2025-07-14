#!/bin/bash
set -a && source .env && set +a && envsubst < configuration.yml > configuration.generated.yml
