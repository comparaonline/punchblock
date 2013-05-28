# encoding: utf-8

module Punchblock
  module HasHeaders
    def inherit(xml_node)
      header_nodes = xml_node.xpath('//ns:header', ns: self.class.registered_ns).to_a
      self.headers = header_nodes
      super
    end

    def headers
      @headers || []
    end

    ##
    # @return [Hash] hash of key-value pairs of headers
    #
    def headers_hash
      headers.inject({}) do |hash, header|
        hash[header.name] = header.value
        hash
      end
    end

    def headers=(other)
      case other
      when Hash
        @headers = []
        other.each_pair { |k,v| @headers << Header.new(k,v) }
      when Array
        @headers = other.map { |h| Header.new(h) }
      end
    end

    def inspect_attributes # :nodoc:
      [:headers_hash] + super
    end
  end
end
