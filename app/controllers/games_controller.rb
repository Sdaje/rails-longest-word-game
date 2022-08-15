require "json"
require "open-uri"

class GamesController < ApplicationController
  ALPHABET = ('A'..'Z').to_a

  def new
    @letters = []
    10.times { @letters << ALPHABET.sample }
  end

  def score
    answer = params[:answer].upcase.chars

    url = "https://wagon-dictionary.herokuapp.com/#{params[:answer]}"
    dictionnary_serialized = URI.open(url).read
    dictionnary = JSON.parse(dictionnary_serialized)

    letters = JSON.parse(params[:letters])
    create_with_grid = answer.all? do |letter|
      answer.count(letter) <= letters.count(letter)
    end
    @result = if create_with_grid == false
                "Sorry but #{params[:answer]} can't be built out of #{letters}"
              elsif dictionnary["found"] == false
                "Sorry but #{params[:answer]} doesn't seem to be a valid english word"
              elsif answer == []
                "No answer !"
              else
                "Congratulations"
              end
  end
end
