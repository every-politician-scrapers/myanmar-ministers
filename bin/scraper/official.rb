#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class MemberList
  class Member
    field :name do
      noko.css('h2').text.tidy
    end

    field :position do
      return ministry.sub('Ministry', 'Minister') if role == 'Union Minister'
      return ministry.sub('Ministry', 'Deputy Minister') if role == 'Deputy Minister'

      role
    end

    private

    def role
      noko.css('p').text.tidy
    end

    def ministry
      noko.xpath('ancestor::div[@class="mb-10"][1]//h2').first.text rescue nil
    end
  end

  class Members
    def member_items
      super.reject { |mem| mem.name =~ /(Ministry|Government)/ }
    end

    def member_container
      noko.css('.p-2')
    end
  end
end

file = Pathname.new 'html/official.html'
puts EveryPoliticianScraper::FileData.new(file).csv
