json.array!(@playoffs) do |playoff|
  json.extract! playoff, :id, :team1, :team2, :title, :running, :g1, :g2, :g3, :g4, :g5, :g6, :g7
  json.url playoff_url(playoff, format: :json)
end
