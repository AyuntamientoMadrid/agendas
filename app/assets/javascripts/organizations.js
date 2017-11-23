$(function(){
  $('#nested-legal-representant').bind('cocoon:after-insert', function() {
    $("#legal_representant_link").hide();
  });
  $('#nested-legal-representant').bind("cocoon:after-remove", function() {
    $("#legal_representant_link").show();
  });

  $(".organization-form").validate({
      ignore: [],
      errorElement: "small",
      rules : {
        "organization[name]" : {
            required : true
        },
        "organization[email]" : {
            required : true
        },
        "organization[user_attributes][password]" : {
            required : true
        },
        "organization[first_name]" : {
            required : true
        },
        "organization[last_name]" : {
            required : true
        }
      },

      messages : {
        "organization[name]" : {
            required : "Añade el nombre"
        },
        "organization[email]" : {
            required : "Añade email"
        },
        "organization[user_attributes][password]" : {
            required : "Añade contraseña"
        },
        "organization[first_name]" : {
            required : "Añade nombre"
        },
        "organization[last_name]" : {
            required : "Añade apellido"
        }
      },

      errorPlacement : function(error, element) {
          error.insertAfter(element);
      }
  });

});
