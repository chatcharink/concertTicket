class DashboardDetailDatatable < ApplicationDatatable
  extend Forwardable
  def_delegator :@view, :session
  def_delegator :@view, :t
  def_delegator :@view, :button_to 
  def_delegator :@view, :registration_user_send_mail_path
  def_delegator :@view, :registration_user_path

  def initialize(params, opts = {})
    @view = opts[:view_context]
    super
  end

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      name: { source: "RegisteredUser.firstname", cond: :like },
      phone_number: { source: "RegisteredUser.phone_number", cond: :like },
      gender: { source: "RegisteredUser.gender", cond: :eq },
      channel_to_know: { source: "RegisteredUser.channel_to_know", cond: :eq },
      location: { source: "QrInfo.location", cond: :like },
      province: {source: "RegisteredUser.province", cond: :like},
      workshop: {source: "RegisteredUser.workshop", cond: :eq},
      concert: {source: "RegisteredUser.concert", cond: :eq},
      action: {source: "RegisteredUser.id", cond: :eq},
    }
  end

  def data
    records.map do |record|
      {
        name: get_name(record),
        phone_number: record.phone_number,
        gender: get_gender(record.gender),
        channel_to_know: record.channel_name_en,
        location: record.location,
        province: get_province_district(record),
        workshop: get_event_icon(record.workshop),
        concert: get_event_icon(record.concert),
        action: get_action(record)
      }
    end
  end

  def get_raw_records
    # insert query here
    register = RegisteredUser.select("qr_infos.location, qr_infos.event_id, channel_to_knows.channel_name_th, channel_to_knows.channel_name_en,registered_users.*").where.not(status: "inactive")
    register = register.where("qr_infos.event_id = ?", session["current_user"]["selected_event"]["id"])
    if params["search_value"].present?
      gender_id = case params["search_value"]
                  when "male" then 1
                  when "female" then 2
                  when "not specific" then 3
                  else nil
                  end 
      register = register.where("registered_users.firstname like ? 
        or registered_users.lastname like ? 
        or registered_users.phone_number like ? 
        or registered_users.gender like ? 
        or channel_to_knows.channel_name_en like ? 
        or qr_infos.location like ? 
        or registered_users.province like ?", "%#{params["search_value"]}%", "%#{params["search_value"]}%", "%#{params["search_value"]}%", gender_id, "%#{params["search_value"]}%", "%#{params["search_value"]}%", "%#{params["search_value"]}%")
    end
    register = register.joins("left join qr_infos on qr_infos.id = registered_users.qr_id")
    register = register.joins("left join channel_to_knows on channel_to_knows.id = registered_users.channel_to_know")
    register
  end

  private
  def get_name record
    name = "#{record.firstname} #{record.lastname}"
    name
  end

  def get_gender gender
    gender_name = case gender
                  when 1 then "Male"
                  when 2 then "Female"
                  else "Not specific"
                  end
    gender_name
  end

  def get_province_district record
    province = record.province.blank? ? "-" : record.province
    district = record.district.blank? ? "-" : record.district
    return "#{province}/#{district}"
  end

  def get_action record
    links = []
    links << button_to(
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" class="w-4 h-4" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <path d="M22 2L11 13" />
        <path d="M22 2L15 22L11 13L2 9L22 2Z" />
      </svg>'.html_safe, registration_user_send_mail_path(id: record.id), class: "inline-flex rounded-md bg-red-900 px-2 py-2 me-2 text-sm font-semibold text-white shadow-xs hover:bg-red-700 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-red-900 cursor-pointer")
    links << button_to(
      '<svg class="w-4 h-4" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 24 24">
        <path fill-rule="evenodd" d="M8.586 2.586A2 2 0 0 1 10 2h4a2 2 0 0 1 2 2v2h3a1 1 0 1 1 0 2v12a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V8a1 1 0 0 1 0-2h3V4a2 2 0 0 1 .586-1.414ZM10 6h4V4h-4v2Zm1 4a1 1 0 1 0-2 0v8a1 1 0 1 0 2 0v-8Zm4 0a1 1 0 1 0-2 0v8a1 1 0 1 0 2 0v-8Z" clip-rule="evenodd"/>
      </svg>'.html_safe, "#", class: "inline-flex rounded-md bg-red-900 px-2 py-2 text-sm font-semibold text-white shadow-xs hover:bg-red-700 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-red-900 cursor-pointer", data: {action: "click->dashboard#setDeleteId", "dashboard-url-param": registration_user_path(id: record.id)})
    
    links.join(" ").html_safe
  end

  def get_event_icon data
    icons = []
    if data.to_i > 0
      icons << '<svg class="w-6 h-6 text-gray-800 dark:text-white" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="currentColor" viewBox="0 0 24 24" style="color:#771D1D; justify-self: center;">
                <path fill-rule="evenodd" d="M2 12C2 6.477 6.477 2 12 2s10 4.477 10 10-4.477 10-10 10S2 17.523 2 12Zm13.707-1.293a1 1 0 0 0-1.414-1.414L11 12.586l-1.793-1.793a1 1 0 0 0-1.414 1.414l2.5 2.5a1 1 0 0 0 1.414 0l4-4Z" clip-rule="evenodd"/>
              </svg>'

    else
      icons << '<svg class="w-6 h-6 text-gray-800 dark:text-white" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24" style="justify-self: center;">
                <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m15 9-6 6m0-6 6 6m6-3a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z"/>
              </svg>'
    end
    icons.join(" ").html_safe
  end
end
