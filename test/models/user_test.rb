require "test_helper"

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test 'can create user' do
    user = User.new name: 'Livreiro da Silva Couve Flor', email: 'some@example.com', password: 'i_like_books'
    assert user.save
  end

  test 'user must have email' do
    user = User.new name: 'Livreiro da Silva Couve Flor', password: 'foobarbazzword'
    assert_not user.save
  end

  test 'user must have password' do
    user = User.new name: 'Livreiro da Silva Couve Flor', email: 'livda@silva.couve'
    assert_not user.save
  end

  test 'email is unique' do
    user = User.new name: 'Hephaestus', email: 'hephaestus@vulcano.forge', password: 'hammer001'
    assert user.save
    user = User.new name: 'Heph Aestus', email: 'hephaestus@vulcano.forge', password: '001hammer'
    assert_not user.save
  end
end
