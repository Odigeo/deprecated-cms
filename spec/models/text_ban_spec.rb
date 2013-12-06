require 'spec_helper'

describe Text do

  before :each do
    stub_const "LOAD_BALANCERS", ["127.0.0.1"]
  end


  it "should trigger two BANs when created" do
    Api.should_receive(:call_p).once.with("http://127.0.0.1", :ban, Api.escape("/v[0-9]+/texts#{INVALIDATE_COLLECTION_DEFAULT.first}"))
    Api.should_receive(:call_p).once.with("http://127.0.0.1", :ban, Api.escape("/v[0-9]+/dictionaries/app/foo_app/locale/sv-SE($|\\?)"))
  	create :text, app: "foo_app", locale: "sv-SE"
  end


  it "should trigger three BANs when updated" do
    Api.stub(:call_p)
   	m = create :text, app: "foo_app", locale: "sv-SE"
  	m.result = "Zalagadoola"
    Api.should_receive(:call_p).once.with("http://127.0.0.1", :ban, Api.escape("/v[0-9]+/texts/#{m.id}#{INVALIDATE_MEMBER_DEFAULT.first}"))
    Api.should_receive(:call_p).once.with("http://127.0.0.1", :ban, Api.escape("/v[0-9]+/texts#{INVALIDATE_COLLECTION_DEFAULT.first}"))
    Api.should_receive(:call_p).once.with("http://127.0.0.1", :ban, Api.escape("/v[0-9]+/dictionaries/app/foo_app/locale/sv-SE($|\\?)"))
 	  m.save!
  end


  it "should trigger three BANs when touched" do
    Api.stub(:call_p)
  	m = create :text, app: "foo_app", locale: "sv-SE"
    Api.should_receive(:call_p).once.with("http://127.0.0.1", :ban, Api.escape("/v[0-9]+/texts/#{m.id}#{INVALIDATE_MEMBER_DEFAULT.first}"))
    Api.should_receive(:call_p).once.with("http://127.0.0.1", :ban, Api.escape("/v[0-9]+/texts#{INVALIDATE_COLLECTION_DEFAULT.first}"))
    Api.should_receive(:call_p).once.with("http://127.0.0.1", :ban, Api.escape("/v[0-9]+/dictionaries/app/foo_app/locale/sv-SE($|\\?)"))
 	  m.touch
  end


  it "should trigger three BANs when destroyed" do
    Api.stub(:call_p)
  	m = create :text, app: "foo_app", locale: "sv-SE"
    Api.should_receive(:call_p).once.with("http://127.0.0.1", :ban, Api.escape("/v[0-9]+/texts/#{m.id}#{INVALIDATE_MEMBER_DEFAULT.first}"))
    Api.should_receive(:call_p).once.with("http://127.0.0.1", :ban, Api.escape("/v[0-9]+/texts#{INVALIDATE_COLLECTION_DEFAULT.first}"))
    Api.should_receive(:call_p).once.with("http://127.0.0.1", :ban, Api.escape("/v[0-9]+/dictionaries/app/foo_app/locale/sv-SE($|\\?)"))
  	m.destroy
  end

end
