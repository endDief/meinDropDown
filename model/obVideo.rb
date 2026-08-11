# Dentro de la clase Window...
def obtener_video_url(api_url)
  #puts 'obtener el video URL con la librería de Java (Lectura con Buffer)'
  url = api_url.to_s
  
  begin
    java_url = URL.new(url)
    connection = java_url.open_connection
    
    connection.set_connect_timeout(5000)
    connection.set_read_timeout(5000)
    
    input_stream = connection.get_input_stream
    
    # ----------------------------------------------------
    #  SOLUCIÓN AL ERROR: LECTURA DE STREAM USANDO BUFFER
    # ----------------------------------------------------
    output = ByteArrayOutputStream.new
    buffer = Java::byte[4096].new # Crear un buffer de 4KB
    
    bytes_read = 0
    # Leer en el buffer y escribir en el output stream hasta que no haya más datos
    while (bytes_read = input_stream.read(buffer)) != -1
      output.write(buffer, 0, bytes_read)
    end
    
    input_stream.close
    output.close
    
    # Obtener los bytes y convertirlos a String
    data_bytes = output.to_byte_array
    data = String.from_java_bytes(data_bytes, "UTF-8")
    # ----------------------------------------------------
    
    # Continuar con el procesamiento de JSON
    json = JSON.parse(data)
    # puts json
    
    if json["items"] && json["items"].any?
      video_id = json["items"][0]["id"]["videoId"]
      puts "#{video_id} aqui se obtiene el Json[items videoID]"
      return "https://www.youtube.com/watch?v=#{video_id}"
    else
      puts "No se encontraron items en la respuesta de YouTube para URL: #{api_url}"
      return nil
    end

  # ... (resto de las capturas de errores)
  rescue IOException => e
    puts "Error de Conexión/Red (Java): #{e.message}"
    nil
  rescue JSON::ParserError => e
    puts "Error al parsear JSON: #{e.message}"
    nil
  rescue => e
    puts "Error general en la API: #{e.message}"
    nil
  end
end
