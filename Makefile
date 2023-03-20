start: 
	redis-server --port 6500 --daemonize yes
	tmux new -s catpurr_one -d -n catpurr_one_sidekiq 'bundle exec sidekiq -r ./lib/catpurr_one.rb;'
	tmux new-window -dn catpurr_one_process -t catpurr_one:1 'sudo -E /home/pi/.asdf/shims/ruby catpurr_one_start.rb'

publish_lambda: build_lambda zip_lambda
	pushd lib/lambda_functions/rekon_catpurrone && \
	aws lambda update-function-code --region us-east-1 --function-name rekon-catpurrone --zip-file fileb://catpurr_rekognition.zip && \
	rm catpurr_rekognition.zip

build_lambda: 
	pushd lib/lambda_functions/rekon_catpurrone && \
	bundle config set --local path "./vendor/bundle" && \
	bundle install --gemfile="./Gemfile"

zip_lambda: 
	pushd lib/lambda_functions/rekon_catpurrone && \
	zip -r catpurr_rekognition.zip *

lambda_deploy_mode: 
	rm .tool-versions
	mv .tool-versions-lambda .tool-versions
	asdf install

exit_lambda_deploy_mode: 
	git checkout .tool-versions .tool-versions-lambda