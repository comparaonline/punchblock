# encoding: utf-8

module Punchblock
  class Event
    class Complete < Event
      register :complete, :ext

      attr_accessor :reason

      def inherit(xml_node)
        if reason_node = xml_node.at_xpath('*')
          self.reason = RayoNode.import(reason_node).tap do |reason|
            reason.target_call_id = target_call_id
            reason.component_id = component_id
          end
        end
        super
      end

      def recording
        # element = find_first('//ns:recording', :ns => RAYO_NAMESPACES[:record_complete])
        # return unless element
        # RayoNode.import(element).tap do |recording|
        #   recording.target_call_id = target_call_id
        #   recording.component_id = component_id
        # end
      end

      def inspect_attributes # :nodoc:
        [:reason, :recording] + super
      end

      class Reason < RayoNode
        attr_accessor :name

        def inherit(xml_node)
          self.name = xml_node.name.to_sym
          super
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

        attr_accessor :details

        def inherit(xml_node)
          self.details = xml_node.text.strip
          super
        end

        def inspect_attributes # :nodoc:
          [:details] + super
        end
      end
    end # Complete
  end
end # Punchblock
