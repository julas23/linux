import mysql.connector
import subprocess
import requests
import datetime
import sys
import os
import time

print('Checking Conky DataBase')
config_db_conky = {
    "host": "localhost",
    "user": "conky",
    "password": "conky_db123",
    "database": "conky"
}

def connect_to_db_conky(config):
    try:
        conn = mysql.connector.connect(**config)
        return conn
    except mysql.connector.Error as e:
        print(f"Erro ao conectar ao MariaDB (Conky): {e}")
        sys.exit(1)

conn_conky = connect_to_db_conky(config_db_conky)

print('Checking Safe DataBase')
config_db_safe = {
    "host": "localhost",
    "user": "juliano",
    "password": "jas2305X",
    "database": "safe"
}

def connect_to_db(config):
    try:
        conn = mysql.connector.connect(**config)
        return conn
    except mysql.connector.Error as e:
        print(f"Erro ao conectar ao MariaDB: {e}")
        sys.exit(1)

def execute_query(conn, query, params=None):
    cursor = conn.cursor()
    cursor.execute(query, params)
    conn.commit()
    cursor.close()

def execute_query_and_fetch(conn, query, params=None):
    cursor = conn.cursor()
    cursor.execute(query, params)
    result = cursor.fetchall()
    cursor.close()
    return result

conn_safe = connect_to_db(config_db_safe)

def get_variable_from_db(varname, conn):
    query = "SELECT varvalue FROM t_safe WHERE varname = %s"
    result = execute_query_and_fetch(conn, query, (varname,))
    if result:
        return result[0][0]
    else:
        return ""

def get_weather_data(city, api_key):
    try:
        url = f"http://api.openweathermap.org/data/2.5/weather?q={city}&appid={api_key}&units=metric"
        response = requests.get(url)
        data = response.json()
        return data
    except requests.RequestException:
        return None


SOURCE_DIRECTORY = get_variable_from_db('SOURCE_DIRECTORY', conn_safe)
DESTINATION_DIRECTORY = get_variable_from_db('DESTINATION_DIRECTORY', conn_safe)
USERNAME = get_variable_from_db('USERNAME', conn_safe)
PASSWORD = get_variable_from_db('PASSWORD', conn_safe)
ROOTPASS = get_variable_from_db('ROOTPASS', conn_safe)
STORAGE = get_variable_from_db('STORAGE', conn_safe)
ARCHITECTURE = get_variable_from_db('ARCHITECTURE', conn_safe)
WINDOWMANAGER = get_variable_from_db('WINDOWMANAGER', conn_safe)
HOSTNAME = get_variable_from_db('HOSTNAME', conn_safe)
WIFIPASSWORD = get_variable_from_db('WIFIPASSWORD', conn_safe)
NETWORKIP = get_variable_from_db('NETWORKIP', conn_safe)
PREFIX = get_variable_from_db('PREFIX', conn_safe)
GATEWAYIP = get_variable_from_db('GATEWAYIP', conn_safe)
NAMESERVER1 = get_variable_from_db('NAMESERVER1', conn_safe)
NAMESERVER2 = get_variable_from_db('NAMESERVER2', conn_safe)
WIFISSID = get_variable_from_db('WIFISSID', conn_safe)
DB_USER = get_variable_from_db('DB_USER', conn_safe)
DB_PASS = get_variable_from_db('DB_PASS', conn_safe)
DB_HOST = get_variable_from_db('DB_HOST', conn_safe)
DB_NAME = get_variable_from_db('DB_NAME', conn_safe)
CITY = get_variable_from_db('CITY', conn_safe)
API_KEY = get_variable_from_db('API_KEY', conn_safe)
timestamp = datetime.datetime.now().strftime("%a %d %b %H_%M")

def redirect_output_to_log(log_file):
    sys.stdout = open(log_file, 'a')
    sys.stderr = open(log_file, 'a')

