conky.config = {
  xinerama_head = 1,
  update_interval = 1,
  double_buffer = true,
  no_buffers = true,
  imlib_cache_size = 10,
  own_window = true,
  own_window_class = 'Conky',
  own_window_transparent = true,
  own_window_argb_visual = false,
  own_window_argb_value = 100,
  own_window_colour = '000000',
  own_window_type = 'override',
  draw_shades = false,
  override_utf8_locale = true,
  use_xft = true,
  uppercase = false,
  minimum_width = 210,
  alignment = 'top_right',
  gap_x = 22,
  gap_y = 22
};

conky.text = [[
${voffset 0}${offset 0}${font Noto:size=34}${color white}${time %e}
${goto 20}${font Noto:size=18}${color white}${voffset -16}${time %b}${color white}${offset 10}${time %Y}
${font Noto:size=12}${color white}${voffset 5}\
${goto 20}${time %A}${goto 153}${color white}${time %H}:${time %M}
]];
