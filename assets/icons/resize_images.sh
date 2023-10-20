#!/bin/bash

# Перебор всех файлов с расширением .icns и .png в текущей директории
for filename in *.{icns,png}; do
    # Проверка существования файла
    if [ -f "$filename" ]; then
        # Извлечение числа из имени файла
        size=$(echo "$filename" | cut -d'-' -f2 | cut -d'.' -f1)

        # Изменение размера изображения с помощью команды sips
        sips -Z "$size" "$filename"
    fi
done