log_directory = '/FS/DATA/juliano/.git/linux/'
log_file = os.path.join(log_directory, 'err.log')

if not os.path.exists(log_directory):
    os.makedirs(log_directory)

## Internet Connection
print('Checking internet')
def check_internet_connection():
    try:
        subprocess.run(['ping', '-c', '3', '8.8.8.8'], stdout=subprocess.PIPE, stderr=subprocess.PIPE, check=True)
        return True
    except subprocess.CalledProcessError:
        return False
if not check_internet_connection():
    print("Offline", datetime.datetime.now().strftime('%d/%b %H:%M'))
    sys.exit(1)

try:
    conn_conky = mysql.connector.connect(
        host=config_db_conky['host'],
        user=config_db_conky['user'],
        password=config_db_conky['password'],
        database=config_db_conky['database']
    )
except mysql.connector.Error as e:
    print(f"Error connecting to MariaDB Platform: {e}")
    sys.exit(1)

time.sleep(5)

## Array for commands in DataBase
print('Array to input commands output in DataBase')
for command_id in range(1, 7):
    cursor = conn_conky.cursor()
    select_query = "SELECT cmd_out FROM t_bulkcon WHERE id = %s"
    update_query = "UPDATE t_bulkcon SET mass_out = %s WHERE id = %s"

    cursor.execute(select_query, (command_id,))
    rows = cursor.fetchall()

    for row in rows:
        command_to_execute = row[0]
        try:
            command_output = subprocess.check_output(command_to_execute, shell=True, text=True)
            cursor.execute(update_query, (command_output, command_id))
            conn_conky.commit()
        except subprocess.CalledProcessError as e:
            print(f"Error executing command: {e}")

    cursor.close()

time.sleep(5)

## Public IP
print('Checking obtaining Public IP')
def get_public_ip():
    try:
        response = requests.get('https://api.ipify.org/?format=json')
        data = response.json()
        ip = data['ip']
        return ip
    except requests.RequestException:
        return None

public_ip = get_public_ip()

if public_ip:
    cursor = conn_conky.cursor()
    insert_query = "UPDATE t_results SET outpu = %s WHERE variable = %s"
    cursor.execute(insert_query, (public_ip, "public_ip_add"))
    conn_conky.commit()
    cursor.close()

time.sleep(5)

## OpenWeather data collection
print('Grabbing data from OpenWeather')
city = get_variable_from_db('CITY', conn_safe)
api_key = get_variable_from_db('API_KEY', conn_safe)

print(f"City: {city}")
print(f"API Key: {api_key}")

weather_data = get_weather_data(city, api_key)

if 'main' in weather_data:
    weather_temp_now = str(weather_data['main']['temp'])[:2]
    weather_temp_min = str(weather_data['main']['temp_min'])[:2]
    weather_temp_max = str(weather_data['main']['temp_max'])[:2]

    cursor = conn_conky.cursor()
    update_query = "UPDATE t_results SET outpu = %s WHERE variable = %s"

    cursor.execute(update_query, (weather_temp_now, "weather_tmp_n"))
    conn_conky.commit()

    cursor.execute(update_query, (weather_temp_min, "weather_tmp_m"))
    conn_conky.commit()

    cursor.execute(update_query, (weather_temp_max, "weather_tmp_x"))
    conn_conky.commit()

    cursor.close()
else:
    print("Error: 'main' key not found in the weather data.")


time.sleep(5)

## Calendar for Conky
print('Calendar for Conky')
def obter_estacao(mes):
    if mes in (1, 2, 3):
        return "Spring"
    elif mes in (4, 5, 6):
        return "Summer"
    elif mes in (7, 8, 9):
        return "Autumn"
    elif mes in (10, 11, 12):
        return "Winter"
    else:
        return ""

