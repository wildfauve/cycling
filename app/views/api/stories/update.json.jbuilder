json.status "ok"
json.status_code 200
json.story do
  json.id @story.id
  json.ref @story.ref
  json.desc @story.desc
  json.start_date @story.start_date
  json.dev_start_date @story.dev_start_date
  json.dev_end_date @story.dev_end_date
  json.test_end_date @story.test_end_date  
  json.end_date @story.end_date    
end