require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    character_set = ("A".."Z").to_a
    @letters = (0...10).map { character_set[rand(character_set.size)] }
  end

  def score
    @answer = params[:word]
    @grid = params[:letters]
    @new_grid = @grid.split(" ")
    @message = ""
    if word_test(@answer) && grid_test(@answer, @new_grid)
      @message = "Contratulations! #{@answer} is a valid English word!"
    else
      @message = word_test(@answer) ? "Sorry but #{@answer} can't be built out of #{@grid.join(" ")}" : "Sorry but #{@answer} is not an english word"
    end
  end

  def word_test(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    user_serialized = URI.open(url).read
    hash = JSON.parse(user_serialized)
    return hash["found"]
  end

  def grid_test(attempt, grid)
    counter = 0
    attempt.upcase.split("").each do |letter|
      grid.each_with_index do |grid_element, i|
        next unless letter == grid_element
        counter += 1
        grid.delete_at(i)
      end
    end
    counter >= attempt.length
  end
end
