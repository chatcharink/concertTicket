module RegistrationUsersHelper
    def get_country
        country = read_file('./lib/country.json')
        select_option = []
        country.each do |c|
            select_option << [c["name"], c["code"]]
        end
        return select_option
    end

    def get_chanel locale
        channel = ChannelToKnow.where.not(status: "deleted")
        if locale == "en"
            arr_channel = channel.pluck(:channel_name_en, :id)
        else
            arr_channel = channel.pluck(:channel_name_th, :id)
        end
        arr_channel
    end

    def arr_provinces
        provinces = [
            "กระบี่",
            "กรุงเทพมหานคร",
            "กาญจนบุรี",
            "กาฬสินธุ์",
            "กำแพงเพชร",
            "ขอนแก่น",
            "จันทบุรี",
            "ฉะเชิงเทรา",
            "ชลบุรี",
            "ชัยนาท",
            "ชัยภูมิ",
            "ชุมพร",
            "เชียงราย",
            "เชียงใหม่",
            "ตรัง",
            "ตราด",
            "ตาก",
            "นครนายก",
            "นครปฐม",
            "นครพนม",
            "นครราชสีมา",
            "นครศรีธรรมราช",
            "นครสวรรค์",
            "นนทบุรี",
            "นราธิวาส",
            "น่าน",
            "บึงกาฬ",
            "บุรีรัมย์",
            "ปทุมธานี",
            "ประจวบคีรีขันธ์",
            "ปราจีนบุรี",
            "ปัตตานี",
            "พระนครศรีอยุธยา",
            "พะเยา",
            "พังงา",
            "พัทลุง",
            "พิจิตร",
            "พิษณุโลก",
            "เพชรบุรี",
            "เพชรบูรณ์",
            "แพร่",
            "ภูเก็ต",
            "มหาสารคาม",
            "มุกดาหาร",
            "แม่ฮ่องสอน",
            "ยโสธร",
            "ยะลา",
            "ร้อยเอ็ด",
            "ระนอง",
            "ระยอง",
            "ราชบุรี",
            "ลพบุรี",
            "เลย",
            "ลำปาง",
            "ลำพูน",
            "ศรีสะเกษ",
            "สกลนคร",
            "สงขลา",
            "สตูล",
            "สมุทรปราการ",
            "สมุทรสงคราม",
            "สมุทรสาคร",
            "สระแก้ว",
            "สระบุรี",
            "สิงห์บุรี",
            "สุโขทัย",
            "สุพรรณบุรี",
            "สุราษฎร์ธานี",
            "สุรินทร์",
            "หนองคาย",
            "หนองบัวลำภู",
            "อ่างทอง",
            "อำนาจเจริญ",
            "อุดรธานี",
            "อุตรดิตถ์",
            "อุทัยธานี",
            "อุบลราชธานี"
        ];
    end

    private
    def read_file file_path
        file = File.read(file_path)
        arr_country = JSON.parse(file)
        return arr_country
    end
end
