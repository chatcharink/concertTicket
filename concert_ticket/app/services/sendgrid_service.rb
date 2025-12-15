require 'sendgrid-ruby'
include SendGrid

class SendgridService
    def initialize(client: SendGridClient)
        @client = client
    end

    # ส่งอีเมลธรรมดา (plain text / html)
    # params:
    #   to: "recipient@example.com"
    #   subject: "Subject"
    #   content: [{ type: 'text/plain', value: '...' }, { type: 'text/html', value: '<b>...</b>' }]
    #   from: { email: 'no-reply@domain.com', name: 'App' }  # optional
    def send_mail(to:, subject:, content:, from: nil, reply_to: nil, headers: {}, attachments: [])
        from ||= {
            email: Rails.application.credentials.dig(:sendgrid, :from_email),
            name: Rails.application.credentials.dig(:sendgrid, :from_name)
        }

        mail = SendGrid::Mail.new
        mail.from = Email.new(email: from[:email], name: from[:name]) if from
        mail.subject = subject

        personalization = Personalization.new
        personalization.add_to(Email.new(email: to))

        headers.each { |k, v| personalization.add_header(Header.new(key: k, value: v)) } if headers.present?
        mail.add_personalization(personalization)

        # contents is an array of { type:, value: }
        content.each { |c| mail.add_content(Content.new(type: c[:type], value: c[:value])) }

        if reply_to
            mail.reply_to = Email.new(email: reply_to)
        end

        # attachments: [{content: Base64.encode64(file_binary), filename: 'file.pdf', type: 'application/pdf'}]
        attachments.each do |att|
            a = Attachment.new
            a.content = att[:content]
            a.type = att[:type]
            a.filename = att[:filename]
            a.disposition = att[:disposition]
            a.content_id = att[:content_id]
            mail.add_attachment(a)
        end

        response = @client.client.mail._('send').post(request_body: mail.to_json)
        log_response(response)
        response
    end

    private

    def log_response(response)
        Rails.logger.info("[SendGrid] status: #{response.status_code}, body: #{response.body}")
    end
end