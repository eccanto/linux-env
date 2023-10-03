#!/usr/bin/env python3

import argparse
import sys
from enum import Enum

from i3ipc import Connection
from i3ipc.con import Con


class Mode(Enum):
    TAB = 'tab'
    GROUP = 'group'

    def __eq__(self, other: object) -> bool:
        return (other == self.value) if isinstance(other, str) else super().__eq__(other)


class I3Workspaces:
    def __init__(self) -> None:
        self.i3_connection = Connection()

    def focus_first(self, node: Con) -> None:
        if node.type != 'workspace':
            while node.focus:
                node = self.i3_connection.get_tree().find_by_id(node.focus[0])

            self.i3_connection.command(f'[con_id={node.id}] focus')

    def focus_next_tab(self, focused: Con = None) -> None:
        if focused is None:
            focused = self.i3_connection.get_tree().find_focused()

        if focused.type != 'workspace':
            if len(focused.parent.nodes) > 1:
                parent_nodes = [node.id for node in focused.parent.nodes]
                parent_nodes_length = len(parent_nodes)
                position = parent_nodes.index(focused.id)

                if parent_nodes_length > 1:
                    if position < parent_nodes_length - 1:
                        self.focus_first(self.i3_connection.get_tree().find_by_id(parent_nodes[position + 1]))
                    else:
                        if len(focused.nodes) > 1:
                            self.focus_first(focused)
                        else:
                            self.focus_first(self.i3_connection.get_tree().find_by_id(parent_nodes[0]))
                else:
                    self.i3_connection.command('focus parent')
                    self.focus_next_tab()
            else:
                self.focus_next_tab(focused.parent)

    def focus_next_group(self, focused: Con = None) -> None:
        if focused is None:
            focused = self.i3_connection.get_tree().find_focused()

        while (
            focused.parent and focused.parent.type != 'workspace' and focused.parent.layout not in ('splith', 'splitv')
        ):
            focused = focused.parent

        if focused.parent.nodes:
            parent_nodes = [node.id for node in focused.parent.nodes]
            parent_nodes_length = len(parent_nodes)
            position = parent_nodes.index(focused.id)

            if position < parent_nodes_length - 1:
                self.focus_first(self.i3_connection.get_tree().find_by_id(parent_nodes[position + 1]))
            else:
                self.focus_first(self.i3_connection.get_tree().find_by_id(parent_nodes[0]))


if __name__ == '__main__':
    argument_parser = argparse.ArgumentParser()
    argument_parser.add_argument('--mode', choices=[enum.value for enum in Mode], required=True)

    arguments = argument_parser.parse_args(sys.argv[1:])

    i3 = I3Workspaces()
    if arguments.mode == Mode.TAB:
        i3.focus_next_tab()
    elif arguments.mode == Mode.GROUP:
        i3.focus_next_group()
