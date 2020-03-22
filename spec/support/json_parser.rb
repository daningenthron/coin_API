module JsonParser
  def json
    JSON.parse(response.body)
  end
end
