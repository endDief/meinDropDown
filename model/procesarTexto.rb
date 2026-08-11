def procesar_texto(texto)
    urls_api = generar_urls(texto) #--> DEF EXTERNO:
    resultados = []
    # puts urls_api
    # puts "#{urls_api.class} aqui es el URLAPI del procesar texto"
    return {post:"No se encontraron URLs para procesar.", id:"error"} if urls_api.empty?
      # <------CONTROLADOR-------->
      #event(post:"No se encontraron URLs para procesar.", id:"error")
      #Controlador.request(post:"No se encontraron URLs para procesar.", id:"error")
      #JOptionPane.show_message_dialog(self, "No se encontraron URLs para procesar.")
    #return []
    #return "el urls_api que guarda Generar_urls(texto) del Procesar_texto en la linea 116 ESTA VACIO"
    urls_api.each do |api_url|
      video_url = obtener_video_url(api_url) #--> DEF EXTERNO:
      resultados << video_url if video_url #ARRAY
      sleep 1 # evita saturar la API
    end
  resultados
end