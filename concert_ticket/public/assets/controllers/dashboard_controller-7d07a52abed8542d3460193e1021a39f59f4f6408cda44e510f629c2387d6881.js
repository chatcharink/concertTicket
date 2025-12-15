import { Controller } from "@hotwired/stimulus"
import $ from 'jquery'
import DataTable from 'datatables.net-bs5'
import "select2"

export default class extends Controller {
    connect() {
        // this.connect_datatable();
    	$("#dashboard-filter-company").select2({
            width: "35%"
        }).on("change", function(){
            let selected_company = document.getElementById("dashboard-filter-company");
            let url = document.getElementById("filter-company-url").value;
            const get_specific_company = fetch(url+"?id="+selected_company.value).then(response => {
                if (response.ok) {
                    return response.text();
                }
            });

            get_specific_company.then((data) => {
                try{
                    let result = JSON.parse(data);
                    
                }catch(exception){
                    $(".graph-details").html("");
                    $(".graph-details").html(data);
                }

            })
        });
    }

    connect_datatable(){
        let table = $("#table-dashboard").DataTable({
            paging: false,
            destroy: true,
            processing: true,
            serverSide: true,
            // pageLength: 20,
            dom: '<t>',
            ajax: { url: $("#table-dashboard").data('url'),
                    contentType: "application/json"
            },
            columns: [
                { data: 'name' },
                { data: 'phone_number' },
                { data: 'gender' },
                { data: 'channel_to_know' },
                { data: 'location' },
                { data: 'province' },
                { data: 'workshop' },
                { data: 'concert' },
                { data: 'action' }
            ],
            columnDefs: [
                { width: "19%", targets: 0 },
                { width: "12%", targets: 1 },
                { width: "10%", targets: 2 },
                { width: "13%", targets: 3 },
                { width: "13%", targets: 4 },
                { width: "13%", targets: 5 },
                { width: "5%", targets: 6 },
                { width: "5%", targets: 7 },
                { width: "10%", targets: 8 },
                { class: "px-6 py-4", targets: [0,3,4,5]},
                { class: "text-center px-6 py-4", targets: [1,2,6,7]},
                { class: "inline-flex text-center px-6 py-4", targets: [8]}
            ],
	    rowCallback: function (row, data) {
                $(row).addClass("font-athiti font-medium bg-white border-b dark:bg-gray-800 dark:border-gray-700 border-gray-200 hover:bg-red-300 dark:hover:bg-gray-600");
            },
            destroy: true
        });
        table.columns.adjust().draw();
    }

    show_detail(){
        this.connect_datatable();
    }

    search_detail(){
        let search_data = document.getElementById("search-detail");
        console.log(search_data.value);
        let table = $("#table-dashboard").DataTable({
            paging: false,
            destroy: true,
            processing: true,
            serverSide: true,
            // pageLength: 20,
            dom: '<tp>',
            ajax: { url: $("#table-dashboard").data('url'),
                    contentType: "application/json",
                    data: {"search_value": search_data.value}
            },
            columns: [
                { data: 'name' },
                { data: 'phone_number' },
                { data: 'gender' },
                { data: 'channel_to_know' },
                { data: 'location' },
                { data: 'province' },
                { data: 'workshop' },
                { data: 'concert' },
                { data: 'action' }
            ],
            columnDefs: [
                { width: "19%", targets: 0 },
                { width: "12%", targets: 1 },
                { width: "10%", targets: 2 },
                { width: "13%", targets: 3 },
                { width: "13%", targets: 4 },
                { width: "13%", targets: 5 },
                { width: "5%", targets: 6 },
                { width: "5%", targets: 7 },
                { width: "10%", targets: 8 },
                { class: "px-6 py-4", targets: [0,3,4,5]},
                { class: "text-center px-6 py-4", targets: [1,2,6,7]},
                { class: "inline-flex text-center px-6 py-4", targets: [8]}
            ],
	    rowCallback: function (row, data) {
                $(row).addClass("font-athiti font-medium bg-white border-b dark:bg-gray-800 dark:border-gray-700 border-gray-200 hover:bg-red-300 dark:hover:bg-gray-600");
            },
            destroy: true
        });
        table.columns.adjust().draw();
    }

