#!/usr/bin/env python3
from i3ipc import Connection


def focus_first(i3, node) -> None:
    if node.type != 'workspace':
        while len(node.focus) > 1:
            node = i3.get_tree().find_by_id(node.focus[0])

        i3.command(f'[con_id={node.id}] focus')


def focus_next(focused=None) -> None:
    i3 = Connection()

    if focused is None:
        focused = i3.get_tree().find_focused()

    if focused.type != 'workspace':
        if len(focused.parent.nodes) > 1:
            parent_nodes = [node.id for node in focused.parent.nodes]
            parent_nodes_length = len(parent_nodes)
            position = parent_nodes.index(focused.id)

            if parent_nodes_length > 1:
                if position < parent_nodes_length - 1:
                    i3.command(f'[con_id={parent_nodes[position + 1]}] focus')
                else:
                    if len(focused.nodes) > 1:
                        focus_first(i3, focused)
                    else:
                        focus_first(i3, i3.get_tree().find_by_id(parent_nodes[0]))
            else:
                i3.command('focus parent')
                focus_next()
        else:
            focus_next(focused.parent)


if __name__ == '__main__':
    focus_next()
