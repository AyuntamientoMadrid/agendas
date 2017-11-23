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
        "organization[user_attributes][first_name]" : {
            required : true
        },
        "organization[user_attributes][last_name]" : {
            required : true
        },
        "organization[user_attributes][email]" : {
            required : true
        },
        "organization[user_attributes][password]" : {
            required : true
        },
        "organization[user_attributes][password_confirmation]" : {
            required : true
        }
      },

      messages : {
        "organization[name]" : {
            required : "Añade el nombre"
        },
        "organization[user_attributes][first_name]" : {
            required : "Añade el nombre"
        },
        "organization[user_attributes][last_name]" : {
            required : "Añade Apellido"
        },
        "organization[user_attributes][password]" : {
            required : "Añade contraseña"
        },
        "organization[user_attributes][phones]" : {
            required : "Añade telefóno"
        },
        "organization[user_attributes][email]" : {
            required : "Añade Email"
        },
        "organization[user_attributes][password]" : {
            required : "Añade Contraseña"
        },
        "organization[user_attributes][password_confirmation]" : {
            required : "Confirmar Contraseña"
        }
      },

      errorPlacement : function(error, element) {
          error.insertAfter(element);
      }
  });

});
