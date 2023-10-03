"""Ranger theme."""

from __future__ import absolute_import, division, print_function

from typing import Any, Tuple

from ranger.gui.color import (
    BRIGHT,
    black,
    blue,
    bold,
    cyan,
    default,
    dim,
    green,
    magenta,
    normal,
    red,
    reverse,
    white,
    yellow,
)
from ranger.gui.colorscheme import ColorScheme


class Dark(ColorScheme):
    """Ranger class theme."""

    progress_bar_color = blue

    DIRECTORY_COLOR = 60
    FOREGROUND_COLOR = white
    EXECUTABLE_COLOR = 62
    TITLEBAR_GOOD_COLOR = 62 + BRIGHT

    def use(self, context: Any) -> Tuple[int, int, int]:  # noqa: MC0001
        foreground, background, attribute = (self.FOREGROUND_COLOR, default, normal)

        if context.reset:
            return (self.FOREGROUND_COLOR, black, normal)

        if context.in_browser:
            if context.selected:
                attribute = reverse
            else:
                attribute = normal
            if context.empty or context.error:
                background = red
            if context.border:
                foreground = default
            if context.media:
                if context.image:
                    foreground = yellow
                else:
                    foreground = magenta
            if context.container:
                foreground = red
            if context.directory:
                attribute |= bold
                foreground = self.DIRECTORY_COLOR
                foreground += BRIGHT
            elif context.executable and not any((context.media, context.container, context.fifo, context.socket)):
                attribute |= bold
                foreground = self.EXECUTABLE_COLOR
                foreground += BRIGHT
            if context.socket:
                attribute |= bold
                foreground = magenta
                foreground += BRIGHT
            if context.fifo or context.device:
                foreground = yellow
                if context.device:
                    attribute |= bold
                    foreground += BRIGHT
            if context.link:
                foreground = cyan if context.good else magenta
            if context.tag_marker and not context.selected:
                attribute |= bold
                if foreground in (red, magenta):
                    foreground = white
                else:
                    foreground = red
                foreground += BRIGHT
            if not context.selected and (context.cut or context.copied):
                attribute |= bold
                foreground = black
                foreground += BRIGHT
                # If the terminal doesn't support bright colors, use dim white
                # instead of black.
                if BRIGHT == 0:
                    attribute |= dim
                    foreground = white
            if context.main_column:
                # Doubling up with BRIGHT here causes issues because it's
                # additive not idempotent.
                if context.selected:
                    attribute |= bold
                if context.marked:
                    attribute |= bold
                    foreground = yellow
            if context.badinfo:
                if attribute & reverse:
                    background = magenta
                else:
                    foreground = magenta

            if context.inactive_pane:
                foreground = cyan

        elif context.in_titlebar:
            if context.hostname:
                foreground = red if context.bad else self.TITLEBAR_GOOD_COLOR
            elif context.directory:
                foreground = self.DIRECTORY_COLOR
                foreground += BRIGHT
            elif context.tab:
                if context.good:
                    background = green
            elif context.link:
                foreground = cyan
            attribute |= bold

        elif context.in_statusbar:
            if context.permissions:
                if context.good:
                    foreground = cyan
                elif context.bad:
                    foreground = magenta
            if context.marked:
                attribute |= bold | reverse
                foreground = yellow
                foreground += BRIGHT
            if context.frozen:
                attribute |= bold | reverse
                foreground = cyan
                foreground += BRIGHT
            if context.message:
                if context.bad:
                    attribute |= bold
                    foreground = red
                    foreground += BRIGHT
            if context.loaded:
                background = self.progress_bar_color
            if context.vcsinfo:
                foreground = blue
                attribute &= ~bold
            if context.vcscommit:
                foreground = yellow
                attribute &= ~bold
            if context.vcsdate:
                foreground = cyan
                attribute &= ~bold

        if context.text:
            if context.highlight:
                attribute |= reverse

        if context.in_taskview:
            if context.title:
                foreground = blue

            if context.selected:
                attribute |= reverse

            if context.loaded:
                if context.selected:
                    foreground = self.progress_bar_color
                else:
                    background = self.progress_bar_color

        if context.vcsfile and not context.selected:
            attribute &= ~bold
            if context.vcsconflict:
                foreground = magenta
            elif context.vcsuntracked:
                foreground = cyan
            elif context.vcschanged:
                foreground = red
            elif context.vcsunknown:
                foreground = red
            elif context.vcsstaged:
                foreground = green
            elif context.vcssync:
                foreground = green
            elif context.vcsignored:
                foreground = default

        elif context.vcsremote and not context.selected:
            attribute &= ~bold
            if context.vcssync or context.vcsnone:
                foreground = green
            elif context.vcsbehind:
                foreground = red
            elif context.vcsahead:
                foreground = blue
            elif context.vcsdiverged:
                foreground = magenta
            elif context.vcsunknown:
                foreground = red

        return foreground, background, attribute
