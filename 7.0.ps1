# Ejercicio 23 - Pizzería Bella Napoli
function Show-PizzaMenu {
    Write-Host "`nPizzería Bella Napoli"
    $tipo = Read-Host "¿Desea una pizza vegetariana? (s/n)"
    
    Write-Host "`nIngredientes base: Mozzarella y Tomate"
    
    if ($tipo -eq 's') {
        Write-Host "`nIngredientes vegetarianos disponibles:"
        Write-Host "1. Pimiento"
        Write-Host "2. Tofu"
        $ingrediente = Read-Host "Seleccione un ingrediente (1-2)"
        
        $ing_elegido = switch ($ingrediente) {
            1 { "Pimiento" }
            2 { "Tofu" }
            default { "Pimiento" }
        }
        
        Write-Host "`nPizza vegetariana con:"
        Write-Host "- Mozzarella"
        Write-Host "- Tomate"
        Write-Host "- $ing_elegido"
    }
    else {
        Write-Host "`nIngredientes no vegetarianos disponibles:"
        Write-Host "1. Peperoni"
        Write-Host "2. Jamón"
        Write-Host "3. Salmón"
        $ingrediente = Read-Host "Seleccione un ingrediente (1-3)"
        
        $ing_elegido = switch ($ingrediente) {
            1 { "Peperoni" }
            2 { "Jamón" }
            3 { "Salmón" }
            default { "Peperoni" }
        }
        
        Write-Host "`nPizza no vegetariana con:"
        Write-Host "- Mozzarella"
        Write-Host "- Tomate"
        Write-Host "- $ing_elegido"
    }
}

# Ejercicio 24 - Días pares e impares en año bisiesto
function Get-BisiestoDias {
    # Inicializamos los contadores
    [int]$dias_pares = 0
    [int]$dias_impares = 0
    
    # En año bisiesto hay 366 días
    for ($i = 1; $i -le 366; $i++) {
        if ($i % 2 -eq 0) {
            $dias_pares++
        }
        else {
            $dias_impares++
        }
    }
    
    Clear-Host
    Write-Host "`n=== ANÁLISIS DE AÑO BISIESTO ===" -ForegroundColor Cyan
    Write-Host "En un año bisiesto hay:"
    Write-Host ("Días pares: {0}" -f $dias_pares) -ForegroundColor Green
    Write-Host ("Días impares: {0}" -f $dias_impares) -ForegroundColor Yellow
    Write-Host "================================`n"
    
    # Pausa para que el usuario pueda ver el resultado
    Write-Host "Presione Enter para continuar..."
    Read-Host
}

# Ejercicio 25 - Menú de usuarios
function Show-MenuUsuarios {
    do {
        Write-Host "`nMenú de Usuarios:"
        Write-Host "1. Listar usuarios"
        Write-Host "2. Crear usuario"
        Write-Host "3. Eliminar usuario"
        Write-Host "4. Modificar usuario"
        Write-Host "0. Salir"
        
        $opcion = Read-Host "Seleccione una opción"
        
        switch ($opcion) {
            1 {
                Write-Host "`nListado de usuarios:"
                Get-LocalUser | Format-Table Name, Enabled, Description
            }
            2 {
                $username = Read-Host "Nombre de usuario"
                $password = Read-Host "Contraseña" -AsSecureString
                New-LocalUser -Name $username -Password $password
                Write-Host "Usuario creado correctamente"
            }
            3 {
                $username = Read-Host "Nombre de usuario a eliminar"
                Remove-LocalUser -Name $username
                Write-Host "Usuario eliminado correctamente"
            }
            4 {
                $oldname = Read-Host "Nombre de usuario actual"
                $newname = Read-Host "Nuevo nombre de usuario"
                Rename-LocalUser -Name $oldname -NewName $newname
                Write-Host "Usuario modificado correctamente"
            }
            0 {
                Write-Host "Saliendo..."
            }
            default {
                Write-Host "Opción inválida"
            }
        }
    } while ($opcion -ne 0)
}

