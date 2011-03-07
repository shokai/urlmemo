$(function(){
    $('input#btnsave').click(save);
});

var save = function(){
    console.log('save');
    var post_data = {
        url : $('input#url').val(),
        title : $('input#title').val()
    }
    $.post(app_root, post_data, function(res){
		if(res.error) message(res.error);
        else{
            message('saved!');
            location.href = app_root;
        }
	},'json');
};

var message = function(mes){
    alert(mes);
};