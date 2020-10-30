'use strict';

const express = require('express');
const axios = require('axios');

const app = express();

app.get('*', function (req, res) {
	const n = req.query ? req.query.n : 1
	axios.get('http://back-app?n=' + n)
	  .then(response => {
		res.send(response.data);
	  })
	  .catch(error => {
		res.status(500).send(JSON.stringify(error));
	  });
});

app.listen(80);