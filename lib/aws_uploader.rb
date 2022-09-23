require "aws-sdk-s3"

class AWSUploader
  def initialize
    credentials = Aws::Credentials.new(
      ENV.fetch("AWS_ACCESS_KEY_ID", nil),
      ENV.fetch("AWS_SECRET_ACCESS_KEY", nil),
    )
    @s3_client = Aws::S3::Client.new(
      region: "ap-southeast-2",
      credentials: credentials,
    )
  end

  def upload(file_path:)
    raise(ArgumentError.new("The file #{file_path} does not exist")) unless File.exist?(file_path)

    @s3_client.put_object(body: file_path, bucket: "test_bucket")
  end
end
