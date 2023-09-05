module State
  # TODO: 以下の定数の使用をやめて以下に定義したメソッドを使用する
  READING_STATE = { 0 => 'さらさら読書：乱読', 1 => 'じっくり読書：精読', 2 => 'さらさら読書：通読' }.freeze

  # さらさら読書メモセレクトボックスに使用
  RANDOKU_MEMO_Q = { 1 => '気持ちが高まったのはいつですか？ それはなぜですか？' }.freeze
  RANDOKU_MEMO_BKG = { 2 => '著者のプロフィールの要約', 3 => '本の核となる時代と地域', 4 => 'その他' }.freeze

  RANDOKU_MEMO_TYPE = State::RANDOKU_MEMO_Q.merge(State::RANDOKU_MEMO_BKG)

  # じっくり読書メモセレクトボックスに使用
  SEIDOKU_MEMO_TYPE = { 1 => '要約', 2 => '著者の意見', 3 => '引用された事実', 4 => '自分の意見', 5 => 'その他' }.freeze
end
