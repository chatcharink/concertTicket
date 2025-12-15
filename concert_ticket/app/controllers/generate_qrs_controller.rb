class GenerateQrsController < ApplicationController
    require 'base64'
    require 'tempfile'
    require 'mini_magick'
    require 'rqrcode'
    require 'sendgrid-ruby'
    include SendGrid
    def index
        return redirect_to login_path() if session["current_user"].blank?
        # @qr = QrInfo.new
    end

    def get_qr
        @qr_code = QrInfo.exist_qr?(params["searchValue"], nil, session)
        if @qr_code.blank?
            respond_to do |format|
                format.json { render :json => {status: "error", message: "Location or phone number \"#{params["searchValue"]}\" not found."} }
            end
        else
            render(
                partial: "generate_qrs/qr_modal",
                formats: [:html, :js, :json, :url_encoded_form]
            )
        end
    end

    def create
        begin
            form_qr = params["form_qr"]

            if is_duplicate_location?(form_qr)
                respond_to do |format|
                    format.json { render :json => {status: "error", message: "Cannot generate QR code because location name: #{form_qr["location"]} already exists."} }
                end
            elsif form_qr["numbers"].to_i <= 0
                respond_to do |format|
                    format.json { render :json => {status: "error", message: "Cannot generate QR"} }
                end
            else
                @qr_code = QrInfo.generate(form_qr, session, params)
                if @qr_code.save!
                    render(
                        partial: "generate_qrs/qr_modal",
                        formats: [:html, :js, :json, :url_encoded_form]
                    )
                else
                    respond_to do |format|
                        format.json { render :json => {status: "error", message: "Cannot generate QR Code. Please contact admin"} }
                    end
                end
            end
        rescue => exception
            p "ERROR: #{exception.message}"
            p "ERROR: #{exception.backtrace.first}"
            respond_to do |format|
                format.json { render :json => {status: "error", message: "Cannot generate QR Code. Please contact admin"} }
            end
        end
    end

    def send_mail
        @qr = QrInfo.find(params[:qr_id])
        begin
            #qr = RegisterUserMailer.generate_qr(@qr, session).deliver_now
            mail = generate_qr(@qr, session)
            flash[:success] = "Send email to #{@qr.email} successfully" 
            redirect_to qr_path()
        rescue => e
            p e.message
            p e.backtrace.first
            flash[:error] = "Cannot send email please contact admin"
            redirect_to qr_path()
        end
    end

    def download_qr
        qr = QrInfo.find(params[:qr_id])
        if qr.qr_code.attached?
            redirect_to rails_blob_url(qr.qr_code, disposition: "attachment")
        else
            flash[:error] = "Cannot download QR code please contact admin"
            redirect_to qr_path()
        end
    end

    private

    def is_duplicate_location? form
        has_location = QrInfo.exist_qr?(form["location"], form["phone_number"], session)
        return has_location.present?
    end

    def generate_qr company, session

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
                <p style="margin-bottom:40px;">This is your information</p>
                <p style="margin-bottom:40px; margin-left:20px;">Company name: #{company.location}</p>
                <p style="margin-bottom:40px; margin-left:20px;">Numbers of Quota: #{company.numbers.to_i - company.ticket_used.to_i}</p>
                <p style="margin-bottom:40px;">Please share this QR code to someone is interested in #{session["current_user"]["selected_event"]["name"]}</p>
                
                <div style="text-align:center;">
                <img src="cid:qr_cid" alt="QRcode" />
                </div>
            </div>

            <!-- Footer -->
            <div style="border-top:1px solid #d7d7d7; border-bottom-left-radius:20px; border-bottom-right-radius:20px; padding:15px;">
                <p>Thanks,</p>
                <p>Siam World Music Festival Team</p>
            </div>

            </div>
            HTML

        
        client = SendgridService.new()
        mail = client.send_mail(
            to: company.email,
            subject: "Thank you for join in Siam World Music Festival",
            content: [{ type: 'text/html', value: html_content }],
            from: { email: Rails.application.credentials.dig(:gmail, :username), name: 'SiamWorldMusicFestival' },
            attachments: attachments
        )
    end
end
