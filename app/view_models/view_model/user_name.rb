module ViewModel

  class UserName
    attr_reader :nickname

    def initialize(user:)
      @nickname = user.nickname
    end
  end
end
