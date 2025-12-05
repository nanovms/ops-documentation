# Benchmarking

Benchmarking is a common task that users will want to perform as many
workloads are more performant in various manners running on Nanos,
however, to get accurate results benchmarking needs to be done as 1:1 as
possible.

One of the first tasks you need to state before trying to benchmark a
workload is to define what you want to benchmark.

Request/second
Throughput
Latency
Storage vs Networking
Writes/seconds or Reads/second
Random Reads/Writes or Sequential
Small vs Large Reads/Writes

There is almost an infinite amount of metrics you can measure and the
more precise you can be about what you are measuring the more accurate
you can state your results.

It is important to isolate your workloads from each other and to take
into account any differeces. This can include but is not limited to:

* cost of virtualization (eg: measuring something from a host vs
  measuring something from a guest)
* networking configuration
* linux vs nanos variance
* app specific differences and app configuration (eg: is it
  multi-process on linux but single process on nanos?)

It is highly suggested when benchmarking to do so on a public cloud for
multiple reasons:

1) It is in all liklihood where the workloads will run in production.
2) You can isolate both your linux workload and your nanos workload on
identical instance types.
3) You can run a third (if involving perhaps networking benchmarks)
instance as your test instance away from your measurable instances.
4) You are guaranteed not to have interference from host/guest problems
or bridged/usermode issues.

Networking Specific Things to Consider:

* Always measure on a bridge/tap setup - never on usermode it is slow.
  (By dafult ops uses usermode for local/dev work but bridge/tap on
prod.)

* Always measure on the same class c or /24 but not on the same instance
  you are trying to measure. You don't want to measure across the public
internet but you also don't want to incorrectly measure from the same
system you expect to measure.

* Linux guest tuning: If you are measuring on real hardware there are
  other configurations to be aware of. Measuring soething running on a
host vs a guest will always be superior for instance. You should also
take into account pot limits and the fact that most linux systems will
be setup for multiple queues.

    If measuring HTTP you may wish to consider wrk instead of ab for
multi-threaded reasons.

These are just a handful of suggestions to help you get more accurate
results and helps the NanoVMs team address performance issues in a
quicker manner.

### Benchmarking with Apache Bench

You should note that without using keep-alive you might quickly run into
issues with time wait.

ab uses a range of ~14k ports when opening new connections and when that
is used up the ports start being reused, however you can't accept new
connections from the port until the TIME_WAIT period expires (default is
2 minutes).

```
ab -c 10 -n 100 -k http://host:port/
ab -c 10 -n 1000 -k http://host:port/
```

### Benchmarking with Wrk

Generally speaking wrk is a better tool to use here as it is
multi-threaded. You are almost guaranteed to see better results for a
variety of reasons but mainly cause of the threaded approach.

```
 wrk http://host:port/
```

As with all benchmarking your results could vary quite a bit from
workload to workload.

### Benchmarking with FIO

FIO allows you to test I/O.

https://github.com/axboe/fio

In order to use fio you'll need to make two changes:

1) Disable shared memory with fio:

```sh
./configure --disable-shm
```

2) Stub get/setpriority syscalls:

```sh
+++ b/src/unix/syscall.c
@@ -2493,6 +2493,8 @@ void register_file_syscalls(struct syscall *map)
     register_syscall(map, io_uring_enter, io_uring_enter);
     register_syscall(map, io_uring_register, io_uring_register);
     register_syscall(map, getcpu, getcpu);
+    register_syscall(map, getpriority, syscall_ignore);
+    register_syscall(map, setpriority, syscall_ignore);
 }
```

For now Nanos does not support direct io so you'll need to set
'direct=0'. A sample config might look like so:

```
:~/$ cat testnew.fio
[global]
name=fio-rand-write
filename=fio-rand-write
rw=randwrite
bs=4K
direct=0
numjobs=4
time_based=1
runtime=10
filename=test
thread

[file1]
size=500m
ioengine=libaio
iodepth=16
```

If you are testing remotely (eg: in the cloud) you may wish to turn on
idle_on_exit:

```
 "ManifestPassthrough": {
  "idle_on_exit": "*"
  }
```

You may also wish to prevent fio from starting immediately:

```
diff --git a/fio.c b/fio.c
index 3d6ce597..72f1aea2 100644
--- a/fio.c
+++ b/fio.c
@@ -22,11 +22,18 @@
  *
  */
 #include "fio.h"
+#include <stdio.h>
+#include <unistd.h>

 int main(int argc, char *argv[], char *envp[])
 {
        int ret = 1;

+    printf("waiting for 5\n");
+
+    sleep(5);
+    printf("done sleeping\n");
```
