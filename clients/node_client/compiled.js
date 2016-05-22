'use strict';

var WebSocket = require('ws');
var url = 'ws://localhost:4000/socket/websocket';
var ws = new WebSocket(url);

ws.on('open', function open() {
    console.log("open socket");

    // const message = {
    //     topic: "users:" + 234,
    //     event: "phx_join",
    //     payload: {},
    //     ref: null
    // }

    var message = {
        topic: "test",
        event: "phx_join",
        payload: {},
        ref: null
    };

    ws.send(JSON.stringify(message));
});

ws.onmessage = function (msg) {
    var data = JSON.parse(msg.data);
    console.log("received data: ", data);
};
