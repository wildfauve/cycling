json.status "ok"
json.status_code 200
(1..500).each do
  json.stories @stories do |story|
    json.cache! story do
      json.id story.id
      json.ref story.ref
      json.description story.desc
      json._links do
        	json.self {json.href api_story_url(story)}
      end 
    end
  end
end