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
//= require bootbox
//= require data-confirm-modal


$(document).ready(function () {

    //Tooltip in the Articles modal popup icons
    $('[data-toggle="tooltip"]').tooltip();

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


    //FAQ Modal screenwise
    $('#FAQcontentModal-campiagn').on('shown.bs.modal', function (event) { 
        // $('.modal-content .modal-body #section-2').show();
        // });
        var section = $('#section-2');
        section.css('background-color', '').css('background-color', '#e9ecef');
        // scroll modal to position top
        var position = section.position();
        $("#FAQcontentModal-campiagn").scrollTop(position.top);
    });
      
    $('.campaing-show').on('click',function(){   
        $('#FAQcontentModal-campiagn').modal('show');
    });
    $('#FAQcontentModal-article').on('shown.bs.modal', function (event) { 
        // $('.modal-content .modal-body #section-2').show();
        // });
        var section = $('#section-3');
        section.css('background-color', '').css('background-color', '#e9ecef');
        // scroll modal to position top
        var position = section.position();
        $("#FAQcontentModal-article").scrollTop(position.top);
    });
      
    $('.article-show').on('click',function(){   
        $('#FAQcontentModal-article').modal('show');
    });


        //Speech content Modal Window
        $('#contentModal').on('show.bs.modal', function(e) { //subscribe to show method
            var getContentFromRow = $(event.target).closest('tr').data('content'); 
            var getIdFromRow = $(event.target).closest('tr').data('id');
            $('.delete-speech').attr('href', '/speeches/' + getIdFromRow);
            //Set the value into modal div
            $(this).find('#contentDetails').text(getContentFromRow);
            //Set the value to fetch the content for Audio
            $(this).find('#speech_content').val(getContentFromRow);
            speakText();
            // Reset the toggle to show the play icon while loading the modal window
            $(".play span").html("").html('<i class="fa fa-play-circle fa-lg" aria-hidden="true"></i>');
        });

        // Add minus icon for collapse element which is open by default
        $(".collapse.show").each(function(){
        	$(this).prev(".card-header").find("i").addClass("fa-minus").removeClass("fa-plus");
        });
        
        // Toggle plus minus icon on show hide of collapse element
        $(".collapse").on('show.bs.collapse', function(){
        	$(this).prev(".card-header").find("i").removeClass("fa-plus").addClass("fa-minus");
        }).on('hide.bs.collapse', function(){
        	$(this).prev(".card-header").find("i").removeClass("fa-minus").addClass("fa-plus");
        });

        //Stop Audio transcription while close the modal window
        $('.close-modal').click(function(){
            var myAudio = document.getElementById("audioPlayback");
            myAudio.pause();
        });

        $("#delete-btn").click(function(){
		    $("#delete-confirm-pane").show(600);
		});
		$("#delete-confirm-cancel").click(function(){
            $("#delete-confirm-pane").hide(600);
        });
        
        //Campaign Validation
        $("#campaign-save").click(function(){
            access_code_title = $("#access_code_title").val();
            if(access_code_title.length <= 0){
                bootbox.alert('Please enter the campaign name');
                $("#access_code_title").css("border-color","red");
                return false;
            }else{
                $("#access_code_title").css("border","none");
            }
        });
        
        $("#access_code_title").keyup(function(){
            access_code_title = $(this).val();
            if(access_code_title.length > 0){
                $("#access_code_title").css("border","1px solid #ced4da");
            }
        });

        //Campaign Validation
        $("#save_content").click(function(){
			article_name = $("#article_name").val();
            //access_code_title = $("#article_title").val();
            acc_code_id = $("#acc_code_id").val();
			add_speech_content = $("#add_speech_content").val();
            var msg = "";
			var newLine = "\r\n"
            if(article_name.length <= 0){
                msg += "Please enter the article name";
				msg += newLine;
                $("#article_name").css("border-color","red");
            }else{
                $("#article_name").css("border","none");
            }
				//             if(access_code_title.length <= 0){
				//                 msg += "Please enter the article title";
				// msg += newLine;
				//                 $("#article_title").css("border-color","red");
				//             }else{
				//                 $("#article_title").css("border","none");
				//             }
            if(add_speech_content.length <= 0){
                msg += "Please enter the article content";
				msg += newLine;
                $("#acc_code_id").css("border-color","red");
			}else if (add_speech_content.length > 2999) {
                msg += "Content character limit exists";
				msg += newLine;
                $("#acc_code_id").css("border-color","red");
            }else{
                $("#acc_code_id").css("border","none");
            }
            if(msg == ""){
                return true;
            }else{
                alert(msg);
                return false;
            }
        });
        

        // $(".action").hover(function() {
        //     $(this).prop("checked", !$(this).prop("checked"));
        //   });

        $(".studio-card-header").mouseover(function() {
            $('.studio-card-body').show();
            $('.skill-card-body').hide();
        });
        $(".studio-card-body").mouseover(function() {
            $(this).show();
        });
        $(".studio-card-body").mouseout(function() {
            $(this).hide();
        });

        $(".skill-card-header").mouseover(function() {
            $('.skill-card-body').show();
            $('.studio-card-body').hide();
        });
        $(".skill-card-body").mouseover(function() {
            $(this).show();
        });
        $(".skill-card-body").mouseout(function() {
            $(this).hide();
        });

        $(".anal-card-header").mouseover(function() {
            $('.skill-card-body').hide();
            $('.studio-card-body').hide();
        });
       

        // Manage Articles show action buttons on the table row
        $(".table tr").mouseover(function(){
            $(".actions", this).show()
        })
        $(".table tr").mouseout(function(){
            $(".actions", this).hide()
        }) 

    //cards
    // $('.studio-card').mouseover(function(){
    //     $('.studio-img').hide();
    //     $('.card-text').show();
    // });
    // $('.studio-card').mouseout(function(){
    //     $('.studio-img').show();
    //     $('.card-text').hide();
    // });

    $(".dropdown-studio").hover(            
        function() {
            $('.studio-menu', this).stop( true, true ).slideDown("150");
        },
        function() {
            $('.studio-menu', this).stop( true, true ).slideUp("150");
        });

    $(".dropdown-skill").hover(            
        function() {
            $('.skill-menu', this).stop( true, true ).slideDown("150");
        },
        function() {
            $('.skill-menu', this).stop( true, true ).slideUp("150");
    });  

    $(".dropdown-analytics").hover(            
        function() {
            $('.analytics-menu', this).stop( true, true ).slideDown("150");
        },
        function() {
            $('.analytics-menu', this).stop( true, true ).slideUp("150");
    });
    
    $(".dropdown-logout").hover(            
        function() {
            $('.logout-menu', this).stop( true, true ).slideDown("150");
        },
        function() {
            $('.logout-menu', this).stop( true, true ).slideUp("150");
    });

    // $("#nav-all-tab").click(function(){
    //     var access_code = $(this).data("access-code");
    //     alert(access_code);
    //     var url = "/voice-chimp-studio/articles/getArticlesByType";
    //     var data = {access_code: access_code, tab: 'All'};
    //     //window.location.href = "/voice-chimp-studio/articles?tab=All&code="+access_code;
    //     //$.get("/voice-chimp-studio/articles/getArticlesByType", {access_code: access_code, tab: 'All'});
        
    // });

    // $("#nav-draft-tab").click(function(){
    //     var access_code = $(this).data("access-code");
    //     window.location.href = "/voice-chimp-studio/articles?tab=Draft&code="+access_code;
    // });

    // $("#nav-published-tab").click(function(){
    //     var access_code = $(this).data("access-code");
    //     window.location.href = "/voice-chimp-studio/articles?tab=Published&code="+access_code;
    // });

    // Dashboard card effects
    // $( ".dashboard-card" ).hover(
    //     function() {
    //       $(this).addClass('shadow-lg').css('cursor', 'pointer'); 
    //     }, function() {
    //       $(this).removeClass('shadow-lg');
    //     }
    //   );
    
  });

  function nav_all_tab(code){
    //alert(code);
    var url = "/voice-reader-studio/articles/getArticlesByType";
    var data = {access_code: code, tab: 'All'};
    return $.ajax({
        type: "POST",
        url: url,
        data: data
      });
  }

  function nav_draft_tab(code){
    //alert(code);
    var url = "/voice-reader-studio/articles/getArticlesByType";
    var data = {access_code: code, tab: 'Draft'};
    return $.ajax({
        type: "POST",
        url: url,
        data: data
      });
  }

  function nav_published_tab(code){
    //alert(code);
    var url = "/voice-reader-studio/articles/getArticlesByType";
    var data = {access_code: code, tab: 'Published'};
    return $.ajax({
        type: "POST",
        url: url,
        data: data
      });
  }
  
  function tab_delete(code, tab){
    alert(code);
    alert(tab);
    var url = "/voice-reader-studio/articles/getArticlesByType";
    var data = {access_code: code, tab: tab};
    // return $.ajax({
    //     type: "POST",
    //     url: url,
    //     data: data
    //   });
  }
  