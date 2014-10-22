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
#  created_at   :datetime
#  updated_at   :datetime
#  markdown     :boolean          default(FALSE), not null
#  html         :text
#  created_by   :integer
#  updated_by   :integer
#
# Indexes
#
#  index_texts_on_app_and_context_and_locale_and_updated_at  (app,context,locale,updated_at)
#  index_texts_on_app_and_locale_and_updated_at              (app,locale,updated_at)
#  index_texts_on_created_at                                 (created_at)
#  index_texts_on_updated_at                                 (updated_at)
#  main_index                                                (app,context,locale,name) UNIQUE
#

require 'spec_helper'

describe Text, :type => :model do
  
  describe "properties" do
    
    it "should have an app name" do
      expect(build(:text, :app => nil)).not_to be_valid
    end
    
    it "app name may only contain alphanumeric characters, underscores and hyphens" do
      expect(build(:text, :app => "blahonga_se")).to be_valid
      expect(build(:text, :app => "blahonga-se")).to be_valid
      expect(build(:text, :app => "blahonga.se")).not_to be_valid
      expect(build(:text, :app => "blahonga!se")).not_to be_valid
      expect(build(:text, :app => "blahonga se")).not_to be_valid
    end
  
    it "should have a context" do
      expect(build(:text, :context => nil)).not_to be_valid
    end
  
    it "context may only contain alphanumeric characters, underscores and hyphens" do
      expect(build(:text, :app => "payment")).to be_valid
      expect(build(:text, :app => "payment.process")).not_to be_valid
      expect(build(:text, :app => "payment process")).not_to be_valid
    end

    it "should have a locale" do
      expect(build(:text, :locale => nil)).not_to be_valid
    end
  
    it "should require the locale to be in the correct ISO format" do
      expect(build(:text, :locale => 'sv-SE')).to be_valid
      expect(build(:text, :locale => 'sv-SWE')).not_to be_valid
      expect(build(:text, :locale => 'sv')).not_to be_valid
      expect(build(:text, :locale => 'SE')).not_to be_valid
      expect(build(:text, :locale => 'SV-se')).not_to be_valid
    end
    
    it "should have a name as key" do
      expect(build(:text, :name => nil)).not_to be_valid
    end
  
    it "should have a name consisting only of acceptable characters" do
      expect(build(:text, :name => "Ming_Vase-32")).to be_valid
      expect(build(:text, :name => "Ming Vase 32")).not_to be_valid
      expect(build(:text, :name => "Effing_Åmål")).not_to be_valid
      expect(build(:text, :name => "foo.bar.baz")).to be_valid
    end
  
    it "should have a result MIME type" do
      expect(build(:text, :mime_type => nil)).not_to be_valid
    end
  
    it "should have a result MIME type containing a slash" do
      expect(build(:text, :mime_type => "text/html")).to be_valid
      expect(build(:text, :mime_type => "application")).not_to be_valid
    end
    
    it "should have an optional usage text field" do
      expect(build(:text, :usage => "radio_button")).to be_valid
      expect(build(:text, :usage => nil)).to be_valid
    end

    it "should have a markdown boolean" do
      expect(build(:text, :markdown => true)).to be_valid
    end

    it "should have an html field" do
      expect(build(:text, :html => '<p>Hej!</p>')).to be_valid
    end
    
  end
  
  it "entries should be unique on app, context, locale, and name" do
    create(:text, app: "foo", context: "bar", locale: 'sv-SE', name: "ze_Key")
    expect { create(:text, app: "foo", context: "bar", locale: 'sv-SE', name: "ze_Key") }.
      to raise_error
    expect { create(:text, app: "xuu", context: "bar", locale: 'sv-SE', name: "ze_Key") }.
      not_to raise_error
    expect { create(:text, app: "foo", context: "xuu", locale: 'sv-SE', name: "ze_Key") }.
      not_to raise_error
    expect { create(:text, app: "foo", context: "bar", locale: 'en-GB', name: "ze_Key") }.
      not_to raise_error
    expect { create(:text, app: "foo", context: "bar", locale: 'sv-SE', name: "anozer_Ki") }.
      not_to raise_error
  end
  
  it "should have a lock_version" do
    expect(build(:text, :lock_version => 12)).to be_valid
    expect(build(:text, :lock_version => nil)).not_to be_valid
  end


  describe "markdown" do

    it "should convert #result to populate the #html attribute when #markdown is true" do
      t = create :text, result: "foo *bar* _baz_", markdown: true
      expect(t.html).to eq "<p>foo <em>bar</em> <em>baz</em></p>\n"
    end

    it "should set #html to nil when #markdown is false" do
      t = create :text, result: "foo *bar* _baz_", markdown: false
      expect(t.html).to eq nil
    end

    it "should not allow the #html attribute to be set by the client" do
      t = create :text, result: "blah", html: "<p>Ce n'est pas possible</p>", markdown: false
      expect(t.html).to eq nil
      t = create :text, result: "blah", html: "<p>Ce n'est pas possible</p>", markdown: true
      expect(t.html).to eq "<p>blah</p>\n"
    end

  end
  
  
  describe "static method a_to_nested_hash" do
    
    it "should convert an array to a hash" do
      expect(Text.a_to_nested_hash([])).to eq({})
    end
    
    it "should key on name in the outermost hash and have another hash as its value" do
      arr = [create(:text, name: "name1", locale: 'sv-SE')]
      res = Text.a_to_nested_hash(arr)
      expect(res.size).to eq 1
      expect(res['name1']).to be_a Hash
    end
    
    it "should collect all locales as keys for the inner hash" do
      arr = [create(:text, name: "name1", locale: 'sv-SE'),
             create(:text, name: "name1", locale: 'en-US'),
             create(:text, name: "name1", locale: 'no-NO')]
      res = Text.a_to_nested_hash(arr)
      expect(res.size).to eq 1
      inner = res['name1']
      expect(inner.size).to eq 3
      expect(inner['sv-SE']).to be_a Text
      expect(inner['en-US']).to be_a Text
      expect(inner['no-NO']).to be_a Text
    end
    
    it "should keep locales of different names apart as expected" do
      arr = [create(:text, name: "name1", locale: 'sv-SE', result: "hey"),
             create(:text, name: "name1", locale: 'en-US'),
             create(:text, name: "name1", locale: 'no-NO'),
             create(:text, name: "name2", locale: 'sv-SE', result: "yo"),
             create(:text, name: "name2", locale: 'en-US'),
             create(:text, name: "name2", locale: 'no-NO')]
      res = Text.a_to_nested_hash(arr)
      expect(res.size).to eq 2
      expect(res['name1']['sv-SE'].result).to eq "hey"
      expect(res['name2']['sv-SE'].result).to eq "yo"
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
      ix = Text.collection
      expect(ix.length).to eq 7
      expect(ix[0]).to be_a Text
    end
    
    it "should allow matches on app" do
      expect(Text.collection(app: 'NOWAI').length).to eq 0
      expect(Text.collection(app: 'foo').length).to eq 4
      expect(Text.collection(app: 'bar').length).to eq 3
    end
    
    it "should allow matches on context" do
      expect(Text.collection(context: 'NOWAI').length).to eq 0
      expect(Text.collection(context: 'alfa').length).to eq 3
      expect(Text.collection(context: 'beta').length).to eq 1
      expect(Text.collection(context: 'zoo').length).to eq 2
      expect(Text.collection(context: 'xux').length).to eq 1
    end
    
    it "should allow matches on name" do
      expect(Text.collection(name: 'NOWAI').length).to eq 0
      expect(Text.collection(name: 'ett').length).to eq 3
      expect(Text.collection(name: 'gokk').length).to eq 4
    end
    
    it "should allow matches on locale" do
      expect(Text.collection(locale: 'NOWAI').length).to eq 0
      expect(Text.collection(locale: 'sv-SE').length).to eq 3
      expect(Text.collection(locale: 'no-NO').length).to eq 1
      expect(Text.collection(locale: 'da-DK').length).to eq 1
      expect(Text.collection(locale: 'en-GB').length).to eq 2
    end
    
    it "should allow searches on app and context" do
      expect(Text.collection(app: 'bar', context: 'zoo').length).to eq 2
      expect(Text.collection(app: 'bar', context: 'xux').length).to eq 1
      expect(Text.collection(app: 'bar', context: 'NOWAI').length).to eq 0
      expect(Text.collection(app: 'NOWAY', context: 'zoo').length).to eq 0
    end
    
    it "key/value pairs not in the index_only array should quietly be ignored" do
      expect(Text.collection(app: 'foo', aardvark: 12).length).to eq 4
    end
    
    
    describe "should permit menu grouping" do
      
      it "to list the existing apps" do
        media = Text.collection(group: :app)
        expect(media.length).to eq 2
      end
      
      it "to give all the contexts in an app" do
        media = Text.collection(app: 'bar', group: :context)
        expect(media.length).to eq 2
      end
      
      it "to give all the names in an app and context" do
        media = Text.collection(app: 'bar', context: 'zoo', group: :name)
        expect(media.length).to eq 1
      end
      
      it "to list all the locales" do
        media = Text.collection(group: :locale)
        expect(media.length).to eq 4
      end
      
    end


    describe "should take a 'search' query arg" do

      it "which with no other args should search for the substring in all Texts" do
        media = Text.collection(search: 'oo')
        expect(media.length).to eq 3
      end

      it "which should further limit other matches" do
        media = Text.collection(context: 'alfa', search: 'oo')
        expect(media.length).to eq 2
      end

    end
    
  end
  
  
end
