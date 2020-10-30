'use strict';

const express = require('express');

const app = express();

app.get('*', function (req, res) {
	const n = req.query ? req.query.n : 1
	res.send(JSON.stringify({
		n: n*n,
		baseurl: req.baseUrl,
		originalUrl: req.originalUrl,
		hostname: req.hostname,
		headers: req.headers
	}));
});

app.listen(80);