///<reference path="../../typings/index.d.ts"/>

'use strict';

import * as express from "express";

const router = express.Router();

/**
 * # getLanding
 * 
 * Retrieves the landing page for the app.
 * 
 * @param: req Request object.
 * @param: res Response object.
 */
const getLanding = (req, res) => {
  if (typeof req.user == 'undefined') {
    req.user = false;
  }

  res.render('home', {
    bodyClass: 'home',
    title: 'Omnijar Studio',
    header: true,
    footer: true
  });
};

router.get('/', getLanding);

export = router;