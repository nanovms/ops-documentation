Crons
========================

Crons are schedules that can run unikernels according to a cron schedule
or rate.

As of today crons are only supported on AWS.

To list all crons:
```
ops crons list
```

You need an IAM role that can assume for EventBridge Scheduler and have
permissions for ec2. You might also wish to add SQS and Cloudwatch if
you need to debug the schedule itself.

To create a new cron from an existing image:
```
export EXECUTIONARN="arn:aws:iam::123456789012:role/cronjobtest"
ops cron create ctest "rate(1 minutes)"
```

To delete a cron:
```
ops cron delete <name>
```

To enable a cron:
```
ops cron enable <name>
```

To disable a cron:
```
ops cron disable <name>
```
