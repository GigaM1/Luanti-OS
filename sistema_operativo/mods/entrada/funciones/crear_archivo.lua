local function pantalla()
    return 20, 20 
end

local x, y = pantalla()
local x1 = x + 1
local barracolor = "style[barra_ic;bgcolor=black;textcolor=white]"
local boton_rojo = "style[barra_ic;bgcolor=red;textcolor=white]"
local barra = "button[-0.5,13;" .. x1 .. ",5;barra_ic;]"
local icono = "image_button[0,14.8;0.90,0.80;inicio.png;inicio;]"
local timer_active = true 
local fondo = "#2a6478"
local tamano = "size[" .. x .. "," .. y .. ",true]" 

function mostrar_formspec(player_name)
    local current_file_path = debug.getinfo(1, "S").source:sub(2)
    local current_directory = current_file_path:match("(.*/)")
    local folder_path = current_directory.."/func_usuario/"
    local archivos = minetest.get_dir_list(folder_path, false)
    local archivos_excluir = {
        ["calculadora.lua"] =    true,
        ["crear_archivo.lua"] =  true,
        ["auth.sqlite"] =        true,
        ["env_meta.txt"] =       true,
        ["force_loaded.txt"] =   true,
        ["ipban.txt"] =          true,
        ["map.sqlite"] =         true,
        ["map_meta.txt"] =       true,
        ["mod_storage.sqlite"] = true,
        ["players.sqlite"] =     true,
        ["world.mt"] =           true,
    }

    local formspec = tamano..
        "bgcolor[" .. fondo .. "]"..
        barracolor..
        barra..  
        icono..
        "image_button[0,14.8;0.90,0.80;inicio_op.png;inicio;]"..
        "field[2,5;6,3;nombre_archivo;Nombre del archivo;]" ..
        "field[2,6;6,3;ext;Extension;]" ..
        "button[1.7,7;2,2;guardar;Crear]"..
        "button[1.7,11;2.5,2;archivos_lua;Archivos Sistema]"..
        "button[4,7;2,2;volver_in;Volver]"
    formspec = formspec .. "textarea[8,5;8,10;Archivos;Archivos;" .. table.concat(archivos, "\n") .. "]"
    local y_offset = 0
    for _, archivo in ipairs(archivos) do
        if not archivos_excluir[archivo] then
            formspec = formspec .. "button[18," .. (5 + y_offset) .. ";2,1;editar_" .. archivo .. ";" .. archivo .. "]" 
            y_offset = y_offset + 1 
        end
    end
    return formspec
end

function archivos_lua(player_name)
    local current_file_path = debug.getinfo(1, "S").source:sub(2)
    local current_directory = current_file_path:match("(.*/)")
    local folder_path = current_directory
    local archivos = minetest.get_dir_list(folder_path, false)
    local archivos_excluir = {["calculadora.lua"] =    true,["crear_archivo.lua"] =  true,["personalizar.lua"] =   true,}
    local formspec = tamano..
        "bgcolor[" .. fondo .. "]"..
        barracolor..
        barra..  
        icono..
        "image_button[0,14.8;0.90,0.80;inicio_op.png;inicio;]"..
        "field[2,5;6,3;nombre_archivo;Nombre del archivo;]" ..
        "field[2,6;6,3;ext;Extension;]" ..
        "button[1.7,7;2,2;guardar;Crear]"..
        "label[1.6,4.7;Archivos del sistema]" ..
        "button[1.7,11;2.5,2;archivoinit;Archivos Init.lua]"..
        "label[1.6,9;Nota:si el archivo creado es de Extension lua \nse añadira al directorio principal de \nfunciones del sistema. \nSe creara con un codigo base para agregarse a las \nfunciones basicas.]" ..
        "button[4,7;2,2;volver_archivos;Volver]"

    formspec = formspec .. "textarea[8,5;8,10;Archivos;Archivos;" .. table.concat(archivos, "\n") .. "]"
    local y_offset = 0
    for _, archivo in ipairs(archivos) do
        if not archivos_excluir[archivo] then
            formspec = formspec .. "button[18," .. (5 + y_offset) .. ";2,1;editar_" .. archivo .. ";" .. archivo .. "]" 
            y_offset = y_offset + 1 
        end
    end
    return formspec
