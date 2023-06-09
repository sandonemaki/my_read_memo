require 'rails_helper'

RSpec.describe RandokuMemo, type: :model do
  describe 'バリデーション' do
    subject(:valid?) { randoku_memo.valid? }

    let(:book) { Book.create(title: 'ダイニングタイトル', author_1: '東野智子', total_page: 100) }

    let(:randoku_memo) { RandokuMemo.new(content: content, book: book) }
    let(:content) do
      '雨にも負けず. 風にも負けず. 雪にも夏の暑さにも負けぬ. 丈夫なからだを持ち. 欲は無く. 決して瞋からず'
    end

    context 'すべての属性が有効なとき' do
      it 'バリデーションが通ること' do
        expect(valid?).to eq true
      end
    end

    context 'コンテンツが存在しないとき' do
      let(:content) { nil }
      it 'バリデーションエラーが発生すること' do
        valid?
        expect(randoku_memo.errors[:content]).to include('内容を入力してください')
      end
    end

    context 'コンテキストが空のとき' do
      let(:content) { '' }
      it 'バリデーションエラーが発生すること' do
        valid?
        expect(randoku_memo.errors[:content]).to include('内容を入力してください')
      end
    end
  end
end
