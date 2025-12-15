module ConcertInfoHelper
    def get_event
        if @concert.blank?
            arr_concert = []
        else
            arr_concert = @concert.pluck(:concert_name, :id)
        end
        arr_concert
    end
end
