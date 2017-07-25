#!/usr/bin/env ruby
require './lib/v1defect'
require 'yaml'
require 'nokogiri'
require 'shellwords'

$V1HOST = YAML::load(File.open("./config/v1config.yml"))
string = ARGV[0]
number, href, workitem_oid, channel, asset_state = string.split(/_:_/)
p "Verifying #{number} channel & asset_state"
check_attr = (RestClient::Request.execute(
  :method => :get,
  :url => URI.encode("#{$V1HOST['base_url']}#{$V1HOST['base_uri']}#{$V1HOST['defect_uri']}#{$V1HOST['defectMulti']};Number='#{number}'"),
  :payload => '{" "}',
  :headers => {'Authorization' => "Bearer #{$V1HOST['token_id']}", :content_type => 'application/xml'}
))
doc=Nokogiri::XML("#{check_attr}")
doc.xpath("//Assets/Asset['id']").each_with_index do |a,index|
  number = doc.xpath("//Assets/Asset/Attribute[@name='Number']").text()
  channel = doc.xpath("//Assets/Asset/Attribute[@name='Custom_Channel2.Name']").text()
  asset_state = doc.xpath("//Assets/Asset/Attribute[@name='AssetState']").text()
  a['href']
  href = a['href'].gsub(/\:/,"/")
  if (channel.empty?  && "#{asset_state}" == "64")
    p "Updating #{number} Default Channel:"
    #NOTES
    #/rest-1.v1/Data/Custom_Channel?sel=Custom_Channel.ID

    update_default_channel = "<Asset><Attribute name='Custom_Channel2' act='set'>Custom_Channel:3523988</Attribute></Asset>"

    #changeComment="#{$V1HOST['comment']}#{update_default_channel}"
    changeComment="#{$V1HOST['comment']}"
    
    #p "#{$V1HOST['base_url']}#{a['href']}#{changeComment}"
    rt=post_timebox_update = (RestClient::Request.execute(
      :method => :post,
      :url => URI.encode("#{$V1HOST['base_url']}#{href}#{changeComment}"),
      :payload => "#{update_default_channel}",
      :headers => {'Authorization' => "Bearer #{$V1HOST['token_id']}",
      :content_type => 'application/xml'}
    ))
    p rt.body
  else 
    p "SKIP #{number}, there is a Channel:[#{channel}] AssetState:[#{asset_state}]"
  end
end

