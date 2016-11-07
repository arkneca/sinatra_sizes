require 'sinatra'

class String

  def caesar_shift(shift=1)
    letters = ('a'..'z').to_a
    ciphertext = ''
    self.downcase.chars do |char|
      if letters.include?(char)
        ciphertext << letters[(letters.index(char) + shift) % 26]
      else
        ciphertext << char
      end
    end
    ciphertext.upcase
  end
end

helpers do
  def title
    @title || 'Caesar Shift Cypher'
  end
end

get '/' do
  erb :form
end

post '/' do
  @title = "Secret Message"
  @plaintext = params[:plaintext].chomp
  shift = params[:shift].to_i
  @ciphertext = @plaintext.caesar_shift(shift)
  erb :result
end
