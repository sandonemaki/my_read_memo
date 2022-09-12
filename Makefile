.PHONY: up
up:
	bundle exec rails s -b 0.0.0.0

.PHONY: kill-server-and-start-server-as-daemon
kill-server-and-start-server-as-deamon:
	kill 'cat tmp/pids/server.pid' || echo ok
	bundle exec rails s -b 0.0.0.0 -d

.PHONY: release-for-aws
elease-for-aws:
	ssh -i ${SECRET_KEY_PATH_V2} ${USER_NAME_V2}@${HOST_V2} "bash -c 'cd my_read_memo && git pull && kill-server-and-start-server-as-daemon'"

.PHONY: db-create
db-create:
	bundle exec rails db:create
	bundle exec rails db:migrate