    setDeleteId(event){
        event.preventDefault();
        let url = event.params["url"];
        let delete_button = document.getElementById("confirm-delete-user");
        delete_button.setAttribute("data-action", "click->dashboard#deleteUser");
        delete_button.setAttribute("data-url", url);
        // document.getElementById("btn-confirm-delete-modal").click();

        const targetEl = document.getElementById("delete-popup-modal");
        const options = {
            placement: 'center-center',
            backdrop: 'static',
            backdropClasses:
                'bg-gray-900/50 dark:bg-gray-900/80 fixed inset-0 z-40',
            closable: false
        };

        const modal = new Modal(targetEl, options);
        modal.show();
        let btn_close = document.getElementById("btn-close-confirm-delete-modal");
        btn_close.addEventListener("click", function() {
            modal.hide();
        });
    }
    
    deleteUser(){
        let delete_button = document.getElementById("confirm-delete-user");
        let url = delete_button.getAttribute("data-url");
        const delete_menu = fetch(url, {
            method: 'DELETE',
            headers: {
                "Content-Type": "application/json",
                "X-CSRF-Token": this.getCsrfToken()
            }
        }).then(response => {
            if (response.ok) {
                return response.text();
            }
        });
    
        delete_menu.then((data) => {
            try{
                let result = JSON.parse(data);
                this.alert(result["status"], result["message"]);
            } catch(e) {
                console.log(e);
                $("#styled-detail").html("");
                $("#styled-detail").html(data);
                const targetEl = document.getElementById("delete-popup-modal");
                const options = {
                    placement: 'center-center',
                    backdrop: 'static',
                    backdropClasses:
                        'bg-gray-900/50 dark:bg-gray-900/80 fixed inset-0 z-40',
                    closable: false
                };

                const modal = new Modal(targetEl, options);
                modal.hide();
                this.connect_datatable();
                this.alert("success", "Delete registered user succussfully.");
            }
        });
    }

    alert_icon(state){
        let icon = ""
        switch(state){
    //     <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24" fill="#currentColor">
    // <circle cx="12" cy="12" r="10" /><path fill="#fff" d="M11 6h2v8h-2zM11 16h2v2h-2z"/></svg>
            case "success":
                icon = '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-check-circle-fill alert-icon-success" viewBox="0 0 16 16"><path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0m-3.97-3.03a.75.75 0 0 0-1.08.022L7.477 9.417 5.384 7.323a.75.75 0 0 0-1.06 1.06L6.97 11.03a.75.75 0 0 0 1.079-.02l3.992-4.99a.75.75 0 0 0-.01-1.05z"/></svg>';
                break;
            case "error":
                icon = '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-exclamation-circle-fill alert-icon-error" viewBox="0 0 16 16"><path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0M8 4a.905.905 0 0 0-.9.995l.35 3.507a.552.552 0 0 0 1.1 0l.35-3.507A.905.905 0 0 0 8 4m.002 6a1 1 0 1 0 0 2 1 1 0 0 0 0-2"/></svg>';
                break;
        }
        return icon
    }

    alert(type, message){
        let main_div = document.createElement("div");
        main_div.setAttribute("class", "absolute w-full top-0 flex items-center p-4 mb-4 z-10 div-alert-"+type)
        main_div.setAttribute("role", "alert");
        main_div.setAttribute("id", "alert-border-1");

        let toast_header = document.createElement("div");
        toast_header.setAttribute("class", "ms-3 font-athiti text-sm font-medium");
        toast_header.innerHTML = message;
        let icon = this.alert_icon(type);
        main_div.innerHTML += icon;
        main_div.appendChild(toast_header);

        let close_icon = document.createElement("button");
        close_icon.setAttribute("type", "button");
        close_icon.setAttribute("class", "ms-auto -mx-1.5 -my-1.5 rounded-lg focus:ring-2 p-1.5 inline-flex items-center justify-center h-8 w-8 cursor-pointer btn-close-alert-"+type);
        close_icon.setAttribute("data-dismiss-target", "#alert-border-1");
        close_icon.setAttribute("aria-label", "Close");

        close_icon.innerHTML += '<span class="sr-only">Dismiss</span>';
        close_icon.innerHTML += '<svg class="w-3 h-3" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 14 14"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m1 1 6 6m0 0 6 6M7 7l6-6M7 7l-6 6"/></svg>';
        main_div.appendChild(close_icon);

        document.getElementsByTagName("body")[0].appendChild(main_div);

        setTimeout(function(){
        main_div.remove();
        }, 5000);
    }

    getCsrfToken() {
        return document.querySelector('meta[name="csrf-token"]').content;
    }
};
