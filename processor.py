import re
import time
import subprocess
from colors import *
from dataclasses import dataclass

# num, upper, lower
BASE62_TABLE = [chr(i) for i in range(48, 58)]
BASE62_TABLE.extend([chr(i) for i in range(65, 91)])
BASE62_TABLE.extend([chr(i) for i in range(97, 123)])

STAGED_RE = re.compile(r'^ .|^MM', flags=re.MULTILINE)
UNSTAGED_RE = re.compile(r'^. |^MM', flags=re.MULTILINE)
UNTRACKED_RE = re.compile(r'^\?\?', flags=re.MULTILINE)
UNMERGED_RE = re.compile(r'^D[DU]|U[ADU]|A[AU]', flags=re.MULTILINE)

@dataclass
class GitWidgets:
    branch: bool = True
    stash: bool = True
    status: bool = True
    commits: bool = True
    async_: float = False

debug = False
def ptime(msg, width=10):
    """Used to get profiling information"""
    global debug
    if not debug:
        return None

    global prev
    print(f"{msg.ljust(width)}: {time.time() - prev:.4}")
    prev = time.time()

class Processor:
    def exit_code(code) -> str:
        return Colors.get('exit_code') + str(code)

    def time():
        """Returns HH:MM:SS time in base 52"""
        return (Colors.get('time')
            + BASE62_TABLE[int(time.strftime('%H'))]
            + BASE62_TABLE[int(time.strftime('%M'))]
            + BASE62_TABLE[int(time.strftime('%S'))]
        )

    def nnn(depth) -> str:
        return "{}n{}".format(Colors.get('nnn'), depth)

    def cwd(path: str) -> str:
        """Returns given path, with dir separators colored differently"""
        path = (path
                .replace(os.getenv('HOME'), '~')
                .replace('/', f"{Colors.get('dir')}/{Colors.get('cwd')}"))
        return f"{Colors.get('cwd')}{path}"

    def git(path: str, widgets: GitWidgets) -> list[str]:
        """Returns a list of the enabled git widgets"""
        is_bare = subprocess.run(['git', 'rev-parse', '--is-bare-repository'], text=True, capture_output=True)
        if is_bare.returncode:  # not a repo
            return [""]
        elif is_bare.stdout.strip() == "true":
            return [f"{Colors.get('git_bare')}BARE"]
        ptime('g bare')

        if widgets.status:
            if widgets.async_:
                status = Processor.git_status(path)
            else:
                status = Processor.git_status(path)
            ptime('g status')

        if widgets.branch:
            branch = Processor.git_branch(path)
            ptime('g branch')
        if widgets.stash:
            stash = Processor.git_stash(path)
            ptime('g stash')
        if widgets.commits:
            commits = Processor.git_commit(path)
            ptime('g commits')
        return filter(None, [branch, stash, status, commits])


    def git_branch(path) -> str:
        """Return either: the tag, the branch, or the abbreviated sha-1"""
        current_sha = subprocess.run(['git', 'rev-parse', '--short', 'HEAD'], text=True, capture_output=True).stdout
        tag = subprocess.run(['git', 'tag', '--points-at', current_sha], text=True, capture_output=True).stdout
        if tag:
            return  f"{Colors.get('git_tag')}{tag.strip()}"

        branch = subprocess.run(['git', 'branch', '--show-current'], text=True, capture_output=True).stdout
        if branch:
            return f"{Colors.get('git_branch')}{branch.strip()}"
        else:
            return f"{Colors.get('git_detached')}{current_sha.strip()}"

    def git_status(path) -> str:
        """Returns the number of staged, unstaged, untracked and unmerged
        files if there are any. Returns nothing otherwise"""
        status = subprocess.run(['git', 'status', '--porcelain=v1'], text=True, capture_output=True).stdout.strip()
        if not status:
            return ""

        counters = {
            'staged': len(STAGED_RE.findall(status)),
            'unstaged': len(UNSTAGED_RE.findall(status)),
            'untracked': len(UNTRACKED_RE.findall(status)),
            'unmerged': len(UNMERGED_RE.findall(status)),
        }
        output = (
            f"{Colors.get('git_staged')}{counters['staged']}{Symbols.git_staged}"
            f"{Colors.get('git_unstaged')}{counters['unstaged']}{Symbols.git_unstaged}"
            f"{Colors.get('git_untracked')}{counters['untracked']}{Symbols.git_untracked}")
        if counters['unmerged']:
            output += f"{Colors.get('git_unmerged')}{counters['unmerged']}{Symbols.git_unmerged}"

        return output

    def git_stash(path) -> str:
        """Returns number of entries in the stash"""
        stash = subprocess.run(['git', 'stash', 'list'], text=True, capture_output=True).stdout.strip()
        if not stash:
            return ""

        return "{}{}{}".format(
            Colors.get('git_stash'),
            Symbols.git_stash,
            stash.count('\n') + 1)

    def git_commit(path) -> str:
        """Returns how many commits ahead and behind the branch is
        compared to its remote
        """
        commits = subprocess.run(['git', 'rev-list', '--left-right', '--count', 'HEAD@{u}...HEAD'], text=True, capture_output=True)
        if commits.returncode:
            return ""

        behind, ahead = commits.stdout.strip().split('\t')
        if behind != '0':
            behind = "{}{}{}".format(
                Colors.get('git_behind'),
                behind,
                Symbols.git_behind)
        else:
            behind = ""

        if ahead != '0':
            ahead = "{}{}{}".format(
                Colors.get('git_ahead'),
                ahead,
                Symbols.git_ahead)
        else:
            ahead = ""

        return f"{behind}{ahead}"

    def format(components: list[str]) -> str:
        """Formats the components into the final string"""
        joined = f"{Colors.get('foreground')}{Symbols.separator}".join(components)
        return ''.join([
            Colors.get('transition'),
            Symbols.start,
            Colors.get('background'),
            joined,
            Colors.get('transition'),
            Symbols.end,
            Colors.get('stop'),
            " ",
        ])

if __name__ == '__main__':
    # Test it out
    import os
    debug = True
    Colors.start_marker = ""
    Colors.end_marker = ""
    gitwidgets = GitWidgets()
    cwd = os.getcwd()
    elems = []
    prev = time.time()
    elems.append(Processor.exit_code(15))
    ptime('exit')
    elems.append(Processor.time())
    ptime('time')
    elems.append(Processor.nnn(2))
    ptime('nnn')
    elems.append(Processor.cwd(cwd))
    ptime('cwd')
    elems.extend(Processor.git(cwd, gitwidgets))
    print()
    print(Processor.format(elems))
    print()
