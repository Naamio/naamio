///<reference path="../../typings/index.d.ts"/>

'use strict';

import * as express from "express";

const router = express.Router();

/**
 * Retrieves the landing page for the app.
 * @version 0.2.0
 * @param {express.Request} req Request object.
 * @param {express.Response} res Response object.
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

/**
 * Retrieves the about page for the app.
 * @version 0.2.0
 * @param {express.Request} req Request object.
 * @param {express.Response} res Response object.
 */
const getAbout = (req: express.Request, res: express.Response) => {

  res.render('about', {
    title: 'About Us',
    header: true,
    footer: true
  });
};

/**
 * Retrieves the contact page for the app.
 * @version 0.2.0
 * @param {express.Request} req Request object.
 * @param {express.Response} res Response object.
 */
const getContact = (req: express.Request, res: express.Response) => {

  res.render('contact', {
    title: 'Contact Us',
    header: true,
    footer: true
  });
};

router.get('/', getLanding);
router.get('/about', getAbout);
router.get('/contact', getContact);

export = router;