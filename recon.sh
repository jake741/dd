#!/bin/bash
set -euo pipefail

# ---- Colors ----
GREEN="\e[32m"
RED="\e[31m"
NC="\e[0m"

# ---- Args ----
TARGET="${1:-}"
MODE="${2:-}"

# ---- Config ----
PROXY_URL="http://127.0.0.1:8080"
HTTPX_THREADS=50
HTTPX_TIMEOUT=15
NAABU_RATE=1000

OUTDIR="${TARGET}_recon"

log()   { echo -e "${GREEN}[+] $1${NC}"; }
error() { echo -e "${RED}[!] $1${NC}" >&2; }

# ---- Check args ----
if [[ -z "$TARGET" ]]; then
    error "Usage: $0 <domain> [proxy]"
    exit 1
fi

# ---- Tool check ----
for tool in subfinder assetfinder alterx httprobe ; do
    command -v $tool >/dev/null || {
        error "$tool not found in PATH"
        exit 1
    }
done

# ---- Setup ----
log "Starting recon for $TARGET"
rm -rf "$OUTDIR"
mkdir -p "$OUTDIR"
cd "$OUTDIR"

# ---- Subdomain Enumeration ----
log "Running subfinder"
subfinder -all -silent -d "$TARGET" -silent -o subfinder.txt > /dev/null

log "Running assetfinder"
assetfinder --subs-only "$TARGET" >> assetfinder.txt > /dev/null 

log "Merging subdomains"
sort -u subfinder.txt assetfinder.txt | tee all_subs.txt > /dev/null

# ---- Alterx ----
log "Running alterx"
alterx -l all_subs.txt -silent -o alterx.txt
# ---- Merge All Subdomains ----
cat all_subs.txt alterx.txt | sort -u > all_subs.txt

# ---- HTTP Probe ----
log "Probing live HTTP services"
pv all_subs.txt | httprobe -c $HTTPX_THREADS -prefer-https >> httpx.txt

if [[ "$MODE" == "proxy" ]]; then
    log "Using proxy $PROXY_URL"
    HTTPX_OPTS+=(-proxy "$PROXY_URL")
fi

#httpx "${HTTPX_OPTS[@]}" > httpx.txt

# ---- Extract Hosts for Naabu ----
#awk -F[/:] '{print $4}' httpx.txt | sort -u > hosts.txt

# ---- Validate ----
#if [[ ! -s hosts.txt ]]; then
 #   error "No live hosts found — skipping port scan"
  #  touch live_hosts.txt
   # exit 0
#fi

#
#---- Port Scan ----
#log "Scanning ports with naabu"
#naabu -l hosts.txt -silent -rate "$NAABU_RATE" -o live_hosts.txt

# ---- Ensure output exists ----
#touch live_hosts.txt


#python3 ~/python/test_2_links.py live_hosts.txt "$TARGET"
# ---- Cleanup ----
log "Cleaning up temporary files"
rm -f $OUTDIR/subfinder.txt $OUTDIR/assetfinder.txt $OUTDIR/subs.txt $OUTDIR/alterx.txt $OUTDIR/all_subs.txt $OUTDIR/hosts.txt

# ---- Done ----
log "Recon completed successfully"
log "Results saved to: $OUTDIR/httpx.txt"
