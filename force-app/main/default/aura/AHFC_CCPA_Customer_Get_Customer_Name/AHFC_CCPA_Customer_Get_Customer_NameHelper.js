({
    // validate string input field data
    validateName : function(name)
    {
        var regex = /[A-Za-z, ]+$/; 
        var validName=false;
        
        if(name!=null  && name!='undefined')
        {
            if(name.match(regex))
            {
                validName=true;
            }
        }
        return validName;
    }
})