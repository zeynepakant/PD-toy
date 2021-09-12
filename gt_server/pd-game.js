class PdGame {
    constructor(p1, p2) {
        this._players = [p1, p2];
        this._turns = [null, null];
        this._sendToPlayers("Prisoner's Dilemma starts!");
        this._players.forEach((player, idx) => {
            player.on('turn', (turn) => {
                this._onTurn(idx, turn);
            });
        });
    }

    _sendToPlayer(playerIndex, msg) {
        this._players[playerIndex].emit('message', msg);
    }

    _sendToPlayers(msg) {
        this._players.forEach((player) =>  {
            player.emit('message', msg);
        });
    }

    _onTurn(playerIndex, turn) {
        this._turns[playerIndex] = turn;
        this._sendToPlayer(playerIndex, `You have chosen to ${turn}!`);
        this._checkGameOver();
    }

    _checkGameOver() {
        const turns = this._turns;
        if (turns[0] && turns[1]) {
            this._sendToPlayers('Game over! ' + turns.join(' : '));
            this._getGameResult();
            this._turns = [null, null];
            this._sendToPlayers('Next round!');
        }
    }

    _getGameResult() {
        switch (this._turns[0]) {
            case 'Cooperate':
                switch (this._turns[1]) {
                    case 'Cooperate':
                        this._players[0].emit('message', 'You are going to serve 1 year in prison.');
                        this._players[1].emit('message', 'You are going to serve 1 year in prison.');
                        return;
                    case 'Defect':
                        this._players[0].emit('message', 'You are going to serve 4 years in prison.');
                        this._players[1].emit('message', 'You are free.');
                        return;
                }
            case 'Defect':
                switch (this._turns[1]) {
                    case 'Cooperate':
                        this._players[0].emit('message', 'You are free.');
                        this._players[1].emit('message', 'You are going to serve 4 years in prison.');
                        return;
                    case 'Defect':
                        this._players[0].emit('message', 'You are going to serve 3 years in prison.');
                        this._players[1].emit('message', 'You are going to serve 3 years in prison.');
                        return;
                }
        }
    }
}
module.exports = PdGame;
