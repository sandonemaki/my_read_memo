.PHONY: up
up:
	bundle exec rails s -b 0.0.0.0

.PHONY: kill-server-and-start-server-as-daemon
kill-server-and-start-server-as-daemon:
	# Rails サーバーのプロセスIDを取得し、サーバーを停止
	# 標準エラーに出力されるエラーメッセージが、/dev/null にリダイレクトされる -> 標準エラー出力に書き込まれる内容を捨てる
	kill $(cat tmp/pids/server.pid) 2>/dev/null || echo "Server is not running or Failed to kill server process"
	bundle exec rails s -b 0.0.0.0 -d

.PHONY: aws_db_cp
aws_db_cp:
	cd config && cp -f aws_database.yml database.yml

.PHONY: pull
pull:
	git pull

.PHONY: db_migrate
db_migrate:
	bundle exec rails db:migrate

.PHONY: release-for-aws
release-for-aws:
	scp -i ${SECRET_KEY_PATH_V2} -p /home/vagrant/my_read_memo/command-in-aws.sh ${USER_NAME_V2}@${HOST_V2}:/home/ubuntu/
	ssh -i ${SECRET_KEY_PATH_V2} ${USER_NAME_V2}@${HOST_V2} "bash /home/ubuntu/command-in-aws.sh"
