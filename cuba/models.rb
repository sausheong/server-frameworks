# require 'sequel'
# require "../sinatra/models"

Mongoid.load!("mongoid.yml", :development)
Mongoid.raise_not_found_error = false

class User
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  store_in collection: "users", database: "blog"
  
  field :name, type: String
  field :email, type: String
  field :password, type: String


end

class Post
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  
  store_in collection: "posts", database: "blog"
  
  field :heading, type: String
  field :content, type: String
  field :created_at, type: DateTime
  
  belongs_to :user
  embeds_many :comments
end

class Comment
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  
  field :content, type: String
  field :created_at, type: DateTime
    
  belongs_to :user
  embedded_in :post
end