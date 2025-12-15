import { Controller } from "@hotwired/stimulus"
import $ from 'jquery'
import DataTable from 'datatables.net-bs5'

export default class extends Controller {
    connect() {
        // this.connect_datatable();
        this.connect_datatable();
    }

    connect_datatable(){
        let table = $("#table-user").DataTable({
            paging: false,
            destroy: true,
            processing: true,
            serverSide: true,
            // pageLength: 20,
            dom: '<t>',
            ajax: { url: $("#table-user").data('url'),
                    contentType: "application/json"
            },
            columns: [
                { data: 'username' },
                { data: 'name' },
                { data: 'email' },
                { data: 'phone_number' },
                { data: 'status' },
                { data: 'action' }
            ],
            columnDefs: [
                { width: "15%", targets: 0 },
                { width: "25%", targets: 1 },
                { width: "15%", targets: 2 },
                { width: "15%", targets: 3 },
                { width: "15%", targets: 4 },
                { width: "15%", targets: 5 },
                { class: "px-6 py-4", targets: [0,1,2,3]},
                { class: "text-center px-6 py-4", targets: [4,5]}
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
        let table = $("#table-user").DataTable({
            paging: false,
            destroy: true,
            processing: true,
            serverSide: true,
            // pageLength: 20,
            dom: '<tp>',
            ajax: { url: $("#table-user").data('url'),
                    contentType: "application/json",
                    data: {"search_value": search_data.value}
            },
            columns: [
                { data: 'username' },
                { data: 'name' },
                { data: 'email' },
                { data: 'phone_number' },
                { data: 'status' },
                { data: 'action' }
            ],
            columnDefs: [
                { width: "15%", targets: 0 },
                { width: "25%", targets: 1 },
                { width: "15%", targets: 2 },
                { width: "15%", targets: 3 },
                { width: "15%", targets: 4 },
                { width: "15%", targets: 5 },
                { class: "px-6 py-4", targets: [0,1,2,3]},
                { class: "text-center px-6 py-4", targets: [4,5]}
            ],
            rowCallback: function (row, data) {
                $(row).addClass("font-athiti font-medium bg-white border-b dark:bg-gray-800 dark:border-gray-700 border-gray-200 hover:bg-red-300 dark:hover:bg-gray-600");
            },
            destroy: true
        });
        table.columns.adjust().draw();
    }

    setDeleteId(event){
        let url = event.params["url"];
        let name = event.params["name"];
        let delete_button = document.getElementById("confirm-delete-button");
        delete_button.setAttribute("data-controller", "user");
        delete_button.setAttribute("data-action", "click->user#deleteUser");
        delete_button.setAttribute("data-url", url);
        document.getElementById("btn-toggle-confirm-delete").click();
        //document.getElementById("confirm-delete-text").innerHTML = "Are you want to sure to delete user : "+name+" ?";
    }
    
    deleteUser(){
        let delete_button = document.getElementById("confirm-delete-button");
        let url = delete_button.getAttribute("data-url");
        const delete_user = fetch(url, {
            method: 'DELETE',
            headers: {
                "Content-Type": "application/json",
                "X-CSRF-Token": this.getCsrfToken()
            },
            body: JSON.stringify({ "name": name }),
        }).then(response => {
            if (response.ok) {
                return response.text();
            }
        });
    
        delete_user.then((data) => {
            try{
                let result = JSON.parse(data);
                if (result["status"] == "success"){
                    window.location.replace(result["redirect_url"]);
                } else {
                    this.alert(result["status"], result["message"]);
                }
            } catch {
            //   $("#close-confirm-delete-user").click();
            //   this.alert("success", "Delete user : "+name+" successfully");
            //   this.searchUser();
                // $("#div-body-subject").html(data);
            }
        });
    }

    getCsrfToken() {
        return document.querySelector('meta[name="csrf-token"]').content;
    }

    showPassword(){
        document.getElementById("password").type = "text";
    }

    hidePassword(){
        document.getElementById("password").type = "password";
    }
};
