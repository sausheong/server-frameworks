module Views
  
  class Layout < Mustache
    attr_accessor :page, :logged_in
    
    def initialize(page)
      @page = page
      @logged_in = false
    end

    def authenticated
      @logged_in, page.logged_in = true, true
      self
    end
    
    def toolbar
      toolbar = Views::Toolbar.new
      toolbar.logged_in = logged_in
      toolbar.render
    end

    def view
      page.render
    end
  end  

  class Toolbar < Mustache
    attr_accessor :logged_in
    
  end
  
  class Index < Mustache
    attr_accessor :posts, :page, :logged_in
    
    def initialize
      @logged_in = false
    end
    
    def posts
      @posts.order_by(:created_at.desc).offset((page-1) * 5).limit(5).to_a
    end
    
    def show_pagination?
      page_count > 1
    end
    
    def page_count
      if @posts.size % 5 == 0
        @posts.size / 5
      else
        (@posts.size / 5) + 1
      end
    end
    
    def pages 
      (1..page_count).map {|n| {'page' => n} }
    end
    
    def first_page?
      page == 1
    end
    
    def last_page?
      page == page_count
    end  
  
  end  

  module Post
    
    class View < Mustache
      attr_accessor :post, :logged_in

      def initialize
        @logged_in = false
      end
      
      def comments_in_reverse
        post.comments.reverse
      end
      
    end  

    class Edit < View; end    
    class New < View; end
  end

  
end