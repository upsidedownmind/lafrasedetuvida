require 'sinatra'
require 'mongo'
require 'json/ext' # required for .to_json

include Mongo

configure do
  conn = MongoClient.new("localhost", 27017)
  set :mongo_connection, conn
  set :mongo_db, conn.db('frasesDB')
end

helpers do
  
  def remove_id obj
    obj.delete('_id')
    obj
  end

  def getDB
    settings.mongo_db['frases']
  end

  def getNextFraseNumber
    settings.mongo_db.eval( "getNewFraseID()" )
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

