# la primera linea siempre debe ser un form  para usar una imagen padre

# recuerde que si no le agrega un tag :*** este por defecto tomara la ultima version
# alpine es la distribucion de linux mas usada por que es muy liviana, aveces desplegamos maquinas super gigantes solo con el fin de desplegar una 
# aplicacion muy liviana y esto se ve traducido en costos
FROM node:17-alpine3.12

# donde vamos a hacer todo nuestro trabajo
WORKDIR /app

# ahora copiamos todos los archivos que esten en donde esta este docker file a nuestro raiz
# tambien se puede direccionar a otra ruta de la siguiente manera 
# ["src/Api/Api.csproj", "src/Api/"], teniendo encuenta que nuestro workdir sera src
# el primer punto es desde y el segunndo punto es hacia
COPY . .

# ester comando lo que va a hacer practicamente es una compilacion de nuestro codigo en node
RUN yarn install --production

# finalmente al final de cada maquina debemos especificar el comando que va a correr
CMD ["node", "app/src/index.js"]