# Ejercicio 26 - Menú de grupos
function Show-MenuGrupos {
    do {
        Write-Host "`nMenú de Grupos:"
        Write-Host "1. Listar grupos"
        Write-Host "2. Ver miembros de un grupo"
        Write-Host "3. Crear grupo"
        Write-Host "4. Eliminar grupo"
        Write-Host "5. Añadir miembro a grupo"
        Write-Host "6. Eliminar miembro de grupo"
        Write-Host "0. Salir"
        
        $opcion = Read-Host "Seleccione una opción"
        
        switch ($opcion) {
            1 {
                Write-Host "`nListado de grupos:"
                Get-LocalGroup | Format-Table Name, Description
            }
            2 {
                $grupo = Read-Host "Nombre del grupo"
                Write-Host ("`nMiembros del grupo {0}" -f $grupo)
                Get-LocalGroupMember -Group $grupo | Format-Table Name, PrincipalSource
            }
            3 {
                $nombre = Read-Host "Nombre del grupo"
                New-LocalGroup -Name $nombre
                Write-Host "Grupo creado correctamente"
            }
            4 {
                $nombre = Read-Host "Nombre del grupo a eliminar"
                Remove-LocalGroup -Name $nombre
                Write-Host "Grupo eliminado correctamente"
            }
            5 {
                $grupo = Read-Host "Nombre del grupo"
                $usuario = Read-Host "Nombre del usuario"
                Add-LocalGroupMember -Group $grupo -Member $usuario
                Write-Host "Usuario añadido al grupo correctamente"
            }
            6 {
                $grupo = Read-Host "Nombre del grupo"
                $usuario = Read-Host "Nombre del usuario"
                Remove-LocalGroupMember -Group $grupo -Member $usuario
                Write-Host "Usuario eliminado del grupo correctamente"
            }
            0 {
                Write-Host "Saliendo..."
            }
            default {
                Write-Host "Opción inválida"
            }
        }
    } while ($opcion -ne 0)
}

# Ejercicio 27 - Gestión de discos con Diskpart
function Start-DiskpartConfig {
    $diskNumber = Read-Host "Introduce el número del disco a utilizar"
    
    # Obtener información del disco
    $disk = Get-Disk -Number $diskNumber
    $diskSizeGB = [math]::Round($disk.Size / 1GB, 2)
    Write-Host "Tamaño del disco: $diskSizeGB GB"
    
    # Crear script temporal para Diskpart
    $scriptPath = "$env:TEMP\diskpart_script.txt"
    
    # Calcular número de particiones de 1GB posibles
    $numPartitions = [math]::Floor($diskSizeGB)
    
    # Crear contenido del script
    $diskpartCommands = @"
select disk $diskNumber
clean
"@
    
    # Añadir comandos para cada partición
    for ($i = 1; $i -le $numPartitions; $i++) {
        $diskpartCommands += @"
create partition primary size=1024
"@
    }
    
    # Guardar comandos en archivo temporal
    $diskpartCommands | Out-File $scriptPath -Encoding ASCII
    
    # Ejecutar Diskpart con el script
    Write-Host "Ejecutando Diskpart..."
    diskpart /s $scriptPath
    
    # Limpiar archivo temporal
    Remove-Item $scriptPath
    
    Write-Host "Proceso completado. Se han creado $numPartitions particiones de 1GB"
}

# Menú principal
function Show-MainMenu {
    do {
        Write-Host "`nMenú Principal:"
        Write-Host "23. Pizzería Bella Napoli"
        Write-Host "24. Calcular días pares e impares en año bisiesto"
        Write-Host "25. Menú de usuarios"
        Write-Host "26. Menú de grupos"
        Write-Host "27. Configuración de disco"
        Write-Host "0. Salir"
        
        $opcion = Read-Host "Seleccione una opción"
        
        switch ($opcion) {
            23 { Show-PizzaMenu }
            24 { Get-BisiestoDias }
            25 { Show-MenuUsuarios }
            26 { Show-MenuGrupos }
            27 { Start-DiskpartConfig }
            0 { Write-Host "Saliendo..." }
            default { Write-Host "Opción inválida" }
        }
    } while ($opcion -ne 0)
}

# Iniciar el script
Show-MainMenu