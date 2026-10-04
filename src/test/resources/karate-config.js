function config(){

    var env = karate.env || 'qa';
    karate.log('karate.env:', env);

    // credenciales
    var user = java.lang.System.getenv('USERNAME_TODOLY');
    var password = java.lang.System.getenv('PASSWORD_TODOLY');

    // Validar que las variables no vengan vacías
    if (!user || !password) {
        karate.log('⚠️ Alerta: USERNAME_TODOLY o PASSWORD_TODOLY no están definidos');
    }


    //convertir a base64
    var JString = Java.type('java.lang.String');
    var Base64 = Java.type('java.util.Base64');
    var encoded = Base64.getEncoder().encodeToString(new JString(user + ':' + password).getBytes());

    var config = {
        baseUrl: 'https://todo.ly',
        basicAuth: 'Basic ' + encoded
    }

    return config;
}