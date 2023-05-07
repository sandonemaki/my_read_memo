export PATH="/home/ubuntu/.anyenv/envs/rbenv/versions/3.0.4/bin:$PATH"
cd my_read_memo
bundle install
git pull origin main
make aws_db_cp
make db_migrate
make kill-server-and-start-server-as-daemon
