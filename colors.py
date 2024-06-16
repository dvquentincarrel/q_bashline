class Colors:
    """Colors to be used for different components of the statusline"""
    start_marker = r"\["
    end_marker = r"\]"

    background = "48;5;234" # Black
    foreground = "97" # White
    transition = "0;38;5;234" # General background transition
    stop = "0"

    exit_code = "37" # White
    time = "37" # White

    nnn = "38;5;163" # Depth of NNN, purple

    # Path
    cwd = "38;5;39" # Blue
    dir = "38;5;101" # directory marker in path, pale green

    # Git
    git_branch = "38;5;214" # Branch, yellow
    git_tag = "38;5;205" # Tag, pale pink
    git_detached = "38;5;202" # Detached Head, dark orange
    git_bare = "38;5;202" # Bare repo, dark orange
    git_staged = "38;5;40" # Staged, green
    git_unstaged = "38;5;166" # Unstaged, orange
    git_untracked = "38;5;197" # Untracked, red
    git_unmerged = "38;5;213" # Unmerged, pink
    git_stash = "38;5;242" # Stashed, grey
    git_ahead = "38;5;14" # Ahead, cyan
    git_behind = "38;5;13" # Behind, magenta

    def get(name: str) -> str:
        """Wraps the color's description in all the necessary symbols and
        thingmabobs to become an ansi escape code, and be properly processed
        by bash

        :param name: name of a color in the Color instance attributes
        :return: The color, ready to be put in a statusline
        """
        return str(
            Colors.start_marker
            + "\x1b["
            + getattr(Colors,name)
            + "m"
            + Colors.end_marker)

class Symbols:
    """Symbols used throughout the statusline"""
    separator = "▕ "
    start = ""
    end = ""
    git_stash = "s"
    git_staged = "+"
    git_unstaged = "!"
    git_untracked = "?"
    git_unmerged = "#"
    git_ahead = "↑"
    git_behind = "↓"
