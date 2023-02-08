require 'elasticsearch'
$client=Elasticsearch::Client.new(host:"http://localhost:9200/", logs:true)