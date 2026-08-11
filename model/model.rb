require_relative "./obVideo"
require_relative "./genURL"
require_relative "./term_yt_dlp"

class Model
def initialize(api_key:)
  @api_key = api_key
end
def procesar_texto(texto)
    urls_api = generar_urls(texto) #--> DEF EXTERNO:
    resultados = []

    return { id:"error", post:"No se encontraron URLs para procesar.", data: nil } if urls_api.empty?
    
    resultados = urls_api.map do |api_url|
      video_url = obtener_video_url(api_url) #--> DEF EXTERNO:
      sleep 1 # evita saturar la API
      video_url
    end.compact

    resultados_limpios = resultados.select { |e| e.is_a?(String) }.map(&:strip).reject(&:empty?)
    if resultados_limpios.empty?
    return {
      id: "error",
      message: "No se pudieron obtener URLs válidas.",
      data: nil
    }
    end
    return {id: "ok", post:"URLs generadas correctamente", data: resultados_limpios}
end

def save_text_to_file(text)
  unless text.is_a?(Array)
      return {
        id: "error",
        message: "Se esperaba un Array",
        data: nil
      }
  end
 
  urls_to_save = text.select { |e| e.is_a?(String) }.map(&:strip).reject(&:empty?)
  
  if urls_to_save.empty?
    return {id: "error", post: "No hay texto para guardar.", data: nil}
  end

  filename = 'list.txt'

  File.open(filename, 'a', encoding: 'UTF-8') do |f|
    urls_to_save.each { |line| f.puts(line) } # <-- ¡La clave es iterar aquí!
  end
 
  {
   id: "ok",
   post: "Guardando #{urls_to_save.size} línea(s) en #{filename}." ,
   data: nil
  }
  
  rescue => e
  
  return { id: "error", post: "Error al guardar: #{e.message}", data: nil}
  
end
def yt_dlp
  term_yt_dlp
end
end
