# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"

# DataTables, Buttons Plugin, and jQuery
pin "datatables.net"                   , to: "https://cdn.datatables.net/2.1.8/js/dataTables.mjs"
pin "datatables.net-bs5"               , to: "https://cdn.datatables.net/2.1.8/js/dataTables.bootstrap5.mjs"
pin "datatables.net-fixedcolumns"      , to: "https://cdn.datatables.net/fixedcolumns/5.0.3/js/dataTables.fixedColumns.mjs"
pin "datatables.net-fixedcolumns-bs5"  , to: "https://cdn.datatables.net/fixedcolumns/5.0.3/js/fixedColumns.bootstrap5.mjs"
# pin "datatables.net-bs5"            , to: "https://cdn.datatables.net/v/dt/dt-2.1.8/datatables.min.js"

pin "jquery"                      , to: "https://ga.jspm.io/npm:jquery@3.6.1/dist/jquery.js"
pin "flowbite"                    , to: "https://cdn.jsdelivr.net/npm/flowbite@3.1.2/dist/flowbite.turbo.min.js"
pin "select2"                     , to: "https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"

pin "chartkick", to: "chartkick.js"
pin "Chart.bundle", to: "Chart.bundle.js"
