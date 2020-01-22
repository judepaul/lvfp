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
//= require popper
//= require bootstrap-sprockets

$(document).ready(function () {
    $('.email_code').click(function () {
        var code = $(this).text();
        var content = $('.email_content_'+code).text();
        $('#display_speech_content').value = "";
        $('#display_speech_content').text(content);
        $('.speak').removeAttr('disabled');
    });



    if ('speechSynthesis' in window) {
  
      $('.speak').click(function(){
        var text = $('#display_speech_content').val();
        var msg = new SpeechSynthesisUtterance();
        var voices = window.speechSynthesis.getVoices();
        msg.text = text;
        msg.lang = 'en-US';
        msg.voice = voices.filter(function(voice) { return voice.name == 'Alex'; })[0];
        msg.rate = 1.0;
        msg.pitch = 1;
        msg.onend = function(e) {
          console.log('Finished in ' + event.elapsedTime + ' seconds.');
        };
  
        speechSynthesis.speak(msg);
      })
    } else {
      $('#modal1').openModal();
    }



  });