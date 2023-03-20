# frozen_string_literal: true

require_relative "../../../../lib/lambda_functions/rekon_catpurrone/lambda_function"
require "spec_helper"

# Change to force a new sha
describe "lib/lambda_functions/rekon_catpurrone/lambda_function.rb" do
  before do
    @event = {
      "Records" => [
        {
          "s3" => {
            "bucket" => {
              "name" => "source bucket name",
            },
            "object" => {
              "key" => "prefixes/the/source/object key",
            },
          },
        },
      ],
    }

    @s3_client = double("s3 client")
    allow(Aws::S3::Client).to receive(:new).and_return(@s3_client)

    @image_in_s3 = double("the image in s3")
    allow(@image_in_s3).to receive(:move_to)
    @bucket = double("bucket", object: @image_in_s3)

    @s3_resource = double("s3 resource", bucket: @bucket)
    allow(Aws::S3::Resource).to receive(:new).and_return(@s3_resource)

    @rekognition_response = double("rekognition response", labels: [])
    @rekognition_client = double("rekognition client", detect_labels: @rekognition_response)
    allow(Aws::Rekognition::Client).to receive(:new).and_return(@rekognition_client)
  end

  it "uses Amazon Rekognition to find what is in the photo" do
    expect(@rekognition_client).to receive(:detect_labels).with(
      {
        image: {
          s3_object: {
            bucket: "source bucket name",
            name: "prefixes/the/source/object key",
          },
        },
        max_labels: 100,
        min_confidence: 95.0,
        features: ["GENERAL_LABELS"],
      },
    )

    lambda_handler(event: @event, context: nil)
  end

  context "when the photo does NOT have a cat" do
    it "moves the file in a processed folder for NOT cats" do
      allow(@rekognition_response).to receive(:labels).and_return(
        [
          double("name 1", name: "name 1"),
          double("name 2", name: "name 2"),
        ],
      )

      expect(@image_in_s3).to receive(:move_to).with(
        bucket: "source bucket name",
        key: "processed/has_no_cat/object key",
      )

      lambda_handler(event: @event, context: nil)
    end
  end

  context "when the photo DOES have a cat" do
    it "moves the file in a processed folder for CATS" do
      allow(@rekognition_response).to receive(:labels).and_return(
        [
          double("name 1", name: "name 1"),
          double("this label is cat", name: "Cat"),
        ],
      )

      expect(@image_in_s3).to receive(:move_to).with(
        bucket: "source bucket name",
        key: "processed/has_cat/object key",
      )

      lambda_handler(event: @event, context: nil)
    end
  end

  context "when there are odd characters in the file name" do
    it "unescapes URL encoded characters" do
      @event["Records"] = [
        {
          "s3" => {
            "bucket" => {
              "name" => "source bucket name",
            },
            "object" => {
              "key" => "prefixes/the/source&object+key",
            },
          },
        },
      ]

      expect(@image_in_s3).to receive(:move_to).with(
        bucket: "source bucket name",
        key: "processed/has_no_cat/source&object key",
      )

      lambda_handler(event: @event, context: nil)
    end
  end
end
