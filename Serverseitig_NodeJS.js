const express = require('express');
const app = express();
const path = require('path');
app.use(express.static('public'));

app.get('/', (req, res) => {
	res.send(":D")
});

app.get('/licht/', (req, res) => {
	res.send('');
	console.log(req.query);
	var dgram = require('dgram');
	var s = dgram.createSocket('udp4');
	s.send(Buffer.from("modus="+ req.query.modus +"&color="+ req.query.color), 2390, req.query.ip);
});
 
app.get('/licht/all/', (req, res) => {
	res.send("")
	var dgram = require('dgram');
	var s = dgram.createSocket('udp4');
	if (req.query.room == "1"){
		if (req.query.state == "0"){
			s.send(Buffer.from("modus=rgb&color=0:0:0"), 2390, '192.168.178.25');
			s.send(Buffer.from("modus=rgb&color=0:0:0"), 2390, '192.168.178.24');
			s.send(Buffer.from("modus=rgb&color=0:0:0"), 2390, '192.168.178.28');
			s.send(Buffer.from("modus=rgb&color=0:0:0"), 2390, '192.168.178.29');
		}
	}
	if (req.query.room == "2"){
		if (req.query.state == "0"){
			s.send(Buffer.from("modus=rgb&color=0:0:0"), 2390, '192.168.178.52');
			s.send(Buffer.from("modus=rgb&color=0:0:0"), 2390, '192.168.178.53');
		}
	}
});


app.listen(80, () => console.log('http://localhost:80/'));
