Dir["#{__dir__}/initializers/*.rb"].each { |file| require file }

module CatpurrOne
  module Config
    AWS_REGION = ENV.fetch("CATPURRONE_AWS_REGION", "us-east-1")
    AWS_S3_BUCKET_NAME = ENV.fetch("CATPURRONE_AWS_S3_BUCKET_NAME", "howdooai.catpurrone-test")
    AWS_S3_UNPROCESSED_IMAGES_DIRECTORY = "unprocessed/"
  end
end
