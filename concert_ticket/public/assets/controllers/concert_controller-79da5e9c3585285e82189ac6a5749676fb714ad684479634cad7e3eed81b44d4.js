import { Controller } from "@hotwired/stimulus"
import $ from 'jquery'

export default class extends Controller {
    connect() {
        // this.element.textContent = "Hello World!"
    }

    select_event(event){
        let selected_event = document.getElementById("concert_name");
        let url = event.params["url"];
        const get_default = fetch(url+"?id="+selected_event.value).then(response => {
            if (response.ok) {
            return response.text();
            }
        });

        get_default.then((data) => {
            try{
                let result = JSON.parse(data);
                var d_checkbox = document.getElementById("is_default");
                if (parseInt(result["is_default"]) > 0){
                    d_checkbox.checked = true;
                } else {
                    d_checkbox.checked = false;
                }
                document.getElementById("edit-concert-id").setAttribute("data-id", selected_event.value);
            }catch(exception){

            }

        })
    }

    clearData(){
        let title = document.getElementById("title-action-event");
        title.innerHTML = title.getAttribute("data-default");
        let btn_submit = document.getElementById("btn-submit-action-event");
        btn_submit.value = btn_submit.getAttribute("data-default");

        document.getElementById("event-name").value = "";
        document.getElementById("event-date").value = "";
        document.getElementById("update-event-id").value = "";
        document.getElementById("set_default").checked = false;
        const targetEl = document.getElementById("new-event-modal");
        const options = {
            placement: 'center-center',
            backdrop: 'static',
            backdropClasses:
                'bg-gray-900/50 dark:bg-gray-900/80 fixed inset-0 z-40',
            closable: false
        };
        const modal = new Modal(targetEl, options);
        modal.show();
        let btn_close = document.getElementById("close-event-action-modal");
        btn_close.addEventListener("click", function() {
            modal.hide();
        });
    }

    editConcert(event){
        let url = event.params["url"];
        let event_id = document.getElementById("edit-concert-id").getAttribute("data-id");

        if (parseInt(event_id) > 0){
            const get_concert_info = fetch(url+"?id="+event_id).then(response => {
                if (response.ok) {
                return response.text();
                }
            });

            get_concert_info.then((data) => {
                try{
                    let result = JSON.parse(data);
                }catch(exception){
                    $("#div-action-concert-info").html("");
                    $("#div-action-concert-info").html(data);
                    const targetEl = document.getElementById("new-event-modal");
                    const options = {
                    placement: 'center-center',
                    backdrop: 'static',
                    backdropClasses:
                        'bg-gray-900/50 dark:bg-gray-900/80 fixed inset-0 z-40',
                    closable: false
                    };
                    const modal = new Modal(targetEl, options);
                    modal.show();
                    let btn_close = document.getElementById("close-event-action-modal");
                    btn_close.addEventListener("click", function() {
                        modal.hide();
                    });
                }
            })
        }
    }
};
