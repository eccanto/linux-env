import logging
import os
from enum import Enum
from pathlib import Path
import pwd


class PermissionManager:
    class User(Enum):
        NORMAL = pwd.getpwnam(os.getlogin()).pw_uid
        ROOT = pwd.getpwnam('root').pw_uid

    def __init__(self, user: User) -> None:
        self.user_euid = user.value

        self.previous_user_euid = os.geteuid()

    def __enter__(self) -> 'PermissionManager':
        os.environ['HOME'] = str(Path(f'~{pwd.getpwuid(self.user_euid).pw_name}').expanduser())
        os.seteuid(self.user_euid)
        return self

    def __exit__(self, *_) -> None:
        os.environ['HOME'] = str(Path(f'~{pwd.getpwuid(self.previous_user_euid).pw_name}').expanduser())
        os.seteuid(self.previous_user_euid)

    @classmethod
    def is_root(cls):
        return os.geteuid() == cls.User.ROOT.value

    @classmethod
    def run_as_root_if_failed(cls):
        def inner(func):
            def wrapper(*args, **kwargs):
                try:
                    func(*args, **kwargs)
                except PermissionError:
                    if not cls.is_root():
                        logging.info('trying as root...')

                        with cls(user=cls.User.ROOT):
                            func(*args, **kwargs)
                    else:
                        raise

            return wrapper
        return inner
