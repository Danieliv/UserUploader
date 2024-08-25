require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is valid with valid attributes' do
    user = User.new(name: 'John Doe', password: 'StrongPass1')
    expect(user).to be_valid
  end

  it 'is not valid without a name' do
    user = User.new(password: 'StrongPass1')
    expect(user).to_not be_valid
  end

  it 'is not valid without a password' do
    user = User.new(name: 'John Doe')
    expect(user).to_not be_valid
  end

  it 'is not valid with a weak password' do
    user = User.new(name: 'John Doe', password: 'weakpass')
    expect(user).to_not be_valid
  end

  it 'is not valid with three repeating characters' do
    user = User.new(name: 'John Doe', password: 'aaaStrongPass1')
    expect(user).to_not be_valid
  end
end
