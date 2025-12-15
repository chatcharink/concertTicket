class RegisteredUser < ApplicationRecord
    def self.registered_user form_user, params
        user = RegisteredUser.create(
                firstname: form_user["firstname"],
                lastname: form_user["lastname"],
                email: form_user["email"],
                phone_number: form_user["phone_number"],
                dob: form_user["dob"],
                gender: form_user["gender"].to_i,
                country: form_user["country"],
                province: params["province_select"],
                district: form_user["district"],
                channel_to_know: form_user["channel_to_know"],
                qr_id:  form_user["qr_id"].to_i,
                status: "registered",
                workshop: form_user["workshop"].to_i,
                concert: form_user["concert"].to_i
        )
        user
    end
end
