import { Controller } from "@hotwired/stimulus"
import $ from 'jquery'

export default class extends Controller {
  connect() {
    // this.element.textContent = "Hello World!"
  }

  generateQr(event){
    event.preventDefault();
    let location = document.getElementById("place-name");
    let location_validate_msg = document.getElementById("location-validate-msg");
    let quota = document.getElementById("number");
    let quota_validate_msg = document.getElementById("quota-validate-msg");
    let email = document.getElementById("email");
    let email_validate_msg = document.getElementById("email-validate-msg");
    let phone_number = document.getElementById("phone_number");
    let phone_validate_msg = document.getElementById("phone-validate-msg");
    let valid_data = false;

    if (location.value == ""){
      location.setAttribute("class", "block w-full rounded-md px-3 py-1.5 font-athiti bg-red-50 border-red-500 text-red-900 placeholder-red-700 -outline-offset-1 outline-gray-200 focus:border-gray-200 focus:border-gray-200 rounded-s-lg sm:text-sm focus:z-10 disabled:opacity-50 disabled:pointer-events-none sm:text-sm/6");
      location_validate_msg.style.display = "block";
    } 
    else
    {
      location.setAttribute("class", "block w-full rounded-md bg-white px-3 py-1.5 font-athiti border-gray-400 -outline-offset-1 outline-gray-200 focus:border-gray-200 focus:border-gray-200 rounded-s-lg sm:text-sm focus:z-10 disabled:opacity-50 disabled:pointer-events-none placeholder:text-gray-400 sm:text-sm/6");
      location_validate_msg.style.display = "none";
      valid_data = true;
    }

    if ((/[0-9]/).test(quota.value)){
      quota.setAttribute("class", "block w-full rounded-md bg-white px-3 py-1.5 font-athiti border-gray-400 -outline-offset-1 outline-gray-200 focus:border-gray-200 focus:border-gray-200 rounded-s-lg sm:text-sm focus:z-10 disabled:opacity-50 disabled:pointer-events-none placeholder:text-gray-400 sm:text-sm/6");
      quota_validate_msg.style.display = "none";
      valid_data = true;
    } 
    else
    {
      quota.setAttribute("class", "block w-full rounded-md px-3 py-1.5 font-athiti bg-red-50 border-red-500 text-red-900 placeholder-red-700 -outline-offset-1 outline-gray-200 focus:border-gray-200 focus:border-gray-200 rounded-s-lg sm:text-sm focus:z-10 disabled:opacity-50 disabled:pointer-events-none sm:text-sm/6");
      quota_validate_msg.style.display = "block";
      valid_data = false;
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
      const generate_qr = fetch(event.target.action, {
        method: 'POST',
        body: new FormData(event.target),
      }).then(response => {
        if (response.ok) {
            return response.text();
        }
      });

      generate_qr.then((data) => {
        try{
          let result = JSON.parse(data);
          this.alert(result["status"], result["message"]);
        } catch {
          $("#display-qr-code").html("");
          $("#display-qr-code").html(data);
          this.showModal();
          location.value = "";
          quota.value = "";
          email.value = "";
          phone_number.value = "";
        }
      });
    }
  }

  set_invalid_message(msg){
    return '<p class="mt-2 text-sm text-red-600 dark:text-red-500"><span class="font-medium">Error: </span>'+msg+'</p>'
  }

  search_qr(){
    let location = document.getElementById("search-location-with-icon");
    let url = document.getElementById("url-for-search-qr-by-location").value;
    if (location.value != ""){
      const find_qr = fetch(url+"?searchValue="+location.value).then(response => {
        if (response.ok) {
          return response.text();
        }
      });

      find_qr.then((data) => {
        try{
          let result = JSON.parse(data);
          this.alert(result["status"], result["message"]);
        }catch(error){
          $("#display-qr-code").html("");
          $("#display-qr-code").html(data);
          this.showModal();
          location.value = "";
        }
      });
    }
  }

  showModal(){
    const targetEl = document.getElementById("qr-static-modal");
    const options = {
      placement: 'center-center',
      backdrop: 'static',
      backdropClasses:
          'bg-gray-900/50 dark:bg-gray-900/80 fixed inset-0 z-40',
      closable: false
    };
    const modal = new Modal(targetEl, options);
    modal.show();
    let btn_close = document.getElementById("close-qr-modal");
    btn_close.addEventListener("click", function() {
      modal.hide();
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


}
