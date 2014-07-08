require "generator_spec"
require "generators/cl_mina/install_generator"

describe ClMina::Generators::InstallGenerator, type: :generator do
  destination File.expand_path('../../tmp', __FILE__)

  before(:all) do
    prepare_destination
    run_generator
  end

  it "creates a deploy.rb in config" do
    assert_file "config/deploy.rb"
  end

  it "creates deploy defaults file" do
    assert_file "config/deploy/defaults.rb"
  end

  it "creates deploy environment files" do
    assert_file "config/deploy/staging.rb"
    assert_file "config/deploy/production.rb"
  end
end