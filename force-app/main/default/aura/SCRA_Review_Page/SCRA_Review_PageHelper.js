({
	delayedRefresh : function(milliseconds){
    let ms = milliseconds || 500;
    window.setTimeout($A.getCallback(function(){
        $A.get('e.force:refreshView').fire();
    }),ms);
},
})