# frozen_string_literal: true

require "catpurr_one"
require "aws-sdk-s3"
require_relative "../config/config"

class AWSUploader
  attr_reader :s3_client

  def initialize
    credentials = Aws::Credentials.new(
      ENV.fetch("AWS_ACCESS_KEY_ID", nil),
      ENV.fetch("AWS_SECRET_ACCESS_KEY", nil),
    )
    @s3_client = Aws::S3::Client.new(
      region: CatpurrOne::Config::AWS_REGION,
      credentials: credentials,
    )
  end

  def upload(file_path:)
    file_name = File.basename(file_path)

    raise ArgumentError, "The file #{file_path} does not exist" unless File.exist?(file_path)

    @s3_client.put_object(
      body: File.open(file_path),
      bucket: CatpurrOne::Config::AWS_S3_BUCKET_NAME,
      key: CatpurrOne::Config::AWS_S3_UNPROCESSED_IMAGES_DIRECTORY + file_name,
    )
  end

  def delete(objects)
    @s3_client.delete_objects(
      bucket: CatpurrOne::Config::AWS_S3_BUCKET_NAME,
      delete: {
        objects: objects,
      },
    )
  end
end
