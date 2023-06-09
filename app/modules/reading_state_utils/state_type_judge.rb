module ReadingStateUtils
  module StateTypeJudge
    def self.determine_state(totalpage:, already_read_count:, unread_count:)
      randoku_imgs = already_read_count + unread_count

      if randoku_imgs < (totalpage * (1.0 / 8.0))
        ReadingStateUtils::StateTypeJudge::Randoku.new
      elsif randoku_imgs >= (totalpage * (1.0 / 8.0)) && unread_count < (totalpage * (1.0 / 4.0))
        ReadingStateUtils::StateTypeJudge::Seidoku.new
      elsif randoku_imgs >= (totalpage * (1.0 / 8.0)) && unread_count >= (totalpage * (1.0 / 4.0))
        ReadingStateUtils::StateTypeJudge::Tudoku.new
      end
    end

    class Randoku
    end
    class Seidoku
    end
    class Tudoku
    end
  end
end
