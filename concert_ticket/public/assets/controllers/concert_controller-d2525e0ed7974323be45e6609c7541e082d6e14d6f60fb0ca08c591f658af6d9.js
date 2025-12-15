import { Controller } from "@hotwired/stimulus"

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
                
            }catch(exception){

            }

        })
    }
};
