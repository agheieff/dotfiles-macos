#!/bin/bash

# Get memory stats using vm_stat (more accurate, matches htop)
VM_STAT=$(vm_stat)
PAGESIZE=$(vm_stat | grep "page size" | awk '{print $8}')
TOTAL_MEM=$(sysctl -n hw.memsize | awk '{print int($1/1073741824)}')

# Extract memory values
PAGES_FREE=$(echo "$VM_STAT" | grep "Pages free" | awk '{print $3}' | sed 's/\.//')
PAGES_ACTIVE=$(echo "$VM_STAT" | grep "Pages active" | awk '{print $3}' | sed 's/\.//')
PAGES_INACTIVE=$(echo "$VM_STAT" | grep "Pages inactive" | awk '{print $3}' | sed 's/\.//')
PAGES_SPECULATIVE=$(echo "$VM_STAT" | grep "Pages speculative" | awk '{print $3}' | sed 's/\.//')
PAGES_WIRED=$(echo "$VM_STAT" | grep "Pages wired down" | awk '{print $4}' | sed 's/\.//')
PAGES_COMPRESSED=$(echo "$VM_STAT" | grep "Pages occupied by compressor" | awk '{print $5}' | sed 's/\.//')

# Calculate used memory (active + wired + compressed)
USED_PAGES=$((PAGES_ACTIVE + PAGES_WIRED + PAGES_COMPRESSED))
USED_MEM=$(echo "scale=1; $USED_PAGES * $PAGESIZE / 1073741824" | bc)

sketchybar --set $NAME label="${USED_MEM}/${TOTAL_MEM}GB"