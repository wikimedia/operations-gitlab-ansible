# WMF GitLab: High Availability options

Review of High Availability options for WMF Gitlab, considering a strict requirement of GitLab Server Community Edition license.

* [GitLab components level cluster](#gitlab)
* [Filesystem level replication cluster — recommended](#filesys)
* [Block device level replication cluster](#blockdev)

## <a name="gitlab"></a>GitLab components level cluster

Separate Gitlab components (PostgreSQL, Redis, Consul, Gitaly and so on) into “external” services using native clusterization. Advise against this option due to complexity and maintenance costs.

This solution is mostly performance-oriented.

Pros:
* One of GitLab’s reference architectures
* Designed to gain more TPS (serve thousands of simultaneous users)
* Gives performance gains

Cons:
* Not designed for fault tolerance or failover
* Many moving parts, setup may be complicated
* Not easy to implement, control and monitor

## <a name="filesys"></a>Filesystem level replication cluster

This is the advised solution.

Create a replicated failover-cluster based on copy-on-write file system — ZFS:
ZFS supports point-in-time, atomic, and consistent file-system level data snapshots.
Creating a snapshot does not impact performance and does not create notable additional overhead. Snapshot delta(s) can be saved to a file and replicated to a remote host over the network on a schedule, resulting in an always consistent (file system level) remote replica.

* Create failover-cluster consisting of two servers — origin and replica
* Server VMs run stock version of Linux (Debian or Ubuntu Server)
* VMs’ root file systems can be kept on traditional file system, EXT4FS or XFS
* Create a separate ZFS data volume for Gitlab data
* Migrate GitLab Server data tree (`/var/opt/gitlab` by default) to ZFS
* Configure a snapshot schedule (create and delete) on the origin system
* Perform an initial full replication of the origin ZFS snapshot to the remote system
* Configure origin and remote schedules for sending deltas between origin and remote systems and its application to the remote ZFS file system.

This mechanism allows for:

A regularly updated remote replica, ready for failover - when the origin server becomes unavailable, service can be quickly migrated to the remote server.
Utilize data snapshots for a set period(s) of time, allowing for a quick historical data retrieval.

It is:
* Not a remote backup mechanism, as remote snapshots are closely following the origin system
* Not a scalability solution, as replica is not available until a failover event

Pros:
* Technology is widely adopted, community support is available
* Replication process is stable and self-recovering
* Works well over WAN
* Provides additional recovery options (only if origin host is fully operational)

Cons:
* Snapshot replication has rather long gap (tens of minutes)
* Will not replace backups and will not give any additional recovery options in case of origin host failure (origin fs and ZFS snapshots will not be available)
* No performance gains

## <a name="blockdev"></a>Block device level replication cluster

Create a failover-cluster based on a distributed replicated RAID using DRBD (see [Linbit DRBD](https://linbit.com/drbd/))

DRBD stands for Distributed Replicated Storage System, works on Linux platform.

DRBD layers logical block devices over existing local block devices on participating cluster nodes. Writes to the primary node are transferred to the lower-level block device and simultaneously propagated to the secondary node(s). The secondary node(s) then transfers data to its corresponding lower-level block device. All read I/O is performed locally unless read-balancing is configured.

Pros:
* Provides a ready-to-failover block device level replica
* May work over WAN in asynchronous mode
* Asynchronous replication mode keeps replica consistent

Cons:
* Designed to work over LAN, WAN replication means high latency in synchronous mode or replica delay in asynchronous mode
* DRBD Proxy, WAN replication optimization software, is a paid product
* Application failover (to other DRBD node) isn’t automated
* Technology is not widely adopted, so no answer-any-question community support
* No performance gains