end

function abrir_archivo(nombre_archivo, ext)
    if not ext or ext == "" then
        minetest.log("error", "El formato del archivo no puede estar vacío.")
        return
    end
    if not nombre_archivo or nombre_archivo == "" then
        minetest.log("error", "El nombre del archivo no puede estar vacío.")
        return
    end
    local current_file_path = debug.getinfo(1, "S").source:sub(2) 
    local current_directory = current_file_path:match("(.*/)")
    local folder_path
    if ext == "lua" then
        folder_path = current_directory --
    else
        folder_path = current_directory.."/func_usuario/"
    end
    local file_path = folder_path .. nombre_archivo .. "." .. ext

    local file, err = io.open(file_path, "w") 
    if not file then
        minetest.log("error", "No se pudo abrir el archivo: " .. err)
        return
    end

    local cont = [[
      local function get_optimal_size()
      -- Aquí puedes definir un tamaño óptimo
      return 20, 20 -- x, y
      end
      local fondo = colo_ele_form or "#2a6478"
      local x, y = get_optimal_size()
      local x1 = x + 1
      local barracolor = "style[barra_ic;bgcolor=black;textcolor=white]"
      local boton_rojo = "style[barra_ic;bgcolor=red;textcolor=white]"
      local barra = "button[-0.5,13;" .. x1 .. ",5;barra_ic;]"
      local icono = "image_button[0,14.8;0.90,0.80;inicio.png;inicio;]"
      local timer_active = true 
      local tamano = "size[" .. x .. "," .. y .. ",true]" 
    ]]
    if ext == "lua" then
        folder_path = current_directory
        file:write(cont)
        file:close()
    else
        folder_path = current_directory.."/func_usuario/"
        file:write("Hola Minetest!")
        file:close()
    end
    minetest.log("info", "Archivo guardado en: " .. file_path)

end

function mostrar_editar_archivo_lua(nombre_archivo)
    if not nombre_archivo then
        minetest.log("error", "El nombre del archivo es nil.")
        return
    end
    local current_file_path = debug.getinfo(1, "S").source:sub(2) 
    local current_directory = current_file_path:match("(.*/)")
    local folder_path = current_directory
    local file_path = folder_path .. nombre_archivo
    local file, err = io.open(file_path, "r")
    if not file then
        minetest.log("error", "No se pudo abrir el archivo: " .. err)
        return
    end
    local contenido = file:read("*all")
    file:close()
    local formspec = tamano..
        barracolor..
        "bgcolor[" .. fondo .. "]"..
        "button[-0.5,13;" .. x1 .. ",5;barra_ic;]"..
        icono..
        "field[0.5,5;6,1;nombre_archivo;Nombre del archivo;" .. nombre_archivo .. "]" ..
        "textarea[0.5,6;12,8;contenido;Contenido del archivo;" .. minetest.formspec_escape(contenido) .. "]" ..
        "button[13,7;2.3,1;guardar_cambios_lua;Guardar Cambios]"..
        "button[13,5.9;2,1;volver_archivos;Volver]"..
        "button[13,8.9;2.3,1;eliminar_archivo_lua;Eliminar Archivo]"
    return formspec
end

function eliminar_archivo(nombre_archivo, player)
    if not nombre_archivo then
        minetest.log("error", "El nombre del archivo es nil.")
        return
    end
    local current_file_path = debug.getinfo(1, "S").source:sub(2) 
    local current_directory = current_file_path:match("(.*/)")
    local folder_path = current_directory.."/func_usuario/"
    local file_path = folder_path .. nombre_archivo
    local success, err = os.remove(file_path)
    if success then
        minetest.log("action", "Archivo eliminado: " .. file_path)
    else
        minetest.log("error", "No se pudo eliminar el archivo: " .. err)
    end
