module State

  # DBから取り出した値をview用に変換するメソッド
  def display_reading_type(db_reading_status:)
    case db_reading_status
    when 0
      "乱読"
    when 1
      "精読"
    when 2
      "通読"
    else
      raise TypeError, "未定義の本の状態です"
    end
  end



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
