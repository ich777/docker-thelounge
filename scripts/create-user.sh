#!/bin/bash
export THELOUNGE_HOME="${DATA_DIR}"
echo -e "$USERPASSWORD\n$SAVELOG\n" | thelounge add $USERNAME