end
function editar_init(player_name)
    local current_file_path = debug.getinfo(1, "S").source:sub(2)
    local current_directory = current_file_path:match("(.*/)")
    local init_file_path = current_directory .. "../init.lua"  
    local file = io.open(init_file_path, "r")
    local contenido = file:read("*all")
    file:close()
    local formspec = tamano..
        barracolor..
        "bgcolor[" .. fondo .. "]"..
        "button[-0.5,13;" .. x1 .. ",5;barra_ic;]"..
        icono..
        "textarea[0.5,6;12,8;contenido;Contenido de Init.lua (archivo principal);" .. minetest.formspec_escape(contenido) .. "]" ..
        "button[13,7;2.3,1;guardar_cambios;Guardar Cambios]"..
        "button[13,5.9;2,1;volver_mo;Volver]"..
        "button[13,8.9;2.3,1;eliminar_archivo;Eliminar Archivo]" 
    return formspec
end

function eliminar_archivo_lua(nombre_archivo, player)
    if not nombre_archivo then
        minetest.log("error", "El nombre del archivo es nil.")
        return
    end
    local current_file_path = debug.getinfo(1, "S").source:sub(2) 
    local current_directory = current_file_path:match("(.*/)")
    local folder_path = current_directory
    local file_path = folder_path .. nombre_archivo
    local success, err = os.remove(file_path)
    if success then
        minetest.log("action", "Archivo eliminado: " .. file_path)
    else
        minetest.log("error", "No se pudo eliminar el archivo: " .. err)
    end
end

