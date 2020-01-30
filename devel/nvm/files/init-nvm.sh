[ -z "$NVM_DIR" ] && export NVM_DIR="$HOME/.nvm"
source @NVM_SHARE@/nvm.sh

# "nvm exec" and certain 3rd party scripts expect "nvm.sh" and "nvm-exec" to exist under $NVM_DIR
[ -e "$NVM_DIR" ] || mkdir -p "$NVM_DIR"
[ -e "$NVM_DIR/nvm.sh" ] || ln -s @NVM_SHARE@/nvm.sh "$NVM_DIR/nvm.sh"
[ -e "$NVM_DIR/nvm-exec" ] || ln -s @NVM_SHARE@/nvm-exec "$NVM_DIR/nvm-exec"
