importScripts('https://www.gstatic.com/firebasejs/10.7.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.7.0/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: "AIzaSyAKcsTikyo_GhUZBWVf3uc918iS3QnQNdQ",
  projectId: "astro-solutions-545de",
  messagingSenderId: "924726132588",
  appId: "1:924726132588:web:080e16fb3568f0fdd5bd49"
});

const messaging = firebase.messaging();