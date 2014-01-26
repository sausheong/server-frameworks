require 'sequel'

Sequel.migration do
  change do
    create_table :users do
      primary_key :id
      DateTime :created_at
      String :email, size: 255
      String :password
      String :name, size: 255        
    end

    create_table :posts do
      primary_key :id
      DateTime :created_at
      String :heading, size: 255
      Text :content
      foreign_key :user_id, :users
    end
    
    create_table :comments do
      primary_key :id
      DateTime :created_at
      Text :content
      foreign_key :post_id, :posts  
      foreign_key :user_id, :users  
    end
  end  
end