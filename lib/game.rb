# class for game
class Game
  attr_accessor :price, :description, :name, :genre, :comments, :ratings,
                :comment_count
  def initialize(data)
    @name = data[:name]
    @description = data[:description]
    @genre = data[:genre]
    @price = data[:price]
    @comment_count = 0
    @comments = []
    @ratings = {}
  end

  def rate(data)
    return unless check_user(data[:user]) && check_rating(data[:rating])
    if ratings.key?(data[:user])
      puts 'this user has already rated'
    else
      @ratings[data[:user]] = data[:rating]
    end
  end

  def check_user(user)
    if user.is_a? User
      return true
    else
      puts 'This is not a user'
    end
  end

  def check_rating(rating)
    if (0..5).include?(rating)
      return true
    else
      puts 'raiting is not valid'
    end
  end

  def add_comment(data)
    @comment_count += 1
    @comments.push(Comment.new(user: data[:user], text: data[:text],
                               id: comment_count))
  end
end
