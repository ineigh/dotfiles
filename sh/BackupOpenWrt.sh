#!/usr/bin/env bash
ssh root@192.168.1.1 \
	'sysupgrade -b /tmp/openwrt-backup.tar.gz &&
   tar -czf /tmp/adguardhome-backup.tar.gz -C /etc adguardhome &&
   apk list --installed > /tmp/openwrt-installed-packages.txt' &&
	scp -O root@192.168.1.1:/tmp/openwrt-backup.tar.gz ~/Backups/OpenWrt/ &&
	scp -O root@192.168.1.1:/tmp/adguardhome-backup.tar.gz ~/Backups/OpenWrt/ &&
	scp -O root@192.168.1.1:/tmp/openwrt-installed-packages.txt ~/Backups/OpenWrt/ &&
	ssh root@192.168.1.1 \
		'rm -f /tmp/openwrt-backup.tar.gz /tmp/adguardhome-backup.tar.gz /tmp/openwrt-installed-packages.txt'
