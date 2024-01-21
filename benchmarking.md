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
