require 'rest-client'
require 'json'
require 'pry'


def get_character_movies_from_api(character)
  #make the web request
  all_characters = RestClient.get('http://www.swapi.co/api/people/')
  character_hash = JSON.parse(all_characters)
  
  # iterate over the character hash to find the collection of `films` for the given
  #   `character`

  url_for_movies = ""

  character_hash["results"].each do |names|
    if names["name"] == character
      url_for_movies = (names["films"])
    end
  end
  # collect those film API urls, make a web request to each URL to get the info
  #  for that film

  movie_info = []

  url_for_movies.each do |url|
    x = RestClient.get(url)
    x = JSON.parse(x)
    movie_info.push(x)
  end

  return movie_info
  # return value of this method should be collection of info about each film.
  #  i.e. an array of hashes in which each hash reps a given film
  # this collection will be the argument given to `parse_character_movies`
  #  and that method will do some nice presentation stuff: puts out a list
  #  of movies by title. play around with puts out other info about a given film.
end


def parse_character_movies(films_hash)
  # some iteration magic and puts out the movies in a nice list
  movie_titles = []
  films_hash.each do |x|
    movie_titles.push(x["title"])
  end
  return movie_titles
end

parse_character_movies(get_character_movies_from_api("Luke Skywalker"))

def show_character_movies(character)
  films_hash = get_character_movies_from_api(character)
  parse_character_movies(films_hash)
end

## BONUS

# that `get_character_movies_from_api` method is probably pretty long. Does it do more than one job?
# can you split it up into helper methods?

def next_page(character, count)
  next_page = "https://www.swapi.co/api/people/?page=" + count.to_s
  find_han_solo("Han Solo", next_page, count)

end

count = 1
def find_han_solo(character, url, count)
  all_characters = RestClient.get(url)
  character_hash = JSON.parse(all_characters)
  
  character_hash["results"].each do |names|
    if names["name"] == character
      print names["name"]
      binding.pry
    end
  count += 1
  next_page(character, count)
  end
end

next_page("Han Solo", 1)
#find_han_solo("Han Solo", 'http://www.swapi.co/api/people/', count)




