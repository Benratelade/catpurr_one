## 25 January 2023
The detector seems to work and triggers the camera. Nice! 

However, the PIR detector seems to send a signal every 60s precisely. 

For the past few days, I have been looking at the code, trying different libraries to interact with the GPIO pins, reading docs. 

In despair, I tried wrapping the sensor in aluminium foil. And that stopped the triggering...

So, there is someting near my raspberry pi that emits a regular signal strong enough to trigger my sensor. Mystery solved. When in doubt, fetch foil. 

### What we have so far
Altogether the following parts work as intended: 
* Using the sensor to trigger the camera
* Once an image is uploaded to the S3 bucket, it triggers a Lambda function
* The lambda function is in charge of getting the cat-ness of the photo via Rekognition and move it to the right folder in the S3 bucket

Still missing: 
* Automatically uploading new photos to the S3 bucket
* Tests! This is a proof of concept. Tests and automations are needed. 
* Automate the provisioning of AWS resources
* Embrace a Continuous Integration method

## 17 January 2023
For the past several days, I have failed to make the Raspberry Pi Camera module work. I tried resetting it in the connector _many_ times, tried a different SD card with PiOS installed, reinstalled the entire OS to make sure it wasn't software-related. Nothing worked. 

In despair, I bought a KEYESTUDIO 1080p camera module (AUD $9.99 at time of purchase). It got delivered quickly, was connected to the Pi swiftly, and worked effortlessly. I wish I'd started there. 

The Raspberry Pi Camera module was either faulty or got fried when I handled it. 