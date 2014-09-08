

	$(document).ready(function lastMessage() {
	
	newURL = window.location.protocol + "//" + window.location.host;

$('#lastmessage').html('<img src="../templates/default/images/loader.gif" width="16" height="16" />&nbsp; loading...');	
$("#lastmessage").load(newURL +'/status.php?randval='+ Math.random());	

});

function killEnter(e){
        e = e? e : window.event;
        var k = e.keyCode? e.keyCode : e.which? e.which : null;
        if (k == 13){
        if (e.preventDefault)
        e.preventDefault();
        return false;
        };
        return true;
        };
        if(typeof document.addEventListener!='undefined')
        document.addEventListener('keydown', killEnter, false);
        else if(typeof document.attachEvent!='undefined')
        document.attachEvent('onkeydown', killEnter);
        else{
        if(document.onkeydown!=null){
        var oldOnkeydown=document.onkeydown;
        document.onkeydown=function(e){
        oldOnkeydown(e);
        killEnter(e);
        };}
        else
        document.onkeydown=killEnter;
}
