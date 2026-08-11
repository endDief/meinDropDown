#yt-dlp es la dependencia que se va a encargar de descargar todos los videos, facil y rapido.
#para descargar esta dependencia es necesario el siguiente enlace: "https://github.com/yt-dlp/yt-dlp#readme"

# To Do: agregar diferentes opciones [calidad,audio, video, playlist,limitar la velocidad, tumbnails, entre otros]

def term_yt_dlp
    yt_dlp = File.expand_path("../yt-dlp.exe", __dir__)
    list = File.expand_path("../list.txt", __dir__)

    success = system(
        yt_dlp,
        "--batch-file",
        list
    )

    mssg = success ? "descarga terminada correctamente" : "yt-dlp terminó con un error"
    depurador(yt_dlp,list)
    puts mssg
end
def depurador(yt_dlp,list)
    puts "yt-dlp: #{yt_dlp}"
    puts "list:   #{list}"
    puts "existe yt-dlp?: #{File.exist?(yt_dlp)}"
    puts "existe list?:   #{File.exist?(list)}"
    puts "Contenido:"
    puts File.read(list).inspect if File.exist?(list)
end
