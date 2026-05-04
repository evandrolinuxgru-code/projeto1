vim /usr/local/sbin/mem_cleanup.sh

#!/usr/bin/env bash
set -euo pipefail

# Percentual mínimo de MemAvailable para NÃO executar limpeza
MIN_PCT=20

# Log simples de execução
LOG=/var/log/mem_cleanup.log

# Coleta memória total (KB) e disponível (KB) via procfs
read TOTAL_KB AVAIL_KB <<< $(awk '
/MemTotal/ {t=$2}
/MemAvailable/ {a=$2}
END {print t, a}
' /proc/meminfo)

# Percentual disponível
AVAIL_PCT=$(( AVAIL_KB * 100 / TOTAL_KB ))

# Se memória >= limite, sai sem ação
[ "$AVAIL_PCT" -ge "$MIN_PCT" ] && exit 0

# Flush de buffers para disco (syscall sync)
sync

# Limpa pagecache + dentries + inodes (vm.drop_caches=3)
echo 3 > /proc/sys/vm/drop_caches

# Reavalia memória disponível após limpeza
AVAIL_AFTER_KB=$(awk '/MemAvailable/ {print $2}' /proc/meminfo)

# Swap usada atual (KB)
SWAP_USED_KB=$(free -k | awk '/Swap:/ {print $3}')

# Só recicla swap se:
# 1) houver swap em uso
# 2) houver RAM livre suficiente para absorver todo swap
if [ "$SWAP_USED_KB" -gt 0 ] && [ "$AVAIL_AFTER_KB" -ge "$SWAP_USED_KB" ]; then
    swapoff -a && swapon -a
fi

# Registro de auditoria
printf "%s avail_before=%s%% swap_used=%sKB\n" \
"$(date '+%F %T')" "$AVAIL_PCT" "$SWAP_USED_KB" >> "$LOG"
