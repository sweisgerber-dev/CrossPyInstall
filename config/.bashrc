echo ""
echo "-----------------------------------------"
echo "Welcome to CrossPyInstall (a python pyinstall environment"
echo "-----------------------------------------"
echo ""
echo "- User $(whoami) [$(id -u $USER)] | Group: $(id -g -n) [$(id -g)]"
echo "- HOME:                ${HOME}"
echo "- WORKDIR:             ${WORKDIR}"

if [ -f ${VIRTUALENV_PATH_EXTERNAL}/bin/activate ]; then
    source ${VIRTUALENV_PATH_EXTERNAL}/bin/activate
    echo "- Python Environment:  ${VIRTUALENV_PATH_EXTERNAL}"
else
    source ${VIRTUALENV_PATH}/bin/activate
    echo "- Python Environment:  ${VIRTUALENV_PATH} (Using Default '${VIRTUALENV_PATH_EXTERNAL}' is empty)"
fi

echo ""
