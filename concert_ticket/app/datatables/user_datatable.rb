class UserDatatable < AjaxDatatablesRails::ActiveRecord
  extend Forwardable
  def_delegator :@view, :session
  def_delegator :@view, :button_to 
  def_delegator :@view, :edit_user_path 
  def_delegator :@view, :user_path 

  def initialize(params, opts = {})
    @view = opts[:view_context]
    super
  end

  def view_columns
    @view_columns ||= {
      username: { source: "User.username", cond: :like },
      name: { source: "User.firstname", cond: :like },
      email: { source: "User.email", cond: :like },
      phone_number: { source: "User.phone_number", cond: :like },
      status: { source: "User.status", cond: :eq },
      action: { source: "User.id", cond: :like }
    }
  end

  def data
    records.map do |record|
      {
        username: record.username,
        name: get_name(record),
        email: record.email,
        phone_number: record.phone_number,
        status: get_status(record.status),
        action: get_action(record)
      }
    end
  end

  def get_raw_records
    user = User.all
    if params["search_value"].present?
      user = user.where("users.username like ? or users.firstname like ? 
        or users.lastname like ? 
        or users.phone_number like ? 
        or users.email like ?
        or users.status like ?", "%#{params["search_value"]}%", "%#{params["search_value"]}%", "%#{params["search_value"]}%", "%#{params["search_value"]}%", "%#{params["search_value"]}%", "%#{params["search_value"]}%")
    end
    user
  end

  private
  def get_name record
    name = "#{record.firstname} #{record.lastname}"
    name
  end

  def get_status status
    color = case status
            when "active" then "#31C48D"
            else "#9CA3AF" end 
    status_badge = []
    status_badge << "<span class=\"inline-flex items-center align-middle justify-center w-4 h-4 mx-2 rounded-full\" style=\"background: #{color}\"></span>"
    status_badge << "<span>#{status.capitalize}</span>"
    status_badge.join(' ').html_safe
  end

  def get_action user
    actions = []
    actions << "<a href=#{edit_user_path(id: user.id)} class=\"nav-link mx-1 d-inline\">"
    actions << '<svg class="w-6 h-6 text-gray-800 dark:text-white inline-flex" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" viewBox="0 0 24 24"><path fill-rule="evenodd" d="M14 4.182A4.136 4.136 0 0 1 16.9 3c1.087 0 2.13.425 2.899 1.182A4.01 4.01 0 0 1 21 7.037c0 1.068-.43 2.092-1.194 2.849L18.5 11.214l-5.8-5.71 1.287-1.31.012-.012Zm-2.717 2.763L6.186 12.13l2.175 2.141 5.063-5.218-2.141-2.108Zm-6.25 6.886-1.98 5.849a.992.992 0 0 0 .245 1.026 1.03 1.03 0 0 0 1.043.242L10.282 19l-5.25-5.168Zm6.954 4.01 5.096-5.186-2.218-2.183-5.063 5.218 2.185 2.15Z" clip-rule="evenodd"/></svg>'
    actions << "</a>"
    # actions << "<a href=#{user_path(id: additional.id)} class=\"nav-link mx-1 d-inline\">"
    unless user.id == 1 || user.status == "deleted"
      actions << "<svg class=\"w-6 h-6 text-gray-800 dark:text-white inline-flex cursor-pointer\" aria-hidden=\"true\" xmlns=\"http://www.w3.org/2000/svg\" width=\"20\" height=\"20\" fill=\"currentColor\" viewBox=\"0 0 24 24\" data-action=\"click->user#setDeleteId\" data-user-url-param=\"#{user_path(id: user.id)}\" data-user-name-param=\"#{user.firstname} #{user.lastname}\"><path fill-rule=\"evenodd\" d=\"M8.586 2.586A2 2 0 0 1 10 2h4a2 2 0 0 1 2 2v2h3a1 1 0 1 1 0 2v12a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V8a1 1 0 0 1 0-2h3V4a2 2 0 0 1 .586-1.414ZM10 6h4V4h-4v2Zm1 4a1 1 0 1 0-2 0v8a1 1 0 1 0 2 0v-8Zm4 0a1 1 0 1 0-2 0v8a1 1 0 1 0 2 0v-8Z\" clip-rule=\"evenodd\"/></svg>"
    end
    actions.join(' ').html_safe
  end

end
