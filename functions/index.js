const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(functions.config().functions);

var newData;

exports.myTrigger = functions.firestore.document('Messages/{id}')
.onCreate(async (snapshot, context) => {

    if (snapshot.empty) {
        console.log('No Devices');
        return;
    }

    newData = snapshot.data();

    const deviceIdTokens = await admin
            .firestore()
            .collection('DeviceTokens')
            .get();

        var tokens = [];

        var m = [];

        var mensaje = await snapshot.data().message;

        console.log('mensaje: ' + mensaje);
        console.log('snapshot.data: ' + snapshot.data().message);

        //mensaje = mensaje +"";

        for (var token of deviceIdTokens.docs) {
            tokens.push(token.data().device_token);
        }

        var payload = {
            notification: {
                title: 'Nuevo mensaje!',
                body: mensaje,
                sound: 'default',
            },
            data: {
                push_key: 'Push Key Value',
                key1: 'cnubqjZKRGqKXFRwUpgrpv:APA91bH0kJAqwOO8_cJmXabdL0w1rmwTx3XMndwon5GNSGE6yB9LSy0jexKwJWQkKiXqAy2ESkE7YbSyQ',
            },
        };

    try {
        const response = await admin.messaging().sendToDevice(tokens, payload);

              response.results.forEach((result, index) => {
                console.log('result ' + index + ': ' + result);

                const error = result.error;
                if (error) {
                  functions.logger.error(
                    'Failure sending notification to',
                    tokens[index],
                    error
                  );
                }
              });
        console.log('Notification sent successfully 2' + tokens[0]);

    } catch (err) {
        console.log(err);
    }
});