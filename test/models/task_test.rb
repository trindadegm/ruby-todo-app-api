require "test_helper"

class TaskTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test 'must have title' do
    task = Task.new description: "some desc", owner: 1, status: "pending", visibility: "public"
    assert_not task.save
  end

  test 'must have status' do
    task = Task.new title: "some title", description: "some desc", owner: 1, visibility: "public"
    assert_not task.save
  end

  test 'must have owner' do
    task = Task.new title: "some title", description: "some desc", status: "pending", visibility: "public"
    assert_not task.save
  end

  test 'must have visibility' do
    task = Task.new title: "some title", description: "some desc", status: "pending", owner: 2
    assert_not task.save
  end

  test 'may not have description' do
    task = Task.new title: "some title", owner: 1, status: "pending", visibility: "public"
    assert task.save
  end

  test 'status can only be pending or done' do
    task = Task.new title: "some title", owner: 1, status: "pending", visibility: "public"
    assert task.save
    task = Task.new title: "some title", owner: 1, status: "done", visibility: "public"
    assert task.save
    task = Task.new title: "some title", owner: 1, status: "something_else", visibility: "public"
    assert_not task.save
  end

  test 'visibility can only be public or private' do
    task = Task.new title: "some title", owner: 1, status: "done", visibility: "public"
    assert task.save
    task = Task.new title: "some title", owner: 1, status: "done", visibility: "private"
    assert task.save
    task = Task.new title: "some title", owner: 1, status: "done", visibility: "something_else"
    assert_not task.save
  end
end
