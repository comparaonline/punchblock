# encoding: utf-8

require 'spec_helper'

module Punchblock
  class Event
    describe End do
      it 'registers itself' do
        RayoNode.class_from_registration(:end, 'urn:xmpp:rayo:1').should be == End
      end

      describe "from a stanza" do
        let :stanza do
          <<-MESSAGE
<end xmlns="urn:xmpp:rayo:1">
  <timeout />
  <!-- Signaling (e.g. SIP) Headers -->
  <header name="X-skill" value="agent" />
  <header name="X-customer-id" value="8877" />
</end>
          MESSAGE
        end

        subject { RayoNode.import parse_stanza(stanza).root, '9f00061', '1' }

        it { should be_instance_of End }

        it_should_behave_like 'event'
        it_should_behave_like 'event_headers'

        its(:reason) { should be == :timeout }
      end

      describe "when setting options in initializer" do
        subject do
          End.new :reason => :hangup,
                  :headers  => { :x_skill => "agent", :x_customer_id => "8877" }
        end

        its(:reason) { should be == :hangup }
        it_should_behave_like 'command_headers'
      end
    end
  end
end # Punchblock
