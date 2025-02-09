#!/bin/bash

# Funciones para cada ejercicio
factorial() {
    local num=$1
    local resultado=1
    for ((i=1; i<=num; i++)); do
        resultado=$((resultado * i))
    done
    echo "El factorial de $num es: $resultado"
}

bisiesto() {
    local anio=$1
    if (( anio % 4 == 0 && (anio % 100 != 0 || anio % 400 == 0) )); then
        echo "$anio es un año bisiesto"
    else
        echo "$anio no es un año bisiesto"
    fi
}

configurarred() {
    local ip=$1
    local mascara=$2
    local puerta=$3
    local dns=$4
    
    echo "Configurando red con:"
    echo "IP: $ip"
    echo "Máscara: $mascara"
    echo "Puerta de enlace: $puerta"
    echo "DNS: $dns"
}

adivina() {
    local objetivo=$((RANDOM % 100 + 1))
    local intentos=0
    local numero
    
    echo "Adivina un número entre 1 y 100"
    read -p "Introduce tu número: " numero
    ((intentos++))
    
    until [ "$numero" -eq "$objetivo" ]; do
        if [ "$numero" -lt "$objetivo" ]; then
            echo "¡Demasiado bajo!"
        else
            echo "¡Demasiado alto!"
        fi
        read -p "Introduce tu número: " numero
        ((intentos++))
    done
    
    echo "¡Correcto! Has necesitado $intentos intentos"
}

edad() {
    local edad=$1
    
    if ((edad < 3)); then
        echo "niñez"
    elif ((edad >= 3 && edad <= 10)); then
        echo "infancia"
    elif ((edad > 10 && edad < 18)); then
        echo "adolescencia"
    elif ((edad >= 18 && edad < 40)); then
        echo "juventud"
    elif ((edad >= 40 && edad < 65)); then
        echo "madurez"
    else
        echo "vejez"
    fi
}

fichero() {
    local archivo=$1
    if [ -f "$archivo" ]; then
        echo "Información del archivo: $archivo"
        echo "Tamaño: $(stat -f %z "$archivo") bytes"
        echo "Tipo: $(file "$archivo")"
        echo "Inodo: $(stat -f %i "$archivo")"
        echo "Punto de montaje: $(df "$archivo" | tail -1 | awk '{print $6}')"
    else
        echo "El archivo no existe"
    fi
}

buscar() {
    local nombre=$1
    local encontrado=$(find / -name "$nombre" 2>/dev/null)
    
    if [ -z "$encontrado" ]; then
        echo "Error: Archivo no encontrado"
    else
        echo "Archivo encontrado en: $encontrado"
        echo "Número de vocales: $(cat "$encontrado" | grep -o '[aeiouAEIOU]' | wc -l)"
    fi
}

contar() {
    local directorio=$1
    if [ -d "$directorio" ]; then
        local cantidad=$(ls -1 "$directorio" | wc -l)
        echo "Número de archivos en $directorio: $cantidad"
    else
        echo "El directorio no existe"
    fi
}

privilegios() {
    if groups | grep -q '\bsudo\b'; then
        echo "El usuario tiene privilegios administrativos"
    else
        echo "El usuario no tiene privilegios administrativos"
    fi
}

permisosoctal() {
    local archivo=$1
    if [ -e "$archivo" ]; then
        local permisos=$(stat -f %Lp "$archivo")
        echo "Permisos octales para $archivo: $permisos"
    else
        echo "El archivo no existe"
    fi
}

