json.status "ok"
json.status_code 200
json.stories @stories do |story|
  json.id story.id
  json.ref story.ref
  json.description story.desc
  json._links do
    	json.self {json.href api_story_url(story)}
  end 
end