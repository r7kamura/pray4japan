require "rubygems"
require "instagram"
require "pp"

# auth
Instagram.configure do |config|
  config.client_id    = "227676dd7872413d8eb3b3de6115e073"
  config.access_token = "2476031.227676d.55a3cd10c3c84d8bbee3c548f84a0f62"
end

# pp Instagram.tag("cat")
  # {"media_count"=>34922, "name"=>"cat"}

# pp Instagram.tag_recent_media("cat").count
  # 20

pp Instagram.tag_recent_media("playforjapan")
  # 
  #{"tags"=>["neko", "cats", "fuga", "cat"],
    #"type"=>"image",
    #"location"=>nil,
    #"comments"=>{"count"=>0, "data"=>[]},
    #"filter"=>nil,
    #"created_time"=>"1299943379",
    #"link"=>"http://instagr.am/p/CLsyR/",
    #"likes"=>{"count"=>0, "data"=>[]},
    #"images"=>
    #{"low_resolution"=>
      #{"url"=>
        #"http://distillery.s3.amazonaws.com/media/2011/03/12/b76e84183c5c4d2c8ece33707c9ed5be_6.jpg",
        #"width"=>306,
        #"height"=>306},
      #"thumbnail"=>
      #{"url"=>
        #"http://distillery.s3.amazonaws.com/media/2011/03/12/b76e84183c5c4d2c8ece33707c9ed5be_5.jpg",
        #"width"=>150,
        #"height"=>150},
      #"standard_resolution"=>
      #{"url"=>
        #"http://distillery.s3.amazonaws.com/media/2011/03/12/b76e84183c5c4d2c8ece33707c9ed5be_7.jpg",
        #"width"=>612,
        #"height"=>612}},
    #"caption"=>
    #{"created_time"=>"1299943399",
      #"text"=>"#cat #cats #fuga #neko",
      #"from"=>
      #{"username"=>"index_level5",
        #"profile_picture"=>
        #"http://distillery.s3.amazonaws.com/profiles/profile_2207879_75sq_1298705634.jpg",
        #"id"=>"2207879",
        #"full_name"=>""},
      #"id"=>"45967794"},
    #"user_has_liked"=>false,
    #"id"=>"36621457",
    #"user"=>
    #{"username"=>"index_level5",
      #"profile_picture"=>
      #"http://distillery.s3.amazonaws.com/profiles/profile_2207879_75sq_1298705634.jpg",
      #"id"=>"2207879",
      #"full_name"=>""}}, 

# pp Instagram.user_search("r7kamura") 
  # [{"username"=>"r7kamura",
  #   "profile_picture"=>
  #    "http://distillery.s3.amazonaws.com/profiles/anonymousUser.jpg",
  #   "id"=>"2476031",
  #   "full_name"=>"Ryo Nakamura"}]


