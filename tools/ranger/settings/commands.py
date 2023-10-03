import os
import subprocess  # nosec B404
from pathlib import Path

from ranger.api.commands import Command


class FzfCommand(Command):
    """Find a file using fzf."""

    name = 'fzf'

    def execute(self):
        fzf = self.fm.execute_command('source ~/.zshrc && fzf', universal_newlines=True, stdout=subprocess.PIPE)
        stdout, _ = fzf.communicate()
        if fzf.returncode == 0:
            fzf_file = os.path.abspath(stdout.rstrip('\n'))
            self.fm.select_file(fzf_file)


class OpenCommand(Command):
    """Open a file/folder."""

    name = 'open'

    def execute(self):
        if self.arg(1):
            target_filename = self.rest(1)
        else:
            target_filename = self.fm.thisfile.path

        subprocess.run(  # nosec
            ['bash', Path('~/.config/ranger/scripts/open_path.sh').expanduser(), target_filename], check=False
        )
        self.fm.exit()
