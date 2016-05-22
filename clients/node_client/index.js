const join_channel = function (channel_name, payload, socket) {
    message = JSON.stringify({
        topic: channel_name,
        event: "phx_join",
        payload: payload, 
        ref: null
    });
    socket.send(message)
    return;
}

const join_user_channel = function (user_id, jwt, username, socket) {
    const channel_name = "users:"+user_id
    const payload = {
        jwt: jwt,
        username: username
    }
    join_channel(channel_name, payload, socket);
}

const create_room = function ({
        user_id,
        room_title,
        room_subtitle,
        is_publicly_searchable,
        permissions
    }, socket) {
    message = JSON.stringify({
        topic: "users:"+user_id,
        event: "create_room",
        payload: {
            room_title: room_title,
            room_subtitle: room_subtitle,
            is_publicly_searchable: is_publicly_searchable,
            permissions: permissions
        }, 
        ref: null
    });
    socket.send(message)
};
module.exports = {
    join_channel: join_channel,
    join_user_channel: join_user_channel,
    create_room: create_room
}
