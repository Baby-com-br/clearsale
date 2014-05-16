require 'savon'
require 'nori'

module Clearsale
  class Connector
    NAMESPACE =  "http://www.clearsale.com.br/integration"

    URLs = {
      "homolog"    => 'http://homologacao.clearsale.com.br/Integracaov2/Service.asmx',
      "production" => 'https://www.clearsale.com.br/integracaov2/service.asmx'
    }

    def self.build(env = ENV['CLEARSALE_ENV'])
      url = ENV["CLEARSALE_URL"] || URLs[env] || URLs["homolog"]
      proxy = ENV['CLEARSALE_PROXY']
      new url, proxy
    end

    def initialize(endpoint_url, proxy=nil)
      @token = ENV['CLEARSALE_ENTITYCODE']

      namespaces = {
          'xmlns:soap' => "http://www.w3.org/2003/05/soap-envelope",
          'xmlns:xsd'  => "http://www.w3.org/2001/XMLSchema" ,
          'xmlns:xsi'  => "http://www.w3.org/2001/XMLSchema-instance" ,
          'xmlns:int'  => "http://www.clearsale.com.br/integration",
      }

      savon_options = {:endpoint => endpoint_url, :namespace => NAMESPACE,
                       :namespaces => namespaces, :convert_request_keys_to => :snakecase }

      savon_options[:proxy]  = proxy if proxy
      savon_options[:log]    = Clearsale::Config.log
      savon_options[:logger] = Clearsale::Config.logger

      @client = Savon.client(savon_options)
    end

    def do_request(method, request)
      namespaced_request = append_namespace('int', request)
      arguments = namespaced_request.merge({'int:entityCode' => @token})

      response = @client.call(method, :message => arguments, :soap_action => "#{NAMESPACE}/#{method}")

      extract_response_xml(method, response.to_hash)
    end

    def extract_response_xml(method, response)
      results = response.fetch(:"#{method.snakecase}_response", {})
      response_xml = results.fetch(:"#{method.snakecase}_result", {}).to_s

      Nori.new(:parser => :nokogiri, :convert_tags_to => lambda { |tag| tag.snakecase.to_sym }).parse(response_xml.gsub(/^<\?xml.*\?>/, ''))
    end

    def append_namespace(namespace, hash)
      Hash[hash.map {|key, value| ["#{namespace}:#{key}", value]}]
    end
  end
end
