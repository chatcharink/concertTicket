import { Controller } from "@hotwired/stimulus"
import $ from 'jquery'
import DataTable from 'datatables.net-bs5'

export default class extends Controller {
    connect() {
        // this.connect_datatable();
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
                { data: 'action' }
            ],
            columnDefs: [
                { width: "25%", targets: 0 },
                { width: "15%", targets: 1 },
                { width: "10%", targets: 2 },
                { width: "15%", targets: 3 },
                { width: "18%", targets: 4 },
                { width: "17%", targets: 5 },
                { width: "5%", targets: 6 },
                { class: "px-6 py-4", targets: [0,3,4,5]},
                { class: "text-center px-6 py-4", targets: [1,2,6]}
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
                { data: 'action' }
            ],
            columnDefs: [
                { width: "25%", targets: 0 },
                { width: "15%", targets: 1 },
                { width: "10%", targets: 2 },
                { width: "15%", targets: 3 },
                { width: "18%", targets: 4 },
                { width: "17%", targets: 5 },
                { width: "5%", targets: 6 },
                { class: "px-6 py-4", targets: [0,3,4,5]},
                { class: "text-center px-6 py-4", targets: [1,2,6]}
            ],
            rowCallback: function (row, data) {
                $(row).addClass("font-athiti font-medium bg-white border-b dark:bg-gray-800 dark:border-gray-700 border-gray-200 hover:bg-red-300 dark:hover:bg-gray-600");
            },
            destroy: true
        });
        table.columns.adjust().draw();
    }
};
