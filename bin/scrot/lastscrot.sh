#!/bin/bash

ls ~/*scrot.png || exit

DIR=$HOME
scrot=$(ls -rt $DIR/*scrot.png | tail -n1)

ans=$(cat ~/bin/scrot/actions.lst | zenity \
    --title="Screenshot $scrot" \
    --text="Action ?" \
    --width=800 \
    --height=600 \
    --list \
    --ok-label="Exécuter" \
    --cancel-label="Annuler" \
    --column=Action \
    --column=Description \
    --print-column=1 \
)

case $ans in
    move )
        if newname=$(zenity \
            --title="Nouvel emplacement" \
            --width=800 \
            --height=600 \
            --file-selection \
            --save \
            --confirm-overwrite
        ); then
            echo $newname | xclip -i -selection clipboard
            mv -v "$scrot" "$newname"
        else
            echo "Abandon"
        fi
        ;;
    voir )
        display $scrot
        ;;
    gimp )
        gimp $scrot
        ;;
    copypath )
        echo $scrot | xclip -i -selection clipboard
        ;;
    mail )
        icedove -compose "attachment=file://$scrot"
        ;;
    remove )
        rm "$scrot"
        ;;
esac
