require 'savon'
require 'nori'

Nori.parser = :nokogiri

module Clearsale
  class Connector
    NAMESPACE =  "http://www.clearsale.com.br/integration"

    URLs = {
      :homolog    => 'http://homologacao.clearsale.com.br/Integracaov2/Service.asmx',
      :production => 'https://www.clearsale.com.br/integracaov2/service.asmx'
    }

    def self.build(env = ENV['CLEARSALE_ENV'])
      if env == "production"
        new(URLs[:production])
      else
        new(URLs[:homolog])
      end
    end

    def initialize(endpoint_url)
      @token = ENV['CLEARSALE_ENTITYCODE']
      @client = Savon::Client.new do |wsdl|
        wsdl.endpoint = endpoint_url
        wsdl.namespace = NAMESPACE
      end
    end

    def do_request(method, request)
      namespaced_request = append_namespace('int', request)
      arguments = namespaced_request.merge({'int:entityCode' => @token})

      response = @client.request(:int, method) do |soap, _, http, _|
        soap.namespaces = {
          'xmlns:soap' => "http://www.w3.org/2003/05/soap-envelope",
          'xmlns:xsd'  => "http://www.w3.org/2001/XMLSchema" ,
          'xmlns:xsi'  => "http://www.w3.org/2001/XMLSchema-instance" ,
          'xmlns:int'  => "http://www.clearsale.com.br/integration",
        }

        soap.env_namespace = :soap

        soap.body = arguments
        http.headers['SOAPAction'] = "#{NAMESPACE}/#{method}"
      end

      extract_response_xml(method, response.to_hash)
    end

    def extract_response_xml(method, response)
      results = response.fetch(:"#{method.snakecase}_response", {})
      response_xml = results.fetch(:"#{method.snakecase}_result", {}).to_s

      Nori.parse(response_xml.gsub(/^<\?xml.*\?>/, ''))
    end

    def append_namespace(namespace, hash)
      Hash[hash.map {|key, value| ["#{namespace}:#{key}", value]}]
    end
  end
end
