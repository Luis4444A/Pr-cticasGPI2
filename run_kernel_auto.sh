# Easybuggy
cd kernel

# Limpia, instala, empaqueta y analiza el proyecto
mvn clean install
mvn package
echo "Archivos .jar encontrados después de empaquetar:"
find . -name "*.jar"

~/pmd-bin-7.0.0/bin/pmd check -d . -R rulesets/java/quickstart.xml -f text
