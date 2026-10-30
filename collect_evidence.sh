#!/bin/bash
# Usage:  bash collect_evidence.sh /foss/designs/runs/RUN_xxxx   (the run that passed)
# Copies layout + DRC/LVS evidence from ONE run into layout/ and evidence/, then zips the package.
set -e
RUN="$1"; [ -d "$RUN/final" ] || { echo "give the run folder (it must contain final/)"; exit 1; }
cd "$(dirname "$0")"
mkdir -p layout evidence
cp "$RUN/final/gds/tcam_top.gds" layout/
cp "$RUN/final/mag/tcam_top.mag" layout/
cp "$RUN/final/metrics.json" evidence/
for f in $(cd "$RUN" && find . -type f \( -name 'drc*.rpt' -o -name 'lvs*.rpt' -o -name 'manufacturability.rpt' -o -name '*drc*.xml' \) | sed 's|^\./||'); do
  cp "$RUN/$f" "evidence/$(echo "$f" | tr '/' '_')"
done
cp "$RUN/resolved.json" evidence/resolved_config.json
echo "RUN used: $(basename "$RUN")" > evidence/README_evidence.txt
ls -l layout evidence
cd ..; zip -qr "$(basename "$OLDPWD").zip" "$(basename "$OLDPWD")" -x '*.vvp' -x '*.vcd' && echo "created $(pwd)/$(basename "$OLDPWD").zip"
