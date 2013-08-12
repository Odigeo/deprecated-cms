# encoding: UTF-8
# == Schema Information
#
# Table name: texts
#
#  id           :integer          not null, primary key
#  app          :string(100)
#  locale       :string(10)
#  context      :string(100)
#  name         :string(100)
#  mime_type    :string(100)
#  usage        :string(100)      default("")
#  result       :text
#  lock_version :integer          default(0), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  markdown     :boolean          default(FALSE), not null
#  html         :text
#  created_by   :integer
#  updated_by   :integer
#


require 'spec_helper'

describe Text do
  
  describe "properties" do
    
    it "should have an app name" do
      build(:text, :app => nil).should_not be_valid
    end
    
    it "app name may only contain alphanumeric characters, underscores and hyphens" do
      build(:text, :app => "blahonga_se").should be_valid
      build(:text, :app => "blahonga.se").should_not be_valid
      build(:text, :app => "blahonga se").should_not be_valid
    end
  
    it "should have a context" do
      build(:text, :context => nil).should_not be_valid
    end
  
    it "context may only contain alphanumeric characters, underscores and hyphens" do
      build(:text, :app => "payment").should be_valid
      build(:text, :app => "payment.process").should_not be_valid
      build(:text, :app => "payment process").should_not be_valid
    end

    it "should have a locale" do
      build(:text, :locale => nil).should_not be_valid
    end
  
    it "should require the locale to be in the correct ISO format" do
      build(:text, :locale => 'sv-SE').should be_valid
      build(:text, :locale => 'sv-SWE').should_not be_valid
      build(:text, :locale => 'sv').should_not be_valid
      build(:text, :locale => 'SE').should_not be_valid
      build(:text, :locale => 'SV-se').should_not be_valid
    end
    
    it "should have a name as key" do
      build(:text, :name => nil).should_not be_valid
    end
  
    it "should have a name consisting only of acceptable characters" do
      build(:text, :name => "Ming_Vase-32").should be_valid
      build(:text, :name => "Ming Vase 32").should_not be_valid
      build(:text, :name => "Effing_Åmål").should_not be_valid
    end
  
    it "should have a result MIME type" do
      build(:text, :mime_type => nil).should_not be_valid
    end
  
    it "should have a result MIME type containing a slash" do
      build(:text, :mime_type => "text/html").should be_valid
      build(:text, :mime_type => "application").should_not be_valid
    end
    
    it "should have an optional usage text field" do
      build(:text, :usage => "radio_button").should be_valid
      build(:text, :usage => nil).should be_valid
    end

    it "should have a markdown boolean" do
      build(:text, :markdown => true).should be_valid
    end

    it "should have an html field" do
      build(:text, :html => '<p>Hej!</p>').should be_valid
    end
    
  end
  
  it "entries should be unique on app, context, locale, and name" do
    create(:text, app: "foo", context: "bar", locale: 'sv-SE', name: "ze_Key")
    lambda { create(:text, app: "foo", context: "bar", locale: 'sv-SE', name: "ze_Key") }.
      should raise_error
    lambda { create(:text, app: "xuu", context: "bar", locale: 'sv-SE', name: "ze_Key") }.
      should_not raise_error
    lambda { create(:text, app: "foo", context: "xuu", locale: 'sv-SE', name: "ze_Key") }.
      should_not raise_error
    lambda { create(:text, app: "foo", context: "bar", locale: 'en-GB', name: "ze_Key") }.
      should_not raise_error
    lambda { create(:text, app: "foo", context: "bar", locale: 'sv-SE', name: "anozer_Ki") }.
      should_not raise_error
  end
  
  it "should have a lock_version" do
    build(:text, :lock_version => 12).should be_valid
    build(:text, :lock_version => nil).should_not be_valid
  end


  describe "markdown" do

    it "should convert #result to populate the #html attribute when #markdown is true" do
      t = create :text, result: "foo *bar* _baz_", markdown: true
      t.html.should == "<p>foo <em>bar</em> <em>baz</em></p>\n"
    end

    it "should set #html to nil when #markdown is false" do
      t = create :text, result: "foo *bar* _baz_", markdown: false
      t.html.should == nil
    end

    it "should not allow the #html attribute to be set by the client" do
      t = create :text, result: "blah", html: "<p>Ce n'est pas possible</p>", markdown: false
      t.html.should == nil
      t = create :text, result: "blah", html: "<p>Ce n'est pas possible</p>", markdown: true
      t.html.should == "<p>blah</p>\n"
    end

  end
  
  
  describe "static method a_to_nested_hash" do
    
    it "should convert an array to a hash" do
      Text.a_to_nested_hash([]).should == {}
    end
    
    it "should key on name in the outermost hash and have another hash as its value" do
      arr = [create(:text, name: "name1", locale: 'sv-SE')]
      res = Text.a_to_nested_hash(arr)
      res.size.should == 1
      res['name1'].should be_a Hash
    end
    
    it "should collect all locales as keys for the inner hash" do
      arr = [create(:text, name: "name1", locale: 'sv-SE'),
             create(:text, name: "name1", locale: 'en-US'),
             create(:text, name: "name1", locale: 'no-NO')]
      res = Text.a_to_nested_hash(arr)
      res.size.should == 1
      inner = res['name1']
      inner.size.should == 3
      inner['sv-SE'].should be_a Text
      inner['en-US'].should be_a Text
      inner['no-NO'].should be_a Text
    end
    
    it "should keep locales of different names apart as expected" do
      arr = [create(:text, name: "name1", locale: 'sv-SE', result: "hey"),
             create(:text, name: "name1", locale: 'en-US'),
             create(:text, name: "name1", locale: 'no-NO'),
             create(:text, name: "name2", locale: 'sv-SE', result: "yo"),
             create(:text, name: "name2", locale: 'en-US'),
             create(:text, name: "name2", locale: 'no-NO')]
      res = Text.a_to_nested_hash(arr)
      res.size.should == 2
      res['name1']['sv-SE'].result.should == "hey"
      res['name2']['sv-SE'].result.should == "yo"
    end
    
  end
  
  
  describe ".index_only" do
    it "should return an array of permitted search query args" do
      Text.index_only.should be_an Array
    end
  end
  
  describe ".collection" do
    
    before :each do
      create :text, app: 'foo', context: 'alfa', name: 'ett',  locale: 'sv-SE', result: 'woo hoo'
      create :text, app: 'foo', context: 'alfa', name: 'ett',  locale: 'no-NO', result: 'too true'
      create :text, app: 'foo', context: 'alfa', name: 'ett',  locale: 'da-DK', result: 'you blue'
      create :text, app: 'foo', context: 'beta', name: 'gokk', locale: 'sv-SE', result: 'moo'
      create :text, app: 'bar', context: 'zoo',  name: 'gokk', locale: 'sv-SE', result: 'quux'
      create :text, app: 'bar', context: 'zoo',  name: 'gokk', locale: 'en-GB', result: 'question'
      create :text, app: 'bar', context: 'xux',  name: 'gokk', locale: 'en-GB', result: 'mystery'
    end
    
    it "should return an array of Text instances" do
      ix = Text.index
      ix.length.should == 7
      ix[0].should be_a Text
    end
    
    it "should allow matches on app" do
      Text.collection(app: 'NOWAI').length.should == 0
      Text.collection(app: 'foo').length.should == 4
      Text.collection(app: 'bar').length.should == 3
    end
    
    it "should allow matches on context" do
      Text.collection(context: 'NOWAI').length.should == 0
      Text.collection(context: 'alfa').length.should == 3
      Text.collection(context: 'beta').length.should == 1
      Text.collection(context: 'zoo').length.should == 2
      Text.collection(context: 'xux').length.should == 1
    end
    
    it "should allow matches on name" do
      Text.collection(name: 'NOWAI').length.should == 0
      Text.collection(name: 'ett').length.should == 3
      Text.collection(name: 'gokk').length.should == 4
    end
    
    it "should allow matches on locale" do
      Text.collection(locale: 'NOWAI').length.should == 0
      Text.collection(locale: 'sv-SE').length.should == 3
      Text.collection(locale: 'no-NO').length.should == 1
      Text.collection(locale: 'da-DK').length.should == 1
      Text.collection(locale: 'en-GB').length.should == 2
    end
    
    it "should allow searches on app and context" do
      Text.collection(app: 'bar', context: 'zoo').length.should == 2
      Text.collection(app: 'bar', context: 'xux').length.should == 1
      Text.collection(app: 'bar', context: 'NOWAI').length.should == 0
      Text.collection(app: 'NOWAY', context: 'zoo').length.should == 0
    end
    
    it "key/value pairs not in the index_only array should quietly be ignored" do
      Text.collection(app: 'foo', aardvark: 12).length.should == 4
    end
    
    
    describe "should permit menu grouping" do
      
      it "to list the existing apps" do
        media = Text.collection(group: :app)
        media.length.should == 2
      end
      
      it "to give all the contexts in an app" do
        media = Text.collection(app: 'bar', group: :context)
        media.length.should == 2
      end
      
      it "to give all the names in an app and context" do
        media = Text.collection(app: 'bar', context: 'zoo', group: :name)
        media.length.should == 1
      end
      
      it "to list all the locales" do
        media = Text.collection(group: :locale)
        media.length.should == 4
      end
      
    end


    describe "should take a 'search' query arg" do

      it "which with no other args should search for the substring in all Texts" do
        media = Text.collection(search: 'oo')
        media.length.should == 3
      end

      it "which should further limit other matches" do
        media = Text.collection(context: 'alfa', search: 'oo')
        media.length.should == 2
      end

    end
    
  end
  
  
end
