$LOAD_PATH.unshift(File.dirname(__FILE__))
%w{
punchblock/call
punchblock/dsl
punchblock/protocol/ozone.rb
punchblock/transport/xmpp.rb
core_ext/nokogiri_hash
}.each { |f| require f }
