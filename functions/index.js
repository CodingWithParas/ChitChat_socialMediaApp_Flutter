   const functions = require('firebase-functions');
   const admin = require('firebase-admin');
   admin.initializeApp();

   exports.sendNotificationOnMessage = functions.firestore
   .document('chat_rooms/{chatRoomId}/messages/{messageId}')
   .onCreate(async (snapshot, context) => {
        const message = snapshot.data();

        try {
            const receiverDoc = await admin.firestore().collection('Users').doc(message.receiverId).get()
            if (!receiverDoc.exists) {
                console.log('No such receiver!');
                return null;
            }

            const receiverData = receiverDoc.dta();
            const token = receiverData.fcmToken;

            if (!token) {
                console.log('No token for user, cannot send notification');
                return null;
            }

            // updated message payload for 'send' method
            const messagePayload = {
                token: token,
                notification: {
                    title: 'New Messgae',
                    body: '${message, senderEmail} says: ${message.message}',

                },
                android : {
                    notification: {
                        clickAction: 'FLUTTER_NOTIFICATION_CLICK'
                    }
                }
                apns: {
                    payload: {
                        aps: {
                            category : 'FLUTTER_NOTIFICATION_CLICK'
                        }
                    }
                }
            };

            // send notification
            const response = await admin.messaging().send(messagePayload);
            console.log('Notification sent successfully:', response);
            return response;
        } catch (error) {
            console.error('Detailed error:', error);
            if (error.code && error.message) {
                console.error('Error code:', error.code);
                console.error('Error message:', error.message);
            }
            throw new Error('Failed to send notification');
        }
   })