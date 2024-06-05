# SMB-Bash-Script-for-WireGuard-
This Shell script is intended to be used for Docker containers on a Gluetun image running a WireGuard VPN in client mode.

This script essentially waits for a specific IP address to become available on any network interface and then mounts an SMB volume if that IP is found. It's assumed that the IP Address that you're looking for is guaranteed to have internet access if present, otherwise the SMB mount will fail.

The Shell script would ideally be set to run on container startup but only after the WireGuard VPN client connection has been provisioned from the entrypoint.sh script in the Gluetun image.

The concept of this Shell script is rather unconventional and shouldn't really be used at all unless you have a very specific use case that requires it. There are superior ways to mount an SMB file share to a Docker container by means of using the host system which can be found here https://docs.docker.com/storage/volumes/

At the very least, It's required to install sudo and cifs-utils to the docker image (based off Alpine Linux) to use this script.
 - apk add sudo cifs-utils
