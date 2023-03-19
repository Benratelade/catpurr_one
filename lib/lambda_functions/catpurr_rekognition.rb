require 'aws-sdk-s3'
require 'aws-sdk-rekognition'
require 'json'

def lambda_handler(event:, context:)
  # Get the record
  first_record = event['Records'].first
  bucket_name = first_record['s3']['bucket']['name']
  full_file_name = CGI.unescape(first_record['s3']['object']['key'])
  
  file_name = full_file_name.split('/').last

  # Get reference to the file in S3
  client = Aws::S3::Client.new(region: first_record['awsRegion'])
  s3 = Aws::S3::Resource.new(client: client)
  object = s3.bucket(bucket_name).object(full_file_name)

  rekognition_client = Aws::Rekognition::Client.new(region: first_record['awsRegion'])

  attrs = {
    image: {
      s3_object: {
        bucket: bucket_name,
        name: full_file_name
      }
    },
    max_labels: 100,
    min_confidence: 95.0,
    features: ['GENERAL_LABELS'],
  }
  response = rekognition_client.detect_labels(attrs)
  
  tag_names = response.labels.map(&:name)
  puts "Detected labels for: #{full_file_name}: [#{tag_names.join(", ")}]"

  new_file_name = if tag_names.include?('Cat')
                    # If it's a cat, move to a cat folder
                    "has_cat/#{file_name}"
                  else
                    # If it's not a cat, move to a not a cat folder
                    "has_no_cat/#{file_name}"
                  end
  puts "Moving file to its new location: #{new_file_name}"

  object.move_to(bucket: bucket_name, key: "processed/#{new_file_name}")
end
