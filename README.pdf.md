---
geometry: margin=1in
urlcolor: blue
mainfont: Inter Light BETA
mainfontoptions:
- BoldFont=Inter Semi Bold
---

# Compilar XtratuM usando Docker

Esta guía explica cómo compilar XtratuM en una máquina Linux de cualquier distribución utilizando Docker. Como ejemplo se compilará XtratuM para IA32.

El Dockerfile que se usará se basa en Ubuntu 14.04, e instala las últimas versiones de los paquetes necesarios para compilar XtratuM disponibles para esta distribución:

- gcc-multilib
- make
- libncurses5-dev
- binutils
- makeself

Además, instalamos los siguientes paquetes en versión de 32 bits

- libxml2-dev:i386

Estos paquetes son específicos para compilar para la arquitectura IA32. Es necesario investigar qué paquetes son necesarios para otras arquitecturas.

## Crear la imagen de Docker

La imagen deberá crearse utilizando una versión limpia del árbol de trabajo de este repositorio. Si antes se ha construido alguna regla del Makefile, deberá limpiarse antes utilizando:
```
make distclean
```

Antes de crear la imagen, hay que copiar la versión adecuada del fichero `xmconfig`, que en nuestro caso `xmconfig.ia32`:

```
cp xmconfig.ia32 xmconfig
```

Una vez limpiado y configurado el árbol de trabajo, construimos la imagen:
```
docker build -t xm .
```

Esto creará la imagen con etiqueta `xm`. Dentro de la imagen, se copiará el árbol de trabajo al directorio `/opt/xtratum`. Los container de esta imagen ejecutarán una *shell* interactiva. Siempre que se quieran ejecutar deberá hacerse con las opciones `--interactive --ty` (versión corta: `-it`).

## Crear y utilizar el container

Crearemos el container con el directorio donde se instalará XtratuM compartido con el anfitrión:

```
docker run -it --name xm -v "$(pwd)/install":/opt/install xm
```

Este comando crea un container de nombre `xm`. Se pueden sustituir los directorios en `"$(pwd)/install":/opt/install` por los que se deseen, sabiendo que el primero es el del anfitrión y el segundo el del container. El container se ejecutará en modo interactivo y abrirá una *shell*, sobre la que podremos empezar a trabajar. Después de haber cerrado la *shell*, podremos volver a abrirla con el siguiente comando:

```
docker start -it xm
```

## Compilar XtratuM

Dentro de la shell ofrecida por el container, podremos compilar XtratuM siguiendo el manual de usuario. La configuración mediante el menú gráfico se hace en este paso:

```
cd /opt/xtratum
make menuconfig
make
make distro-run
```

## Instalar XtratuM

Si queremos sacar los binarios compilados del container, necesitaremos instalar XtrauM en el directorio compartido:

```
$> cd /opt/xtratum
$> ./xtratum-2.6.0.run
Verifying archive integrity... All good.
Uncompressing XtratuM binary distribution 2.6.0:   100%
Starting installation.
Installation log in: /tmp/xtratum-installer-2003.log

Continue with the installation [Y/n]? Y

1.- Installation directory [/opt]: /opt/install/
2.- Path to the target toolchain [/usr/bin/]:
Warning! Destination path /opt/install exists. Installing will DESTROY ALL DATA.
Continue with the installation [Y/n]? Y

3.- Perform the installation using the above settings [Y/n]? Y

Installation completed.
```

## Compilar los ejemplos

Dentro del container podremos compilar los ejemplos, por ejemplo `hello_world`:

```
cd /opt/install
cd xal-examples
cd hello_world
make
```

El binario generado se podrá ya acceder desde el anfitrión en el directorio compartido, y podrá ejecutarse en un emulador o en hardware físico.
