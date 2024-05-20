require 'net/http'
require 'uri'
require 'json'

class GamesController < ApplicationController
  def new
    vowels = %w[a e i o u]
    selected_vowels = vowels.sample(2)
    @letters = (selected_vowels + (0...(10 - selected_vowels.size)).map { ('a'..'z').to_a[rand(26)] }).shuffle
  end

  def score
    letters = params[:letters].split
    word = params[:word].chars

    if (word - letters).empty?
      @uri = URI.parse("https://dictionary.lewagon.com/#{params[:word]}")
      @response = Net::HTTP.get_response(@uri)
      @data = JSON.parse(@response.body)

      if @data["found"]
        @result = "Congratulations! #{params[:word].upcase} is a valid English word!"
      else
        @result = "Sorry but #{params[:word].upcase} does not seem to be a valid English word..."
      end

    else
      @letters = letters.join(', ').upcase
      @result = "Sorry but #{params[:word].upcase} can't be built out of #{@letters}"
    end

  end
end
