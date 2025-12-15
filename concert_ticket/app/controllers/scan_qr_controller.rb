class ScanQrController < ApplicationController
    require 'base64'
    require 'tempfile'
    require 'mini_magick'
    require 'rqrcode'
    require 'sendgrid-ruby'
    include SendGrid
    def index
    end

    def confirm_participated
        return redirect_to siam_music_festival_path() if session["current_user"].blank?
        id = params["id"]
        begin
            registered_user = RegisteredUser.find(id)
            registered_user.update(status: "participated")

            ## Send mail
            mail = confirm_participate_to_user(registered_user)
            #RegisterUserMailer.confirm_participate(registered_user).deliver_now

            @register_user = RegisteredUser.select("qr_infos.location, registered_users.*").joins("left join qr_infos on qr_infos.id = registered_users.qr_id").where(id: id).first

        rescue => e
            p e.message
            p e.backtrace.first
        end
        render(
            partial: "scan_qr/scan_result",
            formats: [:html, :js, :json, :url_encoded_form]
        )
    end

    private
    def confirm_participate_to_user user
        file_path = Rails.root.join('app/assets/images/feedback.png')
        feedback_binary = File.read(file_path)
        feedback_base64 = Base64.strict_encode64(feedback_binary)

        attachments = [
            {
                content: feedback_base64,
                filename: 'feedback.png',
                type: 'image/png',
                disposition: 'inline',
                content_id: 'feedback_cid' # ใช้สำหรับอ้างใน HTML
            }
        ]
        html_content = <<-HTML
            <h1>ขอบคุณที่มาเข้าร่วมงานกับเรา!</h1>

            <p>เรียนคุณ <strong>#{user.firstname}</strong>,</p>

            <p>ขอขอบคุณที่มาเข้าร่วมงาน <strong>Siam World Music Festival</strong> เราได้แนบแบบสอบถามเกี่ยวกับงานไว้ด้านล่าง</p>

            <p>กรุณาช่วยตอบแบบทดสอบเพื่อเป็นประโยชน์ในการพัฒนาในปีต่อๆไป และเจอกันใหม่ปีหน้านะครับ</p>

            <hr>

            <p>ขอบคุณครับ</p>
            <p>ทีมงาน Siam world music festival</p>
            HTML


        client = SendgridService.new()
        mail = client.send_mail(
            to: user.email,
            subject: "Welcome to Siam world music festival",
            content: [{ type: 'text/html', value: html_content }],
            from: { email: Rails.application.credentials.dig(:gmail, :username), name: 'SiamWorldMusicFestival' },
            attachments: attachments
        )
    end
end
