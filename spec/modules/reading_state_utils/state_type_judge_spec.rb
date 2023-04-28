RSpec.describe ReadingStateUtils do
  describe ReadingStateUtils::StateTypeJudge do
    describe ".determine_state" do
      let(:book) { Book.create(
        title: "ダイニングタイトル",
        author_1: "東野智子",
        total_page: 80,
        reading_state: 0,
      )}

      context "乱読画像が0の場合" do
        before do
          @already_read_count = 0
          @unread_count = 0
          @total_page = 80
          @randoku_imgs = @already_read_count + @unread_count
        end

        it "本の状態が乱読であること" do
          expect(ReadingStateUtils::StateTypeJudge.determine_state(
            totalpage: @total_page, 
            already_read_count: @already_read_count, 
            unread_count: @unread_count
            ))
            .to be_an_instance_of ReadingStateUtils::StateTypeJudge::Randoku
        end
      end

      context "乱読画像が総ページに対して1/8未満の場合" do
        before do
          @already_read_count = 0
          @unread_count = 9
          @total_page = 80
          @randoku_imgs = @already_read_count + @unread_count
        end

        it "本の状態が乱読であること" do
          expect(ReadingStateUtils::StateTypeJudge.determine_state(
            totalpage: @total_page, 
            already_read_count: @already_read_count, 
            unread_count: @unread_count
            ))
            .to be_an_instance_of ReadingStateUtils::StateTypeJudge::Randoku
        end
      end

      context "乱読画像が総ページに対して1/8以上で、未読が総ページに対して1/4以上の場合" do
        before do
          @already_read_count = 0
          @unread_count = 20
          @total_page = 80
          @randoku_imgs = @already_read_count + @unread_count
        end

        it "本の状態が通読であること" do
          expect(ReadingStateUtils::StateTypeJudge.determine_state(
            totalpage: @total_page, 
            already_read_count: @already_read_count, 
            unread_count: @unread_count
            ))
            .to be_an_instance_of ReadingStateUtils::StateTypeJudge::Tudoku
        end
      end

      context "乱読画像が総ページに対して1/8以上で、未読が総ページに対して0以上1/4未満の場合" do
        before do
          @already_read_count = 0
          @unread_count = 19
          @total_page = 80
          @randoku_imgs = @already_read_count + @unread_count
        end

        it "本の状態が精読であること1" do
          expect(ReadingStateUtils::StateTypeJudge.determine_state(
            totalpage: @total_page, 
            already_read_count: @already_read_count, 
            unread_count: @unread_count
            ))
            .to be_an_instance_of ReadingStateUtils::StateTypeJudge::Seidoku
        end

        it "本の状態が精読であること2" do
          expect(ReadingStateUtils::StateTypeJudge.determine_state(
            totalpage: @total_page, 
            already_read_count: 2, 
            unread_count: 17
            ))
            .to be_an_instance_of ReadingStateUtils::StateTypeJudge::Seidoku
        end
      end

      context "乱読画像が総ページに対して1/8以上で、未読が0の場合" do
        before do
          @already_read_count = 10
          @unread_count = 0
          @total_page = 80
          @randoku_imgs = @already_read_count + @unread_count
        end 

        it "本の状態が精読であること" do
          expect(ReadingStateUtils::StateTypeJudge.determine_state(
            totalpage: @total_page, 
            already_read_count: @already_read_count, 
            unread_count: @unread_count
            ))
            .to be_an_instance_of ReadingStateUtils::StateTypeJudge::Seidoku
        end
      end
    end

  end
end