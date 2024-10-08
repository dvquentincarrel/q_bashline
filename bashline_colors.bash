#!/bin/bash
# setups colors for bashline. Only run once at shell init

# enclosed in \[ ... \] to tell bash not to count them in the total length of the prompt
C_STP="\[\e[0m\]" # Stop

C_EXT_F="\[\e[37m\]" # Return/Exit code | white / black
C_STP_F="\[\e[38;5;202m\]" # Stopped jobs | Orange

C_NNN_F="\[\e[38;5;163m\]" # nnn | purple

C_PY_F="\[\e[93m\]" # python | bright yellow

C_HIST_F="\[\e[31m\]" # hist | red

C_CWD_F="\\\[\x1b[38;5;39m\\\]" # Current Working Directory | blue
C_DMK_F="\\\[\x1b[38;5;101m\\\]" # Dir marker " / " | pale green

C_BRA_F="\[\e[38;5;214m\]" # Git Branch    | yellow
C_TAG_F="\[\e[38;5;205m\]" # Git Tag       | pale pink
C_DET_F="\[\e[38;5;202m\]" # Detached Head | dark orange
C_BAR_F="\[\e[38;5;202m\]" # Bare repo     | dark orange

C_SBR_F="\[\e[37m\]" # git status square brackets | white / black

C_STA="\[\e[38;5;40m\]" # Staged | green
C_UNS="\[\e[38;5;166m\]" # Unstaged | orange
C_UNT="\[\e[38;5;197m\]" # Untracked | red
C_UNM="\[\e[38;5;213m\]" # Unmered | pink
C_TSH="\[\e[38;5;242m\]"

C_AHD="\[\e[38;5;14m\]" # Ahead | Cyan
C_BHD="\[\e[38;5;13m\]" # Behind | Magenta

C_GEN_B="\[\e[48;5;234m\]" # General background color | black
C_GEN_F="\[\e[97m\]" # General foreground color | white
C_GEN_T="\[\e[0;38;5;234m\]" # General background transition
