.PHONY: schedule-crontab
schedule-crontab:
	./scripts/schedule-crontab.sh


.PHONY: refresh-route53-ip
refresh-route53-ip:
	./scripts/refresh-route53-ip.sh
