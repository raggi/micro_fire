# This may have been stolen from the Pink Warrior (tenderlove). Since then
# it's seen some flashing lights, the bottom of a bucket, and other intense
# torture.

require 'uri'
require 'net/http/persistent'

class MicroFire
  VERSION = '1.0.0'

  class << self
    attr_accessor :stream, :json
  end
  self.stream = URI.parse('https://streaming.campfirenow.com')

  json_libs = [
    lambda { require 'psych'; Psych },
    lambda { require 'yajl' ; Yajl  },
    lambda { require 'json' ; JSON  },
    lambda { raise 'No suitable JSON lib could be found' }
  ]

  self.json = json_libs.each do |loader|
    begin; break loader.call; rescue LoadError; nil; end
  end

  attr_reader :http, :uri, :token, :room
  attr_accessor :stream, :json, :pass

  def initialize uri, token, room
    @stream = self.class.stream
    @json   = self.class.json
    @token  = token
    @http   = Net::HTTP::Persistent.new
    # Don't do anything if not supported by net/http/persistent version or
    # socket.so. Helps when they deploy.
    if @http.respond_to? :socket_options
      @http.socket_options << [Socket::SOL_SOCKET, Socket::SO_KEEPALIVE, 1]
    end
    @pass   = 'x'
    @uri    = find_uri uri
    @room   = find_room room
  end

  def join &block
    req action('join'), &block
    self
  end

  def speak message, &block
    req action('speak'), :message => { :body => message }, &block
    self
  end

  def watch &block
    req action('live'), {}, :Get, stream, &block
    self
  end

  private
  def find_room room
    return room if room =~ /^\d+$/
    res = req('/rooms.json', {}, :Get)
    res = res["rooms"].find { |rm| rm["name"] == room }
    res ? res["id"].to_i : raise("Could not find room by #{room}")
  end

  def find_uri uri
    if uri =~ %r{https?://.*\..*}
      URI.parse uri
    else
      URI.parse "https://#{uri}.campfirenow.com"
    end
  end

  def action action
    "/room/#{room}/#{action}.json"
  end

  def req path, body = {}, type = :Post, uri = uri, &block
    req = Net::HTTP.const_get(type).new(path)
    req.basic_auth token, pass
    if type == :Post
      req.content_type = 'application/json'
      req.body = json.dump(body)
    end
    http.request(uri, req) { |response| return res response, &block }
  rescue Errno::ETIMEDOUT, Net::HTTP::Persistent::Error => e
    backoff && retry
    warn "IO Lost: #{e.class} #{e.message}"
    nil
  end

  def res http_response
    return json.load http_response.body unless block_given?
    # Yield a stream of json events if a block is given
    http_response.read_body do |chunk|
      chunk.split("\r").each do |message|
        yield json.load(message)
      end unless chunk.strip.empty?
    end
  end

  def backoff
    @backoff ||= 1
    sleep(@backoff = @backoff * 2 % 16) != 0
  end

end