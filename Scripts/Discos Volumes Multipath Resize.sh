################################################################################
COMANDOS DE OURO — Discos, LVM, Resize, Multipath

################################################################################
#1. AUMENTAR FISICAMENTE NO VMWARE OU STORAGE
Aumente o disco pela interface do vSphere ou console do storage. Para LUNs, certifique-se que a expansão foi concluída e publicada.

################################################################################
#2. RECONHECER AUMENTO OU INCLUSÃO NO LINUX (SEM REBOOT)
Reiniciar reconhece, mas é possível evitar isso com:

# Usar utilitário dedicado (sg3_utils)
yum install -y sg3_utils
/usr/bin/rescan-scsi-bus.sh -a

# Método manual: echo em sysfs
for dev in /sys/class/scsi_device/*/device/rescan; do
  echo 1 > "$dev"
done

for host in /sys/class/scsi_host/host*/scan; do
  echo "- - -" > "$host"
done

sleep 5
for dev in /sys/block/*/device/rescan; do
  echo 1 > "$dev"
done

# Verificar reconhecimento no log
tail -n 1000 /var/log/messages | grep -i "sd"
dmesg | grep sd

# Validar via disco e partição
lsblk
fdisk -l

################################################################################
#3. AUMENTAR PARTIÇÃO (NÃO-LVM)

- Usando growpart (ext2/3/4, xfs):
yum install -y cloud-utils-growpart
growpart /dev/sda 3

- Usando parted manualmente:
parted /dev/sdb
(parted) print free
(parted) resizepart <partição> <último setor>
e2fsck -f /dev/sdb1
resize2fs /dev/sdb1

################################################################################
#4. AUMENTAR LVM

- Verificar estrutura:
pvs
vgs
lvs -a -o +devices
lvdisplay

- Expandir Logical Volume:
lvextend -L +10G /dev/mapper/vg_data-lv_data
ou
lvextend -l +100%FREE /dev/mapper/vg_data-lv_data

- Expandir filesystem:
resize2fs /dev/mapper/vg_data-lv_data  # EXT4
xfs_growfs /mnt/data                   # XFS
fsadm resize /dev/mapper/vg_data-lv_data  # Genérico

################################################################################
#5. VOLUME MULTIPATH — VERIFICAÇÃO E EXPANSÃO

- Listar volumes multipath:
multipath -ll

- Obter WWN do disco:
scsi_id -g -u /dev/sdX

- Editar /etc/multipath.conf para nomear:
multipaths {
  multipath {
    wwid    3600c0ff00012825e6d7e3c6901000000
    alias   BKP_ORACLE
  }
}

- Aplicar nova config:
multipath -r
systemctl reload multipathd

################################################################################
#6. EXPANSÃO DE VOLUME MULTIPATH EXISTENTE

- Detectar novo tamanho:
multipathd resize map /dev/mapper/BKP_ORACLE

- Validar novo tamanho:
multipath -ll BKP_ORACLE
lsblk

- Redimensionar PV, LV e FS:
pvresize /dev/mapper/BKP_ORACLE
lvextend -l +100%FREE -r /dev/vg_data/lv_bkp

################################################################################
#7. OUTROS COMANDOS ÚTEIS

lsblk -f
blkid
ls -l /dev/mapper/
readlink /dev/mapper/mpathX
pvcreate /dev/mapper/mpathX
vgcreate vg_data /dev/mapper/mpathX
lvcreate -L 100G -n lv_data vg_data
mkfs.xfs /dev/vg_data/lv_data
mount /dev/vg_data/lv_data /mnt/data
ls -l /dev/disk/by-id/
partprobe /dev/sdX

################################################################################
#7. SWAP
fallocate -l 8G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile

echo '/swapfile none swap sw 0 0' >> /etc/fstab

