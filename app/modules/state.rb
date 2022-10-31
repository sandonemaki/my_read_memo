module State
  READING_STATE = { 0 => "乱読", 1 => "精読", 2 => "通読" }.freeze

  # 乱読メモセレクトボックスに使用
  RANDOKU_MEMO_Q = {
    0 => "気持ちが高まったのはいつですか？ それはなぜですか？"
  }.freeze
  RANDOKU_MEMO_BKG = {
    1 => "著者のプロフィールの要約",
    2 => "本の核となる時代と地域",
    3 => "その他"
  }.freeze
end
