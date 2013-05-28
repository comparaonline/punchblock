# encoding: utf-8

module Punchblock
  module Component
    class Input < ComponentNode
      register :input, :input

      ##
      # Create a input command
      #
      # @param [Hash] options
      # @option options [Grammar, Hash] :grammar the grammar to activate
      # @option options [Integer, optional] :max_silence the amount of time in milliseconds that an input command will wait until considered that a silence becomes a NO-MATCH
      # @option options [Float, optional] :min_confidence with which to consider a response acceptable
      # @option options [Symbol, optional] :mode by which to accept input. Can be :speech, :dtmf or :any
      # @option options [String, optional] :recognizer to use for speech recognition
      # @option options [String, optional] :terminator by which to signal the end of input
      # @option options [Float, optional] :sensitivity Indicates how sensitive the interpreter should be to loud versus quiet input. Higher values represent greater sensitivity.
      # @option options [Integer, optional] :initial_timeout Indicates the amount of time preceding input which may expire before a timeout is triggered.
      # @option options [Integer, optional] :inter_digit_timeout Indicates (in the case of DTMF input) the amount of time between input digits which may expire before a timeout is triggered.
      #
      # @return [Command::Input] a formatted Rayo input command
      #
      # @example
      #    input :grammar     => {:value => '[5 DIGITS]', :content_type => 'application/grammar+voxeo'},
      #          :mode        => :speech,
      #          :recognizer  => 'es-es'
      #
      #    returns:
      #      <input xmlns="urn:xmpp:rayo:input:1" mode="speech" recognizer="es-es">
      #        <grammar content-type="application/grammar+voxeo">[5 DIGITS]</choices>
      #      </input>
      #

      ##
      # @return [Integer] the amount of time in milliseconds that an input command will wait until considered that a silence becomes a NO-MATCH
      #
      def max_silence
        read_attr :'max-silence', :to_i
      end

      ##
      # @param [Integer] other the amount of time in milliseconds that an input command will wait until considered that a silence becomes a NO-MATCH
      #
      def max_silence=(other)
        write_attr :'max-silence', other, :to_i
      end

      ##
      # @return [Float] Confidence with which to consider a response acceptable
      #
      def min_confidence
        read_attr 'min-confidence', :to_f
      end

      ##
      # @param [Float] min_confidence with which to consider a response acceptable
      #
      def min_confidence=(min_confidence)
        write_attr 'min-confidence', min_confidence, :to_f
      end

      ##
      # @return [Symbol] mode by which to accept input. Can be :speech, :dtmf or :any
      #
      def mode
        read_attr :mode, :to_sym
      end

      ##
      # @param [Symbol] mode by which to accept input. Can be :speech, :dtmf or :any
      #
      def mode=(mode)
        write_attr :mode, mode
      end

      ##
      # @return [String] recognizer to use for speech recognition
      #
      def recognizer
        read_attr :recognizer
      end

      ##
      # @param [String] recognizer to use for speech recognition
      #
      def recognizer=(recognizer)
        write_attr :recognizer, recognizer
      end

      ##
      # @return [String] terminator by which to signal the end of input
      #
      def terminator
        read_attr :terminator
      end

      ##
      # @param [String] terminator by which to signal the end of input
      #
      def terminator=(terminator)
        write_attr :terminator, terminator
      end

      ##
      # @return [Float] Indicates how sensitive the interpreter should be to loud versus quiet input. Higher values represent greater sensitivity.
      #
      def sensitivity
        read_attr :sensitivity, :to_f
      end

      ##
      # @param [Float] other Indicates how sensitive the interpreter should be to loud versus quiet input. Higher values represent greater sensitivity.
      #
      def sensitivity=(other)
        write_attr :sensitivity, other, :to_f
      end

      ##
      # @return [Integer] Indicates the amount of time preceding input which may expire before a timeout is triggered.
      #
      def initial_timeout
        read_attr :'initial-timeout', :to_i
      end

      ##
      # @param [Integer] timeout Indicates the amount of time preceding input which may expire before a timeout is triggered.
      #
      def initial_timeout=(other)
        write_attr :'initial-timeout', other, :to_i
      end

      ##
      # @return [Integer] Indicates (in the case of DTMF input) the amount of time between input digits which may expire before a timeout is triggered.
      #
      def inter_digit_timeout
        read_attr :'inter-digit-timeout', :to_i
      end

      ##
      # @param [Integer] timeout Indicates (in the case of DTMF input) the amount of time between input digits which may expire before a timeout is triggered.
      #
      def inter_digit_timeout=(other)
        write_attr :'inter-digit-timeout', other, :to_i
      end

      attr_reader :grammar

      def grammar=(other)
        @grammar = Grammar.new(other)
      end

      def inspect_attributes # :nodoc:
        [:mode, :terminator, :recognizer, :initial_timeout, :inter_digit_timeout, :sensitivity, :min_confidence, :grammar] + super
      end

      class Grammar < RayoNode
        attr_accessor :value, :content_type, :url

        ##
        # @param [Hash] options
        # @option options [String] :content_type the document content type
        # @option options [String] :value the grammar document
        # @option options [String] :url the url from which to fetch the grammar
        #
        def self.new(options = {})
          super().tap do |new_node|
            case options
            when Nokogiri::XML::Node
              new_node.inherit options
            when Hash
              new_node.content_type = options[:content_type]
              new_node.value = options[:value]
              new_node.url = options[:url]
            end
          end
        end

        # ##
        # # @return [String, RubySpeech::GRXML::Grammar] the grammar document
        # def value
        #   return nil unless content.present?
        #   if grxml?
        #     RubySpeech::GRXML.import content
        #   else
        #     content
        #   end
        # end

        # ##
        # # @param [String, RubySpeech::GRXML::Grammar] value the grammar document
        # def value=(value)
        #   return unless value
        #   self.content_type = grxml_content_type unless self.content_type
        #   if grxml? && !value.is_a?(RubySpeech::GRXML::Element)
        #     value = RubySpeech::GRXML.import value
        #   end
        #   Nokogiri::XML::Builder.with(self) do |xml|
        #     xml.cdata " #{value} "
        #   end
        # end

        def inspect_attributes # :nodoc:
          [:content_type, :value, :url] + super
        end

        private

        def grxml_content_type
          'application/srgs+xml'
        end

        def grxml?
          content_type == grxml_content_type
        end
      end # Choices

      class Complete
        class Success < Event::Complete::Reason
          register :success, :input_complete

          attr_accessor :mode, :confidence, :interpretation, :utterance

          def inspect_attributes # :nodoc:
            [:mode, :confidence, :interpretation, :utterance] + super
          end
        end

        class NoMatch < Event::Complete::Reason
          register :nomatch, :input_complete
        end

        class NoInput < Event::Complete::Reason
          register :noinput, :input_complete
        end
      end # Complete
    end # Input
  end # Component
end # Punchblock
