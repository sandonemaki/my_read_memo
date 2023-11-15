#require 'rails_helper'
#
#RSpec.describe ViewModel::BooksRandokuIndexCommon do
#  describe 'コンストラクター' do
#    context '本と登録数が0の場合' do
#      it '乱読画像の数が0であること' do
#        actual =
#          ViewModel::BooksIndexCommon.new(
#            all_randoku_state_books: User.new.books,
#            all_seidoku_state_books: [],
#            all_books_count: 0,
#            user_books: User.new.books,
#          )
#        expect(actual.all_randoku_imgs_count).to eq(0)
#      end
#    end
#  end
#end
#
