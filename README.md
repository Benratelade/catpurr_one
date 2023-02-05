## About Catpurr One
This project is just an opportunity to have some fun with my Raspberry Pi 3B+ and cats. 

## Hardware
* Raspberry Pi 3B+
* PIR infrared motion sensor - Duinotech XC-4444
* KEYESTUDIO 1080p with OV5647 sensor camera module (version 1.3)

## Infrastructure
* Once photos have been catpured by Pi's camera, they are uploaded in an S3 bucket. 
* A watcher class observes changes to the contents of the S3 bucket on a regular basis and sends new images to Amazon Rekognition, where the cat-ness of the image will be assessed. 
  * This could actually be easier with a lambda function, since they can be triggered based on changes to S3 bucket contents. 
  * Based on the result, the file will be moved to the appropriate directory (`cat` or `catless`). 
  * Images are kept in the `catless` directory to let me check how well the system works. I do not expect any catty pictures in there, this is a sanity check. 
* New images in the `cat` bucket will be automatically published online. 
  * This too may be a candidate for a lambda function. 
  * Where the images will be published is undecided. Some options are: a blog, making the S3 directory publicly readable, Instagram, Twitter, or a mix of several methods. 

## Testing
* Use ASDF to manage dependencies
* Run tests with rspec
* Continuous Integration is done via Circle CI (TBD)

# Redis
To support queues with Sidekiq, we rely on Redis running on port 6500. `--daemonize yes` starts Redis in the background. 
`redis-server --port 6500 --daemonize yes`

# Local dev
you will need to load variables: 
`. bin/load_env`

Some secrets are necessary too. You will need to run `. bin/load_secrets`, which prompts for a passphrase and decrypts the secrets via Ansible. 