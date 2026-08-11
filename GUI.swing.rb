require 'java'
require 'json'
#require 'net/http'
#require 'net/https'
require 'open-uri'
require 'uri'

# IMPORTAMOS HTTP de JAVA
java_import java.net.URL
java_import java.io.IOException
java_import java.util.Scanner
java_import java.io.ByteArrayOutputStream
# Importamos clases de Swing
java_import javax.swing.JFrame
java_import javax.swing.JButton
java_import javax.swing.JLabel
java_import javax.swing.JTextField
java_import javax.swing.JOptionPane
java_import java.awt.FlowLayout
java_import javax.swing.JPanel
java_import javax.swing.JTextArea
java_import javax.swing.JCheckBox
java_import javax.swing.JScrollPane
#java_import java.awt.GridBagLayout
#java_import java.awt.GridBagConstraints
#java_import javax.swing.BorderFactory
# Crear ventana

class Window < JFrame
  API_KEY = "API_DO_CLOUD.GOOGLE.COM"
  def initialize
     super 'BuscarURL'
     setSize(800,600)
     setLayout (FlowLayout.new)
     setDefaultCloseOperation(JFrame::EXIT_ON_CLOSE) 
     setLocationRelativeTo(nil)
     @text_area = JTextArea.new('', 10, 40)
     add(JLabel.new("INGRESA LOS TITULOS:"))
     scroll = JScrollPane.new(@text_area)  # <<-- envolvemos en JScrollPane
     add(scroll)
     #add (@text_area)
     checker = JCheckBox.new("video")
     add (checker)
     checker2 = JCheckBox.new("MUSIC")
     add(checker2)
     button = JButton.new 'enviar'
     add (button)
     button.add_action_listener do |_|
      puts "Texto ingresado: #{@text_area.get_text}"
      text_of_area = @text_area.get_text
      puts text_of_area.class
      urls_finales = procesar_texto(text_of_area)
         if urls_finales.empty?
             JOptionPane.show_message_dialog(self, "No se encontraron resultados.")
         else
             save_text_to_file(urls_finales)
         end
     end
    setVisible(true)
  end

  # La variable 'text' (que es urls_finales) ya es un Array de Strings.
def save_text_to_file(text) 
  # 1. Aseguramos que solo trabajamos con URLs válidas
  urls_to_save = text.compact.map(&:strip).reject(&:empty?)

  if urls_to_save.empty?
    JOptionPane.show_message_dialog(self, "No hay texto para guardar.")
    return
  end

  filename = 'list.txt'

  # 2. Guardar línea por línea en modo append
  #    Iteramos directamente sobre el Array de URLs
  File.open(filename, 'a', encoding: 'UTF-8') do |f|
    urls_to_save.each { |line| f.puts(line) } # <-- ¡La clave es iterar aquí!
  end

  # Feedback visual 
  JOptionPane.show_message_dialog(self, "Guardando #{urls_to_save.size} línea(s) en #{filename}.")

  # Limpiar el área de texto después de guardar
  @text_area.set_text('')
rescue => e
  JOptionPane.show_message_dialog(self, "Error al guardar: #{e.message}")
end

  def generar_urls(texto, max_results: 1)
    puts "Generar Url"
     base = "https://www.googleapis.com/youtube/v3/search"
     lineas = texto.to_s.split("\n").map(&:strip).reject(&:empty?)
     lineas.map do |linea|
      params = {
      part: "snippet",
      q: linea,
      type: "video",
      maxResults: max_results,
      key: self.class::API_KEY
      }
      query_string = params.map { |k,v| "#{k}=#{URI.encode_www_form_component(v)}" }.join("&")
      "#{base}?#{query_string}"
      end
  end

  # Dentro de la clase Window...
def obtener_video_url(api_url)
  puts 'obtener el video URL con la librería de Java (Lectura con Buffer)'
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
    # ... (el resto de tu lógica de JSON)
    puts json
    
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

def procesar_texto(texto)
    urls_api = generar_urls(texto)
    resultados = []
    puts urls_api
    puts "#{urls_api.class} aqui es el URLAPI del procesar texto"
    if urls_api.empty?
        JOptionPane.show_message_dialog(self, "No se encontraron URLs para procesar.")
    return []
    #return "el urls_api que guarda Generar_urls(texto) del Procesar_texto en la linea 116 ESTA VACIO"
    else
      urls_api.each do |api_url|
        video_url = obtener_video_url(api_url)
        resultados << video_url if video_url
        sleep 1 # evita saturar la API
      end
    end
    resultados
  end

end
Window.new
