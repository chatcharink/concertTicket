class DashboardController < ApplicationController
    include DashboardHelper
    require 'axlsx'

    def index
        return redirect_to login_path() if session["current_user"].blank?
        count_register_user()
    end

    def datatables
        respond_to do |format|
            format.html
            format.json { render json: DashboardDetailDatatable.new(params, view_context: view_context) } 
        end
    end

    def filter_company
        count_register_user(params["id"])
        render(
            partial: "dashboard/graph",
            formats: [:html, :js, :json, :url_encoded_form],
            locals: { }
        )
    end

    def download_report
        users = RegisteredUser.where.not(status: "inactive")
        users = RegisteredUser.select("channel_to_knows.channel_name_en, qr_infos.location, registered_users.*").where.not(status: "inactive")
        users = users.where("qr_infos.event_id = ?", session["current_user"]["selected_event"]["id"])
        users = users.joins("left join qr_infos on qr_infos.id = registered_users.qr_id")
        users = users.joins("left join channel_to_knows on channel_to_knows.id = registered_users.channel_to_know").order(:qr_id)

        # สร้างไฟล์ Excel
        package = Axlsx::Package.new
        workbook = package.workbook

        workbook.add_worksheet(name: "Report") do |sheet|
            # Header row
            sheet.add_row ["Ticket from", "Name", "Date of birth", "Gender", "Telephone", "Email", "Province/District", "Channal to know", "Interest workshop", "Interest concert"]

            # Data rows
            users.each do |u|
                dob = u.dob.blank? ? "-" : u.dob.strftime("%d/%m/%Y")
                gender = case u.gender
                        when 1 then "Male"
                        else "Female"
                        end
                workshop = u.workshop.to_i > 0 ? "สนใจ" : "ไม่สนใจ"
                concert = u.concert.to_i > 0 ? "สนใจ" : "ไม่สนใจ"
                sheet.add_row [u.location, "#{u.firstname} #{u.lastname}", dob, gender, u.phone_number, u.email, "#{u.province}/#{u.district}", u.channel_name_en, workshop, concert], types: [:string, :string, :string, :string, :string, :string, :string, :string, :string, :string]
            end
        end

        # ส่งไฟล์ให้ดาวน์โหลด
        send_data package.to_stream.read,
                    filename: "SWMF-report_#{Time.zone.now.strftime('%Y%m%d_%H%M%S')}.xlsx",
                    type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                    disposition: "attachment"
    end
end
