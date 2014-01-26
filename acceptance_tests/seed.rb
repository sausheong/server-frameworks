class User < Struct.new(:email, :password)
end
class Post < Struct.new(:heading, :content)
end

class Seeder

  def comment
    @comment ||= File.open("seed/comment.txt", 'r').read
  end
  
  def post(type=:txt)
    lines = File.open("seed/post.#{type.to_s}", 'r').readlines
    heading = lines.shift
    content = lines.join
    @post ||= Post.new(heading.chomp, content)
  end

  def user(name)
    if name == :adam
      User.new("adam_gfedity_tan@tfbnw.net", "Dev.123") 
    elsif name == :brad
      User.new("brad_oscwqzm_martin@tfbnw.net", "Dev.123") 
    elsif name == :cindy
      User.new("cindy_ahmcgwr_garcia@tfbnw.net", "Dev.123") 
    end
  end

end