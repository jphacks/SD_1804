'use strict';

import * as functions from 'firebase-functions'
import * as admin from 'firebase-admin'

const fetch = require('node-fetch')

admin.initializeApp();

export const helloWorld = functions.https.onRequest((request, response) => {
 response.send('Hello from Firebase!\n\n');
});

export const addMemo = functions.https.onRequest((req, res) => {
    if (req.method !== 'POST') {
        res.status(405).send('Method Not Allowed');
        return;
    }
    const src = req.body.src;

    res.status(200).send(src);
});

export const addMessage = functions.https.onRequest((req, res) => {
    // Grab the text parameter.
    const original = req.query.text;
    // Push the new message into the Realtime Database using the Firebase Admin SDK.
    return admin.database().ref('/messages').push({ original: original }).then((snapshot) => {
        // Redirect with 303 SEE OTHER to the URL of the pushed object in the Firebase console.
        return res.redirect(303, snapshot.ref.toString());
    });
});

export const makeUppercase = functions.database.ref('/messages/{pushId}/original')
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

export const getImages = functions.https.onRequest((req, res) => {
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

export const addImages = functions.https.onRequest((req, res) => {
    const date = new Date();
    const id = req.query.id;
    const today = `${date.getFullYear()}/${date.getMonth() + 1}/${date.getDate()}`;
    const time = `${date.getHours() + 9}:${date.getMinutes()}`;
    const from = 'amazon';
    const name = 'mac';
    console.log("id", id)
    // const src = req.body.src;
    const src1 = req.body.src1;
    const src2 = req.body.src2;
    const inInbox = true;
    const type = req.body.type;

    try {

        // Push the new message into the Realtime Database using the Firebase Admin SDK.
        return admin.database().ref(`/users/${id}/images`).push({
            date : today,
            from,
            name,
            'src1': src1,
            'src2': src2,
            inInbox,
            time,
            type
        }).then((snapshot) => {
            // Redirect with 303 SEE OTHER to the URL of the pushed object in the Firebase console.
            // return res.redirect(303, snapshot.ref.toString());
            return res.status(200).send('SUCCESS！');
        })
    } catch (error) {
        return res.status(404).send({ id, error, message: 'Not Found' })
    }
});

export const takeOutPost = functions.https.onRequest((req, res) => {
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
                return res.status(404).send({ message: 'Not Found' })
            })
        });
        return res.status(200).send('SUCCESS！');
    })
    .catch(error => {
        return res.status(404).send({ message: 'Not Found' })
    })
});

export const randomTakeInPost = functions.https.onRequest((req, res) => {
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
                return res.status(404).send({ message: 'Not Found' })
            })
        });
        return res.status(200).send('SUCCESS！');
    })
    .catch(error => {
        return res.status(404).send({ message: 'Not Found' })
    })
});

export const ocrParse = functions.https.onRequest(async (req, res) => {
    // const id = req.query.id;
    const src1 = req.body.src1;
    const src2 = req.body.src2;
    // console.log(req.body.src)
    const endPoint =`https://vision.googleapis.com/v1/images:annotate?key=${functions.config().vision.key}`;
    try {
        const rawResponse = await fetch(endPoint, {
            method: "POST",
            mode: "cors",
            headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                requests: [
                    {
                        image: {
                            content: src1
                        },
                        "features": [
                            {
                                "type": "TEXT_DETECTION",
                                "maxResults": 1
                            }
                        ]
                    },
                    {
                        image: {
                            content: src2
                        },
                        "features": [
                            {
                                "type": "TEXT_DETECTION",
                                "maxResults": 1
                            }
                        ]
                    }
                ]
            })
        })
        const content = await rawResponse.json();
        // console.log({content})
        console.log("1: \n\n", content.responses[0], "2: \n\n", content.responses[1]);
        return res.status(200).send("OK")

    } catch (error) {
        // console.error(error)
        console.error('ERROR:', error)
        return res.status(404).send({ message: 'Not Found'})
    }
})

