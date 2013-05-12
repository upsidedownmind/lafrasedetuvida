require 'sinatra'
require 'mongo'
require 'json/ext' # required for .to_json

include Mongo

helpers do

  def get_connection
    #TODO: mejorar la forma de realizar la conexion
    
    return @db_connection if @db_connection

    uri = ENV['MONGOHQ_URL']
    
    if uri.nil?
      uri = "mongodb://localhost:27017/frasesDB"
    end
    
    db = URI.parse( uri )
    db_name = db.path.gsub(/^\//, '')
    @db_connection = Mongo::Connection.new(db.host, db.port).db(db_name)
    @db_connection.authenticate(db.user, db.password) unless (db.user.nil? || db.user.nil?)
    @db_connection
  end

  def getDB
    get_connection['frases']
  end
  
  def remove_id obj
    obj.delete('_id')
    obj
  end

  def getNextFraseNumber
    get_connection.eval( "getNewFraseID()" )
  end
  
end


get '/' do

  #TODO: buscar una mejor manera de hacer esto
  ids = getDB.find({},fields:{_id:1}).to_a
  fraserandom = getDB.find(ids.sample).first

  erb :index, :locals => {:fraserandom => remove_id(fraserandom)}
end

get '/frases/?' do
  content_type :json
  getDB.find.sort( { :numero => 1 } ).map{|x| remove_id(x)}.to_json
end

get '/frase/:numero/?' do
  content_type :json
  remove_id( getDB.find_one(:numero => params[:numero]) ).to_json
 
end

post "/frase" do
  content_type :json

  if params['frase'].empty?
    { 'result'=> 'ERROR'}.to_json
    
  else
    record = { "numero" => getNextFraseNumber, 'frase' => params['frase']  }
  
    getDB.insert record
  
    { 'result'=> 'OK', 'record'=>remove_id(record)}.to_json
   
  end
  
  
end

