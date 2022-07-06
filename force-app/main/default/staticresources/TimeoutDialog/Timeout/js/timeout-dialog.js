/*
 * timeout-dialog.js
 *
 * String formatting, you might want to remove this if you already use it.
 * Example:
 * 
 * var location = 'World';
 * alert('Hello {0}'.format(location));
 */
String.prototype.format = function() {
  var s = this,
      i = arguments.length;

  while (i--) {
    s = s.replace(new RegExp('\\{' + i + '\\}', 'gm'), arguments[i]);
  }
  return s;
};

!function($) {
  $.timeoutDialog = function(options) {

    var settings = {           
      title : 'Your session has expired',
      message : 'Your session has timed out due to {0} minutes of inactivity. Click OK to close this window. You may need to log in again.',  
	  timeout: 15,
      button_text: 'OK', 
      dialog_width: 350
    }    

    $.extend(settings, options);

    var TimeoutDialog = {
      init: function () {			  
        this.setupDialog();
      },       

      setupDialog: function() {
        var self = this;
        self.destroyDialog();

        $('<div id="timeout-dialog">' +
            '<p id="timeout-message">' + settings.message.format(settings.timeout) + '</p>' + '</div>')
        .appendTo('body')
        .dialog({
          modal: true,
          width: settings.dialog_width,
          minHeight: 'auto',
          zIndex: 10000,
          closeOnEscape: false,
          draggable: false,
          resizable: false,
          dialogClass: 'timeout-dialog',
          title: settings.title,
          buttons : {
            'ok-button' : { 
              text: settings.button_text,
              id: "timeout-ok-btn",
              click: function() {
                $(this).dialog("close");				
				window.close();
              }
            }            
          }
        });
		
      },

      destroyDialog: function() {
        if ($("#timeout-dialog").length) {
          $(this).dialog("close");
          $('#timeout-dialog').remove();
        }
      } 
	  
    };

    TimeoutDialog.init();
  };
}(window.jQuery);