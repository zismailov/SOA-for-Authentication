# frozen_string_literal: true

module Cas::Services
  class Signup
    attr_reader :email, :user, :status

    def initialize(email: 'test@example.com', password: 'blank_password')
      @email = email
      @password = password
    end

    def call
      @user = User.new(email: @email)
      @user.encrypted_password = Digest::SHA1.hexdigest(@password)
      @status = :ok if @user.save
    end
  end
end
