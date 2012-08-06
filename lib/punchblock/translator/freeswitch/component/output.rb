# encoding: utf-8

module Punchblock
  module Translator
    class Freeswitch
      module Component
        class Output < AbstractOutput
          private

          def validate
            super
            raise OptionError, "A voice value is unsupported." if @component_node.voice
            filenames
          end

          def do_output
            playback "file_string://#{filenames.join('!')}"
          end

          def filenames
            @filenames ||= @component_node.ssml.children.map do |node|
              case node
              when RubySpeech::SSML::Audio
                node.src
              when String
                raise if node.include?(' ')
                node
              else
                raise
              end
            end.compact
          rescue
            raise UnrenderableDocError, 'The provided document could not be rendered.'
          end

          def playback(path)
            op = current_actor
            register_handler :es, :event_name => 'CHANNEL_EXECUTE_COMPLETE' do |event|
              op.send_complete_event! complete_reason_for_event(event)
            end
            application 'playback', path
          end

          def complete_reason_for_event(event)
            case event[:application_response]
            when 'FILE PLAYED'
              success_reason
            else
              Punchblock::Event::Complete::Error.new(:details => "Engine error: #{event[:application_response]}")
            end
          end
        end
      end
    end
  end
end