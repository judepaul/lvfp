// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery3
//= require jquery_ujs
//= require popper
//= require bootstrap-sprockets
//= require toastr


$(document).ready(function () {

    toastr.options = {
        "closeButton": false,
        "debug": false,
        "newestOnTop": false,
        "progressBar": true,
        "positionClass": "toast-top-full-width",
        "preventDuplicates": false,
        "onclick": null,
        "showDuration": "3000",
        "hideDuration": "1000",
        "timeOut": "5000",
        "extendedTimeOut": "1000",
        "showEasing": "swing",
        "hideEasing": "linear",
        "showMethod": "fadeIn",
        "hideMethod": "fadeOut"
      }

    $('.email_code').click(function () {
        var code = $(this).text();
        var content = $('.email_content_'+code).text();
        var access_code = $('.client_access_code_'+code).text();
        var speech_id = $('.speech_'+code).val();
        $('.delete_speech').show();
        $(".delete_speech").attr("href", "/speeches/"+speech_id);
        $('#client_access_code').text(access_code);
        $('#display_speech_content').value = "";
        $('#display_speech_content').text(content);
        $('.speak').removeAttr('disabled');
        $('.audioPlayback').removeAttr('disabled');
        
        speakText();
    });

  });


  