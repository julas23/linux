#!/bin/bash

HOMEDIR=/FS/DATA/juliano
LINUXDIR=/FS/DATA/juliano/Git/linux
TIMESTAMP=$(date +'%A %d %B %Y - %H:%M')

source $LINUXDIR/sc_vars.ini

cd $LINUXDIR/

for i in $(who | awk '{print $1}'); do
    echo $i > ~/.unknown_users
done

func_begin() {
    killall conky
    killall cava
    killall konsole
    kstart5 --window cava --alldesktops --onbottom --keepbelow --maximize-horizontally --desktopfile $LINUXDIR/config/konsole-cava.kwinrule $LINUXDIR/sc_data.sh startcava
    sleep 2
    WIN_ID1=$(xdotool search --class "Conky" | tail -1)
    sleep 1
    xdotool windowsize $WIN_ID1 3390 300
    sleep 1
    xdotool windowmove $WIN_ID1 0 1865
    sleep 1
    xdotool windowactivate $WIN_ID1

    kstart5 --window conky --alldesktops --onbottom --keepbelow --maximize-horizontally --desktopfile $LINUXDIR/config/konsole-cava.kwinrule $LINUXDIR/sc_data.sh startconky
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
    cd $LINUXDIR
    cp $LINUXDIR/worldmapwp/config/img/$(date +'%m').jpg $LINUXDIR/worldmapwp/config/img/earth.jpg
    rm -f $LINUXDIR/worldmapwp/images/*.jpg
    xplanet -conf $LINUXDIR/worldmapwp/config/config.conf -projection rectangular -geometry 3840x2160 -output $LINUXDIR/worldmapwp/images/$(date +'%d%m%y').jpg --num_times 1
    gsettings set org.mate.background picture-filename $LINUXDIR/worldmapwp/images/$(date +'%d%m%y').jpg
}

func_startconky() {
    if pgrep -x "conky"; then
        clear
        #killall conky
        #nice -n 19 conky -c "$LINUXDIR/conky_ju.conf" &
        #sleep 1
        #nice -n 19 conky -c "$LINUXDIR/conky_bg.conf" &
        #xprop -f _KDE_NET_WM_BLUR_BEHIND_REGION 32c -set _KDE_NET_WM_BLUR_BEHIND_REGION 0 -id `xdotool search --class conky`
    else
        nice -n 19 conky -c "$LINUXDIR/conky_ju.conf" &
        #sleep 1
        #nice -n 19 conky -c "$LINUXDIR/conky_bg.conf" &
        #xprop -f _KDE_NET_WM_BLUR_BEHIND_REGION 32c -set _KDE_NET_WM_BLUR_BEHIND_REGION 0 -id `xdotool search --class conky`
    fi
}

func_update() {
    cd $LINUXDIR
    echo $TIMESTAMP 'Ran update' >> /var/log/output
    func_wallpaper
    func_startconky
    python3 sc_data.py
}

func_rebuild() {
    cd $LINUXDIR/
    $DBC < db_rebuild.sql
    $DBC < db_todo.sql
    $DBC < db_safe.sql
    cd $LINUXDIR/
    yes | sudo sensors-detect
    python3 sc_data.py
    func_wallpaper
}

func_checkall() {
    for var in $($DBC "SELECT id from t_results"); do
        echo $($DBC "SELECT variable,outpu FROM t_results WHERE id = '$var'")
    done
    echo $($DBC "SELECT texto FROM t_todo")
}

func_deeptest() {
    echo 'Testing DB Conky Table t_results'
    for var1 in $($DBC "SELECT id from t_results")
        do
            echo $($DBC  "SELECT variable,outpu FROM t_results WHERE id = '$var1'");
        done
    echo ''
    echo ''
    echo 'Testing DB Conky Table t_todo'
    for var2 in $($DBC "SELECT id FROM t_todo")
        do
            echo $($DBC "SELECT texto FROM t_todo WHERE id = '$var2'")
        done
}

func_example() {
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
    for var in $($DBC "SELECT id from t_results"); do
        echo $($DBC "SELECT variable from t_results WHERE id = '$var'") '-' $($DBC "SELECT descr from t_results WHERE id = '$var'")
    done
}

if [[ -z "$1" ]]; then func_example

elif [[ "$1" == "startconky" ]]; then func_startconky

elif [[ "$1" == "startcava" ]]; then konsole --force-reuse --profile Cava --hide-menubar --hide-tabbar --title "Cava" -e cava -p $LINUXDIR/config/cavaconfig

elif [[ "$1" == "wallpaper" ]]; then func_wallpaper

elif [[ "$1" == "begin" ]]; then func_begin

elif [[ "$1" == "rebuild" ]]; then func_rebuild

elif [[ "$1" == "update" ]]; then func_update

elif [[ "$1" == "check_all" ]]; then func_checkall

elif [[ "$1" == "deeptest" ]]; then func_deeptest

elif [[ "$1" == "calendar" ]]; then $DBC "SELECT mass_out FROM t_bulkcon WHERE id = '7'"

elif [[ "$1" == "task" ]]; then $DBC "SELECT texto FROM t_todo WHERE tipo IN ('task');"

elif [[ "$1" == "safe" ]]; then $DBS "SELECT varname,varvalue FROM t_safe;"

elif [[ "$1" == "note" ]]; then $DBC "SELECT texto FROM t_todo WHERE tipo IN ('note')"

else
    $DBC "SELECT outpu FROM t_results WHERE variable = '$1'"
fi