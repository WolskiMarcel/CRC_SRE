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

### Additional info
The VM already has a working app in Swagger. I've also written a program to collect API data in Python (which I will add to repo soon), before I realized I already had prepared app. Anyway, I used the prepared, ready-made one.

### Good to remember
Before using any scripts you have to grant execute permissions to a file.
```
$ chmod +x script_name.sh
$ sudo ./script_name.sh
```

