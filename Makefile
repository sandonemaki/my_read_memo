.PHONY: up
up:
	bundle exec rails s -b 0.0.0.0

.PHONY: kill-server-and-start-server-as-daemon
kill-server-and-start-server-as-deamon:
	# Rails サーバーのプロセスIDを取得し、サーバーを停止
	# 標準エラーに出力されるエラーメッセージが、/dev/null にリダイレクトされる -> 標準エラー出力に書き込まれる内容を捨てる
	kill `cat tmp/pids/server.pid` 2>/dev/null || echo "Failed to kill the server process"
	bundle exec rails s -b 0.0.0.0 -d

.PHONY: aws_db_cp
aws_db_cp:
	cd config; \cp -f aws_database.yml database.yml

.PHONY: pull
pull:
	git pull

.PHONY: db_migrate
db_migrate:
	bundle exec rails db:migrate

.PHONY: aws_login
aws_login:
	ssh -i ${SECRET_KEY_PATH_V2} ${USER_NAME_V2}@${HOST_V2}

.PHONY: release-for-aws
release-for-aws:
	aws_login pull aws_db_cp db_migrate kill_server_and_start_server_as_daemon