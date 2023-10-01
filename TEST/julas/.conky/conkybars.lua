require 'cairo'

-- Uso andylangton.co.uk/tools/colour-converter per convertire un colore hex nei valori decimali
settings_table = {

    {
        name        =   'fs_free_perc',
        arg         =   '/',
        max         =   100,
        width       =   3,
        height      =   769,
        x           =   22,
        y           =   0,
        fillRed     =   0.48,
        fillGreen   =   0.48,
        fillBlue    =   0.48,
        alpha       =   1
    },
    {
        name        =   'memperc',
        arg         =   '',
        max         =   100,
        width       =   3,
        height      =   769,
        x           =   18,
        y           =   0,
        fillRed     =   1,
        fillGreen   =   0.2,
        fillBlue    =   0.0,
        alpha       =   1
    },
    {
        name        =   'cpu',
        arg         =   'cpu0',
        max         =   100,
        width       =   3,
        height      =   769,
        x           =   12,
        y           =   0,
        fillRed     =   1,
        fillGreen   =   0.80,
        fillBlue    =   0.07,
        alpha       =   1
    },
    {
        name        =   'cpu',
        arg         =   'cpu1',
        max         =   100,
        width       =   3,
        height      =   769,
        x           =   8,
        y           =   0,
        fillRed     =   0.75,
        fillGreen   =   0.24,
        fillBlue    =   1,
        alpha       =   1
    },
    {
        name        =   'cpu',
        arg         =   'cpu2',
        max         =   100,
        width       =   3,
        height      =   769,
        x           =   4,
        y           =   0,
        fillRed     =   0.29,
        fillGreen   =   0.62,
        fillBlue    =   0.97,
        alpha       =   1
    },
    {
        name        =   'cpu',
        arg         =   'cpu3',
        max         =   100,
        width       =   3,
        height      =   769,
        x           =   0,
        y           =   0,
        fillRed     =   0.27,
        fillGreen   =   0.55,
        fillBlue    =   0,
        alpha       =   1
    }

    {
        name        =   'cpu',
        arg         =   'cpu4',
        max         =   100,
        width       =   3,
        height      =   769,
        x           =   0,
        y           =   0,
        fillRed     =   0.27,
        fillGreen   =   0.55,
        fillBlue    =   0,
        alpha       =   1
    }

    {
        name        =   'cpu',
        arg         =   'cpu5',
        max         =   100,
        width       =   3,
        height      =   769,
        x           =   0,
        y           =   0,
        fillRed     =   0.27,
        fillGreen   =   0.55,
        fillBlue    =   0,
        alpha       =   1
    }

    {
        name        =   'cpu',
        arg         =   'cpu6',
        max         =   100,
        width       =   3,
        height      =   769,
        x           =   0,
        y           =   0,
        fillRed     =   0.27,
        fillGreen   =   0.55,
        fillBlue    =   0,
        alpha       =   1
    }

    {
        name        =   'cpu',
        arg         =   'cpu7',
        max         =   100,
        width       =   3,
        height      =   769,
        x           =   0,
        y           =   0,
        fillRed     =   0.27,
        fillGreen   =   0.55,
        fillBlue    =   0,
        alpha       =   1
    }

    {
        name        =   'cpu',
        arg         =   'cpu8',
        max         =   100,
        width       =   3,
        height      =   769,
        x           =   0,
        y           =   0,
        fillRed     =   0.27,
        fillGreen   =   0.55,
        fillBlue    =   0,
        alpha       =   1
    }

    {
        name        =   'cpu',
        arg         =   'cpu9',
        max         =   100,
        width       =   3,
        height      =   769,
        x           =   0,
        y           =   0,
        fillRed     =   0.27,
        fillGreen   =   0.55,
        fillBlue    =   0,
        alpha       =   1
    }

    {
        name        =   'cpu',
        arg         =   'cpu10',
        max         =   100,
        width       =   3,
        height      =   769,
        x           =   0,
        y           =   0,
        fillRed     =   0.27,
        fillGreen   =   0.55,
        fillBlue    =   0,
        alpha       =   1
    }

    {
        name        =   'cpu',
        arg         =   'cpu11',
        max         =   100,
        width       =   3,
        height      =   769,
        x           =   0,
        y           =   0,
        fillRed     =   0.27,
        fillGreen   =   0.55,
        fillBlue    =   0,
        alpha       =   1
    }

    {
        name        =   'cpu',
        arg         =   'cpu12',
        max         =   100,
        width       =   3,
        height      =   769,
        x           =   0,
        y           =   0,
        fillRed     =   0.27,
        fillGreen   =   0.55,
        fillBlue    =   0,
        alpha       =   1
    }
    {
        name        =   'cpu',
        arg         =   'cpu13',
        max         =   100,
        width       =   3,
        height      =   769,
        x           =   0,
        y           =   0,
        fillRed     =   0.27,
        fillGreen   =   0.55,
        fillBlue    =   0,
        alpha       =   1
    }
    {
        name        =   'cpu',
        arg         =   'cpu14',
        max         =   100,
        width       =   3,
        height      =   769,
        x           =   0,
        y           =   0,
        fillRed     =   0.27,
        fillGreen   =   0.55,
        fillBlue    =   0,
        alpha       =   1
    }
    {
        name        =   'cpu',
        arg         =   'cpu15',
        max         =   100,
        width       =   3,
        height      =   769,
        x           =   0,
        y           =   0,
        fillRed     =   0.27,
        fillGreen   =   0.55,
        fillBlue    =   0,
        alpha       =   1
    }
}

function draw_bar(pct, pt)
    local cs=cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, conky_window.width, conky_window.height)
    cr=cairo_create(cs)

    alpha = pt['alpha']

    if pct<1 then
        pct = 1
        alpha = 0.2
    end

    cairo_set_source_rgba(cr, pt['fillRed'], pt['fillGreen'], pt['fillBlue'], alpha)
    cairo_set_line_width (cr, pt['width'])

    -- Original code
    --cairo_move_to (cr, (pt['width'] / 2) + pt['x'], pt['height'] + pt['y'] - 1)
    --cairo_line_to (cr, (pt['width'] / 2) + pt['x'], pt['height'] - (pt['height'] * pct) + pt['y'] - 1)

    -- Barre orizzontali
    --cairo_move_to (cr, pt['x'], pt['y']+25)
    --cairo_line_to (cr, pt['x'] - (pt['x'] * (pct / 100)), pt['y']+25)

    -- Barre verticali
    cairo_move_to (cr, (pt['width'] / 2) + pt['x']+5, pt['y'])
    cairo_line_to (cr, (pt['width'] / 2) + pt['x']+5, (pt['height'] * (pct / 100)))

    cairo_stroke (cr)
    cairo_destroy(cr)
    cr = nil
end



function conky_bar_stats()
    local function setup_bars(pt)
        local str=''
        local value=0

        str=string.format('${%s %s}',pt['name'],pt['arg'])
        str=conky_parse(str)

        value=tonumber(str)
        --value=50 -- Test
        --pct=value/pt['max'] -- Il calcolo lo faccio in draw_bar
        pct=value
        draw_bar(pct,pt)
    end

    if conky_window == nil then return end
    local updates=conky_parse('${updates}')
    update_num=tonumber(updates)


    if update_num>5 then
        for i in pairs(settings_table) do
            setup_bars(settings_table[i])
        end
    end
end
