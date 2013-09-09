# encoding: utf-8

require 'spec_helper'

module Punchblock
  class Event
    describe Offer do
      it 'registers itself' do
        RayoNode.class_from_registration(:offer, 'urn:xmpp:rayo:1').should be == Offer
      end

      describe "from a stanza" do
        let :stanza do
          <<-MESSAGE
<offer xmlns='urn:xmpp:rayo:1'
    to='tel:+18003211212'
    from='tel:+13058881212'>
  <!-- Signaling (e.g. SIP) Headers -->
  <header name="X-skill" value="agent" />
  <header name="X-customer-id" value="8877" />
</offer>
          MESSAGE
        end

        subject { RayoNode.import parse_stanza(stanza).root, '9f00061', '1' }

        it { should be_instance_of Offer }

        it_should_behave_like 'event'
        it_should_behave_like 'event_headers'

        its(:to)    { should be == 'tel:+18003211212' }
        its(:from)  { should be == 'tel:+13058881212' }
      end

      describe "when setting options in initializer" do
        subject do
          Offer.new :to       => 'tel:+18003211212',
                    :from     => 'tel:+13058881212',
                    :headers  => { :x_skill => "agent", :x_customer_id => "8877" }
        end

        it_should_behave_like 'command_headers'

        its(:to)    { should be == 'tel:+18003211212' }
        its(:from)  { should be == 'tel:+13058881212' }
      end
    end
  end
end # Punchblock
