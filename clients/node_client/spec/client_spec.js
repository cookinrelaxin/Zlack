/// test stuff
var vows = require('vows');
var assert = require('assert');
///
/// ws stuff
var WebSocket = require('ws')
var url = 'ws://localhost:4000/socket/websocket'
///
var client = require('../index.js')
vows.describe('Zlack NodeJS client').addBatch({
    'When I join the test topic': {
        'with event "phx_join", no payload, and a null ref': {
            topic: JSON.stringify({
                topic: "test",
                event: "phx_join",
                payload: {},
                ref: null
            }),
            'I receive a response with status "ok"': function (message) {
                var ws = new WebSocket(url)
                ws.on('open', function open() {
                    ws.send(message);
                });

                ws.onmessage = function(msg) {
                    const data = JSON.parse(msg.data)
                    assert.equal(data.payload.status, "ok")
                    ws.close()
                }
            }
        }
    },
    'When I connect to the websocket endpoint' : {
        "and I join the guest channel" : {
            'I receive a response with status "ok"': function () {
                var ws = new WebSocket(url)
                ws.on('open', function open() {
                    client.join_channel("guest", {}, ws);
                });

                ws.onmessage = function(msg) {
                    const data = JSON.parse(msg.data)
                    assert.equal(data.payload.status, "ok")
                    ws.close()
                }
            },
            'I receive a JWT' : function (out_message) {
                var ws = new WebSocket(url)
                ws.on('open', function open() {
                    client.join_channel("guest", {}, ws);
                });

                ws.onmessage = function(in_message) {
                    const data = JSON.parse(in_message.data);
                    assert.include(data.payload.response, 'jwt');
                    ws.close()
                }
            },
            'and a guest username' : function (out_message) {
                var ws = new WebSocket(url)
                ws.on('open', function open() {
                    client.join_channel("guest", {}, ws);
                });

                ws.onmessage = function(in_message) {
                    const data = JSON.parse(in_message.data);
                    assert.include(data.payload.response, 'username')
                    ws.close()
                }
            },
            'and a user ID' : function (out_message) {
                var ws = new WebSocket(url)
                ws.on('open', function open() {
                    client.join_channel("guest", {}, ws);
                });

                ws.onmessage = function(in_message) {
                    const data = JSON.parse(in_message.data);
                    assert.include(data.payload.response, 'id')
                    ws.close()
                }
            },
            // 'and I send a message with event create_permanent_user': {
            //     'and the payload contains a new username and 3 secret questions and answers': {
            //         topic: JSON.stringify({
            //             topic: "guest",
            //             event: "phx_join",
            //             payload: {},
            //             ref: null
            //         }),
            //         'I receive a response with status "ok"' : function (join_message) {
            //             var ws = new WebSocket(url)
            //             ws.on('open', function open() {
            //                 ws.send(join_message);
            //             });

            //             ws.onmessage = function(in_message) {
            //                 const data = JSON.parse(in_message.data);
            //                 console.log("data: ", data);

            //                 switch (data.event) {
            //                     case "phx_reply": {
            //                         jwt = data.payload.response.jwt;
            //                         username = data.payload.response.username;

            //                         create_permanent_user_message = JSON.stringify({
            //                                                 topic: "guest",
            //                                                 event: "create_permanent_user",
            //                                                 payload: {
            //                                                     jwt: jwt,
            //                                                     old_username: username,
            //                                                     new_username: "dGillespie",
            //                                                     secret_question_1: "What was the name of my first dog?",
            //                                                     secret_answer_1: "Charlie",
            //                                                     secret_question_2: "What was the name of the street of my first home that I can remember?",
            //                                                     secret_answer_2: "knotty oak",
            //                                                     secret_question_3: "Who is my dad's favorite musician?",
            //                                                     secret_answer_3: "Bruce Springsteen"
            //                                                 },
            //                                                 ref: null
            //                         });

            //                         ws.send(create_permanent_user_message);
            //                         break;
            //                     }
            //                     case "create_permanent_user": {
            //                         //assert.isTrue(true)


            //                         ws.close()
            //                         break;
            //                     }

            //                 }

            //             }
            //         },
            //         'and I receive receive my private password' : function (out_message) {
            //             flunk()
            //         }
            //     }

            // }
            // 'and a guest account expiration date' : function (out_message) {
            //     var ws = new WebSocket(url)
            //     ws.on('open', function open() {
            //         ws.send(out_message);
            //     });

            //     ws.onmessage = function(in_message) {
            //         const data = JSON.parse(in_message.data);
            //         assert.include(data.payload.response, 'expiration_date')
            //         ws.close()
            //     }
            // },

        },
        "and I have a valid JWT, user ID, and username" : {
            "I can join my private user channel and receive a response with status 'ok'" : function () {
                var ws = new WebSocket(url);
                ws.on('open', function open() {
                    client.join_channel("guest", {}, ws)
                });

                ws.onmessage = function(in_message) {
                    const data = JSON.parse(in_message.data);
                    if (data.topic === 'guest') {
                        const id = data.payload.response.id;
                        const jwt = data.payload.response.jwt;
                        const username = data.payload.response.username;
                        client.join_user_channel(id, jwt, username, ws);
                    }
                    else {
                        assert.equal(data.payload.status, "ok")
                        ws.close()
                    }

                }
            }
        },
        "and I join my user channel" : {
            "and send a message with event 'create_room'" : {
                'and the payload contains "is_publicly_searchable": false' : {
                    'I receive a response with status "ok"' : function () {
                        var ws = new WebSocket(url);
                        ws.on('open', function open() {
                            client.join_channel("guest", {}, ws)
                        });

                        var id = ""
                        var jwt = ""
                        var username = ""

                        ws.onmessage = function(in_message) {
                            const data = JSON.parse(in_message.data);
                            if (data.topic === 'guest') {
                                id = data.payload.response.id;
                                jwt = data.payload.response.jwt;
                                username = data.payload.response.username;
                                client.join_user_channel(id, jwt, username, ws);
                            }
                            else if ((data.topic === ('users:'+id)) && (data.event === 'phx_reply')) { 
                                client.create_room({
                                    user_id: id,
                                    room_title: "BanefulDomain",
                                    room_subtitle: "just a hangout place",
                                    is_publicly_searchable: false,
                                    permissions: "must_be_invited"
                                }, ws);
                            }
                            else {
                                assert.equal(data.payload.status, "ok")
                                ws.close()
                            }

                        }
                    }
                },
                'and the payload contains "is_publicly_searchable": true' : {
                    'I receive a response with status "ok"' : function () {
                        var ws = new WebSocket(url);
                        ws.on('open', function open() {
                            client.join_channel("guest", {}, ws)
                        });

                        var id = ""
                        var jwt = ""
                        var username = ""

                        ws.onmessage = function(in_message) {
                            const data = JSON.parse(in_message.data);
                            if (data.topic === 'guest') {
                                id = data.payload.response.id;
                                jwt = data.payload.response.jwt;
                                username = data.payload.response.username;
                                client.join_user_channel(id, jwt, username, ws);
                            }
                            else if ((data.topic === ('users:'+id)) && (data.event === 'phx_reply')) { 
                                client.create_room({
                                    user_id: id,
                                    room_title: "BanefulDomain",
                                    room_subtitle: "just a hangout place",
                                    is_publicly_searchable: true,
                                    permissions: "must_be_invited"
                                }, ws);
                            }
                            else {
                                assert.equal(data.payload.status, "ok")
                                ws.close()
                            }

                        }
                    }
                },
                'and the payload contains "permissions": "may_request_read_write_subscription"' : {
                    'I receive a response with status "ok"' : function () {
                        var ws = new WebSocket(url);
                        ws.on('open', function open() {
                            client.join_channel("guest", {}, ws)
                        });

                        var id = ""
                        var jwt = ""
                        var username = ""

                        ws.onmessage = function(in_message) {
                            const data = JSON.parse(in_message.data);
                            if (data.topic === 'guest') {
                                id = data.payload.response.id;
                                jwt = data.payload.response.jwt;
                                username = data.payload.response.username;
                                client.join_user_channel(id, jwt, username, ws);
                            }
                            else if ((data.topic === ('users:'+id)) && (data.event === 'phx_reply')) { 
                                client.create_room({
                                    user_id: id,
                                    room_title: "BanefulDomain",
                                    room_subtitle: "just a hangout place",
                                    is_publicly_searchable: true,
                                    permissions: "may_request_read_write_subscription"
                                }, ws);
                            }
                            else {
                                assert.equal(data.payload.status, "ok")
                                ws.close()
                            }

                        }
                    }
                },
                'and the payload contains "permissions": "may_request_read_subscription"' : {
                    'I receive a response with status "ok"' : function () {
                        var ws = new WebSocket(url);
                        ws.on('open', function open() {
                            client.join_channel("guest", {}, ws)
                        });

                        var id = ""
                        var jwt = ""
                        var username = ""

                        ws.onmessage = function(in_message) {
                            const data = JSON.parse(in_message.data);
                            if (data.topic === 'guest') {
                                id = data.payload.response.id;
                                jwt = data.payload.response.jwt;
                                username = data.payload.response.username;
                                client.join_user_channel(id, jwt, username, ws);
                            }
                            else if ((data.topic === ('users:'+id)) && (data.event === 'phx_reply')) { 
                                client.create_room({
                                    user_id: id,
                                    room_title: "BanefulDomain",
                                    room_subtitle: "just a hangout place",
                                    is_publicly_searchable: true,
                                    permissions: "may_request_read_subscription"
                                }, ws);
                            }
                            else {
                                assert.equal(data.payload.status, "ok")
                                ws.close()
                            }

                        }
                    }
                },
                'and the payload contains "permissions": "auto_grant_read_write_subscription"' : {
                    'I receive a response with status "ok"' : function () {
                        var ws = new WebSocket(url);
                        ws.on('open', function open() {
                            client.join_channel("guest", {}, ws)
                        });

                        var id = ""
                        var jwt = ""
                        var username = ""

                        ws.onmessage = function(in_message) {
                            const data = JSON.parse(in_message.data);
                            if (data.topic === 'guest') {
                                id = data.payload.response.id;
                                jwt = data.payload.response.jwt;
                                username = data.payload.response.username;
                                client.join_user_channel(id, jwt, username, ws);
                            }
                            else if ((data.topic === ('users:'+id)) && (data.event === 'phx_reply')) { 
                                client.create_room({
                                    user_id: id,
                                    room_title: "BanefulDomain",
                                    room_subtitle: "just a hangout place",
                                    is_publicly_searchable: true,
                                    permissions: "auto_grant_read_subscription"
                                }, ws);
                            }
                            else {
                                assert.equal(data.payload.status, "ok")
                                ws.close()
                            }

                        }
                    }
                },
                'and the payload contains "permissions": "auto_grant_read_subscription"' : {
                    'I receive a response with status "ok"' : function () {
                        var ws = new WebSocket(url);
                        ws.on('open', function open() {
                            client.join_channel("guest", {}, ws)
                        });

                        var id = ""
                        var jwt = ""
                        var username = ""

                        ws.onmessage = function(in_message) {
                            const data = JSON.parse(in_message.data);
                            if (data.topic === 'guest') {
                                id = data.payload.response.id;
                                jwt = data.payload.response.jwt;
                                username = data.payload.response.username;
                                client.join_user_channel(id, jwt, username, ws);
                            }
                            else if ((data.topic === ('users:'+id)) && (data.event === 'phx_reply')) { 
                                client.create_room({
                                    user_id: id,
                                    room_title: "BanefulDomain",
                                    room_subtitle: "just a hangout place",
                                    is_publicly_searchable: true,
                                    permissions: "auto_grant_read_subscription"
                                }, ws);
                            }
                            else {
                                assert.equal(data.payload.status, "ok")
                                ws.close()
                            }

                        }
                    }
                },
                'and the payload contains "permissions": "must_be_invited"' : {
                    'I receive a response with status "ok"' : function () {
                        var ws = new WebSocket(url);
                        ws.on('open', function open() {
                            client.join_channel("guest", {}, ws)
                        });

                        var id = ""
                        var jwt = ""
                        var username = ""

                        ws.onmessage = function(in_message) {
                            const data = JSON.parse(in_message.data);
                            if (data.topic === 'guest') {
                                id = data.payload.response.id;
                                jwt = data.payload.response.jwt;
                                username = data.payload.response.username;
                                client.join_user_channel(id, jwt, username, ws);
                            }
                            else if ((data.topic === ('users:'+id)) && (data.event === 'phx_reply')) { 
                                client.create_room({
                                    user_id: id,
                                    room_title: "BanefulDomain",
                                    room_subtitle: "just a hangout place",
                                    is_publicly_searchable: true,
                                    permissions: "must_be_invited"
                                }, ws);
                            }
                            else {
                                assert.equal(data.payload.status, "ok")
                                ws.close()
                            }

                        }
                    }
                },
                'and the payload contains "room_title": "insert any room title here"' : {
                    'I receive a response with status "ok"' : function () {
                        var ws = new WebSocket(url);
                        ws.on('open', function open() {
                            client.join_channel("guest", {}, ws)
                        });

                        var id = ""
                        var jwt = ""
                        var username = ""

                        ws.onmessage = function(in_message) {
                            const data = JSON.parse(in_message.data);
                            if (data.topic === 'guest') {
                                id = data.payload.response.id;
                                jwt = data.payload.response.jwt;
                                username = data.payload.response.username;
                                client.join_user_channel(id, jwt, username, ws);
                            }
                            else if ((data.topic === ('users:'+id)) && (data.event === 'phx_reply')) { 
                                client.create_room({
                                    user_id: id,
                                    room_title: "insert any room title here",
                                    room_subtitle: "just a hangout place",
                                    is_publicly_searchable: true,
                                    permissions: "may_request_read_write_subscription"
                                }, ws);
                            }
                            else {
                                assert.equal(data.payload.status, "ok")
                                ws.close()
                            }

                        }
                    }
                },
                'and the payload contains "room_subtitle": "insert any room subtitle here"' : {
                    'I receive a response with status "ok"' : function () {
                        var ws = new WebSocket(url);
                        ws.on('open', function open() {
                            client.join_channel("guest", {}, ws)
                        });

                        var id = ""
                        var jwt = ""
                        var username = ""

                        ws.onmessage = function(in_message) {
                            const data = JSON.parse(in_message.data);
                            if (data.topic === 'guest') {
                                id = data.payload.response.id;
                                jwt = data.payload.response.jwt;
                                username = data.payload.response.username;
                                client.join_user_channel(id, jwt, username, ws);
                            }
                            else if ((data.topic === ('users:'+id)) && (data.event === 'phx_reply')) { 
                                client.create_room({
                                    user_id: id,
                                    room_title: "BanefulDomain",
                                    room_subtitle: "insert any room subtitle here",
                                    is_publicly_searchable: true,
                                    permissions: "may_request_read_write_subscription"
                                }, ws);
                            }
                            else {
                                assert.equal(data.payload.status, "ok")
                                ws.close()
                            }

                        }
                    }
                },
                'and the payload has a different "is_publicly_searchable" field' : {
                    'I receive a response with status "error: invalid is_publicly_searchable"' : function () {
                        var ws = new WebSocket(url);
                        ws.on('open', function open() {
                            client.join_channel("guest", {}, ws)
                        });

                        var id = ""
                        var jwt = ""
                        var username = ""

                        ws.onmessage = function(in_message) {
                            const data = JSON.parse(in_message.data);
                            if (data.topic === 'guest') {
                                id = data.payload.response.id;
                                jwt = data.payload.response.jwt;
                                username = data.payload.response.username;
                                client.join_user_channel(id, jwt, username, ws);
                            }
                            else if ((data.topic === ('users:'+id)) && (data.event === 'phx_reply')) { 
                                client.create_room({
                                    user_id: id,
                                    room_title: "BanefulDomain",
                                    room_subtitle: "just a hangout place",
                                    is_publicly_searchable: "maybe",
                                    permissions: "may_request_read_write_subscription"
                                }, ws);
                            }
                            else {
                                assert.equal(data.payload.status, "error: invalid is_publicly_searchable")
                                ws.close()
                            }

                        }
                    }
                },
                'and the payload has a different "permissions" field' : {
                    'I receive a response with status "error: invalid permissions"' : function () {
                        var ws = new WebSocket(url);
                        ws.on('open', function open() {
                            client.join_channel("guest", {}, ws)
                        });

                        var id = ""
                        var jwt = ""
                        var username = ""

                        ws.onmessage = function(in_message) {
                            const data = JSON.parse(in_message.data);
                            if (data.topic === 'guest') {
                                id = data.payload.response.id;
                                jwt = data.payload.response.jwt;
                                username = data.payload.response.username;
                                client.join_user_channel(id, jwt, username, ws);
                            }
                            else if ((data.topic === ('users:'+id)) && (data.event === 'phx_reply')) { 
                                client.create_room({
                                    user_id: id,
                                    room_title: "BanefulDomain",
                                    room_subtitle: "just a hangout place",
                                    is_publicly_searchable: true,
                                    permissions: "anybody can do anything they want :)"
                                }, ws);
                            }
                            else {
                                assert.equal(data.payload.status, "error: invalid permissions")
                                ws.close()
                            }

                        }
                    }
                },
                'and the "room_title" field in the payload is an empty string' : {
                    'I receive a response with status "error: room_title must not be empty""' : function () {
                        var ws = new WebSocket(url);
                        ws.on('open', function open() {
                            client.join_channel("guest", {}, ws)
                        });

                        var id = ""
                        var jwt = ""
                        var username = ""

                        ws.onmessage = function(in_message) {
                            const data = JSON.parse(in_message.data);
                            if (data.topic === 'guest') {
                                id = data.payload.response.id;
                                jwt = data.payload.response.jwt;
                                username = data.payload.response.username;
                                client.join_user_channel(id, jwt, username, ws);
                            }
                            else if ((data.topic === ('users:'+id)) && (data.event === 'phx_reply')) { 
                                client.create_room({
                                    user_id: id,
                                    room_title: "",
                                    room_subtitle: "just a hangout place",
                                    is_publicly_searchable: true,
                                    permissions: "anybody can do anything they want :)"
                                }, ws);
                            }
                            else {
                                assert.equal(data.payload.status, "error: room_title must not be empty")
                                ws.close()
                            }

                        }
                    }
                },
                'and the "room_subtitle" field in the payload is an empty string' : {
                    'I receive a response with status "error: room_subtitle must not be empty"' : function () {
                        var ws = new WebSocket(url);
                        ws.on('open', function open() {
                            client.join_channel("guest", {}, ws)
                        });

                        var id = ""
                        var jwt = ""
                        var username = ""

                        ws.onmessage = function(in_message) {
                            const data = JSON.parse(in_message.data);
                            if (data.topic === 'guest') {
                                id = data.payload.response.id;
                                jwt = data.payload.response.jwt;
                                username = data.payload.response.username;
                                client.join_user_channel(id, jwt, username, ws);
                            }
                            else if ((data.topic === ('users:'+id)) && (data.event === 'phx_reply')) { 
                                client.create_room({
                                    user_id: id,
                                    room_title: "BanefulDomain",
                                    room_subtitle: "",
                                    is_publicly_searchable: true,
                                    permissions: "may_request_read_write_subscription"
                                }, ws);
                            }
                            else {
                                assert.equal(data.payload.status, "error: room_subtitle must not be empty")
                                ws.close()
                            }

                        }
                    }
                }
            },
            'and send a message with event "find_users_and_channels' : {
                'and the payload contains "query": "<insert any search query here>"' : {
                    'I received a sorted list of users and channels most relevant to my search query' : function () {
                        flunk()
                    }
                },
                'and the payload contains "query": null' : {
                    'I received a sorted list of most popular users and channels' : function () {
                        flunk()
                    }
                }
            }
        },
        "and I join a room channel" : {
            "other users in the room channel receive a notification that I joined" : function () {
                flunk()
            },
            "and I post a message to the channel" : {
                "then other users in channel receive my message" : function () {
                    flunk()
                }
            },
            "and another user posts a message to the channel" : {
                "I receive their message" : function () {
                    flunk()
                },
                "Then a third user also receives their message" : function () {
                    flunk()
                }
            },
            "I receive a page of the most recent messages posted to that channel" : function () {
                flunk()
            },
            "and I request a page of messages posted to that channel, then I receive them" : function () {
                flunk()
            },
            "I receive a list of all of the users subscribed to that channel" : function () {
                flunk()
            },
            "and the users currently connected to that channel are indicated" : function () {
                flunk()
            },
            "and another user leaves the channel" : {
                "I receive a notification that they left" : function () {
                    flunk()
                },
                "and a third user also receives the message" : function () {
                    flunk()
                }
            },
            "and I leave the channel" : {
                "then other users in that channel receive a notification that I left" : function () {
                    flunk()
                }
            },
        }
    }
}).export(module)

function flunk() {
    assert.isTrue(false)
}
