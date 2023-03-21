module State
  # TODO: 以下の定数の使用をやめてBookモデルに定義したメソッドを使用する
  READING_STATE = { 0 => "乱読", 1 => "精読", 2 => "通読" }.freeze


  module ReadingState

    def judgement_type(totalpage:, already_read:, unread:)
      randoku_imges = already_read + unread

      if randoku_images < (totalpage*(1.0/8.0))
        State::ReadingState::Randoku.new
      elsif randoku_images >= (totalpage*(1.0/8.0)) && unread < (totalpage*(1.0/4.0))
        State::ReadingState::Seidoku.new
      elsif randoku_images >= (totalpage*(1.0/8.0)) && unread >= (totalpage*(1.0/4.0))
        State::ReadingState::Tudoku.new
      end
    end


    class Randoku; end
    class Seidoku; end
    class Tudoku; end
  end

end
