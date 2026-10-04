function config(){

    // credenciales

    var user = 'geanmarcos.tataje@gmail.com';
    var password = 'TestingJB$.';

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