romano() {
    local num=$1
    [ "$num" -lt 1 -o "$num" -gt 200 ] && { echo "El número debe estar entre 1 y 200"; return 1; }
    
    local resultado=""
    local valores=(100 90 50 40 10 9 5 4 1)
    local romanos=(C XC L XL X IX V IV I)
    
    for ((i=0; i<${#valores[@]}; i++)); do
        while ((num >= valores[i])); do
            resultado+=${romanos[i]}
            ((num -= valores[i]))
        done
    done
    
    echo "$resultado"
}

automatizar() {
    local directorio="/mnt/usuarios"
    if [ ! -d "$directorio" ] || [ -z "$(ls -A "$directorio")" ]; then
        echo "El directorio está vacío o no existe"
        return 1
    fi
    
    for archivo in "$directorio"/*; do
        local usuario=$(basename "$archivo")
        useradd -m "$usuario"
        while read -r carpeta; do
            mkdir -p "/home/$usuario/$carpeta"
        done < "$archivo"
        rm "$archivo"
    done
}

crear() {
    local nombre=${1:-fichero_vacio}
    local tamanio=${2:-1024}
    
    dd if=/dev/zero of="$nombre" bs=1K count="$tamanio" 2>/dev/null
    echo "Archivo creado $nombre con tamaño ${tamanio}K"
}

crear_2() {
    local nombre_base=${1:-fichero_vacio}
    local tamanio=${2:-1024}
    local nombre="$nombre_base"
    
    for i in {0..9}; do
        if [ ! -f "$nombre" ]; then
            dd if=/dev/zero of="$nombre" bs=1K count="$tamanio" 2>/dev/null
            echo "Archivo creado $nombre con tamaño ${tamanio}K"
            return 0
        fi
        nombre="${nombre_base}${i}"
    done
    
    echo "No se puede crear el archivo: todas las variaciones existen"
    return 1
}

reescribir() {
    local palabra=$1
    echo "$palabra" | sed 's/a/1/g; s/e/2/g; s/i/3/g; s/o/4/g; s/u/5/g'
}

contusu() {
    local cantidad_usuarios=$(ls /home | wc -l)
    echo "Usuarios reales en el sistema: $cantidad_usuarios"
    
    select usuario in $(ls /home); do
        if [ -n "$usuario" ]; then
            local dir_backup="/home/copiaseguridad/${usuario}_$(date +%Y%m%d)"
            mkdir -p "$dir_backup"
            cp -r "/home/$usuario" "$dir_backup"
            echo "Copia de seguridad creada en $dir_backup"
            break
        fi
    done
}

alumnos() {
    read -p "Introduce el número de alumnos: " num_alumnos
    local aprobados=0
    local suspensos=0
    local total=0
    
    for ((i=1; i<=num_alumnos; i++)); do
        read -p "Introduce la nota del alumno $i: " nota
        ((total += nota))
        if ((nota >= 5)); then
            ((aprobados++))
        else
            ((suspensos++))
        fi
    done
    
    echo "Aprobados: $aprobados"
    echo "Suspensos: $suspensos"
    echo "Nota media: $(echo "scale=2; $total/$num_alumnos" | bc)"
}

quita_blancos() {
    for archivo in *; do
        if [[ "$archivo" == *" "* ]]; then
            mv "$archivo" "${archivo// /_}"
        fi
    done
}

lineas() {
    local caracter=$1
    local ancho=$2
    local alto=$3
    
    if [ -z "$caracter" ] || [ -z "$ancho" ] || [ -z "$alto" ]; then
        echo "Error: Faltan parámetros"
        return 1
    fi
    
    if ((ancho < 1 || ancho > 60 || alto < 1 || alto > 10)); then
        echo "Error: Dimensiones inválidas"
        return 1
    fi
    
    for ((i=0; i<alto; i++)); do
        printf "%${ancho}s\n" | tr " " "$caracter"
    done
}

analizar() {
    local directorio=$1
    shift
    local extensiones=("$@")
    
    echo "Análisis del directorio: $directorio"
    for ext in "${extensiones[@]}"; do
        local cantidad=$(find "$directorio" -type f -name "*.$ext" | wc -l)
        echo "Archivos con extensión .$ext: $cantidad"
    done
}

nombre21() {
    local repos=("Fotografia" "Dibujo" "Imagenes")
    local extensiones_validas=("jpg" "gif" "png")
    local usuario=${1:-}
    
    for repo in "${repos[@]}"; do
        for archivo in "$repo"/*; do
            if [ -f "$archivo" ]; then
                local mime=$(file -i "$archivo")
                local ext="${archivo##*.}"
                local ext_correcta=""
                
                case "$mime" in
                    *"image/jpeg"*) ext_correcta="jpg" ;;
                    *"image/gif"*) ext_correcta="gif" ;;
                    *"image/png"*) ext_correcta="png" ;;
                esac
                
                if [ -n "$ext_correcta" ] && [ "$ext" != "$ext_correcta" ]; then
                    mv "$archivo" "${archivo%.*}.$ext_correcta"
                elif [ -z "$ext_correcta" ]; then
                    local propietario=$(stat -f "%Su" "$archivo")
                    local grupo=$(stat -f "%Sg" "$archivo")
                    echo "$propietario;$grupo;$(date +%d.%m.%Y);$archivo" >> descartados.log
                    rm "$archivo"
                fi
            fi
        done
    done
    
    if [ -n "$usuario" ]; then
        local cantidad=$(grep "^$usuario;" descartados.log | wc -l)
        echo "Archivos eliminados para el usuario $usuario: $cantidad"
    fi
}

nombre22() {
    local archivo=$1
    
    if [ ! -f "$archivo" ]; then
        echo "Error: El archivo no existe"
        return 1
    fi
    
    while IFS=: read -r nombre apellido1 apellido2 login; do
        if id "$login" >/dev/null 2>&1; then
            local dir_trabajo="/home/$login/trabajo"
            if [ -d "$dir_trabajo" ]; then
                local dir_destino="/home/proyecto/$login"
                mkdir -p "$dir_destino"
                mv "$dir_trabajo"/* "$dir_destino"/ 2>/dev/null
                chown -R root:root "$dir_destino"
                
                local cantidad=$(ls -1 "$dir_destino" | wc -l)
                echo "$(date +%d/%m/%Y-%H:%M:%S)-$login-$dir_destino" >> bajas.log
                ls -1 "$dir_destino" | nl >> bajas.log
                echo "Total de archivos movidos: $cantidad" >> bajas.log
                
                userdel -r "$login"
            else
                echo "$(date +%d/%m/%Y-%H:%M:%S)-$login-$nombre-$apellido1-$apellido2-ERROR:No existe directorio trabajo" >> bajaserror.log
            fi
        else
            echo "$(date +%d/%m/%Y-%H:%M:%S)-$login-$nombre-$apellido1-$apellido2-ERROR:El usuario no existe" >> bajaserror.log
        fi
    done < "$archivo"
}

# Función para mostrar el menú y obtener la elección del usuario
mostrar_menu() {
    echo -e "\nMenú del Script:"
    echo "1. Calcular factorial"
    echo "2. Comprobar año bisiesto"
    echo "3. Configurar red"
    echo "4. Juego de adivinar números"
    echo "5. Clasificación por edad"
    echo "6. Información de archivo"
    echo "7. Buscar archivo"
    echo "8. Contar archivos en directorio"
    echo "9. Comprobar privilegios administrativos"
    echo "10. Mostrar permisos octales"
    echo "11. Convertir a números romanos"
    echo "12. Automatizar creación de usuarios"
    echo "13. Crear archivo con tamaño"
    echo "14. Crear archivo con backup numerado"
    echo "15. Reescribir con números"
    echo "16. Contar usuarios y hacer backup"
    echo "17. Notas de alumnos"
    echo "18. Quitar espacios de nombres de archivo"
    echo "19. Dibujar líneas"
    echo "20. Analizar extensiones de archivo"
    echo "21. Procesar archivos de imagen"
    echo "22. Procesar bajas de usuarios"
    echo "0. Salir"
    
    read -p "Selecciona una opción: " opcion
    return "$opcion"
}

# Función principal para manejar la selección del menú
principal() {
    local opcion
    
    mostrar_menu
    opcion=$?
    
    case $opcion in
        0) return 0 ;;
        1)
            read -p "Introduce un número: " num
            factorial "$num"
            ;;
        2)
            read -p "Introduce un año: " anio
            bisiesto "$anio"
            ;;
        3)
            read -p "Introduce IP: " ip
            read -p "Introduce máscara: " mascara
            read -p "Introduce puerta de enlace: " puerta
            read -p "Introduce DNS: " dns
            configurarred "$ip" "$mascara" "$puerta" "$dns"
            ;;
        4) adivina ;;
        5)
            read -p "Introduce la edad: " edad
            edad "$edad"
            ;;
        6)
            read -p "Introduce la ruta del archivo: " archivo
            fichero "$archivo"
            ;;
        7)
            read -p "Introduce el nombre del archivo: " nombre
            buscar "$nombre"
            ;;
        8)
            read -p "Introduce el directorio: " directorio
            contar "$directorio"
            ;;
        9) privilegios ;;
        10)
            read -p "Introduce la ruta del archivo: " archivo
            permisosoctal "$archivo"
            ;;
        11)
            read -p "Introduce un número (1-200): " num
            romano "$num"
            ;;
        12) automatizar ;;
        13)
            read -p "Introduce nombre del archivo (opcional): " nombre
            read -p "Introduce tamaño en KB (opcional): " tamanio
            crear "$nombre" "$tamanio"
            ;;
        14)
            read -p "Introduce nombre del archivo (opcional): " nombre
            read -p "Introduce tamaño en KB (opcional): " tamanio
            crear_2 "$nombre" "$tamanio"
            ;;
        15)
            read -p "Introduce una palabra: " palabra
            reescribir "$palabra"
            ;;
        16) contusu ;;
        17) alumnos ;;
        18) quita_blancos ;;
        19)
            read -p "Introduce un carácter: " caracter
            read -p "Introduce el ancho (1-60): " ancho
            read -p "Introduce el alto (1-10): " alto
            lineas "$caracter" "$ancho" "$alto"
            ;;
        20)
            read -p "Introduce el directorio: " directorio
            read -p "Introduce las extensiones (separadas por espacios): " -a extensiones
            analizar "$directorio" "${extensiones[@]}"
            ;;
        21)
            read -p "Introduce nombre de usuario (opcional): " usuario
            nombre21 "$usuario"
            ;;
        22)
            read -p "Introduce el archivo de entrada: " archivo
            nombre22 "$archivo"
            ;;
        *)
            echo "Opción inválida"
            ;;
    esac
    
    principal # Llamada recursiva en lugar de bucle
}

# Iniciar el script
principal
