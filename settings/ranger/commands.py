import os
import subprocess

from ranger.api.commands import Command


class my_edit(Command):
    """:my_edit <filename>

    A sample command for demonstration purposes that opens a file in an editor.
    """

    def execute(self):
        """The execute method is called when you run this command in ranger."""
        if self.arg(1):
            target_filename = self.rest(1)
        else:
            # self.fm is a ranger.core.filemanager.FileManager object and gives
            # you access to internals of ranger.
            # self.fm.thisfile is a ranger.container.file.File object and is a
            # reference to the currently selected file.
            target_filename = self.fm.thisfile.path

        self.fm.notify("Let's edit the file " + target_filename + "!")

        # Using bad=True in fm.notify allows you to print error messages:
        if not os.path.exists(target_filename):
            self.fm.notify("The given file does not exist!", bad=True)
            return

        self.fm.edit_file(target_filename)

    def tab(self, _tabnum):
        """The tab method is called when you press tab.

        This method should return a list of suggestions that the user will tab through.

        _tabnum is 1 for <TAB> and -1 for <S-TAB> by default
        """
        # This is a generic tab-completion function that iterates through the
        # content of the current directory.
        return self._tab_directory_content()


class fzf(Command):
    """Find a file using fzf.

    With a prefix argument select only directories.
    """

    def execute(self):
        fzf = self.fm.execute_command('source ~/.zshrc && fzf', universal_newlines=True, stdout=subprocess.PIPE)
        stdout, _ = fzf.communicate()
        if fzf.returncode == 0:
            fzf_file = os.path.abspath(stdout.rstrip('\n'))
            self.fm.select_file(fzf_file)


class open(Command):
    """Open a file/folder."""

    def execute(self):
        if self.arg(1):
            target_filename = self.rest(1)
        else:
            target_filename = self.fm.thisfile.path

        os.system(f'bash ~/.config/ranger/scripts/open_path.sh {target_filename}')
        self.fm.exit()
