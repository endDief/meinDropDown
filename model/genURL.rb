def generar_urls(texto, max_results: 1)
    #puts "Generar Url"
    base = "https://www.googleapis.com/youtube/v3/search"
    lineas = texto.to_s.split("\n").map(&:strip).reject(&:empty?)
    lineas.map do |linea|
    params = {
    part: "snippet",
    q: linea,
    type: "video",
    maxResults: max_results,
    key: @api_key #self.class::API_KEY #--> AQUI esta el mayor problema
    }
    query_string = params.map { |k,v| "#{k}=#{URI.encode_www_form_component(v)}" }.join("&")
    "#{base}?#{query_string}"
    end
end
