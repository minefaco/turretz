-- Registra el nodo
minetest.register_node("turretz:detector", {
    description = "Detector de entidades",
    tiles = {"detector.png"},
})

-- Registra el proyectil
minetest.register_entity("turretz:bullet", {
    physical = false,
    visual = "sprite",
    textures = {"bullet.png"},
    on_step = function(self, dtime)
        self.object:remove()
        for _, obj in ipairs(minetest.get_objects_inside_radius(self.object:get_pos(), 1)) do
            if obj:is_player() or (obj:get_luaentity() and obj:get_luaentity().name ~= "turretz:bullet") then
                -- Aquí es donde se aplica el daño
                obj:punch(self.object, 1.0, {
                    full_punch_interval = 1.0,
                    damage_groups = {fleshy = 5},
                }, nil)
            end
        end
    end,
})

-- Función para disparar el proyectil
local function disparar_bullet(pos)
    local bullet = minetest.add_entity(pos, "turretz:bullet")
    bullet:set_velocity({x = 0, y = 2, z = 0})
end

-- Función para detectar entidades y jugadores
local function detectar(pos, radio)
    for _, obj in ipairs(minetest.get_objects_inside_radius(pos, radio)) do
        if obj:is_player() or obj:get_luaentity() then
            disparar_bullet(pos)
            break
        end
    end
end

-- Llama a la función de detección cada segundo
local timer = 0
minetest.register_globalstep(function(dtime)
    timer = timer + dtime
    if timer >= 1 then
        timer = 0
        for _, pos in ipairs(minetest.find_nodes_in_area({x = -31000, y = -31000, z = -31000}, {x = 31000, y = 31000, z = 31000}, {"turretz:detector"})) do
            detectar(pos, 10)  -- Cambia el 10 a cualquier radio que desees
        end
    end
end)
