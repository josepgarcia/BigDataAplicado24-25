#!/bin/bash

# Nombre del script: git_and_venv.sh

# 1. Agregar todos los cambios al índice de git
echo "Ejecutando 'git add .'"
git add .

# 2. Mostrar el estado del repositorio
echo "Mostrando el estado del repositorio:"
git status

# 3. Pedir mensaje para el commit
echo "Escribe el mensaje para el commit (o presiona Enter para usar un mensaje predeterminado):"
read -r commit_message

# Usar un mensaje por defecto si no se proporciona uno
if [[ -z "$commit_message" ]]; then
    commit_message="Commit realizado: $(date +'%Y-%m-%d %H:%M:%S')"
fi

# Realizar el commit
echo "Realizando el commit con el mensaje: '$commit_message'"
git commit -m "$commit_message"

# 4. Hacer el push
echo "Ejecutando 'git push'"
git push

if [[ $? -ne 0 ]]; then
    echo "Error: No se pudo realizar el push. Por favor, revisa los errores de Git."
    exit 1
fi

echo "✅ Deploy realizado"
