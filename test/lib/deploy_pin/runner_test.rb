require 'test_helper'

class DeployPin::Runner::Test < ActiveSupport::TestCase
  setup do
    DeployPin.setup do
      tasks_path './tmp/'
      groups ["I", "II", "III"]
      fallback_group "I"
    end

    # clean
    DeployPin::Record.delete_all
    ::FileUtils.rm_rf(DeployPin.tasks_path, secure: true)
    ::FileUtils.mkdir(DeployPin.tasks_path)

    # copy files
    ::FileUtils.cp 'test/support/files/task.rb', "#{DeployPin.tasks_path}1_task.rb"
    ::FileUtils.cp 'test/support/files/task_different.rb', "#{DeployPin.tasks_path}2_task.rb"
    ::FileUtils.cp 'test/support/files/task_same.rb', "#{DeployPin.tasks_path}3_task.rb"
  end

  test "sumary" do
    assert_nothing_raised do
      DeployPin::Runner.summary(identifiers: [DeployPin.fallback_group])
    end
  end

  test "run" do
    assert_nothing_raised do
      DeployPin::Runner.run(identifiers: DeployPin.groups)
    end
  end

  test "run with uuid" do
    assert_nothing_raised do
      DeployPin::Runner.run(identifiers: [75371573753751])
    end
  end

  test "list" do
    assert_nothing_raised do
      DeployPin::Runner.list(identifiers: [DeployPin.fallback_group])
    end
  end

  teardown do
    # clean
    DeployPin::Record.delete_all
    ::FileUtils.rm_rf(DeployPin.tasks_path, secure: true)
  end
end
