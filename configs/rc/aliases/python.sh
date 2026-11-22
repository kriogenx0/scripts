# shellcheck shell=bash
# Kriogenx aliases: python

####################
# Python

alias py='python'
alias pyv='which python; python --version'
alias pyvenv='python -m venv venv'
alias pys="source venv/bin/activate; pyv"
alias pyi="python -m pip install"
alias pyir="python -m pip install -r requirements.txt"
alias pysetup="pyvenv; pys; pyi"

pyaddpackage() {
  pip install "$1" && pip freeze | grep "$1" >> requirements.txt
}