def gerar_calendario(cor_final_semana, cor_dia_atual, cor_padrao):
    cursor = conn_conky.cursor()
    data_atual = datetime.datetime.now()
    mes_atual = data_atual.month
    ano_atual = data_atual.year

    primeiro_dia = datetime.date(ano_atual, mes_atual, 1)
    num_dias_mes = 32 - primeiro_dia.day

    estacao_atual = obter_estacao(mes_atual)

    dia_semana = primeiro_dia.weekday()

    print("     " * dia_semana, end="")

    calendar_output = ""

    calendar_output += f"${{color {cor_padrao}}}{primeiro_dia.strftime('%B %Y'): <21} {estacao_atual}${{color}}\n"
    calendar_output += f"${{color {cor_padrao}}}  Mon  Tue  Wed  Thu  Fri  ${{color}}${{color {cor_final_semana}}}Sat  Sun${{color}}\n"
    calendar_output += "     " * dia_semana

    for dia in range(1, num_dias_mes + 1):
        if dia == data_atual.day:
            calendar_output += f"${{color {cor_dia_atual}}}{dia:4}${{color}} "
        elif dia_semana >= 5:
            if dia_semana == 5:
                calendar_output += f"${{color {cor_final_semana}}}{dia:4}${{color}} "
            else:
                calendar_output += f"${{color {cor_final_semana}}}{dia:4}${{color}} "
        else:
            calendar_output += f"${{color {cor_padrao}}}{dia:4}${{color}} "

        if (dia_semana + 1) % 7 == 0:
            calendar_output += "\n"
        dia_semana = (dia_semana + 1) % 7

    lines_remaining = 8 - calendar_output.count("\n")
    if lines_remaining > 0:
        calendar_output += "\n" * lines_remaining
    return calendar_output

cor_final_semana = "FFA800"
cor_dia_atual = "FF393B"
cor_padrao = "BEBEBF"

cale = gerar_calendario(cor_final_semana, cor_dia_atual, cor_padrao)

cursor = conn_conky.cursor()
update_query_cale = "UPDATE t_bulkcon SET mass_out = %s WHERE id = %s"
cursor.execute(update_query_cale, (cale, 7))
conn_conky.commit()
cursor.close()

time.sleep(5)

##
def get_users_logged():
    command_output = subprocess.run(['who'], stdout=subprocess.PIPE, text=True).stdout
    num_users = len(command_output.splitlines())

    cursor = conn_conky.cursor()
    update_query_user = "UPDATE t_results SET outpu = %s WHERE variable = %s"
    cursor.execute(update_query_user, (str(num_users), "chk_users_log"))
    conn_conky.commit()
    cursor.close()

get_users_logged()

time.sleep(5)

##
today = datetime.date.today()
next_1_day_fw = (today + datetime.timedelta(days=1)).strftime('%d/%b')
next_2_day_fw = (today + datetime.timedelta(days=2)).strftime('%d/%b')
next_3_day_fw = (today + datetime.timedelta(days=3)).strftime('%d/%b')
next_4_day_fw = (today + datetime.timedelta(days=4)).strftime('%d/%b')

cursor = conn_conky.cursor()
update_query_dates = "UPDATE t_results SET outpu = %s WHERE variable = %s"
cursor.execute(update_query_dates, (next_1_day_fw, "next_1_day_fw"))
cursor.execute(update_query_dates, (next_2_day_fw, "next_2_day_fw"))
cursor.execute(update_query_dates, (next_3_day_fw, "next_3_day_fw"))
cursor.execute(update_query_dates, (next_4_day_fw, "next_4_day_fw"))
conn_conky.commit()
cursor.close()

time.sleep(5)

##
shell_command = "cat /etc/passwd | grep $USER | awk -F: '{print $7}' | cut -d'/' -f 3"
command_output = subprocess.run(shell_command, shell=True, stdout=subprocess.PIPE, text=True).stdout.strip()

cursor = conn_conky.cursor()
update_query_shell = "UPDATE t_results SET outpu = %s WHERE variable = %s"
cursor.execute(update_query_shell, (command_output, "shell_running"))
conn_conky.commit()
cursor.close()

