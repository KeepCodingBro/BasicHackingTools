#!bin/bash/

echo "Bienvenido a HTools, elige el número de la herramienta que quieres utilizar:"
echo "1- Escaner de puertos TCP con Nmap sin resolución DNS"
echo "2- Escaner de puertos UDP con Nmap"
echo "3- Fuzzing web de directiorios con Gobuster"
echo "4- Fuzzing de subdominios con Wfuzz"
echo "5- Ataques de fuerza bruta con Hydra"
echo "6- Levantar servidor Http con python"
echo "7- Poner puerto en escucha con NetCat"
echo "8- Salir"
read -p "Elige la herramienta que quieres utilizar escribiendo el número: " opcion

while [ "$opcion" -lt 8 ]; do 
	if [ "$opcion" = "1" ]; then
		echo "Iniciando escaner de puertos con Nmap (FTP)"
		read -p "Introduce la IP de la maquina victima: " ip
		read -p "Introduce la velocidad del escaneo teniendo en cuenta que 1000 es mas lento y 5000 muy rápido: " rate
		sudo nmap -p- --open -sS -sC -sV --min-rate $rate -n -vvv -Pn $ip -oG EscaneoFTP
		echo "Se te ha generado un archivo grepeable con la información de este escaneo con el nombre 'EscaneoFTP'"
		exit
	elif [ "$opcion" = "2" ]; then
		echo "Iniciando escaner de puertos con Nmap (UDP)"
		read -p "Introduce la IP de la maquina victima: " ip
		read -p "Introduce la velocidad del escaneo teniendo en cuenta que 1000 es lento y 5000 muy rapido: " rate
		read -p "Introduce el top puertos mas usados que quiere comprobar (--top-ports): " ports
		nmap -sU --top-ports $ports --min-rate=$rate -Pn $ip
	elif [ "$opcion" = "3" ]; then
		echo "Iniciando Fuzzing de directorios con Gobuster"
		read -p "Introduce la IP o web sobre la que quieres hacer el ataque: " ip
		read -p "Introduce la ruta del diccionario que quieres comprobar: " ruta
		read -p "Introduce el tipo de conexión http o https: " protocolo
		gobuster dir -u $protocolo://$ip/ -w $ruta
		exit
	elif [ "$opcion" = "4" ]; then
		echo "Iniciando Fuzzing de subdominios con WFuzz"
		read -p "Introduce la IP o web sobre la que quieres hacer el ataque: " ip
                read -p "Introduce la ruta del diccionario que quieres comprobar: " ruta
                read -p "Introduce el tipo de conexión http o https: " protocolo
		read -p "Introduce el filtro de status code (--hc): " statuscode
		read -p "Introduce el filtro por numero de lineas (--hl): " lines
		wfuzz -c --hc $statuscode --hl $lines -w $ruta $protocolo://$ip/FUZZ
		echo "Recuerda que para enlazar una Ip con virtual hosting modifica el archivo /etc/hosts"
		exit
	elif [ "$opcion" = "5" ]; then
		echo "Iniciando ataque de fuerza bruta con Hydra"
		read -p "¿Qué dato conoces?(user / password) " dato
		if [ "$dato" = "user" ]; then
			read -p "introduce el nomre de usuario: " usuario
			read -p "introduce la ruta del diccionario que quieres pasar a la contraseña: " ruta
			read -p "introduce la ip de la maquina victima: " ip
			read -p "introduce la el protocolo que deseas atacar: " protocolo
			hydra -l $usuario -P $ruta $protocolo://$ip
			exit
		elif [ "$dato" = "password" ]; then
			read -p "Introduce la contraseña conocida: " password
			read -p "introduce la ruta del diccionario que quieres pasar a la password: " password
                        read -p "introduce la ip de la maquina victima: " ip
                        read -p "introduce la el protocolo que deseas atacar: " protocolo
			hydra -l $ruta -p $password $protocolo://$ip
			exit
		else
			exit
		fi
	elif [ "$opcion" = "6" ]; then
		echo "Iniciando servidor http con python3"
		read -p "Introduce el puerto donde quieres levantarlo '80' suele ser el recomendado: " port
		echo "Para acabar con el proceso ctrl+c"
		echo "Ahora puedes compartir archivos en tu red interna con el comando curl o poniendo tu ip en el browser de la maquina victima"
		sudo python3 -m http.server $port
		exit
	elif [ "$opcion" = "7" ]; then
		echo "Iniciando puerto de escucha con NetCat"
		read -p "Introduce el puerto que quieres poner en escucha: " port
		echo "Para acabar con el proceso ctrl+c"
		sudo nc -nlvp $port
		exit
	else
		exit
	fi
done

