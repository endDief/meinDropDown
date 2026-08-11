class Controller
    #attr_accessor :view, :model
    
  def initialize(view:, model:)
    @view = view
    @model = model

    conectar
  end
  def conectar
    @view.on_procesar do |texto|
      res = @model.procesar_texto(texto)

    if res[:id] == "error"
      @view.mostrar(res[:post])
      next
    end
    urls = res[:data]
    res2 = @model.save_text_to_file(urls)

    if res2[:id] == "error"
      @view.messabox(res2[:post])
    else
      @view.messabox(res2[:post])
      @view.clear_text_area
    end

    @view.dwnld_procesar do |unBool|
        @model.yt_dlp if unBool
       end
    end

  end
end
