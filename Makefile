PYTHON=uv run
HOST=ubuntu@segments.appgrowth.com

run-cli:
		$(PYTHON) -m app.worker

run-http:
		$(PYTHON) -m app.http

run-worker:
		$(PYTHON) rq worker-pool segments --num-workers 5

run-worker-single:
		$(PYTHON) rq worker segments

run-notebook:
		$(PYTHON) -m notebook --ip=127.0.0.1 --port=8888 --no-browser --ServerApp.token='' --ServerApp.password=''

post-http:
		curl -X POST http://localhost:5000/segments \
			-H "Content-Type: application/json" \
			--data '@fixtures/request.json'

post-http-dns:
	curl --resolve 'segments.appgrowth.com:80:3.225.221.81' http://segments.appgrowth.com/segments -H "Content-Type: application/json" --data '@fixtures/request.json'


deploy-key:
	ssh $(HOST) 'cat /home/ubuntu/app/config/authorized_keys > /home/ubuntu/.ssh/authorized_keys'

deploy-copy:
	rsync -ahivr --progress --delete --exclude 'data/' --exclude '__pycache__' --exclude '.venv' . $(HOST):/home/ubuntu/app
	ssh $(HOST) 'mkdir -p /home/ubuntu/app/data'

deploy-config:
	rsync -ahivr --progress config/ $(HOST):/home/ubuntu/app/config/

deploy-restart:
		ssh $(HOST) 'sudo systemctl restart app-http.service app-worker.service app-notebook.service'

deploy-uv:
		ssh $(HOST) 'bash -l -c "cd /home/ubuntu/app && uv sync"'

deploy: deploy-copy deploy-uv deploy-restart
	echo "Deployed to $(HOST)"

ssh:
	ssh -L 8888:localhost:8888 -L 5000:localhost:5000 $(HOST)

install-uv:
	curl -LsSf https://astral.sh/uv/install.sh | sh

install-deps:
	sudo apt update
	sudo apt install -y make tmux redis-server git nginx

install-nginx-config:
	sudo ln -s /home/ubuntu/app/config/nginx/http.conf /etc/nginx/sites-enabled/default
	sudo systemctl reload nginx

install-service:
	sudo cp /home/ubuntu/app/config/system/*.service /etc/systemd/system/
	sudo chown root:root /etc/systemd/system/app-*.service
	sudo chmod 644 /etc/systemd/system/app-*.service
	sudo systemctl daemon-reload
	sudo systemctl enable app-http.service app-worker.service app-notebook.service
	sudo systemctl restart app-http.service app-worker.service app-notebook.service


# aws configure
# from appgrowth.imports import *
# app = create_app()
# app.vault.get('athena_key_id'), app.vault.get('athena_key_secret'), 
install-aws:
	sudo apt install unzip -y
	curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
	unzip awscliv2.zip
	sudo ./aws/install
	rm -rf ./aws

log-http:
		journalctl -u app-http.service -n 50 -f

log-worker:
		journalctl -u app-worker.service -n 50 -f

.PHONY: run-http



bucket/%:
		aws s3api create-bucket --bucket $(notdir $@) \
				--region eu-central-1 --profile personal \
				--create-bucket-configuration LocationConstraint=eu-central-1

create-buckets: bucket/cohortful-development-v1 bucket/cohortful-production-v1


duckdb.sql:
	cd mlcore && uv run -m mlcore.cli.init_duckdb > ../$@
	cp $@ web/db/
	cp $@ mlcore/
.PHONY: duckdb.sql
