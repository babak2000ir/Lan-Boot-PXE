# LAN Boot PXE

A PXE (Preboot Execution Environment) network boot solution for loading boot images using LAN (like DOS and Windows 98 etc.). This setup allows computers to boot from the network without local storage, loading DOS-based operating systems with full network support.

## Credits

This project is based on the excellent work by **Kenton Varda** (Kentie):
- **Reference Article**: [PXE booting Windows 98 with PXElinux](https://www.kentie.net/article/pxe98/)

The original guide provides comprehensive instructions for setting up PXE boot environments for legacy Windows systems, and this project follows those methodologies.

## Overview

This project provides a complete PXE boot infrastructure that:
- Boots legacy systems over the network using PXE
- Provides DOS environment with networking capabilities
- Supports Windows 98 boot disk image
- Includes network drivers for various legacy network cards
- Enables file sharing via network shares

## Directory Structure

```
boot/                   - PXE boot files and bootloader
  ├── pxelinux.0       - PXE bootloader
  ├── menu.c32         - Boot menu interface
  ├── memdisk          - Memory disk emulator
  ├── ldlinux.c32      - SYSLINUX core module
  ├── libutil.c32      - Utility library
  ├── netboot.IMA      - DOS network boot disk image
  ├── winb98.IMA       - Windows 98 boot disk image
  └── pxelinux.cfg/    - Boot configuration
      └── default      - Default boot menu config

netboot/                - DOS boot disk contents
  ├── AUTOEXEC.BAT     - Startup automation script
  ├── CONFIG.SYS       - DOS system configuration
  ├── DOS/             - DOS system utilities
  ├── net/             - Network drivers and tools
  └── Tools/           - Additional DOS utilities

pxeshare/              - Network shared folders
  ├── dos/             - DOS software and files
  └── win98/           - Windows 98 files
```

## Boot Menu Options

The PXE boot menu provides two options:

1. **Network boot disk** - Boots DOS with network support enabled
2. **Windows boot disk** - Boots from Windows 98 disk image

## Network Drivers

The following network card drivers are included in `netboot/net/`:

- **e1000.dos** - Intel PRO/1000 adapters
- **e100b.dos** - Intel PRO/100 adapters
- **EL90X.DOS** - 3Com EtherLink III/XL
- **IBMFE.DOS** - IBM Fast Ethernet
- **MDGND.DOS** - Generic NDIS drivers
- **N100.DOS** - NE100 compatible
- **NE2000.DOS** - NE2000 compatible cards
- **NEMM.DOS** - NE2000 with memory manager
- **UNDIS3C.DOS** - Universal NDIS 3Com

## Requirements

### Server Requirements
- TFTP server
- DHCP server with PXE boot options configured
- File server (SMB/CIFS) for network shares

### DHCP Configuration
Configure your DHCP server with:
```
next-server: <TFTP_SERVER_IP>
filename: "boot/pxelinux.0"
```

### Client Requirements
- Computer with PXE-capable network card
- BIOS configured to boot from network (PXE)

## Setup Instructions

### 1. TFTP Server Setup
Copy the `boot/` directory contents to your TFTP server root directory.

### 2. DHCP Configuration
Configure your DHCP server to:
- Point to your TFTP server IP
- Set boot filename to `boot/pxelinux.0` or `pxelinux.0` (depending on TFTP root)

### 3. Network Share Setup
Configure network shares for the `pxeshare/` directories:
- Share `pxeshare/dos/` as accessible to DOS clients
- Share `pxeshare/win98/` for Windows 98 related files

### 4. Network Configuration
Edit `netboot/net/PROTOCOL.INI` to configure network settings for your environment.

## Customization

### Modifying Boot Menu
Edit `boot/pxelinux.cfg/default` to customize boot options and menu appearance.

### Network Configuration
- **PROTOCOL.INI** - Network protocol configuration
- **SYSTEM.INI** - System settings
- **AUTOEXEC.BAT** - Startup commands and network initialization
- **CONFIG.SYS** - DOS system configuration (memory, drivers)

### Adding Software
Place additional DOS software and utilities in:
- `pxeshare/dos/` - For DOS applications
- `pxeshare/win98/` - For Windows 98 files

## Troubleshooting

### PXE Boot Fails
- Verify DHCP server is providing correct next-server and filename options
- Ensure TFTP server is running and accessible
- Check network connectivity between client and server

### Network Drivers Not Loading
- Verify correct network driver for your NIC in `PROTOCOL.INI`
- Check that network drivers exist in `netboot/net/`
- Ensure NDIS support files (PROTMAN.DOS, ndis.dos) are present

### Cannot Access Network Shares
- Verify file server is running and shares are configured
- Check network credentials in startup scripts
- Ensure TCP/IP stack is properly loaded (TCPDRV.DOS)

## Files Description

### Core Boot Files
- **pxelinux.0** - Initial PXE bootloader loaded by PXE ROM
- **menu.c32** - Provides text-based menu interface
- **memdisk** - Loads disk images into memory and emulates disk drive
- **ldlinux.c32** - Core SYSLINUX library module
- **libutil.c32** - Utility functions library

### DOS System Files
- **COMMAND.COM** - DOS command interpreter
- **IO.SYS** - DOS system file
- **MSDOS.SYS** - DOS system file
- **IFSHLP.SYS** - Installable File System helper

### Network Components
- **PROTMAN.DOS** - Protocol Manager for NDIS drivers
- **ndis.dos** - NDIS (Network Driver Interface Specification) driver
- **NDISHLP.SYS** - NDIS helper
- **TCPDRV.DOS** - TCP/IP protocol driver
- **NETBIND.COM** - Network binding utility

## License

This project uses various components with different licenses:
- SYSLINUX/PXELINUX - GPL
- MS-DOS components - Microsoft
- Network drivers - Various manufacturers

Ensure compliance with all applicable licenses for your use case.

## Contributing

To contribute to this project:
1. Test changes in a isolated network environment
2. Document any modifications to configuration files
3. Update this README with new features or requirements

## Additional Notes

- This setup is designed for legacy DOS and Windows 98 systems
- Modern systems may require different approaches
- Always test in a non-production environment first
- Keep backups of working configurations

---

**Last Updated:** December 25, 2025