time.sleep(5)

##
cursor = conn_conky.cursor()
variable_details = [
    ("distroversion", '1', "|awk 'NR==2 {print $2,$3,$4}'"),
    ("kernelversion", '1', "|awk 'NR==3 {print $4}'"),
    ("x11resolution", '1', "|awk 'NR==7 {print $2}'"),
    ("graphic_envin", '1', "|awk 'NR==8 {print $2,$3}'"),
    ("envinrmanager", '1', "|awk 'NR==9 {print $2,$3}'"),
    ("envinrontheme", '1', "|awk 'NR==10' |cut -d: -f2 |cut -c 2-20"),
    ("cpu_manufectu", '1', "|grep 'CPU' |awk '{print $3,$4,$5}'"),
    ("gpu_manufactu", '1', "|grep 'GPU' |awk '{print $2,$3,$4,$5,$6}'"),
    ("gpu_temperatu", '6', "|awk 'NR==10 {print $3}' |cut -dC -f 1"),
    ("mobo_ddr_slot", '2', "|grep 'bank' |wc -l"),
    ("mobo_ddr_used", '2', "|grep GiB |awk 'NR>=2' |wc -l"),
    ("mobo_ddr_size", '2', "|grep GiB |awk 'NR==2' |cut -d: -f 2 |cut -c 2,3,4,5,6"),
    ("mobo_ddr_alls", '2', "|grep GiB |awk 'NR==1' |cut -d: -f 2 |cut -c 2,3,4,5,6"),
    ("cpu_temperatu", '3', "|grep Tctl |cut -d+ -f2 |cut -c '1,2'"),
    ("mobo_temperat", '3', "|grep -wns acpi -A 2 |grep temp1 |cut -d+ -f2 |cut -c 1,2"),
    ("fan1_rpm_spee", '3', "|grep fan1 |awk '{print $2}'"),
    ("case_temperat", '3', "|grep -wns isa -A 14 |grep temp1 |cut -d+ -f2 |cut -c 1,2"),
    ("case_fan_rpms", '3', "|grep fan3 |awk '{print $2}'"),
    ("nvme0_tempera", '3', "|grep -A 2 'nvme-pci-0100' |grep -i 'Composite' |awk '{print $2}' |cut -d+ -f 2 |cut -c '1,2'"),
    ("nvme1_tempera", '3', "|grep -A 2 'nvme-pci-0400' |grep -i 'Composite' |awk '{print $2}' |cut -d+ -f 2 |cut -c '1,2'"),
    ("nvme2_tempera", '3', "|grep -A 2 'nvme-pci-0500' |grep -i 'Composite' |awk '{print $2}' |cut -d+ -f 2 |cut -c '1,2'"),
    ("mobo_manufact", '4', "|grep 'Manufacturer'	|awk '{print $2}'"),
    ("mobo_modelver", '4', "|grep 'Product' |awk '{print $3}'"),
    ("memory_cloksp", '5', "|grep Speed: |awk 'NR==1 {print $2}'"),
    ("memory_slotty", '5', "|grep -i 'Type: ' |grep -v 'Unknown' |uniq |awk '{print $2}'")
]

for variable, line_number, cmd in variable_details:
    query = f"SELECT mass_out FROM t_bulkcon WHERE id = {line_number}"
    cursor.execute(query)
    result = cursor.fetchone()[0]

    combined_command = f"echo '{result}' {cmd}"

    process = subprocess.Popen(
        combined_command,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        shell=True
    )
    stdout, stderr = process.communicate()

    if process.returncode != 0:
        print("Error:", stderr)
        continue

    output = stdout.strip()

    update_query = "UPDATE t_results SET outpu = %s WHERE variable = %s"
    cursor.execute(update_query, (output, variable))
    conn_conky.commit()

cursor.close()
conn_conky.close()
conn_safe.close()