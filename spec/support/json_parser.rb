module JsonParser
  def json
    JSON.parse(response.body)['data']
  end
end
