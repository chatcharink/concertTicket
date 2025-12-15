class RegisterUserMailer < ApplicationMailer
    include Rails.application.routes.url_helpers

    def generate_qr user, session
        @receiver = user
        if user.qr_code.attached?
          #attachments.inline['qr.jpg'] = user.qr_code.download
          attachments.inline['qr.jpg'] = {
                    mime_type: 'image/jpeg',
                    content: user.qr_code.download,
                    content_id: 'qr.jpg'
          }
        end
        #@qr = Rails.application.routes.url_helpers.rails_blob_url(user.qr_code, host: "https://pdmusicschool.com/ticket_online")
        @event = session["current_user"]["selected_event"]
        mail(to: @receiver.email, subject: "Welcome to My Awesome Site")
    end

    def confirm_register user, qr_path
        @registered_user = user
        # attachments.inline['ticket.png'] = File.read(Rails.root.join('app/assets/images/siam_world_music_festival_ticket.png'))

        attachments.inline['map.png'] = File.read(Rails.root.join('app/assets/images/siam_world_music_festival_map.png'))
        qrcode = RQRCode::QRCode.new("#{qr_path}/get_user/#{user.id}")

        # NOTE: showing with default options specified explicitly
        png = qrcode.as_png(
            resize_gte_to: false,
            resize_exactly_to: false,
            fill: 'white',
            color: 'black',
            size: 190
        )

        require 'tempfile'
        qr_file = Tempfile.new(['qr_registered', '.png'])
        qr_file.binmode
        qr_file.write(png.to_s)
        qr_file.flush

        bg = MiniMagick::Image.open(Rails.root.join('app/assets/images/siam_world_music_festival_ticket.png'))
        qr = MiniMagick::Image.open(qr_file.path)

        result = bg.composite(qr) do |c|
            c.gravity "SouthEast"   # ตำแหน่งทับ (เช่น ขวาล่าง)
            c.geometry "+383+95"     # margin ขอบ (x,y)
        end

        combined_path = Rails.root.join("tmp", "qr_registered.png")
        result.write(combined_path)
        attachments.inline["final.png"] = File.read(combined_path)

        mail(to: @registered_user.email, subject: "Thank you for your register event")
    end

    def confirm_participate user
        @registered_user = user
        attachments.inline['feedback.png'] = File.read(Rails.root.join('app/assets/images/feedback.png'))

        mail(to: @registered_user.email, subject: "Welcome to Siam world music festival")
    end

    def update_numbers user
        @receiver = user
        if user.qr_code.attached?
          #attachments.inline['qr.jpg'] = user.qr_code.download
          attachments.inline['qr.jpg'] = {
                    mime_type: 'image/jpeg',
                    content: user.qr_code.download,
                    content_id: 'qr.jpg'
          }
        end
        mail(to: @receiver.email, subject: "Update quota of registered event")
    end
end
