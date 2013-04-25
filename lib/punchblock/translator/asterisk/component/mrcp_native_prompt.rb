# encoding: utf-8

require 'active_support/core_ext/string/filters'

module Punchblock
  module Translator
    class Asterisk
      module Component
        class MRCPNativePrompt < Component
          include StopByRedirect

          UniMRCPError = Class.new Punchblock::Error

          def execute
            setup_defaults
            validate
            send_ref
            execute_mrcprecog
            complete
          rescue UniMRCPError
            complete_with_error 'Terminated due to UniMRCP error'
          rescue RubyAMI::Error => e
            complete_with_error "Terminated due to AMI error '#{e.message}'"
          rescue OptionError => e
            with_error 'option error', e.message
          end

          private

          def setup_defaults
            @initial_timeout = input_node.initial_timeout || -1
            @inter_digit_timeout = input_node.inter_digit_timeout || -1
          end

          def validate
            raise OptionError, "The renderer #{renderer} is unsupported." unless renderer == 'asterisk'
            raise OptionError, "The recognizer #{recognizer} is unsupported." unless recognizer == 'unimrcp'

            raise OptionError, 'A document is required.' unless output_node.render_documents.count > 0
            raise OptionError, 'Only one document is allowed.' if output_node.render_documents.count > 1
            raise OptionError, 'Only inline documents are allowed.' if first_doc.url
            raise OptionError, 'Only one audio file is allowed.' if first_doc.value.size > 1

            raise OptionError, 'A grammar is required.' unless input_node.grammars.count > 0

            [:interrupt_on, :start_offset, :start_paused, :repeat_interval, :repeat_times, :max_time].each do |opt|
              raise OptionError, "A #{opt} value is unsupported on Asterisk." if output_node.send opt
            end

            raise OptionError, "An initial-timeout value must be -1 or a positive integer." if @initial_timeout < -1
            raise OptionError, "An inter-digit-timeout value must be -1 or a positive integer." if @inter_digit_timeout < -1
          end

          def renderer
            (output_node.renderer || :asterisk).to_s
          end

          def recognizer
            (input_node.recognizer || :unimrcp).to_s
          end

          def execute_mrcprecog
            @call.execute_agi_command 'EXEC MRCPRecog', [grammars, mrcprecog_options].map { |o| "\"#{o.to_s.squish.gsub('"', '\"')}\"" }.join(',')
            raise UniMRCPError if @call.channel_var('RECOG_STATUS') == 'ERROR'
          end

          def grammars
            input_node.grammars.map do |d|
              if d.content_type
                d.value.to_doc.to_s
              else
                d.url
              end
            end.join ','
          end

          def first_doc
            output_node.render_documents.first
          end

          def audio_filename
            first_doc.value.first
          end

          def mrcprecog_options
            {uer: 1, b: (@component_node.barge_in == false ? 0 : 1)}.tap do |opts|
              opts[:nit] = @initial_timeout if @initial_timeout > -1
              opts[:dit] = @inter_digit_timeout if @inter_digit_timeout > -1
              opts[:f] = audio_filename
            end.map { |o| o.join '=' }.join '&'
          end

          def output_node
            @component_node.output
          end

          def input_node
            @component_node.input
          end

          def complete
            send_complete_event case @call.channel_var('RECOG_COMPLETION_CAUSE')
            when '000'
              nlsml = RubySpeech.parse URI.decode(@call.channel_var('RECOG_RESULT'))
              Punchblock::Component::Input::Complete::Match.new nlsml: nlsml
            when '001'
              Punchblock::Component::Input::Complete::NoMatch.new
            when '002'
              Punchblock::Component::Input::Complete::InitialTimeout.new
            end
          end
        end
      end
    end
  end
end