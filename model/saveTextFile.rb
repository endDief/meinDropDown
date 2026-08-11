def save_text_to_file(text) 
  # 1. Aseguramos que solo trabajamos con URLs válidas
  urls_to_save = text.compact.map(&:strip).reject(&:empty?)

  if urls_to_save.empty?
    #<--- controllador ----> se envia un mensaje al controlador
    return {post: "No hay texto para guardar.", id: "error"}
    #JOptionPane.show_message_dialog(self, "No hay texto para guardar.")
  end
  begin
  filename = 'list.txt'

  # 2. Guardar línea por línea en modo append
  #    Iteramos directamente sobre el Array de URLs
  File.open(filename, 'a', encoding: 'UTF-8') do |f|
    urls_to_save.each { |line| f.puts(line) } # <-- ¡La clave es iterar aquí!
  end

  # Feedback visual
  # <-----------CONTROLADOR-------------> 
  {
   post: "Guardando #{urls_to_save.size} línea(s) en #{filename}." ,
   id: "ok"
  }
  # JOptionPane.show_message_dialog(self, "Guardando #{urls_to_save.size} línea(s) en #{filename}.")

  # Limpiar el área de texto después de guardar --> de eso se encarga el GUI
  # @text_area.set_text('') ---> no aplica.
  rescue => e
  # <----------------CONTROLADOR-------------------->
  return {post: "Error al guardar: #{e.message}", id: "error"}
  #JOptionPane.show_message_dialog(self, "Error al guardar: #{e.message}")
  end
end