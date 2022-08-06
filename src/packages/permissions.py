import os
from enum import Enum
from pwd import getpwnam


class PermissionManager:
    class User(Enum):
        NORMAL = getpwnam(os.getlogin()).pw_uid
        ROOT = getpwnam('root').pw_uid

    def __init__(self, user: User) -> None:
        self.user_euid = user.value

        self.previous_user_euid = os.geteuid()

    def __enter__(self) -> 'PermissionManager':
        os.seteuid(self.user_euid)
        return self

    def __exit__(self, *_) -> None:
        os.seteuid(self.previous_user_euid)

    def is_root(cls):
        return os.geteuid() == cls.User.ROOT.value
