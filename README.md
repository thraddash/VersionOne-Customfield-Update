# VersionOne-Customfield-Update
**Summary:** Making a customfield a require field @Defect  
Select all **active** Defects where the customfield value are blank  
Update all active Defects with Default value along with a changeComment  

**Notes:**  
(List all available fields that can be updated)  
**/meta.v1/Defect?xsl=api.xsl**  

(Update the Customfield that you are targeting) my example: Custom_Channel  
**/rest-1.v1/Data/Custom_Channel?sel=Custom_Channel.ID**  

**Requires v1config.yml**  
**token_id: (insert Token Bearer)**  
**base_url: (insert V1host site)**  
**base_uri: (insert Name)**  
```
token_id: InsertYourBearerTokenID  
base_url: https://www17.v1host.com_update_v1hostSite  
base_uri: /InsertCompanyName  
defect_uri: /rest-1.v1/Data/Defect  

defectSelection: ?sel=Number,Custom_Channel2.Name,AssetState&where=AssetState='64';Custom_Channel2.Name='';AssetState!='Deleted'
defectMulti: ?sel=Number,Custom_Channel2.Name,AssetState&where=AssetState='64';AssetState!='Deleted'
comment: ?Comment=Updated+Required+field+to+SELECT+CHANNEL
```
