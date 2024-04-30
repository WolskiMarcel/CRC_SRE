# 🚀 CRC project SRI
### CRC SRE Unicorn
Course on ING HUBS POLAND
Monitoring system implementation for linux system.

### Task
Task included:
* Setting up monitoring for the operating system, databases, and APIs along with alerting
* Implementing the prepared monitoring automatically using Github Actions
* Preparing a dashboard in Grafana tool containing performance data for the operating system and the database. Visualizations of SLIs/SLOs for the API (e.g., latency, error rate)

### Usaged App
Project is created with: 
* Prometheus (inlucind node_exporter)
* Postgresql
* Grafana

## Urgent
Disabling SELinux (Security-Enhanced Linux) may be necessary when an application, such as Prometheus, encounters restrictions related to SELinux security policies.
The execution of the command
```
$ sudo setenforce 0
```
should work, however, it may not always be guaranteed to work, and if it does, it's only until the machine is restarted.
Changing the SELinux configuration file will ensure a persistent change in the SELinux mode after the system is restarted. To do this, you need to use the command:
```
$ sudo vi /etc/selinux/config
```
Find the line that starts with SELINUX=. The value of this line determines the SELinux mode.
Change the value from SELINUX=enforcing to SELINUX=permissive. Make sure to save the changes. Save the file and exit the editor.


### Additional info
The VM already has a working app in Swagger. I've also written a program to collect API data in Python (which I will add to repo soon), before I realized I already had prepared app. Anyway, I used the prepared, ready-made one.

### Good to remember
Before using any scripts you have to grant execute permissions to a file.
```
$ chmod +x script_name.sh
$ sudo ./script_name.sh
```

