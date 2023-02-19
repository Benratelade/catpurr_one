start: 
	redis-server --port 6500 --daemonize yes
	tmux new -s catpurr_one -d -n catpurr_one_sidekiq 'bundle exec sidekiq -r ./lib/catpurr_one.rb;'
	tmux new-window -dn catpurr_one_process -t catpurr_one:1 'sudo -E /home/pi/.asdf/shims/ruby catpurr_one_start.rb'
