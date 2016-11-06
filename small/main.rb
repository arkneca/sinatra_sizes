require 'sinatra'

class String

  def caesar_shift(shift=1)
    letters = ("a".."z").to_a
    ciphertext = []
    self.downcase.scan( /./ ) do |char|
      if letters.include?(char)
        ciphertext << letters[(letters.index(char)+shift)%26]
      else
        ciphertext << char
      end
    end
    ciphertext.join.upcase
  end

end

##### Sinatra ######

helpers do
  def title
    @title || "Casaer Shift Cipher"
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

##### TESTS ######

if ARGV.include? 'test'

  set :environment, :test
  set :run, false

  require 'test/unit'
  require 'rack/test'


  class CaesarCipherTest < Test::Unit::TestCase
    include Rack::Test::Methods

    def app
      Sinatra::Application
    end

    def test_it_can_encrypt_strings
      assert_equal 'JGNNQ','hello'.caesar_shift(2)
    end

    def test_it_can_encrypt_with_negative_shifts
      assert_equal 'GDKKN','hello'.caesar_shift(-1)
    end

    def test_it_can_encrypt_from_a_URL
      post '/', params={plaintext: 'hello', shift: '2'}
      assert last_response.ok?
      assert last_response.body.include?('hello'.caesar_shift(2))
    end

  end

end

