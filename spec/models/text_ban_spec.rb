require 'spec_helper'

describe Text do

  before :each do
    stub_const "LOAD_BALANCERS", ["127.0.0.1"]
  end


  it "should trigger four BANs when created" do
    Api.should_receive(:call_p).once.with("http://127.0.0.1", :ban, "/v[0-9]+/texts$")
    Api.should_receive(:call_p).once.with("http://127.0.0.1", :ban, "/v[0-9]+/texts?")
    Api.should_receive(:call_p).once.with("http://127.0.0.1", :ban, "/v[0-9]+/dictionaries/app/foo_app/locale/sv-SE$")
    Api.should_receive(:call_p).once.with("http://127.0.0.1", :ban, "/v[0-9]+/dictionaries/app/foo_app/locale/sv-SE?")
  	create :text, app: "foo_app", locale: "sv-SE"
  end


  it "should trigger seven BANs when updated" do
    Api.stub(:call_p)
   	m = create :text, app: "foo_app", locale: "sv-SE"
  	m.result = "Zalagadoola"
    Api.should_receive(:call_p).once.with("http://127.0.0.1", :ban, "/v[0-9]+/texts/#{m.id}$")
    Api.should_receive(:call_p).once.with("http://127.0.0.1", :ban, "/v[0-9]+/texts/#{m.id}?")
   	Api.should_receive(:call_p).once.with("http://127.0.0.1", :ban, "/v[0-9]+/texts/#{m.id}/")
    Api.should_receive(:call_p).once.with("http://127.0.0.1", :ban, "/v[0-9]+/texts$")
    Api.should_receive(:call_p).once.with("http://127.0.0.1", :ban, "/v[0-9]+/texts?")
    Api.should_receive(:call_p).once.with("http://127.0.0.1", :ban, "/v[0-9]+/dictionaries/app/foo_app/locale/sv-SE$")
    Api.should_receive(:call_p).once.with("http://127.0.0.1", :ban, "/v[0-9]+/dictionaries/app/foo_app/locale/sv-SE?")
 	  m.save!
  end


  it "should trigger seven BANs when touched" do
    Api.stub(:call_p)
  	m = create :text, app: "foo_app", locale: "sv-SE"
    Api.should_receive(:call_p).once.with("http://127.0.0.1", :ban, "/v[0-9]+/texts/#{m.id}$")
    Api.should_receive(:call_p).once.with("http://127.0.0.1", :ban, "/v[0-9]+/texts/#{m.id}?")
    Api.should_receive(:call_p).once.with("http://127.0.0.1", :ban, "/v[0-9]+/texts/#{m.id}/")
    Api.should_receive(:call_p).once.with("http://127.0.0.1", :ban, "/v[0-9]+/texts$")
    Api.should_receive(:call_p).once.with("http://127.0.0.1", :ban, "/v[0-9]+/texts?")
    Api.should_receive(:call_p).once.with("http://127.0.0.1", :ban, "/v[0-9]+/dictionaries/app/foo_app/locale/sv-SE$")
    Api.should_receive(:call_p).once.with("http://127.0.0.1", :ban, "/v[0-9]+/dictionaries/app/foo_app/locale/sv-SE?")
 	  m.touch
  end


  it "should trigger seven BANs when destroyed" do
    Api.stub(:call_p)
  	m = create :text, app: "foo_app", locale: "sv-SE"
    Api.should_receive(:call_p).once.with("http://127.0.0.1", :ban, "/v[0-9]+/texts/#{m.id}$")
    Api.should_receive(:call_p).once.with("http://127.0.0.1", :ban, "/v[0-9]+/texts/#{m.id}?")
    Api.should_receive(:call_p).once.with("http://127.0.0.1", :ban, "/v[0-9]+/texts/#{m.id}/")
    Api.should_receive(:call_p).once.with("http://127.0.0.1", :ban, "/v[0-9]+/texts$")
    Api.should_receive(:call_p).once.with("http://127.0.0.1", :ban, "/v[0-9]+/texts?")
    Api.should_receive(:call_p).once.with("http://127.0.0.1", :ban, "/v[0-9]+/dictionaries/app/foo_app/locale/sv-SE$")
    Api.should_receive(:call_p).once.with("http://127.0.0.1", :ban, "/v[0-9]+/dictionaries/app/foo_app/locale/sv-SE?")
  	m.destroy
  end

end
