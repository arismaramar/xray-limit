#!/bin/bash
github="raw.githubusercontent.com/chiakge/Linux-NetSpeed/master"
kernel_version="4.14.129-bbrplus"
source /etc/os-release
cat << EOF | sudo debconf-set-selections
# Abort kernel # Abort kernel removal??
linux-base	linux-base/removing-running-kernel	boolean	false
EOF
check_sys() {
    if [[ -f /etc/redhat-release ]]; then
        release="centos"
    elif cat /etc/issue | grep -q -E -i "debian"; then
        release="debian"
    elif cat /etc/issue | grep -q -E -i "ubuntu"; then
        release="ubuntu"
    elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat"; then
        release="centos"
    elif cat /proc/version | grep -q -E -i "debian"; then
        release="debian"
    elif cat /proc/version | grep -q -E -i "ubuntu"; then
        release="ubuntu"
    elif cat /proc/version | grep -q -E -i "centos|red hat|redhat"; then
        release="centos"
    fi
}
check_sys
detele_kernel() {
    if [[ "${release}" == "debian" || "${release}" == "ubuntu" ]]; then
        deb_total=$(dpkg -l | grep linux-image | awk '{print $2}' | grep -v "${kernel_version}" | wc -l)
        if [ "${deb_total}" ] >"1"; then
            echo -e "terdeteksi ${deb_total} Sisa kernel，Mulai Bongkar..."
            for ((integer = 1; integer <= ${deb_total}; integer++)); do
                deb_del=$(dpkg -l | grep linux-image | awk '{print $2}' | grep -v "${kernel_version}" | head -${integer})
                echo -e "Mulai Bongkar ${deb_del} Inti..."
                apt-get purge -y ${deb_del}
                echo -e "Tidak terinstal ${deb_del} Inti Tidak terinstalLengkap, lanjutkan..."
            done
            echo -e "Inti Tidak terinstal Setelah akhir, lanjutkan..."
        else
            echo -e " terdeteksi Jumlah kernel salah, silakan periksa !"
        fi
    fi
}
BBR_grub() {
    if [[ "${release}" == "debian" || "${release}" == "ubuntu" ]]; then
        /usr/sbin/update-grub
    fi
}
remove_all() {
    sed -i '/net.core.default_qdisc/d' /etc/sysctl.conf
    sed -i '/net.ipv4.tcp_congestion_control/d' /etc/sysctl.conf
    sed -i '/fs.file-max/d' /etc/sysctl.conf
    sed -i '/net.core.rmem_max/d' /etc/sysctl.conf
    sed -i '/net.core.wmem_max/d' /etc/sysctl.conf
    sed -i '/net.core.rmem_default/d' /etc/sysctl.conf
    sed -i '/net.core.wmem_default/d' /etc/sysctl.conf
    sed -i '/net.core.netdev_max_backlog/d' /etc/sysctl.conf
    sed -i '/net.core.somaxconn/d' /etc/sysctl.conf
    sed -i '/net.ipv4.tcp_syncookies/d' /etc/sysctl.conf
    sed -i '/net.ipv4.tcp_tw_reuse/d' /etc/sysctl.conf
    sed -i '/net.ipv4.tcp_tw_recycle/d' /etc/sysctl.conf
    sed -i '/net.ipv4.tcp_fin_timeout/d' /etc/sysctl.conf
    sed -i '/net.ipv4.tcp_keepalive_time/d' /etc/sysctl.conf
    sed -i '/net.ipv4.ip_local_port_range/d' /etc/sysctl.conf
    sed -i '/net.ipv4.tcp_max_syn_backlog/d' /etc/sysctl.conf
    sed -i '/net.ipv4.tcp_max_tw_buckets/d' /etc/sysctl.conf
    sed -i '/net.ipv4.tcp_rmem/d' /etc/sysctl.conf
    sed -i '/net.ipv4.tcp_wmem/d' /etc/sysctl.conf
    sed -i '/net.ipv4.tcp_mtu_probing/d' /etc/sysctl.conf
    sed -i '/net.ipv4.ip_forward/d' /etc/sysctl.conf
    sed -i '/fs.inotify.max_user_instances/d' /etc/sysctl.conf
    sed -i '/net.ipv4.tcp_syncookies/d' /etc/sysctl.conf
    sed -i '/net.ipv4.tcp_fin_timeout/d' /etc/sysctl.conf
    sed -i '/net.ipv4.tcp_tw_reuse/d' /etc/sysctl.conf
    sed -i '/net.ipv4.tcp_max_syn_backlog/d' /etc/sysctl.conf
    sed -i '/net.ipv4.ip_local_port_range/d' /etc/sysctl.conf
    sed -i '/net.ipv4.tcp_max_tw_buckets/d' /etc/sysctl.conf
    sed -i '/net.ipv4.route.gc_timeout/d' /etc/sysctl.conf
    sed -i '/net.ipv4.tcp_synack_retries/d' /etc/sysctl.conf
    sed -i '/net.ipv4.tcp_syn_retries/d' /etc/sysctl.conf
    sed -i '/net.core.somaxconn/d' /etc/sysctl.conf
    sed -i '/net.core.netdev_max_backlog/d' /etc/sysctl.conf
    sed -i '/net.ipv4.tcp_timestamps/d' /etc/sysctl.conf
    sed -i '/net.ipv4.tcp_max_orphans/d' /etc/sysctl.conf
    sleep 1s
}
remove_all
echo "fs.file-max = 1000000
net.ipv4.tcp_congestion_control=bbrplus
net.ipv4.icmp_echo_ignore_broadcasts=1
fs.inotify.max_user_instances = 8192
net.ipv4.tcp_tw_reuse = 1
net.ipv4.ip_local_port_range = 1024 65535
net.ipv4.tcp_rmem = 16384 262144 8388608
net.ipv4.tcp_wmem = 32768 524288 16777216
net.core.somaxconn = 8192
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.core.wmem_default = 2097152
net.core.default_qdisc=fq

# Accept IPV4
net.ipv4.tcp_max_tw_buckets = 5000
net.ipv4.tcp_max_syn_backlog = 10240
net.core.netdev_max_backlog = 10240
net.ipv4.tcp_slow_start_after_idle = 0

# Accept IPV6
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.eth0.disable_ipv6 = 0
net.ipv6.conf.eth1.disable_ipv6 = 0
net.ipv6.conf.lo.disable_ipv6 = 0

# forward ipv4
net.ipv4.ip_forward=1" >>/etc/sysctl.conf
sysctl -p
echo "*               soft    nofile           1000000
*               hard    nofile          1000000" >/etc/security/limits.conf
echo "ulimit -SHn 1000000" >>/etc/profile
mkdir bbrplus && cd bbrplus
wget -N --no-check-certificate http://${github}/bbrplus/debian-ubuntu/x64/linux-headers-4.14.129-bbrplus.deb >/dev/null 2>&1
wget -N --no-check-certificate http://${github}/bbrplus/debian-ubuntu/x64/linux-image-4.14.129-bbrplus.deb >/dev/null 2>&1
dpkg -i linux-headers-4.14.129-bbrplus.deb
dpkg -i linux-image-4.14.129-bbrplus.deb
cd .. && rm -rf bbrplus
detele_kernel
BBR_grub
