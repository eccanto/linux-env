conky.config = {
    xinerama_head = 1,
    alignment = 'bottom_right',
    background = false,
    border_width = 20,
    cpu_avg_samples = 2,
    default_color = 'white',
    default_outline_color = 'black',
    default_shade_color = 'black',
    double_buffer = true,
    draw_borders = false,
    draw_graph_borders = true,
    draw_outline = false,
    draw_shades = false,
    extra_newline = false,
    font = 'DejaVu Sans Mono:size=11',
    gap_x = 38,
    gap_y = 16,
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
    own_window_argb_visual = false,
    own_window_argb_value = 255,
    own_window_colour = '000000',
    double_buffer = true,
    update_interval = 2.0,
    xftalpha = 1,
}

conky.text = [[
${voffset 4}
${color #00FFFF}$nodename
$hr
${color #00FF00}Kernel:$color $kernel
${color #00FF00}Machine:$color $machine
$hr
${color #FF00FF}Uptime:$color $uptime
${color #FF00FF}Frequency (in MHz):$color $freq
${color #FF00FF}Frequency (in GHz):$color $freq_g
${color #FF00FF}RAM Usage:$color $mem/$memmax - $memperc% ${membar 4}
${color #FF00FF}Swap Usage:$color $swap/$swapmax - $swapperc% ${swapbar 4}
${color #FF00FF}CPU Usage:$color $cpu% ${cpubar 4}
${color #FF00FF}CPU temperature:$color ${hwmon 4 temp 1}°C
${color #FF00FF}Processes:$color $processes  ${color #FF00FF}Running:$color $running_processes
$hr
${color #FF9122}File systems:
 / $color${fs_used /}/${fs_size /} ${fs_bar 6 /}
$hr
${color #FFF000}Name              PID     CPU%   MEM%
${color lightgrey}${top name 1}${top pid 1} ${top cpu 1} ${top mem 1}
${color lightgrey}${top name 2}${top pid 2} ${top cpu 2} ${top mem 2}
${color lightgrey}${top name 3}${top pid 3} ${top cpu 3} ${top mem 3}
${color lightgrey}${top name 4}${top pid 4} ${top cpu 4} ${top mem 4}
${color lightgrey}${top name 5}${top pid 5} ${top cpu 5} ${top mem 5}
${color lightgrey}${top name 6}${top pid 6} ${top cpu 6} ${top mem 6}
${color lightgrey}${top name 7}${top pid 7} ${top cpu 7} ${top mem 7}
${color lightgrey}${top name 8}${top pid 8} ${top cpu 8} ${top mem 8}
$hr
${voffset 4}
]]
