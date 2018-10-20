const functions = require('firebase-functions');

// The Firebase Admin SDK to access the Firebase Realtime Database.
const admin = require('firebase-admin');
admin.initializeApp();

// Create and Deploy Your First Cloud Functions
// https://firebase.google.com/docs/functions/write-firebase-functions

exports.helloWorld = functions.https.onRequest((request, response) => {
 response.send("Hello from Firebase!");
});

exports.addMemo = functions.https.onRequest((req, res) => {
    if (req.method !== 'POST') {
        res.status(405).send('Method Not Allowed');
        return;
    }
    // JsonParse
    // const obj = JSON.parse(req.body);
    const src = req.body.src;

    res.status(200).send(src);
});

exports.addMessage = functions.https.onRequest((req, res) => {
    // Grab the text parameter.
    const original = req.query.text;
    // Push the new message into the Realtime Database using the Firebase Admin SDK.
    return admin.database().ref('/messages').push({ original: original }).then((snapshot) => {
        // Redirect with 303 SEE OTHER to the URL of the pushed object in the Firebase console.
        return res.redirect(303, snapshot.ref.toString());
    });
});

exports.makeUppercase = functions.database.ref('/messages/{pushId}/original')
    .onCreate((snapshot, context) => {
        // Grab the current value of what was written to the Realtime Database.
        const original = snapshot.val();
        console.log('Uppercasing', context.params.pushId, original);
        const uppercase = original.toUpperCase();
        // You must return a Promise when performing asynchronous tasks inside a Functions such as
        // writing to the Firebase Realtime Database.
        // Setting an "uppercase" sibling in the Realtime Database returns a Promise.
        return snapshot.ref.parent.child('uppercase').set(uppercase);
    });

exports.getImages = functions.https.onRequest((req, res) => {
    // Grab the text parameter.
    const id = req.query.id;
    // Push the new message into the Realtime Database using the Firebase Admin SDK.
    return admin.database().ref(`/users/${id}/images`).once('value').then(data => {
        res.status(200).send(data)
    })
    .catch(error => {
        res.status(404).send({ message: 'Not Found' })
    })
});

exports.addImages = functions.https.onRequest((req, res) => {
    const date = new Date();
    const id = req.query.id;
    const today = date.getFullYear() + "/" + date.getMonth() + 1 + "/" + date.getDate();
    const time = date.getHours() + ":" + date.getMinutes();
    const from = 'amazon';
    const name = 'mac';
    const src = req.body.src;
    const inInbox = "True";
    const type = req.body.type;

    // Push the new message into the Realtime Database using the Firebase Admin SDK.
    return admin.database().ref(`/users/${id}/images`).push({
        date : today,
        from,
        name,
        src,
        inInbox,
        time,
        type
    }).then((snapshot) => {
        // Redirect with 303 SEE OTHER to the URL of the pushed object in the Firebase console.
        return res.redirect(303, snapshot.ref.toString());
    });
});

exports.takeOutPost = functions.https.onRequest((req, res) => {
    // Grab the text parameter.
    const id = req.query.id;
    // Push the new message into the Realtime Database using the Firebase Admin SDK.
    return admin.database().ref(`/users/${id}/images`).once('value').then(data => {
        const obj = data.val();
        Object.keys(obj).forEach(function (k) {
            admin.database().ref(`/users/${id}/images`).update({
                [`${k}/inInbox`]: false
            })
                .catch(error => {
                    res.status(404).send({ message: 'Not Found' })
                })
        });
        res.status(200).send('SUCCESS！');
    })
        .catch(error => {
            res.status(404).send({ message: 'Not Found' })
        })
});

exports.randomTakeInPost = functions.https.onRequest((req, res) => {
    // Grab the text parameter.
    const id = req.query.id;
    // Push the new message into the Realtime Database using the Firebase Admin SDK.
    return admin.database().ref(`/users/${id}/images`).once('value').then(data => {
        const obj = data.val();
        Object.keys(obj).forEach(function (k) {
            admin.database().ref(`/users/${id}/images`).update({
                [`${k}/inInbox`]: Math.floor(Math.random() * 2 + 1) === 1 ? true : false
            })
                .catch(error => {
                    res.status(404).send({ message: 'Not Found' })
                })
        });
        res.status(200).send('SUCCESS！');
    })
        .catch(error => {
            res.status(404).send({ message: 'Not Found' })
        })
});