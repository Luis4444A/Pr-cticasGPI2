#!/bin/bash

# Directorio que contiene los archivos JAR
DIRECTORIO="kernel"

# Nombre del archivo de salida SBOM
ARCHIVO_SBOM="sbom.xml"

# Eliminamos el archivo SBOM anterior si existe
rm -f "$ARCHIVO_SBOM"

# Imprimir la cabecera del archivo XML
echo '<?xml version="1.0" encoding="UTF-8"?>' >> "$ARCHIVO_SBOM"
echo '<sbom>' >> "$ARCHIVO_SBOM"

# Iterar sobre los archivos JAR en el directorio
for file in $(find "$DIRECTORIO" -type f -name "*.jar"); do
    # Imprimir el nombre del archivo JAR
    echo "Analizando $file"
    echo "    <artifact>" >> "$ARCHIVO_SBOM"
    echo "        <name>${file##*/}</name>" >> "$ARCHIVO_SBOM"
    echo "        <dependencies>" >> "$ARCHIVO_SBOM"

    # Intentar analizar el archivo JAR con jdeps
    if jdeps "$file" &>> "$ARCHIVO_SBOM"; then
        :
    else
        echo "Error al analizar el archivo $file con jdeps" >&2
    fi

    echo "        </dependencies>" >> "$ARCHIVO_SBOM"
    echo "    </artifact>" >> "$ARCHIVO_SBOM"
done

# Imprimir el cierre del archivo XML
echo '</sbom>' >> "$ARCHIVO_SBOM"

echo "SBOM generado en $ARCHIVO_SBOM"
