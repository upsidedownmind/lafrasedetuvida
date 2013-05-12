

function loadList() {

  $('#frasesList').html('');

  $.getJSON(  
    '/frases',  
    {},  
    function(json) {
      $(json).each(function(idx,data){
        add2List(data)
      })
    })
    
    //.done(function() { console.log( "second success" ); })
    .fail(function() { alert( "error cargando frases" ); })
    //.always(function() { console.log( "complete" ); });
	
}

function add2List(data) {

  $('#frasesList').prepend('<li class="media"><div class="media-body"><strong>#'+data.numero+'</strong> '+data.frase+'</div></li>')

}

$(document).ready(function() {
	
  $.ajaxSetup ({  
    cache: false  
  }); 
 
  //loadList();
  
  $('#dice').click(function(){

    $('#frasetop').html('...');

    $.getJSON(  
    '/fraserandom',  
    {},  
    function(json) {
      if(json.frase) {
        $('#frasetop').html('<strong>#'+json.numero+'</strong> '+json.frase);
      }
    })
    
    //.done(function() { console.log( "second success" ); })
    .fail(function() { alert( "error cargando frases" ); })
    //.always(function() { console.log( "complete" ); });


  });
	
  $('#addFraseBtn').click(function () {
  
    var frase = $('#frase').val() ;

    if(frase.trim() == "") {
      alert('Ingrese frase');
      return;
    }
    
    $.ajax({
      type: 'POST',
      url:  '/frase',
      data: {'frase': frase},
      success: function (data) {
        
        if(data.result && data.result=='OK') {
          add2List(data.record)
        } else {
          alert('La frase no se agrego')
        }
        
        console.log(data);
      }
    })
      .fail(function() { alert( "error creando frases" ); })
    ;
 
  });
	
});

