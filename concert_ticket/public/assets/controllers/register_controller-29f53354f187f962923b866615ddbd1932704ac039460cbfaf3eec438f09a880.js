import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    connect() {
    
    }

    changeCountry(){
        let province_select = document.getElementById("province-select");
        let province_text = document.getElementById("province-text");
        let province = document.getElementById("province");
        let country = document.getElementById("country");

        if (country.value == "TH")
        {
            province_select.style.display = "block";
            province_text.style.display = "none";
            country.value = "TH";
            province.value = "กรุงเทพมหานคร";
        }
        else
        {
            province_select.style.display = "none";
            province_text.style.display = "block";
            province.value = "";
        }
    }

    getAge(){
        let dob = document.getElementById("dob");
        if (dob.value !== ""){
            let today = new Date();
            let birthDate = new Date(dob.value);
            let age = today.getFullYear() - birthDate.getFullYear();
            let m = today.getMonth() - birthDate.getMonth();
            if (m < 0 || (m === 0 && today.getDate() < birthDate.getDate())) {
                age--;
                m = birthDate.getMonth() - today.getMonth();
            }
            document.getElementById("age").value = age+" ปี "+m+" เดือน";
        }
    }

    submitRegister(event){
        event.preventDefault();
        let firstname = document.getElementById("first-name");
        let firstname_validate_msg = document.getElementById("firstname-validate-msg");

        let lastname = document.getElementById("last-name");
        let lastname_validate_msg = document.getElementById("lastname-validate-msg");

        let phone_number = document.getElementById("phone-number");
        let phone_validate_msg = document.getElementById("phone-validate-msg");

        let email = document.getElementById("email");
        let email_validate_msg = document.getElementById("email-validate-msg");
        let valid_data = false;

        if (firstname.value == ""){
            firstname.setAttribute("class", "block w-full rounded-md px-3 py-1.5 font-athiti bg-red-50 border-red-500 text-red-900 placeholder-red-700 -outline-offset-1 outline-gray-200 focus:border-gray-200 focus:border-gray-200 rounded-s-lg sm:text-sm focus:z-10 disabled:opacity-50 disabled:pointer-events-none sm:text-sm/6");
            firstname_validate_msg.style.display = "block";
        } 
        else
        {
            firstname.setAttribute("class", "block w-full rounded-md bg-white px-3 py-1.5 font-athiti border-gray-400 -outline-offset-1 outline-gray-200 focus:border-gray-200 focus:border-gray-200 rounded-s-lg sm:text-sm focus:z-10 disabled:opacity-50 disabled:pointer-events-none placeholder:text-gray-400 sm:text-sm/6");
            firstname_validate_msg.style.display = "none";
            valid_data = true;
        }

        if (lastname.value == ""){
            lastname.setAttribute("class", "block w-full rounded-md px-3 py-1.5 font-athiti bg-red-50 border-red-500 text-red-900 placeholder-red-700 -outline-offset-1 outline-gray-200 focus:border-gray-200 focus:border-gray-200 rounded-s-lg sm:text-sm focus:z-10 disabled:opacity-50 disabled:pointer-events-none sm:text-sm/6");
            lastname_validate_msg.style.display = "block";
        } 
        else
        {
            lastname.setAttribute("class", "block w-full rounded-md bg-white px-3 py-1.5 font-athiti border-gray-400 -outline-offset-1 outline-gray-200 focus:border-gray-200 focus:border-gray-200 rounded-s-lg sm:text-sm focus:z-10 disabled:opacity-50 disabled:pointer-events-none placeholder:text-gray-400 sm:text-sm/6");
            lastname_validate_msg.style.display = "none";
            valid_data = true;
        }
      
        if (email.value == ""){
            email.setAttribute("class", "block w-full rounded-md px-3 py-1.5 font-athiti bg-red-50 border-red-500 text-red-900 placeholder-red-700 -outline-offset-1 outline-gray-200 focus:border-gray-200 focus:border-gray-200 rounded-s-lg sm:text-sm focus:z-10 disabled:opacity-50 disabled:pointer-events-none sm:text-sm/6");
            email_validate_msg.style.display = "block";
            valid_data = false;
        } 
        else
        {
            email.setAttribute("class", "block w-full rounded-md bg-white px-3 py-1.5 font-athiti border-gray-400 -outline-offset-1 outline-gray-200 focus:border-gray-200 focus:border-gray-200 rounded-s-lg sm:text-sm focus:z-10 disabled:opacity-50 disabled:pointer-events-none placeholder:text-gray-400 sm:text-sm/6");
            email_validate_msg.style.display = "none";
            valid_data = true;
        }
      
        if (phone_number.value == ""){
            phone_number.setAttribute("class", "block w-full rounded-md px-3 py-1.5 font-athiti bg-red-50 border-red-500 text-red-900 placeholder-red-700 -outline-offset-1 outline-gray-200 focus:border-gray-200 focus:border-gray-200 rounded-s-lg sm:text-sm focus:z-10 disabled:opacity-50 disabled:pointer-events-none sm:text-sm/6");
            phone_validate_msg.style.display = "block";
            valid_data = false;
        } 
        else
        {
            phone_number.setAttribute("class", "block w-full rounded-md bg-white px-3 py-1.5 font-athiti border-gray-400 -outline-offset-1 outline-gray-200 focus:border-gray-200 focus:border-gray-200 rounded-s-lg sm:text-sm focus:z-10 disabled:opacity-50 disabled:pointer-events-none placeholder:text-gray-400 sm:text-sm/6");
            phone_validate_msg.style.display = "none";
            valid_data = true;
        }

        if (valid_data){
            let loading_btn = document.getElementById("btn-submit-form-register");
            let btn_text = loading_btn.innerHTML;
            loading_btn.innerHTML = '<svg aria-hidden="true" role="status" class="inline w-4 h-4 me-3 text-gray-200 animate-spin dark:text-gray-600 fill-gray-600 dark:fill-gray-300" viewBox="0 0 100 101" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M100 50.5908C100 78.2051 77.6142 100.591 50 100.591C22.3858 100.591 0 78.2051 0 50.5908C0 22.9766 22.3858 0.59082 50 0.59082C77.6142 0.59082 100 22.9766 100 50.5908ZM9.08144 50.5908C9.08144 73.1895 27.4013 91.5094 50 91.5094C72.5987 91.5094 90.9186 73.1895 90.9186 50.5908C90.9186 27.9921 72.5987 9.67226 50 9.67226C27.4013 9.67226 9.08144 27.9921 9.08144 50.5908Z" fill="currentColor"/><path d="M93.9676 39.0409C96.393 38.4038 97.8624 35.9116 97.0079 33.5539C95.2932 28.8227 92.871 24.3692 89.8167 20.348C85.8452 15.1192 80.8826 10.7238 75.2124 7.41289C69.5422 4.10194 63.2754 1.94025 56.7698 1.05124C51.7666 0.367541 46.6976 0.446843 41.7345 1.27873C39.2613 1.69328 37.813 4.19778 38.4501 6.62326C39.0873 9.04874 41.5694 10.4717 44.0505 10.1071C47.8511 9.54855 51.7191 9.52689 55.5402 10.0491C60.8642 10.7766 65.9928 12.5457 70.6331 15.2552C75.2735 17.9648 79.3347 21.5619 82.5849 25.841C84.9175 28.9121 86.7997 32.2913 88.1811 35.8758C89.083 38.2158 91.5421 39.6781 93.9676 39.0409Z" fill="currentFill"/></svg>';
            loading_btn.innerHTML += "Loading...";
            loading_btn.setAttribute("disabled", "true");
            const register = fetch(event.target.action, {
                method: 'POST',
                body: new FormData(event.target),
            }).then(response => {
                if (response.ok) {
                    return response.text();
                }
            });
        
            register.then((data) => {
                try{
                    result = JSON.parse(data);
                    if (result["redirect_url"] != null){
                        window.location.replace(result["redirect_url"]);
                    } 
                    else 
                    {
                        this.alert(result["status"], result["message"]);
                    }
                } catch {
                    $("#div-form-register").html("");
                    $("#div-form-register").html(data);
                }
                loading_btn.innerHTML = btn_text;
                loading_btn.setAttribute("disabled", "false");
            });
        }
    }

    getOtherUser(event){
        let url = event.params["url"];
        
        const get_content = fetch(url).then(response => {
            if (response.ok) {
            return response.text();
            }
        });

        get_content.then((data) => {
            try{
                let result = JSON.parse(data);
                if (result["state"] == "success"){
                    // let application_path = document.getElementById("application-path");
                    // window.location.replace(application_path.value+"/homework");
                } else {
                    // this.alert(result["state"], result["message"]);
                }
            }catch(error){
                $("#div-form-register").html("");
                $("#div-form-register").html(data);
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
};
