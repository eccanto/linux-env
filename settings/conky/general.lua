conky.config = {
    xinerama_head = 1,
    alignment = 'bottom_right',
    background = false,
    border_width = 1,
    cpu_avg_samples = 2,
    default_color = 'white',
    default_outline_color = 'white',
    default_shade_color = 'white',
    double_buffer = true,
    draw_borders = false,
    draw_graph_borders = true,
    draw_outline = false,
    draw_shades = false,
    extra_newline = false,
    font = 'DejaVu Sans Mono:size=11',
    gap_x = 22,
    gap_y = 22,
    minimum_height = 5,
    minimum_width = 5,
    net_avg_samples = 2,
    no_buffers = true,
    out_to_console = false,
    out_to_ncurses = false,
    out_to_stderr = false,
    out_to_x = true,
    own_window = true,
    own_window_class = 'Conky',
    own_window_type = 'override',
    show_graph_range = false,
    show_graph_scale = false,
    stippled_borders = 0,
    update_interval = 1.0,
    uppercase = false,
    use_spacer = 'none',
    use_xft = true,
    own_window_transparent = false,
    own_window_argb_visual = true,
    own_window_argb_value = 100,
    own_window_colour = '#000000',
    double_buffer = true,
    update_interval = 2.0,
}

conky.text = [[
${color #BFD7FF}$nodename
$hr
${color #29CEFF}Kernel:$color $kernel
${color #29CEFF}Machine:$color $machine
$hr
${color #F489FF}Uptime:$color $uptime
${color #F489FF}Frequency (in MHz):$color $freq
${color #F489FF}Frequency (in GHz):$color $freq_g
${color #F489FF}RAM Usage:$color $mem/$memmax - $memperc% ${membar 4}
${color #F489FF}Swap Usage:$color $swap/$swapmax - $swapperc% ${swapbar 4}
${color #F489FF}CPU Usage:$color $cpu% ${cpubar 4}
${color #F489FF}CPU temperature:$color ${hwmon 4 temp 1}°C
${color #F489FF}Processes:$color $processes  ${color #F489FF}Running:$color $running_processes
$hr
${color #FF8000}File systems:
 / $color${fs_used /}/${fs_size /} ${fs_bar 6 /}
$hr
${color #FFF000}Name              PID     CPU%   MEM%
${color lightgrey}${top name 1}${top pid 1} ${top cpu 1} ${top mem 1}
${color lightgrey}${top name 2}${top pid 2} ${top cpu 2} ${top mem 2}
${color lightgrey}${top name 3}${top pid 3} ${top cpu 3} ${top mem 3}
${color lightgrey}${top name 4}${top pid 4} ${top cpu 4} ${top mem 4}
${color lightgrey}${top name 5}${top pid 5} ${top cpu 5} ${top mem 5}
${color lightgrey}${top name 6}${top pid 6} ${top cpu 6} ${top mem 6}
]]
