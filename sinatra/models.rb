DB = Sequel.connect 'postgres://blogs:blogs@localhost:5432/blogs'
DB.extension :pagination

module BlogModel
  def before_create
    super
    self.created_at = DateTime.now
  end 

  def is_owned_by(a_user)
    user.email = a_user
  end  
end

class User < Sequel::Model
  include BlogModel
  one_to_many :posts
  one_to_many :comments
end

class Post < Sequel::Model
  include BlogModel
  one_to_many :comments
  many_to_one :user
  

end

class Comment < Sequel::Model
  include BlogModel
  many_to_one :post
  many_to_one :user
end