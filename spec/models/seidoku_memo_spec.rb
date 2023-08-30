require 'rails_helper'

RSpec.describe SeidokuMemo, type: :model do
  describe 'バリデーション' do
    subject(:valid?) { seidoku_memo.valid? }

    # テスト用のUserオブジェクトを作成
    before { @user = User.create!(auth0_id: 'auth0|1234', nickname: 'TestUser') }

    let(:book) { Book.create(title: 'ダイニングタイトル', author_1: '東野智子', total_page: 100, user_id: @user.id) }

    let(:seidoku_memo) { SeidokuMemo.new(content: content, book: book) }
    let(:content) do
      '雨にも負けず. 風にも負けず. 雪にも夏の暑さにも負けぬ. 丈夫なからだを持ち. 欲は無く. 決して瞋からず'
    end

    context 'すべての属性が有効なとき' do
      it 'バリデーションが通ること' do
        expect(book.valid?).to eq true
      end
    end

    context 'コンテンツが存在しないとき' do
      let(:content) { nil }
      it 'バリデーションエラーが発生すること' do
        expect(book.valid?).to eq false
      end
    end

    context 'コンテキストが空のとき' do
      let(:content) { '' }
      it 'バリデーションエラーが発生すること' do
        expect(book.valid?).to eq false
      end
    end
  end
end
