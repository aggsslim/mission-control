#!/bin/bash
# Snapshot /api/state lokal -> state.json publik (GitHub Pages), refresh oleh cron watchdog
set -e; cd "$(dirname "$0")"
curl -s http://127.0.0.1:3001/api/state | python3 -c "
import sys,json
d=json.load(sys.stdin)
try:
  d['vps']['tunnel']={'url':'https://aggsslim.github.io/mission-control/','online':True,'note':'Mirror publik GitHub Pages — snapshot data, refresh ±5 menit oleh watchdog. Kontrol (pause/queue) hanya di versi lokal.'}
except Exception: pass
d['public_mirror']={'type':'snapshot','source':'http://127.0.0.1:3001/api/state'}
json.dump(d,open('state.json','w'),ensure_ascii=False)
"
git add -A
git diff --cached --quiet || { git commit -q -m "snapshot $(date +%FT%T%z)"; git push -q origin main; echo pushed; }
