require "aws_uploader"
require "spec_helper"

describe AWSUploader do
  before do
    allow(ENV).to receive(:fetch).with("AWS_ACCESS_KEY_ID", nil).and_return("aws_access_key_id")
    allow(ENV).to receive(:fetch).with("AWS_SECRET_ACCESS_KEY", nil).and_return("aws_secret_access_key")

    @s3_client = double("s3 client")
    allow(Aws::S3::Client).to receive(:new).and_return(@s3_client)
    allow(@s3_client).to receive(:put_object)
  end

  describe "#initialize" do
    it "instantiates a connection to our s3 bucket" do
      aws_credentials = double("aws_credentials")
      expect(Aws::Credentials).to receive(:new).with(
       "aws_access_key_id",
       "aws_secret_access_key",
      ).and_return(aws_credentials)

      expect(Aws::S3::Client).to receive(:new).with(
        region: "ap-southeast-2",
        credentials: aws_credentials, 
      )

      AWSUploader.new
    end
  end

  describe "#upload" do
    it "raises an ArgumentError error if the file doesn't exist" do
      s3_uploader = AWSUploader.new
      expect do
        s3_uploader.upload(file_path: "file_path.jpg")
      end.to raise_error(ArgumentError, "The file file_path.jpg does not exist")
    end

    it "uploads the file to the designated bucket" do
      expect(@s3_client).to receive(:put_object).with(
        body: File.expand_path("./spec/fixtures/images/cat.jpg"),
        bucket: "test_bucket",
      )

      s3_uploader = AWSUploader.new
      s3_uploader.upload(file_path: file_fixture("cat.jpg"))
    end
  end
end
