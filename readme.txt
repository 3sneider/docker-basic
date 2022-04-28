curso de docker 

lo primero para empezar con docker es instalar docker, para ello vamos a su sitio oficial y lo descargamos segun sea el sistema operativo

docker.com - productos -instalamos la version segun el OS

para correr una imagen primero debemos tener identificada la imagen, para ello nos podemos apoyar en docker hub el cual tiene una extensa libreria de imagenes y en cada una nos dara las indicaciones para bajarrla

la manera estandar o comun de bajar una imagen por ejemplo postgres seria

*** docker pull [image]  
*** docker pull postgres

si corremos el comando run antes del pull este automaticamente baja la imagen primero y luego la corre

*** docker run [image]
*** docker run postgres

si queremos diferenciar la version de software podemos especificar un tag, esto no es obligatorio pero si te da una imagen mas especifica, el no agregar un tag te descargara la ultima version

*** docker run [image]:tag
*** docker run postgres:11.04

en algunos casos el contenedor te podra solicitar mas parametros para su configuracion, un ejemplo es la imagen de postgres que solicita una contraseña para la configuracion, en este caso seguimos las indicaciones que nos indique la imagen y asi de sencillo ya tenemos una imagen de postgres corriendo sin necesidad de tenerlo instalado

*** docker run postgres -e POSTGRES_PASSWORD=asdfg

los comandos mas comunes que podriamos utilizar aparte de pull y run serian las siguientes

*** docker images                     *** muestra las imagenes que tenga descargadas
*** docker images | head              *** muestra las primeras imagenes 
*** docker images | grep [IMAGE NAME] *** muestra las primeras imagenes que empiecen con un nombre parcial o completo
*** docker ps                         *** muestra las imagenes que estan corriendo actualmente
*** docker ps -a                      *** muestra las imagenes que han corrido en un tiempo corto
*** docker start [CONTAINER ID]       *** inicia un contenedor sinperder los datos 
*** docker logs [CONTAINER ID]        *** vemos los logs del contenedor
*** docker logs -f [CONTAINER ID]     *** queda escuchando los eventos futuros   
*** docker exec [CONTAINER ID]        *** ejecuto un comando sobre un contenedor que esta corriendo
*** docker exec -it [CONTAINER ID] sh *** ejecuta una terminal interactiva sobre el contenedor
*** docker stop [CONTAINER ID]        *** detiene la ejecucion de un contenedor
*** docker run -d [image]             *** ejecuta en background la imagen

como desarrollamos en docker,inicialmente necesitamos un archivo de nombre Dockerfile y solo si es necesario un .dockerignore

desde aqui vamos al archivo adjunto 

una ves se a creado el docker file procedemos a convertirlo en imagen 

*** docker build .

tambien se le puede pasar un tag para que lo podamos referenciaer en futuros

*** docker build -t [nombrecontenedor] .

una ves este cosntruida la imagen en local a podemos correrla con run, debemos especificar los puertos que estamos exponiendo desde}
la red de docker a nuestra red

*** docker run -d -p 3000:3000 [nombrecontenedor]

para persistir los datos del contenedor y que no cree uno nuevo

*** docker run -d -v /rutaLocal:/rutacontenedor -p 3000:3000 [nombrecontenedor]

una ves hallas creado la imagen y la decees compartir lo que haras es subirla a docker hub
para esto inicialmente te logueas en docker

*** docker login

subir las imagenes 

*** docker push creador/imagen:tag

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

ahora algo mas grande, como correr multiples contenedores que se hablen entre si, lo primero es crear 
una red de docker y que se puedan ver entre ellos

*** docker network create [nombre]

lo corremos de la siguiente forma 

*** docker run -d \                                         *** corre el contenedor en background
*** --network [nombreRed] --network-alias mysql \           *** damos un alias a la red para no tener que usar ip
*** -v /rutaLocal:/var/lib/mysql \                          *** asegurar que la data persista
*** -e MYSQL_ROOT_PASSWORD=secret \                         *** pasamos las variables de entorno requeridas
*** -e MYSQL_DATABASE=databaseName \
*** mysql:5.7                                               *** nombre de la imagen a correr con tag 

para corroborar la conexion corremos el docker y habrimos una terminar interactiva

*** docker exec -it [CONTAINER ID] mysql -p                 *** los comandos despues del id son los comandos del cliente

si queremos ejecutar una nueva imagen en la misma red podemos hacerlo de la siguiente manera 

*** docker run -it --network [nombreRed] nicolaka/netshoot  *** en weste caso tambien estamos abriendo la consola interactiva

