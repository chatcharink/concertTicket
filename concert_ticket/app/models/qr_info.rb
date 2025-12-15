class QrInfo < ApplicationRecord
    include Rails.application.routes.url_helpers
    has_one_attached :qr_code
    has_secure_token :auth_token

    def self.exist_qr? search_value, phone_number, session
        phone_number = search_value if phone_number.blank?
        qr = QrInfo.where("LOWER(location) = ? or phone_number = ?", search_value.downcase, phone_number)
        qr = qr.where(event_id: session["current_user"]["selected_event"]["id"])
        qr.first
    end

    def self.generate form_qr, session, params
        host = Rails.application.config.action_controller.default_url_options[:host]

        qr = QrInfo.create(
            numbers: form_qr["numbers"],
            location: form_qr["location"],
            email: form_qr["email"],
            phone_number: form_qr["phone_number"],
            event_id: session["current_user"]["selected_event"]["id"]
        )

        qrcode = RQRCode::QRCode.new("#{host}/#{params[:locale]}/registration_user/#{qr.auth_token}")

        # Create a new PNG object
        png = qrcode.as_png(
            bit_depth: 1,
            border_modules: 4,
            color_mode: ChunkyPNG::COLOR_GRAYSCALE,
            color: "black",
            file: nil,
            fill: "white",
            module_px_size: 6,
            resize_exactly_to: false,
            resize_gte_to: false,
            size: 500,
        )

        
        qr.qr_code.attach(
            io: StringIO.new(png.to_s),
            filename: "qrcode_#{form_qr["location"]}.png",
            content_type: "image/png",
        )

        qr
    end

    def self.update_quota qr
        count = qr.update(ticket_used: qr.ticket_used+1)
    end
end
