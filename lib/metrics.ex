defmodule Phx.Metrics do
  use Prometheus.Metric

  def setup do
    ## Counter for page turns

    Counter.new(
      name: :elixir_app_page_turned,
      help: "Counter for page turns"
    )

    # Our counter for the number of searches against a particular zipcode.
    # Given that there is a label 'geohash' each zip code gets its own counter.
    # Counter.new(
    #   name: :elixir_app_zip_code_search,
    #   help: "Counter for brewery zip code searches",
    #   labels: [:zip_code, :geohash]
    # )

    # The provided radius will fall into one of the defined buckets
    # Histogram.new(
    #   name: :elixir_app_radius_search,
    #   buckets: [1, 2, 5, 10, 20, 50],
    #   help: "The radius that people are searching within for breweries"
    # )
  end

  # def increment_zip_code_search(zip_code) do
  #   zip_code
  #   |> Phx.ZipCodes.get_zip_code_info()
  #   |> case do
  #     %ZipCode{point: %Geo.Point{coordinates: {long, lat}}} ->
  #       geo_hash = Geohash.encode(lat, long)
  #       Counter.inc(name: :elixir_app_zip_code_search, labels: [zip_code, geo_hash])

  #     _ ->
  #       :noop
  #   end
  # end

  # def observe_radius_search(radius) do
  #   Histogram.observe([name: :elixir_app_radius_search], String.to_integer(radius))
  # end

  def increment_page_turner() do
    Counter.inc(name: :elixir_app_page_turned)
  end
end
