module ViewModel

  class AccountSetting
    attr_reader :nickname, :email

    def initialize(user:, user_email:)
      @nickname = user.nickname
      @email = user_email
      @errors = book.errors
    end
  end
end