como novedad esta imgen nos permiter validar la red a la que estamos apuntando con el comando

--- dig [networkAlias] *** aqui podriamos ver la ip de los contenedores

ahora digamos que queremos conectar una app node con nuestro contenedor mysql
lo corremos de la siguiente forma 

*** docker run -dp 3000:3000 \                              *** corre el contenedor en background por el puerto indicado
*** --network [nombreRed] \                                 *** indicamos la red a la que nos conectamos
*** -e MYSQL_HOST=mysql \                                   *** nos conectamos a la ip o host del otro contenedor
*** -e MYSQL_USER=root \                                    *** indicamos el usuario de la base de datos
*** -e MYSQL_ROOT_PASSWORD=secret \                         *** pasamos las variables de entorno requeridas
*** -e MYSQL_DATABASE=databaseName \
*** [imagen node o app]:25                                  *** nombre de la imagen a correr con tag

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

bueno, ahora como siempre, como ya aprendimos lo complejo, por que no aprendemos como hacerlo facil, siempre es bueno saber la forma nativa para cuando se presenten
casos extraordinarios que no podemos trabajar con herramientas mas modernas

para ello creamos un archivo llamado docker compose en el cual vamos a trabajar 

una ves se halla creado el docker compose para correrlo ejecutamos el comando

*** docker-compose up -d

para bajar los servicios ejecutamos el comando

*** docker-compose down

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

algo que nos puede complicar un poco la vida en este tema de los contenedores son los conceptos de 
puertos y volumentes, buenos pues asi fue como lo entendi

volumenes: puedes montar un directorio en el host y meterlo dentro del contenedor por ejemplo
en un contenedor ngnx vamos a meter un archivo a la carpeta de ngnex

*** docker run -v ./ruta/index.html:/usr/share/nginx/html/index.html ....

tambien puede pasar el directorio completo

*** docker run -v ./ruta/carpeta:/usr/share/nginx/html/ ...

si queremos que los archivos se monten read only ponemos el tag a la ruta :ro

*** docker run -v ./ruta/carpeta:/usr/share/nginx/html/:ro ...

para exponer tus archivos al expetrio lo hacemos desde el tafg -p desde el contenedor al host
el primero es el mio y el segundo es el de el contenedor

*** docker run -p 8080:80 

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

KUBERNETES es un orquestador decontenedores para escalamiento horizontal 
se crea un manifiesto  al cual se le solicita que le vante un pod con tantos contenedores con tantas replicas

los componentes de kubernetes son:

control plain: servidores de kubernetes 
kube proxi, toma el trafico y lo direcciona

como instalar kubernetes
descargamos el cliente de kubernetes kubectl de la pagina 
[https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/]

creo una carpeta en disco local C que se llame kube y pego el cliente,
en propiedades de este equipo, en configuracion avanzada 
en variables de entorno, en path, agregamos una nueva variable de entorno con el nombre de la carpeta
c:\kube y guardamos los cambios y desde el power shel ejecutamos el comando para validar la version

*** kubectl version --client=true

ahora para instalar el cluster de kubernetes si ya tenemos docker desktop lo que hacemos es i r a las preferencias y 
abilitar el uso de kubernetes, esto lo que va a hacer es que cuando inicie tu docker desktop va a iniciar tu cluster de kubernetes y 
a su ves te va a oermitir conectarte a tu cluster

una herramienta para trabajar con tu cliente de kubernet es minikube, pero este no te permite soporte en la nube
para este podemos usar digital ocean y desde ahi podemos descargar el condfig

ahora desde la terminal ejecutamos el diguiente comando para conectar nuestro cluster con nuestro cliente

*** export KUBECONFIG=~/ruta/config

una ves levante y concte ya podemosejecutar el siguiente comando para mostrar los nodos de nuestro cluster

*** kubectl get nodes

para ver nuestros contextos podemos usar el comando 

*** kubectl config get-contexts

si queremos ver los comandos mas basicos de nuestro kubectl ejecutamos

*** kubectl --help

los namespaces son diviciones logicas de los kubernetes, para ve nuestrso namespaces usamos el comando

*** kubectl get ns

un pot es uns et de contenedores, para poder ver nuestro pots usamos el comando

*** kubectl -n [kube-system/namespace] get pods
*** kubectl -n [kube-system/namespace] get pods -o wide     *** muestra mas informacin sobre los pots
*** kubectl -n [kube-system/namespace] delete pod [podName] *** elimina un pod de un namespace

aplicar un manifiesto de kubernetes

*** kubectl apply -f file.yaml








