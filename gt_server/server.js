const express = require('express');
const app = express();
const server = require('http').createServer(app);
const io = require('socket.io')(server);
const PdGame = require('./pd-game');
let waitingPlayer = null;

io.on('connection', (sock) =>  {
    console.log('Someone connected');

    if(waitingPlayer) {
        let pdGame = new PdGame(waitingPlayer, sock);
        waitingPlayer = null;
    } else {
        waitingPlayer = sock;
        waitingPlayer.emit('message', 'Waiting for an opponent');
    }

    sock.on('message', (text) => {
        io.emit('message', text);
    });
});

var listen_port = process.env.PORT || 3000;
server.listen(listen_port, () => {
    console.log('Listening on ' + listen_port);
});

server.on('error', (err) => {
    console.error('Server error: ', err);
});
