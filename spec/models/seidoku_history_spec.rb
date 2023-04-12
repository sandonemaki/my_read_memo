require 'rails_helper'

RSpec.describe SeidokuHistory, type: :model do
  describe ".set" do
    context "精読ヒストリーのレコードが存在しない場合" do
      it "精読ヒストリーのレコードの数が1件増える"
    end
    
    context "精読ヒストリーのレコードが存在する場合" do
      it "精読ヒストリーのレコードの数が変わらないこと"
    end

  end
end
