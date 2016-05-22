/// test stuff
var vows = require('vows');
var assert = require('assert');
///
/// ws stuff
//var WebSocket = require('ws')
//var url = 'ws://localhost:4000/socket/websocket'
///
var Client = require('../index.js')
vows.describe('Zlack NodeJS client').addBatch({
    'When I connect to the websocket endpoint' : {
        "and I join the guest channel" : {
            'I receive a response with status "ok"': function () {
                const client = connect_and_create_guest();

                client.onMessage({topic: "guest", event: "phx_reply"}, function (message) {
                    assert.equal(message.payload.status, "ok");
                    client.disconnect();
                });
            },
            'I receive a JWT' : function (out_message) {
                const client = connect_and_create_guest();

                client.onMessage({topic: "guest", event: "phx_reply"}, function (message) {
                    assert.include(message.payload.response, 'jwt');
                    client.disconnect();
                });
            },
            'and a guest username' : function (out_message) {
                const client = connect_and_create_guest();

                client.onMessage({topic: "guest", event: "phx_reply"}, function (message) {
                    assert.include(message.payload.response, 'username');
                    client.disconnect();
                });
            },
            'and a user ID' : function (out_message) {
                const client = connect_and_create_guest();

                client.onMessage({topic: "guest", event: "phx_reply"}, function (message) {
                    assert.include(message.payload.response, 'id');
                    client.disconnect();
                });
            },
        },
        "and I have a valid JWT, user ID, and username" : {
            "I can join my private user channel and receive a response with status 'ok'" : function () {
                const client = connect_and_create_guest();

                client.onMessage({topic: "guest", event: "phx_reply"}, function (message) {
                    client.jwt = message.payload.response.jwt;
                    client.user_id = message.payload.response.id;
                    client.username = message.payload.response.username;

                    client.onMessage({topic: "users:"+client.user_id, event: "phx_reply"}, function (join_user_channel_message) {
                        assert.equal(join_user_channel_message.payload.status, 'ok');
                        client.disconnect();
                    });
                    
                    client.join_channel({
                        channel_name: "users:"+client.user_id,
                        payload: {jwt: client.jwt, username: client.username}
                    });
                    
                });

            }
        },
        "and I join my user channel" : {
            "and send a message with event 'create_room'" : {
                'and the payload contains "is_publicly_searchable": false' : {
                    'I receive a response with status "ok"' : function () {
                        const client = connect_and_create_guest();

                        client.onMessage({topic: "guest", event: "phx_reply"}, function (message) {
                            client.jwt = message.payload.response.jwt;
                            client.user_id = message.payload.response.id;
                            client.username = message.payload.response.username;

                            const user_channel = "users:"+client.user_id;

                            client.onMessage({topic: user_channel, event: "create_room"}, function (create_room_message) {
                                assert.equal(create_room_message.payload.status, 'ok');
                                client.disconnect();
                            });
                             
                            create_room({
                                client: client,
                                room_title: "BanefulDomain",
                                room_subtitle: "just a hangout place",
                                is_publicly_searchable: false,
                                permissions: "must_be_invited"
                            });
                            
                        });
                    }
                },
                'and the payload contains "is_publicly_searchable": true' : {
                    'I receive a response with status "ok"' : function () {
                        const client = connect_and_create_guest();

                        client.onMessage({topic: "guest", event: "phx_reply"}, function (message) {
                            client.jwt = message.payload.response.jwt;
                            client.user_id = message.payload.response.id;
                            client.username = message.payload.response.username;

                            const user_channel = "users:"+client.user_id;

                            client.onMessage({topic: user_channel, event: "create_room"}, function (create_room_message) {
                                assert.equal(create_room_message.payload.status, 'ok');
                                client.disconnect();
                            });
                             
                            create_room({
                                client: client,
                                room_title: "BanefulDomain",
                                room_subtitle: "just a hangout place",
                                is_publicly_searchable: true,
                                permissions: "must_be_invited"
                            });
                            
                        });
                    }
                },
                'and the payload contains "permissions": "may_request_read_write_subscription"' : {
                    'I receive a response with status "ok"' : function () {
                        const client = connect_and_create_guest();

                        client.onMessage({topic: "guest", event: "phx_reply"}, function (message) {
                            client.jwt = message.payload.response.jwt;
                            client.user_id = message.payload.response.id;
                            client.username = message.payload.response.username;

                            const user_channel = "users:"+client.user_id;

                            client.onMessage({topic: user_channel, event: "create_room"}, function (create_room_message) {
                                assert.equal(create_room_message.payload.status, 'ok');
                                client.disconnect();
                            });
                             
                            create_room({
                                client: client,
                                room_title: "BanefulDomain",
                                room_subtitle: "just a hangout place",
                                is_publicly_searchable: true,
                                permissions: "may_request_read_write_subscription"
                            });
                            
                        });
                    }
                },
                'and the payload contains "permissions": "may_request_read_subscription"' : {
                    'I receive a response with status "ok"' : function () {
                        const client = connect_and_create_guest();

                        client.onMessage({topic: "guest", event: "phx_reply"}, function (message) {
                            client.jwt = message.payload.response.jwt;
                            client.user_id = message.payload.response.id;
                            client.username = message.payload.response.username;

                            const user_channel = "users:"+client.user_id;

                            client.onMessage({topic: user_channel, event: "create_room"}, function (create_room_message) {
                                assert.equal(create_room_message.payload.status, 'ok');
                                client.disconnect();
                            });
                             
                            create_room({
                                client: client,
                                room_title: "BanefulDomain",
                                room_subtitle: "just a hangout place",
                                is_publicly_searchable: true,
                                permissions: "may_request_read_subscription"
                            });
                            
                        });
                    }
                },
                'and the payload contains "permissions": "auto_grant_read_write_subscription"' : {
                    'I receive a response with status "ok"' : function () {
                        const client = connect_and_create_guest();

                        client.onMessage({topic: "guest", event: "phx_reply"}, function (message) {
                            client.jwt = message.payload.response.jwt;
                            client.user_id = message.payload.response.id;
                            client.username = message.payload.response.username;

                            const user_channel = "users:"+client.user_id;

                            client.onMessage({topic: user_channel, event: "create_room"}, function (create_room_message) {
                                assert.equal(create_room_message.payload.status, 'ok');
                                client.disconnect();
                            });
                             
                            create_room({
                                client: client,
                                room_title: "BanefulDomain",
                                room_subtitle: "just a hangout place",
                                is_publicly_searchable: true,
                                permissions: "auto_grant_read_write_subscription"
                            });
                            
                        });
                    }
                },
                'and the payload contains "permissions": "auto_grant_read_subscription"' : {
                    'I receive a response with status "ok"' : function () {
                        const client = connect_and_create_guest();

                        client.onMessage({topic: "guest", event: "phx_reply"}, function (message) {
                            client.jwt = message.payload.response.jwt;
                            client.user_id = message.payload.response.id;
                            client.username = message.payload.response.username;

                            const user_channel = "users:"+client.user_id;

                            client.onMessage({topic: user_channel, event: "create_room"}, function (create_room_message) {
                                assert.equal(create_room_message.payload.status, 'ok');
                                client.disconnect();
                            });
                             
                            create_room({
                                client: client,
                                room_title: "BanefulDomain",
                                room_subtitle: "just a hangout place",
                                is_publicly_searchable: true,
                                permissions: "auto_grant_read_subscription"
                            });
                            
                        });
                    }
                },
                'and the payload contains "permissions": "must_be_invited"' : {
                    'I receive a response with status "ok"' : function () {
                        const client = connect_and_create_guest();

                        client.onMessage({topic: "guest", event: "phx_reply"}, function (message) {
                            client.jwt = message.payload.response.jwt;
                            client.user_id = message.payload.response.id;
                            client.username = message.payload.response.username;

                            const user_channel = "users:"+client.user_id;

                            client.onMessage({topic: user_channel, event: "create_room"}, function (create_room_message) {
                                assert.equal(create_room_message.payload.status, 'ok');
                                client.disconnect();
                            });
                             
                            create_room({
                                client: client,
                                room_title: "BanefulDomain",
                                room_subtitle: "just a hangout place",
                                is_publicly_searchable: true,
                                permissions: "must_be_invited"
                            });
                            
                        });
                    }
                },
                'and the payload contains "room_title": "insert any room title here"' : {
                    'I receive a response with status "ok"' : function () {
                        const client = connect_and_create_guest();

                        client.onMessage({topic: "guest", event: "phx_reply"}, function (message) {
                            client.jwt = message.payload.response.jwt;
                            client.user_id = message.payload.response.id;
                            client.username = message.payload.response.username;

                            const user_channel = "users:"+client.user_id;

                            client.onMessage({topic: user_channel, event: "create_room"}, function (create_room_message) {
                                assert.equal(create_room_message.payload.status, 'ok');
                                client.disconnect();
                            });
                             
                            create_room({
                                client: client,
                                room_title: "insert any room title here",
                                room_subtitle: "just a hangout place",
                                is_publicly_searchable: true,
                                permissions: "must_be_invited"
                            });
                            
                        });
                    }
                },
                'and the payload contains "room_subtitle": "insert any room subtitle here"' : {
                    'I receive a response with status "ok"' : function () {
                        const client = connect_and_create_guest();

                        client.onMessage({topic: "guest", event: "phx_reply"}, function (message) {
                            client.jwt = message.payload.response.jwt;
                            client.user_id = message.payload.response.id;
                            client.username = message.payload.response.username;

                            const user_channel = "users:"+client.user_id;

                            client.onMessage({topic: user_channel, event: "create_room"}, function (create_room_message) {
                                assert.equal(create_room_message.payload.status, 'ok');
                                client.disconnect();
                            });
                             
                            create_room({
                                client: client,
                                room_title: "BanefulDomain",
                                room_subtitle: "insert any room subtitle here",
                                is_publicly_searchable: true,
                                permissions: "must_be_invited"
                            });
                            
                        });
                    }
                },
                'and the payload has a different "is_publicly_searchable" field' : {
                    'I receive a response with status "error: invalid is_publicly_searchable"' : function () {
                        const client = connect_and_create_guest();

                        client.onMessage({topic: "guest", event: "phx_reply"}, function (message) {
                            client.jwt = message.payload.response.jwt;
                            client.user_id = message.payload.response.id;
                            client.username = message.payload.response.username;

                            const user_channel = "users:"+client.user_id;

                            client.onMessage({topic: user_channel, event: "create_room"}, function (create_room_message) {
                                assert.equal(create_room_message.payload.status, 'error: invalid is_publicly_searchable');
                                client.disconnect();
                            });
                             
                            create_room({
                                client: client,
                                room_title: "BanefulDomain",
                                room_subtitle: "just a hangout place",
                                is_publicly_searchable: "maybe",
                                permissions: "must_be_invited"
                            });
                            
                        });
                    }
                },
                'and the payload has a different "permissions" field' : {
                    'I receive a response with status "error: invalid permissions"' : function () {
                        const client = connect_and_create_guest();

                        client.onMessage({topic: "guest", event: "phx_reply"}, function (message) {
                            client.jwt = message.payload.response.jwt;
                            client.user_id = message.payload.response.id;
                            client.username = message.payload.response.username;

                            const user_channel = "users:"+client.user_id;

                            client.onMessage({topic: user_channel, event: "create_room"}, function (create_room_message) {
                                assert.equal(create_room_message.payload.status, 'error: invalid permissions');
                                client.disconnect();
                            });
                             
                            create_room({
                                client: client,
                                room_title: "BanefulDomain",
                                room_subtitle: "just a hangout place",
                                is_publicly_searchable: true,
                                permissions: "do whatever!"
                            });
                            
                        });
                    }
                },
                'and the "room_title" field in the payload is an empty string' : {
                    'I receive a response with status "error: room_title must not be empty""' : function () {
                        const client = connect_and_create_guest();

                        client.onMessage({topic: "guest", event: "phx_reply"}, function (message) {
                            client.jwt = message.payload.response.jwt;
                            client.user_id = message.payload.response.id;
                            client.username = message.payload.response.username;

                            const user_channel = "users:"+client.user_id;

                            client.onMessage({topic: user_channel, event: "create_room"}, function (create_room_message) {
                                assert.equal(create_room_message.payload.status, 'error: room_title must not be empty');
                                client.disconnect();
                            });
                             
                            create_room({
                                client: client,
                                room_title: "",
                                room_subtitle: "just a hangout place",
                                is_publicly_searchable: true,
                                permissions: "must_be_invited"
                            });
                            
                        });
                    }
                },
                'and the "room_subtitle" field in the payload is an empty string' : {
                    'I receive a response with status "error: room_subtitle must not be empty"' : function () {
                        const client = connect_and_create_guest();

                        client.onMessage({topic: "guest", event: "phx_reply"}, function (message) {
                            client.jwt = message.payload.response.jwt;
                            client.user_id = message.payload.response.id;
                            client.username = message.payload.response.username;

                            const user_channel = "users:"+client.user_id;

                            client.onMessage({topic: user_channel, event: "create_room"}, function (create_room_message) {
                                assert.equal(create_room_message.payload.status, 'error: room_subtitle must not be empty');
                                client.disconnect();
                            });
                             
                            create_room({
                                client: client,
                                room_title: "BanefulDomain",
                                room_subtitle: "",
                                is_publicly_searchable: true,
                                permissions: "must_be_invited"
                            });
                            
                        });
                    }
                },
                'and receive a status "ok"' : {
                    'I also receive a room id' : function () {
                        const client = connect_and_create_guest();

                        client.onMessage({topic: "guest", event: "phx_reply"}, function (message) {
                            client.jwt = message.payload.response.jwt;
                            client.user_id = message.payload.response.id;
                            client.username = message.payload.response.username;

                            const user_channel = "users:"+client.user_id;

                            client.onMessage({topic: user_channel, event: "create_room"}, function (create_room_message) {
                                assert.include(create_room_message.payload.response, 'room_id');
                                client.disconnect();
                            });
                             
                            create_room({
                                client: client,
                                room_title: "BanefulDomain",
                                room_subtitle: "just a hangout place",
                                is_publicly_searchable: true,
                                permissions: "must_be_invited"
                            });
                            
                        });
                    }
                }
            },
            // 'and send a message with event "find_users_and_channels' : {
            //     'and the payload contains "query": "<insert any search query here>"' : {
            //         'I received a sorted list of users and channels most relevant to my search query' : function () {
            //             flunk()
            //         }
            //     },
            //     'and the payload contains "query": null' : {
            //         'I received a sorted list of most popular users and channels' : function () {
            //             flunk()
            //         }
            //     }
            // }
        },
        "and I join a room channel" : {
            'and the payload contains "room_id": <some room id>, ' : {
                // 'I receive a response with "status": "ok"' : function () {
                //     var ws = new WebSocket(url);
                //     ws.on('open', function open() {
                //         client.join_channel("guest", {}, ws)
                //     });

                //     var id = ""
                //     var jwt = ""
                //     var username = ""

                //     ws.onmessage = function(in_message) {
                //         const data = JSON.parse(in_message.data);
                //         if (data.topic === 'guest') {
                //             id = data.payload.response.id;
                //             jwt = data.payload.response.jwt;
                //             username = data.payload.response.username;
                //             client.join_user_channel(id, jwt, username, ws);
                //         }
                //         else if ((data.topic === ('users:'+id)) && (data.event === 'phx_reply')) { 
                //             client.create_room({
                //                 user_id: id,
                //                 room_title: "BanefulDomain",
                //                 room_subtitle: "insert any room subtitle here",
                //                 is_publicly_searchable: true,
                //                 permissions: "may_request_read_write_subscription"
                //             }, ws);
                //         }
                //         else if ((data.topic === ('users:'+id)) && (data.event === 'create_room')) { 
                //             // assert.equal(data.payload.status, "ok")
                //             // ws.close()
                //         }

                //         else if ((data.topic === ('rooms:'+room_id)) && (data.event === 'phx_reply')) { 
                //             assert.equal(data.payload.status, "ok")
                //             ws.close()
                //         }

                //     }
                // }
            },
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

function connect_and_create_guest() {
    const client = new Client();
    client.onConnect(function () {
        client.join_channel({channel_name: "guest", payload: {}});
    });
    return client;
}

function create_room({
        client,
        room_title,
        room_subtitle,
        is_publicly_searchable,
        permissions}) {

    const user_channel = "users:"+client.user_id;

    client.onMessage({topic: user_channel, event: "phx_reply"}, function (join_user_channel_message) {
        client.create_room({
            room_title: room_title,
            room_subtitle: room_subtitle,
            is_publicly_searchable: is_publicly_searchable,
            permissions: permissions
        });
    });

    client.join_channel({
        channel_name: user_channel,
        payload: {jwt: client.jwt, username: client.username}
    });

};

function flunk() {
    assert.isTrue(false)
}
