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
#java_import java.awt.FlowLayout
java_import java.awt.BorderLayout
java_import javax.swing.BoxLayout
java_import javax.swing.JPanel
java_import javax.swing.JTextArea
java_import javax.swing.JCheckBox
java_import javax.swing.JScrollPane
#java_import java.awt.GridBagLayout
#java_import java.awt.GridBagConstraints
#java_import javax.swing.BorderFactory
# Crear ventana

class Window < JFrame
  
  def initialize(title_window_name: "BuscarURL")
     super title_window_name
     #begin
     #window_config
     #rescue => e
      #puts "error en la configuracion de la ventana, swing.rb 34"
     #end
     #begin
     #window_assets
     window_config
     #rescue => e
      #puts "error al agregar los assets de la ventana, swing.rb 39"
     #nd
     #begin
     #xbuttom_generarURL
     init_ui
     #rescue => e
      #puts "error al generar el boton"
     #end
     setVisible(true)
     @on_procesar = nil
     # La variable 'text' (que es urls_finales) ya es un Array de Strings.
  end

  def on_procesar(&block)
    @on_procesar = block
  end

  def dwnld_procesar(&block)
    @dwnld_procesar = block
  end

  def window_config
    setSize(800,600)
    #setLayout (FlowLayout.new) #---> ¿?
    setDefaultCloseOperation(JFrame::EXIT_ON_CLOSE) 
    setLocationRelativeTo(nil)
    @root = JPanel.new(BorderLayout.new)
    setContentPane(@root)
  end

  def build_main_panel
    panel = JPanel.new(BorderLayout.new)

    panel.add(build_top_panel, BorderLayout::NORTH)
    panel.add(build_center_panel, BorderLayout::CENTER)

    panel
  end

  def init_ui
    @root.add(build_main_panel, BorderLayout::CENTER)
  end

  def build_top_panel
    puts "top panel"
    panel = JPanel.new
    panel.add(JLabel.new("Ingresa los titulos: "))
    return panel
  end
  def build_center_panel
    puts "center panel"
    panel = JPanel.new
    panel.setLayout(BoxLayout.new(panel, BoxLayout::Y_AXIS))

    @text_area = JTextArea.new('', 10, 40)
    scroll = JScrollPane.new(@text_area)
    panel.add(scroll)
    @download_checker = JCheckBox.new("Descargar?") #<- the new feature
    panel.add(@download_checker)

    button = JButton.new('GenerarURL')
    button.add_action_listener do |_|
      text = @text_area.get_text
      @on_procesar.call(text) if @on_procesar
      @dwnld_procesar.call(true) if @download_checker.isSelected
    end

    panel.add(button)

    return panel
  end
  def window_assets
    @text_area = JTextArea.new('', 10, 40)
    add(JLabel.new("INGRESA LOS TITULOS:"))
    scroll = JScrollPane.new(@text_area)  # <<-- envolvemos en JScrollPane
    add(scroll)
    #add (@text_area)
    #download_checker = JCheckBox.new("Descargar?")
    add (download_checker)
    #if download_checker.value == true
    #  checker = JCheckBox.new("video")
    #  add (checker)
    #  checker2 = JCheckBox.new("MUSIC")
    # add(checker2)
    #end
  end

  def buttom_generarURL
    button = JButton.new 'GenerarURL'
    add (button)

    button.add_action_listener do |_|

      text_of_area = @text_area.get_text
      @on_procesar.call(text_of_area) if @on_procesar
      

      @dwnld_procesar.call(true) if @download_checker.isSelected
     #puts "Texto ingresado: #{@text_area.get_text}"
     #text_of_area = @text_area.get_text 
     #puts text_of_area.class
     # urls_finales = procesar_texto(text_of_area) #>------------> procesar texto
                    # controller.inputView(script:"procesarTexto",text_of_area)
                    # controller.inputView(:procesarTexto, text_of_area)
     #urls_finales = event(post: @text_area.get_text,id:"textArea")               
     #urls_finales = Controller.request(post: @text_area.get_text,id:"textArea")
      #if urls_finales.empty?
        #messabox("No se encontraron resultados.")
      #else
        #Controller.request(post: urls_finales,id:"urlsFinales")
        #save_text_to_file(urls_finales) #>------------------> SaveTextToFile
        #controller.inputView(script: :saveTextFile, text: urls_finales)
      #end
    end
  end

  def buttom
    #
  end

  def messabox(textMessage)
    JOptionPane.show_message_dialog(self, textMessage)
  end

  def clear_text_area
    @text_area.set_text('')
  end
end
#Window.new
