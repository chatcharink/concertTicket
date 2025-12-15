class RegistrationUsersController < ApplicationController
    require 'base64'
    require 'tempfile'
    require 'mini_magick'
    require 'rqrcode'
    require 'sendgrid-ruby'
    include SendGrid
    include ApplicationHelper

    def show
        #return redirect_to siam_music_festival_path(), error: "หมดเขตลงทะเบียนเข้าร่วมงานแล้ว. ขอบคุณที่สนใจเข้าร่วมเป็นส่วนหนึ่งกับพวกเรา ปีหน้าอย่าลืมมาเข้าร่วมอีกนะ"
        @location = QrInfo.find_by(auth_token: params["token"])
        event = ConcertInfo.find(@location.event_id)
        return redirect_to siam_music_festival_path() if Date.today > Date.parse(event.event_day.strftime("%Y-%m-%d"))
        return redirect_to registration_user_limit_quota_path() if @location.ticket_used+1 > @location.numbers
        @user = RegisteredUser.new
    end

    def create
        begin
            user = params["registered_user"]
            count = user["count"].blank? ? 0 : user["count"].to_i
            qr = QrInfo.find(user["qr_id"])

            if (qr.ticket_used+1 <= qr.numbers)
                updated_qr = QrInfo.update_quota(qr)
                @registered = RegisteredUser.registered_user(user, params)
                if @registered.save!
                    ### Send remain quota to leader
                    #RegisterUserMailer.update_numbers(qr).deliver_now
                    mail = update_quota_to_user(qr, session)
                    ### Send thank you to registerred user
                    mail2 = confirm_register(@registered)
                    #RegisterUserMailer.confirm_register(@registered, scan_qr_url()).deliver_now
                    #RegisterUserMailer.confirm_register(@registered).deliver_now
                    render(
                        partial: "registration_users/registered_success",
                        formats: [:html, :js, :json, :url_encoded_form],
                        locals: { count: count+1 }
                    )
                else
                    p "error db"
                    respond_to do |format|
                        format.json { render :json => {status: "error", message: "Cannot register user. Please contact admin"} }
                    end
                end
            else
                flash["error"] = "Cannot register user because over quota"
                respond_to do |format|
                    format.json { render :json => {status: "error", message: "Cannot register user because over quota", redirect_url: registration_user_limit_quota_path()} }
                end
            end
        rescue => e
            p e.message
            p e.backtrace.first
            respond_to do |format|
                format.json { render :json => {status: "error", message: "Cannot register user. Please contact admin"} }
            end
        end
    end

    def get_other_user
        @location = QrInfo.find(params["qr_id"])
        return redirect_to registration_user_limit_quota_path() if @location.ticket_used+1 >= @location.numbers
        @user = RegisteredUser.new
        @count = params["count"]
        render(
            partial: "registration_users/form_other_register",
            formats: [:html, :js, :json, :url_encoded_form]
        )
    end

    def send_mail
        begin
            @register = RegisteredUser.find(params[:id])
            mail = confirm_register(@register)
            #RegisterUserMailer.confirm_register(@register, scan_qr_url()).deliver_now
            flash[:success] = "Send ticket to #{@register.firstname} #{@register.lastname} successfully."
            redirect_to report_path()
        rescue => e
            p e.message
            p e.backtrace.first
            flash[:error] = "Cannot send mail to user. Please contact admin"
            redirect_to report_path()
        end
    end

    def limit_quota
    end

    def destroy
        begin
            register = RegisteredUser.find(params[:id])
            register.update(status: "inactive")
            # flash[:success] = "Delete registered user: #{@register.firstname} #{@register.lastname} successfully."
            render(
                partial: "dashboard/detail",
                formats: [:html, :js, :json, :url_encoded_form]
            )
        rescue => e
            # flash[:error] = "Cannot delete registered user. Please contact admin"
            respond_to do |format|
                format.json { render :json => {status: "error", message: "Cannot delete registered user. Please contact admin"} }
            end
        end
        
    end

    private

    def confirm_register user
        map_path = Rails.root.join('app/assets/images/siam_world_music_festival_map.png')
        map_binary = File.read(map_path)
        map_base64 = Base64.strict_encode64(map_binary)

        qrcode = RQRCode::QRCode.new("#{scan_qr_url()}/get_user/#{user.id}")
        png = qrcode.as_png(
            resize_gte_to: false,
            resize_exactly_to: false,
            fill: 'white',
            color: 'black',
            size: 190
        )

        qr_file = Tempfile.new(['qr_registered', '.png'])
        qr_file.binmode
        qr_file.write(png.to_s)
        qr_file.flush

        bg = MiniMagick::Image.open(Rails.root.join('app/assets/images/siam_world_music_festival_ticket.png'))
        qr = MiniMagick::Image.open(qr_file.path)
        result = bg.composite(qr) do |c|
            c.gravity "SouthEast"
            c.geometry "+383+95"
        end

        combined_path = Rails.root.join('tmp', 'qr_registered.png')
        result.write(combined_path)

        final_binary = File.read(combined_path)
        final_base64 = Base64.strict_encode64(final_binary)
        attachments = [
            {
                content: map_base64,
                filename: 'map.png',
                type: 'image/png',
                disposition: 'inline',
                content_id: 'map_cid' # ใช้สำหรับอ้างใน HTML
            },
            {
                content: final_base64,
                filename: 'ticket.png',
                type: 'image/png',
                disposition: 'inline',
                content_id: 'ticket_cid' # ใช้สำหรับอ้างใน HTML
            }
        ]

        html_content = <<-HTML
            <div style="margin:auto; width:90%; max-width:600px; border:1px solid #d7d7d7; border-radius:20px; font-family:Athiti, sans-serif; font-weight:500; font-style:normal; color:#3b3c66;">

            <div style="padding:15px;">
                <h3>ขอบคุณที่ลงทะเบียนเข้าร่วมงาน!</h3>

                <p>เรียนคุณ <strong>#{user.firstname}</strong>,</p>

                <p>ขอขอบคุณที่สนใจสมัครเข้าร่วมงาน <strong>Siam World Music Festival</strong> เราได้แนบตั๋วเข้าร่วมงานและแผนที่ภายในงานของคุณไว้ด้านล่าง</p>

                <p>กรุณานำตั๋วนี้มาแสดงที่หน้างานเพื่อรับการเข้าร่วมกิจกรรม</p>
                
                <img src="cid:ticket_cid" alt="Ticket" width="100%" />

                <hr>

                <p>ขอบคุณครับ</p>
                <p>ทีมงาน Siam world music festival</p>
            </div>

            </div>
            HTML

        client = SendgridService.new()
        mail = client.send_mail(
            to: user.email,
            subject: "Thank you for your register event",
            content: [{ type: 'text/html', value: html_content }],
            from: { email: Rails.application.credentials.dig(:gmail, :username), name: 'SiamWorldMusicFestival' },
            attachments: attachments
        )
    end

    def update_quota_to_user company, session

        if company.qr_code.attached?
            qr_binary = company.qr_code.download
            qr_base64 = Base64.strict_encode64(qr_binary)
            #attachments.inline['qr.jpg'] = user.qr_code.download
            attachments = [
                {
                    content: qr_base64,
                    filename: 'qr.png',
                    type: 'image/png',
                    disposition: 'inline',
                    content_id: 'qr_cid' # ใช้สำหรับอ้างใน HTML
                }
            ]
        end

        html_content = <<-HTML
            <div style="margin:auto; width:90%; max-width:600px; border:1px solid #d7d7d7; border-radius:20px; font-family:Athiti, sans-serif; font-weight:500; font-style:normal; color:#3b3c66;">

            <!-- Header -->
            <div style="background: linear-gradient(90deg, #0080ff, #eff7f9); color:#fff; font-weight:500; padding:15px; border-top-left-radius:20px; border-top-right-radius:20px;">
                <h3><b>Welcome #{company.location}</b></h3>
            </div>

            <!-- Body -->
            <div style="padding:15px;">
                <p style="margin-bottom:40px;">Someone registered from your QR, This is your infotmation,</p>
                <p style="margin-bottom:40px; margin-left:20px;">Company name: #{company.location}</p>
                <p style="margin-bottom:40px; margin-left:20px;">Numbers of Quota: #{company.numbers.to_i - company.ticket_used.to_i}</p>

                <div style="text-align:center;">
                <img src="cid:qr.jpg" alt="QRcode" />
                </div>
            </div>

            <!-- Footer -->
            <div style="border-top:1px solid #d7d7d7; border-bottom-left-radius:20px; border-bottom-right-radius:20px; padding:15px;">
                <p>Thanks,</p>
                <p>The PD Music Team</p>
            </div>

            </div>
            HTML


        client = SendgridService.new()
        mail = client.send_mail(
            to: company.email,
            subject: "Update quota of registered event",
            content: [{ type: 'text/html', value: html_content }],
            from: { email: Rails.application.credentials.dig(:gmail, :username), name: 'SiamWorldMusicFestival' },
            attachments: attachments
        )
    end
end
