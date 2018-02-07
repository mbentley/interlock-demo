interlock-demo
==============

Demo to show off a few of Interlock's capabilites such as routing with overlays, host mode services, and multiple service routers.

Complete documentation: https://interlock-dev-docs.netlify.com/

To begin, execute the `0_launch_all.sh` script:

```
$ ./0_launch_all.sh
```

This will execute steps 1, 2, and 3 which will launch engines inside of a single engine like Docker for Mac, launch Interlock, and launch two demo apps; one using overlays, the other using host mode to publish ports. You can view the apps then once launched.

While executing the rest of the demo, it may be useful to utilize the `watch_services.sh` script which executes a `watch` on the service list to be able to see when the services are being created, updated, and ready.  I tend to leave this running in a 2nd terminal during a demo.

After that, you can scale the apps using `4_scale_apps.sh`:

```
$ ./4_scale_apps.sh
```

This will scale up each of the demo apps to 3 containers to show no interruptions while scaling up.

Next, you can modify how Interlock works by adding additional service load balancers using `5_convert_multi-region.sh`; one for east, another for west (while leaving the default load balancer present):

```
$ ./5_convert_multi-region.sh
```

This will also launch two more demo applications, one that is configured to use the `east` load balancer, the other on the `west`.

The last thing to do is to scale up those new applications using `6_scale_apps.sh`:

```
$ ./6_scale_apps.sh
```

This will scale up one application, wait about 15 seconds, and then scale up the next.  The purpose is to be able to show how the service load balancers get updated independently.

The environment can be torn down using the `teardown_environment.sh` script when the demo is complete:

```
$ ./teardown_environment.sh
```
