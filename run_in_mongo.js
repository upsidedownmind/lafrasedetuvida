
//see http://docs.mongodb.org/manual/tutorial/create-an-auto-incrementing-field/

db.system.js.save(
                   { _id: "getNewFraseID",
                     value : function(x) { 
			var ret = db.counters.findAndModify(
				  {
				    query: { _id: "fraseid" },
				    update: { $inc: { seq: 1 } },
				    new: true
				  }
			   );

			   return ret.seq;	
	  
			}
                   }
                 );

db.counters.insert(
   {
      _id: "fraseid",
      seq: 0
   }
);

// db.frases.insert({ numero:getNewFraseID(), frase:'Lorem ipsum dolor sit armet 1'  })