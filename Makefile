.PHONY: up
up:
	bundle exec rails s -b 0.0.0.0

.PHONY: production_up
production_up:
	bundle exec rails s -b 0.0.0.0 -e production

.PHONY: kill-server-and-start-server-as-daemon
kill-server-and-start-server-as-daemon:
	# Rails サーバーのプロセスIDを取得し、サーバーを停止
	# 標準エラーに出力されるエラーメッセージが、/dev/null にリダイレクトされる -> 標準エラー出力に書き込まれる内容を捨てる
	kill $(cat tmp/pids/server.pid) 2>/dev/null || echo "Server is not running or Failed to kill server process"
	bundle exec rails s -b 0.0.0.0 -d

.PHONY: kill-server-and-start-production-server-as-daemon
kill-server-and-start-production-server-as-daemon:
	# Rails サーバーのプロセスIDを取得し、サーバーを停止
	# 標準エラーに出力されるエラーメッセージが、/dev/null にリダイレクトされる -> 標準エラー出力に書き込まれる内容を捨てる
	kill $(cat tmp/pids/server.pid) 2>/dev/null || echo "Server is not running or Failed to kill server process"
	bundle exec rails s -b 0.0.0.0 -e production -d

.PHONY: pull
pull:
	git pull

.PHONY: db_migrate
db_migrate:
	bundle exec rails db:migrate

.PHONY: db_create
db_create:
	bundle exec rails db:create

.PHONY: db_production_migrate
db_migrate:
	RAILS_ENV=production bundle exec rails db:migrate

.PHONY: db_production_create
db_create:
	RAILS_ENV=production bundle exec rails db:create

.PHONY: release-for-aws
release-for-aws:
	scp -i ${SECRET_KEY_PATH_V2} -p /home/vagrant/my_read_memo/command-in-aws.sh ${USER_NAME_V2}@${HOST_V2}:/home/ubuntu/
	ssh -i ${SECRET_KEY_PATH_V2} ${USER_NAME_V2}@${HOST_V2} "bash /home/ubuntu/command-in-aws.sh"