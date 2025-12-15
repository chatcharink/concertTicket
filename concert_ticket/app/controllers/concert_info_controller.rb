class ConcertInfoController < ApplicationController
    def index
        return redirect_to login_path() if session["current_user"].blank?
        @concert = ConcertInfo.all
        @deafult_concert = @concert.where(is_default: 1).first
        session["current_user"]["selected_event"] = Hash.new
    end

    def create
        form_concert = params["form_concert"]
        action = "create"
        begin
            if is_duplicate_event?(form_concert["event_name"]) && form_concert["update_id"].blank?
                flash[:error] = "Event: #{form_concert["event_name"]} already exists."
                redirect_to root_path()
            else
                checked_default = form_concert["is_default"].to_i
                check_default(checked_default)
                if form_concert["update_id"].blank?
                    concert = ConcertInfo.create(
                        concert_name: form_concert["event_name"],
                        event_day: form_concert["event_date"],
                        is_default: checked_default
                    )
                    action = "create"
                else
                    concert = ConcertInfo.update(form_concert["update_id"],
                        concert_name: form_concert["event_name"],
                        event_day: form_concert["event_date"],
                        is_default: checked_default
                    )
                    action = "update"
                end
                if concert.save!
                    flash[:success] = "#{action.capitalize} event: #{form_concert["event_name"]} successfully."
                    redirect_to root_path()
                else
                    flash[:error] = "Cannot #{action} event: #{form_concert["event_name"]} because database has something went wrong. Please contact admin."
                    redirect_to root_path()
                end
            end
        rescue => e
            p "Error: #{e.message}"
            p "Error: #{e.backtrace.first}"
            flash[:error] = "Cannot create event because has something went wrong. Please contact admin."
            redirect_to root_path()
        end
    end

    def get_default
        concert = ConcertInfo.find(params["id"])
        is_default = 0
        unless concert.blank?
            is_default = concert.is_default
        end

        respond_to do |format|
            format.json { render :json => {is_default: is_default} }
        end
    end

    def select_event
        form_concert = params["form_select_concert"]
        begin
            selected_event = ConcertInfo.find(form_concert["event"])
            session["current_user"]["selected_event"] = Hash.new
            session["current_user"]["selected_event"]["name"] = selected_event.concert_name
            session["current_user"]["selected_event"]["id"] = form_concert["event"]
            checked_default = form_concert["is_default"].to_i
            check_default(checked_default, form_concert["event"])
            update_default = selected_event.update(is_default: checked_default)
            flash[:success] = "Welcome to Event: #{selected_event.concert_name}"
            redirect_to report_path()
        rescue => e
            flash[:error] = "Cannot select event because has something went wrong. Please contact admin."
            redirect_to root_path()
        end
    end

    def get_concert_info
        selected_event = ConcertInfo.find(params["id"])
        render(
            partial: "concert_info/new_event_modal",
            formats: [:html, :js, :json, :url_encoded_form],
            locals: {title: t("add_event.title_edit"), button: t("add_event.btn_update_event"), id: selected_event.id, name: selected_event.concert_name, date: selected_event.event_day, is_check: selected_event.is_default == 1}
        )
    end

    private
    def is_duplicate_event? name
        has_event = ConcertInfo.where(concert_name: name).count
        has_event > 0
    end

    def check_default default_value, id=nil
        if default_value > 0
            concert = ConcertInfo.where(is_default: 1)
            concert = concert.where.not(id: id) unless id.blank?
            concert = concert.update_all(is_default: 0)
        end
    end
end
