if not minetest.is_singleplayer() then 
    error("This game doesn't work in multiplayer!")
end

local insecure_env = minetest.request_insecure_environment()
if not insecure_env then
    error("\n\nmod security is activated!\n"..
          "disable in advanced development options\n\n\n\n\n\n\n\n\n")
end

local modpath = minetest.get_modpath(minetest.get_current_modname())
local funciones_path = minetest.get_modpath(minetest.get_current_modname()) .. "/funciones/"

function cargar_funciones()
    local archivos = minetest.get_dir_list(funciones_path)
    for _, archivo in ipairs(archivos) do
        if archivo:sub(-4) == ".lua" then
            dofile(funciones_path .. archivo)
            minetest.log("info", "Cargado el archivo: " .. archivo)
        end
    end
end

local function get_optimal_size()
    return 20, 20
end
local fondon = "#000000"
local fondo = "#2a6478"
local x, y = get_optimal_size()
local x1 = x + 1
local carpeta = "image_button[1,6;1,1;carpeta.png;Archivos;]"
local barracolor = "style[barra_ic;bgcolor=black;textcolor=white]"
local logo = "image[8.5,7;4,4;logo.png]"
local boton_rojo = "style[barra_ic;bgcolor=red;textcolor=white]"
local barra = "button[-0.5,13;" .. x1 .. ",5;barra_ic;]"
local icono = "image_button[0,14.8;0.90,0.80;inicio.png;inicio;]"
local timer_active = true 
local tamano = "size[" .. x .. "," .. y .. ",true]" 
local luanti = "label[8,10;Luanti OS]"
-------
function opciones()
    local formspec =tamano..
    logo..
    "bgcolor[" .. fondo .. "]"..
    "style[cerrar;bgcolor=red;textcolor=white]"..
    "style[volver;bgcolor=#F5F5DC;textcolor=white]"..
    "style[Juegos;bgcolor=#F5F5DC;textcolor=white]"..    
    barracolor..
    barra..  
    icono..   
    luanti..
    "textarea[1,12;5,5;;]" ..
    "button[0,13;2,2;volver;Volver]"..    
    "button_exit[0,12;2,2;cerrar;Cerrar OS]"..
    "label[18,14.8.7;Opciones]"
    return formspec
end


minetest.register_on_player_receive_fields(function(player, formname, fields)
    
end)

function inicio(player)
    local current_date = os.date("%Y-%m-%d--%H:%M:%S")
    local hora = "label[15,14.9;Hora: " .. current_date .. "]"
    local formspec = tamano..
        "bgcolor[" .. fondo .. "]"..
    barracolor..
    barra..  
    icono..
    logo..
    hora..
    "image_button[1,6;1,1;carpeta.png;Archivos;]"..
    "image_button[1,5;1,1;calculadora.png;calculadora;]"..
    luanti
    return formspec
end

function inicio_operative(player_name)
    local current_date = os.date("%Y-%m-%d--%H:%M:%S")
    local hora = "label[15,14.9;Hora: " .. current_date .. "]"
    local formspec = tamano..
    "bgcolor[" .. fondo .. "]"..
    barracolor..
    barra.. 
    logo.. 
    hora..
    luanti..
    "image_button[1,6;1,1;carpeta.png;Archivos;]"..
    "image_button[1,5;1,1;calculadora.png;calculadora;]"..
    "image_button[0,14.8;0.90,0.80;inicio_op.png;inicio;]"
    return formspec
end

function actualizar_hora(player)
    local name = player:get_player_name()
    local formspec = inicio(player)
    minetest.show_formspec(player:get_player_name(), "inicio", inicio())
end

function iniciar_temporizador(player,formname, fields)
    timer_active = true
    core.after(1, function()
        if timer_active then
            actualizar_hora(player)
            iniciar_temporizador(player)
        end
        if formname == "lua" then
            minetest.show_formspec(player:get_player_name(), "lua", lua()) 
        end    
    end)
end

function LCS()
    local mod_path = minetest.get_modpath("entrada")
    local file_path = mod_path .. "/../../../../bin/information.txt"
    local file = io.open(file_path, "r")
    local contenido = ""
        if file then
            contenido = file:read("*all")
            file:close()
        else
            return false, "No se pudo abrir el archivo."
        end
    local formspec = tamano..
    "bgcolor[" .. fondon .. "]"..
    barra..  
    icono..
    "button[1,9;5,2;escritorio;escritorio]".. 
    "textarea[7,6;6,6;contenido;Contenido del archivo;" .. contenido .. "]" ..
    "label[8,5;Luanti Control System]"
    return formspec
end

minetest.register_chatcommand("LCS", {
    params = "",
    description = "Luanti Control System",
    func = function(name)
    local mod_path = minetest.get_modpath("entrada")
    local file_path = mod_path .. "/../../../../bin/information.txt" 
    local file = io.open(file_path, "r")
    local contenido = ""
        if file then
            contenido = file:read("*all") 
            file:close()
        else
            return false, "No se pudo abrir el archivo."
        end
        local formspec = tamano..
        "bgcolor[" .. fondon .. "]"..
        barra..  
        icono..
        "textarea[7,6;6,6;contenido;System Information;" .. contenido .. "]" ..
        "label[8,5;Luanti Control System]"
        minetest.show_formspec(name, "LCS", formspec)
    end,
})

-------------/---------------------/-----------------------/-----------------------------/--------------
minetest.register_on_joinplayer(function(player)
    core.after(4, function()
        iniciar_temporizador(player)
        cargar_funciones()            
        os.execute(minetest.get_modpath("entrada") .. "/iniciar_info.bat")
        local sound_file = "start"
           minetest.sound_play(sound_file, {
           to_player = player:get_player_name(),
           gain = 0.7,
        })
    end)
end)
-------------/---------------------/-----------------------/-----------------------------/--------------
minetest.register_on_player_receive_fields(function(player, formname, fields)
    if fields.volver then
        timer_active = true
        iniciar_temporizador(player)
        minetest.show_formspec(player:get_player_name(), "opciones", opciones())
    end
    if fields.volver_op then
        minetest.show_formspec(player:get_player_name(), "opciones", opciones())
    end
    if formname == "inicio" or "inicio_op" then
        if fields.inicio then
        timer_active = false
        core.after(1, function()
        minetest.show_formspec(player:get_player_name(), "opciones", opciones())
        end)
    end
    end
    if formname == "inicio" then
        if fields.Archivos then
        timer_active = false
        core.after(0.5, function()
        minetest.show_formspec(player:get_player_name(), "mostrar_formspec", mostrar_formspec())
        end)
        elseif fields.calculadora then
        timer_active = false
        core.after(0.5, function()
        minetest.show_formspec(player:get_player_name(), "calculadora", calculadora())
        end)
    end
    elseif formname == "opciones" then
        if fields.Archivos then
        minetest.show_formspec(player:get_player_name(), "mostrar_formspec", mostrar_formspec())
        elseif fields.volver then
        minetest.show_formspec(player:get_player_name(), "inicio_operative", inicio_operative())
        elseif fields.cerrar then
        minetest.kick_player(player:get_player_name(), "Has cerrado el juego.")
        end
    end

end)
