#!/bin/sh
set -eu

target=${1-none}

if [ "$target" = none ]; then
    # Build 'em all
    for m in StarwindRemasteredV1.15 base_StarwindRemasteredPatch nomq_StarwindRemasteredPatch; do
        echo "Building $m"
        tes3conv "$m".json "$m".esm
    done
else
    tes3conv StarwindRemasteredV1.15.json StarwindRemasteredV1.15.esm
    # Build a specific thing
    if [ "$target" = "vanilla" ]; then
        tes3conv base_StarwindRemasteredPatch.json base_StarwindRemasteredPatch.esm

    elif [ "$target" = "tsi" ]; then
        tes3conv nomq_StarwindRemasteredPatch.json nomq_StarwindRemasteredPatch.esm
        ./tools/deadcountList.sh
    fi
fi
