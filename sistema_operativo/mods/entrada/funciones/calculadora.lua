
local function pantalla()
    return 20, 20 
end

local x, y = pantalla()
local x1 = x + 1
local barracolor = "style[barra_ic;bgcolor=black;textcolor=white]"
local barra = "button[-0.5,13;" .. x1 .. ",5;barra_ic;]"
local icono = "image_button[0,14.8;0.90,0.80;inicio.png;inicio;]"
local tamano = "size[" .. x .. "," .. y .. ",true]" 
local fondo = "#2a6478"

local base_calculadora = 

    "label[2,5;Calculadora:]" ..
    "field[2,6;2,1;numero1;;]" .. 
    "field[2,7;2,1;numero2;;]" ..

    "button[8,5;1,1;sumar;+]"..
    "button[8,6;1,1;restar;-]"..
    "button[8,7;1,1;dividir;/]"..
    "button[8,8;1,1;multiplicar;*]"..

    "button[7,5;1,1;raiz;√]"..
    "button[7,6;1,1;seno;sen]"..
    "button[7,7;1,1;coseno;cos]"..
    "button[7,8;1,1;tangente;tan]"..

    "button[6,5;1,1;log;log]"..
    "button[6,6;1,1;exp;exp]"..
    "button[6,7;1,1;log10;log10]"..

    "button[1.8,8;2,2;volver_in;Volver]"

-------
function calculadora()
    local formspec = "size[" .. x .. "," .. y .. ",true]" ..
    "bgcolor[" .. fondo .. "]"..
    base_calculadora ..
    barracolor..
    barra..  
    icono..
    "button[1.8,8;2,2;volver_in;Volver]"
    return formspec
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
    if formname == "calculadora" then

        if not fields.numero1 == "" then
             minetest.log("error", "Los campos de número no pueden estar vacíos.")
             return
         end
        local numero1 = tonumber(fields.numero1)
        local numero2 = tonumber(fields.numero2) or 0

        if numero1 == nil then
            minetest.log("error", "Los campos deben contener números válidos.")
            return
        end   

        if nil then 
        elseif fields.sumar then   
        local  formspec = "size[" .. x .. "," .. y .. ",true]" ..
        "bgcolor[" .. fondo .. "]"..
        fondo..
        barracolor..
        barra..  
        icono..
        base_calculadora..
        "textarea[10,5;6,2;mostrar;;".. numero1 + numero2 .."]"
        minetest.show_formspec(player:get_player_name(), "calculadora", formspec)

        elseif fields.restar then
        local  formspec = "size[" .. x .. "," .. y .. ",true]" ..
        "bgcolor[" .. fondo .. "]"..
        fondo..
        barracolor..
        barra..  
        icono..
        base_calculadora..
        "textarea[10,5;6,2;mostrar;;".. numero1 - numero2 .."]"
        minetest.show_formspec(player:get_player_name(), "calculadora", formspec)

        elseif fields.multiplicar then
        local  formspec = "size[" .. x .. "," .. y .. ",true]" ..
        "bgcolor[" .. fondo .. "]"..
        barracolor..
        barra..  
        icono..
        base_calculadora..
        "textarea[10,5;6,2;mostrar;;".. numero1 * numero2 .."]"
        minetest.show_formspec(player:get_player_name(), "calculadora", formspec)

        elseif fields.dividir then
        local  formspec = "size[" .. x .. "," .. y .. ",true]" ..
        "bgcolor[" .. fondo .. "]"..
        barracolor..
        barra..  
        icono..
        base_calculadora..
        "textarea[10,5;6,2;mostrar;;".. numero1 / numero2 .."]"
        minetest.show_formspec(player:get_player_name(), "calculadora", formspec)

        elseif fields.raiz then
        local  formspec = "size[" .. x .. "," .. y .. ",true]" ..
        "bgcolor[" .. fondo .. "]"..
        barracolor..
        barra..  
        icono..
        base_calculadora..
        "textarea[10,5;6,2;mostrar;;".. math.sqrt(numero1) .."]"
        minetest.show_formspec(player:get_player_name(), "calculadora", formspec)

        elseif fields.seno then
        local  formspec = "size[" .. x .. "," .. y .. ",true]" ..
        "bgcolor[" .. fondo .. "]"..
        barracolor..
        barra..  
        icono..
        base_calculadora..
        "textarea[10,5;6,2;mostrar;;".. math.sin(numero1) .." radianes]"
        minetest.show_formspec(player:get_player_name(), "calculadora", formspec)

        elseif fields.coseno then
        local  formspec = "size[" .. x .. "," .. y .. ",true]" ..
        "bgcolor[" .. fondo .. "]"..
        barracolor..
        barra..  
        icono..
        base_calculadora..
        "textarea[10,5;6,2;mostrar;;".. math.cos(numero1) .." radianes]"
        minetest.show_formspec(player:get_player_name(), "calculadora", formspec)

        elseif fields.tangente then
        local  formspec = "size[" .. x .. "," .. y .. ",true]" ..
        "bgcolor[" .. fondo .. "]"..
        barracolor..
        barra..  
        icono..
        base_calculadora..
        "textarea[10,5;6,2;mostrar;;".. math.tan(numero1) .." radianes]"
        minetest.show_formspec(player:get_player_name(), "calculadora", formspec)

        elseif fields.log then
        local  formspec = "size[" .. x .. "," .. y .. ",true]" ..
        "bgcolor[" .. fondo .. "]"..
        barracolor..
        barra..  
        icono..
        base_calculadora..
        "textarea[10,5;6,2;mostrar;;".. math.log(numero1) .." radianes]"
        minetest.show_formspec(player:get_player_name(), "calculadora", formspec)

        elseif fields.exp then
        local  formspec = "size[" .. x .. "," .. y .. ",true]" ..
        "bgcolor[" .. fondo .. "]"..
        barracolor..
        barra..  
        icono..
        base_calculadora..
        "textarea[10,5;6,2;mostrar;;".. math.exp(numero1) .." radianes]"
        minetest.show_formspec(player:get_player_name(), "calculadora", formspec)

        elseif fields.log10 then
        local  formspec = "size[" .. x .. "," .. y .. ",true]" ..
        "bgcolor[" .. fondo .. "]"..
        barracolor..
        barra..  
        icono..
        base_calculadora..
        "textarea[10,5;6,2;mostrar;;".. math.log10(numero1) .." radianes]"
        minetest.show_formspec(player:get_player_name(), "calculadora", formspec)
        end
        if fields.volver_in then
        timer_active = true
        iniciar_temporizador(player)
        minetest.show_formspec(player:get_player_name(), "inicio", inicio(player:get_player_name()))
        end
    end
end)
