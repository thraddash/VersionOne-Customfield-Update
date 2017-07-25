#!/usr/bin/env ruby
require 'net/smtp'
require 'base64'
require 'rest-client'
require 'yaml'
require 'nokogiri'

class V1Connect
  $V1HOST = YAML::load(File.open("./config/v1config.yml"))

  def get_defect
    defect_info = (RestClient::Request.execute(
      :method => :get,
      :url => "#{$V1HOST['base_url']}#{$V1HOST['base_uri']}#{$V1HOST['defect_uri']}#{$V1HOST['defectSelection']}",
      :payload => '{" "}',
      :headers => {'Authorization' => "Bearer #{$V1HOST['token_id']}", :content_type => 'application/xml'}
    ))
    doc=Nokogiri::XML("#{defect_info}")
    i=1
    @asset_total=doc.xpath("//Assets/@total").text().to_i
    p "found #{@asset_total} matches"
    doc.xpath("//Assets/Asset['id']").each_with_index do |a,index|
      number = doc.xpath("//Assets/Asset/Attribute[@name='Number']")
      channel = doc.xpath("//Assets/Asset/Attribute[@name='Custom_Channel2.Name']")
      asset_state = doc.xpath("//Assets/Asset/Attribute[@name='AssetState']")
      string ="#{number[index].text.strip}_:_#{a['href']}_:_#{a['id']}_:_#{channel[index].text.strip}_:_#{asset_state[index].text.strip}"
      string = Shellwords.escape(string)
      #p "#{i} #{string}"
      i+=1
      system("./lib/v1update_defect.rb #{string}")
    end
  end
end
