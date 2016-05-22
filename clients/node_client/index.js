var WebSocket = require('ws')
var url = 'ws://localhost:4000/socket/websocket'

function zLACK_Client() {
    this.username = "";
    this.jwt = "";
    this.user_id = "";
    this.socket = new WebSocket(url);

    //receive ws messages from server
    //not sure if necessary
    //the risk is that messages will be received by the client before the user creates a pattern match for that message. in that case the user will never get the message
    //this._inbox = [];

    //store pattern matches called via onMessage
    this._matches = [];

    var matches = this._matches;
    this.socket.onmessage = function (msg) {
        const message = JSON.parse(msg.data);
        //console.log("message: ", message);
        const pattern = {
            topic: message.topic,
            event: message.event
        };

        for (var i=0; i < matches.length; i++){
            var match = matches[i];
            //console.log("match: ", match);
            if (patterns_equal(pattern, match.pattern)) {
                matches.splice(i, 1);
                match.callback(message);
                break;
            }
        }

    };
}

function patterns_equal(p1, p2) {
    return p1.topic === p2.topic && p1.event == p2.event;
};

zLACK_Client.prototype.onConnect = function (cb) {
    this.socket.on('open', cb);
    return;
}

zLACK_Client.prototype.join_channel = function ({channel_name, payload}) {
    message = JSON.stringify({
        topic: channel_name,
        event: "phx_join",
        payload: payload, 
        ref: null
    });
    this.socket.send(message);
    return;
}

zLACK_Client.prototype.onMessage = function ({topic, event}, cb) {

    // console.log("topic: ", topic);
    // console.log("event: ", event);

    this._matches.push({
        pattern: {topic, event},
        callback: cb
    });

}

zLACK_Client.prototype.disconnect = function () {
    this.socket.close();
}

zLACK_Client.prototype.create_room = function ({room_title,
                                                room_subtitle,
                                                is_publicly_searchable,
                                                permissions
                                            }) {
    message = JSON.stringify({
        topic: "users:" + this.user_id,
        event: "create_room",
        payload: {
            room_title: room_title,
            room_subtitle: room_subtitle,
            is_publicly_searchable: is_publicly_searchable,
            permissions: permissions
        }, 
        ref: null
    });
    this.socket.send(message)
};

const join_room_channel = function (room_id) {
    const channel_name = "rooms:"+room_id
    const payload = {}
    join_channel(channel_name, payload, socket);
}

module.exports = zLACK_Client;
