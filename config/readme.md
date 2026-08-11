# Carpeta config
---

Aqui vas a poner tu key.env (un archivo que contiene API_KEY=TU_CLAVE_DE_API tal cual)
para conseguir tu clave de API de youtube usar https://console.cloud.google.com/
esto es necesario en caso de usar la generacion de URLs (en la primera version es completamente necesario pero en posteriores versiones seran completamente opsional)

 proyecto/
 |
 |--> config/ --- Aqui vas aponer los siguientes archivos y encontraras los siguientes
 | |-> env.rb --- codigo que lee el keyAPI que el proyecto usa para funcionar
 | |-> key.env --- API_KEY=AAAAAAAAAAAAA-AAAAAAAAAAAAAAAAAAAAAAAAA aprox esto es lo que encontraras en console.cloud.google, pegar sin espacios. 
 
--- 
### ¿Por qué es necesario crear el key.env?

Es en este archivo que pondremos el API porque en env.rb espera que exista para que funcione la generacion de URLs.


### ¿Por qué es necesario el API_KEY?

la principal funcion de este proyecto es recibir los titulos del usuario y buscarlos en youtube usando la API oficial para conseguir las URL de cada video, con estas URL se pasan a la dependencia* y asi descargarlos. sin la API_KEY no se pueden conseguir las URL y por lo tanto en esta primera version no se puede continuar con la descarga. (en proximas versiones será opcional)


```
{
    post: {
            @text_area.get_text,
            id:"textArea"
          }
}

MVC/ --- carpeta raiz
|
|--> config/ ---- aqui deberia poder empaquetar con un comando.
    |-> key.env ---- key de API.
|--> controller/
    |-> controller.rb ---- clase principal del controller
|--> libs/
|--> model/
    |-> model.rb ---- clase principal del model
    |-> generarAlgo.rb
    |-> obvd.rb
    |-> codigodentro.rb
|--> sevice/
    |-> union.rb
|--> test/
|--> view/
    |-> config.rb ---- ventana de configuracion
    |-> swing.rb ---- ventana principal
    |-> view.rb ---- clase principal
|-> main.br ---- aqui deberia iniciar todo.


A tener en cuenta, en el archivo union.rb* el codigo es:

require_relative "controller/controller"
require_relative "model/model"
require_relative "view/swing"

model = Model.new
view = View.new
controller = Controller.new(model: model,view: view)

todos los Model deben responder con:
{
  id: "ok" | "error",
  message: String,
  data: Array | nil
}
```
