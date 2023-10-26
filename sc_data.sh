#!/bin/bash

DB_USER=$(cat sc_vars.ini |grep DB_USER |cut -d= -f2)
DB_PASS=$(cat sc_vars.ini |grep DB_PASS |cut -d= -f2)
DB_HOST=$(cat sc_vars.ini |grep DB_HOST |cut -d= -f2)
DB_NAME=$(cat sc_vars.ini |grep DB_NAME |cut -d= -f2)
DB_COMM="mariadb -u $DB_USER -p$DB_PASS -h $DB_HOST $DB_NAME --skip-column-names -s -r -e"

cd $HOME/.git/linux/

for i in $(who | awk '{print $1}'); do
    echo $i > ~/.unknown_users
done

func_begin() {
    killall conky
    killall cava
    killall konsole
    kstart5 --window cava --alldesktops --onbottom --keepbelow --maximize-horizontally --desktopfile /FS/DATA/juliano/.git/linux/config/konsole-cava.kwinrule ~/.git/linux/sc_data.sh startcava
    sleep 2
    WIN_ID1=$(xdotool search --class "konsole" | tail -1)
    sleep 1
    xdotool windowsize $WIN_ID1 3390 300
    sleep 1
    xdotool windowmove $WIN_ID1 0 1865
    sleep 1
    xdotool windowactivate $WIN_ID1

    kstart5 --window conky --alldesktops --onbottom --keepbelow --maximize-horizontally --desktopfile /FS/DATA/juliano/.git/linux/config/konsole-cava.kwinrule ~/.git/linux/sc_data.sh startconky
    #sleep 2
    #WIN_ID2=$(xdotool search --class "Conky" | tail -1)
    #sleep 1
    #xdotool windowsize $WIN_ID2 450 2160
    #sleep 1
    #xdotool windowmove $WIN_ID2 0 3390
    #sleep 1
    #xdotool windowactivate $WIN_ID2
}

func_wallpaper() {
    cd $HOME/.git/linux
    cp $HOME/.git/linux/worldmapwp/config/img/$(date +'%m').jpg $HOME/.git/linux/worldmapwp/config/img/earth.jpg
    rm -f $HOME/.git/linux/worldmapwp/images/*.jpg
    xplanet -conf $HOME/.git/linux/worldmapwp/config/config.conf -projection rectangular -geometry 3840x2160 -output $HOME/.git/linux/worldmapwp/images/$(date +'%d%m%y').jpg --num_times 1
    gsettings set org.mate.background picture-filename $HOME/.git/linux/worldmapwp/images/$(date +'%d%m%y').jpg
}

if [[ -z "$1" ]]; then
    clear
    echo "Você deve declarar um dos parâmetros abaixo:"
    echo ""
    echo "startconky    - reinicia todas as instâncias do conky"
    echo "wallpaper     - reconstrói a imagem do papel de parede"
    echo "rebuild       - recria toda a estrutura de dados"
    echo "calendar      - verifica a saída do calendário no banco de dados para o conky"
    echo "update        - executa uma atualização das informações no banco de dados"
    echo "check_all     - verifica a consistência de todos os dados da tabela"
    echo "cloud_higher  - baixa e cria nuvens com qualidade máxima"
    echo "cloud_medium  - baixa e cria nuvens com qualidade média"
    echo "cloud_lower   - baixa e cria nuvens com qualidade mínima"
    echo ""
    for var in $($DB_COMM "SELECT id from t_results"); do
        echo $($DB_COMM "SELECT variable from t_results WHERE id = '$var'") '-' $($DB_COMM "SELECT descr from t_results WHERE id = '$var'")
    done

elif [[ "$1" == "startconky" ]]; then
    if pgrep -x "conky"; then
        killall conky
        nice -n 19 /home/juliano/Downloads/Install/Packages/conky.AppImage -q -d -c "$HOME/.git/linux/conky_ju.conf" &
        sleep 1
        nice -n 19 /home/juliano/Downloads/Install/Packages/conky.AppImage -q -d -c "$HOME/.git/linux/conky_bg.conf" &
        #xprop -f _KDE_NET_WM_BLUR_BEHIND_REGION 32c -set _KDE_NET_WM_BLUR_BEHIND_REGION 0 -id `xdotool search --class conky`
    else
        nice -n 19 /home/juliano/Downloads/Install/Packages/conky.AppImage -q -d -c "$HOME/.git/linux/conky_ju.conf" &
        sleep 1
        nice -n 19 /home/juliano/Downloads/Install/Packages/conky.AppImage -q -d -c "$HOME/.git/linux/conky_bg.conf" &
        #xprop -f _KDE_NET_WM_BLUR_BEHIND_REGION 32c -set _KDE_NET_WM_BLUR_BEHIND_REGION 0 -id `xdotool search --class conky`
    fi

elif [[ "$1" == "startcava" ]]; then konsole --force-reuse --profile Cava --hide-menubar --hide-tabbar --title "Cava" -e cava -p /FS/DATA/juliano/.git/linux/config/cavaconfig

elif [[ "$1" == "wallpaper" ]]; then func_wallpaper

elif [[ "$1" == "calendar" ]]; then $DB_COMM "SELECT mass_out FROM t_bulkcon WHERE id = '7'"

elif [[ "$1" == "task" ]]; then $DB_COMM "SELECT texto FROM t_todo WHERE tipo IN ('task');"

elif [[ "$1" == "note" ]]; then $DB_COMM "SELECT texto FROM t_todo WHERE tipo IN ('note');"

elif [[ "$1" == "safe" ]]; then $DB_COMM "SELECT texto FROM t_todo WHERE TIPO = 'safe';"

elif [[ "$1" == "begin" ]]; then func_begin

elif [[ "$1" == "rebuild" ]]; then
    cd $HOME/.git/linux/
    #for inst in `cat requirements`; do sudo pacman -S python-$inst; done
    $DB_COMM < db_rebuild.sql
    $DB_COMM < db_todo.sql
    cd ~/.git/linux/
    python3 sc_data.py
    func_wallpaper

elif [[ "$1" == "update" ]]; then
    cd ~/.git/linux/
    python3 sc_data.py
    func_wallpaper

elif [[ "$1" == "check_all" ]]; then
    clear
    for var in $($DB_COMM "SELECT id from t_results"); do
        echo $($DB_COMM "SELECT variable,outpu FROM t_results WHERE id = '$var'")
    done
    echo $($DB_COMM "SELECT texto FROM t_todo")
else
    $DB_COMM "SELECT outpu FROM t_results WHERE variable = '$1'"
fi