function mostrar_editar_archivo(nombre_archivo)
    if not nombre_archivo then
        minetest.log("error", "El nombre del archivo es nil.")
        return
    end
    local current_file_path = debug.getinfo(1, "S").source:sub(2)
    local current_directory = current_file_path:match("(.*/)")
    local folder_path = current_directory.."/func_usuario/"
    local file_path = folder_path .. nombre_archivo
    local file, err = io.open(file_path, "r")
    if not file then
        minetest.log("error", "No se pudo abrir el archivo: " .. err)
        return
    end
    local contenido = file:read("*all")
    file:close()
    local formspec = tamano..
        barracolor..
        "bgcolor[" .. fondo .. "]"..
        "button[-0.5,13;" .. x1 .. ",5;barra_ic;]"..
        icono..
        "field[0.5,5;6,1;nombre_archivo;Nombre del archivo;" .. nombre_archivo .. "]" ..
        "textarea[0.5,6;12,8;contenido;Contenido del archivo;" .. minetest.formspec_escape(contenido) .. "]" ..
        "button[13,7;2.3,1;guardar_cambios;Guardar Cambios]"..
        "button[13,5.9;2,1;volver_mo;Volver]"..
        "button[13,8.9;2.3,1;eliminar_archivo;Eliminar Archivo]" 
    return formspec
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
    if fields.volver_in then
        timer_active = true
        iniciar_temporizador(player)
        minetest.show_formspec(player:get_player_name(), "inicio", inicio(player:get_player_name()))
    end
    if fields.volver_mo then
        minetest.show_formspec(player:get_player_name(), "mostrar_formspec", mostrar_formspec())
    end
    if fields.eliminar_archivo_lua then
        local nombre_archivo = fields.nombre_archivo
        eliminar_archivo_lua(nombre_archivo)
        minetest.show_formspec(player:get_player_name(), "mostrar_formspec", mostrar_formspec())
    end
    if fields.eliminar_archivo then
        local nombre_archivo = fields.nombre_archivo
        eliminar_archivo(nombre_archivo)
        minetest.show_formspec(player:get_player_name(), "mostrar_formspec", mostrar_formspec())
    end
    if formname == "mostrar_formspec" then
        if fields.archivos_lua then
            minetest.show_formspec(player:get_player_name(), "archivos_lua", archivos_lua(player:get_player_name()))
        end
        if fields.guardar then
            abrir_archivo(fields.nombre_archivo, fields.ext)
            minetest.show_formspec(player:get_player_name(), "mostrar_formspec", mostrar_formspec(player:get_player_name()))
        end
        local current_file_path = debug.getinfo(1, "S").source:sub(2) -- Eliminar el primer carácter '@'
        local current_directory = current_file_path:match("(.*/)")
        local folder_path = current_directory.."/func_usuario/"
        for _, archivo in ipairs(minetest.get_dir_list(folder_path, false)) do
            if fields["editar_" .. archivo] then
                minetest.show_formspec(player:get_player_name(), "mostrar_editar_archivo", mostrar_editar_archivo(archivo))
            end
        end
    end
    if formname == "archivos_lua" then
        if fields.volver_archivos then
            minetest.show_formspec(player:get_player_name(), "mostrar_formspec", mostrar_formspec())
        end
        if fields.archivoinit then
            minetest.show_formspec(player:get_player_name(), "editar_init", editar_init(player_name))
        end
        if fields.guardar then
            abrir_archivo(fields.nombre_archivo, fields.ext)
            minetest.show_formspec(player:get_player_name(), "archivos_lua", archivos_lua(player:get_player_name()))
        end
        local current_file_path = debug.getinfo(1, "S").source:sub(2) -- Eliminar el primer carácter '@'
        local current_directory = current_file_path:match("(.*/)")
        local folder_path = current_directory
        for _, archivo in ipairs(minetest.get_dir_list(folder_path, false)) do
            if fields["editar_" .. archivo] then
                minetest.show_formspec(player:get_player_name(), "mostrar_editar_archivo_lua", mostrar_editar_archivo_lua(archivo))
            end
        end
    end
    
    if formname == "editar_init" then
        if fields.guardar_cambios then
            local current_file_path = debug.getinfo(1, "S").source:sub(2)
            local current_directory = current_file_path:match("(.*/)")
            local init_file_path = current_directory .. "../init.lua" 
            local file, err = io.open(init_file_path, "w") 
            if file then     
                file:write(fields.contenido) 
                file:close()
                minetest.log("info", "Cambios guardados en: " .. init_file_path)
            else
                minetest.log("error", "No se pudo guardar el archivo: " .. err)
            end
        end
    end
    if formname == "mostrar_editar_archivo" then
        if fields.guardar_cambios then
            local current_file_path = debug.getinfo(1, "S").source:sub(2)
            local current_directory = current_file_path:match("(.*/)")
            local folder_path = current_directory.."/func_usuario/"
            local file_path = folder_path .. fields.nombre_archivo
            local file, err = io.open(file_path, "w") 
            if file then     
                file:write(fields.contenido) 
                file:close()
                minetest.log("info", "Cambios guardados en: " .. file_path)
            else
                minetest.log("error", "No se pudo guardar el archivo: " .. err)
            end
        end
    end
    if formname == "mostrar_editar_archivo_lua" then
        if fields.guardar_cambios_lua then
            local current_file_path = debug.getinfo(1, "S").source:sub(2)
            local current_directory = current_file_path:match("(.*/)")
            local folder_path = current_directory
            local file_path = folder_path .. fields.nombre_archivo
            local file, err = io.open(file_path, "w") 
            if file then     
                file:write(fields.contenido) 
                file:close()
                minetest.log("info", "Cambios guardados en: " .. file_path)
            else
                minetest.log("error", "No se pudo guardar el archivo: " .. err)
            end
        end
        if fields.volver_archivos then
            minetest.show_formspec(player:get_player_name(), "archivos_lua", archivos_lua())
        end
    end

end)