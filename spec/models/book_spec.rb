require 'rails_helper'

# 整理後のバリデーションテスト
RSpec.describe Book, type: :model do
  # テスト用のUserオブジェクトを作成
  before { @user = User.create!(auth0_id: 'auth0|1234', nickname: 'TestUser') }

  # Userに紐づくBookを作成
  let(:book) { Book.new(title: title, author_1: author_1, total_page: total_page, user_id: @user.id) }

  describe 'バリデーション' do
    subject(:valid?) { book.valid? }

    let(:title) { 'ダイニングタイトル' }
    let(:author_1) { '東野智子' }
    let(:total_page) { 100 }

    context 'すべての属性が有効なとき' do
      it 'バリデーションが通ること' do
        expect(valid?).to eq true
      end
    end

    context 'タイトルがないとき' do
      let(:title) { nil }
      it 'バリデーションエラーが発生すること' do
        valid?
        expect(book.errors[:title]).to include('タイトルを入力してください')
      end
    end

    context '著者がないとき' do
      let(:author_1) { nil }
      it 'バリデーションエラーが発生すること' do
        valid?
        expect(book.errors[:author_1]).to include('著者を入力してください')
      end
    end

    context '読書する本のページ数が存在しないとき' do
      let(:total_page) { nil }
      it 'バリデーションエラーが発生すること' do
        valid?
        expect(book.errors[:total_page]).to include('読書する本のページ数を入力してください')
      end
    end

    context 'タイトルが31文字以下であるとき' do
      let(:title) { 'a' * 31 }
      it 'バリデーションエラーが発生すること' do
        valid?
        expect(book.errors[:title]).to include('30文字以内で入力してください')
      end
    end

    context '著者の入力が31文字であるとき' do
      let(:author_1) { 'a' * 31 }
      it 'バリデーションエラーが発生すること' do
        valid?
        expect(book.errors[:author_1]).to include('30文字以内で入力してください')
      end
    end

    context '読書する本のページ数は1000ページであるとき' do
      let(:total_page) { 1000 }
      it 'バリデーションエラーが発生すること' do
        valid?
        expect(book.errors[:total_page]).to include('登録できるページ数は20〜999ページです')
      end
    end
  end
end

# 整理前のバリデーションテスト
RSpec.describe Book, type: :model do
  # テスト用のUserオブジェクトを作成
  before { @user = User.create!(auth0_id: 'auth0|1234', nickname: 'TestUser') }

  it 'タイトル、著者、読書する本のページ数があれば有効な状態であること' do
    book = Book.new(title: 'ダイニングタイトル', author_1: '東野智子', total_page: 100, user_id: @user.id)
    expect(book).to be_valid
  end

  it 'タイトルがなければ無効な状態であること' do
    book = Book.new(title: nil, user_id: @user.id)
    expect(book.valid?).to eq false
  end

  it '著者がなければ無効な状態であること' do
    book = Book.new(author_1: nil, user_id: @user.id)
    expect(book.valid?).to eq false
  end

  it '読書する本のページ数が存在しなければ無効な状態であること' do
    book = Book.new(total_page: nil, user_id: @user.id)
    expect(book.valid?).to eq false
  end

  it 'タイトルが30文字以下であること' do
    book = Book.new(title: 'a' * 31, user_id: @user.id)
    expect(book.valid?).to eq false
  end

  it '著者の入力が30字以下であること' do
    book = Book.new(author_1: 'a' * 31, user_id: @user.id)
    expect(book.valid?).to eq false
  end

  it '読書する本のページ数は1-999ページまでであること' do
    book = Book.new(total_page: 1000, user_id: @user.id)
    expect(book.valid?).to eq false
  end
end

RSpec.describe Book, type: :model do
  # テスト用のUserオブジェクトを作成
  before { @user = User.create!(auth0_id: 'auth0|1234', nickname: 'TestUser') }

  # Userに紐づくBookを作成
  let(:book) { Book.new(title: 'ダイニングタイトル', author_1: '東野智子', total_page: 100, user_id: @user.id) }

  describe '.try_update_reading_state' do
    let(:book_for_state) do
      Book.create(
        title: 'ダイニングタイトル',
        author_1: '東野智子',
        total_page: 100,
        reading_state: 0,
        user_id: @user.id,
      )
    end

    context 'determine_stateの戻り値がさらさら読書_乱読型のとき' do
      before do
        allow(ReadingStateUtils::StateTypeJudge).to receive(:determine_state).and_return(
          ReadingStateUtils::StateTypeJudge::Randoku.new,
        )
      end

      it '状態に変化がないのでdbに保存されないこと' do
        expect { book_for_state.try_update_reading_state }.not_to change { book.reading_state }
        expect(ReadingStateUtils::StateTypeJudge).to have_received(:determine_state)
      end
    end

    context 'determine_stateの戻り値がじっくり読書_精読型のとき' do
      before do
        allow(ReadingStateUtils::StateTypeJudge).to receive(:determine_state).and_return(
          ReadingStateUtils::StateTypeJudge::Seidoku.new,
        )
      end

      it '「さらさら読書_乱読」から「じっくり読書_精読」に状態が変化するのでdbに保存されること' do
        expect { book.try_update_reading_state }.to change { book.reading_state }
        expect(ReadingStateUtils::StateTypeJudge).to have_received(:determine_state)
      end
    end

    context 'determine_stateの戻り値がじっくり読書_精読型のとき' do
      before do
        allow(ReadingStateUtils::StateTypeJudge).to receive(:determine_state).and_return(
          ReadingStateUtils::StateTypeJudge::Tudoku.new,
        )
      end

      it '「さらさら読書_乱読」から「さらさら読書_通読」に状態が変化するのでdbに保存されること' do
        expect { book.try_update_reading_state }.to change { book.reading_state }
        expect(ReadingStateUtils::StateTypeJudge).to have_received(:determine_state)
      end
    end

    context 'determine_stateの戻り値がじっくり読書_精読型のとき' do
      before do
        allow(ReadingStateUtils::StateTypeJudge).to receive(:determine_state).and_return(
          ReadingStateUtils::StateTypeJudge,
        )
      end

      it 'detaermine_stateの戻り値が存在しない型のためエラーが出ること' do
        expect { book.try_update_reading_state }.to raise_error(TypeError)
        expect(ReadingStateUtils::StateTypeJudge).to have_received(:determine_state)
      end
    end
  end
end
