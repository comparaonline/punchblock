# encoding: utf-8

module Punchblock
  class Event
    class Complete < Event
      register :complete, :ext

      def reason
        element = find_first '*'
        return unless element
        RayoNode.import(element).tap do |reason|
          reason.target_call_id = target_call_id
          reason.component_id = component_id
        end
      end

      def reason=(other)
        children.map(&:remove)
        self << other
      end

      def recording
        element = find_first('//ns:recording', :ns => RAYO_NAMESPACES[:record_complete])
        return unless element
        RayoNode.import(element).tap do |recording|
          recording.target_call_id = target_call_id
          recording.component_id = component_id
        end
      end

      def inspect_attributes # :nodoc:
        [:reason, :recording] + super
      end

      class Reason < RayoNode
        def self.new(options = {})
          super().tap do |new_node|
            case options
            when Nokogiri::XML::Node
              new_node.inherit options
            when Hash
              options.each_pair { |k,v| new_node.send :"#{k}=", v }
            end
          end
        end

        def name
          super.to_sym
        end

        def inspect_attributes # :nodoc:
          [:name] + super
        end
      end

      class Stop < Reason
        register :stop, :ext_complete
      end

      class Hangup < Reason
        register :hangup, :ext_complete
      end

      class Error < Reason
        register :error, :ext_complete

        def details
          text.strip
        end

        def details=(other)
          self << other
        end

        def inspect_attributes # :nodoc:
          [:details] + super
        end
      end
    end # Complete
  end
end # Punchblock
