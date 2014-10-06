# class for game
class Game
  attr_accessor :price, :description, :name, :genre, :comments, :ratings
  def initialize(data)
    @name = data[:name]
    @description = data[:description]
    @genre = data[:genre]
    @price = data[:price]
    @comments = []
    @ratings = {}
  end

  def rate(data)
    return unless check_user(data[:user]) && check_rating(data[:rating])
    if ratings.key?(data[:user])
      fail StandartError, 'this user has already rated'
    else
      @ratings[data[:user]] = data[:rating]
    end
  end

  def check_user(user)
    if user.is_a? User
      return true
    else
      fail TypeError, 'This is not a user'
    end
  end

  def check_rating(rating)
    if (0..5).include?(rating)
      return true
    else
      fail StandartError, 'raiting is not valid'
    end
  end
end
