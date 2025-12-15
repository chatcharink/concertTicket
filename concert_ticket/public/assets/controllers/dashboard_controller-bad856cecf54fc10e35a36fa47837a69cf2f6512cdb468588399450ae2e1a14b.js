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
                { width: "15%", targets: 4 },
                { width: "15%", targets: 5 },
                { width: "8%", targets: 6 },
                { width: "8%", targets: 7 },
                { width: "5%", targets: 8 },
                { class: "px-6 py-4", targets: [0,3,4,5]},
                { class: "text-center px-6 py-4", targets: [1,2,6,7,8]}
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
                { width: "15%", targets: 4 },
                { width: "15%", targets: 5 },
                { width: "8%", targets: 6 },
                { width: "8%", targets: 7 },
                { width: "5%", targets: 8 },
                { class: "px-6 py-4", targets: [0,3,4,5]},
                { class: "text-center px-6 py-4", targets: [1,2,6,7,8]}
            ],
            rowCallback: function (row, data) {
                $(row).addClass("font-athiti font-medium bg-white border-b dark:bg-gray-800 dark:border-gray-700 border-gray-200 hover:bg-red-300 dark:hover:bg-gray-600");
            },
            destroy: true
        });
        table.columns.adjust().draw();
    }
};
