module DashboardHelper
    def get_company_name
        company = QrInfo.where(status: "active", event_id: session["current_user"]["selected_event"]["id"])
        arr_company = []
        arr_company = company.pluck(:location, :id)
        arr_company.insert(0, ["All", ""])
    end  
    def count_register_user id=nil
        user = RegisteredUser.select("channel_to_knows.channel_name_en, qr_infos.location, registered_users.*").where.not(status: "inactive")
        user = user.where("qr_infos.id = ?", id) if id.present?
        user = user.where("qr_infos.event_id = ?", session["current_user"]["selected_event"]["id"])
        user = user.joins("left join qr_infos on qr_infos.id = registered_users.qr_id")
        user = user.joins("left join channel_to_knows on channel_to_knows.id = registered_users.channel_to_know")

        male = 0
        female = 0
        not_specific = 0
        data = Hash.new
        channel = Hash.new
        province = Hash.new
        participate = Hash.new
        participate["workshop"] = 0
        participate["concert"] = 0

        user.each do |u|
            data[u.location] ||= Hash.new
            data[u.location]["male"] ||= 0
            data[u.location]["female"] ||= 0
            data[u.location]["not_specific"] ||= 0
            channel[u.channel_name_en] ||= 0
            channel[u.channel_name_en] += 1
            participate["workshop"] += u.workshop.to_i
            participate["concert"] += u.concert.to_i
            unless u.province.blank?
                province[u.province] ||= 0
                province[u.province] += 1
            end
            
            case u.gender
            when 1
                data[u.location]["male"] += 1
                male += 1
            when 2
                data[u.location]["female"] += 1
                female += 1
            else
                data[u.location]["not_specific"] += 1
                not_specific += 1
            end
        end

        @arr_data = []

        # {name: "male", data: [[location1, 10], [location2, 15]]}
        arr_male = []
        arr_female = []
        arr_not_specific = []

        keys = data.keys
        keys.each do |k|
            arr_male << [k, data[k]["male"]]
            arr_female << [k, data[k]["female"]]
            arr_not_specific << [k, data[k]["not_specific"]]
            # h_data["data"] = [["male", data[k]["male"]], ["female", data[k]["female"]], ["not specific", data[k]["not_specific"]]]
        end

        ["male", "female", "not_specific"].each do |gender|
            arr_gender = case gender
                        when "male" then arr_male
                        when "female" then arr_female
                        else arr_not_specific
                        end
            @arr_data << set_graph(gender, arr_gender)
        end

        @count = [male, female, not_specific]
        @channel = channel.to_a #user.group(:channel_name_en).count
        sort_province = province.to_a.sort_by{|x,y| y}.reverse
        @province = sort_province[0..9]
        @participate_data = participate.to_a
    end

    private
    def set_graph gender, arr_gender
        h_data = Hash.new
        h_data["name"] = gender
        h_data["data"] = arr_gender
        return h_data
    end
end
