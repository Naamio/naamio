///<reference path="../../typings/index.d.ts"/>

'use strict';

import * as express from "express";

const router = express.Router();

/**
 * Retrieves the landing page for the app.
 * @version 0.2.0
 * @param {express.Request} req Request object.
 * @param {express.Request} res Response object.
 */
const getLanding = (req: express.Request, res: express.Response) => {
  if (typeof (<any>req).user == 'undefined') {
    (<any>req).user = false;
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